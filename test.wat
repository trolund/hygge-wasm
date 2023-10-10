(module
  (type $i32_=>_i32 (func (param i32) (result i32)))
  (memory (export "memory") 1)
  (data (i32.const 0) "\00")
  (global $fun_f*ptr (mut i32) i32.const 0)
  (global $heap_base i32 i32.const 4)
  (global $var_x (mut i32) i32.const 0)
  (table $func_table 1 funcref)
  (elem (i32.const 0) $fun_f)
  (func $_start  (result i32) ;; entry point of program (main function) 
    ;; execution start here:
    ;; Start of let
    i32.const 40 ;; push 40 on stack
    global.set $var_x ;; set local var, have been hoisted
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    global.get $fun_f*ptr
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    ;; end of application
    i32.const 80 ;; push 80 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      )
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_f (param $cenv i32) (result i32) ;; function fun_f 
    i32.const 40 ;; push 40 on stack
    global.get $var_x ;; , have been hoisted
    i32.add
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)