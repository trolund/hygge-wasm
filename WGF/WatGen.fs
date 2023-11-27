module WGF.WatGen

open WGF.Types
open WGF.Instr

/// generate the right indentation
/// create a number of tabs equal to the ident
let gIndent i =
    List.replicate i "  " |> String.concat ""

let commentS (b: string) =
    if b.Length > 0 then $" ;; %s{b}" else ""

let resultPrint x =
    // print all value types as wasm result
    List.fold (fun acc x -> acc + $"(result %s{x.ToString()})") "" x

// create functions
let generate_signature signature (comment: string) =
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

        $"\n{gIndent 2}{commentS comment}\n{def}"
    else
        ""

/// format type as a string
let printType (i: int, t) (withName: bool) =
    match t with
    | FuncType(name: Identifier, signature: FunctionSignature) ->

        let (parameters: Local list), (returnValues: ValueType list) = signature

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
        $"{gIndent 1}(type ${name} %s{ic i} (func {parametersString} {returnValuesString}))\n"
    | StructType(name: Identifier, types: Param list) ->
        // valid type: (type $buf (struct (field $pos (mut i32)) (field $chars (mut i32))))

        let formatVar = fun (var: Variable) ->
            match var with
            | (t, Mutable) -> $"(mut {t.ToString()})"
            | (t, Immutable) -> t.ToString()

        let printParam (n: Identifier option, var: Variable) =
            match n with
            | Some name -> $"(field ${name} {formatVar var})"
            | None -> $"(field %s{var.ToString()})"

        let paramsString =
            String.concat " " (List.map (fun (param) -> printParam param) types)

        $"{gIndent 1}(type ${name} {ic i} (struct {paramsString}))\n"
    | ArrayType(name: Identifier, t: ValueType, size: int) ->
        $"{gIndent 1}(type ${name} {ic i} (array {t.ToString()} {size}))\n"

// function that only return the label of the instruction
// I32Const should return "i32.const"
let instrLabel i =
    match i with
    | I32Const _ -> "i32.const"
    | F32Const _ -> "f32.const"
    | I32Eqz _ -> "i32.eqz"
    | I32Eq _ -> "i32.eq"
    | I32Ne -> "i32.ne"
    | I32LtS _ -> "i32.lt_s"
    | I32LtU -> "i32.lt_u"
    | I32GtS _ -> "i32.gt_s"
    | I32GtU -> "i32.gt_u"
    | I32LeS _ -> "i32.le_s"
    | I32LeU -> "i32.le_u"
    | I32GeS _ -> "i32.ge_s"
    | I32GeU -> "i32.ge_u"
    | I32Add _ -> "i32.add"
    | I32And _ -> "i32.and"
    | I32Clz -> "i32.clz"
    | I32Ctz -> "i32.ctz"
    | I32DivS _ -> "i32.div_s"
    | I32DivU _ -> "i32.div_u"
    | I32Mul _ -> "i32.mul"
    | I32Or _ -> "i32.or"
    | I32Popcnt -> "i32.popcnt"
    | I32RemS _ -> "i32.rem_s"
    | I32RemU _ -> "i32.rem_u"
    | I32Rotl -> "i32.rotl"
    | I32Rotr -> "i32.rotr"
    | I32Shl -> "i32.shl"
    | I32ShrS -> "i32.shr_s"
    | I32ShrU -> "i32.shr_u"
    | I32Sub _ -> "i32.sub"
    | I32Xor _ -> "i32.xor"
    | F32Eq _ -> "f32.eq"
    | F32Ne -> "f32.ne"
    | F32Lt _ -> "f32.lt"
    | F32Gt _ -> "f32.gt"
    | F32Le _ -> "f32.le"
    | F32Ge _ -> "f32.ge"
    | F32Abs -> "f32.abs"
    | F32Neg -> "f32.neg"
    | F32Ceil -> "f32.ceil"
    | F32Floor -> "f32.floor"
    | F32Trunc -> "f32.trunc"
    | F32Nearest -> "f32.nearest"
    | F32Sqrt -> "f32.sqrt"
    | F32Add _ -> "f32.add"
    | F32Sub _ -> "f32.sub"
    | F32Mul _ -> "f32.mul"
    | F32Div _ -> "f32.div"
    | F32Min -> "f32.min"
    | F32Max -> "f32.max"
    | F32Copysign -> "f32.copysign"
    | I32Load_ _ -> "i32.load"
    | I32Load _ -> "i32.load"
    | F32Load_ _ -> "f32.load"
    | F32Load _ -> "f32.load"

    | I32Store_ _ -> "i32.store"
    | I32Store _ -> "i32.store"

    | F32Store_ _ -> "f32.store"
    | F32Store _ -> "f32.store"
    | LocalGet _ -> "local.get"
    | LocalSet _ -> "local.set"
    | LocalTee _ -> "local.tee"
    | GlobalGet _ -> "global.get"
    | GlobalSet _ -> "global.set"
    | Unreachable -> "unreachable"
    | Nop -> "nop"
    | Br _ -> "br"
    | BrIf _ -> "br_if"
    | BrTable _ -> "br_table"
    | Return -> "return"
    | Call _ -> "call"
    | CallIndirect _ -> "call_indirect"
    | Block _ -> "block"
    | Loop _ -> "loop"
    | If _ -> "if"
    | Else(_, _, _, _) -> "else"
    | Drop _ -> "drop"
    | Select -> "select"
    | Local(_, _) -> "local"
    | TableGet(_) -> "table.get"
    | TableSet(_) -> "table.set"
    | TableInit(_, _, _) -> "table.init"
    | ElemDrop(_) -> "elem.drop"
    | TableCopy(_, _) -> "table.copy"
    | TableGrow(_) -> "table.grow"
    | TableSize(_) -> "table.size"
    | RefFunc(_) -> "ref.func"
    | MemoryInit(_, _, _) -> "memory.init"
    | DataDrop(_) -> "data.drop"
    | MemoryCopy(_, _) -> "memory.copy"
    | MemoryFill_(_, _, _) -> "memory.fill"
    | MemoryFill -> "memory.fill"
    | MemoryGrow(_) -> "memory.grow"
    | MemorySize -> "memory.size"
    | StructNew(_, _) -> "struct.new"
    | Comment(_) -> ""

