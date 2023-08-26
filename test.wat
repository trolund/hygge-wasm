(module
  (func $fun_f (param $x i32) (param $y i32) (result i32)  ;; function fun_f
 
    local.get $x
    local.get $y
    i32.add
    i32.const 42 ;; push 42 on stack
    i32.lt_s
    (if  (result i32)
     (then
      local.get $x
      i32.const 1 ;; push 1 on stack
      i32.add
      local.get $y
      i32.const 1 ;; push 1 on stack
      i32.add
      call $fun_f ;; call function fun_f

     )
     (else
      local.get $x
      local.get $y
      i32.add

     )
    )
  )
  (func $main  (result i32)  ;; entry point of program (main function)
 
    ;; execution start here:
    i32.const 0 ;; push 0 on stack
    i32.const 0 ;; push 0 on stack
    call $fun_f ;; call function fun_f
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
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (export "main" (func $main))
)