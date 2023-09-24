(module
  (import "env" "writeS" (func $writeS (param i32) (param i32)  
))
  (memory (export "memory") 1)
  (data (i32.const 32) "hygge")
  (global $heap_base i32  i32.const 18
)  (func $_start  (result i32)  ;; entry point of program (main function)
    ;; local variables declarations:
    (local $var_s i32)
 
    ;; execution start here:
    ;; Start of let
    i32.const 0 ;; offset in memory
    i32.const 32 ;; data pointer to store
    i32.store ;; store size in bytes
    i32.const 4 ;; offset in memory
    i32.const 10 ;; length to store
    i32.store ;; store data pointer
    i32.const 0 ;; leave pointer to string on stack
    local.set $var_s ;; set local var
    local.get $var_s
    i32.load ;; Load string pointer
    local.get $var_s
    i32.const 4 ;; length offset
    i32.add ;; add offset to pointer
    i32.load ;; Load string length
    call $writeS ;; call host function
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)