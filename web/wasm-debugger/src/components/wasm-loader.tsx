import { useState, useEffect } from "react";
import { useFilePicker } from 'use-file-picker';

export const WasmLoader = () => {
  const [msg, setMsg] = useState("");
  const [wasmResult, setWasmResult] = useState(null);
  const [wasmmInstance, setWasmInstance] = useState(null);
  const [openFileSelector, { filesContent, loading }] = useFilePicker({
    accept: ['.wat', '.wasm'],
    readAs: "ArrayBuffer",
    multiple: false,
    limitFilesConfig: { max: 1 },
    onFilesSelected: (file) => {
      const wasmFile = file.filesContent[0];
      
      // get the bytes
      const bytes = wasmFile.content;

      // instantiate the wasm module
      WebAssembly.instantiate(bytes)
      .then((results: any) => {
          const instance = results.instance
          setWasmInstance(instance);          
          runInstance(instance);        
          setMsg("File selected: " + file.filesContent[0].name);
          console.log("File selected: ", file.filesContent[0].name);
        })
        .catch((error) => {
          console.error("Error:", error);
          setMsg("Error: " + error);
        });
    }
  });

  const runInstance = (instance: any) => {

    if (!instance) {
      console.log("No instance to run");
      setMsg("No instance to run - start by selecting a .wasm file");
      return;
    }

    const res = instance.exports.main();
    setWasmResult(res);

  }

  return (
    <>
    {loading && <div>Loading...</div>}
    <div>
      <button onClick={() => openFileSelector()}>Select file</button>
      <button onClick={() => runInstance(wasmmInstance)}>Run</button>
    </div>
    <div>
      <div><p>{msg}</p></div>
      <div>Exit code: {wasmResult}</div>
      {wasmResult == 0 ? <div>Success✅</div> : <div>Failure❌</div> }
    </div>
    </>
  );
};


