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


