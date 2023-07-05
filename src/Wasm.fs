// hyggec - The didactic compiler for the Hygge programming language.
// Copyright (C) 2023 Technical University of Denmark
// Author: Troels Lund <s161791@dtu.dk>
// Released under the MIT license (see LICENSE.md for details)

module hyggec.Wasm

type ValueType =
    | I32
    | I64
    | F32
    | F64

type ControlInstruction =
    | Unreachable
    | Nop
    | Block of ValueType list * Instruction list
    | Loop of ValueType list * Instruction list
    | If of ValueType list * ValueType list * Instruction list * Instruction list
    | Br of int
    | BrIf of int
    | BrTable of int list * int
    | Return
and Instruction =
    | Control of ControlInstruction
    | Parametric of ParametricInstruction
    | Variable of VariableInstruction
    | Memory of MemoryInstruction
    | Numeric of NumericInstruction
    | Unknown of string
    
and  ParametricInstruction =
    | Drop
    | Select

and VariableInstruction =
    | LocalGet of int
    | LocalSet of int
    | LocalTee of int
    | GlobalGet of int
    | GlobalSet of int

and MemoryInstruction =
    | I32Load of int * int
    | I64Load of int * int
    | F32Load of int * int
    | F64Load of int * int
    | I32Load8S of int * int
    | I32Load8U of int * int
    | I32Load16S of int * int
    | I32Load16U of int * int
    | I64Load8S of int * int
    | I64Load8U of int * int
    | I64Load16S of int * int
    | I64Load16U of int * int
    | I64Load32S of int * int
    | I64Load32U of int * int
    | I32Store of int * int
    | I64Store of int * int
    | F32Store of int * int
    | F64Store of int * int
    | I32Store8 of int * int
    | I32Store16 of int * int
    | I64Store8 of int * int
    | I64Store16 of int * int
    | I64Store32 of int * int
    | MemorySize
    | MemoryGrow

and NumericInstruction =
    | I32Const of int32
    | I64Const of int64
    | F32Const of float32
    | F64Const of float
    | I32Eqz
    | I32Eq
    | I32Ne
    | I32LtS
    | I32LtU
    | I32GtS
    | I32GtU
    | I32LeS
    | I32LeU
    | I32GeS
    | I32GeU
    | I64Eqz
    | I64Eq
    | I64Ne
    | I64LtS
    | I64LtU
    | I64GtS
    | I64GtU
    | I64LeS
    | I64LeU
    | I64GeS
    | I64GeU
    | F32Eq
    | F32Ne
    | F32Lt
    | F32Gt
    | F32Le
    | F32Ge
    | F64Eq
    | F64Ne
    | F64Lt
    | F64Gt
    | F64Le
    | F64Ge
    | I32Clz
    | I32Ctz
    | I32Popcnt
    | I32Add
    | I32Sub
    | I32Mul
    | I32DivS
    |I32DivU
    | I32RemS
    | I32RemU
    | I32And
    | I32Or
    | I32Xor
    | I32Shl
    | I32ShrS
    | I32ShrU
    | I32Rotl
    | I32Rotr
    | I64Clz
    | I64Ctz
    | I64Popcnt
    | I64Add
    | I64Sub
    | I64Mul
    | I64DivS
    | I64DivU
    | I64RemS
    | I64RemU
    | I64And
    | I64Or
    | I64Xor
    | I64Shl
    | I64ShrS
    | I64ShrU
    | I64Rotl
    | I64Rotr
    | F32Abs
    | F32Neg
    | F32Ceil
    | F32Floor
    | F32Trunc
    | F32Nearest
    | F32Sqrt
    | F32Add
    | F32Sub
    | F32Mul
    | F32Div
    | F32Min
    | F32Max
    | F32Copysign
    | F64Abs
    | F64Neg
    | F64Ceil
    | F64Floor
    | F64Trunc
    | F64Nearest
    | F64Sqrt
    | F64Add
    | F64Sub
    | F64Mul
    | F64Div
    | F64Min
    | F64Max
    | F64Copysign

type WasmModule = Instruction list
