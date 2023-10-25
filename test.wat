(module
  (type $i32_i32_=>_i32 (;0;) (func (param i32) (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) i32.const 0)
  (global $fun_count*ptr (;1;) (mut i32) i32.const 0)
  (global $heap_base (;2;) i32 i32.const 4)
  (global $var_m (;3;) (mut i32) i32.const 0)
  (table $func_table (;0;) 1 funcref)
  (elem (i32.const 0) (;0;) $fun_count)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    i32.const 200 ;; push 200 on stack
    global.set $var_m ;; set local var, have been hoisted
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_count*ptr ;; get global var: fun_count*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 10 ;; push 10 on stack
    global.get $fun_count*ptr ;; get global var: fun_count*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    global.get $var_m ;; get local var: var_m, have been hoisted
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
  (func $fun_count (;1;) (param $cenv i32) (param $arg_curr i32) (result i32) 
    local.get $arg_curr ;; get local var: arg_curr
    global.get $var_m ;; get local var: var_m, have been hoisted
    i32.lt_s
    (if (result i32)
      (then
        ;; start of application
        ;; Load expression to be applied as a function
        global.get $fun_count*ptr ;; get global var: fun_count*ptr
        i32.load offset=4 ;; load closure environment pointer
        local.get $arg_curr ;; get local var: arg_curr
        i32.const 1 ;; push 1 on stack
        i32.add
        global.get $fun_count*ptr ;; get global var: fun_count*ptr
        i32.load ;; load table index
        call_indirect (type $i32_i32_=>_i32) ;; call function
        ;; end of application
      )
      (else
        local.get $arg_curr ;; get local var: arg_curr
      )
    )
  )
  (data (i32.const 0) "\00")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)