namespace WasmTimeDriver;

public static class Utils
{   

    private static string _tempPath = "./data";

    private static void WriteToFile(string filePath, string content)
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
    private static string GetFileName(string path)
    {   
        var fileName = Path.GetFileNameWithoutExtension(path);
        return fileName;
    }

    // run wasm-tools
    // wasm-tools parse struct_working.wat -o struct_working.wasm
    public static void WasmTools(string path, string type) 
    {
        // create directory if not exists
        var folded = Path.GetDirectoryName($"{_tempPath}/{type}/folded/wasm/");
        if (!Directory.Exists(folded))
        {
            Directory.CreateDirectory(folded);
        }

        var fileName = GetFileName(path);
        var wasmPath = $"{_tempPath}/{type}/folded/wasm/{fileName}.wasm";
        var wasmTools = $"wasm-tools parse {path} -o {wasmPath}";
        var process = System.Diagnostics.Process.Start("bash", $"-c \"{wasmTools}\"");

        process.WaitForExit();

        // Check the exit code to determine if there was an error
        if (process.ExitCode != 0)
        {
            Console.WriteLine($"wasm-tools: The process exited with an error. Exit code: {process.ExitCode}, test: {fileName}");
            throw new Exception($"wasm-tools: The process exited with an error. Exit code: {process.ExitCode}");
        }
    }

    public static void Createfile(string name, string wat, WGF.Types.WritingStyle style)
    {
        var fileName = GetFileName(name);
        var type = GetFolderName(name);
        var path = $"{_tempPath}/{type}/{style}/wat/{fileName}.wat";

        WriteToFile(path, wat);

        // validate wat file and create wasm file
        WasmTools(path, type);
    }

    // get last folder name from path
    private static string GetFolderName(string path)
    {
        var folderName = Path.GetFileName(Path.GetDirectoryName(path));
        return folderName;
    }
}