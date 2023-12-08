module WGF.Utils

open WGF.Types
open System.Text

/// generate function type string
let GenFuncTypeID (t) =
    // generate function type name
    let locals: Local list = fst t
    let ret: ValueType list = snd t

    let unit = "_unit"

    let folder = 
        fun str (i, x) ->
                            let (n: Identifier option, t: ValueType) = x
                            // TODO: use names of types in function type
                            match t with
                            | ValueType.Ref l -> str + (if i > 0 then "_" else "") + "eq"
                            // | ValueType.NullableRef l -> str + (if i > 0 then "_" else "") + "eq"
                            | _ -> str + (if i > 0 then "_" else "") + t.ToString()
                            
    let l =
        if List.isEmpty locals then
            unit
        else
            List.fold
                folder
                ""
                (List.indexed locals)

    let r =
        if List.isEmpty ret then
            unit
        else
            List.fold (fun str x -> str + "_" + x.ToString()) "" ret

    $"{l}_=>{r}"

let C instrs =
    instrs |> List.map (fun x -> Commented(x, ""))

let I instrs : Commented<'a> list = instrs |> List.map (fun x -> fst x)


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
            | ArrayType(name, _) -> name)
        (types)


let formatStructString (tl:ValueType list): string = 

    let l =
        List.fold
            (fun str (i, x: ValueType) ->
                str + (if i > 0 then "-" else "") + $"{x.ToString()}")
            ""
            (List.indexed tl)

    $"s_{l}"

/// generate struct type string
/// <summary>Generate struct type name</summary>
/// <param name="t">Struct type</param>
/// <returns>Struct type name</returns>
/// <example>
let GenStructTypeID (t: list<string * ValueType>) : string =
    let fieldTypes = List.map (fun (_, t) -> t) t
    formatStructString fieldTypes

let GenStructTypeIDType (t: list<string * ValueType>) : string =
    // let fieldNames = List.map (fun (n, _) -> n) t
    let fieldTypes = List.map (fun (_, t) -> t) t
    formatStructString fieldTypes

let GenArrayTypeIDType (vt: ValueType) = $"arr_{vt}"

let createStructTypeNode (fields: list<string * ValueType>) =
    let typeParams: Param list =
        List.map (fun (name, t: ValueType) -> 

                match name with
                | "cenv" -> (Some(name), ((EqRef), Mutable))
                | _ -> (Some(name), ((t), Mutable))
                
        ) fields

    let typeId = GenStructTypeID fields

    StructType(typeId, typeParams)

let createStructType (fields: list<string * ValueType>) =
    let typeParams: Param list =
        List.map (fun (name, t: ValueType) -> (Some(name), ((t), Mutable))) fields

    let typeId = GenStructTypeIDType fields

    StructType(typeId, typeParams)
