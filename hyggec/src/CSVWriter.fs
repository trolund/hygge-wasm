module CSVWriter

open System.IO
open System.Threading
open Test

let writeCSV (filename: string) (csvData: string list list) =

    let filePath = "stats.csv" 

    // Create a StreamWriter to write to the file
    let writer = new StreamWriter(filePath)

    (["name of file"; "instr count"; "instr count after op"; "diff"; "% reduction"] :: csvData)
    |> List.map (fun row -> String.concat "," row)
    |> String.concat "\n"
    |> writer.WriteLine

    writer.Close()

let internal collectData tast (file: string) =
    let code = (hyggec.WASMCodegen.codegen tast)
    let opCode = WasmPeephole.optimize code

    let nonOpCount = WasmPeephole.CountInstr code
    let opCount = WasmPeephole.CountInstr opCode

    let fileName = Path.GetFileNameWithoutExtension(file)

    // calualte the precentage of opcodes removed
    let percent = (float (nonOpCount - opCount) / float nonOpCount) * 100.0

    // procent as string with 2 decimals and . to seperate$
    let percent = percent.ToString("0.00", System.Globalization.CultureInfo.InvariantCulture)

    // diffrence between the two
    let diff = nonOpCount - opCount

    [ $"{fileName}"; nonOpCount.ToString(); opCount.ToString(); diff.ToString(); percent.ToString() ]

let internal compile (file: string) (expected: int) =
    match (Util.parseFile file) with
    | Error(e) -> failwith $"Parsing failed: %s{e}"
    | Ok(ast) ->
        match (Typechecker.typecheck ast) with
        | Error(es) -> failwith $"Typing failed: %s{formatErrors es}"
        | Ok(tast) -> collectData tast file

let createStats (opts: CmdLine.StatsOptions) =

    let data =
        (getFilesInTestDir [ "codegen"; "pass" ] |> List.map (fun file -> compile file 0))

    let name = match opts.Out with
               | "" -> "stats.csv"
               | _ -> opts.Out

    writeCSV name data

    0