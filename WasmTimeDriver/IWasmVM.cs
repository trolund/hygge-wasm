using System;
using Wasmtime;

namespace WasmTimeDriver
{
	public interface IWasmVM
	{
		public object? RunFile(string path);
		public object? RunFile(string path, string target);
		public object?[] RunFileTimes(string path, string target, int n);
		public object?[] RunFileTimes(string path, int n);
	}
}

