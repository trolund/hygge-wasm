module WGF.Types

type WritingStyle =
    | Linar
    | Folded

    override this.ToString() =
        match this with
        | Linar -> "linar"
        | Folded -> "folded"

type Commented<'a> = 'a * string

type Label = string

type Identifier =
    | Named of Label
    | Index of int
    // | Address of int

    override this.ToString() =
        match this with
        | Named s -> $"${s}"
        | Index i -> $"{i}"
        //| Address i -> $"{i}"



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
        | Ref of Identifier
        | Nullref
        | Null
        | NullableRef of Identifier
        | EqRef // https://webassembly.github.io/gc/core/syntax/types.html#id2
        | Eq

        override this.ToString() =
            match this with
            | I32 -> "i32"
            | I64 -> "i64"
            | F32 -> "f32"
            | F64 -> "f64"
            | Externref -> "externref"
            | Funcref -> "funcref"
            | NullableRef l -> $"(ref null {l})"
            | Ref l -> 
                match l with
                | Named s -> $"{s}"
                | Index i -> $"%d{i}"
                // | Address i -> $"%d{i}"                        
            | Nullref -> "ref.null"
            | Null -> "null"
            | EqRef -> "eqref" 
            | Eq -> $"eq"

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

type Local = Label option * ValueType

/// function parameters and return values.
/// The signature declares what the function takes (parameters) and returns (return values)
type FunctionSignature = Local list * ValueType list           
        

type Table = Label * ValueType * Limits

    // (memory (export $name) limits)
type Memory = string * Limits
            
type ExternalType =
        /// type name and function signature
        | FunctionType of string * FunctionSignature option
        | TableType of Table
        | MemoryType of Memory
        | GlobalType of Label
        | ElementType of ValueType // todo element type and not value type
        | EmptyType

// module, name, type      
type Import = string * string * ExternalType

type Export = string * ExternalType

// offset and type identifier
type Element = int * Label

type Start = int option

type Variable = ValueType * Mutability

type Param = Label option * Variable

type TableSegment = int * int list

type MemorySegment = int * string

type TypeDef = 
        | FuncType of Label * FunctionSignature
        // (type $buf (struct (field $pos (mut i64)) (field $chars (ref $char-array))))
        | StructType of Label * Param list
        | ArrayType of Label * ValueType