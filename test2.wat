(module
  (import "env" "writeInt" (func $writeInt (param i32) ))
  (func $main  (result i32) ;; entry point of program (main function) 
    ;; execution start here:
    (local $var_z_0 i32) ;; delcare local var $var_z_0
    i32.const 23 ;; push 23 on stack
    local.set $var_z_0 ;; set local var
    local.get $var_z_0
    call $writeInt ;; call host function
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (export "main" (func $main))
)