(module
  (func $main  (result i32)  ;; entry point of program (main function)
    ;; local variables declarations:
 (local $var_x f32)
 (local $var_y f32)
 (local $var_z f32)
 
    ;; execution start here:
    f32.const 1.000000
    local.set $var_x ;; set local var
    f32.const 2.000000
    local.set $var_y ;; set local var
    f32.const 3.000000
    local.set $var_z ;; set local var
    local.get $var_x
    local.get $var_y
    f32.add
    local.get $var_z
    f32.add
    local.set $var_z ;; set local var
    local.get $var_z ;; get local var
    local.set $var_y ;; set local var
    local.get $var_y ;; get local var
    local.set $var_x ;; set local var
    local.get $var_x
    local.get $var_y
    f32.eq
    (if 
     (then
      nop ;; do nothing - if all correct

     )
     (else
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
    )
    local.get $var_y
    local.get $var_z
    f32.eq
    (if 
     (then
      nop ;; do nothing - if all correct

     )
     (else
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
    )
    local.get $var_z
    f32.const 1.000000
    f32.const 2.000000
    f32.add
    f32.const 3.000000
    f32.add
    f32.eq
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