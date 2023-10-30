module hyggec.WASMCodegen

open AST
open Type
open Typechecker
open WGF.Module
open WGF.Types
open WGF.Utils
open System.Text
open SI

let errorExitCode = 42
let successExitCode = 0
let mainFunctionName = "_start"

/// Storage information for variables.
[<RequireQualifiedAccess; StructuralComparison; StructuralEquality>]
type internal Storage =
    /// local variable
    | local of label: string
    /// global variable
    | glob of label: string
    /// offset in bytes of element in structure
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
    [ (I32Const errorExitCode, "error exit code push to stack")
      (GlobalSet(Named("exit_code")), "set exit code")
      (Unreachable, "exit program") ]

type internal CodegenEnv =
    { CurrFunc: string
      ClosureFuncs: Set<string>
      MemoryAllocator: StaticMemoryAllocator
      TableController: TableController
      SymbolController: SymbolController
      VarStorage: Map<string, Storage> }

let internal createFunctionPointer (name: string) (env: CodegenEnv) (m: Module) =
    let ptr_label = $"{name}*ptr"

    // get the index of the function
    let funcindex = env.TableController.next ()

    // allocate memory for function pointer
    let ptr = env.MemoryAllocator.Allocate(4)

    let FunctionPointer =
        m
            .AddFuncRefElement(name, funcindex) // add function to function table
            .AddData(I32Const ptr, Util.intToHex funcindex) // index as hex string
            .AddGlobal((ptr_label, (I32, Mutable), (I32Const ptr)))

    // return compontents needed to create a function pointer
    (FunctionPointer, funcindex, ptr_label)

// map a hygge type to a wasm type
let mapType t =
    match t with
    | TUnit -> []
    | TInt -> [ I32 ]
    | TFloat -> [ F32 ]
    | TBool -> [ I32 ]
    | TString -> [ I32 ]
    | TStruct _ -> [ I32 ]
    | TUnion _ -> [ I32 ]
    | TArray _ -> [ I32 ]
    | TFun _ -> [ I32 ] // passing function as a index to function table
    | TVar _ -> [ I32 ]

/// look up variable in var env
let internal lookupVar (env: CodegenEnv) (e: TypedAST) =
    match e.Expr with
    | Var v ->
        match env.VarStorage.TryFind v with
        | Some(Storage.local l) -> Named(l)
        | Some(Storage.glob l) -> Named(l)
        | Some(Storage.Offset(o)) -> Index(o)
        | _ -> failwith "not implemented"
    | _ -> failwith "not implemented"

/// look up variable in var env
let internal lookupLabel (env: CodegenEnv) (name: string) =
    match env.VarStorage.TryFind name with
    | Some(Storage.local l) -> l
    | Some(Storage.glob l) -> l
    | _ -> failwith "not implemented"

let internal lookupLatestLocal (m: Module) =
    match List.last (m.GetLocals()) with
    | Some(n), _ -> n
    | None, _ -> failwith "failed to find name of the lastest local var"

let internal argsToLocals env args =
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
                VarStorage = env.VarStorage.Add(n, Storage.local l) })
        env
        args

let internal isTopLevel env = env.CurrFunc = mainFunctionName

