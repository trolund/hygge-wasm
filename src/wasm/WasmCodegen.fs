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
        varEnv: Map<string, Var * ValueType>
        memoryAllocator: MemoryAllocator
        VarStorage: Map<string, Storage>
        // FuncRef: Map<string, Label>
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
                                | Some(Storage.Offset(o)) -> [LocalGet (Index(o))]
                                | _ -> failwith "not implemented"
            m.AddCode(instrs)
        | Sqrt e ->
            let m' = doCodegen env e m
            let instrs = m'.GetTempCode() @ C [F32Sqrt]
            m'.ResetTempCode().AddCode(instrs)
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
        | Not(e) ->
            let m' = doCodegen env e m
            let instrs = [I32Eqz]
            m'.AddCode(instrs)
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

                        // find type of e1 and e2 and check if they are equal
            let opcode = match e1.Type, e2.Type with
                                | t1, t2 when ((isSubtypeOf e1.Env t1 TInt) & (isSubtypeOf e1.Env t2 TInt)) -> [I32LtS]
                                | t1, t2 when ((isSubtypeOf e1.Env t1 TFloat) & (isSubtypeOf e1.Env t2 TFloat)) -> [F32Lt]
                                | t1, t2 when ((isSubtypeOf e1.Env t1 TBool) & (isSubtypeOf e1.Env t2 TBool)) -> [I32LtS]
                                | _ -> failwith "type mismatch"

            (m' + m'').AddCode(opcode)
        | Max(e1, e2) 
        | Min(e1, e2) ->

            let m' = doCodegen env e1 m
            let m'' = doCodegen env e2 m

            let instrs = match node.Type with
                                    | t when (isSubtypeOf node.Env t TFloat) -> 
                                        match node.Expr with
                                        | Max(_, _) -> C [F32Max]
                                        | Min(_, _) -> C [F32Min]
                                    | t when (isSubtypeOf node.Env t TInt) -> 
                                        match node.Expr with
                                        | Max(_, _) -> m'.GetTempCode() @ m''.GetTempCode() @ C [I32GtS; Select]
                                        | Min(_, _) -> m'.GetTempCode() @ m''.GetTempCode() @ C [I32LtS; Select]

            C [Comment "Max/min start"] ++ (m' + m'').AddCode(instrs @ C [Comment "Max/min end"])

        | ReadInt ->
            // import readInt function
            let readFunctionSignature: FunctionSignature = ([], [I32])
            let m' = m.AddImport("env", "readInt", FunctionType("readInt", Some(readFunctionSignature)))
            // perform host (system) call
            m'.AddCode([(Call "readInt", "call host function")])
        | ReadFloat ->
            // import readFloat function
            let readFunctionSignature: FunctionSignature = ([], [F32])
            let m' = m.AddImport("env", "readFloat", FunctionType("readFloat", Some(readFunctionSignature)))
            // perform host (system) call
            m'.AddCode([(Call "readFloat", "call host function")])
        | PrintLn e ->
            // TODO support more types 
            let m' = doCodegen env e m
            
            // TODO not correct!!!!
            match e.Type with
            | t when (isSubtypeOf node.Env t TInt) -> 
                // import writeInt function
                let writeFunctionSignature: FunctionSignature = ([(None, I32)], [])
                let m'' = m'.AddImport("env", "writeInt", FunctionType("writeInt", Some(writeFunctionSignature)))
                // perform host (system) call
                m''.AddCode([(Call "writeInt", "call host function")])
            | t when (isSubtypeOf node.Env t TFloat) -> failwith "not implemented"
            | t when (isSubtypeOf node.Env t TBool) -> failwith "not implemented"
            | t when (isSubtypeOf node.Env t TString) ->
                // import writeS function
                let writeFunctionSignature: FunctionSignature = ([(None, I32); (None, I32)], [])
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
        
        | Application(f, args) ->

            let m'' = List.fold (fun m arg -> m + doCodegen env arg (m.ResetTempCode())) m args

            let func_label = match f.Expr with
                                | Var v -> 
                                    match env.VarStorage.TryFind v with
                                    | Some(Storage.Label(l)) -> l
                                    | _ -> failwith "not implemented"
                                | _ -> failwith "not implemented"
            let instrs = m''.GetTempCode() @ [(Call func_label, sprintf "call function %s" func_label)]
            m''.ResetTempCode().AddCode(instrs)

        | Lambda(args, body) ->
            // Label to mark the position of the lambda term body
            let funLabel = Util.genSymbol "lambda"

            /// Names of the Lambda arguments
            let (argNames, _) = List.unzip args

            let argNamesTypes = List.map (fun a -> (a, body.Env.Vars[a])) argNames

            compileFunction  funLabel argNamesTypes body env m
        | Seq(nodes) ->
            // We collect the code of each sequence node by folding over all nodes
            List.fold (fun m node -> (m + doCodegen env node (m.ResetTempCode()))) m nodes

        | While(cond, body) ->
            let cond' = doCodegen env cond m
            let body' = doCodegen env body m
            
            let exitl = Util.genSymbol $"loop_exit"
            let beginl = Util.genSymbol $"loop_begin"

            let loop = C [Loop (beginl, [], cond'.GetTempCode() @ C [I32Eqz; BrIf exitl] @ body'.GetTempCode() @ C [Br beginl])]

            let block = C [(Block (exitl, loop @ C [Nop]))]

            (cond'.ResetTempCode() + body'.ResetTempCode()).AddCode(block)

        | DoWhile(cond, body) ->
            (doCodegen env body m) ++ (doCodegen env {node with Expr = While(cond, body)} m)

        | For(init, cond, update, body) ->
            (doCodegen env init m) ++ (doCodegen env {node with Expr = While(cond, {node with Expr = Seq([body; update])})} m)

        | Assign(name, value) ->
            let value' = doCodegen env value m

     

            match name.Expr with
            | Var(name) ->

                let varLabel = match env.VarStorage.TryFind name with
                                    | Some(Storage.Label(l)) -> Named(l)
                                    | _ -> failwith "not implemented"

                // is nested? - is multiple assignment
                let isNested = match value.Expr with 
                                | Assign(v, _) ->
                                    let nestedName = match v.Expr with
                                                        | Var(n) -> 
                                                            match env.VarStorage.TryFind n with
                                                            | Some(Storage.Label(l)) -> Named(l)
                                                            | _ -> failwith "not implemented"
                                                        | _ -> failwith "not implemented"
                                    
                                    [(LocalGet nestedName, "get local var")]
                                | _ -> []

                let instrs = value'.GetTempCode() @ isNested @ [(LocalSet varLabel, "set local var")]
                value'.ResetTempCode().AddCode(instrs)
            | _ -> failwith "not implemented"
        | Ascription(_, node) ->
        // A type ascription does not produce code --- but the type-annotated
        // AST node does
            doCodegen env node m

        | Let(name, _,
            {Node.Expr = Lambda(args, body);
             Node.Type = TFun(targs, _)}, scope) ->
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

            let scopeModule: Module = (doCodegen {env with VarStorage = varStorage2} scope m)

            scopeModule + bodyCode

        | Let(name, _, init, scope) ->
            let m' = doCodegen env init m

            let varName = Util.genSymbol $"var_%s{name}"
            let env' = {env with VarStorage = env.VarStorage.Add(name, Storage.Label(varName))}

            match init.Type with
            | t when (isSubtypeOf init.Env t TUnit) -> 
                m' ++ (doCodegen env scope m)
            | t when (isSubtypeOf init.Env t TInt) ->
                let varLabel = Named (varName)
                let initCode = m'.GetTempCode()

                let instrs = initCode // inizilize code
                                                    @ [(LocalSet varLabel, "set local var")] // set local var
                let scopeCode = (doCodegen env' scope (m.ResetTempCode()))

                let combi = (instrs ++ scopeCode)

                combi.AddLocals([(Some(Identifier(varName)), I32)])
            | t when (isSubtypeOf init.Env t TFloat) ->
                let varLabel = Named (varName)
                let initCode = m'.GetTempCode()

                let instrs = initCode // inizilize code
                                                    @ [(LocalSet varLabel, "set local var")] // set local var
                let scopeCode = (doCodegen env' scope (m.ResetTempCode()))

                let combi = (instrs ++ scopeCode)

                combi.AddLocals([(Some(Identifier(varName)), F32)])
            | TFun(_, _) -> 
                // todo make function pointer
                failwith "not implemented"
            | _ -> failwith "not implemented"
                

        | LetMut(name, tpe, init, scope) ->
        // The code generation is not different from 'let...', so we recycle it
            doCodegen env {node with Expr = Let(name, tpe, init, scope)} m
        | LetRec(name, _,
          {Node.Expr = Lambda(args, body);
           Node.Type = TFun(targs, _)}, scope) ->
            
            let funLabel = Util.genSymbol $"fun_%s{name}"

            /// Storage info where the name of the compiled function points to the
            /// label 'funLabel'
            let varStorage2 = env.VarStorage.Add(name, Storage.Label(funLabel))

            /// Names of the lambda term arguments
            let (argNames, _) = List.unzip args
            /// List of pairs associating each function argument to its type
            let argNamesTypes = List.zip argNames targs
            /// Compiled function body
            let bodyCode: Module = compileFunction funLabel argNamesTypes body {env with VarStorage = varStorage2} m
            
            let scopeModule: Module = (doCodegen {env with VarStorage = varStorage2} scope m)

            scopeModule + bodyCode

        | LetRec(name, tpe, init, scope) -> 
            doCodegen env {node with Expr = Let(name, tpe, init, scope)} m
        | Pointer(_) ->
            failwith "BUG: pointers cannot be compiled (by design!)"
        
        | AST.Type(_, _, scope) ->
        // A type alias does not produce any code --- but its scope does
            doCodegen env scope m
        | x -> 
                failwith "not implemented"
    
    and internal compileFunction (name: string) (args: List<string * Type.Type>) (body: TypedAST) (env: CodegenEnv) (m: Module): Module =
        // map args to local variables
        let argTypes: Local list = List.map (fun (n, t) -> match t with
                                                                                    | TInt -> (Some(n), I32)
                                                                                    | TFloat -> (Some(n), F32)
                                                                                    | TBool -> (Some(n), I32)
                                                                                    | TString -> (Some(n), I32)
                                                                                    | TUnit -> failwith "not implemented") args

        let signature: FunctionSignature = (argTypes, [I32])

        // add each arg to var storage
        let env' = List.fold (fun env (n, t) -> {env with VarStorage = env.VarStorage.Add(n, Storage.Label(n))}) env args

        // create function instance
        let f: Commented<FunctionInstance> = ({typeIndex = 0
                                               locals = []
                                               signature = signature
                                               body = [] 
                                               name = Some(Identifier(name)) }, sprintf "function %s" name)


        let m' = m.AddFunction(name, f) // .AddExport(name, FunctionType(name, None))

        // compile function body
        let m'' = doCodegen {env' with currFunc = name} body m'
        // add code and locals to function
        m''.AddInstrs(name, m''.GetTempCode()).AddLocals(name, m''.GetLocals()).ResetTempCode()



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
            varEnv = Map.empty
        }

        let m' = m.AddFunction(funcName, f).AddExport(funcName, FunctionType(funcName, None))

        let m = doCodegen env node m'
        
        // return 0 if program is successful
        m.AddLocals(env.currFunc, m.GetLocals()) // set locals of function 
         .AddInstrs(env.currFunc, [Comment "execution start here:"])
         .AddInstrs(env.currFunc, m.GetTempCode()) // add code of main function
         .AddInstrs(env.currFunc, [Comment "if execution reaches here, the program is successful"])
         .AddInstrs(env.currFunc, [(I32Const successExitCode, "exit code 0"); (Return, "return the exit code")])


