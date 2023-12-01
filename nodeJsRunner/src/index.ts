console.log('Node.js V8 - Hygge Runner');
import fs from 'node:fs';
import { WASI, init, MemFS } from "@wasmer/wasi";
import { MemoryAllocator } from './MemoryAllocator';
import { getImports } from './ImportService';
import { lowerI64Imports } from "@wasmer/wasm-transformer"
import { log } from 'node:console';

const isDebug = true;

const { program } = require('commander');

program
    .option('--first')
    .option('-s, --separator <char>');


program.parse();

const options = program.opts();
const limit = options.first ? 1 : undefined;
// console.log(program.args[0].split(options.separator, limit));
// const wasmBuffer: any = fs.readFileSync('/path/to/add.wasm');
// WebAssembly.instantiate(wasmBuffer).then((wasmModule: any) => {
//     // Exported function live under instance.exports
//     const { add } = wasmModule.instance.exports;
//     const sum = add(5, 6);
//     console.log(sum); // Outputs: 11
// });

const run = async (wasmModule: WebAssembly.Module) => {
    console.log("🏃‍♂️ Running...");

    const memoryAllocator = new MemoryAllocator(isDebug);
    const fs = new MemFS()

    let wasi = new WASI({
        env: {},
        args: [],
        fs: fs,
        preopens: {
            "/": "/",
        }
    });

    if (!wasmModule) {
        console.log("No wasm module found");
        return;
    }

    let wasiImports = {};
    let wasiUsed = false;

    try {
        wasiImports = wasi.getImports(wasmModule);
        wasiUsed = true;
    } catch (e) {
        console.log("WASI not used.")
    }

    const combinedImports = {
        ...wasiImports, // WASI imports
        ...getImports(memoryAllocator, isDebug) // Other "custom" imports
    };

    const instance = await WebAssembly.instantiate(wasmModule, combinedImports);

    console.log("👍 Instantiated!");
    
    // const exports = WebAssembly.Module.exports(wasmModule);
    // console.log(exports);

    // Grow the memory function
    let growMemory = (n: number) => {
        (instance.exports.memory as WebAssembly.Memory).grow(n);
    }

    let heap_base: number;

    try {
        heap_base = (instance.exports.heap_base_ptr as any).value as number;
    } catch (e) {
        console.log("No heap_base_ptr found");
        heap_base = 0;
    }

    // initialize the memory allocator
    memoryAllocator.set(heap_base);
    memoryAllocator.memory = (instance.exports.memory as WebAssembly.Memory);
    memoryAllocator.setGrow(growMemory);

    if (wasiUsed) {

        // Start the WebAssembly WASI instance!
        try {
            // Run the start function
            let exitCode = wasi.start(instance);
            // Get the stdout of the WASI module
            let stdout = wasi.getStdoutString();


            console.log(`${stdout}(exit code: ${exitCode})`, 'DodgerBlue');
        } catch (e) {
            console.error(e);
        } finally {
            wasi.free();
        }

    } else {
        try {
            const start = instance.exports["_start"] as Function;
            const res = start();
            console.log("result:" + res);
        } catch (e) {
            console.error("Program failed");
        } finally {
            handleExitCode(instance);
        }
    }
}

const handleExitCode = (instance: WebAssembly.Instance) => {
    try {
        let exitCode = (instance.exports.exit_code as any).value as number;
        console.log(`exit code: ${exitCode}`);
    } catch (e) {
        console.log("No exit_code found");
    }
}


async function start() {
    // This is needed to load the WASI library first (since is a Wasm module)
    await init();

    // load local wasm file
    try {
        // Read the contents of the binary file synchronously
        // load wasm demo file
        const data = fs.readFileSync('./test_files/bubblesort.wasm');

        // instantiate the wasm module
        const module: WebAssembly.Module = await WebAssembly.compile(data);
        // Use the file data as needed
        // For example, you might process the binary data here
        // const module = await WebAssembly.instantiate(data);
        // Instantiate the WASI module
        await run(module);
    } catch (error) {
        console.error('Error reading the file:', error.message);
    }



}



start();