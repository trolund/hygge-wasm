module WASMCodegen

open AST
open Type
open Typechecker
open Wat.WFG

    (* A global variable has an absolute address, a local one has an offset: *)
    type Var = 
        | GloVar of int (* absolute address in stack           *)
        | LocVar of int (* address relative to bottom of frame *)

    (* The variable environment keeps track of global and local variables, and 
       keeps track of next available offset for local variables *)
    type varEnv = Map<string, Var * ValueType> * int

    type internal CodegenEnv = {
        funcIndexMap: Map<string, List<Instr>>
        currFunc: string
    }

    let rec internal doCodegen (env: CodegenEnv) (node: TypedAST) (m: Module) : Module =
        match node.Expr with    
        | IntVal i -> 
            let instrs = [PlainInstr (I32Const i)]
            m.AddInstrs(env.currFunc, instrs)
        | BoolVal b ->
            let instrs = [PlainInstr (I32Const (if b then 1 else 0))]
            m.AddInstrs(env.currFunc, instrs)
        | FloatVal f ->
            let instrs = [PlainInstr (F32Const f)]
            m.AddInstrs(env.currFunc, instrs)
        | And(e1, e2) ->
            let m' = doCodegen env e1 m
            let m'' = doCodegen env e2 m'
            let instrs = [PlainInstr (I32And)]
            m''.AddInstrs(env.currFunc, instrs)
        | StringVal s ->
            let allocatedModule = m.AddMemory("memory", Bounded(1, 2))  
            allocatedModule.AddData(PlainInstr (I32Const 0), s)
        | PrintLn e ->
            let m' = doCodegen env e m
            let writeFunctionSignature: ValueType list * 'a list = ([I32; I32], [])
            let m'' = m'.AddImport("env", "writeS", FunctionType("writeS", Some(writeFunctionSignature)))
            m''.AddInstrs(env.currFunc, [PlainInstr (I32Const 0); PlainInstr (I32Const 13); PlainInstr (Call "writeS")])
        | AST.If(condition, ifTrue, ifFalse) ->
            let m' = doCodegen env condition m
            let m'' = doCodegen env ifTrue m'
            let m''' = doCodegen env ifFalse m''

            m'''
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
        | _ -> failwith "not implemented"

    // add implicit main function
    let implicit (node: TypedAST): Module =
        
        let funcName = "main"
        
        let signature = ([], [I32])
        let f: Function = Some(funcName), signature, [], []

        let m = Module()
        let env = {
            currFunc = funcName
            funcIndexMap = Map.empty
        }

        // commeted f
        let res: Commented<Function> = f, Some("main function")

        let m' = m.AddFunction(funcName, res).AddExport(funcName, FunctionType(funcName, None))

        let m = doCodegen env node m'
        
        // return 0 if program is successful
        m.AddInstrs(funcName, [PlainInstr (I32Const 0); PlainInstr (Return)])


