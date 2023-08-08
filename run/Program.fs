module Wat.test

open Wasm

let wat_of_instruction instruction =
    match instruction with
    | Parametric parametric -> parametric.ToString()
    | Numeric numeric -> numeric.ToString()
    | Control control -> control.ToString()
    | Variable variable -> variable.ToString()
    | Memory memory -> memory.ToString()
    

let generate_wat_code instructions =

    // function that acummulates the wat code from a list of instructions
    let rec generate_wat_code_aux instructions watCode =
        match instructions with
        | [] -> watCode
        | instruction :: instructions -> generate_wat_code_aux instructions (watCode + (wat_of_instruction instruction) + "\n")

    generate_wat_code_aux instructions ""

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

    let watCode = generate_wat_code exampleModule
    printfn "%s" watCode
    0 // return an integer exit code