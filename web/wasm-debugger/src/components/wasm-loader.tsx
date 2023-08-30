import { useState, useEffect } from "react";
import { fromEvent } from "file-selector";
import { FileUploader } from "react-drag-drop-files";

export const WasmLoader = () => {
  const [wasmResult, setWasmResult] = useState(null);
  const [file, setFile] = useState<File | null>(null);

  const fileTypes = ["wat", "wasm"];

  useEffect(() => {
    const loadWasm = async () => {
      if (!file) {
        return;
      }

        fetch(file.name)
          .then((response) => response.arrayBuffer())
          .then((bytes) => WebAssembly.instantiate(bytes))
          .then((results) => {
            setWasmResult((results.instance.exports as any).main());
          });

    };
    loadWasm();
  }, [file]);

  const handleChange = (file: any) => {
    console.log(file);
    setFile(file);
  };

  return (
    <>
      <div>
        <FileUploader
          hoverTitle={"Drop here"}
          required
          multiple={false}
          label={"File to run"}
          handleChange={handleChange}
          name="file"
          types={fileTypes}
        />
      </div>
      <div>
        WebAssembly Result: {wasmResult},{" "}
        {wasmResult == 0 ? <p>✅</p> : <p>❌</p>}
      </div>
    </>
  );
};
