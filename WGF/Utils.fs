module WGF.Utils

open WGF.Types
open System.Text

/// generate function type string
let GenFuncTypeID (t) =
    // generate function type name
    let locals: Local list = fst t
    let ret: ValueType list = snd t

    // replace nullable ref with normal ref
    let replaceNullableRef (l: Local list) =
        List.map
            (fun (name, t) ->
                match t with
                | NullableRef l -> (name, Ref(l)) // replace with normal ref
                | _ -> (name, t))
            l

    let locals': Local list = replaceNullableRef locals
    let ret': ValueType list = List.map
                                    (fun (t) ->
                                        match t with
                                        | NullableRef l -> Ref(l) // replace with normal ref
                                        | _ -> t)
                                    ret

    let unit = "_unit"

    let folder =
        fun str (i, x) ->
            let (n: Label option, t: ValueType) = x
            // TODO: use names of types in function type
            match t with
            | Ref l -> str + (if i > 0 then "_" else "") + "eq"
            | NullableRef l -> str + (if i > 0 then "_" else "") + "ref"
            | _ -> str + (if i > 0 then "_" else "") + t.ToString()

    let l =
        if List.isEmpty locals then
            unit
        else
            List.fold folder "" (List.indexed locals')

    let r =
        if List.isEmpty ret then
            unit
        else
            List.fold
                (fun str (t: ValueType) ->
                    let frag =
                        match t with
                        | Ref _ -> "eq"
                        | NullableRef _ -> "ref"
                        | _ -> t.ToString()

                    str + "_" + frag)
                ""
                ret'

    $"{l}_=>{r}"

let C instrs =
    instrs |> List.map (fun x -> Commented(x, ""))

// write wasm module to file
let writeWasmFile (wasm: string) (path: string) =
    let file = System.IO.File.Create(path)
    let bytes = wasm |> Encoding.UTF8.GetBytes
    file.Write(bytes, 0, bytes.Length)
    file.Close()

let distinctTypes types =
    List.distinctBy
        (fun l ->
            match l with
            | FuncType(name, _) -> name
            | StructType(name, _) -> name
            | StructSubType(_, name, _) -> name
            | ArrayType(name, _) -> name)
        (types)


/// Render a ValueType as a fragment usable inside a WAT '$'-identifier.
/// ValueType.ToString() renders ref types as e.g. "(ref null $arr_i32)",
/// which contains characters ('(', ')', ' ') that are not legal in a WAT
/// identifier - so reference types are rendered from their inner name instead.
let rec typeNameFragment (vt: ValueType) : string =
    match vt with
    | Ref(Named n) -> $"ref_{n}"
    | Ref(Index i) -> $"ref_{i}"
    | NullableRef(Named n) -> $"nref_{n}"
    | NullableRef(Index i) -> $"nref_{i}"
    | _ -> vt.ToString()

let formatStructString (tl: list<string * ValueType>) : string =

    let l =
        List.fold
            (fun str (i, (n, x: ValueType)) ->
                str + (if i > 0 then "|" else "") + $"{n.ToString()}-{typeNameFragment x}")
            ""
            (List.indexed tl)

    $"s|{l}"

/// generate struct type string
/// <summary>Generate struct type name</summary>
/// <param name="t">Struct type</param>
/// <returns>Struct type name</returns>
/// <example>
let GenStructTypeID (t: list<string * ValueType>) : string =
    // let fieldTypes = List.map (fun (n, t) -> t) t
    formatStructString t

let GenStructTypeIDType (t: list<string * ValueType>) : string =
    // let fieldNames = List.map (fun (n, _) -> n) t
    // let fieldTypes = List.map (fun (_, t) -> t) t
    formatStructString t

let GenArrayTypeIDType (vt: ValueType) = $"arr_{typeNameFragment vt}"

let createStructTypeNode (fields: list<string * ValueType>) =
    let typeParams: Param list =
        List.map
            (fun (name, t: ValueType) ->

                match name with
                | "cenv" -> (Some(name), ((EqRef), Mutable))
                | _ -> (Some(name), ((t), Mutable))

            )
            fields

    let typeId = GenStructTypeID fields

    StructType(typeId, typeParams)

/// Generate the typedef for a struct AND every one of its field-prefixes
/// (length 1, 2, ..., n), each declared as a WasmGC 'sub' of the previous,
/// shorter prefix. Hygge's struct subtyping rule is exactly "a struct is a
/// subtype of any prefix of its own fields" (see Typechecker.isSubtypeOf),
/// so this chain is always a valid - and the only needed - set of ancestors
/// for this struct type, regardless of where else it's used in the program.
let createStructTypeNodeWithPrefixes (fields: list<string * ValueType>) : TypeDef list =
    if fields.IsEmpty then
        [ StructType(GenStructTypeID fields, []) ]
    else
    [ 1 .. fields.Length ]
    |> List.map (fun n ->
        let prefix = fields[0 .. n - 1]
        let typeId = GenStructTypeID prefix

        let typeParams: Param list =
            List.map
                (fun (name, t: ValueType) ->
                    match name with
                    | "cenv" -> (Some(name), (EqRef, Mutable))
                    | _ -> (Some(name), (t, Mutable)))
                prefix

        // every link in the chain is declared 'open' (via StructSubType, even
        // the root with no supertype) since any of them may later need to
        // serve as the supertype of an even wider struct elsewhere in the
        // program - a plain, final StructType could not be extended then.
        if n = 1 then
            StructSubType(None, typeId, typeParams)
        else
            StructSubType(Some(GenStructTypeID(fields[0 .. n - 2])), typeId, typeParams))

/// sort types by function type and (struct type, array type)
/// <summary>Sort types by function type and (struct type, array type), functions is last</summary>
/// <param name="types">List of types</param>
/// <returns>Sorted list of types</returns>
/// <example>
let sortTypes (types: TypeDef list) =
    let funcTypes =
        types
        |> List.filter
            (fun t ->
                match t with
                | FuncType(_, _) -> true
                | _ -> false)

    let otherTypes =
        types
        |> List.filter
            (fun t ->
                match t with
                | StructType(_, _) -> true
                | StructSubType(_, _, _) -> true
                | ArrayType(_, _) -> true
                | _ -> false)

    otherTypes @ funcTypes