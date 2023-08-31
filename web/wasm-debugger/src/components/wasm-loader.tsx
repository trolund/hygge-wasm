import { useState, useEffect } from "react";
import styles from './wasm-loader.module.css';
import { useFilePicker } from 'use-file-picker';
import { FiFileText, FiChevronRight } from "react-icons/fi";

export const WasmLoader = () => {
  const [msg, setMsg] = useState("");
  const [wasmResult, setWasmResult] = useState(null);
  const [wasmmInstance, setWasmInstance] = useState(null);
  const [openFileSelector, { filesContent, loading }] = useFilePicker({
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

  const createModule = (bytes: any) => {
    WebAssembly.instantiate(bytes)
    .then((results: any) => {
        const instance = results.instance
        setWasmInstance(instance);          
        // runInstance(instance);        
      })
      .catch((error) => {
        console.error("Error:", error);
        setMsg("Error: " + error);
      });
  }

  const runInstance = (instance: any) => {

    if (!instance) {
      console.log("No instance to run");
      setMsg("No instance to run - start by selecting a .wasm file");
      return;
    }

    const res = instance.exports.main();
    setWasmResult(res);
    console.log("Result:", res);
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
    <div>
      <button className={styles.button} onClick={openFileSelector}><FiFileText className={styles.icon} /> Select file</button>
      <button className={styles.button} onClick={() => runInstance(wasmmInstance)}><FiChevronRight className={styles.icon} /> Run</button>
    </div>
    <div>
      <div>{msg}</div>
    </div>
    {status(wasmResult ?? -1)}
    </>
  );
};


