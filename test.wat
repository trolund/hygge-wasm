(module
  (func $main  (result i32)  ;; entry point of program (main function)
    ;; local variables declarations:
 (local $var_x i32)
 (local $var_x_0 i32)
 
    ;; execution start here:
    i32.const 0 ;; push 0 on stack
    local.set $var_x ;; set local var
    i32.const 41 ;; push 41 on stack
    local.set $var_x_0 ;; set local var
    i32.const 3 ;; push 3 on stack
    local.get $var_x_0
    i32.lt_s
    (if  (result i32)
     (then
      i32.const 1

     )
     (else
      i32.const 0

     )
    )
    (if 
     (then
      nop ;; do nothing - if all correct

     )
     (else
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
    )
    local.get $var_x
    i32.const 3 ;; push 3 on stack
    i32.lt_s
    (if  (result i32)
     (then
      i32.const 1

     )
     (else
      i32.const 0

     )
    )
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