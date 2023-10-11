(module
  (type $i32_i32_i32_=>_i32 (func (param i32) (param i32) (param i32) (result i32)))
  (memory (export "memory") 1)
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (global $fun_f_inner*ptr (mut i32) i32.const 4)
  (global $fun_f_outer*ptr (mut i32) i32.const 0)
  (global $heap_base i32 i32.const 8)
  (table $func_table 2 funcref)
  (elem (i32.const 0) $fun_f_outer)
  (elem (i32.const 1) $fun_f_inner)
  (func $_start  (result i32) ;; entry point of program (main function) 
    ;; execution start here:
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f_outer*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    i32.const 1 ;; push 1 on stack
    i32.const 2 ;; push 2 on stack
    global.get $fun_f_outer*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 5 ;; push 5 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      )
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_f_inner (param $cenv i32) (param $x i32) (param $y i32) (result i32) ;; function fun_f_inner 
    local.get $x
    local.get $y
    i32.add
    i32.const 2 ;; push 2 on stack
    i32.add
  )
  (func $fun_f_outer (param $cenv i32) (param $x i32) (param $y i32) (result i32) ;; function fun_f_outer 
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f_inner*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    local.get $x
    local.get $y
    global.get $fun_f_inner*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)