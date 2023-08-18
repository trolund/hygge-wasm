module WASMCodegen

open AST
open Type
open Typechecker
open Wat.WFG

    // // Codegen evorionment for Wasm Moduel
    // type CodegenEnv = {
    //     mutable _module: Module
    //     mutable locals: List<Locals>
    // }

    let rec internal doCodegen (m: Module) (node: TypedAST): Module =
        match node.Expr with    
        | IntVal i -> m + Module([I32Const i])
        | FloatVal f -> m + Module([F32Const f])
        | BoolVal b -> m + Module([I32Const (if b then 1 else 0)])
        | StringVal s -> 
            let allocatedModule = if m.GetAllocatedPages() < 1 then m.AddMemory("memory", Bounded(1, 2)) else m

            allocatedModule.AddData((I32Const 0), s)
        | Var v -> Module([LocalGet 0]) // TODO: implement variables
        | Add(lhs, rhs) -> 

            // code lhs and rhs
            let sides = (doCodegen m rhs + doCodegen m lhs).AddTempCode([I32Add])
            m.AppendToLastFunction(sides.GetTempCode())

        | Print(a) -> 
                // function type
                let writeFunctionSignature: ValueType list * 'a list = ([Externref], [])
                m.AddImport("env", "write", FunctionType("write", Some(writeFunctionSignature)))
                 .AppendToLastFunction([Call "write"])
        | PrintLn(a) -> 
                let m' = doCodegen m a
                // function type
                let writeFunctionSignature: ValueType list * 'a list = ([I32; I32], [])
                m'.AddImport("env", "writeS", FunctionType("writeS", Some(writeFunctionSignature)))
                  .AppendToLastFunction([I32Const 0; I32Const 13; Call "writeS"])
                  .AppendToLastFunction([I32Const 0; Return])
        | ReadInt -> 
                // function type
                let readFunctionSignature: ValueType list * 'a list = ([], [I32])
                m.AddImport("env", "readInt", FunctionType("read", Some(readFunctionSignature)))
                 .AppendToLastFunction([Call "read"])
        | _ -> failwith "Not implemented"

    // add implicit main function
    let implicit (node: TypedAST): Module =
        
        let funcName = "main"
        
        let signature = ([], [I32])
        let f: Function = Some(funcName), signature, [], []

        let _module = Module()
                                .AddFunction(f, "Entry point of program")
                                .AddExport(funcName, FunctionType(funcName, None))

        doCodegen _module node
