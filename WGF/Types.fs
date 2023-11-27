module WGF.Types

type WritingStyle =
    | Linar
    | Folded

    override this.ToString() =
        match this with
        | Linar -> "linar"
        | Folded -> "folded"

type Commented<'a> = 'a * string

type Label =
    | Named of string
    | Index of int
    | Address of int

    override this.ToString() =
        match this with
        | Named s -> $"$%s{s}"
        | Index i -> i.ToString()
        | Address i -> $"%d{i}"

type Identifier = string

type VarType =
        | Local
        | Global

type ValueType =
        // basic numeric types
        | I32
        | I64
        | F32
        | F64
        // reference types
        | Externref
        | Funcref

        override this.ToString() =
            match this with
            | I32 -> "i32"
            | I64 -> "i64"
            | F32 -> "f32"
            | F64 -> "f64"
            | Externref -> "externref"
            | Funcref -> "funcref"

type BlockType =
        | Type of ValueType
        | TypeIndex of int
        | Empty

        override this.ToString() =
            match this with
            | Type t -> t.ToString()
            | TypeIndex i -> $"type %d{i}"
            | Empty -> "empty"
            
type Mutability =
        | Mutable
        | Immutable

type Limits =
        | Unbounded of int
        | Bounded of int * int

        // to string
        override this.ToString() =
            match this with
            | Unbounded min -> $"%d{min}"
            | Bounded(min, max) -> $"%d{min} %d{max}"

type Local = Identifier option * ValueType

/// function parameters and return values.
/// The signature declares what the function takes (parameters) and returns (return values)
type FunctionSignature = Local list * ValueType list           
            
type TypeDef = 
        | FuncType of Identifier * FunctionSignature
        | StructType of Identifier * ValueType list
        | ArrayType of Identifier * ValueType * int

type Table = Identifier * ValueType * Limits

    // (memory (export $name) limits)
type Memory = string * Limits
            
type ExternalType =
        /// type name and function signature
        | FunctionType of string * FunctionSignature option
        | TableType of Table
        | MemoryType of Memory
        | GlobalType of Identifier
        | ElementType of ValueType // todo element type and not value type
        | EmptyType

// module, name, type      
type Import = string * string * ExternalType

type Export = string * ExternalType

// offset and type identifier
type Element = int * Identifier

type Start = int option

type Variable = ValueType * Mutability

type TableSegment = int * int list

type MemorySegment = int * string

