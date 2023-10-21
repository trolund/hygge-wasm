(module
  (type $i32_f32_f32_=>_f32 (;0;) (func (param i32) (param f32) (param f32) (result f32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) i32.const 0)
  (global $fun_f*ptr (;1;) (mut i32) i32.const 0)
  (global $heap_base (;2;) i32 i32.const 4)
  (global $var_x (;3;) (mut f32) f32.const 0.000000)
  (table $func_table (;0;) 1 funcref)
  (elem (i32.const 0) (;0;) $fun_f)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    f32.const 5.000000
    global.set $var_x ;; set local var, have been hoisted
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f*ptr ;; get global var: fun_f*ptr
    i32.load offset=4 ;; load closure environment pointer
    f32.const 1.000000
    f32.const 2.000000
    global.get $fun_f*ptr ;; get global var: fun_f*ptr
    i32.load ;; load table index
    call_indirect (type $i32_f32_f32_=>_f32) ;; call function
    ;; end of application
    f32.const 3.000000
    f32.eq
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
  (func $fun_f (;1;) (param $cenv i32) (param $arg_x f32) (param $arg_y f32) (result f32) 
    local.get $arg_y ;; get local var: arg_y
    f32.const 1.000000
    f32.gt
    (if (result f32)
      (then
        local.get $arg_x ;; get local var: arg_x
        local.get $arg_y ;; get local var: arg_y
        f32.add
      )
      (else
        local.get $arg_x ;; get local var: arg_x
        local.get $arg_y ;; get local var: arg_y
        f32.add
        f32.const 2.000000
        f32.add
      )
    )
  )
  (data (i32.const 0) "\00")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)