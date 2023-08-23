(module
  (func $fun_f (param i32) (param i32) (result i32)  ;; function fun_f
    ;; local variables declarations:
  
  )
  (func $main  (result i32)  ;; entry point of program (main function)
    ;; local variables declarations:
  
    ;; execution start here:
    i32.const 1 ;; push 1 on stack
    i32.const 2 ;; push 2 on stack
    call_indirect 0 ;; call function
    local.set $var ;; set local var
    local.get $var
    i32.const 3 ;; push 3 on stack
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