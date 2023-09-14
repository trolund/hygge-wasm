import { useEffect, useState } from "react";
import styles from './wasm-loader.module.css';
import { useFilePicker } from 'use-file-picker';
import { FiFileText, FiChevronRight } from "react-icons/fi";
import { start } from "../helloworld";

export const WasmLoader = () => {
  
  const [msg, setMsg] = useState("");
  const [isRunning, setIsRunning] = useState(false);
  const [wasmResult, setWasmResult] = useState(null);
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
      createModule(bytes);
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

  const createModule = (bytes: any) => {
    WebAssembly.instantiate(bytes, imports)
    .then(async (results: WebAssembly.WebAssemblyInstantiatedSource) => {
        const instance: WebAssembly.Instance = results.instance;
        setWasmInstance(instance);  
        memory = instance.exports.memory as any;       
        


        // runInstance(instance);        
      })
      .catch((error) => {
        console.error("Error:", error);
        setMsg("Error: " + error);
      });
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

  const buttonClick = async () => {
    const moduleBytes = await fetch(
      "https://cdn.deno.land/wasm/versions/v1.0.2/raw/tests/demo.wasm",
    );
    start(moduleBytes);
  };

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
      <button onClick={buttonClick}></button>
      <button className={styles.button} onClick={openFileSelector}><FiFileText className={styles.icon} /> Select file</button>
      <button className={styles.button} onClick={() => runInstance(wasmInstance)}><FiChevronRight className={styles.icon} /> Run</button>
    </div>
    <div>
      <div>{msg}</div>
    </div>
    {status(wasmResult ?? -1)}
    </>
  );
};


