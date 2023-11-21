module WGF.Instr

open WGF.Types

/// Instructions are syntactically distinguished into plain (Instr) and structured instructions (BlockInstr).
/// <summary>All Wasm instructions used</summary>
type Wasm =
    // Control Instrs
    | Unreachable
    | Nop
    | Else of ValueType list * ValueType list * Wasm list * Wasm list
    | Br of Identifier
    | BrIf of Identifier
    | BrTable of int list * int
    | Return
    // Memory Instrs
    | I32Load_ of int option * int option
    | I32Load
    | I64Load of int * int
    /// load align and offset
    | F32Load_ of int option * int option
    | F32Load
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
    /// align and offset
    | I32Store_ of int option * int option
    | I32Store
    | I64Store of int * int
    | F32Store_ of int option * int option
    | F32Store
    | F64Store of int * int
    | I32Store8 of int * int
    | I32Store16 of int * int
    | I64Store8 of int * int
    | I64Store16 of int * int
    | I64Store32 of int * int
    | MemorySize
    | MemoryGrow
    // Numeric Instrs
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
    | I32DivU
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
    // Parametric Instr
    | Drop
    | Select
    // Variable Instr
    | Local of Label * ValueType // https://developer.mozilla.org/en-US/docs/WebAssembly/Reference/Variables/Local
    | LocalGet of Label
    | LocalSet of Label
    | LocalTee of Label
    | GlobalGet of Label
    | GlobalSet of Label
    // Table Instr
    | TableGet of int
    | TableSet of int
    | TableInit of int * int * int
    | ElemDrop of int
    | TableCopy of int * int
    | TableGrow of int
    | TableSize of int
    // Call Instr
    | Call of string
    | CallIndirect_ of int * int
    /// type label
    | CallIndirect of Label
    | CallIndirect__ of FunctionSignature
    // ref
    | RefFunc of Label
    // Conversion Instr
    | I32WrapI64
    | I32TruncF32S
    | I32TruncF32U
    | I32TruncF64S
    | I32TruncF64U
    | I64ExtendI32S
    | I64ExtendI32U
    | I64TruncF32S
    | I64TruncF32U
    | I64TruncF64S
    | I64TruncF64U
    | F32ConvertI32S
    | F32ConvertI32U
    | F32ConvertI64S
    | F32ConvertI64U
    | F32DemoteF64
    | F64ConvertI32S
    | F64ConvertI32U
    | F64ConvertI64S
    | F64ConvertI64U
    | F64PromoteF32
    | I32ReinterpretF32
    | I64ReinterpretF64
    | F32ReinterpretI32
    | F64ReinterpretI64
    // memory instr
    | MemoryInit of int * int * int
    | DataDrop of int
    | MemoryCopy of int * int
    | MemoryFill_ of int * int * int
    | MemoryFill
    /// Block Instruction
    /// label * result type * instrs
    | Block of Identifier * ValueType list * list<Commented<Wasm>>
    /// Loop Instruction
    /// label * result type * instrs
    | Loop of Identifier * ValueType list * list<Commented<Wasm>>
    /// If Instruction
    /// reuslt type of if, then block, else block
    /// if (result type) then (instrs) else (instrs)
    | If of ValueType list * list<Commented<Wasm>> * list<Commented<Wasm>> option
    // comment
    | Comment of string

and Instrs = Wasm list

/// Global variables are like module-level variables in JavaScript.
/// They are declared with a type and an initial value.
/// The type can be either mutable or immutable.
/// The initial value is a constant expression.
/// The value can be either a constant or an import.
/// It can have a name, which is used to export the global variable.
/// The name is optional, and can be used to import the global variable.
and Global = Identifier * (ValueType * Mutability) * Wasm

and Data = Wasm * string

// ( func name <signature> <locals> <body> )
// The signature declares what the function takes (parameters) and returns (return values).
// The locals are like vars in JavaScript, but with explicit types declared.
// The body is just a linear list of low-level Instrs.
and Function = string option * FunctionSignature * Variable list * Commented<Wasm> list

and GlobalSegment = int * Wasm list

and FunctionInstance =
    { name: Identifier option
      signature: FunctionSignature
      locals: Local list
      body: Commented<Wasm> list }
