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
    /// load align and offset
    | F32Load_ of int option * int option
    | F32Load
    | I32Load8S of int * int
    | I32Load8U of int * int
    | I32Load16S of int * int
    | I32Load16U of int * int
    /// align and offset
    | I32Store_ of int option * int option
    | I32Store
    | F32Store_ of int option * int option
    | F32Store
    | I32Store8 of int * int
    | I32Store16 of int * int
    | MemorySize
    | MemoryGrow
    // Numeric Instrs
    | I32Const of int32
    | F32Const of float32
    | I32Eqz
    | I32Eq
    | I32Ne
    | I32LtS
    | I32LtU
    | I32GtS
    | I32GtU
    | I32LeS of Wasm Commented list
    | I32LeU
    | I32GeS
    | I32GeU
    | F32Eq
    | F32Ne
    | F32Lt
    | F32Gt
    | F32Le of Wasm Commented list
    | F32Ge
    | I32Clz
    | I32Ctz
    | I32Popcnt
    | I32Add of Wasm Commented list
    | I32Sub of Wasm Commented list
    | I32Mul of Wasm Commented list
    | I32DivS of Wasm Commented list
    | I32DivU of Wasm Commented list
    | I32RemS of Wasm Commented list 
    | I32RemU of Wasm Commented list
    | I32And of Wasm Commented list
    | I32Or of Wasm Commented list
    | I32Xor of Wasm Commented list
    | I32Shl
    | I32ShrS
    | I32ShrU
    | I32Rotl
    | I32Rotr
    | F32Abs
    | F32Neg
    | F32Ceil
    | F32Floor
    | F32Trunc
    | F32Nearest
    | F32Sqrt
    | F32Add of Wasm Commented list
    | F32Sub of Wasm Commented list
    | F32Mul of Wasm Commented list
    | F32Div of Wasm Commented list
    | F32Min
    | F32Max
    | F32Copysign
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
    // | I32WrapI64
    | I32TruncF32S
    | I32TruncF32U
    // | I32TruncF64S
    // | I32TruncF64U
    | F32ConvertI32S
    | F32ConvertI32U
    // | F32ConvertI64S
    // | F32ConvertI64U
    | I32ReinterpretF32
    | F32ReinterpretI32
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

and Global = Identifier * (ValueType * Mutability) * Commented<Wasm>

and Data = Commented<Wasm> * string

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
