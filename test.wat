(module
  (func $main  (result i32)  ;; entry point of program (main function)
    ;; local variables declarations:
  
    ;; execution start here:
    i32.const 1 ;; push 1 on stack
    i32.const 2 ;; push 2 on stack
    i32.rem_s
    i32.const 1 ;; push 1 on stack
    i32.eq
    i32.const 42 ;; push 42 on stack
    i32.const 5 ;; push 5 on stack
    i32.rem_s
    i32.const 2 ;; push 2 on stack
    i32.eq
    i32.and
    (if 
     (then
      nop ;; do nothing - if all correct

     )
     (else
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
    )
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (export "main" (func $main))
)