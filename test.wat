(module
  (type $_=>_i32 (;0;) (func  (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) i32.const 0)
  (global $fun_makeCounter*ptr (;1;) (mut i32) i32.const 0)
  (global $fun_makeCounter/anonymous*ptr (;2;) (mut i32) i32.const 4)
  (global $heap_base (;3;) i32 i32.const 8)
  (global $var_c1 (;4;) (mut i32) i32.const 0)
  (table $func_table (;0;) 2 funcref)
  (elem (i32.const 0) (;0;) $fun_makeCounter)
  (elem (i32.const 1) (;1;) $fun_makeCounter/anonymous)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_makeCounter*ptr ;; get global var: fun_makeCounter*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $fun_makeCounter*ptr ;; get global var: fun_makeCounter*ptr
    i32.load ;; load table index
    call_indirect (type $_=>_i32) ;; call function
    ;; end of application
    global.set $var_c1 ;; set local var, have been hoisted
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load ;; load table index
    call_indirect (type $_=>_i32) ;; call function
    ;; end of application
    i32.const 10 ;; push 10 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_makeCounter (;1;)  (result i32) 
  )
  (func $fun_makeCounter/anonymous (;2;)  (result i32) 
    i32.const 10 ;; push 10 on stack
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)