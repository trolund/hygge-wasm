var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
console.log('Node.js V8 - Hygge Runner');
import fs from 'node:fs';
import { WASI, init, MemFS } from "@wasmer/wasi";
import { MemoryAllocator } from './MemoryAllocator';
import { getImports } from './ImportService';
const isDebug = true;
const { program } = require('commander');
program
    .option('--first')
    .option('-s, --separator <char>');
program.parse();
const options = program.opts();
const limit = options.first ? 1 : undefined;
const run = (wasmModule) => __awaiter(void 0, void 0, void 0, function* () {
    console.log("🏃‍♂️ Running...");
    const memoryAllocator = new MemoryAllocator(isDebug);
    const fs = new MemFS();
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
    }
    catch (e) {
        console.log("WASI not used.");
    }
    const combinedImports = Object.assign(Object.assign({}, wasiImports), getImports(memoryAllocator, isDebug));
    const instance = yield WebAssembly.instantiate(wasmModule, combinedImports);
    console.log("👍 Instantiated!");
    let growMemory = (n) => {
        instance.exports.memory.grow(n);
    };
    let heap_base;
    try {
        heap_base = instance.exports.heap_base_ptr.value;
    }
    catch (e) {
        console.log("No heap_base_ptr found");
        heap_base = 0;
    }
    memoryAllocator.set(heap_base);
    memoryAllocator.memory = instance.exports.memory;
    memoryAllocator.setGrow(growMemory);
    if (wasiUsed) {
        try {
            let exitCode = wasi.start(instance);
            let stdout = wasi.getStdoutString();
            console.log(`${stdout}(exit code: ${exitCode})`, 'DodgerBlue');
        }
        catch (e) {
            console.error(e);
        }
        finally {
            wasi.free();
        }
    }
    else {
        try {
            const start = instance.exports["_start"];
            const res = start();
            console.log("result:" + res);
        }
        catch (e) {
            console.error("Program failed");
        }
        finally {
            handleExitCode(instance);
        }
    }
});
const handleExitCode = (instance) => {
    try {
        let exitCode = instance.exports.exit_code.value;
        console.log(`exit code: ${exitCode}`);
    }
    catch (e) {
        console.log("No exit_code found");
    }
};
function start() {
    return __awaiter(this, void 0, void 0, function* () {
        yield init();
        try {
            const data = fs.readFileSync('./test_files/bubblesort.wasm');
            const module = yield WebAssembly.compile(data);
            yield run(module);
        }
        catch (error) {
            console.error('Error reading the file:', error.message);
        }
    });
}
start();
//# sourceMappingURL=index.js.map