module WGF.WatGen

open WGF.Types
let indent = 6

let commentS (b: string) =
    if b.Length > 0 then $" ;; %s{b}" else ""

let resultPrint (x) =
    // print all value types as wasm result
    List.fold (fun acc x -> acc + $" (result %s{x.ToString()})") "" x

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
        String.concat " " (List.map (fun x -> $"(result %s{x.ToString()})") returnValues)

    $"%s{parametersString} %s{returnValuesString}%s{commentS comment}"

let generate_wat_code instrs =

    let rec generate_wat_code_aux instrs watCode =
        match instrs with
        | [] -> watCode
        | instr :: tailInstrs -> generate_wat_code_aux tailInstrs (watCode + (instr.ToString()) + "\n")

    generate_wat_code_aux instrs ""

// generate_wat_code that handle Commented Instr
let generate_wat_code_commented instrs =

    let rec generate_wat_code_aux instrs watCode =
        match instrs with
        | [] -> watCode
        | instr :: tailInstrs ->
            match instr with
            | (instr, comment) ->
                generate_wat_code_aux tailInstrs (watCode + (instr.ToString()) + " ;; " + comment + "\n")

    generate_wat_code_aux instrs ""

let generate_wat_code_ident instrs ident =

    let generate_indent i =
        List.replicate i " " |> String.concat "" in

    let rec generate_wat_code_aux instrs watCode indent =
        match instrs with
        | [] -> watCode
        | head :: tail ->
            let (instr, c: string) = head

            // based on c to generate comment
            let watCode =
                watCode
                + generate_indent indent
                + instr.ToString()
                + if (c.Length > 0) then $" ;; %s{c}\n" else "\n" in

            generate_wat_code_aux tail watCode indent

    generate_wat_code_aux instrs "" ident

// sp
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
                " "
                (List.map
                    (fun x ->

                        match x with
                        | (Some name, t) -> $"   (local $%s{name} %s{t.ToString()})\n"
                        | (None, t) -> $"    (local %s{t.ToString()})\n")
                    locals)

        $"  %s{commentS comment}\n %s{def} "
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
    // let name = sprintf "%s_type" name
    $"  (type $%s{name} %s{ic i} (func %s{parametersString} %s{returnValuesString}))\n"

/// format global as a string
let printGlobal (i: int, g) =
    let name, (valueType, mutability), instr = g
    let valueType = valueType.ToString()

    let gType =
        match mutability with
        | Mutable -> $"(mut %s{valueType})"
        | Immutable -> $"%s{valueType}"

    //let instrs = instrs |> List.map (fun x -> Commented(x, ""))
    //let instrs = generate_wat_code_ident instrs 0
    sprintf "  (global $%s %s %s%s %s)\n" name (ic i) gType (commentS "") (instr.ToString())

let commentString (a) (b: string) = $"%s{a} ;; %s{b}"