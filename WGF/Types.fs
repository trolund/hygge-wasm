module WGF.Types

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