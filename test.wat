(module
  (type $struct_x*i32_y*i32 (;0;) (array (mut i32)))
  (type $$struct_x*i32_y*i32_i32_i32_=>_i32 (;1;) (func (param (ref $struct_x*i32_y*i32)) (param i32) (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $fun_f*ptr (;1;) (mut i32) (i32.const 0))
  (global $heap_base (;2;) (mut i32) (i32.const 4))
  (global $var_result (;3;) (mut i32) (i32.const 0))
  (table $func_table (;0;) 1 funcref)
  (elem (i32.const 0) (;0;) $fun_f)
  (func $_start (;0;)   
    ;; execution start here:
    ;; Start of let
    (global.set $var_result ;; set local var, have been hoisted
      ;; Load expression to be applied as a function
      (call_indirect (type $i32_i32_i32_=>_i32) ;; call function
        (i32.load offset=4
          (global.get $fun_f*ptr) ;; get global var: fun_f*ptr
        )
        (i32.const 1) ;; push 1 on stack
        (i32.const 2) ;; push 2 on stack
        (i32.load ;; load table index
          (global.get $fun_f*ptr) ;; get global var: fun_f*ptr
        )
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (global.get $var_result) ;; get local var: var_result, have been hoisted
            (i32.const 3) ;; push 3 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (func $fun_f (;1;) (param $cenv (ref $struct_x*i32_y*i32)) (param $arg_x i32) (param $arg_y i32) (result i32) 
    (i32.add
      (local.get $arg_x) ;; get local var: arg_x
      (local.get $arg_y) ;; get local var: arg_y
    )
  )
  (data (i32.const 0) "\00")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)