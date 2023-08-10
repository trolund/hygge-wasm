// hyggec - The didactic compiler for the Hygge programming language.
// Copyright (C) 2023 Technical University of Denmark
// Author: Troels Lund <s161791@dtu.dk>
// Released under the MIT license (see LICENSE.md for details)

module hyggec.Wasm

// data types for the Wasm language
type ValueType =
    | I32
    | I64
    | F32
    | F64

// All intrctions types
type Instruction =
    | Unreachable
    | Nop
    | Block of ValueType list * Instruction list
    | Loop of ValueType list * Instruction list
    | If of ValueType list * ValueType list * Instruction list * Instruction list
    | Br of int
    | BrIf of int
    | BrTable of int list * int
    | Return
    | Call of int
    | CallIndirect of int * int
    | Drop
    | Select
    | LocalGet of int
    | LocalSet of int
    | LocalTee of int
    | GlobalGet of int
    | GlobalSet of int
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
    | I32Const of int
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

    override this.ToString() =
        match this with
        // Memory Instructions
        | I32Load (align, offset) -> sprintf "i32.load align=%d offset=%d" align offset
        | I64Load (align, offset) -> sprintf "i64.load align=%d offset=%d" align offset
        | F32Load (align, offset) -> sprintf "f32.load align=%d offset=%d" align offset
        | F64Load (align, offset) -> sprintf "f64.load align=%d offset=%d" align offset
        | I32Load8S (align, offset) -> sprintf "i32.load8_s align=%d offset=%d" align offset
        | I32Load8U (align, offset) -> sprintf "i32.load8_u align=%d offset=%d" align offset
        | I32Load16S (align, offset) -> sprintf "i32.load16_s align=%d offset=%d" align offset
        | I32Load16U (align, offset) -> sprintf "i32.load16_u align=%d offset=%d" align offset
        | I64Load8S (align, offset) -> sprintf "i64.load8_s align=%d offset=%d" align offset
        | I64Load8U (align, offset) -> sprintf "i64.load8_u align=%d offset=%d" align offset
        | I64Load16S (align, offset) -> sprintf "i64.load16_s align=%d offset=%d" align offset
        | I64Load16U (align, offset) -> sprintf "i64.load16_u align=%d offset=%d" align offset
        | I64Load32S (align, offset) -> sprintf "i64.load32_s align=%d offset=%d" align offset
        | I64Load32U (align, offset) -> sprintf "i64.load32_u align=%d offset=%d" align offset
        | I32Store (align, offset) -> sprintf "i32.store align=%d offset=%d" align offset
        | I64Store (align, offset) -> sprintf "i64.store align=%d offset=%d" align offset
        | F32Store (align, offset) -> sprintf "f32.store align=%d offset=%d" align offset
        | F64Store (align, offset) -> sprintf "f64.store align=%d offset=%d" align offset
        | I32Store8 (align, offset) -> sprintf "i32.store8 align=%d offset=%d" align offset
        | I32Store16 (align, offset) -> sprintf "i32.store16 align=%d offset=%d" align offset
        | I64Store8 (align, offset) -> sprintf "i64.store8 align=%d offset=%d" align offset
        | I64Store16 (align, offset) -> sprintf "i64.store16 align=%d offset=%d" align offset
        | I64Store32 (align, offset) -> sprintf "i64.store32 align=%d offset=%d" align offset
        | MemorySize -> "memory.size"
        | MemoryGrow -> "memory.grow"
        // Variable Instructions
        | LocalGet index -> sprintf "get_local %d" index
        | LocalSet index -> sprintf "set_local %d" index
        | LocalTee index -> sprintf "tee_local %d" index
        | GlobalGet index -> sprintf "get_global %d" index
        | GlobalSet index -> sprintf "set_global %d" index
        // Call Instructions
        | Call index -> sprintf "call %d" index
        | CallIndirect (index, reserved) -> sprintf "call_indirect %d %d" index reserved
        // Parametric Instructions
        | Drop -> "drop"
        | Select -> "select"
        // Numeric Instructions
        | I32Const value -> sprintf "i32.const %i" value
        | I64Const value -> sprintf "i64.const %i" value
        | F32Const value -> sprintf "f32.const %f" value
        | F64Const value -> sprintf "f64.const %f" value
        | I32Eqz -> "i32.eqz"
        | I32Eq -> "i32.eq"
        | I32Ne -> "i32.ne"
        | I32LtS -> "i32.lt_s"
        | I32LtU -> "i32.lt_u"
        | I32GtS -> "i32.gt_s"
        | I32GtU -> "i32.gt_u"
        | I32LeS -> "i32.le_s"
        | I32LeU -> "i32.le_u"
        | I32GeS -> "i32.ge_s"
        | I32GeU -> "i32.ge_u"
        | I32Add -> "i32.add"
        | I32And -> "i32.and"
        | I32Clz -> "i32.clz"
        | I32Ctz -> "i32.ctz"
        | I32DivS -> "i32.div_s"
        | I32DivU -> "i32.div_u"
        | I32Mul -> "i32.mul"
        | I32Or -> "i32.or"
        | I32Popcnt -> "i32.popcnt"
        | I32RemS -> "i32.rem_s"
        | I32RemU -> "i32.rem_u"
        | I32Rotl -> "i32.rotl"
        | I32Rotr -> "i32.rotr"
        | I32Shl -> "i32.shl"
        | I32ShrS -> "i32.shr_s"
        | I32ShrU -> "i32.shr_u"
        | I32Sub -> "i32.sub"
        | I32Xor -> "i32.xor"
        | I64Add -> "i64.add"
        | I64And -> "i64.and"
        | I64Clz -> "i64.clz"
        | I64Ctz -> "i64.ctz"
        | I64DivS -> "i64.div_s"
        | I64DivU -> "i64.div_u"
        | I64Mul -> "i64.mul"
        | I64Or -> "i64.or"
        | I64Popcnt -> "i64.popcnt"
        | I64RemS -> "i64.rem_s"
        | I64RemU -> "i64.rem_u"
        | I64Rotl -> "i64.rotl"
        | I64Rotr -> "i64.rotr"
        | I64Shl -> "i64.shl"
        | I64ShrS -> "i64.shr_s"
        | I64ShrU -> "i64.shr_u"
        | I64Sub -> "i64.sub"
        | I64Xor -> "i64.xor"
        | I64Eqz -> "i64.eqz"
        | I64Eq -> "i64.eq"
        | I64Ne -> "i64.ne"
        | I64LtS -> "i64.lt_s"
        | I64LtU -> "i64.lt_u"
        | I64GtS -> "i64.gt_s"
        | I64GtU -> "i64.gt_u"
        | I64LeS -> "i64.le_s"
        | I64LeU -> "i64.le_u"
        | I64GeS -> "i64.ge_s"
        | I64GeU -> "i64.ge_u"
        | F32Eq -> "f32.eq"
        | F32Ne -> "f32.ne"
        | F32Lt -> "f32.lt"
        | F32Gt -> "f32.gt"
        | F32Le -> "f32.le"
        | F32Ge -> "f32.ge"
        | F32Abs -> "f32.abs"
        | F32Neg -> "f32.neg"
        | F32Ceil -> "f32.ceil"
        | F32Floor -> "f32.floor"
        | F32Trunc -> "f32.trunc"
        | F32Nearest -> "f32.nearest"
        | F32Sqrt -> "f32.sqrt"
        | F32Add -> "f32.add"
        | F32Sub -> "f32.sub"
        | F32Mul -> "f32.mul"
        | F32Div -> "f32.div"
        | F32Min -> "f32.min"
        | F32Max -> "f32.max"
        | F32Copysign -> "f32.copysign"
        | F64Eq -> "f64.eq"
        | F64Ne -> "f64.ne"
        | F64Lt -> "f64.lt"
        | F64Gt -> "f64.gt"
        | F64Le -> "f64.le"
        | F64Ge -> "f64.ge"
        | F64Abs -> "f64.abs"
        | F64Neg -> "f64.neg"
        | F64Ceil -> "f64.ceil"
        | F64Floor -> "f64.floor"
        | F64Trunc -> "f64.trunc"
        | F64Nearest -> "f64.nearest"
        | F64Sqrt -> "f64.sqrt"
        | F64Add -> "f64.add"
        | F64Sub -> "f64.sub"
        | F64Mul -> "f64.mul"
        | F64Div -> "f64.div"
        | F64Min -> "f64.min"
        | F64Max -> "f64.max"
        | F64Copysign -> "f64.copysign"