let rec internal doCodegen (env: CodegenEnv) (node: TypedAST) (m: Module) : Module =
    match node.Expr with
    | UnitVal -> m
    | IntVal i -> m.AddCode([ (I32Const i, $"push %i{i} on stack") ])
    | BoolVal b -> m.AddCode([ I32Const(if b then 1 else 0) ])
    | FloatVal f -> m.AddCode([ F32Const f ])
    | StringVal s ->
        // allocate for struct like structure
        let ptr = env.MemoryAllocator.Allocate(2 * 4)

        // compute size of string in bytes
        let stringSizeInBytes = Encoding.BigEndianUnicode.GetByteCount(s)

        // allocate string in memory
        let daraPtr = env.MemoryAllocator.Allocate(stringSizeInBytes)

        // store data pointer and length in struct like structure
        let dataString = Util.dataString [ daraPtr; stringSizeInBytes ]

        m
            .AddData(I32Const(daraPtr), s) // store the string it self in memory
            .AddData(I32Const(ptr), dataString) // store pointer an length in memory
            .AddCode([ (I32Const(ptr), "leave pointer to string on stack") ])
    | StringLength e ->
        let m' = doCodegen env e m

        let instrs =
            m'.GetAccCode()
            @ [ (I32Load_(None, Some(4)), "load string length")
                // divide by 2 to get the number of characters
                (I32Const 1, "push 1 on stack") // or i32.const 2
                (I32ShrS, "divide by 2") ] // or i32.div_s

        m'.ResetAccCode().AddCode(instrs)
    | Var v ->
        // load variable
        let instrs: List<Commented<Instr>> =
            match env.VarStorage.TryFind v with
            | Some(Storage.local l) -> [ (LocalGet(Named(l)), $"get local var: {l}") ] // push local variable on stack
            | Some(Storage.glob l) -> [ (GlobalGet(Named(l)), $"get global var: {l}") ] // push global variable on stack
            | Some(Storage.Offset(i)) -> // push variable from offset on stack
                // get load instruction based on type
                let li: Instr =
                    match (expandType node.Env node.Type) with
                    | t when (isSubtypeOf node.Env t TBool) -> I32Load_(None, Some(i * 4))
                    | t when (isSubtypeOf node.Env t TInt) -> I32Load_(None, Some(i * 4))
                    | t when (isSubtypeOf node.Env t TFloat) -> F32Load_(None, Some(i * 4))
                    | t when (isSubtypeOf node.Env t TString) -> I32Load_(None, Some(i * 4))
                    | _ -> I32Load_(None, Some(i * 4))

                [ (LocalGet(Index(0)), "get env pointer")
                  (li, $"load value at offset: {i * 4}") ]
            | _ -> failwith "could not find variable in var storage"

        m.AddCode(instrs)
    | PreIncr(e) ->
        let m' = doCodegen env e m

        let label = lookupVar env e

        let instrs =
            match (expandType e.Env e.Type) with
            | t when (isSubtypeOf e.Env t TInt) -> m'.GetAccCode() @ C [ I32Const 1; I32Add; LocalTee(label) ]
            | t when (isSubtypeOf e.Env t TFloat) -> m'.GetAccCode() @ C [ F32Const 1.0f; F32Add; LocalTee(label) ]
            | _ -> failwith "not implemented"

        m'.ResetAccCode().AddCode(instrs)
    | PostIncr(e) ->
        let m' = doCodegen env e m

        let label = lookupVar env e

        let instrs =
            match (expandType e.Env e.Type) with
            | t when (isSubtypeOf e.Env t TInt) ->
                m'.GetAccCode() @ C [ LocalGet(label); I32Const 1; I32Add; LocalSet(label) ]
            | t when (isSubtypeOf e.Env t TFloat) ->
                m'.GetAccCode() @ C [ LocalGet(label); F32Const 1.0f; F32Add; LocalSet(label) ]
            | _ -> failwith "not implemented"

        m'.ResetAccCode().AddCode(instrs)
    | PreDcr(e) ->
        let m' = doCodegen env e m

        let label = lookupVar env e

        let instrs =
            match (expandType e.Env e.Type) with
            | t when (isSubtypeOf e.Env t TInt) -> m'.GetAccCode() @ C [ I32Const 1; I32Sub; LocalTee(label) ]
            | t when (isSubtypeOf e.Env t TFloat) -> m'.GetAccCode() @ C [ F32Const 1.0f; F32Sub; LocalTee(label) ]
            | _ -> failwith "not implemented"

        m'.ResetAccCode().AddCode(instrs)
    | PostDcr(e) ->
        let m' = doCodegen env e m

        let label = lookupVar env e

        let instrs =
            match (expandType e.Env e.Type) with
            | t when (isSubtypeOf e.Env t TInt) ->
                m'.GetAccCode() @ C [ LocalGet(label); I32Const 1; I32Sub; LocalSet(label) ]
            | t when (isSubtypeOf e.Env t TFloat) ->
                m'.GetAccCode() @ C [ LocalGet(label); F32Const 1.0f; F32Sub; LocalSet(label) ]
            | _ -> failwith "not implemented"

        m'.ResetAccCode().AddCode(instrs)
    | MinAsg(lhs, rhs)
    | DivAsg(lhs, rhs)
    | MulAsg(lhs, rhs)
    | RemAsg(lhs, rhs)
    | AddAsg(lhs, rhs) ->
        let lhs' = doCodegen env lhs m
        let rhs' = doCodegen env rhs m

        let opCode =
            match (expandType node.Env node.Type) with
            | t when (isSubtypeOf node.Env t TInt) ->
                match node.Expr with
                | AddAsg _ -> I32Add
                | MinAsg _ -> I32Sub
                | MulAsg _ -> I32Mul
                | DivAsg _ -> I32DivS
                | RemAsg _ -> I32RemS
                | _ -> failwith "failed to find numeric int operation"
            | t when (isSubtypeOf node.Env t TFloat) ->
                match node.Expr with
                | AddAsg _ -> F32Add
                | MinAsg _ -> F32Sub
                | MulAsg _ -> F32Mul
                | DivAsg _ -> F32Div
                | _ -> failwith "failed to find numeric float operation"
            | _ -> failwith "failed to find numeric operation"

        let label = lookupVar env lhs

        let instrs =
            match (expandType node.Env node.Type) with
            | t when (isSubtypeOf node.Env t TInt) ->
                lhs'.GetAccCode() @ rhs'.GetAccCode() @ C [ opCode; LocalTee(label) ]
            | t when (isSubtypeOf node.Env t TFloat) ->
                lhs'.GetAccCode() @ rhs'.GetAccCode() @ C [ opCode; LocalTee(label) ]
            | _ -> failwith "not implemented"

        (lhs' + rhs').ResetAccCode().AddCode(instrs)
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
                | Max _ -> m'.GetAccCode() @ m''.GetAccCode() @ C [ I32GtS; Select ]
                | Min _ -> m'.GetAccCode() @ m''.GetAccCode() @ C [ I32LtS; Select ]
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
            | _ -> failwith "failed to find numeric operation"

        (lhs' + rhs').AddCode([ opCode ])
    | And(e1, e2) ->
        let m' = doCodegen env e1 m
        let m'' = doCodegen env e2 m
        (m' + m'').AddCode([ I32And ])
    | Or(e1, e2) ->
        let m' = doCodegen env e1 m
        let m'' = doCodegen env e2 m
        (m' + m'').AddCode([ I32Or ])
    | Not(e) -> (doCodegen env e m).AddCode([ I32Eqz ])
    | Greater(e1, e2) ->
        let m' = doCodegen env e1 m
        let m'' = doCodegen env e2 m

        // find type of e1 and e2 and check if they are equal
        let opcode =
            match (expandType e1.Env e1.Type) with
            | t1 when (isSubtypeOf e1.Env t1 TInt) -> [ I32GtS ]
            | t1 when (isSubtypeOf e1.Env t1 TFloat) -> [ F32Gt ]
            | t1 when (isSubtypeOf e1.Env t1 TBool) -> [ I32GtS ]
            | _ -> failwith "type mismatch"

        (m' + m'').AddCode(opcode)
    | Eq(e1, e2) ->
        let m' = doCodegen env e1 m
        let m'' = doCodegen env e2 m

        // find type of e1 and e2 and check if they are equal
        let opcode =
            match (expandType e1.Env e1.Type) with
            | t1 when (isSubtypeOf e1.Env t1 TInt) -> [ I32Eq ]
            | t1 when (isSubtypeOf e1.Env t1 TFloat) -> [ F32Eq ]
            | t1 when (isSubtypeOf e1.Env t1 TBool) -> [ I32Eq ]
            | _ -> failwith "type mismatch"

        let instrs = m'.GetAccCode() @ m''.GetAccCode() @ C opcode
        (m + m'.ResetAccCode() + m''.ResetAccCode()).AddCode(instrs)
    | Xor(e1, e2) ->
        let m' = doCodegen env e1 m
        let m'' = doCodegen env e2 m
        let instrs = [ I32Xor ]
        (m' + m'').AddCode(instrs)
    | Less(e1, e2) ->
        let m' = doCodegen env e1 m
        let m'' = doCodegen env e2 m

        // find type of e1 and e2 and check if they are equal
        let opcode =
            match (expandType e1.Env e1.Type) with
            | t1 when (isSubtypeOf e1.Env t1 TInt) -> [ I32LtS ]
            | t1 when (isSubtypeOf e1.Env t1 TFloat) -> [ F32Lt ]
            | t1 when (isSubtypeOf e1.Env t1 TBool) -> [ I32LtS ]
            | _ -> failwith "type mismatch"

        (m' + m'').AddCode(opcode)
    | LessOrEq(e1, e2) ->
        let m' = doCodegen env e1 m
        let m'' = doCodegen env e2 m

        // find type of e1 and e2 and check if they are equal
        let opcode =
            match (expandType e1.Env e1.Type) with
            | t1 when (isSubtypeOf e1.Env t1 TInt) -> [ I32LeS ]
            | t1 when (isSubtypeOf e1.Env t1 TFloat) -> [ F32Le ]
            | t1 when (isSubtypeOf e1.Env t1 TBool) -> [ I32LeS ]
            | _ -> failwith "type mismatch"

        (m' + m'').AddCode(opcode)
    | GreaterOrEq(e1, e2) ->
        let m' = doCodegen env e1 m
        let m'' = doCodegen env e2 m

        // find type of e1 and e2 and check if they are equal
        let opcode =
            match (expandType e1.Env e1.Type) with
            | t1 when (isSubtypeOf e1.Env t1 TInt) -> [ I32GeS ]
            | t1 when (isSubtypeOf e1.Env t1 TFloat) -> [ F32Ge ]
            | t1 when (isSubtypeOf e1.Env t1 TBool) -> [ I32GeS ]
            | _ -> failwith "type mismatch"

        (m' + m'').AddCode(opcode)
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
    | Print e ->
        // TODO: make print and println different
        let m' = doCodegen env e m

        match (expandType e.Env e.Type) with
        | t when (isSubtypeOf node.Env t TFloat) ->
            // perform host (system) call
            m'
                .AddImport(getImport "writeFloat") // import writeF function
                .AddCode([ (Call "writeFloat", "call host function") ])
        | t when (isSubtypeOf node.Env t TString) ->
            // import writeS function
            let m'' =
                m
                    .AddImport(getImport "writeS")
                    .AddCode(
                        // push string pointer to stack
                        m'.GetAccCode()
                        @ [ (I32Load, "Load string pointer") ]
                        @ m'.GetAccCode()
                        @ [
                            // (I32Const 4, "length offset")
                            // (I32Add, "add offset to pointer")
                            (I32Load_(None, Some(4)), "Load string length") ]
                    )

            // perform host (system) call
            (m'.ResetAccCode() ++ m'').AddCode([ (Call "writeS", "call host function") ])
        | _ ->
            // import writeInt function
            let m'' = m'.AddImport(getImport "writeInt")
            // perform host (system) call
            m''.AddCode([ (Call "writeInt", "call host function") ])
    | AST.If(condition, ifTrue, ifFalse) ->
        let m' = doCodegen env condition m
        let m'' = doCodegen env ifTrue m
        let m''' = doCodegen env ifFalse m

        // get the return type of the ifTrue branch and subsequently the ifFalse branch
        let resultType = (expandType node.Env node.Type)

        let instrs =
            m'.GetAccCode()
            @ C [ (If(mapType resultType, m''.GetAccCode(), Some(m'''.GetAccCode()))) ]

        (m' + m'' + m''').ResetAccCode().AddCode(instrs)
    | Assertion(e) ->
        let m' = doCodegen env e (m.ResetAccCode())

        let instrs =
            m'.GetAccCode()
            // invert assertion
            @ [ (I32Eqz, "invert assertion") ]
            @ C [ (If([], trap, None)) ]

        m'.ResetAccCode().AddCode(instrs)
    | Application(expr, args) ->
        /// compile arguments
        let argm = List.fold (fun m arg -> m + doCodegen env arg (m.ResetAccCode())) m args

        /// generate code for the expression for the function to be applied
        let exprm: Module = (doCodegen env expr m)

        // type to function signature
        let typeId = GenFuncTypeID(typeToFuncSiganture (expandType expr.Env expr.Type))

        argm
            .ResetAccCode()
            .AddCode([ Comment "Load expression to be applied as a function" ])
            .AddCode(
                exprm.GetAccCode() // load closure environment pointer as first argument
                @ [ (I32Load_(None, Some(4)), "load closure environment pointer") ]
                @ argm.GetAccCode() // load the rest of the arguments
                @ exprm.GetAccCode() // load function pointer
                @ [ (I32Load, "load table index")
                    (CallIndirect(Named(typeId)), "call function") ]
            )

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
            compileFunction
                funLabel
                argNamesTypes
                body
                { env'' with
                    ClosureFuncs = env.ClosureFuncs.Add(funLabel) }
                funcPointer

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
                    m + doCodegen env node (m.ResetAccCode())
                else
                    // return node
                    match node.Type with
                    | TUnit -> m + doCodegen env node (m.ResetAccCode())
                    | _ ->
                        // drop value if it is not needed
                        m + ((doCodegen env node (m.ResetAccCode())).AddCode([ Drop ])))
            m
            (List.indexed nodes)

    | While(cond, body) ->
        let cond' = doCodegen env cond m
        let body' = doCodegen env body m

        let exitl = env.SymbolController.genSymbol $"loop_exit"
        let beginl = env.SymbolController.genSymbol $"loop_begin"

        let loop =
            C
                [ Loop(
                      beginl,
                      [],
                      cond'.GetAccCode()
                      @ C [ I32Eqz; BrIf exitl ]
                      @ body'.GetAccCode()
                      @ C [ Br beginl ]
                  ) ]

        let block = C [ (Block(exitl, [], loop)) ]

        (cond'.ResetAccCode() + body'.ResetAccCode()).AddCode(block)

    | DoWhile(cond, body) ->
        (doCodegen env body m)
        ++ (doCodegen env { node with Expr = While(cond, body) } m)

    | For(init, cond, update, body) ->
        (doCodegen env init m)
        ++ (doCodegen
                env
                { node with
                    Expr =
                        While(
                            cond,
                            { node with
                                Expr = Seq([ body; update ]) }
                        ) }
                m)
    | Array(length, data) ->
        let length' = doCodegen env length m
        let data' = doCodegen env data m

        // check that length is bigger then 1 - if not return 42
        let lengthCheck =
            length'.GetAccCode()
            @ [ (I32Const 1, "put one on stack")
                (I32LeS, "check if length is <= 1")
                (If([], trap, None), "check that length of array is bigger then 1 - if not return 42") ]

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
            structm // pointer to struct on stack
                .AddLocals([ (Some(Identifier(structPointerLabel)), I32) ]) // add local var
                .AddCode([ (LocalSet(Named(structPointerLabel)), "set struct pointer var") ]) // set struct pointer var

        let allocation = // allocate memory for array, return pointer to allocated memory
            length' // length of array on stack
                .AddImport(getImport "malloc") // import malloc function
                .AddCode(
                    [ (I32Const 4, "4 bytes")
                      (I32Mul, "multiply length with 4 to get size")
                      (Call "malloc", "call malloc function") ]
                )

        // set data pointer of struct
        let instr =
            [ (LocalGet(Named(structPointerLabel)), "get struct pointer var") ]
            @ allocation.GetAccCode() // get pointer to allocated memory - value to store in data pointer field
            @ [ (I32Store, "store pointer to data") ]


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
            [ (Comment "start of loop body", "")
              (LocalGet(Named(structPointerLabel)), "get struct pointer var")
              (I32Load, "load data pointer")

              // find offset to element
              (LocalGet(Named(i)), "get index")
              (I32Const(4), "byte offset")
              (I32Mul, "multiply index with byte offset") // then offset is on top of stack

              // apply offset data pointer
              (I32Add, "add offset to base address") ] // then pointer to element is on top of stack
            @ data'.GetAccCode() // get value to store in allocated memory
            @ [ (storeInstr, "store value in elem pos"); (Comment "end of loop body", "") ]

        // loop that runs length times and stores data in allocated memory
        let loop =
            C
                [ Loop(
                      beginl,
                      [], // loops does not return anything
                      length'.GetAccCode()
                      @ [ (LocalGet(Named i), "get i") ]
                      @ C [ I32Eq; BrIf exitl ]
                      @ body
                      @ [ (LocalGet(Named i), "get i")
                          (I32Const(1), "increment by 1")
                          (I32Add, "add 1 to i")
                          (LocalSet(Named i), "write to i") ]
                      @ C [ Br beginl ]
                  ) ]

        // block that contains loop and provides a way to exit the loop
        let block: Commented<Instr> list =
            C [ I32Const 0; LocalSet(Named(i)) ] @ C [ (Block(exitl, [], loop)) ]

        let loopModule =
            data'.ResetAccCode().AddLocals([ (Some(Identifier(i)), I32) ]).AddCode(block)

        lengthCheck
        ++ structPointer.AddCode(instr)
        ++ loopModule.AddCode(
            [ (LocalGet(Named(structPointerLabel)), "leave pointer to allocated array struct on stack") ]
        )
    | ArrayLength(target) ->
        let m' = doCodegen env target m

        let instrs = m'.GetAccCode() @ [ (I32Load_(None, Some(4)), "load length") ]

        C [ Comment "start array length node" ]
        ++ m'.ResetAccCode().AddCode(instrs @ C [ Comment "end array length node" ])

    | ArrayElement(target, index) ->
        let m' = doCodegen env target m
        let m'' = doCodegen env index m

        // check that index is bigger then 0 - if not return 42
        // and that index is smaller then length - if not return 42
        let indexCheck =
            m''.GetAccCode() // index on stack
            @ [ (I32Const 0, "put zero on stack")
                (I32LtS, "check if index is >= 0")
                (If([], trap, None), "check that index is >= 0 - if not return 42") ]
            @ m''.GetAccCode() // index on stack
            @ m'.GetAccCode() // struct pointer on stack
            @ [ (I32Load_(None, Some(4)), "load length") ]
            @ [ (I32GeU, "check if index is < length")
                (If([], trap, None), "check that index is < length - if not return 42") ]

        // resolve load and store instruction based on type
        let loadInstr =
            match (expandType node.Env node.Type) with
            | t when (isSubtypeOf node.Env t TInt) -> I32Load
            | t when (isSubtypeOf node.Env t TFloat) -> F32Load
            | _ -> I32Load

        let instrs =
            m'.GetAccCode() // struct pointer on stack
            @ [ (I32Load, "load data pointer") ]
            @ m''.GetAccCode() // index on stack
            @ [ (I32Const 4, "byte offset")
                (I32Mul, "multiply index with byte offset")
                (I32Add, "add offset to base address") ]
            @ [ (loadInstr, "load value") ]

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
            startm.GetAccCode() // start on stack
            @ [ (I32Const 0, "put zero on stack")
                (I32LtS, "check if start is >= 0")
                (If([], trap, None), "check that start is >= 0 - if not return 42") ]
            @ startm.GetAccCode() // start on stack
            @ targetm.GetAccCode() // struct pointer on stack
            @ [ (I32Load_(None, Some(4)), "load length") ]
            @ [ (I32GeU, "check if start is < length")
                (If([], trap, None), "check that start is < length - if not return 42") ]

        // check that end is bigger then 0 - if not return 42
        // and that end is smaller then length of the original array - if not return 42
        // and end is bigger then start - if not return 42
        // and the difference between end and start should be at least 1 - if not return 42

        // check that end index is smaller then length of the original array - if not return 42
        let endCheck =
            endingm.GetAccCode() // end index on stack
            @ targetm.GetAccCode() // struct pointer on stack
            @ [ (I32Load_(None, Some(4)), "load length") ] // 4 is the offset to length field
            @ [ (I32GtU, "check if end is < length")
                (If([], trap, None), "check that end is < length - if not return 42") ]

        // difference between end and start should be at least 1
        let atleastOne =
            endingm.GetAccCode() // end on stack
            @ startm.GetAccCode() // start on stack
            @ [ (I32Sub, "subtract end from start") ]
            @ [ (I32Const 1, "put one on stack")
                (I32LtU, "check if difference is < 1")
                (If([], trap, None), "check that difference is <= 1 - if not return 42") ]

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
                .AddLocals([ (Some(Identifier(structPointerLabel)), I32) ]) // add local var
                .AddCode([ (LocalSet(Named(structPointerLabel)), "set struct pointer var") ]) // set struct pointer var

        // set data pointer of struct
        let instr =
            // here to store pointer to allocated memory
            [ (LocalGet(Named(structPointerLabel)), "get struct pointer var") ]

            // value to store in data pointer field
            @ targetm.GetAccCode() // pointer to exsisiting array struct on stack
            @ [ (I32Load, "Load data pointer from array struct") ]
            @ startm.GetAccCode() // index of start
            @ [ (I32Const 4, "offset of data field")
                (I32Mul, "multiply index with byte offset")
                (I32Add, "add offset to base address") ] // get pointer to allocated memory - value to store in data pointer field
            @ [ (I32Store, "store pointer to data") ]

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
                let scopeVarStorage = env.VarStorage.Add(var, Storage.local varName)

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
                    targetm.GetAccCode()
                    @ [ (loadInstr (None, Some(4)), "load data pointer")
                        (LocalSet(Named(varName)), "set local var") ]

                let caseCode =
                    dataPointer
                    ++ scope
                        // .AddLocals([ (Some(Identifier(var)), I32) ])
                        .AddCode([ (Br matchEndLabel, "break out of match") ])

                let condition =
                    targetm.GetAccCode()
                    @ [ (I32Load, "load label")
                        (I32Const id, $"put label id {id} on stack")
                        (I32Eq, "check if index is equal to target") ]

                // if case is not the last case
                let case = condition @ C [ (If([], caseCode.GetAccCode(), None)) ]

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
            | Some(Storage.local l) ->
                value'
                    .ResetAccCode()
                    .AddCode(value'.GetAccCode() @ [ (LocalTee(Named(l)), "set local var") ])
            | Some(Storage.Offset(i)) ->
                // get correct load and store instruction
                let li, si =
                    match (expandType value.Env value.Type) with
                    | t when (isSubtypeOf value.Env t TInt) ->
                        ((I32Load_(None, Some(i * 4)), "load value i32 from env"),
                         (I32Store_(None, Some(i * 4)), "store i32 value in env"))
                    | t when (isSubtypeOf value.Env t TFloat) ->
                        ((F32Load_(None, Some(i * 4)), "load value f32 from env"),
                         (F32Store_(None, Some(i * 4)), "store f32 value in env"))
                    | _ -> failwith "not implemented"

                let store = [ (LocalGet(Index(0)), "get env") ] @ value'.GetAccCode() @ [ si ]
                let load = [ (LocalGet(Index(0)), "get env") ] @ [ li ]

                value'.ResetAccCode().AddCode(store @ load)
            | _ -> failwith "not implemented"


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
                        selTargetCode.GetAccCode()
                        @ rhsCode.GetAccCode()
                        @ [ (F32Store_(None, Some(offset * 4)), "store float in struct") ]
                        // load value just to leave a value on the stack
                        @ selTargetCode.GetAccCode()
                        @ [ (F32Load_(None, Some(offset * 4)), "load float from struct") ]
                    | _ ->
                        selTargetCode.GetAccCode()
                        @ rhsCode.GetAccCode()
                        @ [ (I32Store_(None, Some(offset * 4)), "store int in struct") ]
                        // load value just to leave a value on the stack
                        @ selTargetCode.GetAccCode()
                        @ [ (I32Load_(None, Some(offset * 4)), "load int from struct") ]

                // Put everything together
                assignCode ++ (rhsCode.ResetAccCode() + selTargetCode.ResetAccCode())
            | _ -> failwith "failed to assign to field"
        | ArrayElement(target, index) ->
            let selTargetCode = doCodegen env target m
            let indexCode = doCodegen env index m

            let rhsCode = doCodegen env value m

            // Check index >= 0 and index < length
            let indexCheck =
                indexCode.GetAccCode() // index on stack
                @ [ (I32Const 0, "put zero on stack")
                    (I32LtS, "check if index is >= 0")
                    (If([], trap, None), "check that index is >= 0 - if not return 42") ]
                @ indexCode.GetAccCode() // index on stack
                @ selTargetCode.GetAccCode() // struct pointer on stack
                @ [ (I32Load_(None, Some(4)), "load length") ]
                @ [ (I32GeU, "check if index is < length")
                    (If([], trap, None), "check that index is < length - if not return 42") ]

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
                // store value in allocated memory
                selTargetCode.GetAccCode() // struct pointer on stack
                @ [ (I32Load, "load data pointer") ]
                @ indexCode.GetAccCode() // index on stack
                @ [ (I32Const 4, "byte offset")
                    (I32Mul, "multiply index with byte offset")
                    (I32Add, "add offset to base address") ]
                @ rhsCode.GetAccCode()
                @ [ (storeInstr, "store value in elem pos") ]
                // load value just to leave a value on the stack
                @ selTargetCode.GetAccCode() // struct pointer on stack
                @ [ (I32Load, "load data pointer") ]
                @ indexCode.GetAccCode() // index on stack
                @ [ (I32Const 4, "byte offset")
                    (I32Mul, "multiply index with byte offset")
                    (I32Add, "add offset to base address") ]
                @ [ (loadInstr, "load int from elem pos") ]

            (rhsCode.ResetAccCode() + indexCode.ResetAccCode() + selTargetCode.ResetAccCode())
                .AddCode(indexCheck @ instrs)
        | _ -> failwith "not implemented"
    | Ascription(_, node) ->
        // A type ascription does not produce code --- but the type-annotated
        // AST node does
        doCodegen env node m

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
        let funcref = env.VarStorage.Add(name, Storage.glob ptr_label)

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
        let bodyCode: Module = compileFunction funLabel argNamesTypes body env'' funcPointer

        let closure =
            if isTopLevel env then
                Module()
            else
                (createClosure env node index funcPointer captured)
                    .AddCode([ GlobalSet(Named(ptr_label)) ])

        let scopeModule: Module =
            (doCodegen
                { env with
                    VarStorage = funcref
                    ClosureFuncs = env.ClosureFuncs.Add(funLabel) }
                scope
                funcPointer)

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
                VarStorage = env.VarStorage.Add(name, Storage.local varName) }

        match (expandType init.Env init.Type) with
        | t when (isSubtypeOf init.Env t TUnit) -> m' ++ (doCodegen env scope m)
        | t when (isSubtypeOf init.Env t TInt) ->
            let varLabel = Named(varName)
            let initCode = m'.GetAccCode()

            let instrs =
                initCode // inizilize code
                @ [ (LocalSet varLabel, "set local var") ] // set local var

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

            let instrs =
                initCode // inizilize code
                @ [ (LocalSet varLabel, "set local var") ] // set local var

            let scopeCode = (doCodegen env' scope (m.ResetAccCode()))

            C [ Comment "Start of let" ]
            ++ m'.ResetAccCode()
            ++ (instrs ++ scopeCode)
                .AddLocals([ (Some(Identifier(varName)), F32) ])
                .AddCode([ Comment "End of let" ])
        | TFun _ ->
            // todo make function pointer
            let varLabel = Named(varName)

            // add var to func ref
            let env'' =
                { env' with
                    VarStorage = env.VarStorage.Add(name, Storage.local varName) }

            let initCode = m'.GetAccCode()

            let instrs =
                initCode // inizilize code
                @ [ (LocalSet varLabel, "set local var") ] // set local var

            let scopeCode = (doCodegen env'' scope (m.ResetAccCode()))

            let combi = (instrs ++ scopeCode)

            C [ Comment "Start of let" ]
            ++ m'.ResetAccCode()
            ++ combi
                .AddLocals([ (Some(Identifier(varName)), I32) ])
                .AddCode([ Comment "End of let" ])
        | TStruct _ ->
            let varLabel = Named(varName)
            let initCode = m'.GetAccCode()

            let instrs =
                initCode // inizilize code
                @ [ (LocalSet varLabel, "set local var") ] // set local var

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

            let instrs =
                initCode // inizilize code
                @ [ (LocalSet varLabel, "set local var") ] // set local var

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
        let funcref = env.VarStorage.Add(name, Storage.glob ptr_label)
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
            compileFunction
                funLabel
                argNamesTypes
                body
                { env'' with
                    ClosureFuncs = env.ClosureFuncs.Add(funLabel) }
                funcPointer

        let closure =
            if isTopLevel env then
                Module()
            else
                (createClosure env' node index funcPointer captured)
                    .AddCode([ GlobalSet(Named(ptr_label)) ])

        let scopeModule: Module =
            (doCodegen
                { env' with
                    ClosureFuncs = env.ClosureFuncs.Add(funLabel) }
                scope
                funcPointer)

        // Set the function pointer to the closure struct
        bodyCode + closure + scopeModule

    | LetRec(name, tpe, init, scope, export) ->
        doCodegen
            env
            { node with
                Expr = Let(name, tpe, init, scope, export) }
            m
    | Pointer _ -> failwith "BUG: pointers cannot be compiled (by design!)"
    | AST.Type(_, _, scope) ->
        // A type alias does not produce any code --- but its scope does
        doCodegen env scope m
    | Struct(fields) ->
        let fieldNames = List.map (fun (n, _) -> n) fields
        let fieldTypes = List.map (fun (_, t) -> t) fields

        let structName = env.SymbolController.genSymbol $"Sptr"

        // calculate size of struct (each field is 4 bytes)
        let size = List.length fields

        // allocate memory for struct in dynamic memory
        let allocate =
            m
                .AddImport(getImport "malloc")
                .AddLocals([ (Some(Identifier(structName)), I32) ])
                .AddCode(
                    [ (I32Const size, "size of struct")
                      (I32Const 4, "4 bytes")
                      (I32Mul, "multiply length with 4 to get size")
                      (Call "malloc", "call malloc function")
                      (LocalSet(Named(structName)), "set struct pointer var") ]
                )

        // fold over fields and add them to struct with indexes
        let folder =
            fun (acc: Module) (fieldOffset: int, fieldName: string, fieldInit: TypedAST) ->

                let fieldOffsetBytes = fieldOffset * 4

                // initialize field
                let initField = doCodegen env fieldInit m

                // add comment to init field
                let initField' = C [ Comment $"init field {fieldName}" ] ++ initField

                // instr based on type of field
                // store field in memory
                let instr =
                    match (expandType fieldInit.Env fieldInit.Type) with
                    | t when (isSubtypeOf fieldInit.Env t TUnit) -> [] // Nothing to do
                    | t when (isSubtypeOf fieldInit.Env t TFloat) ->
                        [ (LocalGet(Named(structName)), "get struct pointer var")
                          (I32Const fieldOffsetBytes, "push field offset to stack")
                          (I32Add, "add offset to base address") ]
                        @ initField'.GetAccCode()
                        @ [ (F32Store, $"store float field ({fieldName}) in memory") ]
                    | _ ->
                        [ (LocalGet(Named(structName)), "get struct pointer var")
                          (I32Const fieldOffsetBytes, "push field offset to stack")
                          (I32Add, "add offset to base address") ]
                        @ initField'.GetAccCode()
                        @ [ (I32Store, "store int field in memory") ]

                // accumulate code
                acc ++ initField.ResetAccCode().AddCode(instr)

        let fieldsInitCode =
            List.fold folder m (List.zip3 [ 0 .. fieldNames.Length - 1 ] fieldNames fieldTypes)

        let combined =
            allocate
            ++ fieldsInitCode.AddCode([ (LocalGet(Named(structName)), "push struct address to stack") ])

        C [ Comment "start of struct contructor" ]
        ++ combined.AddCode(C [ Comment "end of struct contructor" ])
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
                    selTargetCode.GetAccCode()
                    @ [ (F32Load_(None, Some(offset * 4)), $"load field: {fieldNames[offset]}") ]
                | _ ->
                    selTargetCode.GetAccCode()
                    @ [ (I32Load_(None, Some(offset * 4)), $"load field: {fieldNames[offset]}") ]

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
and typeToFuncSiganture (t: Type.Type) =
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
                    | TStruct _ -> (None, I32)
                    | TArray _ -> (None, I32)
                    | TInt -> (None, I32)
                    | TFloat -> (None, F32)
                    | TBool -> (None, I32)
                    | TString -> (None, I32)
                    | TUnit -> failwith "a function cannot have a unit argument")
                args


        // added cenv var to args to pass closure env
        let argTypes' = (None, I32) :: argTypes
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
    : Module =

    // map args to there types
    let argTypes': Local list = (Some("cenv"), I32) :: (argsToLocals env args)
    let signature: FunctionSignature = (argTypes', mapType body.Type)

    // compile function body
    let m': Module = doCodegen { env with CurrFunc = name } body m

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

    // all captured variables are stored in a struct
    let capturedVarsStruct =
        { node with
            Expr = Struct(capturedStructFields) }

    // generate code for struct
    let capturedVarsStructCode = doCodegen env capturedVarsStruct m

    // struct that contains env and function pointer
    let returnStruct =
        { node with
            Expr =
                Struct(
                    [ ("f",
                       { node with
                           Expr = IntVal(index) // function pointer
                           Type = TInt })
                      ("env",
                       { node with
                           Expr = IntVal(0) // env pointer, is later replaced with pointer to closure environment
                           Type = TInt }) ]
                ) }

    let returnStructModule = doCodegen env returnStruct m

    // get name local var that stores pointer to struct
    let localVarID = lookupLatestLocal returnStructModule

    let instr =
        returnStructModule.GetAccCode()
        @ [ (I32Const 4, "4 byte offset"); (I32Add, "add offset") ]
        @ capturedVarsStructCode.GetAccCode()
        @ [ (I32Store, "store poninter in return struct") ]
        @ [ (LocalGet(Named(localVarID)), "get pointer to return struct") ]


    (returnStructModule.ResetAccCode() + capturedVarsStructCode.ResetAccCode())
        .AddCode(instr) // pointer becomes value to store

/// function that recursively propagates the AST and substitutes all local get and set instructions of a specific variable
/// with global get and set instructions
/// this is used to upgrade local variables to global variables
/// this is needed for the closure implementation
let rec localSubst (code: Commented<Instr> list) (var: string) : Commented<Instr> list =
    match code with
    | [] -> code // end of code
    | (LocalGet(Named(n)), c) :: rest when n = var ->
        [ (GlobalGet(Named(n)), c + ", have been hoisted") ] @ localSubst rest var
    | (LocalSet(Named(n)), c) :: rest when n = var ->
        [ (GlobalSet(Named(n)), c + ", have been hoisted") ] @ localSubst rest var
    | (LocalTee(Named(n)), c) :: rest when n = var ->
        [ (GlobalSet(Named(n)), c + ", have been hoisted")
          (GlobalGet(Named(n)), c + ", have been hoisted") ]
        @ localSubst rest var
    // block instructions
    | (Block(l, vt, instrs), c) :: rest -> [ (Block(l, vt, (localSubst instrs var)), c) ] @ localSubst rest var
    | (Loop(l, vt, instrs), c) :: rest -> [ (Loop(l, vt, (localSubst instrs var)), c) ] @ localSubst rest var
    | (If(l, instrs1, instrs2), c) :: rest ->
        match instrs2 with
        | None -> [ (If(l, (localSubst instrs1 var), instrs2), c) ] @ localSubst rest var
        | Some(instrs2) ->
            [ (If(l, (localSubst instrs1 var), Some(localSubst instrs2 var)), c) ]
            @ localSubst rest var
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
                    | _ -> failwith "not implemented"

                (n, (t, Mutable), value))
            upgradeList

    m.AddGlobals(globals).ReplaceFuncs(funcs')

/// add special implicit main function
/// as the entry point of the program
let codegen (node: TypedAST) : Module =

    // _start function is the entry point of the program
    // _start name is a special name that is part of the WASI ABI.
    // https://github.com/WebAssembly/WASI/blob/main/legacy/application-abi.md
    let funcName = mainFunctionName

    // signature of main function
    // the main function has no arguments and returns an 32 bit integer
    let signature = ([], [ I32 ])

    let f: Commented<FunctionInstance> =
        ({ locals = List.Empty
           signature = signature
           body = List.Empty
           name = Some(Identifier(funcName)) },
         "entry point of program (main function)")

    /// Environment used during code generation
    let env =
        { CurrFunc = funcName
          MemoryAllocator = StaticMemoryAllocator()
          TableController = TableController()
          SymbolController = SymbolController()
          VarStorage = Map.empty
          ClosureFuncs = Set.empty }

    // add function to module and export it
    let m' =
        Module()
            .AddFunction(funcName, f)
            .AddExport(funcName, FunctionType(funcName, None))

    // compile main function
    let m = doCodegen env node m'

    // get the heap base pointer
    // the offset is the current position of the memory allocator
    // before this offset only static data is allocated
    let staticOffset: int = env.MemoryAllocator.GetAllocationPosition()
    let numOfStaticPages: int = env.MemoryAllocator.GetNumPages()

    let heapBase = "heap_base"
    let exitCode = "exit_code"

    let topLevelModule =
        m
            .AddMemory(("memory", Unbounded(numOfStaticPages))) // allocate memory need as unbounded memory
            .AddLocals(env.CurrFunc, m.GetLocals()) // set locals of function
            .AddInstrs(env.CurrFunc, [ Comment "execution start here:" ])
            .AddInstrs(env.CurrFunc, m.GetAccCode()) // add code of main function
            .AddInstrs(env.CurrFunc, [ Comment "if execution reaches here, the program is successful" ])
            .AddInstrs(env.CurrFunc, [ (I32Const successExitCode, "exit code 0"); (Return, "return the exit code") ]) // return 0 if program is successful
            .AddGlobal((heapBase, (I32, Immutable), (I32Const staticOffset))) // add heap base pointer
            .AddGlobal((exitCode, (I32, Mutable), (I32Const 0))) // add exit code
            .AddExport(heapBase + "_ptr", GlobalType("heap_base")) // export heap base pointer
            .AddExport(exitCode, GlobalType("exit_code")) // export exit code pointer
            .ResetAccCode() // reset accumulated code
            .ResetLocals() // reset locals

    // all top-level locals (in _start) are transformed to global vars
    let l = localsToID (m.GetLocals())

    let h = (Set.toList (Set(m.GetHostingList())))

    // hoist all top level locals to global vars
    hoistingLocals topLevelModule (h @ l)
