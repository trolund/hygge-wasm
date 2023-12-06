// import { readFile as _readFile } from 'fs';
// import { promisify } from 'util';
// const readFile = promisify(_readFile);

class MemoryAllocator {

  // current offset
  offset = 0;

  // number of pages
  currentSize = 1;

  // 64kb page size
  _pageSize = 64 * 1024;

  // 4 bytes stride
  _stride = 4;

  grow = null;

  _memory;

  _isDebug = true;

  // constructor
  constructor(isDebug = false) {
      this._isDebug = isDebug;
  }

  /// Allocate a new block of memory of the given size in bytes.
  /// Returns the offset of the allocated block.
  allocate(size) {
  if (this.offset + size > (this.currentSize * this._pageSize) && this.grow) {
      // find required number of pages to grow
      const requiredPages = (this.offset + size) / this._pageSize;
      // round required pages to the next integer
      const roundedPages = (Math.ceil(requiredPages)) - 1;

      this.grow(roundedPages); // grow by 1 page
      this.currentSize = requiredPages; // update current size

      console.log(`MemoryAllocator: growing memory by ${roundedPages} pages`);
  }

  const addrees = this.offset; // save current offset
  this.offset += size; // increment offset by size

  if (this._isDebug) console.log(`MemoryAllocator: allocated ${size} bytes at offset ${addrees}`);

  return addrees; // return address
  }

  setGrow(grow) {
      this.grow = grow;
  }

  get memory() {
      return this._memory;
  }

  set memory(memory) {
      this._memory = memory;
  }

  /// set the allocator to the given offset
  set(offset) {
      let mul8 = (offset + 7) &(-8); // https://www.geeksforgeeks.org/round-to-next-greater-multiple-of-8/
      this.offset = mul8;
  }

  /// Reset the allocator to the beginning of the memory block
  reset() {
      this.offset = 0;
  }

}

// this code comes from https://stackoverflow.com/questions/8936984/uint8array-to-string-in-javascript
function Utf8ArrayToStr(array) {
  var out, i, len, c;
  var char2, char3;

  out = "";
  len = array.length;
  i = 0;
  while(i < len) {
  c = array[i++];
  switch(c >> 4)
  { 
    case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7:
      // 0xxxxxxx
      out += String.fromCharCode(c);
      break;
    case 12: case 13:
      // 110x xxxx   10xx xxxx
      char2 = array[i++];
      out += String.fromCharCode(((c & 0x1F) << 6) | (char2 & 0x3F));
      break;
    case 14:
      // 1110 xxxx  10xx xxxx  10xx xxxx
      char2 = array[i++];
      char3 = array[i++];
      out += String.fromCharCode(((c & 0x0F) << 12) |
                     ((char2 & 0x3F) << 6) |
                     ((char3 & 0x3F) << 0));
      break;
  }
  }

  return out;
}


function getImports(memoryAllocator, isDebug = false) {

  return {
      env: {
        abort(_msg, _file, line, column) {
          console.error("abort called at index.ts:" + line + ":" + column);
        },
        writeS(address, length) {
          // Get `memory[address..address + length]`.
          const mem = new Uint8Array(
            memoryAllocator.memory.buffer
          );
  
          const data = mem.subarray(
            address,
            address + length
          );
  
          const text = Utf8ArrayToStr(data);
          console.log(text);
        },
        writeInt(i){
          console.log(i);
        },
        writeFloat(f){
          console.log(f);
        },
        readFloat() {
          var num;
          do {
            var val = prompt("Input a float");
            if (val == null) {
              continue;
            }
            num = parseFloat(val);

            console.log("User provided input:", num);
            return num;
          }
          while (num && isNaN(num));
          return 0;
        },
        
        malloc(size) {
          let pointer = memoryAllocator.allocate(size);
          if (isDebug) { console.log("malloc", size, "pointer", pointer); }
          return pointer;
        },
        readInt() {
          var num;
          do {
            var val = prompt("Input an integer");
            if (val == null) {
              continue;
            }
            num = parseInt(val);

            console.log("User provided input:", num);
            return num;
          }
          while (num && isNaN(num));
          return 0;
        },
      }
    }

  }

async function runWasm() {    

  const memoryAllocator = new MemoryAllocator(true);

  const combinedImports = {
    ...getImports(memoryAllocator, true) // Other "custom" imports
};

  // const path = readline();
  const path = read("./runFile.txt", "utf8");

  const buf = read(path, 'binary');
  const module = await WebAssembly.compile(buf);
  const wasmInstance = new WebAssembly.Instance(module, combinedImports);

  console.log("👍 Instantiated!");
    
  // const exports = WebAssembly.Module.exports(wasmModule);
  // console.log(exports);

  // Grow the memory function
  let growMemory = (n) => {
      (wasmInstance.exports.memory).grow(n);
  }

  let heap_base;

  try {
      heap_base = (wasmInstance.exports.heap_base_ptr).value;
  } catch (e) {
      console.log("No heap_base_ptr found");
      heap_base = 0;
  }

  // initialize the memory allocator
  memoryAllocator.set(heap_base);
  memoryAllocator.memory = (wasmInstance.exports.memory);
  memoryAllocator.setGrow(growMemory);


  const result = wasmInstance.exports._start();
  console.log('Result:', result);
}

runWasm();
