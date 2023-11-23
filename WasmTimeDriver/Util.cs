public static class Utils
{
    public static void WriteToFile(string filePath, string content)
    {
        // create directory if not exists
        var directory = Path.GetDirectoryName(filePath);
        if (!Directory.Exists(directory))
        {
            Directory.CreateDirectory(directory);
        }

        using (StreamWriter writer = new StreamWriter(filePath))
        {
            writer.Write(content);
        }
    }

    // exstract file name from path
    public static string GetFileName(string path)
    {   
        var fileName = Path.GetFileNameWithoutExtension(path);
        return fileName;
    }

    // run wat2wasm command on file
    public static void Wat2Wasm(string path, string type) 
    {
        // create directory if not exists
        var directory = Path.GetDirectoryName($"./temp/{type}/wasm/");
        if (!Directory.Exists(directory))
        {
            Directory.CreateDirectory(directory);
        }

        var fileName = GetFileName(path);
        var wasmPath = $"./temp/{type}/wasm/{fileName}.wasm";
        var wat2wasm = $"wat2wasm --debug-names {path} -o {wasmPath}";
        var process = System.Diagnostics.Process.Start("bash", $"-c \"{wat2wasm}\"");

        process.WaitForExit();

        // Check the exit code to determine if there was an error
        if (process.ExitCode != 0)
        {
            Console.WriteLine($"The process exited with an error. Exit code: {process.ExitCode}");
            throw new Exception($"Wat2Wasm: The process exited with an error. Exit code: {process.ExitCode}");
        }
    }

    // run wasm-as command on file
    public static void WasmAs(string path, string type) 
    {
        // create directory if not exists
        var directory = Path.GetDirectoryName($"./temp/{type}/wasm/");
        if (!Directory.Exists(directory))
        {
            Directory.CreateDirectory(directory);
        }

        var fileName = GetFileName(path);
        var wasmPath = $"./temp/{type}/wasm/{fileName}.wasm";
        var wasmAs = $"wasm-as {path} -o {wasmPath}";
        var process = System.Diagnostics.Process.Start("bash", $"-c \"{wasmAs}\"");

        process.WaitForExit();

        // Check the exit code to determine if there was an error
        if (process.ExitCode != 0)
        {
            Console.WriteLine($"WasmAs: The process exited with an error. Exit code: {process.ExitCode}, test: {fileName}");
            throw new Exception($"WasmAs: The process exited with an error. Exit code: {process.ExitCode}");
        }
    }

    public static void Createfile(string name, string wat)
    {
        var fileName = GetFileName(name);
        var type = GetFolderName(name);
        var path = $"./temp/{type}/wat/{fileName}.wat";

        WriteToFile(path, wat);
        Wat2Wasm(path, type);
        // WasmAs(path, type);

    }

    // get last folder name from path
    public static string GetFolderName(string path)
    {
        var folderName = Path.GetFileName(Path.GetDirectoryName(path));
        return folderName;
    }
}
