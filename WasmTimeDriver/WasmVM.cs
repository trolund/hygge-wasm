using System.Collections;
using System.Reflection.Metadata.Ecma335;
using System.Text;
using Microsoft.VisualBasic;
using Wasmtime;

namespace WasmTimeDriver
{

    public class WasmVM : IWasmVM
    {

        private readonly Engine _engine;
        private readonly Linker _linker;
        private readonly Store _store;

        public WasmVM()
        {
            var config = new Config()
                .WithDebugInfo(true)
                .WithCraneliftDebugVerifier(true)
                .WithOptimizationLevel(0);

            _engine = new Engine(config);
            _store = new Store(_engine);

            var WasiConfig = new WasiConfiguration()
            //.WithStandardOutput("/dev/fd/1")
            //.WithStandardInput("/dev/fd/0");
            .WithInheritedStandardOutput()
            .WithInheritedStandardInput();
            // .WithInheritedArgs()
            // .WithInheritedStandardError()
            // .WithInheritedEnvironment();

            // Set up all WASI functunality 
            _store.SetWasiConfiguration(WasiConfig);

            _linker = new Linker(_engine);
            SetupLinker();
        }

        private void SetupLinker()
        {

            // get an input
            _linker.Define(
                "env",
                "read",
                Function.FromCallback(_store, () =>
                {
                    try
                    {
                        string? s = "";
                        do
                        {
                            s = Console.ReadLine();
                        } while (s is null);
                        return s;
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("error:" + e);
                    }

                    return null;
                })
            );

            // print to the console
            /*_linker.Define(
                "env",
                "write",
                Function.FromCallback(_store, (int x) =>
                {
                    Console.WriteLine(x);
                })
            );*/


            /*_linker.Define(
                "env",
                "print",
                Function.FromCallback(_store, (string? s) => Console.WriteLine(s))
            );*/

            _linker.Define(
                "env",
                "write",
                Function.FromCallback(_store, (string s) =>
               {

                   Console.WriteLine(s);
               })
            );

            _linker.Define(
               "env",
               "ReadInt",
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
               "ReadFloat",
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
                Function.FromCallback(_store, (int i) =>
                {
                    var memory = _store.ToString();
                    Console.WriteLine(i);
                })
            );

            _linker.Define(
                "env",
                "writeTwoInts",
                Function.FromCallback(_store, (int a, int b) =>
                {
                    Console.WriteLine(@"{0} {1}", a, b);
                })
            );

            _linker.Define(
                "env",
                "writeS",
                Function.FromCallback(_store, (Caller caller, int address, int length) =>
                {
                    // memory == export name
                    var message = caller.GetMemory("memory").ReadString(address, length / 2);
                    Console.WriteLine(message);
                })
            );

            _linker.DefineWasi();

        }

        public object?[] RunFileTimes(string path, int n)
        {
            return RunFileTimes(path, "main", n);
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

        public object? RunFile(string path)
        {
            return RunFile(path, "main");
        }

        public object? RunWatString(string target, string wat)
        {
            return RunWat(target, wat);
        }

        public object? RunWat(string target, string wat)
        {
            try
            {
                // load module 
                using var module = Module.FromText(_engine, "test", wat);
                return ExecModule(module, target);
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                return null;
            }
        }

        public object? RunFile(string path, string? target)
        {
            try
            {
                // load module 
                using var module = Module.FromTextFile(_engine, path);

                if (target is null)
                {
                    return 0;
                }

                return ExecModule(module, target);
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                return null;
            }
        }

        public object? ExecModule(Module m, string target)
        {
            // when the instance will the VM run.
            var instance = _linker.Instantiate(_store, m);
            // run specific target.
            var res = RunTarget(target, instance);

            return res;
        }

        public object? Run(string wat, string target)
        {
            try
            {
                // load module 
                using var module = Module.FromText(_engine, target, wat);
                return ExecModule(module, target);
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                return null;
            }
        }

        private static object? RunTarget(string target, Instance? instance)
        {

            if (target is null || target.Length == 0)
            {
                throw new Exception("error: target was null or have length of zero");
            }

            if (instance is null)
            {
                throw new Exception("error: instance was null");
            }

            // get target function
            var function = instance.GetFunction(target);

            if (function is null)
            {
                Console.WriteLine($"warn: {target} export is missing");
            }

            // run the code
            return function.Invoke();
        }

    }

}



