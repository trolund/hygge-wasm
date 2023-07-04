using System;
using Wasmtime;

namespace WasmTimeDriver
{
	public interface IWasmVM
	{
		public object? RunFile(string path);
		public object? RunFile(string path, string target);
    }
}

