module WGF.WasmUtil

    open System.Text
    
    // write wasm module to file
    let writeWasmFile (wasm: string) (path: string) =
        let file = System.IO.File.Create(path)
        let bytes = wasm |> Encoding.UTF8.GetBytes
        file.Write(bytes, 0, bytes.Length)
        file.Close()
