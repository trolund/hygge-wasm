namespace WasmTimeDriver;

public class HostDef
{
    // map that contains all the host functions
    public static Dictionary<string, Func<object[], object>> HostFunctions = new();

    
    
}