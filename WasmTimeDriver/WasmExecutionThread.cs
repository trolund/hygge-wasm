using System.Collections.Concurrent;

namespace WasmTimeDriver
{
    /// <summary>
    /// wasmtime registers per-thread stack-guard bookkeeping the first time it
    /// runs Wasm code on a given OS thread. Under .NET's thread pool (e.g. the
    /// VSTest/Expecto test host), async work can be scheduled onto a different
    /// pool thread each time, and after enough distinct threads have touched
    /// wasmtime, a new one fails that lookup and crashes the whole process
    /// ("Could not determine thread index for stack guard region", SIGBUS/
    /// SIGILL) instead of throwing a catchable exception. Running all wasmtime
    /// calls on one dedicated, persistent thread avoids this entirely.
    /// </summary>
    internal static class WasmExecutionThread
    {
        private static readonly BlockingCollection<Action> _queue = new();

        static WasmExecutionThread()
        {
            var thread = new Thread(() =>
            {
                foreach (var action in _queue.GetConsumingEnumerable())
                {
                    action();
                }
            });
            thread.IsBackground = true;
            thread.Start();
        }

        public static T Invoke<T>(Func<T> func)
        {
            T result = default!;
            Exception? error = null;
            using var done = new ManualResetEventSlim(false);

            _queue.Add(() =>
            {
                try
                {
                    result = func();
                }
                catch (Exception e)
                {
                    error = e;
                }
                finally
                {
                    done.Set();
                }
            });

            done.Wait();

            if (error is not null)
            {
                throw error;
            }

            return result;
        }
    }
}
