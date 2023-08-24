(module
  (func $fun_f (param $x i32) (param $y i32) (result i32)  ;; function fun_f
 
    local.get $x
    local.get $y
    i32.add
  )
  (func $main  (result i32)  ;; entry point of program (main function)
 
    ;; execution start here:
    i32.const 1 ;; push 1 on stack
    i32.const 2 ;; push 2 on stack
    call $fun_f ;; call function fun_f
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