module WasmPeepholeHelper

open WGF.Types
open WGF.Instr

// function that check if a sub-tree contains side effects
// in this case that is local and global set and memory store
let rec hasSideEffects (instrs: Commented<WGF.Instr.Wasm> list) : bool =
    match instrs with
    | (LocalSet _, _) :: rest -> true
    | (GlobalSet _, _) :: rest -> true
    | (I32Store _, _) :: rest -> true
    | (I32Store_ _, _) :: rest -> true
    | (F32Store _, _) :: rest -> true
    | (F32Store_ _, _) :: rest -> true
    | (LocalTee _, _) :: rest -> true   
    | (Call _, _) :: rest -> true
    | (CallIndirect _, _) :: rest -> true
    | (StructSet _, _) :: rest -> true
    | (ArraySet _, _) :: rest -> true

    | (If (_, con, ifTrue, ifFalse), _) :: rest -> 
        hasSideEffects con ||
        hasSideEffects ifTrue || 
        match ifFalse with
        | Some ifFalse -> hasSideEffects ifFalse
        | None -> false
    
    | (Block (_, _, instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (Loop (_, _, instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (I32Load(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (I32Load_(align, offset, instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (F32Load(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (F32Load_(align, offset, instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (I32Eqz(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest

    | (I32Eq(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest

    | (I32LtS(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (I32GtS(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (I32LeS(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (I32GeS(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (F32Eq(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (F32Lt(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (F32Gt(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (F32Le(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (F32Ge(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (I32Add(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest

    | (I32Sub(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (I32Mul(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest

    | (I32DivS(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (I32DivU(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (I32RemS(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (I32RemU(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (I32And(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (I32Or(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest

    | (I32Xor(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (F32Add(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (F32Sub(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (F32Mul(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest
    
    | (F32Div(instrs), _) :: rest ->
        hasSideEffects instrs || hasSideEffects rest

    | (Drop(subTree), _) :: rest when (hasSideEffects subTree) -> 
        true

    | _ :: rest -> hasSideEffects rest
    | [] -> false

let isLocalTee instr = 
    match instr with
    | (LocalTee _, _) -> true
    | _ -> false

// contains two I32Const instructions or two F32Const instructions
let isConstConst (instrs: Commented<Wasm> list) =
    if instrs.Length > 2 then
        false
    else

    match instrs with
    | (I32Const _, _) :: (I32Const _, _) :: _ -> true
    | (F32Const _, _) :: (F32Const _, _) :: _ -> true
    | _ -> false

// getConstConst
let getI32ConstConst (instrs: Commented<Wasm> list): int * int =
    match instrs with
    | (I32Const (i1), _) :: (I32Const (i2), _) :: _ -> (i1, i2)
    | _ -> failwith "getConstConst: did not find two constants"

let getF32ConstConst (instrs: Commented<Wasm> list) =
    match instrs with
    | (F32Const (f1), _) :: (F32Const (f2), _) :: _ -> (f1, f2)
    | _ -> failwith "getConstConst: did not find two constants"

// isConst
let isI32Const (instrs: Commented<Wasm> list) =
    match instrs with
    | (I32Const _, _) :: _ -> true
    | _ -> false

// getI32Const
let getI32Const (instrs: Commented<Wasm> list) =
    match instrs with
    | (I32Const (i), _) :: _ -> i
    | _ -> failwith "getConst: did not find a constant"

let rec countFunctionInstrs (instrs: Commented<Wasm> list) : int =
    match instrs with
    | (LocalSet (_, instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (GlobalSet (_, instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (I32Store (instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (I32Store_ (_, _, instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (F32Store (instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (F32Store_ (_, _, instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (LocalTee (_, instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (Call (_), _) :: rest -> 1 + countFunctionInstrs rest
    | (CallIndirect (_), _) :: rest -> 1 + countFunctionInstrs rest
    | (If (_, con, ifTrue, ifFalse), _) :: rest -> 1 + (countFunctionInstrs con) + (countFunctionInstrs ifTrue) + (match ifFalse with | Some ifFalse -> countFunctionInstrs ifFalse | None -> 0) + countFunctionInstrs rest
    | (Block (_, _, instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (Loop (_, _, instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (I32Load(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (I32Load_(_, _, instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (F32Load(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (F32Load_(_, _, instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (I32Eqz(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (I32Eq(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (I32LtS(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (I32GtS(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (I32LeS(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (I32GeS(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (F32Eq(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (F32Lt(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (F32Gt(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (F32Le(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (F32Ge(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (I32Add(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (I32Sub(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (I32Mul(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (I32DivS(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (I32DivU(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (I32RemS(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (I32RemU(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (I32And(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (I32Or(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (I32Xor(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (F32Add(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (F32Sub(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (F32Mul(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (F32Div(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (Drop(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (MemoryGrow(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (F32Sqrt(instrs'), _) :: rest -> 1 + (countFunctionInstrs instrs') + countFunctionInstrs rest
    | (F32Const _, _) :: rest -> 1 + countFunctionInstrs rest
    | (I32Const _, _) :: rest -> 1 + countFunctionInstrs rest
    | (LocalGet _, _) :: rest -> 1 + countFunctionInstrs rest
    | (GlobalGet _, _) :: rest -> 1 + countFunctionInstrs rest
    | (MemorySize, _) :: rest -> 1 + countFunctionInstrs rest
    | (Br _, _) :: rest -> 1 + countFunctionInstrs rest
    | (BrIf _, _) :: rest -> 1 + countFunctionInstrs rest
    | (BrTable _, _) :: rest -> 1 + countFunctionInstrs rest
    | (Return, _) :: rest -> 1 + countFunctionInstrs rest
    | (F32Ceil, _) :: rest -> 1 + countFunctionInstrs rest
    | (F32Floor, _) :: rest -> 1 + countFunctionInstrs rest
    | (F32Trunc, _) :: rest -> 1 + countFunctionInstrs rest
    | (F32Nearest, _) :: rest -> 1 + countFunctionInstrs rest
    | (F32Abs, _) :: rest -> 1 + countFunctionInstrs rest
    | (F32Neg, _) :: rest -> 1 + countFunctionInstrs rest
    | (F32Copysign, _) :: rest -> 1 + countFunctionInstrs rest
    | (I32Clz, _) :: rest -> 1 + countFunctionInstrs rest
    | (I32Ctz, _) :: rest -> 1 + countFunctionInstrs rest
    | (I32Popcnt, _) :: rest -> 1 + countFunctionInstrs rest
    | (I32Rotl, _) :: rest -> 1 + countFunctionInstrs rest
    | (I32Rotr, _) :: rest -> 1 + countFunctionInstrs rest
    | (I32Shl, _) :: rest -> 1 + countFunctionInstrs rest
    | (I32ShrS, _) :: rest -> 1 + countFunctionInstrs rest
    | (I32ShrU, _) :: rest -> 1 + countFunctionInstrs rest
    | (Select, _) :: rest -> 1 + countFunctionInstrs rest
    | (F32Max, _) :: rest -> 1 + countFunctionInstrs rest
    | (F32Min, _) :: rest -> 1 + countFunctionInstrs rest

    | (Unreachable, _) :: rest -> 1 + countFunctionInstrs rest

    // does not count comments
    | (Comment _, _) :: rest -> countFunctionInstrs rest

    | _ :: rest -> failwith "did not recognize instruction"
    | [] -> 0