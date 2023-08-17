module WASMCodegen

open AST
open Type
open Typechecker
open Wat.WFG


    let rec internal doCodegen (m: Module) (node: TypedAST): Module =
        match node.Expr with    
        | IntVal i -> m + Module([I32Const i])
        | FloatVal f -> m + Module([F32Const f])
        | BoolVal b -> m + Module([I32Const (if b then 1 else 0)])
        | StringVal s -> m + Module([I32Const 0]) // TODO: implement strings
        | Var v -> Module([LocalGet 0]) // TODO: implement variables
        | Add (a, b) -> m + doCodegen m a + doCodegen m b + Module([I32Add])


    // add implicit main function
    let implicit (node: TypedAST): Module =
        
        let funcName = "main"

        let body : List<Instr> =
            [
                    I32Const 41
                    I32Const 42
                    I32Add
                    Return
            ]

        let f: Function = Some(funcName), ([], [I32]), [], body

        let _module = Module().AddFunction(f, "function 1").AddExport(funcName, FunctionType(funcName))

        doCodegen _module node
