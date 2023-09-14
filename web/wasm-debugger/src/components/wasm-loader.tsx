import { useEffect, useState } from "react";
import styles from './wasm-loader.module.css';
import { useFilePicker } from 'use-file-picker';
import { FiFileText, FiChevronRight } from "react-icons/fi";
import { start } from "../helloworld";
import { WASI, init } from "@wasmer/wasi";
import { buffer } from "stream/consumers";
import { log } from "console";
import { Buffer } from 'buffer';

// @ts-ignore
window.Buffer = Buffer;

export const WasmLoader = () => {
  
  const [msg, setMsg] = useState("");
  const [isRunning, setIsRunning] = useState(false);
  const [wasmResult, setWasmResult] = useState(null);
  // set bytes 
  const [bytes, setBytes] = useState(null);
  const [wasmInstance, setWasmInstance] = useState<WebAssembly.Instance | null>(null);
  
  const [openFileSelector, { loading }] = useFilePicker({
    accept: ['.wasm'],
    readAs: "ArrayBuffer",
    multiple: false,
    limitFilesConfig: { max: 1 },
    onFilesSelected: (file) => {
      setWasmResult(null);
      // get the first and only file
      const wasmFile = file.filesContent[0];
      // get the bytes
      const bytes = wasmFile.content;
      // instantiate the wasm module
      setBytes(bytes);
    },
    onFilesRejected: ({ errors }) => {
      // this callback is called when there were validation errors
      console.log('File rejected', errors);
      setMsg("File rejected: " + errors);
    },
    onFilesSuccessfulySelected: ({ plainFiles, filesContent }) => {
      // this callback is called when there were no validation errors
      console.log('File selected', plainFiles[0].name);
      setMsg("File selected: " + plainFiles[0].name + " ✅");
    },
  });

  let memory: WebAssembly.Memory = new WebAssembly.Memory({initial: 1});

  const imports = {
    env: {
      abort(_msg: any, _file: any, line: any, column: any) {
        console.error("abort called at index.ts:" + line + ":" + column);
      },
      writeS(address: number, length: number) {
        // Get `memory[address..address + length]`.
        const mem = new Uint8Array(
          memory.buffer
        );
        
        const data = mem.subarray(
          address,
          address + length
        );
    
        // Convert it into a string.
        const decoder = new TextDecoder("utf-8");
        const text = decoder.decode(data);
        console.log(text);
      }
  }
}

  const run = async (bytes: Buffer) => {
    console.log("Running...");
    // print the bytes
    console.log("buffer", bytes);
    await init();
    
    let wasi = new WASI({
      env: {},
      args: [],
    });



    function fetchArrayBuffer(bytes: Buffer) {
      return new Promise((resolve, reject) => {
        // Simulate an asynchronous operation that produces an ArrayBuffer
          try {
            const response = new Response(bytes, {
              status: 200, // Status code
              statusText: 'OK', // Status text
              headers: { 'Content-Type': 'application/wasm' }, // Content-Type header
            });
            resolve(response); // Resolve the Promise with the custom Response
          } catch (error) {
            reject(error); // Reject the Promise if there's an error
          }
      });
    }

    const module = await WebAssembly.compileStreaming(fetchArrayBuffer(bytes) as any);
    // Instantiate the WASI module
    await wasi.instantiate(module, {});
    
    // Run the start function
    let exitCode = wasi.start();
    let stdout = wasi.getStdoutString();
    
     // This should print "hello world (exit code: 0)"
    console.log(`${stdout}(exit code: ${exitCode})`);
    // const inst = wasi.instantiate(module.instance, {});

    // // setWasmInstance(inst);

    // let exitCode = wasi.start();
    // let stdout = wasi.getStdoutString();
    // // This should print "hello world (exit code: 0)"
    // console.log(`${stdout}\n(exit code: ${exitCode})`);
  }

  const runInstance = async (instance: any) => {

    if (!instance) {
      console.log("No instance to run");
      setMsg("No instance to run - start by selecting a .wasm file");
      return;
    }
    setIsRunning(true);

    // const res = instance.exports.main();
    // setWasmResult(res);
    // console.log("Result:", res);
    
    // // get the memory
    // memory = instance.exports.memory;

    // Instantiate the WASI module


    setIsRunning(false);
  }

  const status = (result: number) => {
    if (result == 0) {
    return <div>exit code: {result}, Success✅</div>
    }
    else if (result == -1) {
      return <></>
    }

    return <div>exit code: {result}, Failure❌</div>
    }

  return (
    <>
    {loading && <div>Loading...</div>}
    {isRunning && <div>Running...</div>}
    <div>
      <button className={styles.button} onClick={openFileSelector}><FiFileText className={styles.icon} /> Select file</button>
      <button className={styles.button} onClick={() => bytes ? run(bytes) : {}}><FiChevronRight className={styles.icon} /> Run</button>
    </div>
    <div>
      <div>{msg}</div>
    </div>
    {status(wasmResult ?? -1)}
    </>
  );
};


