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
    | BrIf of Identifier * Wasm Commented list
    | BrTable of int list * int
    | Return
    // Memory Instrs
    | I32Load_ of int option * int option * Wasm Commented list
    | I32Load of Wasm Commented list
    /// load align and offset
    | F32Load_ of int option * int option * Wasm Commented list
    | F32Load of Wasm Commented list
    /// align and offset
    | I32Store_ of int option * int option * Wasm Commented list
    | I32Store of Wasm Commented list
    | F32Store_ of int option * int option * Wasm Commented list
    | F32Store of Wasm Commented list
    // Numeric Instrs
    | I32Const of int32
    | F32Const of float32
    | I32Eqz of Wasm Commented list
    | I32Eq of Wasm Commented list
    | I32Ne
    | I32LtS of Wasm Commented list
    | I32LtU
    | I32GtS of Wasm Commented list
    | I32GtU
    | I32LeS of Wasm Commented list
    | I32LeU
    | I32GeS of Wasm Commented list
    | I32GeU
    | F32Eq of Wasm Commented list
    | F32Ne
    | F32Lt of Wasm Commented list
    | F32Gt of Wasm Commented list
    | F32Le of Wasm Commented list
    | F32Ge of Wasm Commented list
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
    | MemorySize
    | MemoryGrow of Wasm Commented list
    // Parametric Instr
    | Drop
    | Select
    // Variable Instr
    | Local of Label * ValueType // https://developer.mozilla.org/en-US/docs/WebAssembly/Reference/Variables/Local
    | LocalGet of Label
    | LocalSet of Label * Wasm Commented list
    | LocalTee of Label * Wasm Commented list
    | GlobalGet of Label 
    | GlobalSet of Label * Wasm Commented list
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
    /// type label
    | CallIndirect of Label * Wasm Commented list
    // ref
    | RefFunc of Label
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
    /// if (result type), condision, then (instrs) else (instrs)
    | If of ValueType list * list<Commented<Wasm>> * list<Commented<Wasm>> * list<Commented<Wasm>> option
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
