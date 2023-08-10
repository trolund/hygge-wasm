module Wat.test

open Wasm
open WasmTimeDriver

let runCode target watCode = 
    let vm = WasmVM()
    let result = vm.RunWat(target, watCode)
    printfn "%A" result

[<EntryPoint>]
let main argv = 

    // create a main function with the types 
    let funcName = "start"

    let body : Instructions =
        [
                Numeric (I32Const 42)
                Numeric (I32Const 42)
                Numeric (I32Add)
                Control Return
        ]

    let f: Function = Some(funcName), ([], [I32]), [], body

    let _module = Module.create_module_instance
                                            .add_function(f)
                                            .add_export(funcName, FunctionType(funcName))

    // let watCode = generate_module_code exampleModule
    let watCode = generate_module_code_ _module
    printfn "%s" watCode

    runCode funcName watCode
    0 // return an integer exit code
