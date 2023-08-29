(module
  (import "env" "writeInt" (func $writeInt (param i32)  
))
  (func $fun_fb (param $i i32) (result i32)  ;; function fun_fb
    ;; local variables declarations:
 (local $var_by3 i32)
 (local $var_by5 i32)
 
    local.get $i
    i32.const 3 ;; push 3 on stack
    i32.rem_s
    i32.const 0 ;; push 0 on stack
    i32.eq
    local.set $var_by3 ;; set local var
    local.get $i
    i32.const 5 ;; push 5 on stack
    i32.rem_s
    i32.const 0 ;; push 0 on stack
    i32.eq
    local.set $var_by5 ;; set local var
    local.get $var_by3
    (if  (result i32)
     (then
      local.get $var_by5
      (if  (result i32)
     (then
      i32.const 10 ;; push 10 on stack

     )
     (else
      i32.const 12 ;; push 12 on stack

     )
    )

     )
     (else
      local.get $var_by5
      (if  (result i32)
     (then
      i32.const 13 ;; push 13 on stack

     )
     (else
      i32.const 14 ;; push 14 on stack

     )
    )

     )
    )
  )
  (func $main  (result i32)  ;; entry point of program (main function)
    ;; local variables declarations:
 (local $var_by3 i32)
 (local $var_by5 i32)
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
      i32.lt_s
      i32.eqz
      br_if $loop_exit
      local.get $var_x
      call $fun_fb ;; call function fun_fb
      call $writeInt ;; call host function
      local.get $var_x
      i32.const 1 ;; push 1 on stack
      i32.add
      local.set $var_x ;; set local var
      br $loop_begin

)
      nop

)
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (export "main" (func $main))
)