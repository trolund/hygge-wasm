(module
  (func $main  (result i32)  ;; entry point of program (main function)
 
    ;; execution start here:
    ;; Max/min start
    i32.const 12 ;; push 12 on stack
    i32.const 10 ;; push 10 on stack
    i32.const 12 ;; push 12 on stack
    i32.const 10 ;; push 10 on stack
    i32.gt_s
    select
    ;; Max/min end
    i32.const 12 ;; push 12 on stack
    i32.eq
    (if 
     (then
      nop ;; do nothing - if all correct

     )
     (else
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
    )
    ;; Max/min start
    i32.const 120 ;; push 120 on stack
    i32.const 1 ;; push 1 on stack
    i32.const 120 ;; push 120 on stack
    i32.const 1 ;; push 1 on stack
    i32.gt_s
    select
    ;; Max/min end
    i32.const 120 ;; push 120 on stack
    i32.eq
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