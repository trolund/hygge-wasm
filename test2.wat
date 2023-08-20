(module
  (import "env" "writeS" (func $writeS (param i32) (param i32) ))
  (data (i32.const 264) "6 strings? - please stop!")
  (data (i32.const 220) "5 strings? - too easy!")
  (data (i32.const 176) "4 strings? - too easy!")
  (data (i32.const 132) "3 strings? - too easy!")
  (data (i32.const 104) "Wow 2 strings!")
  (data (i32.const 0) "Hello, World! - Welcome to the world of WebAssembly!")
  (memory (export "memory") 1)
  (func $main  (result i32) ;; Entry point of program (main function) 
    ;; Execution start here:
    i32.const 0 ;; offset in memory
    i32.const 104 ;; size in bytes
    call $writeS ;; call host function
    i32.const 104 ;; offset in memory
    i32.const 28 ;; size in bytes
    call $writeS ;; call host function
    i32.const 132 ;; offset in memory
    i32.const 44 ;; size in bytes
    call $writeS ;; call host function
    i32.const 176 ;; offset in memory
    i32.const 44 ;; size in bytes
    call $writeS ;; call host function
    i32.const 220 ;; offset in memory
    i32.const 44 ;; size in bytes
    call $writeS ;; call host function
    i32.const 264 ;; offset in memory
    i32.const 50 ;; size in bytes
    call $writeS ;; call host function
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (export "main" (func $main))
)