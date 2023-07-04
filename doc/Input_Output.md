# Input and output system 

All interaction between host and client is implemented in the function _SetupLinker_ in the class _WasmVM_.

Wasm code:
```wat
(module
  (import "env" "read" (func $read (result externref)))
  (import "env" "write" (func $write (param externref)))
  (memory (export "memory") 1)

(func (export "_start") (result i32)
    ;; Read user input
    call $read     
    ;; Write the input to the console
    call $write    
    ;; load 42 onto the stack
    i32.const 42
    ;; return the second value (42)
    return
  )
)
```

Console output:
```
io.wat
2
2
return value 42
```