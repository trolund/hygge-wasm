(module
  (func $main  (result i32) ;; entry point of program (main function) 
    ;; execution start here:
    (local $var i32) ;; delcare local var var
    i32.const 0 ;; push 0 on stack
    local.set $var ;; set local var
    (local $var_0 i32) ;; delcare local var var_0
    i32.const 42 ;; push 42 on stack
    local.set $var_0 ;; set local var
    i32.const 3 ;; push 3 on stack
    local.get $var_0
    i32.lt_s
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (export "main" (func $main))
)