/// generate the wat instruction for a list of instructions
/// indent is the number of tabs to add before each instruction
// let style = Folded

let printInstr (i: Commented<Instr.Wasm>) =
    let (instr, comment) = i

    // all non nested instructions
    match instr with
    | I32Const value -> $"i32.const %i{value}"
    | F32Const value -> $"f32.const %f{value}"
    | I32Ne -> "i32.ne"
    | I32LtS _ -> "i32.lt_s"
    | I32LtU -> "i32.lt_u"
    | I32GtS _ -> "i32.gt_s"
    | I32GtU -> "i32.gt_u"
    | I32LeU -> "i32.le_u"
    | I32GeS _ -> "i32.ge_s"
    | I32GeU -> "i32.ge_u"
    | I32Clz -> "i32.clz"
    | I32Ctz -> "i32.ctz"
    | I32Popcnt -> "i32.popcnt"
    | I32Rotl -> "i32.rotl"
    | I32Rotr -> "i32.rotr"
    | I32Shl -> "i32.shl"
    | I32ShrS -> "i32.shr_s"
    | I32ShrU -> "i32.shr_u"
    | F32Ne -> "f32.ne"
    | F32Lt _ -> "f32.lt"
    | F32Gt _ -> "f32.gt"
    | F32Ge _ -> "f32.ge"
    | F32Abs -> "f32.abs"
    | F32Neg -> "f32.neg"
    | F32Ceil -> "f32.ceil"
    | F32Floor -> "f32.floor"
    | F32Trunc -> "f32.trunc"
    | F32Nearest -> "f32.nearest"
    | F32Sqrt -> "f32.sqrt"
    | F32Min -> "f32.min"
    | F32Max -> "f32.max"
    | F32Copysign -> "f32.copysign"
    | MemoryGrow _ -> "memory.grow"
    | MemorySize -> "memory.size"
    // declare variable
    | LocalGet l -> $"local.get %s{l.ToString()}"
    | GlobalGet index -> $"global.get %s{index.ToString()}"
    | Unreachable -> "unreachable"
    | Nop -> "nop"
    | Br id -> $"br $%s{id}"
    | Return -> "return"
    | Call name -> $"call $%s{name}"
    | CallIndirect(label, instrs) -> $"call_indirect (type %s{label.ToString()})"
    | Drop _ -> "drop"
    | Drop_ -> "drop"
    | Select -> "select"
    | RefFunc label -> $"ref.func %s{label.ToString()}"
    | MemoryFill -> "memory.fill"
    | MemoryFill_(offset, value, size) -> $"memory.fill offset=%d{offset} value=%d{value} size=%d{size}"
    | Comment comment -> $";; %s{comment}"
    | StructNew(name, instrs) -> $"struct.new %s{name.ToString()}"
    | Null l -> $"ref.null {l.ToString()}"
    | _ -> failwith "not implemented"

