(module
  (import "env" "writeInt" (func $writeInt (param i32)  
))
  (func $main  (result i32)  ;; entry point of program (main function)
    ;; local variables declarations:
    (local $var_s1 i32)
 
    ;; execution start here:
    i32.const 0 ;; push field address to stack
    i32.const 42 ;; push 42 on stack
    i32.store ;; store field in memory
    i32.const 1 ;; push field address to stack
    i32.const 1
    i32.store ;; store field in memory
    local.set $var_s1 ;; set local var
    local.get $var_s1
    i32.const 0 ;; push field offset to stack
    call $writeInt ;; call host function
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (export "main" (func $main))
)