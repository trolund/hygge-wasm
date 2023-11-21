module WGF.WatGen

open WGF.Types
open WGF.Instr

/// generate the right indentation
/// create a number of tabs equal to the ident
let gIndent i =
    List.replicate i "  " |> String.concat ""

let commentS (b: string) =
    if b.Length > 0 then $";; %s{b}" else ""

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




 /// generate the wat instruction for a list of instructions
/// indent is the number of tabs to add before each instruction
let rec genWat instrs ident =

        let rec aux (instrs: Commented<Instr.Wasm> list) (watCode: string) (indent: int) =
            match instrs with
            | [] -> watCode
            | head :: tail ->
                // deconstruct instr and comment
                let (instr, c: string) = head

                // compute indent
                let is = gIndent indent

                match instr with
                // block instructions
                | Block(label, valueTypes, instrs: Commented<Instr.Wasm> list) ->
                    let innerWat = aux instrs "" (indent + 1)

                    let s =
                        watCode
                        + is
                        + $"(block ${label} {resultPrint valueTypes}\n{innerWat}{gIndent (indent)})\n"

                    aux tail s indent
                | Loop(label, valueTypes, instrs: Commented<Instr.Wasm> list) ->
                    let innerWat = aux instrs "" (indent + 1)

                    let s =
                        watCode
                        + is
                        + $"(loop ${label} {resultPrint valueTypes}\n{innerWat}{gIndent (indent)})\n"

                    aux tail s indent
                | If(types, ifInstrs, elseInstrs) ->
                    match elseInstrs with
                    | Some elseInstrs' ->
                        let innerWatTrue = aux ifInstrs "" (indent + 2) // indent + 2 because of (then\n)
                        let innerWatFalse = aux elseInstrs' "" (indent + 2)

                        let s =
                            watCode
                            + is
                            + $"(if {resultPrint types}\n{gIndent (indent + 1)}(then\n{innerWatTrue}{gIndent (indent + 1)})\n{gIndent (indent + 1)}(else\n{innerWatFalse}{gIndent (indent + 1)})\n{gIndent (indent)})\n"

                        aux tail s indent
                    | None ->
                        let innerWatTrue = aux ifInstrs "" (indent + 2) // indent + 2 because of (then\n)

                        let s =
                            watCode
                            + is
                            + $"(if {resultPrint types}\n{gIndent (indent + 1)}(then\n{innerWatTrue}{gIndent (indent + 1)})\n{gIndent (indent)})\n"

                        aux tail s indent
                | _ ->
                    // generate wat code for plain instr
                    let instrAsString =
                        (printInstr instr) + if (c.Length > 0) then $" ;; %s{c}\n" else "\n" in

                    let watCode = watCode + is + instrAsString

                    aux tail watCode indent

        aux instrs "" ident
    
    and printInstr i =
            match i with
            | I32Const value -> $"i32.const %i{value}"
            | I64Const value -> $"i64.const %i{value}"
            | F32Const value -> $"f32.const %f{value}"
            | F64Const value -> $"f64.const %f{value}"
            | I32Eqz -> "i32.eqz"
            | I32Eq -> "i32.eq"
            | I32Ne -> "i32.ne"
            | I32LtS -> "i32.lt_s"
            | I32LtU -> "i32.lt_u"
            | I32GtS -> "i32.gt_s"
            | I32GtU -> "i32.gt_u"
            | I32LeS -> "i32.le_s"
            | I32LeU -> "i32.le_u"
            | I32GeS -> "i32.ge_s"
            | I32GeU -> "i32.ge_u"
            | I32Add -> "i32.add"
            | I32And -> "i32.and"
            | I32Clz -> "i32.clz"
            | I32Ctz -> "i32.ctz"
            | I32DivS -> "i32.div_s"
            | I32DivU -> "i32.div_u"
            | I32Mul -> "i32.mul"
            | I32Or -> "i32.or"
            | I32Popcnt -> "i32.popcnt"
            | I32RemS -> "i32.rem_s"
            | I32RemU -> "i32.rem_u"
            | I32Rotl -> "i32.rotl"
            | I32Rotr -> "i32.rotr"
            | I32Shl -> "i32.shl"
            | I32ShrS -> "i32.shr_s"
            | I32ShrU -> "i32.shr_u"
            | I32Sub -> "i32.sub"
            | I32Xor -> "i32.xor"
            | I64Add -> "i64.add"
            | I64And -> "i64.and"
            | I64Clz -> "i64.clz"
            | I64Ctz -> "i64.ctz"
            | I64DivS -> "i64.div_s"
            | I64DivU -> "i64.div_u"
            | I64Mul -> "i64.mul"
            | I64Or -> "i64.or"
            | I64Popcnt -> "i64.popcnt"
            | I64RemS -> "i64.rem_s"
            | I64RemU -> "i64.rem_u"
            | I64Rotl -> "i64.rotl"
            | I64Rotr -> "i64.rotr"
            | I64Shl -> "i64.shl"
            | I64ShrS -> "i64.shr_s"
            | I64ShrU -> "i64.shr_u"
            | I64Sub -> "i64.sub"
            | I64Xor -> "i64.xor"
            | I64Eqz -> "i64.eqz"
            | I64Eq -> "i64.eq"
            | I64Ne -> "i64.ne"
            | I64LtS -> "i64.lt_s"
            | I64LtU -> "i64.lt_u"
            | I64GtS -> "i64.gt_s"
            | I64GtU -> "i64.gt_u"
            | I64LeS -> "i64.le_s"
            | I64LeU -> "i64.le_u"
            | I64GeS -> "i64.ge_s"
            | I64GeU -> "i64.ge_u"
            | F32Eq -> "f32.eq"
            | F32Ne -> "f32.ne"
            | F32Lt -> "f32.lt"
            | F32Gt -> "f32.gt"
            | F32Le -> "f32.le"
            | F32Ge -> "f32.ge"
            | F32Abs -> "f32.abs"
            | F32Neg -> "f32.neg"
            | F32Ceil -> "f32.ceil"
            | F32Floor -> "f32.floor"
            | F32Trunc -> "f32.trunc"
            | F32Nearest -> "f32.nearest"
            | F32Sqrt -> "f32.sqrt"
            | F32Add -> "f32.add"
            | F32Sub -> "f32.sub"
            | F32Mul -> "f32.mul"
            | F32Div -> "f32.div"
            | F32Min -> "f32.min"
            | F32Max -> "f32.max"
            | F32Copysign -> "f32.copysign"
            | F64Eq -> "f64.eq"
            | F64Ne -> "f64.ne"
            | F64Lt -> "f64.lt"
            | F64Gt -> "f64.gt"
            | F64Le -> "f64.le"
            | F64Ge -> "f64.ge"
            | F64Abs -> "f64.abs"
            | F64Neg -> "f64.neg"
            | F64Ceil -> "f64.ceil"
            | F64Floor -> "f64.floor"
            | F64Trunc -> "f64.trunc"
            | F64Nearest -> "f64.nearest"
            | F64Sqrt -> "f64.sqrt"
            | F64Add -> "f64.add"
            | F64Sub -> "f64.sub"
            | F64Mul -> "f64.mul"
            | F64Div -> "f64.div"
            | F64Min -> "f64.min"
            | F64Max -> "f64.max"
            | F64Copysign -> "f64.copysign"
            | I32Load_(align, offset) ->
                match align, offset with
                | Some align, Some offset -> $"i32.load align=%d{align} offset=%d{offset}"
                | Some align, None -> $"i32.load align=%d{align}"
                | None, Some offset -> $"i32.load offset=%d{offset}"
                | None, None -> "i32.load"
            | I32Load -> "i32.load"
            | I64Load(align, offset) -> $"i64.load align=%d{align} offset=%d{offset}"
            | F32Load_(align, offset) ->
                match align, offset with
                | Some align, Some offset -> $"f32.load align=%d{align} offset=%d{offset}"
                | Some align, None -> $"f32.load align=%d{align}"
                | None, Some offset -> $"f32.load offset=%d{offset}"
                | None, None -> "f32.load"
            | F32Load -> "f32.load"
            | F64Load(align, offset) -> $"f64.load align=%d{align} offset=%d{offset}"
            | I32Load8S(align, offset) -> $"i32.load8_s align=%d{align} offset=%d{offset}"
            | I32Load8U(align, offset) -> $"i32.load8_u align=%d{align} offset=%d{offset}"
            | I32Load16S(align, offset) -> $"i32.load16_s align=%d{align} offset=%d{offset}"
            | I32Load16U(align, offset) -> $"i32.load16_u align=%d{align} offset=%d{offset}"
            | I64Load8S(align, offset) -> $"i64.load8_s align=%d{align} offset=%d{offset}"
            | I64Load8U(align, offset) -> $"i64.load8_u align=%d{align} offset=%d{offset}"
            | I64Load16S(align, offset) -> $"i64.load16_s align=%d{align} offset=%d{offset}"
            | I64Load16U(align, offset) -> $"i64.load16_u align=%d{align} offset=%d{offset}"
            | I64Load32S(align, offset) -> $"i64.load32_s align=%d{align} offset=%d{offset}"
            | I64Load32U(align, offset) -> $"i64.load32_u align=%d{align} offset=%d{offset}"
            | I32Store_(align, offset) ->
                match align, offset with
                | Some align, Some offset -> $"i32.store align=%d{align} offset=%d{offset}"
                | Some align, None -> $"i32.store align=%d{align}"
                | None, Some offset -> $"i32.store offset=%d{offset}"
                | None, None -> "i32.store"
            | I32Store -> "i32.store"
            | I64Store(align, offset) -> $"i64.store align=%d{align} offset=%d{offset}"
            | F32Store_(align, offset) ->
                match align, offset with
                | Some align, Some offset -> $"f32.store align=%d{align} offset=%d{offset}"
                | Some align, None -> $"f32.store align=%d{align}"
                | None, Some offset -> $"f32.store offset=%d{offset}"
                | None, None -> "f32.store"
            | F32Store -> "f32.store"
            | F64Store(align, offset) -> $"f64.store align=%d{align} offset=%d{offset}"
            | I32Store8(align, offset) -> $"i32.store8 align=%d{align} offset=%d{offset}"
            | I32Store16(align, offset) -> $"i32.store16 align=%d{align} offset=%d{offset}"
            | I64Store8(align, offset) -> $"i64.store8 align=%d{align} offset=%d{offset}"
            | I64Store16(align, offset) -> $"i64.store16 align=%d{align} offset=%d{offset}"
            | I64Store32(align, offset) -> $"i64.store32 align=%d{align} offset=%d{offset}"
            | MemorySize -> "memory.size"
            | MemoryGrow -> "memory.grow"
            // declare variable
            | LocalGet l -> $"local.get %s{l.ToString()}"
            | LocalSet l -> $"local.set %s{l.ToString()}"
            | LocalTee l -> $"local.tee %s{l.ToString()}"
            | GlobalGet index -> $"global.get %s{index.ToString()}"
            | GlobalSet index -> $"global.set %s{index.ToString()}"
            | Unreachable -> "unreachable"
            | Nop -> "nop"
            | Br id -> $"br $%s{id}"
            | BrIf id -> $"br_if $%s{id}"
            // TODO: br_table
            // | BrTable (indexes, index) -> sprintf "br_table %s %d" (generate_wat_code indexes) index
            | Return -> "return"
            | Call name -> $"call $%s{name}"
            | CallIndirect_(index, x) -> $"call_indirect %d{index}" // TODO: add x??
            | CallIndirect label -> $"call_indirect (type %s{label.ToString()})"
            | CallIndirect__(signature) -> sprintf "call_indirect %s" (generate_signature signature "")
            | Drop -> "drop"
            | Select -> "select"
            // block instructions
            // | Block(label, valueTypes, instrs) ->
            //     $"(block $%s{label} %s{resultPrint valueTypes}\n%s{generate_wat_code_ident instrs indent}\n    )"
            // | Loop(label, valueTypes, instrs: Commented<Instr> list) ->
            //     $"(loop $%s{label} %s{resultPrint valueTypes}\n%s{generate_wat_code_ident instrs indent}\n)"
            // | If(types, ifInstrs, elseInstrs) ->
            //     match elseInstrs with
            //     | Some elseInstrs' ->
            //         $"(if %s{resultPrint types}\n     (then\n%s{generate_wat_code_ident ifInstrs indent}\n     )\n     (else\n%s{generate_wat_code_ident elseInstrs' indent}\n     )\n    )"
            //     | None ->
            //         $"(if%s{resultPrint types} (then\n%s{generate_wat_code_ident ifInstrs indent}       )\n      )"
            // comments
            | RefFunc label -> $"ref.func %s{label.ToString()}"
            | MemoryFill -> "memory.fill"
            | MemoryFill_(offset, value, size) -> $"memory.fill offset=%d{offset} value=%d{value} size=%d{size}"
            | Comment comment -> $";; %s{comment}"

            | x -> $"not implemented: %s{x.ToString()}" 

/// format global as a string
let printGlobal (i: int, g) =
    let name, (valueType, mutability), instr = g
    let valueType = valueType.ToString()

    let gType =
        match mutability with
        | Mutable -> $"(mut %s{valueType})"
        | Immutable -> $"%s{valueType}"

    sprintf "%s(global $%s %s %s%s %s)\n" (gIndent 1) name (ic i) gType (commentS "") (printInstr instr)