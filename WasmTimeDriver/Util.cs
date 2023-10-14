using System.IO;
using System.Runtime.InteropServices;

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
    }

    public static void Createfile(string name, string wat)
    {
        var fileName = Utils.GetFileName(name);
        var type = Utils.GetFolderName(name);
        var path = $"./temp/{type}/wat/{fileName}.wat";

        Utils.WriteToFile(path, wat);
        Utils.Wat2Wasm(path, type);
    }

    // get last folder name from path
    public static string GetFolderName(string path)
    {
        var folderName = Path.GetFileName(Path.GetDirectoryName(path));
        return folderName;
    }
}