and Type = ValueType list * ValueType list

and Import = string * string * ExternalType

and ExternalType =
    | FunctionType of Type
    | TableType of Table
    | MemoryType of Memory
    | GlobalType of Global
    | None

and Table = ValueType * Limits

and Memory = Limits

and Global = ValueType * Mutability

and Mutability =
    | Mutable
    | Immutable

and Limits =
    | Unbounded of int
    | Bounded of int * int

and Export = string * ExternalType

and Element = int * Instruction list

and Data = int * string

and Function = ValueType list * ValueType list * Instruction list

and TableSegment = int * int list

and MemorySegment = int * string

and GlobalSegment = int * Instruction list

and Start = int

and ElementSegment = int * int list

and DataSegment = int * string

and Code = int * int list * Instruction list

and Module = 
    { types : Type list
      functions : Function list 
      tables : Table list
      memories : Memory list
      globals : Global list
      exports : Export list
      start : Start option
      elements : Element list
      data : Data list
      codes : Code list 
      imports : Import list
      locals : ValueType list}
    
    override this.ToString() =
        let mutable result = ""
        result <- result + "(module\n" // open module tag

        for type_ in this.types do // print all types
            result <- result + sprintf "  (type %s)\n" (type_.ToString())

        for import: Import in this.imports do // print all imports
        
            let modu, func_name, func_signature = import

            result <- result + sprintf "  (import \"%s\" \"%s\" %s)\n" modu func_name (match func_signature with
                                                                                            | FunctionType type_ -> sprintf "(func %s)" (type_.ToString())
                                                                                            | TableType table -> sprintf "(table %s)" (table.ToString())
                                                                                            | MemoryType memory -> sprintf "(memory %s)" (memory.ToString())
                                                                                            | GlobalType global_ -> sprintf "(global %s)" (global_.ToString())
                                                                                            | None -> sprintf ""
                                                                                            )
                                                                                            

        for global_ in this.globals do
            result <- result + sprintf "  (global %s)\n" (global_.ToString())

        for export in this.exports do
            result <- result + sprintf "  (export \"%s\" %s)\n" (fst export) (match snd export with
                                                                              | FunctionType type_ -> sprintf "(func %s)" (type_.ToString())
                                                                              | TableType table -> sprintf "(table %s)" (table.ToString())
                                                                              | MemoryType memory -> sprintf "(memory %s)" (memory.ToString())
                                                                              | GlobalType global_ -> sprintf "(global %s)" (global_.ToString()))
        for element in this.elements do
            result <- result + sprintf "  (elem %s)\n" (element.ToString())
        for data in this.data do
            result <- result + sprintf "  (data %s)\n" (data.ToString())
        for code in this.codes do
            result <- result + sprintf "  (func %s)\n" (code.ToString())
        for table in this.tables do
            result <- result + sprintf "  (table %s)\n" (table.ToString())
        for memory in this.memories do
            result <- result + sprintf "  (memory %s)\n" (memory.ToString())
        for function_ in this.functions do
            result <- result + sprintf "  (func %s)\n" (function_.ToString())

        // print start
        match this.start with
        | Some start -> result <- result + sprintf "  (start %d)\n" start
        | _ -> ()

        result <- result + ")" // close module tag
        result




    
