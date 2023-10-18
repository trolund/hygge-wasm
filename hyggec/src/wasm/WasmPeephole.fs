module WasmPeephole

open WGF.Module

/// Optimize a list of Text segment statements.
let rec internal optimizeInstr (code: Commented<Instr> list) : (Commented<Instr> list) =
    match code with
    // Optimization: remove a local.get immediately followed by a local.set 
    // of the same local variable. This is a common pattern when using local
    // variables as temporaries.
    | (LocalSet(l1), c1) :: (LocalGet(l2), c2) :: rest when l1 = l2 -> (LocalTee(l1), c1 + c2) :: optimizeInstr rest

    // no optimization case matched: continue with the rest
    | stmt :: rest ->
        // If we are here, we did not find any pattern to optimize: we skip the
        // first assembly statement and try with the rest
        stmt :: (optimizeInstr rest)
    | [] -> []


/// Optimize the given assembly code.
let optimize (m: Module) : Module =
    /// Recursively perform peephole optimization, until the result stops
    /// changing (i.e. there is nothning more we can optimize).
    // get all functions
    let funcs = m.GetAllFuncs()

    // for each function
    let funcs' =
        List.map
            (fun (name, (func, c)) ->
                // get all instructions
                let instrs = func.body

                // optimize all instructions
                let instrs' = optimizeInstr instrs

                (name, { func with body = instrs' }), c)
            funcs

    // replace all functions with the new ones that have been optimized
    m.ReplaceFuncs(funcs')

/// Count the number of instructions in the given module.
let CountInstr (m: Module) : int =
    // get all functions
    let funcs = m.GetAllFuncs()

    // count all instructions inside each function
    let numOfEachFunc =
        List.map
            (fun (name, (func, c)) ->
                // get all instructions
                let instrs = func.body

                List.length instrs)
            funcs

    // return sum of all instructions
    List.sum numOfEachFunc
