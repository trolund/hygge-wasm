namespace WasmTimeDriver
{
	public interface IWasmVM
	{
		object? Run(string wat, string target, string name = "unknown");
		public object? RunFile(string path, string name = "unknown");
		public object? RunFile(string path, string target, string name = "unknown");
		public object?[] RunFileTimes(string path, string target, int n);
		public object?[] RunFileTimes(string path, int n);
		object? RunWatString(string target, string wat, string name = "unknown");
		object? RunWatString(string wat, string name = "unknown");
	}
}

