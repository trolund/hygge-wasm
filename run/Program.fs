module Wat.test

open Wasm
open WasmTimeDriver

[<EntryPoint>]
let main argv = 

    let _module = ModuleInstance.create_module_instance

    // create a main function with the types 
    let body : Instructions =
        [
                Numeric (I32Const 42)
                Numeric (I32Const 42)
                Numeric (I32Add)
                Control Return
        ]
    
    let f: Function =  ([], [ValueType.I32]), [], body

    let new_module = _module.add_function(f)

    // let watCode = generate_module_code exampleModule
    let watCode = generate_module_code_ new_module
    printfn "%s" watCode
    
    let vm = WasmVM()

    let res = vm.RunFile(opt.File)
    
    0 // return an integer exit code