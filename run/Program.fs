module Wat.test

open WFG
open WasmTimeDriver

let runCode target watCode = 
    let vm = WasmVM()
    let result = vm.RunWat(target, watCode)
    printfn "return: %A" result

let sec = 
        // create a main function with the types 
    let funcName = "start"

    let body : List<Instr> =
        [
                I32Const 41
                I32Const 42
                I32Add
                Return
        ]

    let f: Function = Some(funcName), ([], [I32]), [], body

    let _module = Module().AddFunction(f, "function 1").AddExport(funcName, FunctionType(funcName))
                                 
    // generate the wat code
    let watCode = _module.ToString()
    printfn "%s" watCode
    write_wasm_file watCode "test.wat"

    // run the wat code with wasmtime 
    runCode funcName watCode

// [<EntryPoint>]
// let main argv = 
//    // first |> ignore
//     //sec |> ignore

//     0 // return an integer exit code

