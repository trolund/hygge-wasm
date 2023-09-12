(module
  (import "env" "writeS" (func $writeS (param i32) (param i32)  
))
  (memory (export "memory") 1)
  (data (i32.const 0) "hej2")
  (data (i32.const 40) "hej")
  (func $main  (result i32)  ;; entry point of program (main function)
    ;; local variables declarations:
    (local $var_arr i32)
 
    ;; execution start here:
    i32.const 0 ;; offset in memory
    i32.const 32 ;; size in bytes
    call $writeS ;; call host function
    ;; Start of let
    ;; start of struct contructor
    i32.const 32 ;; push field address to stack at end
    ;; init field length
    i32.const 2 ;; push 2 on stack
    i32.const 2 ;; push 2 on stack
    i32.add
    i32.store ;; store field in memory
    i32.const 36 ;; push field address to stack at end
    ;; init field data
    i32.const 40 ;; push 40 on stack
    i32.const 2 ;; push 2 on stack
    i32.add
    i32.store ;; store field in memory
    i32.const 32 ;; push struct address to stack
    ;; end of struct contructor
    local.set $var_arr ;; set local var
    i32.const 40 ;; offset in memory
    i32.const 24 ;; size in bytes
    call $writeS ;; call host function
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (export "main" (func $main))
)