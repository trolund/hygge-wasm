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
            _engine = new Engine();
            _linker = new Linker(_engine);
            _store = new Store(_engine);

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
            _linker.Define(
                "env",
                "write",
                Function.FromCallback(_store, (string? s) => Console.WriteLine(s))
            );
            
            _linker.Define(
                "env",
                "print",
                Function.FromCallback(_store, (string? s) => Console.WriteLine(s))
            );
        }

        public object? RunFile(string path)
        {
            return RunFile(path, "_start");
        }

        public object? RunFile(string path, string target)
        {
            try
            {
                using var module = Module.FromTextFile(_engine, path);
                return RunTarget(target, _linker.Instantiate(_store, module));
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
                throw new Exception($"error: {target} export is missing");
            }

            // run the code
            return function.Invoke();
        }

    }

}



