module Wat.test

open WFG
open WasmTimeDriver

let runCode target watCode = 
    let vm = WasmVM()
    let result = vm.RunWat(target, watCode)
    printfn "return: %A" result

let first = 
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

    // generate the wat code
    let watCode = generate_module_code _module
    // printfn "%s" watCode

    // run the wat code with wasmtime 
    runCode funcName watCode

let sec = 
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
    let f2: Function = Some(funcName + "2"), ([], [I32]), [], body

    let _module = Wasm().AddFunction(f).AddExport(funcName, FunctionType(funcName)) + 
                        Wasm().AddFunction(f2).AddExport(funcName + "2", FunctionType(funcName + "2"))
                                 
    // generate the wat code
    let watCode = generate_module_code _module
    printfn "%s" watCode

    // run the wat code with wasmtime 
    runCode funcName watCode

[<EntryPoint>]
let main argv = 
    first |> ignore



    0 // return an integer exit code

