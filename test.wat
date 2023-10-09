(module
  (type $i32_i32_=>_i32 (func (param i32) (param i32) (result i32)))
  (memory (export "memory") 1)
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (data (i32.const 8) "\02")
  (global $fun_f*ptr (mut i32) i32.const 0)
  (global $fun_g*ptr (mut i32) i32.const 4)
  (global $fun_h*ptr (mut i32) i32.const 8)
  (global $heap_base i32 i32.const 12)
  (table $func_table 3 funcref)
  (elem (i32.const 0) $fun_f)
  (elem (i32.const 1) $fun_g)
  (elem (i32.const 2) $fun_h)
  (func $_start  (result i32) ;; entry point of program (main function) 
    ;; execution start here:
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_h*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    i32.const 1 ;; push 1 on stack
    global.get $fun_h*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 42 ;; push 42 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_h*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    i32.const 42 ;; push 42 on stack
    global.get $fun_h*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 1 ;; push 1 on stack
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
  (func $fun_f (param $cenv i32) (param $x i32) (result i32) ;; function fun_f 
    local.get $x
    i32.const 42 ;; push 42 on stack
    i32.lt_s
  )
  (func $fun_g (param $cenv i32) (param $b i32) (result i32) ;; function fun_g 
    local.get $b
    (if  (result i32)
     (then
      i32.const 42 ;; push 42 on stack

     )
     (else
      i32.const 1 ;; push 1 on stack

     )
    )
  )
  (func $fun_h (param $cenv i32) (param $y i32) (result i32) ;; function fun_h 
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    local.get $y
    global.get $fun_f*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    (if  (result i32)
     (then
      ;; start of application
      ;; Load expression to be applied as a function
      global.get $fun_g*ptr
      i32.const 4 ;; 4 byte offset
      i32.add ;; add offset
      i32.load ;; load closure environment pointer
      ;; start of application
      ;; Load expression to be applied as a function
      global.get $fun_f*ptr
      i32.const 4 ;; 4 byte offset
      i32.add ;; add offset
      i32.load ;; load closure environment pointer
      local.get $y
      global.get $fun_f*ptr
      i32.load ;; load table index
      call_indirect (type $i32_i32_=>_i32) ;; call function
      ;; end of application
      global.get $fun_g*ptr
      i32.load ;; load table index
      call_indirect (type $i32_i32_=>_i32) ;; call function
      ;; end of application

     )
     (else
      ;; start of application
      ;; Load expression to be applied as a function
      global.get $fun_g*ptr
      i32.const 4 ;; 4 byte offset
      i32.add ;; add offset
      i32.load ;; load closure environment pointer
      i32.const 0
      global.get $fun_g*ptr
      i32.load ;; load table index
      call_indirect (type $i32_i32_=>_i32) ;; call function
      ;; end of application

     )
    )
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)