using System;
using Wasmtime;

namespace WasmTimeDriver
{
	public interface IWasmVM
	{
		object? Run(string wat, string target);
		public object? RunFile(string path);
		public object? RunFile(string path, string target);
		public object?[] RunFileTimes(string path, string target, int n);
		public object?[] RunFileTimes(string path, int n);
		object? RunWatString(string target, string wat);
	}
}

