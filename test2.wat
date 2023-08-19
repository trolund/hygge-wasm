(module
  (import "env" "writeS" (func $writeS (param i32) (param i32) ))
  (data (i32.const 52) "Wow 2 strings!")
  (data (i32.const 0) "Hello, World! - Welcome to the world of WebAssembly!")
  (memory (export "memory") 1)
  (func $main  (result i32) ;; main function 
    i32.const 0
    i32.const 52
    call $writeS
    i32.const 52
    i32.const 66
    call $writeS
    i32.const 0
    return
  )
  (export "main" (func $main))
)