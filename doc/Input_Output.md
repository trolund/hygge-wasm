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


## Write to console with WASI

```wat
(module
  (type $write_type (func (param i32 i32 i32 i32) (result i32)))
  (import "wasi_snapshot_preview1" "fd_write" (func $fd_write (type $write_type)))
  (memory (export "memory") 1)
  (data (i32.const 8) "Hello, WASI!\n")

  (func $main (result i32)
    (i32.store (i32.const 0) (i32.const 8))  ;; iov.iov_base - This is a pointer to the start of the 'hello world\n' string
    (i32.store (i32.const 4) (i32.const 13))  ;; iov.iov_len - The length of the 'hello world\n' string
    ;; Prepare parameters for fd_write
    i32.const 1         ;; File descriptor (1 represents stdout)
    i32.const 0         ;; Pointer to the data to be written
    i32.const 1         ;; Length of the data
    i32.const 20        ;; Pointer to store the number of bytes written (not used in this example)

    ;; Call fd_write
    call $fd_write
  )

  (export "_start" (func $main))
)
```

## Read to console with WASI

```wat
(module
  (import "wasi_snapshot_preview1" "fd_read" (func $fd_read (param i32 i32 i32 i32) (result i32)))
  (memory (export "memory") 1)
  (data (i32.const 8) "Hello, WASI!\n")

  (func $main (result i32)
    (i32.store (i32.const 0) (i32.const 8))  ;; iov.iov_base - This is a pointer to the start of the 'hello world\n' string
    (i32.store (i32.const 4) (i32.const 13))  ;; iov.iov_len - The length of the 'hello world\n' string
    
    (call $fd_read
      (local.get $stdin_fd)
      (local.get $iov_ptr)
      (i32.const 1)  ;; number of iovecs
      (local.get $nread_ptr)
    )
  )

  (export "_start" (func $main))
)
```