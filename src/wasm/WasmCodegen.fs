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
    | Frame of offset: int

type internal MemoryAllocator() =
    let mutable allocationPosition = 0
    let pageSize = 64 * 1024  // 64KB

    // list of allocated memory
    let mutable allocatedMemory: List<int * int> = []

    // get head of allocated memory list
    member this.GetAllocated() =
        (allocatedMemory.Head)

    // get number of pages needed to allocate size bytes
    member this.GetNumPages() =
        let numPages = allocationPosition / pageSize
        if allocationPosition % pageSize <> 0 then
            numPages + 1
        else
            numPages

    // allocate size bytes
    member this.Allocate(size: int) =
        if size <= 0 then
            failwith "Size must be positive"

        let startPosition = allocationPosition
        
        // added to allocated memory
        allocatedMemory <- (startPosition, size) :: allocatedMemory
        
        allocationPosition <- allocationPosition + size
        (startPosition, size)

    member this.GetAllocationPosition() =
        allocationPosition

    type internal CodegenEnv = {
        funcIndexMap: Map<string, List<Instr>>
        currFunc: string
        // // name, type, allocated address
        // varEnv: Map<string, Var * ValueType>
        memoryAllocator: MemoryAllocator
        VarStorage: Map<string, Storage>
    }

    let rec internal doCodegen (env: CodegenEnv) (node: TypedAST) (m: Module) : Module =
        match node.Expr with    
        | UnitVal ->
            m
        | IntVal i -> 
            m.AddCode([(I32Const i, (sprintf "push %i on stack" (i)))])
        | BoolVal b ->
            m.AddCode([I32Const (if b then 1 else 0)])
        | FloatVal f ->
            m.AddCode([F32Const f])
        | StringVal s ->
            // allocate string in memory
            let (address, size) = env.memoryAllocator.Allocate(Encoding.BigEndianUnicode.GetByteCount(s))
            // add memory to module
            let allocatedModule = m.AddMemory("memory", Unbounded(env.memoryAllocator.GetNumPages()))
            // add data to module. push address and size (bytes) to the stack
            allocatedModule.AddData(I32Const address, s)
                           .AddCode([(I32Const address, "offset in memory"); (I32Const (size), "size in bytes")])
        | Var v ->
            // load variable
            // TODO
            let instrs = match env.VarStorage.TryFind v with
                                | Some(Storage.Label(l)) -> [LocalGet (Named(l))]
                                | Some(Storage.Frame(o)) -> [LocalGet (Index(o))]
                                | _ -> failwith "not implemented"
            m.AddCode(instrs)
        | Add(lhs, rhs)
        | Sub(lhs, rhs)
        | Rem(lhs, rhs)
        | Div(lhs, rhs)
        | Mult(lhs, rhs) as expr ->
            let lhs' = doCodegen env lhs m
            let rhs' = doCodegen env rhs m

            let opCode = match node.Type with
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

            (lhs' + rhs').AddCode([opCode])
        | And(e1, e2) ->
            let m' = doCodegen env e1 m
            let m'' = doCodegen env e2 m
            let instrs = [I32And]
            (m' + m'').AddCode(instrs)
        | Or(e1, e2) ->
            let m' = doCodegen env e1 m
            let m'' = doCodegen env e2 m
            let instrs = [I32Or]
            (m' + m'').AddCode(instrs)
        |Eq(e1, e2) ->
            let m' = doCodegen env e1 m
            let m'' = doCodegen env e2 m

            // find type of e1 and e2 and check if they are equal
            let opcode = match e1.Type, e2.Type with
                                | t1, t2 when ((isSubtypeOf e1.Env t1 TInt) & (isSubtypeOf e1.Env t2 TInt)) -> [I32Eq]
                                | t1, t2 when ((isSubtypeOf e1.Env t1 TFloat) & (isSubtypeOf e1.Env t2 TFloat)) -> [F32Eq]
                                | t1, t2 when ((isSubtypeOf e1.Env t1 TBool) & (isSubtypeOf e1.Env t2 TBool)) -> [I32Eq]
                                | _ -> failwith "type mismatch"

            let instrs = m'.GetTempCode() @ m''.GetTempCode() @ C opcode
            m.AddCode(instrs)
        | Xor(e1, e2) ->
            let m' = doCodegen env e1 m
            let m'' = doCodegen env e2 m
            let instrs = [I32Xor]
            (m' + m'').AddCode(instrs)
        | Less(e1, e2) ->
            let m' = doCodegen env e1 m
            let m'' = doCodegen env e2 m
            let instrs = [I32LtS]
            (m' + m'').AddCode(instrs)
        | PrintLn e ->
            // TODO support more types 
            let m' = doCodegen env e m
            
            // TODO not correct!!!!
            match e.Type with
            | t when (isSubtypeOf node.Env t TInt) -> 
                // import writeInt function
                let writeFunctionSignature: ValueType list * 'a list = ([I32], [])
                let m'' = m'.AddImport("env", "writeInt", FunctionType("writeInt", Some(writeFunctionSignature)))
                // perform host (system) call
                m''.AddCode([(Call "writeInt", "call host function")])
            | t when (isSubtypeOf node.Env t TFloat) -> failwith "not implemented"
            | t when (isSubtypeOf node.Env t TBool) -> failwith "not implemented"
            | t when (isSubtypeOf node.Env t TString) ->
                // import writeS function
                let writeFunctionSignature: ValueType list * 'a list = ([I32; I32], [])
                let m'' = m'.AddImport("env", "writeS", FunctionType("writeS", Some(writeFunctionSignature)))
                // perform host (system) call
                m''.AddCode([(Call "writeS", "call host function")])
            | _ -> failwith "not implemented"
        | AST.If(condition, ifTrue, ifFalse) ->
            let m' = doCodegen env condition m
            let m'' = doCodegen env ifTrue m
            let m''' = doCodegen env ifFalse m

            // get subtype of ifTrue and ifFalse
            let t = match ifTrue.Type, ifFalse.Type with
                    | t, _ when (isSubtypeOf ifTrue.Env t TUnit) -> []
                    | _, t when (isSubtypeOf ifFalse.Env t TUnit) -> []
                    | t, _ when (isSubtypeOf ifTrue.Env t TFloat) -> [F32]
                    | _, t when (isSubtypeOf ifFalse.Env t TFloat) -> [F32]
                    | t, _ when (isSubtypeOf ifTrue.Env t TInt) -> [I32]
                    | _, t when (isSubtypeOf ifFalse.Env t TInt) -> [I32]
                    | t, _ when (isSubtypeOf ifTrue.Env t TBool) -> [I32]
                    | _, t when (isSubtypeOf ifFalse.Env t TBool) -> [I32]
                    | t, _ when (isSubtypeOf ifTrue.Env t TString) -> [I32; I32]
                    | _, t when (isSubtypeOf ifFalse.Env t TString) -> [I32; I32]
                    | _ -> failwith "not implemented"

            let instrs = m'.GetTempCode() @ C [(If (t, m''.GetTempCode(), Some(m'''.GetTempCode())))]

            (m' + m'' + m''').ResetTempCode().AddCode(instrs)
        | Assertion(e) ->
            let m' = doCodegen env e (m.ResetTempCode())
            let instrs = m'.GetTempCode() @ C [(If ([], [(Nop, "do nothing - if all correct")], Some([(I32Const errorExitCode, "error exit code push to stack"); (Return, "return exit code")])))]
            m'.ResetTempCode().AddCode(instrs)
        | While(condition, body) ->
            m.AddInstrs(env.currFunc,  [
                 (Loop ([I32], C [
                     (I32Const 1)
                     (I32Const 1)
                     (I32Add)
                     (Drop)
                     (BrIf 0)
                     (Br 1)
                ]));
            ])
        | Let(name, _, init, scope) ->
            let m' = doCodegen env init m

            let varName = Util.genSymbol "var"
            let env' = {env with VarStorage = env.VarStorage.Add(name, Storage.Label(varName))}

            match init.Type with
            | t when (isSubtypeOf init.Env t TUnit) -> failwith "not implemented"
            | t when (isSubtypeOf init.Env t TFloat) -> failwith "not implemented"
            | t when (isSubtypeOf init.Env t TInt) ->
                // make x a Instr
                let varLabel = Named (varName)
                let initCode = m'.GetTempCode()
                // let varDef = [(Local (varLabel, (I32)), sprintf "delcare local var %s" varName)] // declare local var
                let instrs = initCode // inizilize code
                                                    @ [(LocalSet varLabel, "set local var")] // set local var
                let scopeCode = doCodegen env' scope (m.ResetTempCode())
                (instrs ++ scopeCode).AddLocals(env.currFunc, [(Identifier(varName), I32)])
            | t when (isSubtypeOf init.Env t TBool) -> failwith "not implemented"
            | t when (isSubtypeOf init.Env t TString) -> failwith "not implemented"
        | Seq(nodes) ->
            // We collect the code of each sequence node by folding over all nodes
            List.fold (fun m node -> doCodegen env node m) m nodes
        // | Var(name) ->
        //     let (var, _) = Map.find name env.varEnv
        //     let instrs = [GetLocal var]
        //     m.AddInstrs(env.currFunc, instrs)
        | Ascription(_, node) ->
        // A type ascription does not produce code --- but the type-annotated
        // AST node does
        doCodegen env node m

        // Special case for compiling a function with a given name in the input
        // source file. We recognise this case by checking whether the 'Let...'
        // declares 'name' as a Lambda expression with a TFun type
        // | Let(name, _,
        //     {Node.Expr = Lambda(args, body);
        //     Node.Type = TFun(targs, _)}, scope) ->
        //    Module()
        | x -> 
                failwith "not implemented"

    // add implicit main function
    let implicit (node: TypedAST): Module =
        
        let funcName = "main"
        
        let signature = ([], [I32])
        let f: Commented<FunctionInstance> = ({typeIndex = 0
                                               locals = []
                                               signature = signature
                                               body = [] 
                                               name = Some(Identifier(funcName)) }, "entry point of program (main function)")

        let m = Module()
        let env = {
            currFunc = funcName
            funcIndexMap = Map.empty
            memoryAllocator = MemoryAllocator()
            VarStorage = Map.empty
        }

        let m' = m.AddFunction(funcName, f).AddExport(funcName, FunctionType(funcName, None))

        let m = doCodegen env node m'
        
        // return 0 if program is successful
        m.AddInstrs(env.currFunc, [Comment "execution start here:"])
         .AddInstrs(env.currFunc, m.GetTempCode())
         .AddInstrs(env.currFunc, [Comment "if execution reaches here, the program is successful"])
         .AddInstrs(env.currFunc, [(I32Const successExitCode, "exit code 0"); (Return, "return the exit code")])


