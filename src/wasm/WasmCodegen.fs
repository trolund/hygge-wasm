module WASMCodegen

open AST
open Type
open Typechecker
open Wat.WFG
open System.Text

let errorExitCode = 42
let successExitCode = 0

// adress and size
type Var =
    | GloVar of int * int
    | LocVar of int * int

/// Storage information for variables.
[<RequireQualifiedAccess; StructuralComparison; StructuralEquality>]
type internal Storage =
    // /// The variable is stored in an integerregister.
    // | Reg of reg: Reg
    // /// The variable is stored in a floating-point register.
    // | FPReg of fpreg: FPReg
    /// The variable is stored in memory, in a location marked with a
    /// label in the compiled assembly code.
    | Label of label: string
    /// This variable is stored on the stack, at the given offset (in bytes)
    /// from the memory address contained in the frame pointer (fp) register.
    | Offset of offset: int
    | Tabel of label: string * int
    | FuncRef of label: string * int

/// A memory allocator that allocates memory in pages of 64KB.
/// The allocator keeps track of the current allocation position.
type internal StaticMemoryAllocator() =

    let mutable allocationPosition = 0
    let pageSize = 64 * 1024 // 64KB

    // list of allocated memory
    let mutable allocatedMemory: List<int * int> = []

    // get head of allocated memory list
    member this.GetAllocated() = (allocatedMemory.Head)

    // 4 bytes stride
    member this.stride: int = 4

    // get number of pages needed to allocate size bytes
    member this.GetNumPages() =
        let numPages = allocationPosition / pageSize

        if allocationPosition % pageSize <> 0 then
            numPages + 1
        else
            numPages

    /// function that call the dynamic allocator with the number of bytes needed and return the start position
    /// Allocate in linear memory a block of 'size' bytes.
    /// will return the start position and size of the allocated memory
    member this.Allocate(size: int) =
        if size <= 0 then
            failwith "Size must be positive"

        let startPosition = allocationPosition

        // added to allocated memory
        allocatedMemory <- (startPosition, size) :: allocatedMemory

        allocationPosition <- allocationPosition + size
        (startPosition * this.stride, size * this.stride)

    member this.GetAllocationPosition() = allocationPosition

// function that repeat code pattern and accumulate it
let rec repeat (n: int) (f: int -> List<Commented<Instr>>) =
    match n with
    | 0 -> []
    | _ -> f n @ repeat (n - 1) f


/// function that generates code for calling "env" "malloc" function with the size of in bytes
/// it assumes that the size is on the stack
/// it will return the start position or -1 if there is no more memory
let allocate =
    let m =
        Module()
            .AddImport("env", "malloc", FunctionType("malloc", Some([ (None, I32) ], [ I32 ])))

    let instr = [ (Call "malloc", "call malloc function") ]
    m.AddCode(instr)

type internal CodegenEnv =
    { funcIndexMap: Map<string, List<Instr>>
      currFunc: string
      // // name, type, allocated address
      varEnv: Map<string, Var * ValueType>
      memoryAllocator: StaticMemoryAllocator
      VarStorage: Map<string, Storage> } // function refances in table

/// look up variable in var env
let internal lookupLabel (env: CodegenEnv) (e: TypedAST) =
    match e.Expr with
    | Var v ->
        match env.VarStorage.TryFind v with
        | Some(Storage.Label(l)) -> Named(l)
        | Some(Storage.Offset(o)) -> Index(o)
        | _ -> failwith "not implemented"
    | _ -> failwith "not implemented"

