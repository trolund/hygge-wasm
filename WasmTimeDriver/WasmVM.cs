using System.Collections;
using Wasmtime;

namespace WasmTimeDriver
{

    public class WasmVM
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
                .WithFuelConsumption(true)
                .WithEpochInterruption(true)
        );

        /// <summary>
        /// A runaway (e.g. infinite-looping) Hygge program would otherwise hang
        /// forever on the single shared <see cref="WasmExecutionThread"/>,
        /// wedging every other pending/future Wasm call in the process. Exactly
        /// one of two mechanisms bounds a given run: a fuel budget (consumed
        /// deterministically per executed instruction - reproducible, same trap
        /// point every time) or an epoch-based wall-clock timeout (a background
        /// timer ticks the shared engine's epoch; the run traps once its
        /// deadline is reached). Wasmtime requires both to be enabled at the
        /// engine level regardless (the engine is a shared singleton - see
        /// above - so its Config can't vary per run), so the mechanism that
        /// isn't chosen for a given run is neutralised with an effectively
        /// unlimited budget instead of actually being disabled.
        /// </summary>
        private const int EpochTickMs = 50;

        /// Ticks at 50ms is ~1.5 million years - far beyond any process's
        /// lifetime, so this is "never" for the mechanism not in use, without
        /// risking an unsigned overflow (SetEpochDeadline adds this to the
        /// current epoch) the way ulong.MaxValue would.
        private const ulong UnlimitedTicks = 1_000_000_000_000UL;

        private static readonly System.Threading.Timer _epochTicker = new System.Threading.Timer(
            _ => _sharedEngine.IncrementEpoch(),
            null,
            EpochTickMs,
            EpochTickMs
        );

        private const ulong DefaultFuel = 100_000_000;

        /// Null means "not the active mechanism for this run" - set to an
        /// effectively unlimited budget in RunTarget instead of the real one.
        private readonly ulong? _fuel;
        private readonly int? _timeoutMs;

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

        // ponytail: default fuel budget is a rough order-of-magnitude guess, not a
        // measured figure. Tune via the constructor if it trips on legitimately heavy
        // programs or is too generous.
        //
        // fuel and timeoutMs are mutually exclusive: pass at most one. If both are
        // given, fuel wins. If neither is given, fuel with the default budget is used.
        public WasmVM(bool debug = false, bool output = false, ulong? fuel = null, int? timeoutMs = null)
        {

            this.debug = debug;
            this.output = output;
            if (fuel is not null)
            {
                this._fuel = fuel;
            }
            else if (timeoutMs is not null)
            {
                this._timeoutMs = timeoutMs;
            }
            else
            {
                this._fuel = DefaultFuel;
            }
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
                _store.Fuel = _fuel ?? ulong.MaxValue;
                // ticks are EpochTickMs apart, so this many ticks from now is roughly _timeoutMs away
                _store.SetEpochDeadline(_timeoutMs is int t ? (ulong)Math.Max(1, t / EpochTickMs) : UnlimitedTicks);

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
            catch (TrapException te) when (te.Type == TrapCode.OutOfFuel)
            {
                // program ran out of its fuel budget instead of failing on its own
                if (debug) Console.WriteLine($"warn: execution exceeded its {_fuel} fuel budget and was interrupted");
                return 42;
            }
            catch (TrapException te) when (te.Type == TrapCode.Interrupt)
            {
                // program ran longer than the timeout instead of failing on its own
                if (debug) Console.WriteLine($"warn: execution exceeded {_timeoutMs}ms timeout and was interrupted");
                return 42;
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



