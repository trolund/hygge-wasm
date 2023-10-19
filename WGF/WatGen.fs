module WGF.WatGen

open WGF.Types

/// generate the right indentation
/// create a number of tabs equal to the ident
let gIndent i =
    List.replicate i "  " |> String.concat ""

let commentS (b: string) =
    if b.Length > 0 then $";; %s{b}" else ""

let resultPrint (x) =
    // print all value types as wasm result
    List.fold (fun acc x -> acc + $"(result %s{x.ToString()})") "" x

// create functions
let generate_signature (signature) (comment: string) =
    let parameters, returnValues = signature

    let parametersString =
        String.concat
            " "
            (List.map
                (fun (n, t) ->
                    match n with
                    | Some name -> $"(param $%s{name} %s{t.ToString()})"
                    | None -> $"(param %s{t.ToString()})")
                parameters)

    let returnValuesString =
        String.concat "" (List.map (fun x -> $"(result {x.ToString()})") returnValues)

    $"{parametersString} {returnValuesString}"

let ic (i: int) = $"(;{i};)"

let genrate_name (name: string option) =
    match name with
    | Some name -> $"$%s{name}"
    | _ -> ""

let generate_local (locals: (string option * 'a) list) =
    if locals.Length > 0 then
        let comment = "local variables declarations:"

        let def =
            String.concat
                ""
                (List.map
                    (fun x ->
                        match x with
                        | (Some name, t) -> $"{gIndent 2}(local $%s{name} %s{t.ToString()})\n"
                        | (None, t) -> $"{gIndent 2}(local %s{t.ToString()})\n")
                    locals)

        $"{gIndent 2}{commentS comment}\n{def}"
    else
        ""

/// format type as a string
let printType (i: int, t) (withName: bool) =
    let name, signature = t
    let parameters, returnValues = signature

    let parametersString =
        String.concat
            " "
            (List.map
                (fun (n, t) ->
                    match n with
                    | Some name ->
                        if withName then
                            $"(param $%s{name} %s{t.ToString()})"
                        else
                            $"(param %s{t.ToString()})"
                    | None -> $"(param %s{t.ToString()})")
                parameters)

    let returnValuesString =
        String.concat " " (List.map (fun x -> $"(result %s{x.ToString()})") returnValues)

    // name with suffix
    $"{gIndent 1}(type $%s{name} %s{ic i} (func %s{parametersString} %s{returnValuesString}))\n"

/// format global as a string
let printGlobal (i: int, g) =
    let name, (valueType, mutability), instr = g
    let valueType = valueType.ToString()

    let gType =
        match mutability with
        | Mutable -> $"(mut %s{valueType})"
        | Immutable -> $"%s{valueType}"

    sprintf "%s(global $%s %s %s%s %s)\n" (gIndent 1) name (ic i) gType (commentS "") (instr.ToString())
