# Input and output system 

All interaction between host and client is implemented in the function _SetupLinker_ in the class _WasmVM_.

Wasm code (io.wat):
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


generated Wasm code 18/8 2023 (io.wat):
```wat
(module
  (import "env" "writeS" (func $writeS (param i32) (param i32) ))
  (data (i32.const 0) "Hello, World!")
  (memory (export "memory") 1 2)
  (func $main  (result i32) ;; Entry point of program 
   i32.const 0
   i32.const 13
   call $writeS
   i32.const 0
   return
  )
  (export "main" (func $main))
)
```

From 

```hyg
println("Hello, World!")
```