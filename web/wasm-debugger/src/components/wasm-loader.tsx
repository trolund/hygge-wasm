import { useState, useEffect } from 'react';
import {fromEvent} from 'file-selector';


export const WasmLoader = () => {
  const [wasmResult, setWasmResult] = useState(null);
  const [file, setFile] = useState("");

  const setup = () => {
    document.addEventListener('drop', async evt => {
        evt.preventDefault();
        const files = await fromEvent(evt);

        const fileNames = files.map((f: any) => f.name);

        setFile(fileNames[0]);
        console.log(files);
        });
    }

const selectFile = async () => {
    // Open file picker
    const handles = await (window as any).showOpenFilePicker({multiple: true});
    // Get the files
    const files = await fromEvent(handles);

    // map to an array of file names
    const fileNames = files.map((f: any) => f.name);

    setFile(fileNames[0]);

    console.log(files);
    }

  useEffect(() => {
    setup()
    const loadWasm = async () => {
      
        fetch("test.wasm")
        .then((response) => response.arrayBuffer())
        .then((bytes) => WebAssembly.instantiate(bytes))
        .then((results) => {
            setWasmResult((results.instance.exports as any).main());
        });
    };
    loadWasm();
  }, []);

  return <>
    <div><button onClick={selectFile}>Select file</button><input name='file-name' placeholder='file' value={file}></input></div>
    <div>WebAssembly Result: {wasmResult}, {wasmResult == 0 ? <p>✅</p> : <p>❌</p>}</div>
  </>;
};
