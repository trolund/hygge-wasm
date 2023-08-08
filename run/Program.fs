module Wat.test

open Wasm

[<EntryPoint>]
let main argv = 

    let _module = ModuleInstance.create_module_instance

    
    let exampleModule : Instructions =
        [
            Control (Block ("label", [
                Numeric (I32Const 42)
                Numeric (I32Const 42)
                Numeric (I32Add)
                Control Return
            ]))
        ]
    
    let f: Function = ([], [], exampleModule)

    let _module' = _module.add_function f

    let watCode = generate_module_code exampleModule
    printfn "%s" watCode
    0 // return an integer exit code