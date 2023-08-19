namespace Wat

module WFG =

    open System.Text

    let generate_wat_code instrs =

        let rec generate_wat_code_aux instrs watCode =
            match instrs with
            | [] -> watCode
            | instr :: tailInstrs -> generate_wat_code_aux tailInstrs (watCode + (instr.ToString()) + "\n")

        generate_wat_code_aux instrs ""

    type ValueType =
        | I32
        | I64
        | F32
        | F64
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
                | Empty -> "empty"
    
   // Instructions are syntactically distinguished into plain (Instr) and structured instructions (BlockInstr).
    type Instr =
        | PlainInstr of PlainInstr
        | BlockInstr of BlockInstr

        override this.ToString() =
            match this with
                | PlainInstr i -> i.ToString()
                | BlockInstr i -> i.ToString()

    and PlainInstr = 
        // Control Instrs
        | Unreachable
        | Nop
        | Else of ValueType list * ValueType list * Instr list * Instr list
        | Br of int
        | BrIf of int
        | BrTable of int list * int
        | Return
        // Memory Instrs
        | I32Load of int * int
        | I64Load of int * int
        | F32Load of int * int
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
        | I32Store of int * int
        | I64Store of int * int
        | F32Store of int * int
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
        | LocalGet of int
        | LocalSet of int
        | LocalTee of int
        | GlobalGet of int
        | GlobalSet of int
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
        | CallIndirect of int * int
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
        // comment
        | Comment of string

        
        override this.ToString() =
            match this with
                | I32Const value -> sprintf "i32.const %i" value
                | I64Const value -> sprintf "i64.const %i" value
                | F32Const value -> sprintf "f32.const %f" value
                | F64Const value -> sprintf "f64.const %f" value
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
                | I32Load (align, offset) -> sprintf "i32.load align=%d offset=%d" align offset
                | I64Load (align, offset) -> sprintf "i64.load align=%d offset=%d" align offset
                | F32Load (align, offset) -> sprintf "f32.load align=%d offset=%d" align offset
                | F64Load (align, offset) -> sprintf "f64.load align=%d offset=%d" align offset
                | I32Load8S (align, offset) -> sprintf "i32.load8_s align=%d offset=%d" align offset
                | I32Load8U (align, offset) -> sprintf "i32.load8_u align=%d offset=%d" align offset
                | I32Load16S (align, offset) -> sprintf "i32.load16_s align=%d offset=%d" align offset
                | I32Load16U (align, offset) -> sprintf "i32.load16_u align=%d offset=%d" align offset
                | I64Load8S (align, offset) -> sprintf "i64.load8_s align=%d offset=%d" align offset
                | I64Load8U (align, offset) -> sprintf "i64.load8_u align=%d offset=%d" align offset
                | I64Load16S (align, offset) -> sprintf "i64.load16_s align=%d offset=%d" align offset
                | I64Load16U (align, offset) -> sprintf "i64.load16_u align=%d offset=%d" align offset
                | I64Load32S (align, offset) -> sprintf "i64.load32_s align=%d offset=%d" align offset
                | I64Load32U (align, offset) -> sprintf "i64.load32_u align=%d offset=%d" align offset
                | I32Store (align, offset) -> sprintf "i32.store align=%d offset=%d" align offset
                | I64Store (align, offset) -> sprintf "i64.store align=%d offset=%d" align offset
                | F32Store (align, offset) -> sprintf "f32.store align=%d offset=%d" align offset
                | F64Store (align, offset) -> sprintf "f64.store align=%d offset=%d" align offset
                | I32Store8 (align, offset) -> sprintf "i32.store8 align=%d offset=%d" align offset
                | I32Store16 (align, offset) -> sprintf "i32.store16 align=%d offset=%d" align offset
                | I64Store8 (align, offset) -> sprintf "i64.store8 align=%d offset=%d" align offset
                | I64Store16 (align, offset) -> sprintf "i64.store16 align=%d offset=%d" align offset
                | I64Store32 (align, offset) -> sprintf "i64.store32 align=%d offset=%d" align offset
                | MemorySize -> "memory.size"
                | MemoryGrow -> "memory.grow"
                | LocalGet index -> sprintf "get_local %d" index
                | LocalSet index -> sprintf "set_local %d" index
                | LocalTee index -> sprintf "tee_local %d" index
                | GlobalGet index -> sprintf "get_global %d" index
                | GlobalSet index -> sprintf "set_global %d" index
                | Unreachable -> "unreachable"
                | Nop -> "nop"
                //| Block (label, instrs) -> sprintf "(block $%s\n%s\n)" label (generate_wat_code instrs) 
                //| Loop (valueTypes, instrs) -> sprintf "(loop %s\n%s\n)" (generate_wat_code valueTypes) (generate_wat_code instrs)
                //| If (valueTypes1, valueTypes2, instrs1, instrs2) -> sprintf "if %s %s\n%s\nelse\n%s\nend" (generate_wat_code valueTypes1) (generate_wat_code valueTypes2) (generate_wat_code instrs1) (generate_wat_code instrs2)
                | Br index -> sprintf "br %d" index
                | BrIf index -> sprintf "br_if %d" index
                | BrTable (indexes, index) -> sprintf "br_table %s %d" (generate_wat_code indexes) index
                | Return -> "return"
                | Call name -> sprintf "call $%s" name
                | CallIndirect (index, x) -> sprintf "call_indirect %d" index // TODO: add x?? 
                | Drop -> "drop"
                | Select -> "select"
    // all block instructions of wasm
    and BlockInstr =
        | Block of string * list<Instr>
        | Loop of ValueType list * list<Instr>
        // then block, else block
        | If of list<Instr> * list<Instr> option

        // print the block instruction
        override this.ToString() =
            match this with
            | Block (label, instrs) -> sprintf "(block $%s\n%s\n)" label (generate_wat_code instrs) 
            | Loop (valueTypes, instrs) -> sprintf "(loop %s\n%s\n)" (generate_wat_code valueTypes) (generate_wat_code instrs)
            | If (ifInstrs, elseInstrs) -> 
                let elseInstrs = 
                    match elseInstrs with
                    | Some instrs -> instrs
                    | None -> []
                sprintf "(if\n (then\n%s\n) (else\n%s\n)\n)" (generate_wat_code ifInstrs) (generate_wat_code elseInstrs)


    let generate_wat_code_ident instrs ident =
        
        let generate_indent i = List.replicate i " " |> String.concat "" in

        // function that return 1 if the Instr is a BlockInstr
        let is_block_Instr (instr: Instr) =
            match instr with
            | BlockInstr _ -> 1
            | _ -> 0

        let rec generate_wat_code_aux instrs watCode indent =
            match instrs with
            | [] -> watCode
            | head :: tail ->
                let watCode = watCode + generate_indent indent + head.ToString() + "\n" in
                generate_wat_code_aux tail watCode indent

        generate_wat_code_aux instrs "" ident


    type Instrs = Instr list

    and Type = ValueType list * ValueType list

    // module, name, type
    and Import = string * string * ExternalType

    and ExternalType =
        | FunctionType of string * FunctionSignature option
        | TableType of Table
        | MemoryType of Memory
        | GlobalType of Global
        | EmptyType

    and Table = ValueType * Limits
    
    // (memory (export $name) limits)
    and Memory = string * Limits

    and Global = ValueType * Mutability

    and Mutability =
        | Mutable
        | Immutable

    and Limits =
        | Unbounded of int
        | Bounded of int * int

        // to string
        override this.ToString() =
            match this with
            | Unbounded min -> sprintf "%d" min
            | Bounded (min, max) -> sprintf "%d %d" min max
    
    and Export = string * ExternalType

    and Element = int * Instr list

    and Data = Instr * string

    // ( func name <signature> <locals> <body> )
    // The signature declares what the function takes (parameters) and returns (return values).
    // The locals are like vars in JavaScript, but with explicit types declared.
    // The body is just a linear list of low-level Instrs.
    and Function = string option * FunctionSignature * Variable list * Instr list

    // function parameters and return values.
    // The signature declares what the function takes (parameters) and returns (return values)
    and FunctionSignature = ValueType list * ValueType list

    and Variable = ValueType * Mutability

    and TableSegment = int * int list

    and MemorySegment = int * string

    and GlobalSegment = int * Instr list

    and Start = int option

    and ElementSegment = int * int list

    and DataSegment = int * string

    and Code = int * int list * Instr list

    type Commented<'a> = 'a * string option

    let commentToString (x: Commented<'a>) =
        match x with
        | (x, Some comment) -> sprintf "%s ;; %s" (x.ToString()) comment
        | (x, _) -> x.ToString()

    let commentString (a) (b: string option) = 
        match b with
        | Some comment -> sprintf "%s ;; %s" a comment
        | _ -> a
    
    let commentS (b: string option) = 
        match b with
        | Some comment -> sprintf " ;; %s" comment
        | _ -> ""

    [<RequireQualifiedAccess>]
    type Module private (types: list<Type>, functions: Map<string, Commented<Function>>, tables: list<Table>, memories: List<Memory>, globals: list<Global>, exports: Set<Export>, imports: list<Import>, start: Start, elements: list<Element>, data: list<Data>, locals: list<ValueType>, tempCode: list<Instr>) =
            member private this.types: list<Type> = types
            member private this.functions = functions 
            member private this.tables = tables
            member private this.memories = memories
            member private this.globals: list<Global> = globals
            member private this.exports: Set<Export> = exports
            member private this.imports: list<Import> = imports
            member private this.start: Start = start
            member private this.elements: list<Element> = elements
            member private this.data: list<Data> = data
            // member private this.codes = Code
            member private this.locals: list<ValueType> = locals

            member private this.tempCode: list<Instr> = tempCode
            
            // empty constructor
            new () = Module([], Map.empty, [], [], [], Set.empty, [], None, [], [], [], [])
            
            // add temp code
            member this.AddCode (instrs: Instr list) =
                let tempCode = this.tempCode @ instrs
                Module(this.types, this.functions, this.tables, this.memories, this.globals, this.exports, this.imports, this.start, this.elements, this.data, this.locals, tempCode)

            // get temp code
            member this.GetTempCode () =
                this.tempCode

            // reset temp code
            member this.ResetTempCode () =
                Module(this.types, this.functions, this.tables, this.memories, this.globals, this.exports, this.imports, this.start, this.elements, this.data, this.locals, [])

            // Add instructions to function with name
            member this.AddInstrs (name: string, instrs: Instr list) =
                let (f), s = this.functions.[name]
                // add instrs to function f
                // ( func name <signature> <locals> <body> )
                let (n, signature, locals, body) = f

                let functions = this.functions.Add(name, ((n, signature, locals, body @ instrs), s))
                Module(this.types, functions, this.tables, this.memories, this.globals, this.exports, this.imports, this.start, this.elements, this.data, this.locals, this.tempCode)

            // Add an import to the module
            member this.AddImport (i: Import) =
                let imports = i :: this.imports
                Module(this.types, this.functions, this.tables, this.memories, this.globals, this.exports, imports, this.start, this.elements, this.data, this.locals, this.tempCode)

            // Add a function to the module
            member this.AddFunction (name: string, f: Commented<Function>) =
                Module(this.types, functions.Add(name, f), this.tables, this.memories, this.globals, this.exports, this.imports, this.start, this.elements, this.data, this.locals, this.tempCode)
                
            // Add a type to the module
            member this.AddType (t: Type) =
                let types = t :: this.types
                Module(types, this.functions, this.tables, this.memories, this.globals, this.exports, this.imports, this.start, this.elements, this.data, this.locals, this.tempCode)

            // Add a table to the module
            member this.AddTable (t: Table) =
                let tables = t :: this.tables
                Module(this.types, this.functions, tables, this.memories, this.globals, this.exports, this.imports, this.start, this.elements, this.data, this.locals, this.tempCode)

            // Add a memory to the module
            member this.AddMemory (m: Memory) =
                Module(this.types, this.functions, this.tables, m :: memories, this.globals, this.exports, this.imports, this.start, this.elements, this.data, this.locals, this.tempCode)

            // Add a global to the module
            member this.AddGlobal (g: Global) =
                let globals = g :: this.globals
                Module(this.types, this.functions, this.tables, this.memories, globals, this.exports, this.imports, this.start, this.elements, this.data, this.locals, this.tempCode)

            // Add an export to the module
            member this.AddExport (e: Export) =
                let exports = e :: Set.toList this.exports
                Module(this.types, this.functions, this.tables, this.memories, this.globals, Set(exports), this.imports, this.start, this.elements, this.data, this.locals, this.tempCode)

            //  Add Data to the module
            member this.AddData (d: Data) =
                let data = d :: this.data
                Module(this.types, this.functions, this.tables, this.memories, this.globals, this.exports, this.imports, this.start, this.elements, data, this.locals ,this.tempCode)

            // combine two wasm modules
            member this.Combine (m: Module) =
                let types = this.types @ m.types
                let functions = Map.fold (fun acc key value -> Map.add key value acc) this.functions m.functions
                let tables = this.tables @ m.tables
                let memories = this.memories @ m.memories
                let globals = this.globals @ m.globals
                let exports = Set.toList this.exports @ Set.toList m.exports
                let imports = this.imports @ m.imports
                let start = this.start
                let elements = this.elements @ m.elements
                let data = this.data @ m.data
                let locals = this.locals @ m.locals
                let tempCode = this.tempCode @ m.tempCode
                Module(types, functions, tables, memories, globals, Set(exports), imports, start, elements, data, locals, tempCode)

            static member (+) (wasm1: Module, wasm2: Module): Module = wasm1.Combine wasm2

            static member (++) (wasm1: Module, wasm2: Module): Module = wasm1.Combine wasm2

            override this.ToString() =
                let mutable result = ""

                // create functions
                let generate_signature (signature: FunctionSignature) comment =
                    let parameters, returnValues = signature
                    let parametersString = String.concat " " (List.map (fun x -> (sprintf "(param %s)" (x.ToString()))) parameters)
                    let returnValuesString = String.concat " " (List.map (fun x -> (sprintf "(result %s)" (x.ToString()))) returnValues)
                    sprintf "%s %s" parametersString returnValuesString + commentS comment
                
                let generate_local (locals: Variable list) =
                    String.concat " " (List.map (fun x -> (sprintf "(local %s %s)" ((fst x).ToString()) ((snd x).ToString()))) locals)

                let genrate_name (name: string option) =
                    match name with
                    | Some name ->
                        sprintf "$%s" name
                    | _ -> ""        

                result <- result + "(module\n" // open module tag

                for type_ in this.types do // print all types
                    result <- result + sprintf "  (type %s)\n" (type_.ToString())

                for import: Import in this.imports do // print all imports
                
                    let modu, func_name, func_signature = import

                    result <- result + sprintf "  (import \"%s\" \"%s\" %s)\n" modu func_name (match func_signature with
                                                                                                    | FunctionType (name, signature) -> 
                                                                                                                match signature with
                                                                                                                | Some signature -> sprintf "(func $%s %s)" name (generate_signature signature None)
                                                                                                                | _ -> sprintf "(func $%s)" name
                                                                                                    | TableType table -> sprintf "(table %s)" (table.ToString())
                                                                                                    | MemoryType memory -> sprintf "(memory %s)" (memory.ToString())
                                                                                                    | _ -> ""
                                                                                                    )
                                                                                                    

                for global_ in this.globals do
                    result <- result + sprintf "  (global %s)\n" (global_.ToString())

                for element in this.elements do
                    result <- result + sprintf "  (elem %s)\n" (element.ToString())
                for (instr, data) in this.data do
                    result <- result + sprintf "  (data (%s) \"%s\")\n" (instr.ToString()) (data.ToString())
                for table in this.tables do
                    result <- result + sprintf "  (table %s)\n" (table.ToString())
                for (name, Limits)  in this.memories do
                    result <- result + sprintf "  (memory (export \"%s\") %s)\n" name (Limits.ToString())            

                for funcKey in this.functions.Keys do
                    let (name, signature, locals, body), comment = this.functions.[funcKey]
                    result <- result + sprintf "  (func %s %s %s\n%s  )\n" (genrate_name name) (generate_signature signature comment) (generate_local locals) (generate_wat_code_ident body 4) 
                    
                // create exports
                for export in this.exports do
                    result <- result + sprintf "  (export \"%s\" %s)\n" (fst export) (match snd export with
                                                                                        | FunctionType (name, _) -> sprintf "(func $%s)" (name)
                                                                                        | TableType table -> sprintf "(table %s)" (table.ToString())
                                                                                        | MemoryType memory -> sprintf "(memory %s)" (memory.ToString())
                                                                                        | GlobalType global_ -> sprintf "(global %s)" (global_.ToString())
                                                                                        | _ -> "")

                // print start
                match this.start with
                | Some index -> result <- result + sprintf "  (start %d)\n" index
                | None -> ()

                result <- result + ")" // close module tag
                result

