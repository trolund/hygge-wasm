module Wat.test

open Wasm

[<EntryPoint>]
let main argv = 

    let exampleModule : Module =
        [
            Control (Block ("label", [
                Numeric (I32Const 42)
                Numeric (I32Const 42)
                Numeric (I32Add)
                Control Return
            ]))
        ]

    let watCode = generate_module_code exampleModule
    printfn "%s" watCode
    0 // return an integer exit code