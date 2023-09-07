(module
  (type $fun_makeCounter_type (func  (result i32)))
  (type $lambda_type (func (param i32) (result i32)))
  (table $func_table 1 funcref)
  (elem (i32.const 0) $lambda)
  (func $fun_makeCounter  (result i32)  ;; function fun_makeCounter
    ;; local variables declarations:
    (local $var_x i32)
 
    i32.const 0 ;; push 0 on stack
    local.set $var_x ;; set local var
    local.get $var_x
    call $lambda
  )
  (func $lambda (param $x i32) (result i32)  ;; function lambda
 
    local.get $x
    i32.const 1 ;; push 1 on stack
    i32.add
  )
  (func $main  (result i32)  ;; entry point of program (main function)
    ;; local variables declarations:
    (local $var_c1 i32)
    (local $var_c2 i32)
    (local $var_x i32)
 
    ;; execution start here:
    call $fun_makeCounter ;; call function fun_makeCounter
    local.set $var_c1 ;; set local var
    call $fun_makeCounter ;; call function fun_makeCounter
    local.set $var_c2 ;; set local var
    call $fun_makeCounter ;; call function fun_makeCounter
    i32.const 1 ;; push 1 on stack
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
    call $fun_makeCounter ;; call function fun_makeCounter
    i32.const 2 ;; push 2 on stack
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
    call $fun_makeCounter ;; call function fun_makeCounter
    i32.const 1 ;; push 1 on stack
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