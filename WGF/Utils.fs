module WGF.Utils

open WGF.Types

/// generate function type string
let GenFuncTypeName (t) =
    // generate function type name
    let locals = fst t
    let ret = snd t

    let l =
        List.fold
            (fun str (i, x) ->
                let (_, t) = x
                str + (if i > 0 then "_" else "") + t.ToString())
            ""
            (List.indexed locals)

    let r = List.fold (fun str x -> str + "_" + x.ToString()) "" ret

    $"{l}_=>{r}"

let C instrs =
    instrs |> List.map (fun x -> Commented(x, ""))

let I instrs : Commented<'a> list = instrs |> List.map (fun x -> fst x)
