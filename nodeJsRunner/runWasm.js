const fs = require('fs');
const util = require('util');
const readFile = util.promisify(fs.readFile);

async function runWasm() {
  // Read the Wasm file
  const wasmBuffer = await readFile('./test_files/test.wasm');

  // Create a WebAssembly module
  const wasmModule = new WebAssembly.Module(wasmBuffer);

  // Create an instance of the module
  const wasmInstance = new WebAssembly.Instance(wasmModule);

  // Call the exported function
  const result = wasmInstance.exports._start();
  console.log('Result:', result);
}

runWasm();
