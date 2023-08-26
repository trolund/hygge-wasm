(module
  (func $fun_f (param $x1 i32) (param $x2 i32) (param $x3 i32) (param $x4 i32) (param $x5 i32) (param $x6 i32) (param $x7 i32) (param $x8 i32) (result i32)  ;; function fun_f
    ;; local variables declarations:
 (local $var_v1 i32)
 (local $var_v2 i32)
 (local $var_v3 i32)
 (local $var_v4 i32)
 (local $var_v5 i32)
 (local $var_v6 i32)
 (local $var_v7 i32)
 (local $var_v8 i32)
 
    i32.const 2 ;; push 2 on stack
    local.set $var_v1 ;; set local var
    i32.const 3 ;; push 3 on stack
    local.set $var_v2 ;; set local var
    i32.const 4 ;; push 4 on stack
    local.set $var_v3 ;; set local var
    i32.const 5 ;; push 5 on stack
    local.set $var_v4 ;; set local var
    i32.const 6 ;; push 6 on stack
    local.set $var_v5 ;; set local var
    i32.const 7 ;; push 7 on stack
    local.set $var_v6 ;; set local var
    i32.const 8 ;; push 8 on stack
    local.set $var_v7 ;; set local var
    i32.const 9 ;; push 9 on stack
    local.set $var_v8 ;; set local var
    local.get $x1
    local.get $var_v1
    i32.mul
    local.get $x2
    local.get $var_v2
    i32.mul
    i32.add
    local.get $x3
    local.get $var_v3
    i32.mul
    i32.add
    local.get $x4
    local.get $var_v4
    i32.mul
    i32.add
    local.get $x5
    local.get $var_v5
    i32.mul
    i32.add
    local.get $x6
    local.get $var_v6
    i32.mul
    i32.add
    local.get $x7
    local.get $var_v7
    i32.mul
    i32.add
    local.get $x8
    local.get $var_v8
    i32.mul
    i32.add
  )
  (func $main  (result i32)  ;; entry point of program (main function)
    ;; local variables declarations:
 (local $var_result0 i32)
 (local $var_result1 i32)
 (local $var_v1 i32)
 (local $var_v1_0 i32)
 (local $var_v2 i32)
 (local $var_v2_1 i32)
 (local $var_v3 i32)
 (local $var_v3_2 i32)
 (local $var_v4 i32)
 (local $var_v4_3 i32)
 (local $var_v5 i32)
 (local $var_v5_4 i32)
 (local $var_v6 i32)
 (local $var_v6_5 i32)
 (local $var_v7 i32)
 (local $var_v7_6 i32)
 (local $var_v8 i32)
 (local $var_v8_7 i32)
 
    ;; execution start here:
    i32.const 1 ;; push 1 on stack
    i32.const 1 ;; push 1 on stack
    i32.const 1 ;; push 1 on stack
    i32.const 1 ;; push 1 on stack
    i32.const 1 ;; push 1 on stack
    i32.const 1 ;; push 1 on stack
    i32.const 1 ;; push 1 on stack
    i32.const 1 ;; push 1 on stack
    call $fun_f ;; call function fun_f
    local.set $var_result0 ;; set local var
    i32.const 1 ;; push 1 on stack
    local.set $var_v1_0 ;; set local var
    i32.const 2 ;; push 2 on stack
    local.set $var_v2_1 ;; set local var
    i32.const 3 ;; push 3 on stack
    local.set $var_v3_2 ;; set local var
    i32.const 4 ;; push 4 on stack
    local.set $var_v4_3 ;; set local var
    i32.const 5 ;; push 5 on stack
    local.set $var_v5_4 ;; set local var
    i32.const 6 ;; push 6 on stack
    local.set $var_v6_5 ;; set local var
    i32.const 7 ;; push 7 on stack
    local.set $var_v7_6 ;; set local var
    i32.const 8 ;; push 8 on stack
    local.set $var_v8_7 ;; set local var
    local.get $var_v1_0
    local.get $var_v2_1
    local.get $var_v3_2
    local.get $var_v4_3
    local.get $var_v5_4
    local.get $var_v6_5
    local.get $var_v7_6
    local.get $var_v8_7
    call $fun_f ;; call function fun_f
    local.set $var_result1 ;; set local var
    local.get $var_result0
    i32.const 44 ;; push 44 on stack
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
    local.get $var_result1
    i32.const 240 ;; push 240 on stack
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