module WASMCodegen

open AST
open Type
open Typechecker
open Wat.WFG

    // adress and size
type Var = 
    | GloVar of int * int
    | LocVar of int * int

type internal MemoryAllocator() =
    let mutable allocationPosition = 0
    let pageSize = 64 * 1024  // 64KB

    // list of allocated memory
    let mutable allocatedMemory: List<int * int> = []

    // get head of allocated memory list
    member this.GetAllocatedSize() =
        fst allocatedMemory.Head

    // get number of pages needed to allocate size bytes
    member this.GetNumPages() =
        let numPages = allocationPosition / pageSize
        if allocationPosition % pageSize <> 0 then
            numPages + 1
        else
            numPages

    member this.Allocate(size: int) =
        if size <= 0 then
            failwith "Size must be positive"

        // added to allocated memory
        allocatedMemory <- (allocationPosition, size) :: allocatedMemory
        
        let startPosition = allocationPosition
        allocationPosition <- allocationPosition + size
        startPosition

    member this.GetAllocationPosition() =
        allocationPosition

    type internal CodegenEnv = {
        funcIndexMap: Map<string, List<Instr>>
        currFunc: string
        // name, type, allocated address
        varEnv: Map<string, Var * ValueType>
        memoryAllocator: MemoryAllocator
    }



    let rec internal doCodegen (env: CodegenEnv) (node: TypedAST) (m: Module) : Module =
        match node.Expr with    
        | IntVal i -> 
            let instrs = [PlainInstr (I32Const i)]
            m.AddCode(instrs)
        | BoolVal b ->
            let instrs = [PlainInstr (I32Const (if b then 1 else 0))]
            m.AddCode(instrs)
        | FloatVal f ->
            let instrs = [PlainInstr (F32Const f)]
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

            (lhs' + rhs').AddCode([PlainInstr (opCode)])
        | And(e1, e2) ->
            let m' = doCodegen env e1 m
            let m'' = doCodegen env e2 m'
            let instrs = [PlainInstr (I32And)]
            m''.AddCode(instrs)
        | StringVal s ->
            let address = env.memoryAllocator.Allocate(s.Length)
            let allocatedModule = m.AddMemory("memory", Unbounded(env.memoryAllocator.GetNumPages()))  
            allocatedModule.AddData(PlainInstr (I32Const address), s)
        |Eq(e1, e2) ->
            let m' = doCodegen env e1 m
            let m'' = doCodegen env e2 m
            let instrs = m'.GetTempCode() @ m''.GetTempCode() @ [PlainInstr (I32Eq)]
            m''.AddCode(instrs)
        | PrintLn e ->
            // TODO support more types
            let m' = doCodegen env e m
            let writeFunctionSignature: ValueType list * 'a list = ([I32; I32], [])
            let m'' = m'.AddImport("env", "writeS", FunctionType("writeS", Some(writeFunctionSignature)))
            m''.AddCode([PlainInstr (I32Const (env.memoryAllocator.GetAllocatedSize())); PlainInstr (I32Const (env.memoryAllocator.GetAllocationPosition())); PlainInstr (Call "writeS")])
        | AST.If(condition, ifTrue, ifFalse) ->
            let m' = doCodegen env condition m
            let m'' = doCodegen env ifTrue m
            let m''' = doCodegen env ifFalse m

            let instrs = m'.GetTempCode() @ [BlockInstr (If (m''.GetTempCode() @ [PlainInstr (Return)], Some(m'''.GetTempCode() @ [PlainInstr (Return)])))]

            (m' + m'' + m''').ResetTempCode().AddCode(instrs)
        | Assertion(e) ->
            let m' = doCodegen env e m
            let instrs = m'.GetTempCode() @ [BlockInstr (If ([PlainInstr (Nop)], Some([PlainInstr (I32Const 42); PlainInstr (Return)])))]
            m'.ResetTempCode().AddCode(instrs)
        | While(condition, body) ->
            m.AddInstrs(env.currFunc, [
                BlockInstr (Loop ([I32], [
                    PlainInstr (I32Const 1);
                    PlainInstr (I32Const 1);
                    PlainInstr (I32Add);
                    PlainInstr (Drop);
                    PlainInstr (BrIf 0);
                    PlainInstr (Br 1);
                ]));
            ])
        | Seq(nodes) ->
        // We collect the code of each sequence node by folding over all nodes
            // let folder (asm: Asm) (node: TypedAST) =
            //     asm ++ (doCodegen env node)
            // List.fold folder (Asm()) nodes
            let m' = doCodegen env (List.head nodes) m
            let m'' = doCodegen env (List.head (List.tail nodes)) m'
            m''
        | x -> failwith "not implemented"

    // add implicit main function
    let implicit (node: TypedAST): Module =
        
        let funcName = "main"
        
        let signature = ([], [I32])
        let f: Function = Some(funcName), signature, [], []

        let m = Module()
        let env = {
            currFunc = funcName
            funcIndexMap = Map.empty
            varEnv = Map.empty
            memoryAllocator = MemoryAllocator()
        }

        // commeted f
        let res: Commented<Function> = f, Some("main function")

        let m' = m.AddFunction(funcName, res).AddExport(funcName, FunctionType(funcName, None))

        let m = doCodegen env node m'
        
        // return 0 if program is successful
        m.AddInstrs(env.currFunc, m.GetTempCode()).AddInstrs(env.currFunc, [PlainInstr (I32Const 0); PlainInstr (Return)])


