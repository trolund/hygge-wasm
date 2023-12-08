module hyggec.WASMCodegen

open AST
open Type
open Typechecker
open WGF.Module
open WGF.Types
open WGF.Utils
open WGF.Instr
open System.Text
open SI
open Config

// static values
let errorExitCode = 42
let successExitCode = 0
let mainFunctionName = "_start"
let heapBase = "heap_base"
let exitCode = "exit_code"

/// Storage information for variables.
[<RequireQualifiedAccess; StructuralComparison; StructuralEquality>]
type internal Storage =
    /// local variable
    | Local of label: string
    /// global variable
    | Global of label: string
    /// offset in as indecies of element in structure
    | Offset of offset: int

/// A memory allocator that allocates memory in pages of 64KB.
/// The allocator keeps track of the current allocation position.
type internal StaticMemoryAllocator() =

    let mutable allocationPosition = 0
    let pageSize = 64 * 1024 // 64KB

    // list of allocated memory
    let mutable allocatedMemory: List<int * int> = []

    // get head of allocated memory list
    member this.GetAllocated() = allocatedMemory.Head

    // get number of pages needed to allocate size bytes
    member this.GetNumPages() =
        let neededPages = int (ceil (float allocationPosition / float pageSize))

        // in case of 0 pages i needed for static data allways have 1 page for dynamic data
        if neededPages = 0 then 1 else neededPages

    /// function that call the dynamic allocator with the number of bytes needed and return the start position
    /// Allocate in linear memory a block of 'size' bytes.
    /// will return the start position and size of the allocated memory
    member this.Allocate(size: int) =
        if size < 0 then
            failwith "Size must be positive or zero"

        let startPosition = allocationPosition

        // added to allocated memory
        allocatedMemory <- (startPosition, size) :: allocatedMemory

        allocationPosition <- allocationPosition + size
        startPosition

    member this.GetAllocationPosition() = allocationPosition

/// A table controller that keeps track of the current position in the table.
type internal TableController() =

    let mutable allocationPosition = 0

    /// get the next free index in the table
    member this.next() =
        let startPosition = allocationPosition
        allocationPosition <- allocationPosition + 1
        startPosition

    member this.reset() = allocationPosition <- 0

    member this.get() = allocationPosition

type internal SymbolController() =

    /// Set of known uniquely-generated symbols.  It must be locked before being
    /// used, to avoid errors if multiple threads attempt to generate unique symbols
    /// at the same time.
    let mutable knownSyms = System.Collections.Generic.HashSet<string>()
    let mutable knownSymsWithIds = System.Collections.Generic.List<string>()

    /// Internal counter used to generate suffixes for unique symbols.  This counter
    /// should only be used after locking 'knownSyms' above.
    let mutable nextSymSuffix: uint = 0u

    member this.genSymbol(prefix: string) : string =
        if knownSyms.Add(prefix) then
            prefix
        else
            let sym = $"%s{prefix}$%d{nextSymSuffix}"
            nextSymSuffix <- nextSymSuffix + 1u
            knownSyms.Add(sym) |> ignore
            sym

    member this.genSymbolId(symbol: string) : int =
        let id = knownSymsWithIds.IndexOf(symbol)

        if (id = -1) then
            knownSymsWithIds.Add(symbol)
            knownSymsWithIds.Count
        else
            // We return the symbol position in 'knownSymsWithIds' as unique id
            id + 1

/// code that is executed when an error occurs
let trap =
    [ (GlobalSet(Named("exit_code"), [ (I32Const errorExitCode, "error exit code push to stack") ]), "set exit code")
      (Unreachable, "exit program") ]

/// check if memory is big enough to allocate size bytes
/// if not allocate more memory
/// return the start position of the allocated memory
let checkMemory (size: Commented<Wasm> list) : Commented<Wasm> list =
    [ (If(
          [],
          [ (I32GeS(
                [ (I32Add([ (GlobalGet(Named(heapBase)), "get heap base") ] @ size), "find size need to allocate")
                  (I32Mul([ (MemorySize, "memory size"); (I32Const 65536, "page size") ]), "find current size") ]
             ),
             "size need > current size") ],
          [ (Drop(
                [ (MemoryGrow(
                      [ (I32DivS(
                            [ (I32Add([ (GlobalGet(Named(heapBase)), "get heap base") ] @ size),
                               "find size need to allocate")
                              (I32Const 65536, "page size") ]
                         ),
                         "grow memory!") ]
                   ),
                   "grow memory if needed") ]
             ),
             "drop new size") ],
          None
       ),
       "grow memory if needed") ]

type internal CodegenEnv =
    { CurrFunc: string
      MemoryAllocator: StaticMemoryAllocator
      TableController: TableController
      SymbolController: SymbolController
      VarStorage: Map<string, Storage>
      Config: Config.CompileConfig }

let internal createFunctionPointer (name: string) (env: CodegenEnv) (m: Module) : Module * int * string =
    let ptr_label = $"{name}*ptr"

    // get the index of the function
    let funcindex = env.TableController.next ()

    // allocate memory for function pointer
    let memoryAddress = env.MemoryAllocator.Allocate(4)

    let FunctionPointer =
        m
            .AddFuncRefElement(name, funcindex) // add function to function table
            .AddData((I32Const memoryAddress, ""), Util.intToHex funcindex) // index as hex string
            .AddGlobal((ptr_label, (I32, Mutable), (I32Const memoryAddress, "")))

    // return compontents needed to create a function pointer
    (FunctionPointer, funcindex, ptr_label)


// map a hygge type to a wasm type
// TODO: add env to function
let mapType t =
    match t with
    | TUnit -> []
    | TInt -> [ I32 ]
    | TFloat -> [ F32 ]
    | TBool -> [ I32 ]
    | TString -> [ I32 ]
    | TStruct _ -> [ I32 ] // return ref type when in heap mode
    | TUnion _ -> [ I32 ]
    | TArray _ -> [ I32 ]
    | TFun _ -> [ I32 ] // passing function as a index to function table
    | TVar _ -> [ I32 ]
    | TAny -> [ EqRef ]

let funcp = GenStructTypeIDType [ ("func", (I32)); ("cenv", (EqRef)) ]

let rec mapTypeHeap (t: Type) =
    match t with
    | TStruct l ->
        let fieldTypes = List.map (fun (n, t) -> (n, mapTypeHeap t)) l
        Ref(Named(GenStructTypeIDType fieldTypes))
    | TArray t -> mapTypeHeap t
    | TFun _ -> Ref(Named(funcp)) 
    | _ -> (mapType t)[0]

let findBestMatchType (m: Module) (fields: List<string * Type>) =

    // Tjek for ecsakt match

    let structTypes =
        List.fold
            (fun acc (t) ->
                match t with
                | StructType(id, params) -> (id, params) :: acc
                | _ -> acc)
            []
            (m.GetTypes())

    let typeParams: Param list =
        List.map (fun (name, t) -> (Some(name), ((mapType t)[0], Mutable))) fields

    // count number of matching types
    let maches =
        List.fold
            (fun acc (currId, currParams) ->
                // find number of matching types between currParams and fields
                // let matches = List.map2 (fun a b ->  a = b ) currParams typeParams
                // let numberOfMatches = List.sum (List.map (fun x -> if x then 1 else 0) matches)
                let numberOfMatches =
                    List.length (List.filter (fun x -> List.exists (fun y -> x = y) currParams) typeParams)

                (currId, numberOfMatches) :: acc)
            []
            structTypes

    let bestMatch = List.maxBy snd maches

    fst bestMatch



// look up variable in var env
// TODO: remove this function
let internal lookupVar (env: CodegenEnv) (e: TypedAST) =
    match e.Expr with
    | Var v ->
        match env.VarStorage.TryFind v with
        | Some(Storage.Local l) -> Named(l)
        | Some(Storage.Global l) -> Named(l)
        | Some(Storage.Offset(o)) -> Index(o)
        | _ -> failwith "not implemented"
    | FieldSelect(e, f) ->
        match e.Expr with
        | Var v ->
            match env.VarStorage.TryFind v with
            | Some(Storage.Local l) -> Named(l)
            | Some(Storage.Global l) -> Named(l)
            | Some(Storage.Offset(o)) -> Index(o)
            | _ -> failwith "not implemented"
    | _ -> failwith "not implemented"

/// look up variable in var env
let internal lookupLabel (env: CodegenEnv) (name: string) =
    match env.VarStorage.TryFind name with
    | Some(Storage.Local l) -> l
    | Some(Storage.Global l) -> l
    | _ -> failwith "not implemented"

let internal lookupLatestLocal (m: Module) =
    match List.last (m.GetLocals()) with
    | Some(n), _ -> n
    | None, _ -> failwith "failed to find name of the lastest local var"

let internal lookupLatestType (m: Module) =
    let types = m.GetTypes()

    match List.last types with
    | v -> v
    | _ -> failwith "failed to find name of the lastest local var"


let internal argsToLocals env args =
    if env.Config.AllocationStrategy = Heap then
        List.map (fun (n, t) -> (Some(lookupLabel env n), (mapTypeHeap t))) args
    else
        List.map (fun (n, t) -> (Some(lookupLabel env n), (mapType t)[0])) args

let internal addCapturedToEnv env captured =
    List.fold
        (fun env (index, n) ->
            { env with
                VarStorage = env.VarStorage.Add(n, Storage.Offset(index)) })
        env
        (List.indexed captured)

let internal localsToID (locals: Local list) =
    (List.map
        (fun (n, _) ->
            match n with
            | Some(n) -> n
            | None -> failwith "not implemented")
        locals)

/// add each arg to var storage (all local vars)
let internal addArgsToEnv env args =
    List.fold
        (fun env (n, _) ->
            let l = env.SymbolController.genSymbol $"arg_{n}"

            { env with
                VarStorage = env.VarStorage.Add(n, Storage.Local l) })
        env
        args

let internal isTopLevel env = env.CurrFunc = mainFunctionName

