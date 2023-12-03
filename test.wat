(module
  (type $s_i32_i32-eqref_eqref (;0;) (struct (field $f (mut i32)) (field $cenv (mut eqref))))
  (type $s_i32_i32-eqref_eqref_i32_i32_=>_i32 (;1;) (func (param (ref $s_i32_i32-eqref_eqref)) (param i32) (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $fun_f*ptr (;1;) (mut (ref null $s_i32_i32-eqref_eqref)) (ref.null $s_i32_i32-eqref_eqref))
  (global $heap_base (;2;) (mut i32) (i32.const 0))
  (global $var_result (;3;) (mut i32) (i32.const 0))
  (table $func_table (;0;) 1 funcref)
  (elem (i32.const 0) (;0;) $fun_f)
  (func $_start (;0;)   
    ;; execution start here:
    ;; Start of let
    (global.set $var_result ;; set local var, have been hoisted
      ;; Load expression to be applied as a function
      (call_indirect (type $s_i32_i32-eqref_eqref_i32_i32_=>_i32) ;; call function
        (struct.get $s_i32_i32-eqref_eqref 1 ;; load closure environment pointer
          (global.get $fun_f*ptr) ;; get global var: fun_f*ptr
        )
        (i32.const 1) ;; push 1 on stack
        (i32.const 2) ;; push 2 on stack
        (struct.get $s_i32_i32-eqref_eqref 0 ;; load table index
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
  (func $fun_f (;1;) (param $cenv (ref $s_i32_i32-eqref_eqref)) (param $arg_x i32) (param $arg_y i32) (result i32) 
    (i32.add
      (local.get $arg_x) ;; get local var: arg_x
      (local.get $arg_y) ;; get local var: arg_y
    )
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)