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