let generateText (instrs: Wasm Commented list) (style: WritingStyle) =

    let emptyS = ""

    let rec aux (instrs: Commented<Instr.Wasm> list) (watCode: string) (indent: int) =
        match instrs with
        | [] -> watCode
        | head :: tail ->
            // deconstruct instr and comment
            let (instr, c: string) = head

            // compute indent
            let space = gIndent indent

            match instr with
            // block instructions
            | Block(label, valueTypes, instrs: Commented<Instr.Wasm> list) when style = Folded ->
                let innerWat = aux instrs "" (indent + 1)

                let s =
                    watCode
                    + space
                    + $"(block ${label} {resultPrint valueTypes}\n{innerWat}{gIndent (indent)})\n"

                aux tail s indent

            | Block(label, valueTypes, instrs: Commented<Instr.Wasm> list) when style = Linar ->
                let innerWat = aux instrs "" (indent + 1)

                let s =
                    watCode
                    + space
                    + $"block ${label} {resultPrint valueTypes}\n{innerWat}{gIndent (indent)}end\n"

                aux tail s indent
            
            | Loop(label, valueTypes, instrs: Commented<Instr.Wasm> list) when style = Folded  ->
                let innerWat = aux instrs "" (indent + 1)

                let s =
                    watCode
                    + space
                    + $"(loop ${label} {resultPrint valueTypes}\n{innerWat}{gIndent (indent)})\n"

                aux tail s indent

            | Loop(label, valueTypes, instrs: Commented<Instr.Wasm> list) when style = Linar ->
                let innerWat = aux instrs "" (indent + 1)

                let s =
                    watCode
                    + space
                    + $"loop ${label} {resultPrint valueTypes}\n{innerWat}{gIndent (indent)}end\n"

                aux tail s indent
            
            | If(types, cond, ifInstrs, elseInstrs) when style = Folded ->
                match elseInstrs with
                | Some elseInstrs' ->
                    let condWat = aux cond "" (indent + 2)
                    let innerWatTrue = aux ifInstrs "" (indent + 2) // indent + 2 because of (then\n)
                    let innerWatFalse = aux elseInstrs' "" (indent + 2)

                    let s =
                        watCode
                        + space
                        + $"(if {resultPrint types}\n{condWat}{gIndent (indent + 1)}(then\n{innerWatTrue}{gIndent (indent + 1)})\n{gIndent (indent + 1)}(else\n{innerWatFalse}{gIndent (indent + 1)})\n{gIndent (indent)})\n"

                    aux tail s indent
                | None ->
                    let condWat = aux cond "" (indent + 2)
                    let innerWatTrue = aux ifInstrs "" (indent + 2) // indent + 2 because of (then\n)

                    let s =
                        watCode
                        + space
                        + $"(if {resultPrint types}\n{condWat}{gIndent (indent + 1)}(then\n{innerWatTrue}{gIndent (indent + 1)})\n{gIndent (indent)})\n"

                    aux tail s indent
            | If(types, cond, ifInstrs, elseInstrs) when style = Linar ->
                match elseInstrs with
                | Some elseInstrs' ->
                    let condWat = aux cond "" (indent)
                    let innerWatTrue = aux ifInstrs "" (indent + 1) // indent + 2 because of (then\n)
                    let innerWatFalse = aux elseInstrs' "" (indent + 1)

                    let s =
                        watCode
                        + condWat // condition code before if
                        + space
                        + $"if {resultPrint types}\n{innerWatTrue}{gIndent (indent)}else\n{innerWatFalse}{gIndent (indent)}end\n"

                    aux tail s indent
                | None ->
                    let condWat = aux cond "" (indent)
                    let innerWatTrue = aux ifInstrs "" (indent + 1) 

                    let s =
                        watCode
                        + condWat
                        + space
                        + $"if {resultPrint types}\n{innerWatTrue}{gIndent (indent)}end\n"

                    aux tail s indent
            | StructNew(label, instrs: Commented<Wasm> list) when style = Folded ->
                let innerWat = aux instrs "" (indent + 1)

                let s =
                    watCode
                    + space
                    + $"(struct.new %s{label.ToString()}\n{innerWat}{gIndent (indent)})\n"

                aux tail s indent
            | StructNew(label, instrs: Commented<Wasm> list) when style = Linar ->
                let innerWat = aux instrs "" (indent + 1)

                let s =
                    watCode
                    + space
                    + $"struct.new %s{label.ToString()}\n{innerWat}{gIndent (indent)}end\n"

                aux tail s indent
            // foled instructions
            | I32Sub instrs
            | I32Mul instrs
            | I32DivS instrs
            | I32DivU instrs
            | I32RemS instrs
            | I32RemU instrs
            | F32Add instrs
            | F32Sub instrs
            | F32Mul instrs
            | F32Div instrs
            | I32Or instrs
            | I32And instrs
            | I32Xor instrs
            | I32LeS instrs
            | F32Le instrs
            | I32LtS instrs
            | I32Eq instrs
            | I32Eqz instrs
            | F32Eq instrs
            | I32GtS instrs
            | F32Lt instrs
            | F32Gt instrs
            | I32LtS instrs
            | I32GtS instrs
            | F32Lt instrs
            | F32Gt instrs
            | I32GeS instrs
            | F32Ge instrs
            | I32Store instrs
            | F32Store instrs
            | MemoryGrow instrs
            | Drop instrs
            | StructNew (_, instrs)
            | I32Add instrs when style = Folded ->
                let watCode =
                    watCode
                    + space
                    + $"({instrLabel instr}{commentS c}\n{aux instrs emptyS (indent + 1)}{gIndent (indent)})\n"

                aux tail watCode indent
            | StructNew (_, instrs)
            | Drop instrs
            | MemoryGrow instrs
            | I32GeS instrs
            | F32Ge instrs
            | F32Lt instrs
            | F32Gt instrs
            | I32GtS instrs
            | I32LtS instrs
            | I32LtS instrs
            | I32GtS instrs
            | F32Lt instrs
            | F32Gt instrs
            | I32Sub instrs
            | I32Mul instrs
            | I32DivS instrs
            | I32DivU instrs
            | I32RemS instrs
            | I32RemU instrs
            | F32Add instrs
            | F32Sub instrs
            | F32Mul instrs
            | F32Div instrs
            | I32Or instrs
            | I32And instrs
            | I32Xor instrs
            | I32LeS instrs
            | F32Le instrs
            | I32Eq instrs
            | I32Eqz instrs
            | F32Eq instrs
            | I32Store instrs
            | F32Store instrs
            | I32Add instrs when style = Linar ->
                aux
                    tail
                    (watCode
                     + (aux instrs emptyS indent)
                     + $"{gIndent indent}{instrLabel instr}{commentS c}\n")
                    indent

            | GlobalSet(l, instrs)
            | LocalTee(l, instrs)
            | LocalSet(l, instrs: Commented<Wasm> list) when style = Linar ->
                aux
                    tail
                    (watCode
                     + (aux instrs emptyS indent)
                     + $"{gIndent indent}{instrLabel instr} {l.ToString()}{commentS c}\n")
                    indent

            | GlobalSet(l, instrs)
            | LocalTee(l, instrs)
            | LocalSet(l, instrs) when style = Folded ->
                let watCode =
                    watCode
                    + space
                    + $"({instrLabel instr} {l.ToString()}{commentS c}\n{aux instrs emptyS (indent + 1)}{gIndent (indent)})\n"

                aux tail watCode indent

            | I32Load(instrs: Commented<Wasm> list) when style = Linar ->
                aux
                    tail
                    (watCode
                     + (aux instrs emptyS indent)
                     + $"{gIndent indent}{instrLabel instr}{commentS c}\n")
                    indent
            | I32Load(instrs: Commented<Wasm> list) when style = Folded ->
                let watCode =
                    watCode
                    + space
                    + $"({instrLabel instr}{commentS c}\n{aux instrs emptyS (indent + 1)}{gIndent (indent)})\n"

                aux tail watCode indent

            | I32Load_(align, offset, instrs) when style = Folded ->
                match align, offset with
                | Some align, Some offset ->
                    let watCode =
                        watCode
                        + space
                        + $"({instrLabel instr} align=%d{align} offset=%d{offset}\n{aux instrs emptyS (indent + 1)}{gIndent (indent)})\n"

                    aux tail watCode indent
                | Some align, None ->
                    let watCode =
                        watCode
                        + space
                        + $"({instrLabel instr} align=%d{align}\n{aux instrs emptyS (indent + 1)}{gIndent (indent)})\n"

                    aux tail watCode indent
                | None, Some offset ->
                    let watCode =
                        watCode
                        + space
                        + $"({instrLabel instr} offset=%d{offset}\n{aux instrs emptyS (indent + 1)}{gIndent (indent)})\n"

                    aux tail watCode indent
                | None, None ->
                    let watCode =
                        watCode
                        + space
                        + $"({instrLabel instr}\n{aux instrs emptyS (indent + 1)}{gIndent (indent)})\n"

                    aux tail watCode indent

            | F32Load_(align, offset, instrs) when style = Linar ->
                match align, offset with
                | Some align, Some offset ->
                    aux
                        tail
                        (watCode
                         + (aux instrs emptyS indent)
                         + space
                         + $"{instrLabel instr} align={align} offset={offset}{commentS c}\n")
                        indent
                | Some align, None ->
                    aux
                        tail
                        (watCode
                         + (aux instrs emptyS indent)
                         + space
                         + $"{instrLabel instr} align={align}{commentS c}\n")
                        indent
                | None, Some offset ->
                    aux
                        tail
                        (watCode
                         + (aux instrs emptyS indent)
                         + space
                         + $"{instrLabel instr} offset={offset}{commentS c}\n")
                        indent
                | None, None ->
                    let watCode = watCode + (aux instrs emptyS indent) + space + $"f32.load\n"
                    aux tail watCode indent
            | F32Load_(align, offset, instrs) when style = Folded ->
                match align, offset with
                | Some align, Some offset ->
                    let watCode =
                        watCode
                        + space
                        + $"({instrLabel instr} align=%d{align} offset=%d{offset}\n{aux instrs emptyS (indent + 1)}{gIndent (indent)})\n"

                    aux tail watCode indent
                | Some align, None ->
                    let watCode =
                        watCode
                        + space
                        + $"({instrLabel instr} align=%d{align}\n{aux instrs emptyS (indent + 1)}{gIndent (indent)})\n"

                    aux tail watCode indent
                | None, Some offset ->
                    let watCode =
                        watCode
                        + space
                        + $"({instrLabel instr} offset=%d{offset}\n{aux instrs emptyS (indent + 1)}{gIndent (indent)})\n"

                    aux tail watCode indent
                | None, None ->
                    let watCode =
                        watCode
                        + space
                        + $"({instrLabel instr}\n{aux instrs emptyS (indent + 1)}{gIndent (indent)})\n"

                    aux tail watCode indent
            | F32Load_(align, offset, instrs) when style = Linar ->
                aux
                    tail
                    (watCode
                     + (aux instrs emptyS indent)
                     + $"{gIndent indent}{instrLabel instr} align={align} offset={offset}{commentS c}\n")
                    indent
            | F32Load(instrs) when style = Folded ->
                let watCode =
                    watCode
                    + space
                    + $"({instrLabel instr}{commentS c}\n{aux instrs emptyS (indent + 1)}{gIndent (indent)})\n"

                aux tail watCode indent
            | F32Load(instrs) when style = Linar ->
                aux
                    tail
                    (watCode
                     + (aux instrs emptyS indent)
                     + $"{gIndent indent}{instrLabel instr}{commentS c}\n")
                    indent
            | I32Load_(align, offset, instrs: Commented<Wasm> list) when style = Linar ->
                let offset =
                    match offset with
                    | Some offset -> offset
                    | None -> 0

                let align =
                    match align with
                    | Some align -> align
                    | None -> 0

                let offsetString = if offset > 0 then $" offset={offset}" else ""
                let alignString = if align > 0 then $" align={align}" else ""

                let watCode =
                    watCode
                    + aux instrs emptyS indent
                    + space
                    + $"{instrLabel instr}{alignString}{offsetString}{commentS c}\n"

                aux tail watCode indent

            | F32Load_(align, offset, instrs: Commented<Wasm> list) when style = Linar ->
                let offset =
                    match offset with
                    | Some offset -> offset
                    | None -> 0

                let align =
                    match align with
                    | Some align -> align
                    | None -> 0

                let offsetString = if offset > 0 then $" offset={offset}" else ""
                let alignString = if align > 0 then $" align={align}" else ""

                let watCode =
                    watCode
                    + space
                    + $"({instrLabel instr}{alignString}{offsetString}{commentS c}\n{aux instrs emptyS (indent + 1)}{gIndent (indent)})\n"

                aux tail watCode indent

            | I32Store_(align, offset, instrs: Commented<Wasm> list) when style = Linar ->
                let offset =
                    match offset with
                    | Some offset -> offset
                    | None -> 0

                let align =
                    match align with
                    | Some align -> align
                    | None -> 0

                let offsetString = if offset > 0 then $" offset={offset}" else ""
                let alignString = if align > 0 then $" align={align}" else ""

                let watCode =
                    watCode
                    + aux instrs emptyS indent
                    + space
                    + $"{instrLabel instr}{alignString}{offsetString}{commentS c}\n"

                aux tail watCode indent

            | I32Store_(align, offset, instrs: Commented<Wasm> list) when style = Folded ->
                let offset =
                    match offset with
                    | Some offset -> offset
                    | None -> 0

                let align =
                    match align with
                    | Some align -> align
                    | None -> 0

                let offsetString = if offset > 0 then $" offset=%d{offset}" else ""
                let alignString = if align > 0 then $" align=%d{align}" else ""

                let watCode =
                    watCode
                    + space
                    + $"({instrLabel instr}{alignString}{offsetString}{commentS c}\n{aux instrs emptyS (indent + 1)}{gIndent (indent)})\n"

                aux tail watCode indent

            | F32Store_(align, offset, instrs: Commented<Wasm> list) when style = Linar ->
                let offset =
                    match offset with
                    | Some offset -> offset
                    | None -> 0

                let align =
                    match align with
                    | Some align -> align
                    | None -> 0

                let offsetString = if offset > 0 then $" offset={offset}" else ""
                let alignString = if align > 0 then $" align={align}" else ""

                let watCode =
                    watCode
                    + aux instrs emptyS indent
                    + space
                    + $"{instrLabel instr}{alignString}{offsetString}{commentS c}\n"

                aux tail watCode indent

            | F32Store_(align, offset, instrs: Commented<Wasm> list) when style = Folded ->
                let offset =
                    match offset with
                    | Some offset -> offset
                    | None -> 0

                let align =
                    match align with
                    | Some align -> align
                    | None -> 0

                let offsetString = if offset > 0 then $" offset=%d{offset}" else ""
                let alignString = if align > 0 then $" align=%d{align}" else ""

                let watCode =
                    watCode
                    + space
                    + $"({instrLabel instr}{alignString}{offsetString}{commentS c}\n{aux instrs emptyS (indent + 1)}{gIndent (indent)})\n"

                aux tail watCode indent


            | CallIndirect(t, instrs: Commented<Wasm> list) when style = Linar ->
                aux
                    tail
                    (watCode
                     + (aux instrs emptyS indent)
                     + $"{gIndent indent}{instrLabel instr} (type {t.ToString()}){commentS c}\n")
                    indent
            | CallIndirect(t, instrs: Commented<Wasm> list) when style = Folded ->
                let watCode =
                    watCode
                    + space
                    + $"({instrLabel instr} (type {t.ToString()}){commentS c}\n{aux instrs emptyS (indent + 1)}{gIndent (indent)})\n"

                aux tail watCode indent

            | BrIf(label, instrs: Commented<Wasm> list) when style = Linar ->
                aux
                    tail
                    (watCode
                     + (aux instrs emptyS indent)
                     + $"{gIndent indent}{instrLabel instr} $%s{label.ToString()}{commentS c}\n")
                    indent

            | BrIf(label, instrs: Commented<Wasm> list) when style = Folded ->
                let watCode =
                    watCode
                    + space
                    + $"({instrLabel instr} $%s{label.ToString()}{commentS c}\n{aux instrs emptyS (indent + 1)}{gIndent (indent)})\n"

                aux tail watCode indent


            | _ ->

                let isComment =
                    match instr with
                    | Comment _ -> true
                    | _ -> false

                let f s =
                    if style = Folded && not isComment then $"({s})" else s
                // generate wat code for plain unested instr
                let instrAsString =
                    f (printInstr head) + if (c.Length > 0) then $" ;; %s{c}\n" else "\n" in

                let watCode = watCode + space + instrAsString

                aux tail watCode indent

    aux instrs "" 2

/// format global as a string
let printGlobal (i: int, g: Global) =
    let name, (valueType, mutability), instr = g
    let valueType = valueType.ToString()

    let gType =
        match mutability with
        | Mutable -> $"(mut %s{valueType})"
        | Immutable -> $"%s{valueType}"

    sprintf "%s(global $%s %s %s%s %s)\n" (gIndent 1) name (ic i) gType (commentS "") $"({printInstr instr})"
