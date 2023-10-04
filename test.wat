(module
  (type $fun_g_type (func (param i32) (result i32)))
  (memory (export "memory") 1)
  (data (i32.const 0) "\00")
  (global $fun_g (mut i32) i32.const 0)
  (global $heap_base i32 i32.const 4)
  (table $func_table 1 funcref)
  (elem (i32.const 0) $fun_g)
  (func $_start  (result i32) ;; entry point of program (main function) 
    ;; execution start here:
    i32.const 10 ;; push 10 on stack
    ;; Load expression to be applied as a function
    global.get $fun_g
    call_indirect (param i32) (result i32) ;; call function
    i32.const 50 ;; push 50 on stack
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
  (func $fun_g (param $z i32) (result i32) ;; function fun_g 
    local.get $z
    i32.const 50 ;; push 50 on stack
    i32.lt_s
    (if  (result i32)
     (then
      local.get $z
      i32.const 1 ;; push 1 on stack
      i32.add
      ;; Load expression to be applied as a function
      global.get $fun_g
      call_indirect (param i32) (result i32) ;; call function

     )
     (else
      local.get $z

     )
    )
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)