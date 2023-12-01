"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
console.log('Node.js V8 - Hygge Runner');
const node_fs_1 = __importDefault(require("node:fs"));
const wasi_1 = require("@wasmer/wasi");
const MemoryAllocator_1 = require("./MemoryAllocator");
const ImportService_1 = require("./ImportService");
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
    const memoryAllocator = new MemoryAllocator_1.MemoryAllocator(isDebug);
    const fs = new wasi_1.MemFS();
    let wasi = new wasi_1.WASI({
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
    const combinedImports = Object.assign(Object.assign({}, wasiImports), (0, ImportService_1.getImports)(memoryAllocator, isDebug));
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
        yield (0, wasi_1.init)();
        try {
            const data = node_fs_1.default.readFileSync('./test_files/test.wasm');
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