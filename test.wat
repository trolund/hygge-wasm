(module
  (import "env" "writeS" (func $writeS (param i32) (param i32) 
))
  (memory (export "memory") 1)
  (data (i32.const 0) "\08\00\00\00\24\00\00\00")
  (data (i32.const 8) "hygge println test")
  (data (i32.const 44) "\34\00\00\00\20\00\00\00")
  (data (i32.const 52) "hygge print test")
  (global $exit_code (mut i32) i32.const 0)
  (global $heap_base i32 i32.const 84)
  (global $var_s (mut i32) i32.const 0)
  (global $var_s2 (mut i32) i32.const 0)
  (func $_start  (result i32) ;; entry point of program (main function)
 
    ;; execution start here:
    ;; Start of let
    i32.const 0 ;; leave pointer to string on stack
    global.set $var_s ;; set local var, have been hoisted
    global.get $var_s ;; get local var: var_s, have been hoisted
    i32.load ;; Load string pointer
    global.get $var_s ;; get local var: var_s, have been hoisted
    i32.const 4 ;; length offset
    i32.add ;; add offset to pointer
    i32.load ;; Load string length
    call $writeS ;; call host function
    ;; Start of let
    i32.const 44 ;; leave pointer to string on stack
    global.set $var_s2 ;; set local var, have been hoisted
    global.get $var_s2 ;; get local var: var_s2, have been hoisted
    i32.load ;; Load string pointer
    global.get $var_s2 ;; get local var: var_s2, have been hoisted
    i32.const 4 ;; length offset
    i32.add ;; add offset to pointer
    i32.load ;; Load string length
    call $writeS ;; call host function
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)