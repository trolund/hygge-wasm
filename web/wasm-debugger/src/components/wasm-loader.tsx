import { useState, useEffect } from "react";
import { useFilePicker } from 'use-file-picker';

export const WasmLoader = () => {
  const [wasmResult, setWasmResult] = useState(null);
  const [openFileSelector, { filesContent, loading }] = useFilePicker({
    accept: ['.wat', '.wasm'],
    readAs: "ArrayBuffer",
  });

  useEffect(() => {
    if (filesContent.length) {
        const file = filesContent[0];

        console.log(file);

        const bytes = file.content;

        WebAssembly.instantiate(bytes)
        .then((results: any) => {
            const instance = results.instance;
            
            // Call the "main" function
            const res = instance.exports.main();

            console.log(res);
            
            // You can do something after calling the function
          })
          .catch((error) => {
            console.error("Error:", error);
          });
    }
}, [filesContent]);

  if (loading) {
    return <div>Loading...</div>;
  }

  const run = async (file: string) => {



    // WebAssembly.instantiateStreaming(file).then(
    //     (obj) => {
    //       // Call an exported function:
    //       const res = (obj.instance.exports as any).main();
      
    //       // or access the buffer contents of an exported memory:
    //       // const i32 = new Uint32Array(obj.instance.exports.memory.buffer);
      
    //       // or access the elements of an exported table:
    //       //const table = obj.instance.exports.table;
    //       // console.log(table.get(0)());
    //     },
    //   );
  }


  return (
    <div>
      <button onClick={() => openFileSelector()}>Select files </button>
      <br />
      {/* {filesContent.map((file, index) => (
        <div>
          <h2>{file.name}</h2>
          <div key={index}>{file.content}</div>
          <br />
        </div>
      ))} */}
    </div>
  );
};


