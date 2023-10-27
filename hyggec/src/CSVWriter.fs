module CSVWriter

open System.IO


let writeCSV (csvData: string list list) =

    let filePath = "data.csv"

    // Create a StreamWriter to write to the file
    let writer = new StreamWriter(filePath, true)

    csvData
    |> List.map (fun row -> String.concat "," row)
    |> String.concat "\n"
    // Append to file
    |> writer.WriteLine

    writer.Close()
