module WasmPeephole

open WGF.Module
open WGF.Types
open WGF.Instr
open WasmPeepholeHelper

/// Optimize a list of Text segment statements.
/// TODO: make sure that optimizeInstr are applied until the result stops changing
let rec internal optimizeInstr (code: Commented<WGF.Instr.Wasm> list) : (Commented<WGF.Instr.Wasm> list) =
    match code with
    // Optimization: remove a local.get immediately followed by a local.set
    // of the same local variable. This is a common pattern when using local
    // variables as temporaries.
    | (LocalSet(l1, instrs), c1) :: (LocalGet(l2), c2) :: rest when l1 = l2 ->
        (LocalTee(l1, instrs), c1 + c2) :: optimizeInstr rest


    // // Constant Multiplication by Powers of 2: replace `i32.const x` followed by `i32.mul` with `i32.shl x`. This is more efficient for multiplication by powers of 2
    // | (I32Const x, c1) :: (I32Mul, c2) :: rest when Peephole.isPowerOfTwo x ->

    //     let log2 x = log x / log 2.0
    //     let shamt = int(log2 x)

    //     (I32Const shamt, c1) :: (I32Shl, c2) :: optimizeInstr rest

    // Constant Division by Powers of 2:
    // replace `i32.const x` followed by `i32.div_s` with `i32.shr_s x`. This is more efficient for division by powers of 2
    // | (I32Const x, c1) :: (I32DivS, c2) :: rest when isPowerOfTwo x ->

    //     let log2 x = log x / log 2.0
    //     let shamt = int(log2 x)

    //     (I32Const shamt, c1) :: (I32ShrS, c2) :: optimizeInstr rest

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
    // | (I32Const 0, c1) :: (I32Add, c2) :: rest ->
    //     optimizeInstr rest

    // // Squaring a Value:
    // // Replace `i32.mul` with `i32.mul` for squaring a value.
    // | (I32Mul, c1) :: (I32Mul, c2) :: rest ->
    //     (I32Mul, c1 + c2) :: optimizeInstr rest

    // if get and set

    // check if the sub-tree of drop has a local.tee as the last instrction
    | (Drop(subTree), _) :: rest when isLocalTee (List.last subTree) ->
        // if it does, we can remove the drop
        // and replace the local.tee with a local.set
        let subTree' = List.take (List.length subTree - 1) subTree

        match List.last subTree with
        | (LocalTee(x, instrs), c) ->
            let localSet = (LocalSet(x, instrs), c)
            let rest' = optimizeInstr rest
            subTree' @ [ localSet ] @ rest'
        | _ -> failwith "should not happen"

    | (Drop(subTree), _) :: rest when (not (hasSideEffects subTree)) -> optimizeInstr rest

    // constant folding
    // authmatic constant folding
    | (I32Add(instrs), c1) :: rest when isConstConst instrs ->
        let (v1, v2) = (getI32ConstConst instrs)
        (I32Const(v1 + v2), c1) :: optimizeInstr rest
    | (I32Sub(instrs), c1) :: rest when isConstConst instrs ->
        let (v1, v2) = (getI32ConstConst instrs)
        (I32Const(v1 - v2), c1) :: optimizeInstr rest
    | (I32Mul(instrs), c1) :: rest when isConstConst instrs ->
        let (v1, v2) = (getI32ConstConst instrs)
        (I32Const(v1 * v2), c1) :: optimizeInstr rest
    | (I32DivS(instrs), c1) :: rest when isConstConst instrs ->
        let (v1, v2) = (getI32ConstConst instrs)
        (I32Const(v1 / v2), c1) :: optimizeInstr rest
    | (I32DivU(instrs), c1) :: rest when isConstConst instrs ->
        let (v1, v2) = (getI32ConstConst instrs)
        (I32Const(v1 / v2), c1) :: optimizeInstr rest
    | (I32RemS(instrs), c1) :: rest when isConstConst instrs ->
        let (v1, v2) = (getI32ConstConst instrs)
        (I32Const(v1 % v2), c1) :: optimizeInstr rest
    | (I32RemU(instrs), c1) :: rest when isConstConst instrs ->
        let (v1, v2) = (getI32ConstConst instrs)
        (I32Const(v1 % v2), c1) :: optimizeInstr rest
    | (I32And(instrs), c1) :: rest when isConstConst instrs ->
        let (v1, v2) = (getI32ConstConst instrs)
        (I32Const(v1 &&& v2), c1) :: optimizeInstr rest
    | (I32Or(instrs), c1) :: rest when isConstConst instrs ->
        let (v1, v2) = (getI32ConstConst instrs)
        (I32Const(v1 ||| v2), c1) :: optimizeInstr rest
    | (I32Xor(instrs), c1) :: rest when isConstConst instrs ->
        let (v1, v2) = (getI32ConstConst instrs)
        (I32Const(v1 ^^^ v2), c1) :: optimizeInstr rest
    // | (I32Shl, c1) :: rest when isConstConst rest ->
    //     let (v1, v2) = (getI32ConstConst rest)
    //     (I32Const(v1 <<< v2), c1) :: optimizeInstr rest
    // | (I32ShrS, c1) :: rest when isConstConst rest ->
    //     let (v1, v2) = (getI32ConstConst rest)
    //     (I32Const(v1 >>> v2), c1) :: optimizeInstr rest
    // | (I32ShrU, c1) :: rest when isConstConst rest ->
    //     let (v1, v2) = (getI32ConstConst rest)
    //     (I32Const(v1 >>> v2), c1) :: optimizeInstr rest
    | (F32Add(instrs), c1) :: rest when isConstConst instrs ->
        let (v1, v2) = (getF32ConstConst instrs)
        (F32Const(v1 + v2), c1) :: optimizeInstr rest
    | (F32Sub(instrs), c1) :: rest when isConstConst instrs ->
        let (v1, v2) = (getF32ConstConst instrs)
        (F32Const(v1 - v2), c1) :: optimizeInstr rest
    | (F32Mul(instrs), c1) :: rest when isConstConst instrs ->
        let (v1, v2) = (getF32ConstConst instrs)
        (F32Const(v1 * v2), c1) :: optimizeInstr rest
    | (F32Div(instrs), c1) :: rest when isConstConst instrs ->
        let (v1, v2) = (getF32ConstConst instrs)
        (F32Const(v1 / v2), c1) :: optimizeInstr rest

    // logical
    | (I32Eq(instrs), c1) :: rest when isConstConst instrs ->
        let (v1, v2) = (getI32ConstConst instrs)

        if v1 = v2 then
            (I32Const 1, c1) :: optimizeInstr rest
        else
            (I32Const 0, c1) :: optimizeInstr rest
    | (I32LtS(instrs), c1) :: rest when isConstConst instrs ->
        let (v1, v2) = (getI32ConstConst instrs)

        if v1 < v2 then
            (I32Const 1, c1) :: optimizeInstr rest
        else
            (I32Const 0, c1) :: optimizeInstr rest
    | (I32GtS(instrs), c1) :: rest when isConstConst instrs ->
        let (v1, v2) = (getI32ConstConst instrs)

        if v1 > v2 then
            (I32Const 1, c1) :: optimizeInstr rest
        else
            (I32Const 0, c1) :: optimizeInstr rest
    | (I32LeS(instrs), c1) :: rest when isConstConst instrs ->
        let (v1, v2) = (getI32ConstConst instrs)

        if v1 <= v2 then
            (I32Const 1, c1) :: optimizeInstr rest
        else
            (I32Const 0, c1) :: optimizeInstr rest
    | (I32GeS(instrs), c1) :: rest when isConstConst instrs ->
        let (v1, v2) = (getI32ConstConst instrs)

        if v1 >= v2 then
            (I32Const 1, c1) :: optimizeInstr rest
        else
            (I32Const 0, c1) :: optimizeInstr rest
    | (F32Eq(instrs), c1) :: rest when isConstConst instrs ->
        let (v1, v2) = (getF32ConstConst instrs)

        if v1 = v2 then
            (I32Const 1, c1) :: optimizeInstr rest
        else
            (I32Const 0, c1) :: optimizeInstr rest
    | (F32Lt(instrs), c1) :: rest when isConstConst instrs ->
        let (v1, v2) = (getF32ConstConst instrs)

        if v1 < v2 then
            (I32Const 1, c1) :: optimizeInstr rest
        else
            (I32Const 0, c1) :: optimizeInstr rest
    | (F32Gt(instrs), c1) :: rest when isConstConst instrs ->
        let (v1, v2) = (getF32ConstConst instrs)

        if v1 > v2 then
            (I32Const 1, c1) :: optimizeInstr rest
        else
            (I32Const 0, c1) :: optimizeInstr rest
    | (F32Le(instrs), c1) :: rest when isConstConst instrs ->
        let (v1, v2) = (getF32ConstConst instrs)

        if v1 <= v2 then
            (I32Const 1, c1) :: optimizeInstr rest
        else
            (I32Const 0, c1) :: optimizeInstr rest
    | (F32Ge(instrs), c1) :: rest when isConstConst instrs ->
        let (v1, v2) = (getF32ConstConst instrs)

        if v1 >= v2 then
            (I32Const 1, c1) :: optimizeInstr rest
        else
            (I32Const 0, c1) :: optimizeInstr rest

    | (I32Eqz(instrs), c1) :: rest when isI32Const instrs ->
        let v = (getI32Const instrs)

        if v = 0 then
            (I32Const 1, c1) :: optimizeInstr rest
        else
            (I32Const 0, c1) :: optimizeInstr rest

    | (If(t, cond, ifTrue, ifFalse), c1) :: rest when isI32Const cond ->
        let v = (getI32Const cond)

        if v = 0 then
            match ifFalse with
            | Some ifFalse -> ifFalse @ optimizeInstr rest
            | None -> optimizeInstr rest
        else
            optimizeInstr ifTrue @ optimizeInstr rest

    // // tee local drop
    // | (LocalTee (x, instrs), c) :: (Drop, _) :: rest ->
    //     // should be a local.set
    //     (LocalSet (x, instrs), c) :: optimizeInstr rest

    // // if a value is pushed on the stack and then dropped, we can remove both
    // | (I32Const _, _) :: (Drop, _) :: rest ->
    //     optimizeInstr rest

    // // global.get and then drop
    // | (GlobalGet _, _) :: (Drop, _) :: rest ->
    //     optimizeInstr rest

    // terverse nested nodes
    // terverse if
    | (If(t, cond, ifTrue, ifFalse), c1) :: rest ->
        let cond' = optimizeInstr cond
        let ifTrue' = optimizeInstr ifTrue

        let ifFalse' =
            match ifFalse with
            | Some ifFalse -> Some(optimizeInstr ifFalse)
            | None -> ifFalse

        let rest' = optimizeInstr rest

        (If(t, cond', ifTrue', ifFalse'), c1) :: rest'

    // terverse block
    | (Block(l, t, instrs), c1) :: rest ->
        let instrs' = optimizeInstr instrs
        let rest' = optimizeInstr rest
        (Block(l, t, instrs'), c1) :: rest'

    // terverse loop
    | (Loop(l, t, instrs), c1) :: rest ->
        let instrs' = optimizeInstr instrs
        let rest' = optimizeInstr rest
        (Loop(l, t, instrs'), c1) :: rest'

    // loads
    | (I32Load(instrs), c) :: rest ->
        let instrs' = optimizeInstr instrs
        (I32Load(instrs'), c) :: optimizeInstr rest

    | (I32Load_(align, offset, instrs), c) :: rest ->
        let instrs' = optimizeInstr instrs
        (I32Load_(align, offset, instrs'), c) :: optimizeInstr rest

    | (F32Load(instrs), c) :: rest ->
        let instrs' = optimizeInstr instrs
        (F32Load(instrs'), c) :: optimizeInstr rest

    | (F32Load_(align, offset, instrs), c) :: rest ->
        let instrs' = optimizeInstr instrs
        (F32Load_(align, offset, instrs'), c) :: optimizeInstr rest

    // stores
    | (I32Store(instrs), c) :: rest ->
        let instrs' = optimizeInstr instrs
        (I32Store(instrs'), c) :: optimizeInstr rest

    | (I32Store_(align, offset, instrs), c) :: rest ->
        let instrs' = optimizeInstr instrs
        (I32Store_(align, offset, instrs'), c) :: optimizeInstr rest

    | (F32Store(instrs), c) :: rest ->
        let instrs' = optimizeInstr instrs
        (F32Store(instrs'), c) :: optimizeInstr rest

    | (F32Store_(align, offset, instrs), c) :: rest ->
        let instrs' = optimizeInstr instrs
        (F32Store_(align, offset, instrs'), c) :: optimizeInstr rest

    | (I32Eqz(instrs), c) :: rest -> (I32Eqz(optimizeInstr instrs), c) :: optimizeInstr rest

    | (I32Eq(instrs), c) :: rest -> (I32Eq(optimizeInstr instrs), c) :: optimizeInstr rest

    | (I32LtS(instrs), c) :: rest -> (I32LtS(optimizeInstr instrs), c) :: optimizeInstr rest

    | (I32GtS(instrs), c) :: rest -> (I32GtS(optimizeInstr instrs), c) :: optimizeInstr rest

    | (I32LeS(instrs), c) :: rest -> (I32LeS(optimizeInstr instrs), c) :: optimizeInstr rest

    | (I32GeS(instrs), c) :: rest -> (I32GeS(optimizeInstr instrs), c) :: optimizeInstr rest

    | (F32Eq(instrs), c) :: rest -> (F32Eq(optimizeInstr instrs), c) :: optimizeInstr rest

    | (F32Lt(instrs), c) :: rest -> (F32Lt(optimizeInstr instrs), c) :: optimizeInstr rest

    | (F32Gt(instrs), c) :: rest -> (F32Gt(optimizeInstr instrs), c) :: optimizeInstr rest

    | (F32Le(instrs), c) :: rest -> (F32Le(optimizeInstr instrs), c) :: optimizeInstr rest

    | (F32Ge(instrs), c) :: rest -> (F32Ge(optimizeInstr instrs), c) :: optimizeInstr rest

    | (I32Add(instrs), c) :: rest -> (I32Add(optimizeInstr instrs), c) :: optimizeInstr rest

    | (I32Sub(instrs), c) :: rest -> (I32Sub(optimizeInstr instrs), c) :: optimizeInstr rest

    | (I32Mul(instrs), c) :: rest -> (I32Mul(optimizeInstr instrs), c) :: optimizeInstr rest

    | (I32DivS(instrs), c) :: rest -> (I32DivS(optimizeInstr instrs), c) :: optimizeInstr rest

    | (I32DivU(instrs), c) :: rest -> (I32DivU(optimizeInstr instrs), c) :: optimizeInstr rest

    | (I32RemS(instrs), c) :: rest -> (I32RemS(optimizeInstr instrs), c) :: optimizeInstr rest

    | (I32RemU(instrs), c) :: rest -> (I32RemU(optimizeInstr instrs), c) :: optimizeInstr rest

    | (I32And(instrs), c) :: rest -> (I32And(optimizeInstr instrs), c) :: optimizeInstr rest

    | (I32Or(instrs), c) :: rest -> (I32Or(optimizeInstr instrs), c) :: optimizeInstr rest

    | (I32Xor(instrs), c) :: rest -> (I32Xor(optimizeInstr instrs), c) :: optimizeInstr rest

    | (F32Add(instrs), c) :: rest -> (F32Add(optimizeInstr instrs), c) :: optimizeInstr rest

    | (F32Sub(instrs), c) :: rest -> (F32Sub(optimizeInstr instrs), c) :: optimizeInstr rest

    | (F32Mul(instrs), c) :: rest -> (F32Mul(optimizeInstr instrs), c) :: optimizeInstr rest

    | (F32Div(instrs), c) :: rest -> (F32Div(optimizeInstr instrs), c) :: optimizeInstr rest

    | (Drop(instrs), c) :: rest -> (Drop(optimizeInstr instrs), c) :: optimizeInstr rest

    | (MemoryGrow(instrs), c) :: rest -> (MemoryGrow(optimizeInstr instrs), c) :: optimizeInstr rest

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

                // run the optimization, until the result stops changing
                let rec optimizeInstrUntilStable
                    (instrs: Commented<WGF.Instr.Wasm> list)
                    : Commented<WGF.Instr.Wasm> list =
                    let instrs' = optimizeInstr instrs

                    if instrs' = instrs then
                        instrs
                    else
                        optimizeInstrUntilStable instrs'

                // optimize all instructions
                let instrs' = optimizeInstrUntilStable instrs

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

                countFunctionInstrs instrs)
            funcs

    // return sum of all instructions
    List.sum numOfEachFunc