let rec internal doCodegen (env: CodegenEnv) (node: TypedAST) (m: Module) : Module =
    match node.Expr with
    | UnitVal -> m
    | IntVal i -> m.AddCode([ (I32Const i, (sprintf "push %i on stack" (i))) ])
    | BoolVal b -> m.AddCode([ I32Const(if b then 1 else 0) ])
    | FloatVal f -> m.AddCode([ F32Const f ])
    | StringVal s ->
        // allocate string in memory
        let (address, size) =
            env.memoryAllocator.Allocate(Encoding.BigEndianUnicode.GetByteCount(s))
        // add memory to module
        let allocatedModule =
            m.AddMemory("memory", Unbounded(env.memoryAllocator.GetNumPages()))
        // add data to module. push address and size (bytes) to the stack
        allocatedModule
            .AddData(I32Const(address), s)
            .AddCode([ (I32Const(address), "offset in memory"); (I32Const(size), "size in bytes") ])
    | Var v ->
        // load variable
        // TODO
        let instrs =
            match env.VarStorage.TryFind v with
            | Some(Storage.Label(l)) -> [ LocalGet(Named(l)) ]
            | Some(Storage.Offset(o)) -> [ LocalGet(Index(o)) ]
            | _ -> failwith "not implemented"

        m.AddCode(instrs)

    | PreIncr(e) ->
        let m' = doCodegen env e m

        let label = lookupLabel env e

        let instrs =
            match e.Type with
            | t when (isSubtypeOf e.Env t TInt) ->
                m'.GetTempCode() @ C [ I32Const 1; I32Add; LocalSet(label); LocalGet(label) ]
            | _ -> failwith "not implemented"

        C [ Comment "Start PreIncr" ]
        ++ (m'.ResetTempCode().AddCode(instrs @ (C [ Comment "End PreIncr" ])))
    | PostIncr(e) ->
        let m' = doCodegen env e m

        let label = lookupLabel env e

        let instrs =
            match e.Type with
            | t when (isSubtypeOf e.Env t TInt) ->
                m'.GetTempCode() @ C [ LocalGet(label); I32Const 1; I32Add; LocalSet(label) ]
            | _ -> failwith "not implemented"

        C [ Comment "Start PostIncr" ]
        ++ (m'.ResetTempCode().AddCode(instrs @ (C [ Comment "End PostIncr" ])))
    | PreDcr(e) ->
        let m' = doCodegen env e m

        let label = lookupLabel env e

        let instrs =
            match e.Type with
            | t when (isSubtypeOf e.Env t TInt) ->
                m'.GetTempCode() @ C [ I32Const 1; I32Sub; LocalSet(label); LocalGet(label) ]
            | _ -> failwith "not implemented"

        C [ Comment "Start PreDecr" ]
        ++ (m'.ResetTempCode().AddCode(instrs @ (C [ Comment "End PreDecr" ])))
    | PostDcr(e) ->
        let m' = doCodegen env e m

        let label = lookupLabel env e

        let instrs =
            match e.Type with
            | t when (isSubtypeOf e.Env t TInt) ->
                m'.GetTempCode() @ C [ LocalGet(label); I32Const 1; I32Sub; LocalSet(label) ]
            | _ -> failwith "not implemented"

        C [ Comment "Start PostDecr" ]
        ++ (m'.ResetTempCode().AddCode(instrs @ (C [ Comment "End PostDecr" ])))

    | MinAsg(lhs, rhs)
    | DivAsg(lhs, rhs)
    | MulAsg(lhs, rhs)
    | RemAsg(lhs, rhs)
    | AddAsg(lhs, rhs) ->
        let lhs' = doCodegen env lhs m
        let rhs' = doCodegen env rhs m

        let opCode =
            match node.Type with
            | t when (isSubtypeOf node.Env t TInt) ->
                match node.Expr with
                | AddAsg(_, _) -> I32Add
                | MinAsg(_, _) -> I32Sub
                | MulAsg(_, _) -> I32Mul
                | DivAsg(_, _) -> I32DivS
                | RemAsg(_, _) -> I32RemS
                | _ -> failwith "not implemented"
            | t when (isSubtypeOf node.Env t TFloat) ->
                match node.Expr with
                | AddAsg(_, _) -> F32Add
                | MinAsg(_, _) -> F32Sub
                | MulAsg(_, _) -> F32Mul
                | DivAsg(_, _) -> F32Div
                | _ -> failwith "not implemented"

        let label = lookupLabel env lhs

        let instrs =
            match node.Type with
            | t when (isSubtypeOf node.Env t TInt) ->
                lhs'.GetTempCode()
                @ rhs'.GetTempCode()
                @ C [ opCode; LocalSet(label); LocalGet(label) ]
            | t when (isSubtypeOf node.Env t TFloat) ->
                lhs'.GetTempCode()
                @ rhs'.GetTempCode()
                @ C [ opCode; LocalSet(label); LocalGet(label) ]
            | _ -> failwith "not implemented"

        C [ Comment "Start AddAsgn/MinAsgn" ]
        ++ (lhs' + rhs')
            .ResetTempCode()
            .AddCode(instrs @ (C [ Comment "End AddAsgn/MinAsgn" ]))

    | Max(e1, e2)
    | Min(e1, e2) ->

        let m' = doCodegen env e1 m
        let m'' = doCodegen env e2 m

        let instrs =
            match node.Type with
            | t when (isSubtypeOf node.Env t TFloat) ->
                match node.Expr with
                | Max(_, _) -> C [ F32Max ]
                | Min(_, _) -> C [ F32Min ]
                | _ -> failwith "not implemented"
            | t when (isSubtypeOf node.Env t TInt) ->
                match node.Expr with
                | Max(_, _) -> m'.GetTempCode() @ m''.GetTempCode() @ C [ I32GtS; Select ]
                | Min(_, _) -> m'.GetTempCode() @ m''.GetTempCode() @ C [ I32LtS; Select ]
                | _ -> failwith "not implemented"
            | _ -> failwith "failed type of max/min"

        C [ Comment "Max/min start" ]
        ++ (m' + m'').AddCode(instrs @ C [ Comment "Max/min end" ])

    | Sqrt e ->
        let m' = doCodegen env e m
        let instrs = m'.GetTempCode() @ C [ F32Sqrt ]
        m'.ResetTempCode().AddCode(instrs)
    | Add(lhs, rhs)
    | Sub(lhs, rhs)
    | Rem(lhs, rhs)
    | Div(lhs, rhs)
    | Mult(lhs, rhs) as expr ->
        let lhs' = doCodegen env lhs m
        let rhs' = doCodegen env rhs m

        let opCode =
            match node.Type with
            | t when (isSubtypeOf node.Env t TInt) ->
                match expr with
                | Add(_, _) -> I32Add
                | Sub(_, _) -> I32Sub
                | Rem(_, _) -> I32RemS
                | Div(_, _) -> I32DivS
                | Mult(_, _) -> I32Mul
                | _ -> failwith "not implemented"
            | t when (isSubtypeOf node.Env t TFloat) ->
                match expr with
                | Add(_, _) -> F32Add
                | Sub(_, _) -> F32Sub
                | Div(_, _) -> F32Div
                | Mult(_, _) -> F32Mul
                | _ -> failwith "not implemented"

        (lhs' + rhs').AddCode([ opCode ])
    | And(e1, e2) ->
        let m' = doCodegen env e1 m
        let m'' = doCodegen env e2 m
        let instrs = [ I32And ]
        (m' + m'').AddCode(instrs)
    | Or(e1, e2) ->
        let m' = doCodegen env e1 m
        let m'' = doCodegen env e2 m
        let instrs = [ I32Or ]
        (m' + m'').AddCode(instrs)
    | Not(e) ->
        let m' = doCodegen env e m
        let instrs = [ I32Eqz ]
        m'.AddCode(instrs)
    | Greater(e1, e2) ->
        let m' = doCodegen env e1 m
        let m'' = doCodegen env e2 m

        // find type of e1 and e2 and check if they are equal
        let opcode =
            match e1.Type, e2.Type with
            | t1, t2 when ((isSubtypeOf e1.Env t1 TInt) & (isSubtypeOf e1.Env t2 TInt)) -> [ I32GtS ]
            | t1, t2 when ((isSubtypeOf e1.Env t1 TFloat) & (isSubtypeOf e1.Env t2 TFloat)) -> [ F32Gt ]
            | t1, t2 when ((isSubtypeOf e1.Env t1 TBool) & (isSubtypeOf e1.Env t2 TBool)) -> [ I32GtS ]
            | _ -> failwith "type mismatch"

        (m' + m'').AddCode(opcode)
    | Eq(e1, e2) ->
        let m' = doCodegen env e1 m
        let m'' = doCodegen env e2 m

        // find type of e1 and e2 and check if they are equal
        let opcode =
            match e1.Type, e2.Type with
            | t1, t2 when ((isSubtypeOf e1.Env t1 TInt) & (isSubtypeOf e1.Env t2 TInt)) -> [ I32Eq ]
            | t1, t2 when ((isSubtypeOf e1.Env t1 TFloat) & (isSubtypeOf e1.Env t2 TFloat)) -> [ F32Eq ]
            | t1, t2 when ((isSubtypeOf e1.Env t1 TBool) & (isSubtypeOf e1.Env t2 TBool)) -> [ I32Eq ]
            | _ -> failwith "type mismatch"

        let instrs = m'.GetTempCode() @ m''.GetTempCode() @ C opcode
        (m + m'.ResetTempCode() + m''.ResetTempCode()).AddCode(instrs)
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
            match e1.Type, e2.Type with
            | t1, t2 when ((isSubtypeOf e1.Env t1 TInt) & (isSubtypeOf e1.Env t2 TInt)) -> [ I32LtS ]
            | t1, t2 when ((isSubtypeOf e1.Env t1 TFloat) & (isSubtypeOf e1.Env t2 TFloat)) -> [ F32Lt ]
            | t1, t2 when ((isSubtypeOf e1.Env t1 TBool) & (isSubtypeOf e1.Env t2 TBool)) -> [ I32LtS ]
            | _ -> failwith "type mismatch"

        (m' + m'').AddCode(opcode)

    | LessOrEq(e1, e2) ->
        let m' = doCodegen env e1 m
        let m'' = doCodegen env e2 m

        // find type of e1 and e2 and check if they are equal
        let opcode =
            match e1.Type, e2.Type with
            | t1, t2 when ((isSubtypeOf e1.Env t1 TInt) & (isSubtypeOf e1.Env t2 TInt)) -> [ I32LeS ]
            | t1, t2 when ((isSubtypeOf e1.Env t1 TFloat) & (isSubtypeOf e1.Env t2 TFloat)) -> [ F32Le ]
            | t1, t2 when ((isSubtypeOf e1.Env t1 TBool) & (isSubtypeOf e1.Env t2 TBool)) -> [ I32LeS ]
            | _ -> failwith "type mismatch"

        (m' + m'').AddCode(opcode)

    | GreaterOrEq(e1, e2) ->
        let m' = doCodegen env e1 m
        let m'' = doCodegen env e2 m

        // find type of e1 and e2 and check if they are equal
        let opcode =
            match e1.Type, e2.Type with
            | t1, t2 when ((isSubtypeOf e1.Env t1 TInt) & (isSubtypeOf e1.Env t2 TInt)) -> [ I32GeS ]
            | t1, t2 when ((isSubtypeOf e1.Env t1 TFloat) & (isSubtypeOf e1.Env t2 TFloat)) -> [ F32Ge ]
            | t1, t2 when ((isSubtypeOf e1.Env t1 TBool) & (isSubtypeOf e1.Env t2 TBool)) -> [ I32GeS ]
            | _ -> failwith "type mismatch"

        (m' + m'').AddCode(opcode)

    | ReadInt ->
        // import readInt function
        let readFunctionSignature: FunctionSignature = ([], [ I32 ])

        let m' =
            m.AddImport("env", "readInt", FunctionType("readInt", Some(readFunctionSignature)))
        // perform host (system) call
        m'.AddCode([ (Call "readInt", "call host function") ])
    | ReadFloat ->
        // import readFloat function
        let readFunctionSignature: FunctionSignature = ([], [ F32 ])

        let m' =
            m.AddImport("env", "readFloat", FunctionType("readFloat", Some(readFunctionSignature)))
        // perform host (system) call
        m'.AddCode([ (Call "readFloat", "call host function") ])
    | PrintLn e ->
        // TODO support more types
        let m' = doCodegen env e m

        // TODO not correct!!!!
        match e.Type with
        | t when (isSubtypeOf node.Env t TInt) ->
            // import writeInt function
            let writeFunctionSignature: FunctionSignature = ([ (None, I32) ], [])

            let m'' =
                m'.AddImport("env", "writeInt", FunctionType("writeInt", Some(writeFunctionSignature)))
            // perform host (system) call
            m''.AddCode([ (Call "writeInt", "call host function") ])
        | t when (isSubtypeOf node.Env t TFloat) -> failwith "not implemented"
        | t when (isSubtypeOf node.Env t TBool) -> failwith "not implemented"
        | t when (isSubtypeOf node.Env t TString) ->
            // import writeS function
            let writeFunctionSignature: FunctionSignature = ([ (None, I32); (None, I32) ], [])

            let m'' =
                m'.AddImport("env", "writeS", FunctionType("writeS", Some(writeFunctionSignature)))
            // perform host (system) call
            m''.AddCode([ (Call "writeS", "call host function") ])
        | _ -> failwith "not implemented"
    | AST.If(condition, ifTrue, ifFalse) ->
        let m' = doCodegen env condition m
        let m'' = doCodegen env ifTrue m
        let m''' = doCodegen env ifFalse m

        // get subtype of ifTrue and ifFalse
        let t =
            match ifTrue.Type, ifFalse.Type with
            | t, _ when (isSubtypeOf ifTrue.Env t TUnit) -> []
            | _, t when (isSubtypeOf ifFalse.Env t TUnit) -> []
            | t, _ when (isSubtypeOf ifTrue.Env t TFloat) -> [ F32 ]
            | _, t when (isSubtypeOf ifFalse.Env t TFloat) -> [ F32 ]
            | t, _ when (isSubtypeOf ifTrue.Env t TInt) -> [ I32 ]
            | _, t when (isSubtypeOf ifFalse.Env t TInt) -> [ I32 ]
            | t, _ when (isSubtypeOf ifTrue.Env t TBool) -> [ I32 ]
            | _, t when (isSubtypeOf ifFalse.Env t TBool) -> [ I32 ]
            | t, _ when (isSubtypeOf ifTrue.Env t TString) -> [ I32; I32 ]
            | _, t when (isSubtypeOf ifFalse.Env t TString) -> [ I32; I32 ]
            | _ -> failwith "not implemented"

        let instrs =
            m'.GetTempCode() @ C [ (If(t, m''.GetTempCode(), Some(m'''.GetTempCode()))) ]

        (m' + m'' + m''').ResetTempCode().AddCode(instrs)
    | Assertion(e) ->
        let m' = doCodegen env e (m.ResetTempCode())

        let instrs =
            m'.GetTempCode()
            @ C
                [ (If(
                      [],
                      [ (Nop, "do nothing - if all correct") ],
                      Some(
                          [ (I32Const errorExitCode, "error exit code push to stack")
                            (Return, "return exit code") ]
                      )
                  )) ]

        m'.ResetTempCode().AddCode(instrs)

    | Application(f, args) ->

        let m'' = List.fold (fun m arg -> m + doCodegen env arg (m.ResetTempCode())) m args

        let func_label =
            match f.Expr with
            | Var v ->
                match env.VarStorage.TryFind v with
                | Some(Storage.Label(l)) -> l
                | Some(Storage.FuncRef(l, _)) -> l
                // todo make function pointer
                | _ -> failwith "not implemented"
            | _ -> failwith "not implemented"

        let instrs =
            m''.GetTempCode() @ [ (Call func_label, sprintf "call function %s" func_label) ]

        m''.ResetTempCode().AddCode(instrs)

    | Lambda(args, body) ->
        // Label to mark the position of the lambda term body
        let funLabel = Util.genSymbol "lambda"

        // capture variables in body
        let l = captureVars body

        // resolve type of captured variables
        let l' = List.map (fun v -> (v, body.Env.Vars[v])) l

        /// Names of the Lambda arguments
        let (argNames, _) = List.unzip args

        let argNamesTypes = (List.map (fun a -> (a, body.Env.Vars[a])) argNames) @ l'

        let m' = m.AddFuncRefElement(funLabel)

        // add func ref to env
        let env' =
            { env with
                VarStorage = env.VarStorage.Add(funLabel, Storage.Offset(m'.funcTableSize - 1)) }

        // intrctions that get all locals used in lamda and push them to stack
        let instrs =
            List.map
                (fun (n, t) ->
                    match t with
                    | TInt -> LocalGet(Named(n))
                    | TFloat -> LocalGet(Named(n))
                    | TBool -> LocalGet(Named(n))
                    // | TString -> (LocalGet(Named(n)), "get local var")
                    | TUnit -> failwith "not implemented")
                argNamesTypes

        let l = (C instrs) @ (C [ Call funLabel ])

        l ++ (compileFunction funLabel argNamesTypes body env' m')
    | Seq(nodes) ->
        // We collect the code of each sequence node by folding over all nodes
        List.fold (fun m node -> (m + doCodegen env node (m.ResetTempCode()))) m nodes

    | While(cond, body) ->
        let cond' = doCodegen env cond m
        let body' = doCodegen env body m

        let exitl = Util.genSymbol $"loop_exit"
        let beginl = Util.genSymbol $"loop_begin"

        let loop =
            C
                [ Loop(
                      beginl,
                      [],
                      cond'.GetTempCode()
                      @ C [ I32Eqz; BrIf exitl ]
                      @ body'.GetTempCode()
                      @ C [ Br beginl ]
                  ) ]

        let block = C [ (Block(exitl, loop @ C [ Nop ])) ]

        (cond'.ResetTempCode() + body'.ResetTempCode()).AddCode(block)

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

        // node with literal value 0
        // data poiner of struct is first zoro.
        let zero = { node with Expr = IntVal 0 }

        // create struct with length and data
        let structm =
            doCodegen
                env
                { node with
                    Expr = Struct([ ("length", length); ("data", zero) ]) }
                m

        // pointer to struct in local var
        let structPointerLabel = Util.genSymbol $"structPointer"

        let structPointer =
            structm // pointer to struct on stack
                .AddLocals([ (Some(Identifier(structPointerLabel)), I32) ]) // add local var
                .AddCode([ (LocalSet(Named(structPointerLabel)), "set struct pointer var") ]) // set struct pointer var

        let allocation = // leave pointer to allocated memory on stack
            length' // length of array on stack
                .AddImport("env", "malloc", FunctionType("malloc", Some([ (None, I32) ], [ I32 ]))) // import malloc function
                .AddCode(
                    [ (I32Const 4, "4 bytes")
                      (I32Mul, "multiply length with 4 to get size")
                      (Call "malloc", "call malloc function") ]
                )

        // set data pointer of struct
        let instr =
            [ (LocalGet(Named(structPointerLabel)), "get struct pointer var")
              (I32Const 4, "offset of data field")
              (I32Add, "add offset to base address to get data pointer field") ]
            @ allocation.GetTempCode() // get pointer to allocated memory - value to store in data pointer field
            @ [ (I32Store, "store pointer to data") ]


        // loop that runs length times and stores data in allocated memory
        let exitl = Util.genSymbol $"loop_exit"
        let beginl = Util.genSymbol $"loop_begin"

        // body should set data in allocated memory
        let body =
            [ (LocalGet(Named(structPointerLabel)), "get struct pointer var")
              (I32Const(8), "byte offset")
              (I32Add, "add offset to base address") // then data pointer + 4 (point to fist elem) is on top of stack = [length, data, fist elem, second elem, ...]

              (LocalGet(Named("i")), "get index")
              (I32Const(4), "byte offset")
              (I32Mul, "multiply index with byte offset") // then offset is on top of stack

              (I32Add, "add offset to base address") ] // then pointer to element is on top of stack
            @ data'.GetTempCode() // get value to store in allocated memory
            @ [ (I32Store, "store value in elem pos") ]

        let loop =
            C
                [ Loop(
                      beginl,
                      [],
                      length'.GetTempCode()
                      @ [ (LocalGet(Named "i"), "get i") ]
                      @ C [ I32Eq; BrIf exitl ]                      
                      @ body
                      @ [ (LocalGet(Named "i"), "get i"); (I32Const(1), "increment by 1"); (I32Add, "add 1 to i"); (LocalSet(Named "i"), "write to i") ]
                      @ C [ Br beginl ]
                  ) ]

        let block = C [ (Block(exitl, loop @ C [ Nop ])) ]


        let loopModule =
            data'.ResetTempCode().AddLocals([ (Some(Identifier("i")), I32) ]).AddCode(block)

        structPointer
        ++ allocation
        ++ loopModule.AddCode(
            instr
            @ [ (LocalGet(Named(structPointerLabel)), "leave pointer to allocated array struct on stack") ]
        )
    | ArrayLength(target) ->
        let m' = doCodegen env target m

        let instrs =
            m'.GetTempCode()
            // @ [ (I32Const 0, "offset of length field"); (I32Add, "add offset") ] // not needed when is first field in struct
            @ [ (I32Load, "load length") ]

        C [ Comment "start array length node" ]
        ++ m'.ResetTempCode().AddCode(instrs @ C [ Comment "end array length node" ])
    | Assign(name, value) ->
        let value' = doCodegen env value m

        match name.Expr with
        | Var(name) ->

            let varLabel =
                match env.VarStorage.TryFind name with
                | Some(Storage.Label(l)) -> Named(l)
                | _ -> failwith "not implemented"

            // is nested? - is multiple assignment
            let isNested =
                match value.Expr with
                | Assign(v, _) ->
                    let nestedName =
                        match v.Expr with
                        | Var(n) ->
                            match env.VarStorage.TryFind n with
                            | Some(Storage.Label(l)) -> Named(l)
                            | _ -> failwith "not implemented"
                        | _ -> failwith "not implemented"

                    [ (LocalGet nestedName, "get local var") ]
                | _ -> []

            let instrs =
                value'.GetTempCode() @ isNested @ [ (LocalSet varLabel, "set local var") ]

            value'.ResetTempCode().AddCode(instrs)
        | FieldSelect(target, field) ->

            let selTargetCode = doCodegen env target m

            /// Code for the 'rhs' expression of the assignment
            let rhsCode = doCodegen env value m

            match (expandType target.Env target.Type) with
            | TStruct(fields) ->
                /// Names of the struct fields
                let (fieldNames, _) = List.unzip fields
                /// Offset of the selected struct field from the beginning of
                /// the struct
                let offset = List.findIndex (fun f -> f = field) fieldNames

                // is literal
                let isLiteral =
                    match value.Expr with
                    | IntVal i -> true
                    | FloatVal f -> true
                    | BoolVal b -> true
                    | _ -> false

                /// Assembly code that performs the field value assignment
                let assignCode =
                    match name.Type with
                    | t when (isSubtypeOf value.Env t TUnit) -> [] // Nothing to do
                    | t when (isSubtypeOf value.Env t TFloat) ->
                        let instrs =
                            selTargetCode.GetTempCode()
                            @ [ (I32Const(offset * 4), "offset of field"); (I32Add, "add offset") ]
                            @ rhsCode.GetTempCode()
                            @ [ (F32Store, "store float in struct") ]
                            @ rhsCode.GetTempCode()

                        instrs
                    | x ->
                        let instrs =
                            selTargetCode.GetTempCode()
                            @ [ (I32Const(offset * 4), "offset of field"); (I32Add, "add offset") ]
                            @ rhsCode.GetTempCode()
                            @ [ (I32Store, "store int in struct") ]
                            @ rhsCode.GetTempCode() // TODO possible bug (leave a constant on the stack after execution)

                        instrs
                // Put everything together
                (assignCode) ++ (rhsCode.ResetTempCode() + selTargetCode.ResetTempCode())
        | _ -> failwith "not implemented"
    | Ascription(_, node) ->
        // A type ascription does not produce code --- but the type-annotated
        // AST node does
        doCodegen env node m

    | Let(name,
          _,
          { Node.Expr = Lambda(args, body)
            Node.Type = TFun(targs, _) },
          scope) ->
        /// Assembly label to mark the position of the compiled function body.
        /// For readability, we make the label similar to the function name
        let funLabel = Util.genSymbol $"fun_%s{name}"

        /// Names of the lambda term arguments
        let (argNames, _) = List.unzip args
        /// List of pairs associating each function argument to its type
        let argNamesTypes = List.zip argNames targs
        /// Compiled function body
        let bodyCode: Module = compileFunction funLabel argNamesTypes body env m

        /// Storage info where the name of the compiled function points to the
        /// label 'funLabel'
        let varStorage2 = env.VarStorage.Add(name, Storage.Label(funLabel))

        let scopeModule: Module = (doCodegen { env with VarStorage = varStorage2 } scope m)

        scopeModule + bodyCode

    | Let(name, _, init, scope) ->
        let m' = doCodegen env init m

        let varName = Util.genSymbol $"var_%s{name}"

        let env' =
            { env with
                VarStorage = env.VarStorage.Add(name, Storage.Label(varName)) }

        match init.Type with
        | t when (isSubtypeOf init.Env t TUnit) -> m' ++ (doCodegen env scope m)
        | t when (isSubtypeOf init.Env t TInt) ->
            let varLabel = Named(varName)
            let initCode = m'.GetTempCode()

            let instrs =
                initCode // inizilize code
                @ [ (LocalSet varLabel, "set local var") ] // set local var

            let scopeCode = (doCodegen env' scope (m.ResetTempCode()))

            let combi = (instrs ++ scopeCode)

            C [ Comment "Start of let" ]
            ++ m'.ResetTempCode()
            ++ combi
                .AddLocals([ (Some(Identifier(varName)), I32) ])
                .AddCode([ Comment "End of let" ])
        | t when (isSubtypeOf init.Env t TFloat) ->
            let varLabel = Named(varName)
            let initCode = m'.GetTempCode()

            let instrs =
                initCode // inizilize code
                @ [ (LocalSet varLabel, "set local var") ] // set local var

            let scopeCode = (doCodegen env' scope (m.ResetTempCode()))

            let combi = (instrs ++ scopeCode)

            C [ Comment "Start of let" ]
            ++ m'.ResetTempCode()
            ++ combi
                .AddLocals([ (Some(Identifier(varName)), F32) ])
                .AddCode([ Comment "End of let" ])
        | TFun(_, _) ->
            // todo make function pointer
            let varLabel = Named(varName)

            // get function label
            let funcLabel =
                match init.Expr with
                | Application(f, _) ->
                    match f.Expr with
                    | Var(v) ->
                        match env.VarStorage.TryFind v with
                        | Some(Storage.Label(l)) -> l
                        | _ -> failwith "not implemented"
                    | _ -> failwith "not implemented"


            // add var to func ref
            let env' =
                { env' with
                    VarStorage = env.VarStorage.Add(name, Storage.FuncRef(funcLabel, 0)) }

            let initCode = m'.GetTempCode()

            let instrs =
                initCode // inizilize code
                @ [ (LocalSet varLabel, "set local var") ] // set local var

            let scopeCode = (doCodegen env' scope (m.ResetTempCode()))

            let combi = (instrs ++ scopeCode)

            C [ Comment "Start of let" ]
            ++ m'.ResetTempCode()
            ++ combi
                .AddLocals([ (Some(Identifier(varName)), I32) ])
                .AddCode([ Comment "End of let" ])
        | TStruct(_) ->
            let varLabel = Named(varName)
            let initCode = m'.GetTempCode()

            let instrs =
                initCode // inizilize code
                @ [ (LocalSet varLabel, "set local var") ] // set local var

            let scopeCode = (doCodegen env' scope (m.ResetTempCode()))

            let combi = (instrs ++ scopeCode)

            C [ Comment "Start of let" ]
            ++ m'.ResetTempCode()
            ++ combi
                .AddLocals([ (Some(Identifier(varName)), I32) ])
                .AddCode([ Comment "End of let" ])
        | _ ->
            // todo make function pointer
            let varLabel = Named(varName)
            let initCode = m'.GetTempCode()

            let instrs =
                initCode // inizilize code
                @ [ (LocalSet varLabel, "set local var") ] // set local var

            let scopeCode = (doCodegen env' scope (m.ResetTempCode()))

            let combi = (instrs ++ scopeCode)

            C [ Comment "Start of let" ]
            ++ m'.ResetTempCode()
            ++ combi
                .AddLocals([ (Some(Identifier(varName)), I32) ])
                .AddCode([ Comment "End of let" ])


    | LetMut(name, tpe, init, scope) ->
        // The code generation is not different from 'let...', so we recycle it
        doCodegen
            env
            { node with
                Expr = Let(name, tpe, init, scope) }
            m
    | LetRec(name,
             _,
             { Node.Expr = Lambda(args, body)
               Node.Type = TFun(targs, _) },
             scope) ->

        let funLabel = Util.genSymbol $"fun_%s{name}"

        /// Storage info where the name of the compiled function points to the
        /// label 'funLabel'
        let funcref = env.VarStorage.Add(name, Storage.Label(funLabel))

        /// Names of the lambda term arguments
        let (argNames, _) = List.unzip args
        /// List of pairs associating each function argument to its type
        let argNamesTypes = List.zip argNames targs

        /// Compiled function body
        let bodyCode: Module =
            compileFunction funLabel argNamesTypes body { env with VarStorage = funcref } m

        let scopeModule: Module = (doCodegen { env with VarStorage = funcref } scope m)

        scopeModule + bodyCode

    | LetRec(name, tpe, init, scope) ->
        doCodegen
            env
            { node with
                Expr = Let(name, tpe, init, scope) }
            m
    | Pointer(_) -> failwith "BUG: pointers cannot be compiled (by design!)"

    | AST.Type(_, _, scope) ->
        // A type alias does not produce any code --- but its scope does
        doCodegen env scope m

    // data strctures

    | Struct(fields) ->
        let fieldNames = List.map (fun (n, _) -> n) fields
        let fieldTypes = List.map (fun (_, t) -> t) fields

        let structName = Util.genSymbol $"Sptr"

        // calculate size of struct (each field is 4 bytes)
        let size = List.length fields

        // allocate memory for struct in dynamic memory
        let allocate =
            m
                .AddImport("env", "malloc", FunctionType("malloc", Some([ (None, I32) ], [ I32 ])))
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
                    match fieldInit.Type with
                    | t when (isSubtypeOf fieldInit.Env t TFloat) ->
                        [ (LocalGet(Named(structName)), "get struct pointer var")
                          (I32Const fieldOffsetBytes, "push field offset to stack")
                          (I32Add, "add offset to base address") ]
                        @ initField'.GetTempCode()
                        @ [ (F32Store, "store field in memory") ]
                    | _ ->
                        [ (LocalGet(Named(structName)), "get struct pointer var")
                          (I32Const fieldOffsetBytes, "push field offset to stack")
                          (I32Add, "add offset to base address") ]
                        @ initField'.GetTempCode()
                        @ [ (I32Store, "store field in memory") ]

                // accumulate code
                acc ++ initField.ResetTempCode().AddCode(instr)


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
            match (expandType node.Env target.Type) with
            | TStruct(fields) ->
                let (fieldNames, fieldTypes) = List.unzip fields
                let offset = List.findIndex (fun f -> f = field) fieldNames

                match fieldTypes.[offset] with
                | t when (isSubtypeOf node.Env t TUnit) -> [] // Nothing to do
                | t when (isSubtypeOf node.Env t TFloat) ->
                    // Retrieve value of struct field
                    selTargetCode.GetTempCode()
                    @ [ //(I32Const 4, "4 bytes")
                        //(I32Mul, "multiply offset by 4")
                        (I32Const(offset * 4), "push field offset to stack")
                        (I32Add, "add offset to base address")
                        (F32Load, "load field") ]
                | _ ->
                    // Retrieve value of struct field
                    selTargetCode.GetTempCode()
                    @ [ // (I32Const 4, "4 bytes")
                        // (I32Mul, "multiply offset by 4")
                        (I32Const(offset * 4), "push field offset to stack")
                        (I32Add, "add offset to base address")
                        (I32Load, "load field") ]
            | t -> failwith $"BUG: FieldSelect codegen on invalid target type: %O{t}"

        // Put everything together: compile the target, access the field
        selTargetCode.ResetTempCode()
        ++ m.AddCode(
            C [ Comment "Start of field select" ]
            @ fieldAccessCode
            @ C [ Comment "End of field select" ]
        )
    | x -> failwith "not implemented"

and internal compileFunction
    (name: string)
    (args: List<string * Type.Type>)
    (body: TypedAST)
    (env: CodegenEnv)
    (m: Module)
    : Module =
    // map args to local variables
    let argTypes: Local list =
        List.map
            (fun (n, t) ->
                match t with
                | TInt -> (Some(n), I32)
                | TFloat -> (Some(n), F32)
                | TBool -> (Some(n), I32)
                | TString -> (Some(n), I32)
                | TUnit -> failwith "not implemented")
            args

    let signature: FunctionSignature = (argTypes, [ I32 ])

    // add each arg to var storage
    let env' =
        List.fold
            (fun env (n, t) ->
                { env with
                    VarStorage = env.VarStorage.Add(n, Storage.Label(n)) })
            env
            args

    // create function instance
    let f: Commented<FunctionInstance> =
        ({ typeIndex = 0
           locals = []
           signature = signature
           body = []
           name = Some(Identifier(name)) },
         sprintf "function %s" name)


    let m' = m.AddFunction(name, f, true)

    // .AddExport(name, FunctionType(name, None))

    // compile function body
    let m'' = doCodegen { env' with currFunc = name } body m'
    // add code and locals to function
    m''
        .AddInstrs(name, m''.GetTempCode())
        .AddLocals(name, m''.GetLocals())
        .ResetTempCode()


and internal compileLambdaFunction
    (name: string)
    (args: List<string * Type.Type>)
    (body: TypedAST)
    (env: CodegenEnv)
    (m: Module)
    : Module =
    // map args to local variables
    let argTypes: Local list =
        List.map
            (fun (n, t) ->
                match t with
                | TInt -> (Some(n), I32)
                | TFloat -> (Some(n), F32)
                | TBool -> (Some(n), I32)
                | TString -> (Some(n), I32)
                | TUnit -> failwith "not implemented")
            args

    let signature: FunctionSignature = (argTypes, [ I32 ])

    // add each arg to var storage
    let env' =
        List.fold
            (fun env (n, t) ->
                { env with
                    VarStorage = env.VarStorage.Add(n, Storage.Label(n)) })
            env
            args

    // create function instance
    let f: Commented<FunctionInstance> =
        ({ typeIndex = 0
           locals = []
           signature = signature
           body = []
           name = Some(Identifier(name)) },
         sprintf "function %s" name)


    let m' = m.AddFunction(name, f) // .AddExport(name, FunctionType(name, None))

    // compile function body
    let m'' = doCodegen { env' with currFunc = name } body m'
    // add code and locals to function
    m''
        .AddInstrs(name, m''.GetTempCode())
        .AddLocals(name, m''.GetLocals())
        .ResetTempCode()

// return a list of all variables in the given expression
and internal captureVars (node: TypedAST) =
    match node.Expr with
    | Var v -> [ v ]
    | Lambda(args, body) ->
        let (argNames, _) = List.unzip args
        let bodyVars = captureVars body
        List.filter (fun v -> not (List.contains v argNames)) bodyVars
    | Seq(nodes) -> List.concat (List.map captureVars nodes)
    | AST.If(cond, ifTrue, ifFalse) -> List.concat [ captureVars cond; captureVars ifTrue; captureVars ifFalse ]
    | While(cond, body) -> List.concat [ captureVars cond; captureVars body ]
    | DoWhile(cond, body) -> List.concat [ captureVars cond; captureVars body ]
    | For(init, cond, update, body) ->
        List.concat [ captureVars init; captureVars cond; captureVars update; captureVars body ]
    | Assign(name, value) -> List.concat [ captureVars name; captureVars value ]
    | Ascription(_, node) -> captureVars node
    | Let(name, _, init, scope) -> List.concat [ captureVars init; captureVars scope ]
    | LetMut(name, _, init, scope) -> List.concat [ captureVars init; captureVars scope ]
    | LetRec(name, _, init, scope) -> List.concat [ captureVars init; captureVars scope ]
    | Pointer(_) -> []
    | _ -> []

// add special implicit main function
let implicit (node: TypedAST) : Module =

    let funcName = "_start" // todo change name to _start

    let signature = ([], [ I32 ])

    let f: Commented<FunctionInstance> =
        ({ typeIndex = 0
           locals = []
           signature = signature
           body = []
           name = Some(Identifier(funcName)) },
         "entry point of program (main function)")

    let m = Module().AddMemory(("memory", Unbounded(1)))

    let env =
        { currFunc = funcName
          funcIndexMap = Map.empty
          memoryAllocator = StaticMemoryAllocator()
          VarStorage = Map.empty
          varEnv = Map.empty }

    // add function to module and export it
    let m' =
        m.AddFunction(funcName, f).AddExport(funcName, FunctionType(funcName, None))

    // compile main function
    let m = doCodegen env node m'

    let staticOffset: int = env.memoryAllocator.GetAllocationPosition()

    let heapBase = "heap_base"
    // return 0 if program is successful
    m
        .AddLocals(env.currFunc, m.GetLocals()) // set locals of function
        .AddInstrs(env.currFunc, [ Comment "execution start here:" ])
        .AddInstrs(env.currFunc, m.GetTempCode()) // add code of main function
        .AddInstrs(env.currFunc, [ Comment "if execution reaches here, the program is successful" ])
        .AddInstrs(env.currFunc, [ (I32Const successExitCode, "exit code 0"); (Return, "return the exit code") ])
        .AddGlobal((heapBase, (I32, Immutable), [ I32Const staticOffset ]))
        .AddExport(heapBase + "_ptr", GlobalType("heap_base"))
