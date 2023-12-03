export function getImports(memoryAllocator, isDebug = false) {
    return {
        env: {
            abort(_msg, _file, line, column) {
                console.error("abort called at index.ts:" + line + ":" + column);
            },
            writeS(address, length) {
                const mem = new Uint8Array(memoryAllocator.memory.buffer);
                const data = mem.subarray(address, address + length);
                const decoder = new TextDecoder("utf-8");
                const text = decoder.decode(data);
                console.log(text);
            },
            writeInt(i) {
                console.log(i);
            },
            writeFloat(f) {
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
                } while (num && isNaN(num));
                return 0;
            },
            malloc(size) {
                let pointer = memoryAllocator.allocate(size);
                if (isDebug) {
                    console.log("malloc", size, "pointer", pointer);
                }
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
                } while (num && isNaN(num));
                return 0;
            },
        }
    };
}
//# sourceMappingURL=ImportService.js.map