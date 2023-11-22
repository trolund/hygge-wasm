namespace WGF

module Module =

    open WGF.Types
    open WGF.WatGen
    open WGF.Instr
   
    /// define a module
    [<RequireQualifiedAccess>]
    type Module
        private
        (
            types: Set<Type>,
            functions: Map<string, Commented<FunctionInstance>>,
            tables: seq<Table>,
            memories: Set<Memory>,
            globals: Set<Global>,
            exports: Set<Export>,
            imports: Set<Import>,
            start: Start,
            elements: Set<Element>,
            data: Set<Data>,
            locals: Set<Local>,
            tempCode: list<Commented<Instr.Wasm>>,
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
        member private this.tempCode: list<Commented<Instr.Wasm>> = tempCode

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
        new(tempCode: list<Commented<Instr.Wasm>>) =
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

        member this.IsFunction(name: string) = this.functions.ContainsKey(name)

        member this.LookupFuncInFuncTable(name: string) =
            let (f, s) = this.functions.[name]

            let elems = this.elements |> Set.filter (fun (_, l) -> l = name)

            if elems.Count = 0 then
                None
            else
                let (index, _) = elems |> Set.toList |> List.head

                Some(index, f, s)

        /// add func ref element and grow func table. GetFuncTableSize will be increased by 1
        /// <summary>add func ref element and grow func table</summary>
        /// <param name="label">label of function</param>
        /// <returns>new module</returns>
        member this.AddFuncRefElement(label: string, index: int) =
            // is there a tabel named func_table
            let func_table =
                this.tables |> Seq.tryFind (fun (name, _, _) -> name = "func_table")

            // init table if no table named func_table exists
            let (table: Table) =
                match func_table with
                | Some(name, valueType, limits) -> (name, valueType, limits)
                | None -> ("func_table", Funcref, Unbounded 1)

            let elements: Element = (index, label)

            Module(
                this.types,
                this.functions,
                Seq.append this.tables (seq { table }),
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
        member this.AddCode(instrs: Instr.Wasm list) =
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
        member this.AddCode(instrs: Commented<Instr.Wasm> list) =
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
        member this.AddVars(t: VarType, vars: list<Local>) =
            match t with
            | VarType.Local ->
                let locals = vars @ Set.toList this.locals

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
            | VarType.Global ->
                // map local to global
                let vars: Global list = vars |> List.map (fun (name, t) -> 
                    match name with
                    | Some name -> 
                        match t with
                        | ValueType.I32 -> (name, (I32, Mutable), (I32Const 0, ""))
                        | ValueType.F32 -> (name, (F32, Mutable), (F32Const 0.0f, ""))
                        | _ -> failwith "keep it wasm32"
                    | None -> failwith "global must have name"
                )

                let globals = vars @ Set.toList this.globals

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
                ({ locals = f.locals @ locals
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
        member this.AddInstrs(name: string, instrs: Instr.Wasm list) =
            let (f), s = this.functions.[name]
            // add instrs to function f a function instance
            let newInstance: Commented<FunctionInstance> =
                ({ locals = f.locals
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

        member this.AddInstrs(name: string, instrs: Commented<Instr.Wasm> list) =
            let (f), s = this.functions.[name]
            // add instrs to function f a function instance
            let newInstance: Commented<FunctionInstance> =
                ({ locals = f.locals
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

                    // add instance to function
                    let f' = (instance, snd f)
                    let typedef = instance.signature

                    let typeS = Utils.GenFuncTypeID typedef

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
            let tables = Seq.append this.tables (seq { t })

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
            Module(
                Set.ofSeq (Seq.distinctBy (fun l -> fst l) (Set.union this.types m.types)),
                Map.fold (fun acc key value -> Map.add key value acc) this.functions m.functions,
                Seq.append this.tables m.tables,
                Set.union this.memories m.memories,
                Set.union this.globals m.globals,
                Set.union this.exports m.exports,
                Set.union this.imports m.imports,
                this.start,
                Set.union this.elements m.elements,
                Set.union this.data m.data,
                Set.union this.locals m.locals,
                m.tempCode |> List.append this.tempCode,
                this.funcTableSize + m.funcTableSize,
                this.hostinglist |> List.append m.hostinglist
            )

        static member (+)(wasm1: Module, wasm2: Module) : Module = wasm1.Combine wasm2

        static member (++)(wasm1: Module, wasm2: Module) : Module = wasm1.Combine wasm2

        static member (++)(instr: Commented<Instr.Wasm> list, wasm2: Module) : Module = Module(instr).Combine wasm2

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
                        "%s(import \"%s\" \"%s\" %s %s)\n"
                        (gIndent 1)
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
                result <-
                    result
                    + $"{gIndent 1}(memory %s{ic i} (export \"%s{name}\") %s{Limits.ToString()})\n"

            // print all globals
            for global_ in List.indexed (Set.toList this.globals) do
                result <- result + (printGlobal global_)


            // print tables and elements
            // func table
            result <-
                result
                + sprintf
                    "%s(table $%s %s %s %s)\n"
                    (gIndent 1)
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

                result <-
                    result
                    + $"{gIndent 1}(elem (i32.const %i{index}) %s{ic i} $%s{element.ToString()})\n"


            // create functions
            let mutable x: int = 0

            for funcKey in this.functions.Keys do
                let (f), c = this.functions.[funcKey]

                result <-
                    result
                    + $"{gIndent 1}(func %s{genrate_name f.name} %s{ic x} %s{generate_signature f.signature c} %s{generate_local f.locals}\n%s{genWat f.body 2}  )\n"

                // increase x
                x <- x + 1

            for (instr, data) in this.data do
                result <- result + $"{gIndent 1}(data (%s{printInstr instr}) \"%s{data.ToString()}\")\n"

            // create exports
            for export in this.exports do
                result <-
                    result
                    + sprintf
                        "%s(export \"%s\" %s)\n"
                        (gIndent 1)
                        (fst export)
                        (match snd export with
                         | FunctionType(name, _) -> $"(func $%s{name})"
                         | TableType table -> $"(table %s{table.ToString()})"
                         | MemoryType memory -> $"(memory %s{memory.ToString()})"
                         | GlobalType global_ -> $"(global $%s{global_.ToString()})"
                         | _ -> "")
            // print start
            match this.start with
            | Some index -> result <- result + $"{gIndent 1}(start %d{index})\n"
            | None -> ()

            // close module tag
            result <- result + ")"

            // return module represented in WAT format as string
            result
