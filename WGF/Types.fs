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
