(module
  (func $main  (result i32)  ;; entry point of program (main function)
    ;; local variables declarations:
 (local $var_x i32)
 (local $var_y i32)
 
    ;; execution start here:
    i32.const 0 ;; push 0 on stack
    local.set $var_x ;; set local var
    i32.const 10 ;; push 10 on stack
    local.set $var_y ;; set local var
    (block $loop_exit
      (loop $loop_begin 
      local.get $var_x
      local.get $var_y
      i32.eq
      i32.eqz
      i32.eqz
      br_if $loop_exit
      local.get $var_x
      i32.const 1 ;; push 1 on stack
      i32.sub
      local.set $var_x ;; set local var
      local.get $var_x
      i32.const 2 ;; push 2 on stack
      i32.add
      local.set $var_x ;; set local var
      local.get $var_y
      i32.const 1 ;; push 1 on stack
      i32.sub
      local.set $var_y ;; set local var
      br $loop_begin

)
      nop

)
    local.get $var_x
    local.get $var_y
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
    local.get $var_x
    i32.const 5 ;; push 5 on stack
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