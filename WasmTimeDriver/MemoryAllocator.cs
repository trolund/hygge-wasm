using System.Reflection.Metadata;
using Wasmtime;

namespace WasmTimeDriver
{
    /// <summary>
    ///  Memory allocator for the VM with initial heap size of 1 page.
    /// </summary>
    /// <remarks>
    /// The heap size will grow if the VM tries to allocate more memory than the current heap size.
    /// A debug flag can be set to print out when the heap is growing.
    /// </remarks>
    public class MemoryAllocator
    {
        private IntPtr _offset;  // Pointer to the allocated heap
        private int _heapSize; // Size of the heap
                               // wasm page sise - 64KB
        private readonly int _pageSize = 64 * 1024;

        private bool _debugMode;

        public MemoryAllocator(int initialHeapSize, bool debugMode = false)
        {
            _offset = IntPtr.Zero;
            _heapSize = initialHeapSize;
            _debugMode = debugMode;
        }

        // Custom malloc implementation
        public IntPtr Malloc(Memory? mem, int size)
        {

            // if size i <= 0 fail
            if (size <= 0)
            {
                return new IntPtr(-1);
            }

            // check if allocation will be out of bounds
            if (_offset.ToInt32() + size > (_heapSize * _pageSize))
            {
                if (mem != null)
                {
                    int offset = _offset.ToInt32();
                    double requiredPages = (offset + size) / (double) _pageSize;
                    // round required pages to the next integer
                    int roundedPages = (int)Math.Ceiling((double) requiredPages);

                    // difference between current size and the new required size
                    int growBy = roundedPages - _heapSize;

                    mem.Grow(growBy);
                    _heapSize += growBy;

                    if (_debugMode)
                    {
                        Console.ForegroundColor = ConsoleColor.Cyan;
                        Console.WriteLine($"MemoryAllocator: growing memory by {growBy} pages");
                        Console.ResetColor();
                    }
                }
                else
                {
                    return new IntPtr(-1);
                }
            }

            // if allocation is in bounds
            // return pointer to the start of the heap
            var pos = _offset.ToInt32();

            // increment the heap pointer
            _offset = new IntPtr(pos + size);

            if (_debugMode)
            {
                Console.WriteLine($"MemoryAllocator: malloc {size} pointer {pos}");
            }
            return new IntPtr(pos);

            // Implement your memory allocation logic here
            // You'll need to track allocated blocks and manage the heap
            // Return a pointer to the allocated memory
        }

        // set heap pointer
        public void SetHeapPointer(int ptr)
        {
            this._offset = new IntPtr((ptr + 7) & (-8)); // https://www.geeksforgeeks.org/round-to-next-greater-multiple-of-8/
        }

        // reset all memory
        public void Reset()
        {
            // Implement your memory reset logic here
            // This function will be called when the VM is reset   
            this._offset = IntPtr.Zero;
        }

    }

}