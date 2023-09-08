(module
  (memory (export "memory") 1)
  (global $Sptr (mut i32)  i32.const 0
)  (func $main  (result i32)  ;; entry point of program (main function)
 
    ;; execution start here:
    i32.const 0 ;; push field address to stack
    i32.const 42 ;; push 42 on stack
    i32.store ;; store field in memory
    i32.const 1 ;; push field address to stack
    i32.const 1
    i32.store ;; store field in memory
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (export "main" (func $main))
)