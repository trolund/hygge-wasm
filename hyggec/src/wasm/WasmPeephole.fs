module WasmPeephole

open WGF.Module
open WGF.Types
open Util

/// Optimize a list of Text segment statements.
/// TODO: make sure that optimizeInstr are applied until the result stops changing
let rec internal optimizeInstr (code: Commented<Instr> list) : (Commented<Instr> list) =
    match code with
    // Optimization: remove a local.get immediately followed by a local.set 
    // of the same local variable. This is a common pattern when using local
    // variables as temporaries.
    | (LocalSet(l1), c1) :: (LocalGet(l2), c2) :: rest when l1 = l2 -> (LocalTee(l1), c1 + c2) :: optimizeInstr rest

    // Constant Multiplication by Powers of 2: replace `i32.const x` followed by `i32.mul` with `i32.shl x`. This is more efficient for multiplication by powers of 2
    | (I32Const x, c1) :: (I32Mul, c2) :: rest when isPowerOfTwo x -> 

        let log2 x = log x / log 2.0
        let shamt = int(log2 x)

        (I32Const shamt, c1) :: (I32Shl, c2) :: optimizeInstr rest

    // Constant Division by Powers of 2:
    // replace `i32.const x` followed by `i32.div_s` with `i32.shr_s x`. This is more efficient for division by powers of 2
    | (I32Const x, c1) :: (I32DivS, c2) :: rest when isPowerOfTwo x -> 

        let log2 x = log x / log 2.0
        let shamt = int(log2 x)

        (I32Const shamt, c1) :: (I32ShrS, c2) :: optimizeInstr rest

    // const x, const y, i32.add followed by drop can be replaced with nothing
    | (I32Const x, c1) :: (I32Const y, c2) :: (I32Add, c3) :: (Drop, c4) :: rest -> 
        optimizeInstr rest
    | (I32Const x, c1) :: (I32Const y, c2) :: (I32Sub, c3) :: (Drop, c4) :: rest -> 
        optimizeInstr rest
    | (I32Const x, c1) :: (I32Const y, c2) :: (I32Mul, c3) :: (Drop, c4) :: rest ->
        optimizeInstr rest
    | (I32Const x, c1) :: (I32Const y, c2) :: (I32DivS, c3) :: (Drop, c4) :: rest ->
        optimizeInstr rest
    | (I32Const x, c1) :: (I32Const y, c2) :: (I32RemS, c3) :: (Drop, c4) :: rest ->
        optimizeInstr rest
    // | (I32Const x, c1) :: (I32Const y, c2) :: (I32And, c3) :: (Drop, c4) :: rest ->
    //     optimizeInstr rest
    // | (I32Const x, c1) :: (I32Const y, c2) :: (I32Or, c3) :: (Drop, c4) :: rest ->
    //     optimizeInstr rest
    // | (I32Const x, c1) :: (I32Const y, c2) :: (I32Xor, c3) :: (Drop, c4) :: rest ->
    //     optimizeInstr rest
    // | (I32Const x, c1) :: (I32Const y, c2) :: (I32Shl, c3) :: (Drop, c4) :: rest ->
    //     optimizeInstr rest
    // | (I32Const x, c1) :: (I32Const y, c2) :: (I32ShrS, c3) :: (Drop, c4) :: rest ->
    //     optimizeInstr rest
    // | (I32Const x, c1) :: (I32Const y, c2) :: (I32ShrU, c3) :: (Drop, c4) :: rest ->
    //     optimizeInstr rest
    // | (I32Const x, c1) :: (I32Const y, c2) :: (I32Rotl, c3) :: (Drop, c4) :: rest ->
    //     optimizeInstr rest
    // | (I32Const x, c1) :: (I32Const y, c2) :: (I32Rotr, c3) :: (Drop, c4) :: rest ->
    //     optimizeInstr rest

    // global get drop
    | (GlobalGet x, c1) :: (Drop, c2) :: rest ->
        optimizeInstr rest
    // local get drop
    | (LocalGet x, c1) :: (Drop, c2) :: rest ->
        optimizeInstr rest

    // // Bitwise AND for Modulo by Power of 2:
    // // replace `i32.const x` followed by `i32.and` with `i32.and (x-1)`. This is more efficient for modulo by powers of 2
    // | (I32Const x, c1) :: (I32And, c2) :: rest when isPowerOfTwo x -> 

    //     let x' = x - 1

    //     (I32Const x', c1) :: (I32And, c2) :: optimizeInstr rest

    // // replace `i32.const 0` followed by `i32.eqz` with `i32.eqz`. 
    // | (I32Const 0, c1) :: (I32Eqz, c2) :: rest -> 

    //     (I32Eqz, c1 + c2) :: optimizeInstr rest

    // Zero Initialization:
    // Replace `i32.const 0` followed by `i32.add` with the original value. This is an optimization when adding zero.
    | (I32Const 0, c1) :: (I32Add, c2) :: rest -> 
        optimizeInstr rest

    // // Squaring a Value:
    // // Replace `i32.mul` with `i32.mul` for squaring a value.
    // | (I32Mul, c1) :: (I32Mul, c2) :: rest -> 
    //     (I32Mul, c1 + c2) :: optimizeInstr rest

    // if a value is pushed on the stack and then dropped, we can remove both
    | (I32Const x, c1) :: (Drop, c2) :: rest -> 
        optimizeInstr rest
        
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
