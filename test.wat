(module
  (func $fun_f (param $x i32) (result i32)  ;; function fun_f
 
    local.get $x
    i32.const 42 ;; push 42 on stack
    i32.lt_s
  )
  (func $fun_g (param $b i32) (result i32)  ;; function fun_g
 
    local.get $b
    (if  (result i32)
     (then
      i32.const 42 ;; push 42 on stack

     )
     (else
      i32.const 1 ;; push 1 on stack

     )
    )
  )
  (func $fun_h (param $y i32) (result i32)  ;; function fun_h
 
    local.get $y
    call $fun_f ;; call function fun_f
    (if  (result i32)
     (then
      local.get $y
      call $fun_f ;; call function fun_f
      call $fun_g ;; call function fun_g

     )
     (else
      i32.const 0
      call $fun_g ;; call function fun_g

     )
    )
  )
  (func $main  (result i32)  ;; entry point of program (main function)
 
    ;; execution start here:
    i32.const 1 ;; push 1 on stack
    call $fun_h ;; call function fun_h
    i32.const 42 ;; push 42 on stack
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
    i32.const 42 ;; push 42 on stack
    call $fun_h ;; call function fun_h
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