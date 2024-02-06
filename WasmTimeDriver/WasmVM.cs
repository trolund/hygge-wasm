﻿using System.Collections;
using Wasmtime;

namespace WasmTimeDriver
{

    public class WasmVM : IWasmVM
    {

        private readonly Engine _engine;
        private readonly Linker _linker;
        private readonly Store _store;
        /// <summary>
        ///  Memory allocator for the VM with initial heap size of 1 page.
        /// </summary>
        /// <remarks>
        /// The heap size will grow if the VM tries to allocate more memory than the current heap size.
        /// A debug flag can be set to print out when the heap is growing.
        /// </remarks>
        private readonly MemoryAllocator _allocator;
        private readonly string main = "_start";

        private readonly bool debug = false;
        private readonly bool output = false;

        public WasmVM(bool debug = false, bool output = false)
        {

            this.debug = debug;
            this.output = output;
            this._allocator = new MemoryAllocator(1, debug);

            var config = new Config()
                // .WithDebugInfo(true)
                // .WithCraneliftDebugVerifier(true)
                .WithOptimizationLevel(0);

            _engine = new Engine(config);
            _store = new Store(_engine);

            var WasiConfig = new WasiConfiguration()
            .WithInheritedStandardOutput()
            .WithInheritedStandardInput()
            .WithInheritedArgs()
            .WithInheritedStandardError()
            .WithInheritedEnvironment();

            // Set up all WASI functunality 
            _store.SetWasiConfiguration(WasiConfig);

            _linker = new Linker(_engine);
            SetupLinker();
        }

        private void SetupLinker()
        {

            _linker.Define(
                "env",
                "malloc",
                Function.FromCallback(_store, (Caller caller, int size) =>
                {
                    IntPtr adreess = _allocator.Malloc(caller.GetMemory("memory"), size);

                    return adreess.ToInt32();
                })
            );

            _linker.Define(
               "env",
               "readInt",
               Function.FromCallback(_store, () =>
               {
                   try
                   {
                       string? s = "";
                       int res;
                       do
                       {
                           s = Console.ReadLine();
                           res = Int32.Parse(s);
                       } while (s is null);
                       return res;
                   }
                   catch (Exception e)
                   {
                       Console.WriteLine("error:" + e);
                   }

                   return 0;
               })
           );


            _linker.Define(
               "env",
               "readFloat",
               Function.FromCallback(_store, () =>
               {
                   try
                   {
                       string? s = "";
                       float res;
                       do
                       {
                           s = Console.ReadLine();
                           res = float.Parse(s);
                       } while (s is null);
                       return res;
                   }
                   catch (Exception e)
                   {
                       Console.WriteLine("error:" + e);
                   }

                   return 0;
               })
           );

            _linker.Define(
                "env",
                "writeInt",
                Function.FromCallback(_store, (int i, int nl) =>
                {   
                    if (nl == 1) {
                        Console.WriteLine(i);
                    } else {
                        Console.Write(i);
                    }
                })
            );

            _linker.Define(
                "env",
                "writeFloat",
                Function.FromCallback(_store, (float i, int nl) =>
                {
                    if (nl == 1) {
                        Console.WriteLine(i);
                    } else {
                        Console.Write(i);
                    }
                })
            );

            _linker.Define(
                "env",
                "writeS",
                Function.FromCallback(_store, (Caller caller, int address, int length, int nl) =>
                {
                    // memory == export name
                    var memory = caller.GetMemory("memory");
                    if (memory == null)
                    {
                        Console.WriteLine("Error: Memory not found.");
                        return;
                    }
                    var message = memory.ReadString(address, length);
                    
                    if (nl > 0) {
                        Console.WriteLine(message);
                    } else {
                        Console.Write(message);
                    }
                })
            );

            _linker.DefineWasi();

        }

        public object?[] RunFileTimes(string path, int n)
        {
            return RunFileTimes(path, main, n);
        }

        public object?[] RunFileTimes(string path, string target, int n)
        {
            ArrayList list = new ArrayList();

            for (int i = 0; i < n; i++)
            {
                list.Add(RunFile(path, target));
            }

            return list.ToArray();
        }

        public object? RunFile(string path, string name = "unknown")
        {
            return RunFile(path, main, name);
        }

        public object? RunWatString(string target, string wat, string name = "unknown")
        {
            return RunWat(target, wat, name);
        }

        public object? RunWatString(string wat, string name = "unknown")
        {
            return RunWat(main, wat, name);
        }


        public object? RunWat(string target, string wat, string name = "unknown")
        {
            try
            {
                // load module 
                using var module = Module.FromText(_engine, name, wat);

                return ExecModule(module, target, name);
            }
            catch (Exception e)
            {
                Console.WriteLine(name);
                Console.WriteLine(e);
                return 42;
            }
        }

        public object? RunFile(string path, string? target, string name = "unknown")
        {
            try
            {
                // load module 
                if (debug) Console.WriteLine("Loading module from file: " + path);
                using var module = Module.FromTextFile(_engine, path);

                if (target is null)
                {
                    return 0;
                }

                return ExecModule(module, target);
            }
            catch (Exception e)
            {
                Console.WriteLine(name);
                Console.WriteLine(e);
                return 42;
            }
        }

        public object? ExecModule(Module m, string target, string name = "unknown")
        {
            // when the instance will the VM run.
            var instance = _linker.Instantiate(_store, m);
            // run specific target.
            var res = RunTarget(target, instance, name);

            return res;
        }

        public object? Run(string wat, string target, string name = "unknown")
        {
            try
            {
                // load module 
                using var module = Module.FromText(_engine, target, wat);
                return ExecModule(module, target);
            }
            catch (Exception e)
            {
                Console.WriteLine(name);
                Console.WriteLine(e);
                return 42;
            }
        }

        private object? RunTarget(string target, Instance? instance, string name = "unknown")
        {

            if (target is null || target.Length == 0)
            {
                throw new Exception("error: target was null or have length of zero");
            }

            if (instance is null)
            {   
                throw new Exception("error: instance was null");
            }

            // get heap pointer
            try
            {
                var heap = instance.GetGlobal("heap_base_ptr").GetValue();
                _allocator.SetHeapPointer(Int32.Parse(heap.ToString()));
            }
            catch (Exception e)
            {
                if (debug) Console.WriteLine("No heap_base_ptr found");
            }

            // get target function
            var function = instance.GetFunction(target);

            if (function is null)
            {
                if (debug) { 
                    Console.WriteLine(name);
                    Console.WriteLine($"warn: {target} export is missing");
                }
                return null;
            }

            // run the code
            try
            {
                function.Invoke();

                // exit code is null if the function does not return anything
                try
                {
                    var exitCode = instance.GetGlobal("exit_code").GetValue();
                    return exitCode;
                }
                catch (Exception e)
                {
                    if (debug) Console.WriteLine("No exit code found");
                }
            }
            catch
            {
                // mashine trap error code
                // Console.WriteLine($"Machine trap error: {e}");
                return 42;
            }
            return 0;
        }

        public void Dispose()
        {
            _engine.Dispose();
            _store.Dispose();
            _linker.Dispose();

        }
    }

}



