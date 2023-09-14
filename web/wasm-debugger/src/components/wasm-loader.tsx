import { useState } from "react";
import styles from './wasm-loader.module.css';
import { useFilePicker } from 'use-file-picker';
import { FiFileText, FiChevronRight } from "react-icons/fi";
import { WASI, init } from "@wasmer/wasi";
import { Buffer } from 'buffer';

// @ts-ignore
window.Buffer = Buffer;

type exportValue = {
  kind: string;
  name: string;
}

export const WasmLoader = () => {

  const [msg, setMsg] = useState("");
  const [isRunning, setIsRunning] = useState(false);
  const [wasmResult, setWasmResult] = useState<number | null>(null);
  // set bytes 
  const [bytes, setBytes] = useState(null);
  const [wasmInstance, setWasmInstance] = useState<WebAssembly.Module | null>(null);
  // is run disabled
  const [isRunDisabled, setIsRunDisabled] = useState(true);
  // stdout
  const [stdout, setStdout] = useState("");

  const [openFileSelector, { loading }] = useFilePicker({
    accept: ['.wasm'],
    readAs: "ArrayBuffer",
    multiple: false,
    limitFilesConfig: { max: 1 },
    onFilesSelected: async (file) => {
      setWasmResult(null);
      setStdout("");
      setIsRunDisabled(false);
      // get the first and only file
      const wasmFile = file.filesContent[0];
      // get the bytes
      const bytes = wasmFile.content;
      // instantiate the wasm module
      setBytes(bytes);
      const module = await WebAssembly.compile(bytes);
      setWasmInstance(module);

      const exports = WebAssembly.Module.exports(module);

      const s = exports.find((e: exportValue) => {
        if (e.name == "_start" && e.kind == "function") {
          return true;
        }
        return false;
      });

      if (s) {
        console.log("Found _start function");
        // setMsg("Found _start function ✅");
        setIsRunDisabled(false);
      } else {
        console.log("No _start function found");
        setMsg("No _start function found ❌");
        setIsRunDisabled(true);
      }
    },
    onFilesRejected: ({ errors }) => {
      // this callback is called when there were validation errors
      console.log('File rejected', errors);
      setMsg("File rejected: " + errors);
      setIsRunDisabled(true);
    },
    onFilesSuccessfulySelected: ({ plainFiles, filesContent }) => {
      // this callback is called when there were no validation errors
      console.log('File selected', plainFiles[0].name);
      setMsg("File selected: " + plainFiles[0].name + " ✅");
      setIsRunDisabled(false);
    },
  });

  let memory: WebAssembly.Memory = new WebAssembly.Memory({ initial: 1 });

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

  const run = async () => {
    console.log("🏃‍♂️ Running...");
    await init();

    let wasi = new WASI({
      env: {},
      args: [],
    });

    setIsRunning(true);

    // Instantiate the WASI module
    await wasi.instantiate(wasmInstance, {});

    // Run the start function
    let exitCode = wasi.start();
    // Get the stdout of the WASI module
    let stdout = wasi.getStdoutString();

    setStdout(stdout);

    // This should print "hello world (exit code: 0)"
    console.log(`${stdout}(exit code: ${exitCode})`);
    setWasmResult(exitCode);
    setIsRunning(false);
    wasi.free();

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
      {loading && <div>⏳Loading...</div>}
      {isRunning && <div>🏃‍♂️Running...</div>}
      <div>
        <button className={styles.button} onClick={openFileSelector}><FiFileText className={styles.icon} /> Select file</button>
        <button disabled={isRunDisabled} className={styles.button} onClick={run}><FiChevronRight className={styles.icon} /> Run</button>
      </div>
      <div>
        <div>{msg}</div>
      </div>
      {status(wasmResult ?? -1)}

      {stdout && <div className={styles.stdout}>
        <div>Stdout:</div>
        <div>{stdout}</div>
      </div>}
      <footer className={styles.footer}>
        <div>Created by Troels Lund (trolund@gmail.com)</div>
      </footer>
    </>
  );
};


