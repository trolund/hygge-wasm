(module
  (type $fun_y_type (func  ))
  (import "env" "writeS" (func $writeS (param i32) (param i32) ))
  (memory (export "memory") 1)
  (data (i32.const 0) "\00")
  (data (i32.const 12) "hej")
  (global $heap_base i32  i32.const 18
)  (table $func_table 1 funcref)
  (elem (i32.const 0) $fun_y)
  (func $_start  (result i32) ;; entry point of program (main function)    ;; local variables declarations:
    (local $fun_y i32)
 
    ;; execution start here:
    i32.const 0 ;; pointer to function
    i32.load ;; load function pointer
    local.set $fun_y ;; set local var
    call $fun_y ;; call function fun_y
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_y   ;; function fun_y 
    i32.const 4 ;; offset in memory
    i32.const 12 ;; data pointer to store
    i32.store ;; store size in bytes
    i32.const 8 ;; offset in memory
    i32.const 6 ;; length to store
    i32.store ;; store data pointer
    i32.const 4 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 4 ;; offset in memory
    i32.const 12 ;; data pointer to store
    i32.store ;; store size in bytes
    i32.const 8 ;; offset in memory
    i32.const 6 ;; length to store
    i32.store ;; store data pointer
    i32.const 4 ;; leave pointer to string on stack
    i32.const 4 ;; length offset
    i32.add ;; add offset to pointer
    i32.load ;; Load string length
    call $writeS ;; call host function
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)