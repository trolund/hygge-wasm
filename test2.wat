(module
  (import "env" "writeS" (func $writeS (param i32) (param i32) ))
  (data (i32.const 264) "6 strings? - please stop!")
  (data (i32.const 220) "5 strings? - too easy!")
  (data (i32.const 176) "4 strings? - too easy!")
  (data (i32.const 132) "3 strings? - too easy!")
  (data (i32.const 104) "Wow 2 strings!")
  (data (i32.const 0) "Hello, World! - Welcome to the world of WebAssembly!")
  (memory (export "memory") 1)
  (func $main  (result i32) ;; Entry point of program (main function)) 
    ;; Execution start here:
    i32.const 0
    i32.const 104
    call $writeS
    i32.const 104
    i32.const 28
    call $writeS
    i32.const 132
    i32.const 44
    call $writeS
    i32.const 176
    i32.const 44
    call $writeS
    i32.const 220
    i32.const 44
    call $writeS
    i32.const 264
    i32.const 50
    call $writeS
    i32.const 0
    return
  )
  (export "main" (func $main))
)