﻿namespace WGF

module Module =

    open WGF.Types
    open WGF.WatGen

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

    and BlockType =
        | Type of ValueType
        | TypeIndex of int
        | Empty

        override this.ToString() =
            match this with
            | Type t -> t.ToString()
            | TypeIndex i -> $"type %d{i}"
            | Empty -> "empty"

    /// Instructions are syntactically distinguished into plain (Instr) and structured instructions (BlockInstr).
    /// <summary>All Wasm instructions used</summary>
    type Instr =
        // Control Instrs
        | Unreachable
        | Nop
        | Else of ValueType list * ValueType list * Instr list * Instr list
        | Br of Identifier
        | BrIf of Identifier
        | BrTable of int list * int
        | Return
        // Memory Instrs
        | I32Load_ of int option * int option
        | I32Load
        | I64Load of int * int
        /// load align and offset
        | F32Load_ of int option * int option
        | F32Load
        | F64Load of int * int
        | I32Load8S of int * int
        | I32Load8U of int * int
        | I32Load16S of int * int
        | I32Load16U of int * int
        | I64Load8S of int * int
        | I64Load8U of int * int
        | I64Load16S of int * int
        | I64Load16U of int * int
        | I64Load32S of int * int
        | I64Load32U of int * int
        /// align and offset
        | I32Store_ of int option * int option
        | I32Store
        | I64Store of int * int
        | F32Store_ of int option * int option
        | F32Store
        | F64Store of int * int
        | I32Store8 of int * int
        | I32Store16 of int * int
        | I64Store8 of int * int
        | I64Store16 of int * int
        | I64Store32 of int * int
        | MemorySize
        | MemoryGrow
        // Numeric Instrs
        | I32Const of int32
        | I64Const of int64
        | F32Const of float32
        | F64Const of float
        | I32Eqz
        | I32Eq
        | I32Ne
        | I32LtS
        | I32LtU
        | I32GtS
        | I32GtU
        | I32LeS
        | I32LeU
        | I32GeS
        | I32GeU
        | I64Eqz
        | I64Eq
        | I64Ne
        | I64LtS
        | I64LtU
        | I64GtS
        | I64GtU
        | I64LeS
        | I64LeU
        | I64GeS
        | I64GeU
        | F32Eq
        | F32Ne
        | F32Lt
        | F32Gt
        | F32Le
        | F32Ge
        | F64Eq
        | F64Ne
        | F64Lt
        | F64Gt
        | F64Le
        | F64Ge
        | I32Clz
        | I32Ctz
        | I32Popcnt
        | I32Add
        | I32Sub
        | I32Mul
        | I32DivS
        | I32DivU
        | I32RemS
        | I32RemU
        | I32And
        | I32Or
        | I32Xor
        | I32Shl
        | I32ShrS
        | I32ShrU
        | I32Rotl
        | I32Rotr
        | I64Clz
        | I64Ctz
        | I64Popcnt
        | I64Add
        | I64Sub
        | I64Mul
        | I64DivS
        | I64DivU
        | I64RemS
        | I64RemU
        | I64And
        | I64Or
        | I64Xor
        | I64Shl
        | I64ShrS
        | I64ShrU
        | I64Rotl
        | I64Rotr
        | F32Abs
        | F32Neg
        | F32Ceil
        | F32Floor
        | F32Trunc
        | F32Nearest
        | F32Sqrt
        | F32Add
        | F32Sub
        | F32Mul
        | F32Div
        | F32Min
        | F32Max
        | F32Copysign
        | F64Abs
        | F64Neg
        | F64Ceil
        | F64Floor
        | F64Trunc
        | F64Nearest
        | F64Sqrt
        | F64Add
        | F64Sub
        | F64Mul
        | F64Div
        | F64Min
        | F64Max
        | F64Copysign
        // Parametric Instr
        | Drop
        | Select
        // Variable Instr
        | Local of Label * ValueType // https://developer.mozilla.org/en-US/docs/WebAssembly/Reference/Variables/Local
        | LocalGet of Label
        | LocalSet of Label
        | LocalTee of Label
        | GlobalGet of Label
        | GlobalSet of Label
        // Table Instr
        | TableGet of int
        | TableSet of int
        | TableInit of int * int * int
        | ElemDrop of int
        | TableCopy of int * int
        | TableGrow of int
        | TableSize of int
        // Call Instr
        | Call of string
        | CallIndirect_ of int * int
        /// type label
        | CallIndirect of Label
        | CallIndirect__ of FunctionSignature
        // ref
        | RefFunc of Label
        // Conversion Instr
        | I32WrapI64
        | I32TruncF32S
        | I32TruncF32U
        | I32TruncF64S
        | I32TruncF64U
        | I64ExtendI32S
        | I64ExtendI32U
        | I64TruncF32S
        | I64TruncF32U
        | I64TruncF64S
        | I64TruncF64U
        | F32ConvertI32S
        | F32ConvertI32U
        | F32ConvertI64S
        | F32ConvertI64U
        | F32DemoteF64
        | F64ConvertI32S
        | F64ConvertI32U
        | F64ConvertI64S
        | F64ConvertI64U
        | F64PromoteF32
        | I32ReinterpretF32
        | I64ReinterpretF64
        | F32ReinterpretI32
        | F64ReinterpretI64
        // memory instr
        | MemoryInit of int * int * int
        | DataDrop of int
        | MemoryCopy of int * int
        | MemoryFill_ of int * int * int
        | MemoryFill
        // Block Instr
        | Block of Identifier * ValueType list * list<Commented<Instr>>
        | Loop of Identifier * ValueType list * list<Commented<Instr>>
        /// reuslt type of if, then block, else block
        | If of ValueType list * list<Commented<Instr>> * list<Commented<Instr>> option
        // comment
        | Comment of string

        override this.ToString() =
            match this with
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
            | Block(label, valueTypes, instrs) ->
                $"(block $%s{label} %s{resultPrint valueTypes}\n%s{generate_wat_code_ident instrs indent}\n    )"
            | Loop(label, valueTypes, instrs: Commented<Instr> list) ->
                $"(loop $%s{label} %s{resultPrint valueTypes}\n%s{generate_wat_code_ident instrs indent}\n)"
            | If(types, ifInstrs, elseInstrs) ->
                match elseInstrs with
                | Some elseInstrs' ->
                    $"(if %s{resultPrint types}\n     (then\n%s{generate_wat_code_ident ifInstrs indent}\n     )\n     (else\n%s{generate_wat_code_ident elseInstrs' indent}\n     )\n    )"
                | None ->
                    $"(if%s{resultPrint types} (then\n%s{generate_wat_code_ident ifInstrs indent}       )\n      )"
            // comments
            | RefFunc label -> $"ref.func %s{label.ToString()}"
            | MemoryFill -> "memory.fill"
            | MemoryFill_(offset, value, size) -> $"memory.fill offset=%d{offset} value=%d{value} size=%d{size}"
            | Comment comment -> $";; %s{comment}"

            | x -> $"not implemented: %s{x.ToString()}"


    and Instrs = Instr list

    and Type = Identifier * FunctionSignature

    // module, name, type
    and Import = string * string * ExternalType

    and ExternalType =
        /// type name and function signature
        | FunctionType of string * FunctionSignature option
        | TableType of Table
        | MemoryType of Memory
        | GlobalType of Identifier
        | ElementType of ValueType // todo element type and not value type
        | EmptyType

    and Table = Identifier * ValueType * Limits

    // (memory (export $name) limits)
    and Memory = string * Limits

    /// Global variables are like module-level variables in JavaScript.
    /// They are declared with a type and an initial value.
    /// The type can be either mutable or immutable.
    /// The initial value is a constant expression.
    /// The value can be either a constant or an import.
    /// It can have a name, which is used to export the global variable.
    /// The name is optional, and can be used to import the global variable.
    and Global = Identifier * (ValueType * Mutability) * Instr

    and Mutability =
        | Mutable
        | Immutable

    and Limits =
        | Unbounded of int
        | Bounded of int * int

        // to string
        override this.ToString() =
            match this with
            | Unbounded min -> $"%d{min}"
            | Bounded(min, max) -> $"%d{min} %d{max}"

    and Export = string * ExternalType


    // offset and type identifier
    and Element = int * Identifier

    and Data = Instr * string

    // ( func name <signature> <locals> <body> )
    // The signature declares what the function takes (parameters) and returns (return values).
    // The locals are like vars in JavaScript, but with explicit types declared.
    // The body is just a linear list of low-level Instrs.
    and Function = string option * FunctionSignature * Variable list * Commented<Instr> list

    /// function parameters and return values.
    /// The signature declares what the function takes (parameters) and returns (return values)
    and FunctionSignature = Local list * ValueType list

    and Variable = ValueType * Mutability

    and TableSegment = int * int list

    and MemorySegment = int * string

    and GlobalSegment = int * Instr list

    and Start = int option

    and ElementSegment = int * int list

    and DataSegment = int * string

    and Code = int * int list * Instr list

    and Local = Identifier option * ValueType

    and FunctionInstance =
        {
          // moduleInstance : ModuleInstance
          typeIndex: int
          name: Identifier option
          signature: FunctionSignature
          locals: Local list
          body: Commented<Instr> list }

    and funcTable = Identifier * ValueType * Limits

    let commentString (a) (b: string) = $"%s{a} ;; %s{b}"



    [<RequireQualifiedAccess>]
    type Module
        private
        (
            types: Set<Type>,
            functions: Map<string, Commented<FunctionInstance>>,
            tables: list<Table>,
            memories: Set<Memory>,
            globals: Set<Global>,
            exports: Set<Export>,
            imports: Set<Import>,
            start: Start,
            elements: Set<Element>,
            data: Set<Data>,
            locals: Set<Local>,
            tempCode: list<Commented<Instr>>,
            funcTableSize: int,
            hostinglist
        ) =
        member private this.types: Set<Type> = types
        member private this.functions = functions
        member private this.tables = tables
        member private this.memories: Set<Memory> = memories
        member private this.globals: Set<Global> = globals
        member private this.exports: Set<Export> = exports
        member private this.imports: Set<Import> = imports
        member private this.start: Start = start
        member private this.elements: Set<Element> = elements
        member private this.data: Set<Data> = data
        // member private this.codes = Code
        member private this.locals: Set<Local> = locals

        member private this.funcTableSize: int = funcTableSize
        member private this.tempCode: list<Commented<Instr>> = tempCode

        member private this.hostinglist: string list = hostinglist

        // empty constructor
        new() =
            Module(
                Set.empty,
                Map.empty,
                [],
                Set.empty,
                Set.empty,
                Set.empty,
                Set.empty,
                None,
                Set.empty,
                Set.empty,
                Set.empty,
                [],
                0,
                []
            )

        // module constructor that take temp code
        new(tempCode: list<Commented<Instr>>) =
            Module(
                Set.empty,
                Map.empty,
                [],
                Set.empty,
                Set.empty,
                Set.empty,
                Set.empty,
                None,
                Set.empty,
                Set.empty,
                Set.empty,
                tempCode,
                0,
                []
            )

        member this.GetFuncTableSize = this.elements.Count

        member this.GetHostingList() = this.hostinglist

        member this.AddToHostingList(name: string) =
            Module(
                this.types,
                this.functions,
                this.tables,
                this.memories,
                this.globals,
                this.exports,
                this.imports,
                this.start,
                this.elements,
                this.data,
                this.locals,
                this.tempCode,
                this.funcTableSize,
                name :: this.hostinglist
            )

        member this.GetAllFuncs() = this.functions |> Map.toList

        member this.ReplaceFuncs(list: list<(string * FunctionInstance) * string>) =
            // map list to map
            let map = list |> List.map (fun ((name, f), s) -> (name, (f, s))) |> Map.ofList

            Module(
                this.types,
                map,
                this.tables,
                this.memories,
                this.globals,
                this.exports,
                this.imports,
                this.start,
                this.elements,
                this.data,
                this.locals,
                this.tempCode,
                this.funcTableSize,
                this.hostinglist
            )

        member this.RemoveLocal(name: string) =
            let locals = this.locals |> Set.filter (fun (n, _) -> n <> Some name)

            Module(
                this.types,
                this.functions,
                this.tables,
                this.memories,
                this.globals,
                this.exports,
                this.imports,
                this.start,
                this.elements,
                this.data,
                locals,
                this.tempCode,
                this.funcTableSize,
                this.hostinglist
            )

        /// add func ref element and grow func table. GetFuncTableSize will be increased by 1
        /// <summary>add func ref element and grow func table</summary>
        /// <param name="label">label of function</param>
        /// <returns>new module</returns>
        member this.AddFuncRefElement(label: string, index: int) =
            // is there a tabel named func_table
            let func_table =
                this.tables |> List.tryFind (fun (name, _, _) -> name = "func_table")

            // init table if no table named func_table exists
            let (table: Table) =
                match func_table with
                | Some(name, valueType, limits) -> (name, valueType, limits)
                | None -> ("func_table", Funcref, Unbounded 1)

            let elements: Element = (index, label)

            Module(
                this.types,
                this.functions,
                table :: this.tables,
                this.memories,
                this.globals,
                this.exports,
                this.imports,
                this.start,
                Set(elements :: Set.toList this.elements),
                this.data,
                this.locals,
                this.tempCode,
                this.elements.Count + 1,
                this.hostinglist
            )

        // add temp code
        member this.AddCode(instrs: Instr list) =
            // map comment to instrs
            let instrs = instrs |> List.map (fun x -> Commented(x, ""))
            let tempCode = this.tempCode @ instrs

            Module(
                this.types,
                this.functions,
                this.tables,
                this.memories,
                this.globals,
                this.exports,
                this.imports,
                this.start,
                this.elements,
                this.data,
                this.locals,
                tempCode,
                this.funcTableSize,
                this.hostinglist
            )

        // add temp code with comment
        member this.AddCode(instrs: Commented<Instr> list) =
            let tempCode = this.tempCode @ instrs

            Module(
                this.types,
                this.functions,
                this.tables,
                this.memories,
                this.globals,
                this.exports,
                this.imports,
                this.start,
                this.elements,
                this.data,
                this.locals,
                tempCode,
                this.funcTableSize,
                this.hostinglist
            )

        // get temp code
        member this.GetAccCode() = this.tempCode

        // reset temp code
        member this.ResetAccCode() =
            Module(
                this.types,
                this.functions,
                this.tables,
                this.memories,
                this.globals,
                this.exports,
                this.imports,
                this.start,
                this.elements,
                this.data,
                this.locals,
                [],
                this.funcTableSize,
                this.hostinglist
            )

        // reset Locals
        member this.ResetLocals() =
            Module(
                this.types,
                this.functions,
                this.tables,
                this.memories,
                this.globals,
                this.exports,
                this.imports,
                this.start,
                this.elements,
                this.data,
                Set.empty,
                this.tempCode,
                this.funcTableSize,
                this.hostinglist
            )

        // add locals to module
        member this.AddLocals(locals: list<Local>) =
            let locals = locals @ Set.toList this.locals

            Module(
                this.types,
                this.functions,
                this.tables,
                this.memories,
                this.globals,
                this.exports,
                this.imports,
                this.start,
                this.elements,
                this.data,
                Set(locals),
                this.tempCode,
                this.funcTableSize,
                this.hostinglist
            )

        // get locals from module
        member this.GetLocals() = Set.toList this.locals

        // add locals tp function with name
        member this.AddLocals(name: string, locals: list<Local>) =
            let (f), s = this.functions.[name]

            let newInstance: Commented<FunctionInstance> =
                ({ typeIndex = f.typeIndex
                   locals = f.locals @ locals
                   signature = f.signature
                   body = f.body
                   name = f.name },
                 s)

            let functions = this.functions.Add(name, newInstance)

            Module(
                this.types,
                functions,
                this.tables,
                this.memories,
                this.globals,
                this.exports,
                this.imports,
                this.start,
                this.elements,
                this.data,
                this.locals,
                this.tempCode,
                this.funcTableSize,
                this.hostinglist
            )

        // Add instructions to function with name
        member this.AddInstrs(name: string, instrs: Instr list) =
            let (f), s = this.functions.[name]
            // add instrs to function f a function instance
            let newInstance: Commented<FunctionInstance> =
                ({ typeIndex = f.typeIndex
                   locals = f.locals
                   signature = f.signature
                   body = f.body @ (instrs |> List.map (fun x -> Commented(x, "")))
                   name = f.name },
                 s)

            let functions = this.functions.Add(name, newInstance)

            Module(
                this.types,
                functions,
                this.tables,
                this.memories,
                this.globals,
                this.exports,
                this.imports,
                this.start,
                this.elements,
                this.data,
                this.locals,
                this.tempCode,
                this.funcTableSize,
                this.hostinglist
            )

        member this.AddInstrs(name: string, instrs: Commented<Instr> list) =
            let (f), s = this.functions.[name]
            // add instrs to function f a function instance
            let newInstance: Commented<FunctionInstance> =
                ({ typeIndex = f.typeIndex
                   locals = f.locals
                   signature = f.signature
                   body = f.body @ instrs
                   name = f.name },
                 s)

            let functions = this.functions.Add(name, newInstance)

            Module(
                this.types,
                functions,
                this.tables,
                this.memories,
                this.globals,
                this.exports,
                this.imports,
                this.start,
                this.elements,
                this.data,
                this.locals,
                this.tempCode,
                this.funcTableSize,
                this.hostinglist
            )

        // Add an import to the module
        member this.AddImport(i: Import) =
            let imports = i :: Set.toList this.imports

            Module(
                this.types,
                this.functions,
                this.tables,
                this.memories,
                this.globals,
                this.exports,
                Set(imports),
                this.start,
                this.elements,
                this.data,
                this.locals,
                this.tempCode,
                this.funcTableSize,
                this.hostinglist
            )


        // Add a function to the module
        member this.AddFunction(name: string, f: Commented<FunctionInstance>) = this.AddFunction(name, f, false)

        member this.AddFunction(name: string, f: Commented<FunctionInstance>, addTypedef: bool) =
            // add typedef
            let (types, f') =
                if addTypedef then
                    let typeIndex = this.types.Count

                    // get instance
                    let instance = fst f
                    // add typeindex to instance
                    let instance = { instance with typeIndex = typeIndex }
                    // add instance to function
                    let f' = (instance, snd f)
                    let typedef = instance.signature

                    let typeS = Utils.GenFuncTypeName typedef

                    let typedef = (typeS, typedef)

                    let set = Set(List.distinctBy (fun l -> fst l) (typedef :: Set.toList this.types))

                    set, f'
                else
                    this.types, f

            Module(
                types,
                functions.Add(name, f'),
                this.tables,
                this.memories,
                this.globals,
                this.exports,
                this.imports,
                this.start,
                this.elements,
                this.data,
                this.locals,
                this.tempCode,
                this.funcTableSize,
                this.hostinglist
            )

        // Add a table to the module
        member this.AddTable(t: Table) =
            let tables = t :: this.tables

            Module(
                this.types,
                this.functions,
                tables,
                this.memories,
                this.globals,
                this.exports,
                this.imports,
                this.start,
                this.elements,
                this.data,
                this.locals,
                this.tempCode,
                this.funcTableSize,
                this.hostinglist
            )

        // Add a memory to the module
        member this.AddMemory(m: Memory) =
            Module(
                this.types,
                this.functions,
                this.tables,
                Set(m :: (Set.toList memories)),
                this.globals,
                this.exports,
                this.imports,
                this.start,
                this.elements,
                this.data,
                this.locals,
                this.tempCode,
                this.funcTableSize,
                this.hostinglist
            )

        /// <summary>add global to module</summary>
        /// <param name="g">global</param>
        /// <returns>module</returns>
        /// <example>
        /// let g = ("g", (I32, Mutable), [I32Const 0l])
        /// let m = m.AddGlobal g
        /// </example>
        /// <remarks>add global to module</remarks>
        member this.AddGlobal(g: Global) =
            let globals = g :: Set.toList this.globals

            Module(
                this.types,
                this.functions,
                this.tables,
                this.memories,
                Set(globals),
                this.exports,
                this.imports,
                this.start,
                this.elements,
                this.data,
                this.locals,
                this.tempCode,
                this.funcTableSize,
                this.hostinglist
            )

        member this.AddGlobals(globals: list<Global>) =
            let globals = globals @ Set.toList this.globals

            Module(
                this.types,
                this.functions,
                this.tables,
                this.memories,
                Set(globals),
                this.exports,
                this.imports,
                this.start,
                this.elements,
                this.data,
                this.locals,
                this.tempCode,
                this.funcTableSize,
                this.hostinglist
            )

        // Add an export to the module
        member this.AddExport(e: Export) =
            let exports = e :: Set.toList this.exports

            Module(
                this.types,
                this.functions,
                this.tables,
                this.memories,
                this.globals,
                Set(exports),
                this.imports,
                this.start,
                this.elements,
                this.data,
                this.locals,
                this.tempCode,
                this.funcTableSize,
                this.hostinglist
            )

        //  Add Data to the module
        member this.AddData(d: Data) =
            let data = d :: Set.toList this.data

            Module(
                this.types,
                this.functions,
                this.tables,
                this.memories,
                this.globals,
                this.exports,
                this.imports,
                this.start,
                this.elements,
                Set(data),
                this.locals,
                this.tempCode,
                this.funcTableSize,
                this.hostinglist
            )

        // combine two wasm modules
        member this.Combine(m: Module) =
            let types =
                Set(List.distinctBy (fun l -> fst l) (Set.toList this.types @ Set.toList m.types))

            let functions =
                Map.fold (fun acc key value -> Map.add key value acc) this.functions m.functions

            let tables = this.tables @ m.tables
            let memories = Set.toList this.memories @ Set.toList m.memories
            let globals = Set.toList this.globals @ Set.toList m.globals
            let exports = Set.toList this.exports @ Set.toList m.exports
            let imports = Set.toList this.imports @ Set.toList m.imports
            let start = this.start
            let elements = Set.toList this.elements @ Set.toList m.elements
            let data = Set.toList this.data @ Set.toList m.data
            let locals = Set.toList this.locals @ Set.toList m.locals
            let tempCode = this.tempCode @ m.tempCode
            let hostinglist = this.hostinglist @ m.hostinglist

            Module(
                Set(types),
                functions,
                tables,
                Set(memories),
                Set(globals),
                Set(exports),
                Set(imports),
                start,
                Set(elements),
                Set(data),
                Set(locals),
                tempCode,
                this.funcTableSize + m.funcTableSize,
                hostinglist
            )

        static member (+)(wasm1: Module, wasm2: Module) : Module = wasm1.Combine wasm2

        static member (++)(wasm1: Module, wasm2: Module) : Module = wasm1.Combine wasm2

        static member (++)(instr: Commented<Instr> list, wasm2: Module) : Module = Module(instr).Combine wasm2

        static member (@)(wasm1: Instrs list, wasm2: Commented<Instrs> list) =
            let instrs = wasm1 |> List.map (fun x -> Commented(x, ""))
            instrs @ wasm2

        static member (@)(wasm1: Commented<Instrs> list, wasm2: Instrs list) =
            let instrs = wasm2 |> List.map (fun x -> Commented(x, ""))
            wasm1 @ instrs

        static member (@)(wasm1: Commented<Instrs> list, wasm2: Commented<Instrs> list) = wasm1 @ wasm2

        override this.ToString() =
            let mutable result = ""

            // open module tag
            result <- result + "(module\n"

            // print all types
            for type_ in List.indexed (Set.toList this.types) do
                result <- result + (printType type_ false)

            // print all imports
            for (i: int, import: Import) in List.indexed (Set.toList this.imports) do

                let modu, func_name, func_signature = import

                result <-
                    result
                    + sprintf
                        "  (import \"%s\" \"%s\" %s %s)\n"
                        modu
                        func_name
                        (ic i)
                        (match func_signature with
                         | FunctionType(name, signature) ->
                             match signature with
                             | Some signature -> sprintf "(func $%s %s)" name (generate_signature signature "")
                             | _ -> $"(func $%s{name})"
                         | TableType table -> $"(table %s{table.ToString()})"
                         | MemoryType memory -> $"(memory %s{memory.ToString()})"
                         | _ -> "")
            // print all memories
            for i, (name, Limits) in List.indexed (Set.toList this.memories) do
                result <- result + $"  (memory %s{ic i} (export \"%s{name}\") %s{Limits.ToString()})\n"

            // print all globals
            for global_ in List.indexed (Set.toList this.globals) do
                result <- result + (printGlobal global_)


            // print tables and elements

            // func table
            result <-
                result
                + sprintf
                    "  (table $%s %s %s %s)\n"
                    "func_table"
                    (ic 0)
                    $"%d{this.elements.Count}"
                    (ValueType.Funcref.ToString())

            // // print rest of tables
            // for table in this.tables do
            //     result <- result + sprintf "  (table %s)\n" (table.ToString())

            for i, element in List.indexed (Set.toList this.elements) do
                // unpacked element
                let (index, element) = element
                result <- result + $"  (elem (i32.const %i{index}) %s{ic i} $%s{element.ToString()})\n"


            // create functions
            let mutable x: int = 0

            for funcKey in this.functions.Keys do
                let (f), c = this.functions.[funcKey]

                result <-
                    result
                    + $"  (func %s{genrate_name f.name} %s{ic x} %s{generate_signature f.signature c} %s{generate_local f.locals}\n%s{generate_wat_code_ident f.body ((indent / 2) + 1)}  )\n"

                // increase x
                x <- x + 1

            for (instr, data) in this.data do
                result <- result + $"  (data (%s{instr.ToString()}) \"%s{data.ToString()}\")\n"

            // create exports
            for export in this.exports do
                result <-
                    result
                    + sprintf
                        "  (export \"%s\" %s)\n"
                        (fst export)
                        (match snd export with
                         | FunctionType(name, _) -> $"(func $%s{name})"
                         | TableType table -> $"(table %s{table.ToString()})"
                         | MemoryType memory -> $"(memory %s{memory.ToString()})"
                         | GlobalType global_ -> $"(global $%s{global_.ToString()})"
                         | _ -> "")
            // print start
            match this.start with
            | Some index -> result <- result + $"  (start %d{index})\n"
            | None -> ()

            // close module tag
            result <- result + ")"

            // return module represented in WAT format as string
            result