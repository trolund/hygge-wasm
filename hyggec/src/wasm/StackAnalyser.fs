module hyggec.Analisys

open WGF.Module
open WGF.Types

let repeatDrop (n: int) : (Commented<Instr> list) =
    let rec repeatDrop' (n: int) (acc: (Commented<Instr> list)) : (Commented<Instr> list) =
        if n = 0 then acc
        else repeatDrop' (n - 1) ((Drop, "drop value on stack!") :: acc)
    repeatDrop' n []

// algorithem that will insert drop instructions to the stack when the stack is not balanced
let rec internal analyseStack (instrs: Commented<Instr> list) (stackSize: int) : (Commented<Instr> list * int) =
    match instrs with
    | (instr, c) :: rest ->
        match instr with
        // all i32 instructions that push to the stack
        | I32Const _ ->
            let stackSize' = stackSize + 1
            let instrs', size = analyseStack rest stackSize'
            (instr, c) :: instrs', size
        | I32Add ->
            // add pops 2 and pushes 1
            let stackSize' = stackSize - 1
            let instrs', size = analyseStack rest stackSize'
            (instr, c) :: instrs', size
        | I32Sub ->
            // sub pops 2 and pushes 1
            let stackSize' = stackSize - 1
            let instrs', size = analyseStack rest stackSize'
            (instr, c) :: instrs', size
        | I32Mul ->
            // mul pops 2 and pushes 1
            let stackSize' = stackSize - 1
            let instrs', size = analyseStack rest stackSize'
            (instr, c) :: instrs', size
        | I32DivS ->
            // div pops 2 and pushes 1
            let stackSize' = stackSize - 1
            let instrs', size = analyseStack rest stackSize'
            (instr, c) :: instrs', size
        | I32RemS ->
            // rem pops 2 and pushes 1
            let stackSize' = stackSize - 1
            let instrs', size = analyseStack rest stackSize'
            (instr, c) :: instrs', size
        | I32And ->
            // and pops 2 and pushes 1
            let stackSize' = stackSize - 1
            let instrs', size = analyseStack rest stackSize'
            (instr, c) :: instrs', size
        | I32Or ->
            // or pops 2 and pushes 1
            let stackSize' = stackSize - 1
            let instrs', size = analyseStack rest stackSize'
            (instr, c) :: instrs', size
        | I32Xor ->
            // xor pops 2 and pushes 1
            let stackSize' = stackSize - 1
            let instrs', size = analyseStack rest stackSize'
            (instr, c) :: instrs', size
        | I32Shl ->
            // shl pops 2 and pushes 1
            let stackSize' = stackSize - 1
            let instrs', size = analyseStack rest stackSize'
            (instr, c) :: instrs', size
        | I32ShrS ->
            // shr pops 2 and pushes 1
            let stackSize' = stackSize - 1
            let instrs', size = analyseStack rest stackSize'
            (instr, c) :: instrs', size
        | I32Eqz ->
            // eqz pops 1 and pushes 1
            let instrs', size = analyseStack rest stackSize
            (instr, c) :: instrs', size
        | I32Eq ->
            // eq pops 2 and pushes 1
            let stackSize' = stackSize - 1
            let instrs', size = analyseStack rest stackSize'
            (instr, c) :: instrs', size
        | I32Ne ->
            // ne pops 2 and pushes 1
            let stackSize' = stackSize - 1
            let instrs', size = analyseStack rest stackSize'
            (instr, c) :: instrs', size
        | I32LtS ->
            // lt pops 2 and pushes 1
            let stackSize' = stackSize - 1
            let instrs', size = analyseStack rest stackSize'
            (instr, c) :: instrs', size
        | I32LeS ->
            // le pops 2 and pushes 1
            let stackSize' = stackSize - 1
            let instrs', size = analyseStack rest stackSize'
            (instr, c) :: instrs', size
        | I32GtS ->
            // gt pops 2 and pushes 1
            let stackSize' = stackSize - 1
            let instrs', size = analyseStack rest stackSize'
            (instr, c) :: instrs', size
        | I32GeS ->
            // ge pops 2 and pushes 1
            let stackSize' = stackSize - 1
            let instrs', size = analyseStack rest stackSize'
            (instr, c) :: instrs', size
        | I32WrapI64 ->
            // wrap pops 1 and pushes 1
            let instrs', size = analyseStack rest stackSize
            (instr, c) :: instrs', size
        // | I32TruncSF32 ->
        //     // trunc pops 1 and pushes 1
        //     (instr, c) :: analyseStack rest stackSize
        // | I32TruncUF32 ->
        //     // trunc pops 1 and pushes 1
        //     (instr, c) :: analyseStack rest stackSize
        // | I32TruncSF64 ->
        //     // trunc pops 1 and pushes 1
        //     (instr, c) :: analyseStack rest stackSize
        // | I32TruncUF64 ->   
        //     // trunc pops 1 and pushes 1
        //     (instr, c) :: analyseStack rest stackSize
        | I32ReinterpretF32 ->
            // reinterpret pops 1 and pushes 1
            let instrs', size = analyseStack rest stackSize
            (instr, c) :: instrs', size
        | I32Load ->
            // load pops 1 and pushes 1
            let instrs', size = analyseStack rest stackSize
            (instr, c) :: instrs', size
        | I32Store ->
            // store pops 2 and pushes 0
            let stackSize' = stackSize - 2
            let instrs', size = analyseStack rest stackSize'
            (instr, c) :: instrs', size
        | I32Load8S _ ->
            // load8s pops 1 and pushes 1
            let instrs', size = analyseStack rest stackSize
            (instr, c) :: instrs', size
        | I32Load8U _ ->
            // load8u pops 1 and pushes 1
            let instrs', size = analyseStack rest stackSize
            (instr, c) :: instrs', size
        | I32Load16S _ ->
            // load16s pops 1 and pushes 1
            let instrs', size = analyseStack rest stackSize
            (instr, c) :: instrs', size
        | I32Load16U _ ->
            // load16u pops 1 and pushes 1
            let instrs', size = analyseStack rest stackSize
            (instr, c) :: instrs', size
        | I32Store8 _ ->
            // store8 pops 2 and pushes 0
            let stackSize' = stackSize - 2
            let instrs', size = analyseStack rest stackSize'
            (instr, c) :: instrs', size
        | I32Store16 _ ->
            // store16 pops 2 and pushes 0
            let stackSize' = stackSize - 2
            let instrs', size = analyseStack rest stackSize'
            (instr, c) :: instrs', size
        | I32Clz ->
            // clz pops 1 and pushes 1
            let instrs', size = analyseStack rest stackSize
            (instr, c) :: instrs', size
        | I32Ctz ->
            // ctz pops 1 and pushes 1
            let instrs', size = analyseStack rest stackSize
            (instr, c) :: instrs', size
        | I32Popcnt ->
            // popcnt pops 1 and pushes 1
            let instrs', size = analyseStack rest stackSize
            (instr, c) :: instrs', size
        | I32Rotl ->
            // rotl pops 3 and pushes 1
            let stackSize' = stackSize - 2
            let instrs', size = analyseStack rest stackSize'
            (instr, c) :: instrs', size
        | I32Rotr ->
            // rotr pops 3 and pushes 1
            let stackSize' = stackSize - 2
            let instrs', size = analyseStack rest stackSize'
            (instr, c) :: instrs', size
       // block instr
       // here we need to check if the block is balanced
        | Block (l, t, instrs') ->
            let instrs', size = analyseStack instrs' stackSize
            let instrs'', size' = analyseStack rest (stackSize + size)
            let instrs''' = repeatDrop (size' - size)
            (Block (l, t, instrs'), c) :: instrs''' @ instrs'', size
        | Loop (l, t, instrs') ->
            let instrs', size = analyseStack instrs' stackSize
            let instrs'', size' = analyseStack rest (stackSize + size)
            let instrs''' = repeatDrop (size' - size)
            (Loop (l, t, instrs'), c) :: instrs''' @ instrs'', size
        | If (t, instrs1, instrs2) ->
            match instrs2  with
            | Some(instrs2') -> 
                let instrs1', size1 = analyseStack instrs1 stackSize
                let instrs2', size2 = analyseStack instrs2' stackSize
                let instrs'', size' = analyseStack rest (stackSize + size1 + size2)
                let instrs''' = repeatDrop (size' - size1 - size2)
                (If (t, instrs1', Some(instrs2')), c) :: instrs''' @ instrs'', size1 + size2
            | None ->
                let instrs1', size1 = analyseStack instrs1 stackSize
                let instrs'', size' = analyseStack rest (stackSize + size1)
                let instrs''' = repeatDrop (size' - size1)
                (If (t, instrs1', None), c) :: instrs''' @ instrs'', size1
    | [] -> ([], stackSize)

// this function will trim the stack
let trimStack (m: Module): Module = 
    // get all functions
    let funcs = m.GetAllFuncs()

    // for each function
    let funcs' =
        List.map
            (fun (name, (func, c)) ->
                let instrs', _ = analyseStack func.body 0

                (name,
                 { func with
                     body = instrs'
                     }),
                c)
            funcs

    m.ReplaceFuncs(funcs')