(module
  (func $main  (result i32)  ;; entry point of program (main function)
    ;; local variables declarations:
    (local $var_a i32)
    (local $var_b i32)
 
    ;; execution start here:
    i32.const 5 ;; push 5 on stack
    local.set $var_a ;; set local var
    ;; Start PreIncr
    local.get $var_a
    i32.const 1
    i32.add
    local.set $var_a
    local.get $var_a
    ;; End PreIncr
    local.set $var_b ;; set local var
    local.get $var_a
    i32.const 6 ;; push 6 on stack
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
    local.get $var_b
    i32.const 6 ;; push 6 on stack
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