let rec internal doCodegen (env: CodegenEnv) (node: TypedAST) (m: Module) : Module =
    match node.Expr with
    | UnitVal -> m
    | IntVal i -> m.AddCode([ (I32Const i, $"push %i{i} on stack") ])
    | BoolVal b ->
        let v = if b then 1 else 0
        let s = if v = 1 then "true" else "false"
        m.AddCode([ (I32Const(v), $"push %s{s} on stack") ])
    | FloatVal f -> m.AddCode([ (F32Const f, $"push %f{f} on stack") ])
    | StringVal s ->
        // allocate for struct like structure
        let ptr = env.MemoryAllocator.Allocate(3 * 4)

        // compute size of string in bytes
        let utf8Encoder = Encoding.UTF8
        let utf8Bytes = utf8Encoder.GetBytes(s)
        let stringSizeInBytes = utf8Bytes.Length

        // allocate string in memory
        let daraPtr = env.MemoryAllocator.Allocate(stringSizeInBytes)

        // store data pointer and length in struct like structure
        let dataString = Util.dataString [ daraPtr; stringSizeInBytes; s.Length ]

        m
            .AddData((I32Const(daraPtr), ""), s) // store the string it self in memory
            .AddData((I32Const(ptr), ""), dataString) // store pointer an length in memory
            .AddCode([ (I32Const(ptr), "leave pointer to string on stack") ])
    | StringLength e ->
        let m' = doCodegen env e m

        let instrs = [ (I32Load_(None, Some(8), m'.GetAccCode()), "load string length") ]

        m'.ResetAccCode().AddCode(instrs)
    | Neg({ Node.Expr = IntVal(v)
            Node.Type = TInt }) -> m.AddCode([ (I32Const(-v), $"push %i{-v} on stack") ])
    | Neg({ Node.Expr = FloatVal(v)
            Node.Type = TFloat }) -> m.AddCode([ (F32Const(-v), $"push %f{-v} on stack") ])
    | Neg(e) ->
        let m' = doCodegen env e m

        let instrs =
            match (expandType e.Env e.Type) with
            | t when (isSubtypeOf e.Env t TInt) ->
                [ (I32Mul(m'.GetAccCode() @ [ (I32Const(-1), "push -1 on stack") ]), "multiply with -1") ]
            | t when (isSubtypeOf e.Env t TFloat) ->
                [ (F32Mul(m'.GetAccCode() @ [ (F32Const(-1.0f), "push -1.0 on stack") ]), "multiply with -1.0") ]
            | _ -> failwith "negation of type not implemented"

        m'.ResetAccCode().AddCode(instrs)
    | Var v ->
        // load variable
        let instrs: List<Commented<WGF.Instr.Wasm>> =
            match env.VarStorage.TryFind v with
            | Some(Storage.Local l) -> [ (LocalGet(Named(l)), $"get local var: {l}") ] // push local variable on stack
            | Some(Storage.Global l) -> [ (GlobalGet(Named(l)), $"get global var: {l}") ] // push global variable on stack
            | Some(Storage.Offset(i)) -> // push variable from offset on stack
                // get load instruction based on type
                let li: WGF.Instr.Wasm =
                    match (expandType node.Env node.Type) with
                    | t when (isSubtypeOf node.Env t TBool) ->
                        I32Load_(None, Some(i * 4), [ (LocalGet(Index(0)), "get env pointer") ])
                    | t when (isSubtypeOf node.Env t TInt) ->
                        I32Load_(None, Some(i * 4), [ (LocalGet(Index(0)), "get env pointer") ])
                    | t when (isSubtypeOf node.Env t TFloat) ->
                        F32Load_(None, Some(i * 4), [ (LocalGet(Index(0)), "get env pointer") ])
                    | t when (isSubtypeOf node.Env t TString) ->
                        I32Load_(None, Some(i * 4), [ (LocalGet(Index(0)), "get env pointer") ])
                    | _ -> I32Load_(None, Some(i * 4), [ (LocalGet(Index(0)), "get env pointer") ])

                [ (li, $"load value at offset: {i * 4}") ]
            | _ -> failwith "could not find variable in var storage"

        m.AddCode(instrs)
    | PreIncr(e) ->
        let instrs =
            match (expandType e.Env e.Type) with
            | t when (isSubtypeOf e.Env t TInt) ->
                let assignode =
                    { node with
                        Expr =
                            Assign(
                                e,
                                { node with
                                    Expr = Add(e, { node with Expr = IntVal 1 }) }
                            ) }

                (doCodegen env assignode m)
            | t when (isSubtypeOf e.Env t TFloat) ->
                let assignode =
                    { node with
                        Expr =
                            Assign(
                                e,
                                { node with
                                    Expr = Add(e, { node with Expr = FloatVal 1.0f }) }
                            ) }

                (doCodegen env assignode m)
            | _ -> failwith "not implemented"

        instrs
    | PostIncr(e) ->
        let instrs =
            match (expandType e.Env e.Type) with
            | t when (isSubtypeOf e.Env t TInt) ->
                let assignode =
                    { node with
                        Expr =
                            Assign(
                                e,
                                { node with
                                    Expr = Add(e, { node with Expr = IntVal 1 }) }
                            ) }

                (doCodegen env e m) + (doCodegen env assignode m)
            | t when (isSubtypeOf e.Env t TFloat) ->
                let assignode =
                    { node with
                        Expr =
                            Assign(
                                e,
                                { node with
                                    Expr = Add(e, { node with Expr = FloatVal 1.0f }) }
                            ) }

                (doCodegen env e m) + (doCodegen env assignode m)
            | _ -> failwith "not implemented"

        instrs.ResetAccCode().AddCode([ Drop(instrs.GetAccCode()) ])
    | PreDcr(e) ->
        let valNode =
            match (expandType e.Env e.Type) with
            | t when (isSubtypeOf e.Env t TInt) -> { node with Expr = IntVal 1 }
            | t when (isSubtypeOf e.Env t TFloat) -> { node with Expr = FloatVal 1.0f }
            | _ -> failwith "not implemented"

        let assignode =
            { node with
                Expr = Assign(e, { node with Expr = Sub(e, valNode) }) }

        (doCodegen env assignode m)
    | PostDcr(e) ->
        let valNode =
            match (expandType e.Env e.Type) with
            | t when (isSubtypeOf e.Env t TInt) -> { node with Expr = IntVal 1 }
            | t when (isSubtypeOf e.Env t TFloat) -> { node with Expr = FloatVal 1.0f }
            | _ -> failwith "not implemented"

        let assignode =
            { node with
                Expr = Assign(e, { node with Expr = Sub(e, valNode) }) }

        let assignModule = (doCodegen env assignode m)

        ((doCodegen env e m) + assignModule.ResetAccCode())
            .AddCode([ Drop(assignModule.GetAccCode()) ])
    | MinAsg(lhs, rhs) ->
        doCodegen
            env
            { node with
                Expr = Assign(lhs, { node with Expr = Sub(lhs, rhs) }) }
            m
    | DivAsg(lhs, rhs) ->
        doCodegen
            env
            { node with
                Expr = Assign(lhs, { node with Expr = Div(lhs, rhs) }) }
            m
    | MulAsg(lhs, rhs) ->
        doCodegen
            env
            { node with
                Expr = Assign(lhs, { node with Expr = Mult(lhs, rhs) }) }
            m
    | RemAsg(lhs, rhs) ->
        doCodegen
            env
            { node with
                Expr = Assign(lhs, { node with Expr = Rem(lhs, rhs) }) }
            m
    | AddAsg(lhs, rhs) ->
        doCodegen
            env
            { node with
                Expr = Assign(lhs, { node with Expr = Add(lhs, rhs) }) }
            m
    | Max(e1, e2)
    | Min(e1, e2) ->
        let m' = doCodegen env e1 m
        let m'' = doCodegen env e2 m

        let instrs =
            match (expandType node.Env node.Type) with
            | t when (isSubtypeOf node.Env t TFloat) ->
                match node.Expr with
                | Max _ -> C [ F32Max ]
                | Min _ -> C [ F32Min ]
                | _ -> failwith "not implemented"
            | t when (isSubtypeOf node.Env t TInt) ->
                match node.Expr with
                | Max _ -> C [ I32GtS(m'.GetAccCode() @ m''.GetAccCode()); Select ]
                | Min _ -> C [ I32LtS(m'.GetAccCode() @ m''.GetAccCode()); Select ]
                | _ -> failwith "not implemented"
            | _ -> failwith "failed type of max/min"

        (m' + m'').AddCode(instrs)
    | Sqrt e ->
        let m' = doCodegen env e m
        let instrs = m'.GetAccCode() @ C [ F32Sqrt ]
        m'.ResetAccCode().AddCode(instrs)
    | Add(lhs, rhs)
    | Sub(lhs, rhs)
    | Rem(lhs, rhs)
    | Div(lhs, rhs)
    | And(lhs, rhs)
    | Or(lhs, rhs)
    | Xor(lhs, rhs)
    | Mult(lhs, rhs) as expr ->
        let lhs' = doCodegen env lhs m
        let rhs' = doCodegen env rhs m

        let opCode =
            match (expandType node.Env node.Type) with
            | t when (isSubtypeOf node.Env t TInt) ->
                match expr with
                | Add _ -> I32Add
                | Sub _ -> I32Sub
                | Rem _ -> I32RemS
                | Div _ -> I32DivS
                | Mult _ -> I32Mul
                | _ -> failwith "failed to find numeric int operation"
            | t when (isSubtypeOf node.Env t TFloat) ->
                match expr with
                | Add _ -> F32Add
                | Sub _ -> F32Sub
                | Div _ -> F32Div
                | Mult _ -> F32Mul
                | _ -> failwith "failed to find numeric float operation"
            | t when (isSubtypeOf node.Env t TBool) ->
                match expr with
                | And _ -> I32And
                | Or _ -> I32Or
                | Xor _ -> I32Xor
            | _ -> failwith "failed to find numeric operation"

        (lhs'.ResetAccCode() + rhs'.ResetAccCode())
            .AddCode([ opCode (lhs'.GetAccCode() @ rhs'.GetAccCode()) ])
    // short circuit and
    | ShortAnd(lhs, rhs) ->
        doCodegen
            env
            { node with
                Expr = AST.If(lhs, rhs, { node with Expr = IntVal 0 }) }
            m
    // short circuit or
    | ShortOr(lhs, rhs) ->
        doCodegen
            env
            { node with
                Expr = AST.If(lhs, { node with Expr = IntVal 1 }, rhs) }
            m
    | Not(e) ->
        let m' = doCodegen env e m
        m'.ResetAccCode().AddCode([ I32Eqz(m'.GetAccCode()) ])
    | Greater(e1, e2) ->
        let m' = doCodegen env e1 m
        let m'' = doCodegen env e2 m

        // find type of e1 and e2 and check if they are equal
        let opcode =
            match (expandType e1.Env e1.Type) with
            | t1 when (isSubtypeOf e1.Env t1 TInt) -> I32GtS
            | t1 when (isSubtypeOf e1.Env t1 TFloat) -> F32Gt
            | t1 when (isSubtypeOf e1.Env t1 TBool) -> I32GtS
            | _ -> failwith "type mismatch"

        (m'.ResetAccCode() + m''.ResetAccCode())
            .AddCode([ (opcode (m'.GetAccCode() @ m''.GetAccCode()), "") ])
    | AST.Eq(lhs, rhs) ->
        let m' = doCodegen env lhs m
        let m'' = doCodegen env rhs m

        // find type of e1 and e2 and check if they are equal
        let opcode =
            match (expandType lhs.Env lhs.Type) with
            | t1 when (isSubtypeOf lhs.Env t1 TInt) -> I32Eq
            | t1 when (isSubtypeOf lhs.Env t1 TFloat) -> F32Eq
            | t1 when (isSubtypeOf lhs.Env t1 TBool) -> I32Eq
            | _ -> failwith "type mismatch"

        let instrs = [ (opcode (m'.GetAccCode() @ m''.GetAccCode()), "equality check") ]
        (m + m'.ResetAccCode() + m''.ResetAccCode()).AddCode(instrs)
    | Less(lhs, rhs) ->
        let m' = doCodegen env lhs m
        let m'' = doCodegen env rhs m

        // find type of e1 and e2 and check if they are equal
        let opcode =
            match (expandType lhs.Env lhs.Type) with
            | t1 when (isSubtypeOf lhs.Env t1 TInt) -> I32LtS
            | t1 when (isSubtypeOf lhs.Env t1 TFloat) -> F32Lt
            | t1 when (isSubtypeOf lhs.Env t1 TBool) -> I32LtS
            | _ -> failwith "type mismatch"

        (m'.ResetAccCode() + m''.ResetAccCode())
            .AddCode([ (opcode (m'.GetAccCode() @ m''.GetAccCode()), "") ])
    | LessOrEq(e1, e2) ->
        let m' = doCodegen env e1 m
        let m'' = doCodegen env e2 m

        // find type of e1 and e2 and check if they are equal
        let opcode =
            match (expandType e1.Env e1.Type) with
            | t1 when (isSubtypeOf e1.Env t1 TInt) -> I32LeS
            | t1 when (isSubtypeOf e1.Env t1 TFloat) -> F32Le
            | t1 when (isSubtypeOf e1.Env t1 TBool) -> I32LeS
            | _ -> failwith "type mismatch"

        (m'.ResetAccCode() + m''.ResetAccCode())
            .AddCode([ (opcode (m'.GetAccCode() @ m''.GetAccCode()), "") ])
    | GreaterOrEq(e1, e2) ->
        let m' = doCodegen env e1 m
        let m'' = doCodegen env e2 m

        // find type of e1 and e2 and check if they are equal
        let opcode =
            match (expandType e1.Env e1.Type) with
            | t1 when (isSubtypeOf e1.Env t1 TInt) -> I32GeS
            | t1 when (isSubtypeOf e1.Env t1 TFloat) -> F32Ge
            | t1 when (isSubtypeOf e1.Env t1 TBool) -> I32GeS
            | _ -> failwith "type mismatch"

        (m'.ResetAccCode() + m''.ResetAccCode())
            .AddCode([ (opcode (m'.GetAccCode() @ m''.GetAccCode()), "") ])
    | ReadInt ->
        // perform host (system) call
        m
            .AddImport(getImport "readInt") // import readInt function
            .AddCode([ (Call "readInt", "call host function") ]) // call host function
    | ReadFloat ->
        // perform host (system) call
        m
            .AddImport(getImport "readFloat") // import readFloat function
            .AddCode([ (Call "readFloat", "call host function") ]) // call host function
    | PrintLn e
    | Print e when env.Config.Si = WASI ->
        // TODO: make print and println different
        let m' = doCodegen env e m

        match (expandType e.Env e.Type) with
        | t when (isSubtypeOf node.Env t TFloat) -> failwith "not implemented"
        | t when (isSubtypeOf node.Env t TString) ->
            // import writeS function
            m'
                .ResetAccCode()
                .AddImport(
                    ("wasi_snapshot_preview1",
                     "fd_write",
                     FunctionType("fd_write", Some([ (None, I32); (None, I32); (None, I32); (None, I32) ], [ I32 ])))
                )
                .AddCode(
                    // push string pointer to stack
                    [ (I32Const 1, "1 for stdout") ]
                    @ m'.GetAccCode()
                    @ [ (I32Add([ (I32Const 4, "offset to length") ] @ m'.GetAccCode()), "Load string length")
                        (I32Const 0, "1 for stdout") ]
                )
                .AddCode([ Drop([ (Call "fd_write", "call host function") ]) ])
        | _ ->
            // import writeInt function
            // import writeS function
            m'
                .ResetAccCode()
                .AddImport(
                    ("wasi_snapshot_preview1",
                     "fd_write",
                     FunctionType("fd_write", Some([ (None, I32); (None, I32); (None, I32); (None, I32) ], [ I32 ])))
                )
                .AddCode(
                    // push string pointer to stack
                    [ (I32Const 1, "1 for stdout") ]
                    @ m'.GetAccCode()
                    @ [ (I32Add([ (I32Const 4, "offset to length") ] @ m'.GetAccCode()), "Load string length")
                        (I32Const 0, "1 for stdout") ]
                )
                .AddCode([ Drop([ (Call "fd_write", "call host function") ]) ])
    | PrintLn e
    | Print e ->
        // TODO: make print and println different
        let m' = doCodegen env e m

        // use new line if printLn
        let nl = if node.Expr = PrintLn e then 1 else 0

        match (expandType e.Env e.Type) with
        | t when (isSubtypeOf node.Env t TFloat) ->
            // perform host (system) call
            m'
                .AddImport(getImport "writeFloat") // import writeF function
                .AddCode([ (I32Const nl, "newline"); (Call "writeFloat", "call host function") ])
        | t when (isSubtypeOf node.Env t TString) ->
            // import writeS function
            let m'' =
                m
                    .AddImport(getImport "writeS")
                    .AddCode(
                        // push string pointer to stack
                        [ (I32Load(m'.GetAccCode()), "Load string pointer") ]
                        @ [ (I32Load_(None, Some(4), m'.GetAccCode()), "Load string length")
                            (I32Const nl, "newline") ]
                    )

            // perform host (system) call
            (m'.ResetAccCode() ++ m'').AddCode([ (Call "writeS", "call host function") ])
        | _ ->
            // import writeInt function
            let m'' = m'.AddImport(getImport "writeInt")
            // perform host (system) call
            m''.AddCode([ (I32Const nl, "newline"); (Call "writeInt", "call host function") ])
    | AST.If(condition, ifTrue, ifFalse) ->
        let m' = doCodegen env condition m
        let m'' = doCodegen env ifTrue m
        let m''' = doCodegen env ifFalse m

        // get the return type of the ifTrue branch and subsequently the ifFalse branch
        let resultType = (expandType node.Env node.Type)

        let instrs =
            C [ (If(mapType resultType, m'.GetAccCode(), m''.GetAccCode(), Some(m'''.GetAccCode()))) ]

        (m' + m'' + m''').ResetAccCode().AddCode(instrs)
    | Assertion(e) ->
        let m' = doCodegen env e (m.ResetAccCode())

        let instrs =
            // invert assertion
            C [ (If([], [ (I32Eqz(m'.GetAccCode()), "invert assertion") ], trap, None)) ]

        m'.ResetAccCode().AddCode(instrs)
    | Application(expr, args: List<Node<TypingEnv, Type>>) when env.Config.AllocationStrategy = Heap ->
        /// compile arguments
        let argm = List.fold (fun m arg -> m + doCodegen env arg (m.ResetAccCode())) m args

        /// generate code for the expression for the function to be applied
        let exprm: Module = (doCodegen env expr m)

        // type to function signature
        let typeId = GenFuncTypeID(typeToFuncSiganture env (expandType expr.Env expr.Type))
        let stypeId = GenStructTypeIDType [ ("", I32); ("", EqRef) ]

        (argm)
            .ResetAccCode()
            .AddCode([ Comment "Load expression to be applied as a function" ])
            .AddCode(
                [ (CallIndirect(
                      Named(typeId),
                      [ (StructGet(Named(stypeId), Index(1), exprm.GetAccCode()), "load closure environment pointer") ]
                      @ argm.GetAccCode() // load the rest of the arguments
                      // load function pointer
                      @ [ (StructGet(Named(stypeId), Index(0), exprm.GetAccCode()), "load table index") ]
                   ),
                   "call function") ]
            )
    | Application(expr, args: List<Node<TypingEnv, Type>>) ->
        /// compile arguments
        let argm = List.fold (fun m arg -> m + doCodegen env arg (m.ResetAccCode())) m args

        /// generate code for the expression for the function to be applied
        let exprm: Module = (doCodegen env expr m)

        // type to function signature
        let typeId = GenFuncTypeID(typeToFuncSiganture env (expandType expr.Env expr.Type))

        (argm)
            .ResetAccCode()
            .AddCode([ Comment "Load expression to be applied as a function" ])
            .AddCode(
                [ (CallIndirect(
                      Named(typeId),
                      [ (I32Load_(None, Some(4), exprm.GetAccCode()), "load closure environment pointer") ]
                      @ argm.GetAccCode() // load the rest of the arguments
                      // load function pointer
                      @ [ (I32Load(exprm.GetAccCode()), "load table index") ]
                   ),
                   "call function") ]
            )
    | Lambda(args, body) when env.Config.AllocationStrategy = Heap ->
        // Label to mark the position of the lambda term body
        let funLabel = env.SymbolController.genSymbol $"{env.CurrFunc}/anonymous"

        let ptr_label = $"{funLabel}*ptr"

        // get the index of the function
        let funcindex = env.TableController.next ()

        let captured = Set.toList (ASTUtil.capturedVars node)

        let closTypeModule =
            if List.length captured > 0 then
                let args =
                    (List.map (fun (n) -> (Some(n), (mapTypeHeap node.Env.Vars[n], Mutable))) captured)

                Module().AddTypedef(StructType($"clos_{funLabel}", args))
            else
                Module()

        /// Names of the lambda term arguments
        let argNames, _ = List.unzip args
        /// List of pairs associating each function argument to its type
        let argNamesTypes = List.map (fun a -> (a, body.Env.Vars[a])) argNames

        let env' = addArgsToEnv env args

        let captured = Set.toList (ASTUtil.capturedVars node)

        let env'' = addCapturedToEnv env' captured

        /// Compiled function body
        let bodyCode: Module =
            compileFunction funLabel argNamesTypes body env'' (Module()) captured

        let closure = createClosure env node funcindex (Module()) captured
        let funcp = GenStructTypeIDType [ ("func", (I32)); ("cenv", (EqRef)) ]

        (bodyCode + closure + closTypeModule)
            .AddFuncRefElement(funLabel, funcindex)
            .AddGlobal((ptr_label, (Ref(Named(funcp)), Mutable), (Null(Named(funcp)), "")))
    | Lambda(args, body) ->
        // Label to mark the position of the lambda term body
        let funLabel = env.SymbolController.genSymbol $"{env.CurrFunc}/anonymous"

        let funcPointer, index, _ = createFunctionPointer funLabel env m

        /// Names of the lambda term arguments
        let argNames, _ = List.unzip args
        /// List of pairs associating each function argument to its type
        let argNamesTypes = List.map (fun a -> (a, body.Env.Vars[a])) argNames

        let env' = addArgsToEnv env args

        let captured = Set.toList (ASTUtil.capturedVars node)

        let env'' = addCapturedToEnv env' captured

        /// Compiled function body
        let bodyCode: Module =
            compileFunction funLabel argNamesTypes body env'' (Module()) captured

        let closure = createClosure env node index funcPointer captured

        (funcPointer + bodyCode + closure)
    | Seq(nodes) ->
        // We collect the code of each sequence node by folding over all nodes
        // and accumulating the code of each node in the accumulator module.
        // if a node in the  sequence is evaluated to a value (not unit) we drop it from the stack
        // unless it is the last node in the sequence. Meaning that it is the return value of the sequence.
        let lastIndex = (List.length nodes) - 1

        List.fold
            (fun m (i, node) ->
                // when values is push to the stack but is not needed
                // we drop them to keep the stack clean

                // if it is last node
                // the last node is the return value of the sequence
                // this may be a unit value
                if (i = lastIndex) then
                    // return last node
                    // todo just use new Module()
                    m + doCodegen env node (m.ResetAccCode())
                else
                    // return node
                    match node.Type with
                    | TUnit -> m + doCodegen env node (m.ResetAccCode())
                    | _ ->
                        let subTree = (doCodegen env node (m.ResetAccCode()))
                        // drop value if it is not needed
                        (m + subTree.ResetAccCode())
                            .AddCode([ (Drop(subTree.GetAccCode()), "drop value of subtree") ]))
            m
            (List.indexed nodes)

    | While(cond, body) ->
        let cond' = doCodegen env cond m
        let body' = doCodegen env body m

        let exitl = env.SymbolController.genSymbol $"loop_exit"
        let beginl = env.SymbolController.genSymbol $"loop_begin"

        let body'' =
            if (expandType body.Env body.Type) = TUnit then
                body'.GetAccCode()
            else
                [ (Drop(body'.GetAccCode()), "drop value of loop body") ]

        let loop =
            C
                [ Loop(
                      beginl,
                      [],
                      [ (BrIf(exitl, [ (I32Eqz(cond'.GetAccCode()), "evaluate loop condition") ]), "if false break") ]
                      @ body''
                      @ [ (Br beginl, "jump to beginning of loop") ]
                  ) ]

        let block = C [ (Block(exitl, [], loop)) ]

        (cond'.ResetAccCode() + body'.ResetAccCode()).AddCode(block)

    | DoWhile(cond, body) ->

        let body' = (doCodegen env body m)
        // insert drop if body is not unit
        let mayDrop =
            if (expandType body.Env body.Type) = TUnit then
                body'.GetAccCode()
            else
                [ (Drop(body'.GetAccCode()), "drop value of the body") ]

        body'.ResetAccCode().AddCode(mayDrop)
        ++ (doCodegen env { node with Expr = While(cond, body) } m)

    | For(init, cond, update, body) ->
        // the init expression is evaluated before the loop
        // the init expresstion is not allowed to return a value
        // therefore we drop the value if it is not unit
        let init' = (doCodegen env init m)

        let mayDrop =
            if (expandType init.Env init.Type) = TUnit then
                init'.GetAccCode()
            else
                [ (Drop(init'.GetAccCode()), "drop value of init node") ]

        init'.ResetAccCode().AddCode(mayDrop)
        ++ (doCodegen
                env
                { node with
                    Expr =
                        While(
                            cond,
                            { node with
                                Expr =
                                    Seq(
                                        [ body
                                          update
                                          { node with
                                              Expr = UnitVal
                                              Type = TUnit } ]
                                    ) }
                        ) }
                m)
    // array constructor for heap allocation
    | Array(length, data) when env.Config.AllocationStrategy = Heap ->
        let length' = doCodegen env length m
        let data' = doCodegen env data m

        let arrayType = GenArrayTypeIDType(mapTypeHeap data.Type)

        // check that length is bigger then 1 - if not return 42
        let lengthCheck =
            [ (If(
                  [],
                  [ (I32LeS(length'.GetAccCode() @ [ (I32Const 1, "put one on stack") ]), "check if length is <= 1") ],
                  trap,
                  None
               ),
               "check that length of array is bigger then 1 - if not return 42") ]

        (length'.ResetAccCode() + data'.ResetAccCode())
            .AddTypedef(ArrayType(arrayType, mapTypeHeap data.Type))
            .AddCode(
                lengthCheck
                @ [ (ArrayNew(Named(arrayType), data'.GetAccCode() @ length'.GetAccCode()), "create new array") ]
            )
    | Array(length, data) ->
        let length' = doCodegen env length m
        let data' = doCodegen env data m

        // check that length is bigger then 1 - if not return 42
        let lengthCheck =
            [ (If(
                  [],
                  [ (I32LeS(length'.GetAccCode() @ [ (I32Const 1, "put one on stack") ]), "check if length is <= 1") ],
                  trap,
                  None
               ),
               "check that length of array is bigger then 1 - if not return 42") ]

        // node with literal value 0
        // data poiner of struct is first zoro.
        let zero = { node with Expr = IntVal 0 }

        // create struct with length and data
        let structm =
            doCodegen
                env
                { node with
                    Expr = Struct([ ("data", zero); ("length", length) ]) }
                m

        // pointer to struct in local var
        let structPointerLabel = env.SymbolController.genSymbol $"arr_ptr"

        let structPointer =
            structm
                .ResetAccCode() // pointer to struct on stack
                .AddLocals([ (Some(Identifier(structPointerLabel)), I32) ]) // add local var
                .AddCode([ (LocalSet(Named(structPointerLabel), structm.GetAccCode()), "set struct pointer var") ]) // set struct pointer var

        let allocation = // allocate memory for array, return pointer to allocated memory
            match env.Config.AllocationStrategy with
            | External ->
                length'
                    .ResetAccCode() // length of array on stack
                    .AddImport(getImport "malloc") // import malloc function
                    .AddCode(
                        [ (I32Mul(length'.GetAccCode() @ [ (I32Const 4, "4 bytes") ]),
                           "multiply length with 4 to get size")
                          (Call "malloc", "call malloc function") ]
                    )
            | Internal ->
                let size =
                    [ (I32Mul(length'.GetAccCode() @ [ (I32Const 4, "4 bytes") ]), "multiply length with 4 to get size") ]

                length'
                    .ResetAccCode() // length of array on stack
                    .AddCode(checkMemory size)
                    .AddCode(
                        [ (GlobalGet(Named(heapBase)), "leave current heap base address")
                          (GlobalSet(
                              Named(heapBase),
                              [ (I32Add([ (GlobalGet(Named(heapBase)), "current base address") ] @ size),
                                 "add size to heap base") ]
                           ),
                           "set heap base") ]
                    )
            | Heap -> failwith "WasmGc not implemented"

        // set data pointer of struct
        let instr =
            // get pointer to allocated memory - value to store in data pointer field
            [ (I32Store(
                  [ (LocalGet(Named(structPointerLabel)), "get struct pointer var") ]
                  @ allocation.GetAccCode()
               ),
               "store pointer to data") ]


        // loop that runs length times and stores data in allocated memory
        let exitl = env.SymbolController.genSymbol $"loop_exit"
        let beginl = env.SymbolController.genSymbol $"loop_begin"
        let i = env.SymbolController.genSymbol $"i"

        let storeInstr =
            match (expandType data.Env data.Type) with
            | t when (isSubtypeOf data.Env t TInt) -> I32Store
            | t when (isSubtypeOf data.Env t TFloat) -> F32Store
            | _ -> I32Store

        // body should set data in allocated memory
        // TODO: optimize loop so i just multiply index with 4 and add it to base address
        let body =
            // get value to store in allocated memory
            [ (storeInstr (
                  [ (Comment "start of loop body", "")
                    (I32Add(
                        [ (I32Load([ (LocalGet(Named(structPointerLabel)), "get struct pointer var") ]),
                           "load data pointer")
                          (I32Mul(
                              [
                                // find offset to element
                                (LocalGet(Named(i)), "get index")
                                (I32Const(4), "byte offset") ]
                           ),
                           "multiply index with byte offset") ]
                     ),
                     "add offset to base address") ] // then offset is on top of stack
                  @ data'.GetAccCode()
               ),
               "store value in elem pos")
              (Comment "end of loop body", "") ]

        // loop that runs length times and stores data in allocated memory
        let loop =
            C
                [ Loop(
                      beginl,
                      [], // loops does not return anything
                      [ (BrIf(exitl, C [ I32Eq(length'.GetAccCode() @ [ (LocalGet(Named i), "get i") ]) ]), "") ]
                      @ body
                      @ [ (LocalSet(
                              Named i,
                              [ (I32Add([ (LocalGet(Named i), "get i"); (I32Const(1), "increment by 1") ]), "add 1 to i") ]
                           ),
                           "write to i") ]
                      @ C [ Br beginl ]
                  ) ]

        // block that contains loop and provides a way to exit the loop
        let block: Commented<WGF.Instr.Wasm> list =
            C [ LocalSet(Named(i), C [ I32Const 0 ]) ] @ C [ (Block(exitl, [], loop)) ]

        let loopModule =
            data'.ResetAccCode().AddLocals([ (Some(Identifier(i)), I32) ]).AddCode(block)

        lengthCheck
        ++ structPointer.AddCode(instr)
        ++ loopModule.AddCode(
            [ (LocalGet(Named(structPointerLabel)), "leave pointer to allocated array struct on stack") ]
        )
    | ArrayLength(target) when env.Config.AllocationStrategy = Heap ->
        let target' = doCodegen env target m

        target'
            .ResetAccCode()
            .AddCode([ (ArrayLen(target'.GetAccCode()), "get length") ])
    | ArrayLength(target) ->
        let target' = doCodegen env target m

        target'
            .ResetAccCode()
            .AddCode(
                C [ Comment "start array length node" ]
                @ [ (I32Load_(None, Some(4), target'.GetAccCode()), "load length") ]
                @ C [ Comment "end array length node" ]
            )
    | ArrayElement(target, index) when env.Config.AllocationStrategy = Heap ->
        let target' = doCodegen env target m
        let index' = doCodegen env index m
        let length' = doCodegen env { node with Expr = ArrayLength(target) } m

        let arrayType = GenArrayTypeIDType(mapTypeHeap target.Type)

        // check that index is bigger then 0 - if not return 42
        // and that index is smaller then length - if not return 42
        let indexCheck =
            [ (If(
                  [],
                  [ (I32LtS(
                        index'.GetAccCode() // index on stack
                        @ [ (I32Const 0, "put zero on stack") ]
                     ),
                     "check if index is >= 0") ],
                  trap,
                  None
               ),
               "check that index is >= 0 - if not return 42") ]
            @ [ (If(
                    [],
                    [ (I32GeS(
                          index'.GetAccCode() // index on stack
                          @ length'.GetAccCode() // length on stack
                       ),
                       "check if index is < length") ],
                    trap,
                    None
                 ),
                 "check that index is < length - if not return 42") ]

        indexCheck
        ++ (target' + index' + length'.ResetAccCode())
            .ResetAccCode()
            .AddCode([ (ArrayGet(Named(arrayType), target'.GetAccCode() @ index'.GetAccCode()), "get element") ])

    | ArrayElement(target, index) ->
        let m' = doCodegen env target m
        let m'' = doCodegen env index m

        // check that index is bigger then 0 - if not return 42
        // and that index is smaller then length - if not return 42
        let indexCheck =
            [ (If(
                  [],
                  [ (I32LtS(
                        m''.GetAccCode() // index on stack
                        @ [ (I32Const 0, "put zero on stack") ]
                     ),
                     "check if index is >= 0") ],
                  trap,
                  None
               ),
               "check that index is >= 0 - if not return 42") ]
            @ [ (If(
                    [],
                    [ (I32GeS(
                          m''.GetAccCode() // index on stack
                          // struct pointer on stack
                          @ [ (I32Load_(None, Some(4), m'.GetAccCode()), "load length") ]
                       ),
                       "check if index is < length") ],
                    trap,
                    None
                 ),
                 "check that index is < length - if not return 42") ]

        // resolve load and store instruction based on type
        let loadInstr =
            match (expandType node.Env node.Type) with
            | t when (isSubtypeOf node.Env t TInt) -> I32Load
            | t when (isSubtypeOf node.Env t TFloat) -> F32Load
            | _ -> I32Load

        let instrs =
            // struct pointer on stack
            [ (loadInstr (
                  [ (I32Add(
                        [ (I32Load(m'.GetAccCode()), "load data pointer")
                          (I32Mul(m''.GetAccCode() @ [ (I32Const 4, "byte offset") ]), "multiply index with byte offset") ]
                     ),
                     "add offset to base address") ]
               ),
               "load value") ]

        indexCheck
        ++ (m' + m'')
            .ResetAccCode()
            .AddCode(instrs @ C [ Comment "end array element access node" ])
    // array slice creates a new struct with a pointer to the data of the original array
    | ArraySlice(target, start, ending) ->

        let length =
            { node with
                Expr = Sub(ending, start)
                Type = TInt }

        // compile target
        let targetm = doCodegen env target m
        // compile start index
        let startm = doCodegen env start m
        // compile end index
        let endingm = doCodegen env ending m

        // check of indecies are valid
        // check that start is bigger then 0 - if not return 42
        // and that start is smaller then length of the original array - if not return 42
        let startCheck =
            [ (If(
                  [],
                  [ (I32LtS(
                        startm.GetAccCode() // start on stack
                        @ [ (I32Const 0, "put zero on stack") ]
                     ),
                     "check if start is >= 0") ],
                  trap,
                  None
               ),
               "check that start is >= 0 - if not return 42") ]
            @ [ (If(
                    [],
                    [ (I32GeS(
                          startm.GetAccCode() // start on stack
                          // struct pointer on stack
                          @ [ (I32Load_(None, Some(4), targetm.GetAccCode()), "load length") ]
                       ),
                       "check if start is < length") ],
                    trap,
                    None
                 ),
                 "check that start is < length - if not return 42") ]

        // check that end is bigger then 0 - if not return 42
        // and that end is smaller then length of the original array - if not return 42
        // and end is bigger then start - if not return 42
        // and the difference between end and start should be at least 1 - if not return 42

        // check that end index is smaller then length of the original array - if not return 42
        let endCheck =
            [ (If(
                  [],
                  // 4 is the offset to length field
                  [ (I32GtS(
                        endingm.GetAccCode() // end index on stack
                        // struct pointer on stack
                        @ [ (I32Load_(None, Some(4), targetm.GetAccCode()), "load length") ]
                     ),
                     "check if end is < length") ],
                  trap,
                  None
               ),
               "check that end is < length - if not return 42") ]

        // difference between end and start should be at least 1
        let atleastOne =
            [ (If(
                  [],
                  [ (I32LtS(
                        [ (I32Sub(endingm.GetAccCode() @ startm.GetAccCode()), "subtract end from start")
                          (I32Const 1, "put one on stack") ]
                     ),
                     "check if difference is < 1") ],
                  trap,
                  None
               ),
               "check that difference is <= 1 - if not return 42") ]

        // create struct with length and data
        let structm =
            doCodegen
                env
                { node with
                    Expr = Struct([ ("data", { node with Expr = IntVal 0 }); ("length", length) ]) }
                m

        let structPointerLabel = env.SymbolController.genSymbol $"arr_slice_ptr"

        let structm' =
            structm
                .ResetAccCode() // pointer to struct on stack
                .AddLocals([ (Some(Identifier(structPointerLabel)), I32) ]) // add local var
                .AddCode([ (LocalSet(Named(structPointerLabel), structm.GetAccCode()), "set struct pointer var") ]) // set struct pointer var

        // set data pointer of struct
        let instr =
            // here to store pointer to allocated memory
            // value to store in data pointer field
            // pointer to exsisiting array struct on stack
            // get pointer to allocated memory - value to store in data pointer field
            [ (I32Store(
                  [ (LocalGet(Named(structPointerLabel)), "get struct pointer var")
                    (I32Add(
                        [ (I32Load(targetm.GetAccCode()), "Load data pointer from array struct")
                          (I32Mul(startm.GetAccCode() @ [ (I32Const 4, "offset of data field") ]),
                           "multiply index with byte offset") ]
                     ),
                     "add offset to base address") ]
               ),
               "store pointer to data") ]

        (C [ Comment "start array slice" ] @ atleastOne @ endCheck @ startCheck)
        ++ structm'
        ++ (targetm.ResetAccCode() + endingm.ResetAccCode())
            // .AddCode([ (LocalSet(Named(structPointerLabel)), "set struct pointer var") ])
            .AddCode(instr)
            .AddCode(
                [ (LocalGet(Named(structPointerLabel)), "leave pointer to allocated array struct on stack")
                  (Comment "end array slice", "") ]
            )
    | UnionCons(label, expr) ->
        // compute label id
        let id = env.SymbolController.genSymbolId label
        // create node for label
        let idNode = { node with Expr = IntVal id }

        // in case there is no data aka a unit - we need to add a zero
        let data =
            match (expandType expr.Env expr.Type) with
            | TUnit -> { node with Expr = IntVal 0 } // unitvalue
            | _ -> expr

        // rewrite as struct
        let structNode =
            { node with
                Expr = Struct([ ("id", idNode); ("data", data) ]) }

        // codegen structNode
        C [ Comment "Start of union contructor" ]
        ++ (doCodegen env structNode m).AddCode([ (Comment "End of union contructor") ])
    | Match(target, cases) ->
        let targetm = doCodegen env target m

        let labels, vars, exprs = List.unzip3 cases
        let indexedLabels = List.indexed labels

        // resolve result type of match expression
        let reusltType = mapType (expandType exprs[0].Env exprs[0].Type)

        // let matchResult = Util.genSymbol $"match_result"
        let matchEndLabel = env.SymbolController.genSymbol $"match_end"
        // fold over indexedLabels to generate code for each case
        let folder =
            fun (acc: Module) (i: int * string) ->
                let index, label = i
                let id = env.SymbolController.genSymbolId label
                let expr = exprs[index]
                let var = vars[index]

                let varNode =
                    { node with
                        Expr = Var var
                        Type = expr.Env.Vars[var] }

                let varName = env.SymbolController.genSymbol $"match_var_{var}"

                // map case var to label address
                let scopeVarStorage = env.VarStorage.Add(var, Storage.Local varName)

                /// Environment for compiling the 'case' scope
                let scopeEnv =
                    { env with
                        VarStorage = scopeVarStorage }

                // resolve type of var
                let t = mapType (expandType varNode.Env varNode.Type)

                let scope =
                    (doCodegen scopeEnv expr m)
                        .AddLocals([ (Some(Identifier(varName)), (if t.IsEmpty then I32 else (t)[0])) ])

                // resolve load and store instruction based on type
                let loadInstr =
                    match (expandType varNode.Env varNode.Type) with
                    | t when (isSubtypeOf expr.Env t TInt) -> I32Load_
                    | t when (isSubtypeOf expr.Env t TFloat) -> F32Load_
                    | _ -> I32Load_

                // address to data
                let dataPointer =
                    [ (LocalSet(
                          Named(varName),
                          [ (loadInstr (None, Some(4), targetm.GetAccCode()), "load data pointer") ]
                       ),
                       "set local var") ] // set local var

                let caseCode =
                    dataPointer ++ scope.AddCode([ (Br matchEndLabel, "break out of match") ])

                let condition =
                    [ (I32Eq(
                          [ (I32Load(targetm.GetAccCode()), "load label")
                            (I32Const id, $"put label id {id} on stack") ]
                       ),
                       "check if index is equal to target") ]

                // if case is not the last case
                let case = C [ (If([], condition, caseCode.GetAccCode(), None)) ]

                acc
                ++ caseCode
                    .ResetAccCode()
                    .AddCode(C [ Comment $"case for id: ${id}, label: {label}" ] @ case)

        let casesCode = List.fold folder (Module()) indexedLabels

        let defaultCase =
            C [ Comment "no case was matched, therefore return exit error code" ] @ trap

        // block that contains all cases
        let block =
            C [ (Block(matchEndLabel, reusltType, casesCode.GetAccCode() @ defaultCase)) ]

        casesCode.ResetAccCode().AddCode(block)
    | Assign(name, value) ->
        let value' = doCodegen env value m

        match name.Expr with
        | Var(name) ->

            match env.VarStorage.TryFind name with
            | Some(Storage.Local l) ->
                value'
                    .ResetAccCode()
                    .AddCode([ (LocalTee(Named(l), value'.GetAccCode()), "set local var") ])
            | Some(Storage.Offset(i)) ->
                // get correct load and store instruction
                let li, si =
                    match (expandType value.Env value.Type) with
                    | t when (isSubtypeOf value.Env t TInt) ->
                        ((I32Load_(None, Some(i * 4), [ (LocalGet(Index(0)), "get env") ]), "load value i32 from env"),
                         (I32Store_(None, Some(i * 4), [ (LocalGet(Index(0)), "get env") ] @ value'.GetAccCode()),
                          "store i32 value in env"))
                    | t when (isSubtypeOf value.Env t TFloat) ->
                        ((F32Load_(None, Some(i * 4), [ (LocalGet(Index(0)), "get env") ]), "load value f32 from env"),
                         (F32Store_(None, Some(i * 4), [ (LocalGet(Index(0)), "get env") ] @ value'.GetAccCode()),
                          "store f32 value in env"))
                    | _ -> failwith "not implemented"

                value'.ResetAccCode().AddCode([ si ] @ [ li ])
            | Some(Storage.Global g) ->
                value'
                    .ResetAccCode()
                    .AddCode(
                        [ (GlobalSet(Named(g), value'.GetAccCode()), "set global var")
                          (GlobalGet(Named(g)), "get global var") ]
                    )
            | _ -> failwith "not implemented"

        | FieldSelect(target, field) when env.Config.AllocationStrategy = Heap ->
            let selTargetCode = doCodegen env target m
            /// Code for the 'rhs' expression of the assignment
            let rhsCode = doCodegen env value m

            match (expandType target.Env target.Type) with
            | TStruct(fields: List<string * Type>) ->
                /// Names of the struct fields
                let fieldNames, _ = List.unzip fields
                /// offset of the selected struct field from the beginning of
                /// the struct
                let offset = List.findIndex (fun f -> f = field) fieldNames

                // map fields t valueType
                let fieldTypes = List.map (fun (n, t) -> (n, mapTypeHeap t)) fields
                // typeid
                let typeId = GenStructTypeIDType fieldTypes

                let assignCode =
                    Module()
                        .AddCode(
                            [ (StructSet(
                                  Named(typeId),
                                  Named(fieldNames[offset]), // could also be Index(offset)
                                  // struct pointer on stack and value to store
                                  selTargetCode.GetAccCode() @ rhsCode.GetAccCode()
                               ),
                               $"set field: {fieldNames[offset]}")
                              (StructGet(Named(typeId), Named(fieldNames[offset]), selTargetCode.GetAccCode()),
                               $"get field: {fieldNames[offset]}") ]
                        )

                assignCode ++ (rhsCode.ResetAccCode() + selTargetCode.ResetAccCode())
            | _ -> failwith "failed to assign to field"
        | FieldSelect(target, field) ->

            let selTargetCode = doCodegen env target m

            /// Code for the 'rhs' expression of the assignment
            let rhsCode = doCodegen env value m

            match (expandType target.Env target.Type) with
            | TStruct(fields) ->
                /// Names of the struct fields
                let fieldNames, _ = List.unzip fields
                /// offset of the selected struct field from the beginning of
                /// the struct
                let offset = List.findIndex (fun f -> f = field) fieldNames

                /// Assembly code that performs the field value assignment
                let assignCode =
                    match (expandType name.Env name.Type) with
                    | t when (isSubtypeOf value.Env t TUnit) -> [] // Nothing to do
                    | t when (isSubtypeOf value.Env t TFloat) ->
                        // load value just to leave a value on the stack
                        [ (F32Load_(
                              None,
                              Some(offset * 4),
                              selTargetCode.GetAccCode()
                              @ [ (F32Store_(None, Some(offset * 4), selTargetCode.GetAccCode() @ rhsCode.GetAccCode()),
                                   "store float in struct") ]
                           ),
                           "load float from struct") ]
                    | _ ->
                        // load value just to leave a value on the stack
                        [ (I32Load_(
                              None,
                              Some(offset * 4),
                              selTargetCode.GetAccCode()
                              @ [ (I32Store_(None, Some(offset * 4), selTargetCode.GetAccCode() @ rhsCode.GetAccCode()),
                                   "store int in struct") ]
                           ),
                           "load int from struct") ]

                // Put everything together
                assignCode ++ (rhsCode.ResetAccCode() + selTargetCode.ResetAccCode())
            | _ -> failwith "failed to assign to field"
        | ArrayElement(target, index) when env.Config.AllocationStrategy = Heap ->
            let target' = doCodegen env target m
            let index' = doCodegen env index m
            let value' = doCodegen env value m
            let length' = doCodegen env { node with Expr = ArrayLength(target) } m
            let arrayType = GenArrayTypeIDType(mapTypeHeap value.Type)

            // Check index >= 0 and index < length
            let indexCheck =
                [ (If(
                      [],
                      [ (I32LtS(
                            index'.GetAccCode() // index on stack
                            @ [ (I32Const 0, "put zero on stack") ]
                         ),
                         "check if index is >= 0") ],
                      trap,
                      None
                   ),
                   "check that index is >= 0 - if not return 42") ]
                @ [ (If(
                        [],
                        [ (I32GeS(
                              index'.GetAccCode() // index on stack
                              @ length'.GetAccCode() // length on stack
                           ),
                           "check if index is < length") ],
                        trap,
                        None
                     ),
                     "check that index is < length - if not return 42") ]

            let instrs =
                [ (ArraySet(Named(arrayType), target'.GetAccCode() @ index'.GetAccCode() @ value'.GetAccCode()),
                   "write to element") ]
                @ value'.GetAccCode()

            (value'.ResetAccCode() + index'.ResetAccCode() + target'.ResetAccCode())
                .AddCode(indexCheck @ instrs)
        | ArrayElement(target, index) ->
            let selTargetCode = doCodegen env target m
            let indexCode = doCodegen env index m

            let rhsCode = doCodegen env value m

            // Check index >= 0 and index < length
            let indexCheck =
                [ (If(
                      [],
                      [ (I32LtS(
                            indexCode.GetAccCode() // index on stack
                            @ [ (I32Const 0, "put zero on stack") ]
                         ),
                         "check if index is >= 0") ],
                      trap,
                      None
                   ),
                   "check that index is >= 0 - if not return 42") ]
                @ [ (If(
                        [],
                        [ (I32GeS(
                              indexCode.GetAccCode() // index on stack
                              // struct pointer on stack
                              @ [ (I32Load_(None, Some(4), selTargetCode.GetAccCode()), "load length") ]
                           ),
                           "check if index is < length") ],
                        trap,
                        None
                     ),
                     "check that index is < length - if not return 42") ]

            let storeInstr =
                match (expandType value.Env value.Type) with
                | t when (isSubtypeOf value.Env t TInt) -> I32Store
                | t when (isSubtypeOf value.Env t TFloat) -> F32Store
                | _ -> I32Store

            let loadInstr =
                match (expandType value.Env value.Type) with
                | t when (isSubtypeOf value.Env t TInt) -> I32Load
                | t when (isSubtypeOf value.Env t TFloat) -> F32Load
                | _ -> I32Load

            let instrs =
                [ (storeInstr (
                      [ (I32Add(
                            [ (I32Load(selTargetCode.GetAccCode()), "load data pointer")
                              (I32Mul(
                                  // store value in allocated memory
                                  // struct pointer on stack
                                  indexCode.GetAccCode() // index on stack
                                  @ [ (I32Const 4, "byte offset") ]
                               ),
                               "multiply index with byte offset") ]
                         ),
                         "add offset to base address") ]
                      @ rhsCode.GetAccCode()
                   ),
                   "store value in elem pos") ]
                // load value just to leave a value on the stack
                // struct pointer on stack
                @ [ (loadInstr (
                        [ (I32Add(
                              [ (I32Load(selTargetCode.GetAccCode()), "load data pointer")
                                (I32Mul(indexCode.GetAccCode() @ [ (I32Const 4, "byte offset") ]),
                                 "multiply index with byte offset") ]
                           ),
                           "add offset to base address") ]
                     ),
                     "load int from elem pos") ]

            (rhsCode.ResetAccCode() + indexCode.ResetAccCode() + selTargetCode.ResetAccCode())
                .AddCode(indexCheck @ instrs)
        | _ -> failwith "not implemented"
    | Ascription(_, node) ->
        // A type ascription does not produce code --- but the type-annotated
        // AST node does
        doCodegen env node m

    | Let(name,
          _,
          { Node.Expr = Lambda(args, body)
            Node.Type = TFun(targs, _) },
          scope,
          export) when env.Config.AllocationStrategy = Heap ->
        /// Assembly label to mark the position of the compiled function body.
        /// For readability, we make the label similar to the function name
        let funLabel = env.SymbolController.genSymbol $"fun_%s{name}"

        let m =
            if export then
                m.AddExport(name, FunctionType(funLabel, None))
            else
                m

        // struct with function pointer and closure environment pointer
        let stypeId = GenStructTypeIDType [ ("", I32); ("", EqRef) ]

        let ptr_label = $"{funLabel}*ptr"

        // get the index of the function
        let funcindex = env.TableController.next ()

        let funcPointer =
            { node with
                Expr =
                    Struct(
                        [ ("f",
                           { node with
                               Expr = IntVal(funcindex) // function pointer
                               Type = TInt })
                          //   ("env",
                          //    { node with
                          //        Expr = UnitVal
                          //        Type = TUnit })
                          ]

                    )
                Type = TStruct([ ("f", TInt); ("cenv", TAny) ]) }

        // compile function pointer
        let funcPointerModule =
            (doCodegen env funcPointer (m))
                .AddFuncRefElement(funLabel, funcindex) // add function to function table
                .AddGlobal((ptr_label, (Ref(Named(stypeId)), Mutable), (Null(Named(stypeId)), "")))

        /// Storage info where the name of the compiled function points to the
        /// label 'funLabel'
        let funcref = env.VarStorage.Add(name, Storage.Global ptr_label)

        // add each arg to var storage (all local vars)
        let env' = addArgsToEnv env args

        /// Names of the lambda term arguments
        let argNames, _ = List.unzip args
        /// List of pairs associating each function argument to its type
        let argNamesTypes = List.zip argNames targs

        let captured = Set.toList (ASTUtil.capturedVars node)

        let env'' =
            if isTopLevel env then
                env'
            else
                addCapturedToEnv env' captured

        /// Compiled function body
        let bodyCode: Module =
            compileFunction funLabel argNamesTypes body env'' (Module()) captured

        let closure =
            if isTopLevel env then
                Module()
            else
                let closureModule = (createClosure env' node funcindex funcPointerModule captured)

                closureModule
                    .ResetAccCode()
                    .AddCode([ GlobalSet(Named(ptr_label), closureModule.GetAccCode()) ])

        let scopeModule: Module =
            (doCodegen { env with VarStorage = funcref } scope funcPointerModule)

        // Set the function pointer to the closure struct
        bodyCode + closure + scopeModule

    // special case for function definitions
    | Let(name,
          _,
          { Node.Expr = Lambda(args, body)
            Node.Type = TFun(targs, _) },
          scope,
          export) ->
        /// Assembly label to mark the position of the compiled function body.
        /// For readability, we make the label similar to the function name
        let funLabel = env.SymbolController.genSymbol $"fun_%s{name}"

        let m =
            if export then
                m.AddExport(name, FunctionType(funLabel, None))
            else
                m

        let funcPointer, index, ptr_label = createFunctionPointer funLabel env m

        /// Storage info where the name of the compiled function points to the
        /// label 'funLabel'
        let funcref = env.VarStorage.Add(name, Storage.Global ptr_label)

        // add each arg to var storage (all local vars)
        let env' = addArgsToEnv env args

        /// Names of the lambda term arguments
        let argNames, _ = List.unzip args
        /// List of pairs associating each function argument to its type
        let argNamesTypes = List.zip argNames targs

        let captured = Set.toList (ASTUtil.capturedVars node)

        let env'' =
            if isTopLevel env then
                env'
            else
                addCapturedToEnv env' captured

        /// Compiled function body
        let bodyCode: Module =
            compileFunction funLabel argNamesTypes body env'' (Module()) captured

        let closure =
            if isTopLevel env then
                Module()
            else
                let closureModule = (createClosure env' node index funcPointer captured)

                closureModule
                    .ResetAccCode()
                    .AddCode([ GlobalSet(Named(ptr_label), closureModule.GetAccCode()) ])

        let scopeModule: Module =
            (doCodegen { env with VarStorage = funcref } scope funcPointer)

        // Set the function pointer to the closure struct
        bodyCode + closure + scopeModule

    | Let(name, _, init, scope, export) ->
        let m' = doCodegen env init m

        let varName = env.SymbolController.genSymbol $"var_%s{name}"

        let m =
            if export then
                m.AddExport(varName, GlobalType(varName)).AddToHostingList(varName)
            else
                m

        let env' =
            { env with
                VarStorage = env.VarStorage.Add(name, Storage.Local varName) }

        match (expandType init.Env init.Type) with
        | t when (isSubtypeOf init.Env t TUnit) -> m' ++ (doCodegen env scope m)
        | t when (isSubtypeOf init.Env t TInt) ->
            let varLabel = Named(varName)
            let initCode = m'.GetAccCode()

            let instrs = [ (LocalSet(varLabel, initCode), "set local var") ] // set local var

            let scopeCode = (doCodegen env' scope (m.ResetAccCode()))

            let combi = (instrs ++ scopeCode)

            C [ Comment "Start of let" ]
            ++ m'.ResetAccCode()
            ++ combi
                .AddLocals([ (Some(Identifier(varName)), I32) ])
                .AddCode([ Comment "End of let" ])
        | t when (isSubtypeOf init.Env t TFloat) ->
            let varLabel = Named(varName)
            let initCode = m'.GetAccCode()

            let instrs = [ (LocalSet(varLabel, initCode), "set local var") ] // set local var

            let scopeCode = (doCodegen env' scope (m.ResetAccCode()))

            C [ Comment "Start of let" ]
            ++ m'.ResetAccCode()
            ++ (instrs ++ scopeCode)
                .AddLocals([ (Some(Identifier(varName)), F32) ])
                .AddCode([ Comment "End of let" ])
        | TFun _ when env.Config.AllocationStrategy = Heap ->
            // todo make function pointer
            let varLabel = Named(varName)

            // add var to func ref
            let env'' =
                { env' with
                    VarStorage = env.VarStorage.Add(name, Storage.Local varName) }

            let initCode = m'.GetAccCode()

            let instrs = [ (LocalSet(varLabel, initCode), "set local var") ] // set local var

            let scopeCode = (doCodegen env'' scope (m.ResetAccCode()))

            let combi = (instrs ++ scopeCode)

            let funcp = GenStructTypeIDType [ ("func", (I32)); ("cenv", (EqRef)) ]

            C [ Comment "Start of let" ]
            ++ m'.ResetAccCode()
            ++ combi
                .AddLocals([ (Some(Identifier(varName)), Ref(Named(funcp))) ])
                .AddCode([ Comment "End of let" ])
        | TFun _ ->
            // todo make function pointer
            let varLabel = Named(varName)

            // add var to func ref
            let env'' =
                { env' with
                    VarStorage = env.VarStorage.Add(name, Storage.Local varName) }

            let initCode = m'.GetAccCode()

            let instrs = [ (LocalSet(varLabel, initCode), "set local var") ] // set local var

            let scopeCode = (doCodegen env'' scope (m.ResetAccCode()))

            let combi = (instrs ++ scopeCode)

            C [ Comment "Start of let" ]
            ++ m'.ResetAccCode()
            ++ combi
                .AddLocals([ (Some(Identifier(varName)), I32) ])
                .AddCode([ Comment "End of let" ])
        | TStruct _ when env.Config.AllocationStrategy = Heap ->
            let varLabel = Named(varName)
            let initCode = m'.GetAccCode()

            let t =
                match lookupLatestType m' with
                | StructType(l, _) -> l
                | _ -> failwith "not a struct"

            let instrs = [ (LocalSet(varLabel, initCode), "set local var") ] // set local var

            let scopeCode = (doCodegen env' scope (m'.ResetAccCode()))

            let combi = (instrs ++ scopeCode + m.ResetAccCode())

            C [ Comment "Start of let" ]
            ++ m'.ResetAccCode()
            ++ combi
                .AddLocals([ (Some(Identifier(varName)), Ref(Named(t))) ])
                .AddCode([ Comment "End of let" ])
        | TArray _ when env.Config.AllocationStrategy = Heap ->
            let varLabel = Named(varName)
            let initCode = m'.GetAccCode()

            let t = GenArrayTypeIDType(mapTypeHeap init.Type)

            let instrs = [ (LocalSet(varLabel, initCode), "set local var") ] // set local var

            let scopeCode = (doCodegen env' scope (m'.ResetAccCode()))

            let combi = (instrs ++ scopeCode + m.ResetAccCode())

            C [ Comment "Start of let" ]
            ++ m'.ResetAccCode()
            ++ combi
                .AddLocals([ (Some(Identifier(varName)), Ref(Named(t))) ])
                .AddCode([ Comment "End of let" ])
        | TStruct _ ->
            let varLabel = Named(varName)
            let initCode = m'.GetAccCode()

            let instrs = [ (LocalSet(varLabel, initCode), "set local var") ] // set local var

            let scopeCode = (doCodegen env' scope (m'.ResetAccCode()))

            let combi = (instrs ++ scopeCode + m.ResetAccCode())

            C [ Comment "Start of let" ]
            ++ m'.ResetAccCode()
            ++ combi
                .AddLocals([ (Some(Identifier(varName)), I32) ])
                .AddCode([ Comment "End of let" ])
        | _ ->
            // todo make function pointer
            let varLabel = Named(varName)
            let initCode = m'.GetAccCode()

            let instrs = [ (LocalSet(varLabel, initCode), "set local var") ] // set local var

            let scopeCode = (doCodegen env' scope (m.ResetAccCode()))

            let combi = (instrs ++ scopeCode)

            C [ Comment "Start of let" ]
            ++ m'.ResetAccCode()
            ++ combi
                .AddLocals([ (Some(Identifier(varName)), I32) ])
                .AddCode([ Comment "End of let" ])

    | LetMut(name, tpe, init, scope, export) ->
        // check if var is captured
        let isVarCaptured = List.contains name (Set.toList (ASTUtil.capturedVars scope))

        // rewrite let mut to let with struct to support mutabul closures
        if isVarCaptured then

            let fieldName = "value"

            // create struct with one field called value
            let structNode =
                { node with
                    Expr = Struct([ (fieldName, init) ])
                    Type = TStruct([ (fieldName, init.Type) ]) }

            // var node with struct pointer var
            let varNode =
                { node with
                    Expr = Var(name)
                    Type = TStruct([ (fieldName, init.Type) ]) }

            // select field value from struct every time var is used
            let selectNode =
                { node with
                    Expr = FieldSelect(varNode, fieldName)
                    Type = init.Type }

            // replace every occurence of the var in scope with the struct FieldSelect
            let scope' = ASTUtil.subst scope name selectNode

            // node with sequence of let and scope
            let n =
                { node with
                    Expr = Let(name, tpe, structNode, scope', export) }

            let m' = (doCodegen env n m)

            m'
        else
            // The code generation is not different from 'let...', so we recycle it
            (doCodegen
                env
                { node with
                    Expr = Let(name, tpe, init, scope, export) }
                m)
    | LetRec(name,
             _,
             { Node.Expr = Lambda(args, body)
               Node.Type = TFun(targs, _) },
             scope,
             export) when env.Config.AllocationStrategy = Heap ->

        let funLabel = env.SymbolController.genSymbol $"fun_%s{name}"

        let m =
            if export then
                m.AddExport(name, FunctionType(funLabel, None))
            else
                m

        let ptr_label = $"{funLabel}*ptr"

        let funcp = GenStructTypeIDType [ ("func", (I32)); ("cenv", (EqRef)) ]

        // get the index of the function
        let funcindex = env.TableController.next ()

        /// Storage info where the name of the compiled function points to the
        /// label 'funLabel'
        let funcref = env.VarStorage.Add(name, Storage.Global ptr_label)
        let env' = { env with VarStorage = funcref }

        // add each arg to var storage (all local vars)
        let env'' = addArgsToEnv env' args

        /// Names of the lambda term arguments
        let argNames, _ = List.unzip args
        /// List of pairs associating each function argument to its type
        let argNamesTypes = List.zip argNames targs

        let captured = Set.toList (ASTUtil.capturedVars node)

        let closTypeModule =
            if List.length captured > 0 then
                let args =
                    (List.map (fun (n) -> (Some(n), (mapTypeHeap node.Env.Vars[n], Mutable))) captured)

                Module().AddTypedef(StructType($"clos_{name}", args))
            else
                Module()

        // let closType =
        //     GenStructTypeIDType(List.map (fun (n) -> (n, mapTypeHeap node.Env.Vars[n])) captured)

        let clos =
            [ GlobalSet(
                  Named(ptr_label),
                  C
                      [ StructNew(
                            Named(funcp),
                            [ (I32Const funcindex, "put function index on stack")
                              (NullValue(Eq), "null ref") ]
                        ) ]
              ) ]

        let env'' =
            if isTopLevel env then
                env''
            else
                addCapturedToEnv env'' captured

        /// Compiled function body
        let bodyCode: Module =
            compileFunction funLabel argNamesTypes body env'' (Module()) captured

        let closure =
            if isTopLevel env then
                Module()
            else
                let closureModule = (createClosure env' node funcindex (Module()) captured)

                closureModule
                    .ResetAccCode()
                    .AddCode([ GlobalSet(Named(ptr_label), closureModule.GetAccCode()) ])

        let scopeModule: Module = (doCodegen env' scope m)


        // Set the function pointer to the closure struct
        C clos ++ closTypeModule
        + bodyCode.AddTypedef(StructType(funcp, [ (Some("func"), (I32, Mutable)); (Some("cenv"), (EqRef, Mutable)) ]))
        + closure
        + scopeModule
            .AddFuncRefElement(funLabel, funcindex)
            .AddGlobal((ptr_label, (Ref(Named(funcp)), Mutable), (Null(Named(funcp)), "")))

    | LetRec(name,
             _,
             { Node.Expr = Lambda(args, body)
               Node.Type = TFun(targs, _) },
             scope,
             export) ->

        let funLabel = env.SymbolController.genSymbol $"fun_%s{name}"

        let m =
            if export then
                m.AddExport(name, FunctionType(funLabel, None))
            else
                m

        let funcPointer, index, ptr_label = createFunctionPointer funLabel env m

        /// Storage info where the name of the compiled function points to the
        /// label 'funLabel'
        let funcref = env.VarStorage.Add(name, Storage.Global ptr_label)
        let env' = { env with VarStorage = funcref }

        // add each arg to var storage (all local vars)
        let env'' = addArgsToEnv env' args

        /// Names of the lambda term arguments
        let argNames, _ = List.unzip args
        /// List of pairs associating each function argument to its type
        let argNamesTypes = List.zip argNames targs

        let captured = Set.toList (ASTUtil.capturedVars node)

        let env'' =
            if isTopLevel env then
                env''
            else
                addCapturedToEnv env'' captured

        /// Compiled function body
        let bodyCode: Module =
            compileFunction funLabel argNamesTypes body env'' (Module()) captured

        let closure =
            if isTopLevel env then
                Module()
            else
                let closureModule = (createClosure env' node index funcPointer captured)

                closureModule
                    .ResetAccCode()
                    .AddCode([ GlobalSet(Named(ptr_label), closureModule.GetAccCode()) ])

        let scopeModule: Module = (doCodegen env' scope funcPointer)

        // Set the function pointer to the closure struct
        bodyCode + closure + scopeModule

    | LetRec(name, tpe, init, scope, export) ->
        doCodegen
            env
            { node with
                Expr = Let(name, tpe, init, scope, export) }
            m
    | Pointer _ -> failwith "BUG: pointers cannot be compiled (by design!)"
    | AST.Type(name, def, scope) ->
        if env.Config.AllocationStrategy = Heap then
            let result = resolvePretype node.Env def

            match result with
            | Ok(t) ->
                match (expandType node.Env t) with
                | TStruct(fields) ->
                    //let td = createStructType fields
                    let typeParams: Param list =
                        List.map (fun (name, t: Type) -> (Some(name), ((mapTypeHeap t), Mutable))) fields

                    let fieldTypes = List.map (fun (n, t) -> (n, mapTypeHeap t)) fields
                    let id = GenStructTypeIDType fieldTypes
                    let td = StructType(name, typeParams)
                    (doCodegen env scope m).AddTypedef(td)
                | TArray(t) ->
                    let id = GenArrayTypeIDType(mapTypeHeap t)
                    let td = ArrayType(name, mapTypeHeap t)
                    (doCodegen env scope m).AddTypedef(td)
                | _ -> (doCodegen env scope m)
            | Error(e) -> doCodegen env scope m
        else
            doCodegen env scope m
    // struct constructor
    | Struct(fields) when env.Config.AllocationStrategy = Heap ->
        let fieldNodes = List.map (fun (_, t) -> t) fields

        // fold over fields and add them to struct with indexes
        let folder =
            fun (acc: Module) (fieldInit: TypedAST) ->
                // initialize field
                let initField = doCodegen env fieldInit m
                // accumulate code
                acc ++ initField

        let fieldsInitCode = List.fold folder m fieldNodes

        let fieldTypes =
            List.map (fun (n, t: Node<TypingEnv, Type>) -> (n, mapTypeHeap (expandType t.Env t.Type))) fields

        fieldsInitCode
            .ResetAccCode()
            .AddTypedef(createStructTypeNode fieldTypes)
            .AddCode(
                [ (StructNew(Named(GenStructTypeID fieldTypes), fieldsInitCode.GetAccCode()),
                   "leave ref of struct on stack") ]
            )
    | Struct(fields) ->
        let fieldNames = List.map (fun (n, _) -> n) fields
        let fieldTypes = List.map (fun (_, t) -> t) fields

        let structName = env.SymbolController.genSymbol $"Sptr"

        // calculate size of struct (each field is 4 bytes)
        let size = List.length fields

        // allocate memory for struct in dynamic memory
        let allocate =
            match env.Config.AllocationStrategy with
            | External ->
                m
                    .AddImport(getImport "malloc")
                    .AddLocals([ (Some(Identifier(structName)), I32) ])
                    .AddCode(
                        [ (LocalSet(
                              Named(structName),
                              [ (I32Const(size * 4), "size of struct")
                                (Call "malloc", "call malloc function") ]
                           ),
                           "set struct pointer var") ]
                    )
            | Internal ->
                m
                    .AddLocals([ (Some(Identifier(structName)), I32) ])
                    .AddCode(checkMemory [ (I32Const(size * 4), "size of struct") ])
                    .AddCode(
                        [ (LocalSet(
                              Named(structName),
                              [ (GlobalGet(Named(heapBase)), "leave current heap base address")
                                (GlobalSet(
                                    Named(heapBase),
                                    [ (I32Add(
                                          [ (GlobalGet(Named(heapBase)), "get current heap base")
                                            (I32Const(size * 4), "size of struct") ]
                                       ),
                                       "add size to heap base") ]
                                 ),
                                 "set base pointer") ]
                           ),
                           "set struct pointer var") ]
                    )
            | Heap -> failwith "WasmGC is not implemented in this case"

        // fold over fields and add them to struct with indexes
        let folder =
            fun (acc: Module) (fieldOffset: int, fieldName: string, fieldInit: TypedAST) ->

                // calculate offset of field in bytes
                let fieldOffsetBytes = fieldOffset * 4

                // initialize field
                let initField = doCodegen env fieldInit m

                // add comment to init field
                let initField' = C [ Comment $"init field ({fieldName})" ] ++ initField

                // instr based on type of field
                // store field in memory
                let instr =
                    match (expandType fieldInit.Env fieldInit.Type) with
                    | t when (isSubtypeOf fieldInit.Env t TUnit) -> [] // Nothing to do
                    | t when (isSubtypeOf fieldInit.Env t TFloat) ->
                        [ (F32Store(
                              [ (I32Add(
                                    [ (LocalGet(Named(structName)), "get struct pointer var")
                                      (I32Const fieldOffsetBytes, "push field offset to stack") ]
                                 ),
                                 "add offset to base address") ]
                              @ initField'.GetAccCode()
                           ),
                           "store int field in memory") ]
                    | _ ->
                        [ (I32Store(
                              [ (I32Add(
                                    [ (LocalGet(Named(structName)), "get struct pointer var")
                                      (I32Const fieldOffsetBytes, "push field offset to stack") ]
                                 ),
                                 "add offset to base address") ]
                              @ initField'.GetAccCode()
                           ),
                           "store int field in memory") ]

                // accumulate code
                acc ++ initField.ResetAccCode().AddCode(instr)

        let fieldsInitCode =
            List.fold folder m (List.zip3 [ 0 .. fieldNames.Length - 1 ] fieldNames fieldTypes)

        let combined =
            allocate
            ++ fieldsInitCode.AddCode([ (LocalGet(Named(structName)), "push struct address to stack") ])

        C [ Comment "start of struct contructor" ]
        ++ combined.AddCode(C [ Comment "end of struct contructor" ])
    | FieldSelect(target, field) when env.Config.AllocationStrategy = Heap ->
        let selTargetCode = doCodegen env target m

        let fieldAccessCode =
            match (expandType target.Env target.Type) with
            | TStruct(fields) ->
                let fieldNames, _ = List.unzip fields
                let offset = List.findIndex (fun f -> f = field) fieldNames
                let fieldTypes = List.map (fun (n, t) -> (n, mapTypeHeap t)) fields

                [ (StructGet(Named(GenStructTypeIDType fieldTypes), Index(offset), selTargetCode.GetAccCode()),
                   $"load field: {field}") ]
            | t -> failwith $"BUG: FieldSelect codegen on invalid target type: %O{t}"

        // Put everything together: compile the target, access the field
        selTargetCode.ResetAccCode()
        ++ m.AddCode(
            C [ Comment "Start of field select" ]
            @ fieldAccessCode
            @ C [ Comment "End of field select" ]
        )
    | FieldSelect(target, field) ->
        let selTargetCode = doCodegen env target m

        let fieldAccessCode =
            match (expandType target.Env target.Type) with
            | TStruct(fields) ->
                let fieldNames, fieldTypes = List.unzip fields
                let offset = List.findIndex (fun f -> f = field) fieldNames

                // Retrieve value of struct field
                match fieldTypes[offset] with
                | t when (isSubtypeOf target.Env t TUnit) -> [] // Nothing to do
                | t when (isSubtypeOf target.Env t TFloat) ->
                    [ (F32Load_(None, Some(offset * 4), selTargetCode.GetAccCode()), $"load field: {fieldNames[offset]}") ]
                | _ ->
                    [ (I32Load_(None, Some(offset * 4), selTargetCode.GetAccCode()), $"load field: {fieldNames[offset]}") ]

            | t -> failwith $"BUG: FieldSelect codegen on invalid target type: %O{t}"

        // Put everything together: compile the target, access the field
        selTargetCode.ResetAccCode()
        ++ m.AddCode(
            C [ Comment "Start of field select" ]
            @ fieldAccessCode
            @ C [ Comment "End of field select" ]
        )
    | _ -> failwith "not implemented"

/// create a function signature from a type
and internal typeToFuncSiganture (env: CodegenEnv) (t: Type.Type) =
    match t with
    | TFun(args, ret) ->

        // map args to there types
        let argTypes: Local list =
            List.map
                (fun t ->
                    match t with
                    | TUnion _ -> (None, I32)
                    | TVar _ -> (None, I32)
                    | TFun _ -> (None, I32) // passing function as a index to function table
                    | TStruct(fields) when env.Config.AllocationStrategy = Heap ->
                        let fieldTypes = List.map (fun (n, t) -> (n, mapTypeHeap t)) fields
                        (None, Ref(Named(GenStructTypeIDType fieldTypes)))
                    | TArray t when env.Config.AllocationStrategy = Heap ->
                        (None, Ref(Named(GenArrayTypeIDType(mapTypeHeap t))))
                    | TStruct _ -> (None, I32)
                    | TArray _ -> (None, I32)
                    | TInt -> (None, I32)
                    | TFloat -> (None, F32)
                    | TBool -> (None, I32)
                    | TString -> (None, I32)
                    | TAny -> (None, EqRef)
                    | TUnit -> failwith "a function cannot have a unit argument")
                args

        let funcPointerStruct =
            if env.Config.AllocationStrategy = Heap then
                let closureType = GenStructTypeIDType(List.map (fun (_, x) -> ("", x)) argTypes)
                Ref(Named(GenStructTypeIDType [ ("", I32); ("", Ref(Named(closureType))) ]))
            else
                I32

        // added cenv var to args to pass closure env
        let argTypes': Local list = (None, funcPointerStruct) :: argTypes
        let signature: FunctionSignature = (argTypes', mapType ret)

        signature
    | _ -> failwith "type is not a function"

/// Compile a function with its arguments, body and return the resulting module
and internal compileFunction
    (name: string)
    (args: List<string * Type.Type>)
    (body: TypedAST)
    (env: CodegenEnv)
    (m: Module)
    (captured: string list)
    : Module =

    let funcPointerStruct = if env.Config.AllocationStrategy = Heap then Eq else I32

    // map args to there types
    let argTypes': Local list =
        (Some("cenv"), funcPointerStruct) :: (argsToLocals env args)

    let signature: FunctionSignature =
        (argTypes',
         if env.Config.AllocationStrategy = Heap then
             [ mapTypeHeap body.Type ]
         else
             mapType body.Type)

    // add cenv type def of a function pointer
    let cenvHeapTypeDef =
        if env.Config.AllocationStrategy = Heap then
            Module()
                .AddTypedef(
                    StructType(
                        GenStructTypeIDType [ ("func", (I32)); ("cenv", (EqRef)) ],
                        [ (Some("func"), (I32, Mutable)); (Some("cenv"), (EqRef, Mutable)) ]
                    )
                )
        else
            Module()

    // compile function body
    let m': Module = cenvHeapTypeDef ++ doCodegen { env with CurrFunc = name } body m

    // create function instance
    let f: Commented<FunctionInstance> =
        ({ locals = m'.GetLocals()
           signature = signature
           body = m'.GetAccCode()
           name = Some(Identifier(name)) },
         $"function {name}")

    // add code and locals to function
    m'
        .AddFunction(name, f, true) // add function to module
        .ResetAccCode() // reset accumulated code
        .ResetLocals() // reset locals

and internal createClosure (env: CodegenEnv) (node: TypedAST) (index: int) (m: Module) (capturedList: string list) =

    let resolveNode n =
        let t =
            if (Set.contains n node.Env.Mutables) then
                TStruct([ ("value", node.Env.Vars[n]) ]) // mutable vars are stored in a struct after closure conversion
            else
                node.Env.Vars[n]

        { node with Expr = Var(n); Type = t }

    // map captured to a list of string * TypedAST where the string is the name of the captured variable
    let capturedStructFields = List.map (fun n -> (n, resolveNode n)) capturedList

    // struct that contains env and function pointer
    let returnStruct =
        { node with
            Expr =
                Struct(
                    [ ("func",
                       { node with
                           Expr = IntVal(index) // function pointer
                           Type = TInt })
                      ("cenv",
                       { node with
                           Expr = Struct(capturedStructFields)
                           Type = TAny }) ]

                )
            Type = TStruct([ ("func", TInt); ("cenv", TAny) ]) }

    doCodegen env returnStruct m

/// function that recursively propagates the AST and substitutes all local get and set instructions of a specific variable
/// with global get and set instructions
/// this is used to upgrade local variables to global variables
/// this is needed for the closure implementation
let rec localSubst (code: Commented<WGF.Instr.Wasm> list) (var: string) : Commented<WGF.Instr.Wasm> list =
    match code with
    | [] -> code // end of code
    | (LocalGet(Named(n)), c) :: rest when n = var ->
        [ (GlobalGet(Named(n)), c + ", have been hoisted") ] @ localSubst rest var
    | (LocalSet(Named(n), instrs), c) :: rest when n = var ->
        [ (GlobalSet(Named(n), localSubst instrs var), c + ", have been hoisted") ]
        @ localSubst rest var
    | (LocalTee(Named(n), instrs), c) :: rest when n = var ->
        [ (GlobalSet(Named(n), localSubst instrs var), c + ", have been hoisted")
          (GlobalGet(Named(n)), c + ", have been hoisted") ]
        @ localSubst rest var
    // block instructions
    | (Block(l, vt, instrs), c) :: rest -> [ (Block(l, vt, (localSubst instrs var)), c) ] @ localSubst rest var
    | (Loop(l, vt, instrs), c) :: rest -> [ (Loop(l, vt, (localSubst instrs var)), c) ] @ localSubst rest var
    | (If(l, cond, instrs1, instrs2), c) :: rest ->
        match instrs2 with
        | None ->
            [ (If(l, (localSubst cond var), (localSubst instrs1 var), instrs2), c) ]
            @ localSubst rest var
        | Some(instrs2) ->
            [ (If(l, (localSubst cond var), (localSubst instrs1 var), Some(localSubst instrs2 var)), c) ]
            @ localSubst rest var
    // nested instructions
    | (I32Add(instrs), c) :: rest -> [ (I32Add(localSubst instrs var), c) ] @ localSubst rest var
    | (I32Sub(instrs), c) :: rest -> [ (I32Sub(localSubst instrs var), c) ] @ localSubst rest var
    | (I32Mul(instrs), c) :: rest -> [ (I32Mul(localSubst instrs var), c) ] @ localSubst rest var
    | (I32DivS(instrs), c) :: rest -> [ (I32DivS(localSubst instrs var), c) ] @ localSubst rest var
    | (I32RemS(instrs), c) :: rest -> [ (I32RemS(localSubst instrs var), c) ] @ localSubst rest var
    | (I32And(instrs), c) :: rest -> [ (I32And(localSubst instrs var), c) ] @ localSubst rest var
    | (I32Or(instrs), c) :: rest -> [ (I32Or(localSubst instrs var), c) ] @ localSubst rest var
    | (I32Xor(instrs), c) :: rest -> [ (I32Xor(localSubst instrs var), c) ] @ localSubst rest var
    | (F32Add(instrs), c) :: rest -> [ (F32Add(localSubst instrs var), c) ] @ localSubst rest var
    | (F32Sub(instrs), c) :: rest -> [ (F32Sub(localSubst instrs var), c) ] @ localSubst rest var
    | (F32Mul(instrs), c) :: rest -> [ (F32Mul(localSubst instrs var), c) ] @ localSubst rest var
    | (F32Div(instrs), c) :: rest -> [ (F32Div(localSubst instrs var), c) ] @ localSubst rest var
    | (I32LeS(instrs), c) :: rest -> [ (I32LeS(localSubst instrs var), c) ] @ localSubst rest var
    | (F32Le(instrs), c) :: rest -> [ (F32Le(localSubst instrs var), c) ] @ localSubst rest var
    | (I32Eq(instrs), c) :: rest -> [ (I32Eq(localSubst instrs var), c) ] @ localSubst rest var
    | (F32Eq(instrs), c) :: rest -> [ (F32Eq(localSubst instrs var), c) ] @ localSubst rest var
    | (I32Eqz(instrs), c) :: rest -> [ (I32Eqz(localSubst instrs var), c) ] @ localSubst rest var
    | (LocalSet(Named(n), instrs), c) :: rest when n <> var ->
        [ (LocalSet(Named(n), localSubst instrs var), c) ] @ localSubst rest var
    | (LocalTee(Named(n), instrs), c) :: rest when n <> var ->
        [ (LocalTee(Named(n), localSubst instrs var), c) ] @ localSubst rest var
    | (GlobalSet(Named(n), instrs), c) :: rest when n <> var ->
        [ (GlobalSet(Named(n), localSubst instrs var), c) ] @ localSubst rest var
    | (I32Load(instrs), c) :: rest -> [ (I32Load(localSubst instrs var), c) ] @ localSubst rest var
    | (I32Load_(align, offset, instrs), c) :: rest ->
        [ (I32Load_(align, offset, localSubst instrs var), c) ] @ localSubst rest var
    | (F32Load(instrs), c) :: rest -> [ (F32Load(localSubst instrs var), c) ] @ localSubst rest var
    | (F32Load_(align, offset, instrs), c) :: rest ->
        [ (F32Load_(align, offset, localSubst instrs var), c) ] @ localSubst rest var
    | (I32GtS(instrs), c) :: rest -> [ (I32GtS(localSubst instrs var), c) ] @ localSubst rest var
    | (I32LtS(instrs), c) :: rest -> [ (I32LtS(localSubst instrs var), c) ] @ localSubst rest var
    | (I32GeS(instrs), c) :: rest -> [ (I32GeS(localSubst instrs var), c) ] @ localSubst rest var
    | (CallIndirect(t, instrs), c) :: rest -> [ (CallIndirect(t, localSubst instrs var), c) ] @ localSubst rest var
    | (I32Store(instrs), c) :: rest -> [ (I32Store(localSubst instrs var), c) ] @ localSubst rest var
    | (I32Store_(align, offset, instrs), c) :: rest ->
        [ (I32Store_(align, offset, localSubst instrs var), c) ] @ localSubst rest var
    | (F32Store(instrs), c) :: rest -> [ (F32Store(localSubst instrs var), c) ] @ localSubst rest var
    | (F32Store_(align, offset, instrs), c) :: rest ->
        [ (F32Store_(align, offset, localSubst instrs var), c) ] @ localSubst rest var
    | (MemoryGrow(instrs), c) :: rest -> [ (MemoryGrow(localSubst instrs var), c) ] @ localSubst rest var
    | (BrIf(l, instrs), c) :: rest -> [ (BrIf(l, localSubst instrs var), c) ] @ localSubst rest var
    | (Drop(instrs), c) :: rest -> [ (Drop(localSubst instrs var), c) ] @ localSubst rest var
    | (StructNew(l, instrs), c) :: rest -> [ (StructNew(l, localSubst instrs var), c) ] @ localSubst rest var
    | (StructGet(l, offset, instrs), c) :: rest ->
        [ (StructGet(l, offset, localSubst instrs var), c) ] @ localSubst rest var
    | (StructSet(l, offset, instrs), c) :: rest ->
        [ (StructSet(l, offset, localSubst instrs var), c) ] @ localSubst rest var
    | (ArrayNew(l, instrs), c) :: rest -> [ (ArrayNew(l, localSubst instrs var), c) ] @ localSubst rest var
    | (ArrayGet(l, instrs), c) :: rest -> [ (ArrayGet(l, localSubst instrs var), c) ] @ localSubst rest var
    | (ArraySet(l, instrs), c) :: rest -> [ (ArraySet(l, localSubst instrs var), c) ] @ localSubst rest var
    | (ArrayLen(instrs), c) :: rest -> [ (ArrayLen(localSubst instrs var), c) ] @ localSubst rest var
    | (Null(l), c) :: rest -> [ (Null(l), c) ] @ localSubst rest var


    // keep all other instructions
    | instr :: rest -> [ instr ] @ localSubst rest var

let hoistingLocals (m: Module) (upgradeList: list<string>) : Module =
    // get all functions
    let funcs = m.GetAllFuncs()

    // for each function
    let funcs' =
        List.map
            (fun (name, (func, c)) ->
                // get all locals
                let locals = func.locals
                // get all instructions
                let instrs = func.body

                // substitute all local get and set instructions with global get and set instructions
                let instrs' = List.fold (fun acc n -> localSubst acc n) instrs upgradeList

                // remove all locals in upgradelist from module
                let locals': Local list =
                    List.filter
                        (fun (n, _) ->
                            match n with
                            | Some(n) -> not (List.contains n upgradeList)
                            | None -> true)
                        locals

                // return function with hoisted locals
                (name,
                 { func with
                     body = instrs'
                     locals = locals' }),
                c)
            funcs

    let allLocals =
        (List.fold (fun total (_, (func, _)) -> total @ func.locals) [] funcs)

    // find type of local
    let findType (name: string) =
        List.find
            (fun (n, _) ->
                match n with
                | Some(n) -> n = name
                | None -> false)
            allLocals

    // add all vars from upgradeList to global vars
    let globals =
        List.map
            (fun n ->

                let t = snd (findType n)

                let value =
                    match t with
                    | I32 -> I32Const 0
                    | F32 -> F32Const 0.0f
                    | Ref l -> Null l
                    | _ -> failwith "global type not supported"

                (n, (t, Mutable), (value, "")))
            upgradeList

    m.AddGlobals(globals).ReplaceFuncs(funcs')

/// add special implicit main function
/// as the entry point of the program
let codegen (node: TypedAST) (config: CompileConfig option) : Module =

    // _start function is the entry point of the program
    // _start name is a special name that is part of the WASI ABI.
    // https://github.com/WebAssembly/WASI/blob/main/legacy/application-abi.md
    let funcName = mainFunctionName

    // signature of main function
    // the main function has no arguments
    let signature: FunctionSignature = ([], mapType node.Type)

    let funcInstance: Commented<FunctionInstance> =
        ({ locals = List.Empty
           signature = signature
           body = List.Empty
           name = Some(Identifier(funcName)) },
         "entry point of program (main function)")

    let allocationStrategy =
        match config with
        | Some(c) -> c.AllocationStrategy
        | None -> Internal

    let si =
        match config with
        | Some(c) -> c.Si
        | None -> HyggeSI

    /// Environment used during code generation
    let env =
        { CurrFunc = funcName
          MemoryAllocator = StaticMemoryAllocator()
          TableController = TableController()
          SymbolController = SymbolController()
          VarStorage = Map.empty
          Config =
            { AllocationStrategy = allocationStrategy
              Si = si } }

    // add function to module and export it
    let m' =
        Module()
            .AddFunction(funcName, funcInstance)
            .AddExport(funcName, FunctionType(funcName, None))

    // compile main function
    let m = doCodegen env node m'

    // get the heap base pointer
    // the offset is the current position of the memory allocator
    // before this offset only static data is allocated
    let staticOffset: int = env.MemoryAllocator.GetAllocationPosition()
    let numOfStaticPages: int = env.MemoryAllocator.GetNumPages()

    let topLevelModule =
        m
            .AddMemory(("memory", Unbounded(numOfStaticPages))) // allocate memory need as unbounded memory
            .AddLocals(env.CurrFunc, m.GetLocals()) // set locals of function
            .AddInstrs(env.CurrFunc, [ Comment "execution start here:" ])
            .AddInstrs(env.CurrFunc, m.GetAccCode()) // add code of main function
            .AddInstrs(env.CurrFunc, [ Comment "if execution reaches here, the program is successful" ])
            .AddGlobal(
                (heapBase,
                 (I32,
                  if env.Config.AllocationStrategy = External then
                      Immutable
                  else
                      Mutable),
                 (I32Const staticOffset, ""))
            ) // add heap base pointer
            .AddGlobal((exitCode, (I32, Mutable), (I32Const 0, ""))) // add exit code
            .AddExport(heapBase + "_ptr", GlobalType("heap_base")) // export heap base pointer
            .AddExport(exitCode, GlobalType("exit_code")) // export exit code pointer
            .ResetAccCode() // reset accumulated code
            .ResetLocals() // reset locals

    // all top-level locals (in _start) are transformed to global vars
    let l = localsToID (m.GetLocals())

    let h = (Set.toList (Set(m.GetHostingList())))

    // hoist all top level locals to global vars
    hoistingLocals topLevelModule (h @ l)
