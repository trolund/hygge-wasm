using System.Collections;
using Wasmtime;

namespace WasmTimeDriver
{

    public class WasmVM : IWasmVM
    {

        /// <summary>
        /// A wasmtime Engine is meant to be created once and shared across many
        /// Stores/Modules for the lifetime of the process (see wasmtime docs).
        /// Creating one per WasmVM instance - as every compile/test run does -
        /// accumulates native (JIT/GC) resources fast enough to crash the
        /// process after a few dozen instances, so it is shared statically here.
        /// </summary>
        private static readonly Engine _sharedEngine = new Engine(
            new Config()
                // .WithDebugInfo(true)
                // .WithCraneliftDebugVerifier(true)
                .WithOptimizationLevel(0)
                .WithGc(true)
        );

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

            _store = new Store(_sharedEngine);

            var WasiConfig = new WasiConfiguration()
            .WithInheritedStandardOutput()
            .WithInheritedStandardInput()
            .WithInheritedArgs()
            .WithInheritedStandardError()
            .WithInheritedEnvironment();

            // Set up all WASI functunality 
            _store.SetWasiConfiguration(WasiConfig);

            _linker = new Linker(_sharedEngine);
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
            return WasmExecutionThread.Invoke<object?>(() =>
            {
                try
                {
                    // load module
                    using var module = Module.FromText(_sharedEngine, name, wat);

                    return ExecModule(module, target, name);
                }
                catch (Exception e)
                {
                    Console.WriteLine(name);
                    Console.WriteLine(e);
                    return 42;
                }
            });
        }

        public object? RunFile(string path, string? target, string name = "unknown")
        {
            return WasmExecutionThread.Invoke<object?>(() =>
            {
                try
                {
                    // load module
                    if (debug) Console.WriteLine("Loading module from file: " + path);
                    using var module = Module.FromTextFile(_sharedEngine, path);

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
            });
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
            return WasmExecutionThread.Invoke<object?>(() =>
            {
                try
                {
                    // load module
                    using var module = Module.FromText(_sharedEngine, target, wat);
                    return ExecModule(module, target);
                }
                catch (Exception e)
                {
                    Console.WriteLine(name);
                    Console.WriteLine(e);
                    return 42;
                }
            });
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
            // _sharedEngine is process-wide and intentionally never disposed here.
            _store.Dispose();
            _linker.Dispose();
        }
    }

}



