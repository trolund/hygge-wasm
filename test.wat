(module
  (import "env" "writeInt" (func $writeInt (param i32)  
))
  (func $main  (result i32)  ;; entry point of program (main function)
    ;; local variables declarations:
    (local $var_3 i32)
    (local $var_2 i32)
    (local $var_1 i32)
    (local $var_0 i32)
    (local $var i32)
 
    ;; execution start here:
    i32.const 23 ;; push 23 on stack
    local.set $var ;; set local var
    i32.const 24 ;; push 24 on stack
    local.set $var_0 ;; set local var
    i32.const 25 ;; push 25 on stack
    local.set $var_1 ;; set local var
    i32.const 26 ;; push 26 on stack
    local.set $var_2 ;; set local var
    i32.const 27 ;; push 27 on stack
    local.set $var_3 ;; set local var
    local.get $var
    call $writeInt ;; call host function
    local.get $var_0
    call $writeInt ;; call host function
    local.get $var_1
    call $writeInt ;; call host function
    local.get $var_2
    local.get $var
    call $writeInt ;; call host function
    local.get $var_0
    call $writeInt ;; call host function
    local.get $var_1
    call $writeInt ;; call host function
    local.get $var_3
    i32.add
    call $writeInt ;; call host function
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (export "main" (func $main))
)