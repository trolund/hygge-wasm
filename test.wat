(module
  (type $i32_i32_=>_i32 (;0;) (func (param i32) (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) i32.const 0)
  (global $fun_factorial*ptr (;1;) (mut i32) i32.const 0)
  (global $heap_base (;2;) i32 i32.const 4)
  (table $func_table (;0;) 1 funcref)
  (elem (i32.const 0) (;0;) $fun_factorial)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Load expression to be applied as a function
    global.get $fun_factorial*ptr ;; get global var: fun_factorial*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 5 ;; push 5 on stack
    global.get $fun_factorial*ptr ;; get global var: fun_factorial*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    i32.const 120 ;; push 120 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_factorial (;1;) (param $cenv i32) (param $arg_n i32) (result i32) 
    local.get $arg_n ;; get local var: arg_n
    i32.const 0 ;; push 0 on stack
    i32.eq
    (if (result i32)
      (then
        i32.const 1 ;; push 1 on stack
      )
      (else
        local.get $arg_n ;; get local var: arg_n
        ;; Load expression to be applied as a function
        global.get $fun_factorial*ptr ;; get global var: fun_factorial*ptr
        i32.load offset=4 ;; load closure environment pointer
        local.get $arg_n ;; get local var: arg_n
        i32.const 1 ;; push 1 on stack
        i32.sub
        global.get $fun_factorial*ptr ;; get global var: fun_factorial*ptr
        i32.load ;; load table index
        call_indirect (type $i32_i32_=>_i32) ;; call function
        i32.mul
      )
    )
  )
  (data (i32.const 0) "\00")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)