(module
  (type $s_i32-eqref (;0;) (struct (field $func (mut i32)) (field $cenv (mut eqref))))
  (type $eq_i32_=>_i32 (;1;) (func (param (ref null eq)) (param i32) (result i32)))
  (type $s_i32-i32 (;2;) (struct (field $a (mut i32)) (field $x (mut i32))))
  (type $clos_fun_outer/anonymous (;3;) (struct (field $a (mut i32)) (field $x (mut i32))))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $fun_outer*ptr (;1;) (mut (ref null $s_i32-eqref)) (ref.null $s_i32-eqref))
  (global $fun_outer/anonymous*ptr (;2;) (mut (ref null $s_i32-eqref)) (ref.null $s_i32-eqref))
  (global $heap_base (;3;) (mut i32) (i32.const 0))
  (global $var_c1 (;4;) (mut (ref null $s_i32-eqref)) (ref.null $s_i32-eqref))
  (table $func_table (;0;) 2 funcref)
  (elem (i32.const 0) (;0;) $fun_outer)
  (elem (i32.const 1) (;1;) $fun_outer/anonymous)
  (func $_start (;0;)   
    ;; execution start here:
    (global.set $fun_outer*ptr
      (struct.new $s_i32-eqref
        (i32.const 0) ;; put function index on stack
        (ref.null eq) ;; null ref
      )
    )
    ;; Start of let
    (global.set $var_c1 ;; set local var, have been hoisted
      ;; Load expression to be applied as a function
      (call_indirect (type $eq_i32_=>_i32) ;; call function
        (struct.get $s_i32-eqref 1 ;; load closure environment pointer
          (global.get $fun_outer*ptr) ;; get global var: fun_outer*ptr
        )
        (i32.const 2) ;; push 2 on stack
        (struct.get $s_i32-eqref 0 ;; load table index
          (global.get $fun_outer*ptr) ;; get global var: fun_outer*ptr
        )
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            ;; Load expression to be applied as a function
            (call_indirect (type $eq_i32_=>_i32) ;; call function
              (struct.get $s_i32-eqref 1 ;; load closure environment pointer
                (global.get $var_c1) ;; get local var: var_c1, have been hoisted
              )
              (i32.const 2) ;; push 2 on stack
              (struct.get $s_i32-eqref 0 ;; load table index
                (global.get $var_c1) ;; get local var: var_c1, have been hoisted
              )
            )
            (i32.const 7) ;; push 7 on stack
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
  (func $fun_outer (;1;) (param $cenv (ref null eq)) (param $arg_x i32) (result (ref $s_i32-eqref)) 
     ;; local variables declarations:
    (local $var_a i32)

    ;; Start of let
    (local.set $var_a ;; set local var
      (i32.add
        (local.get $arg_x) ;; get local var: arg_x
        (i32.const 1) ;; push 1 on stack
      )
    )
    (struct.new $s_i32-eqref
      (i32.const 1) ;; push 1 on stack
      (struct.new $s_i32-i32
        (local.get $var_a) ;; get local var: var_a
        (local.get $arg_x) ;; get local var: arg_x
      )
    )
    ;; End of let
  )
  (func $fun_outer/anonymous (;2;) (param $cenv (ref null eq)) (param $arg_y i32) (result i32) 
    (i32.add
      (i32.add
        (local.get $arg_y) ;; get local var: arg_y
        (i32.load offset=0
          (local.get 0) ;; get env pointer
        )
      )
      (i32.load offset=4
        (local.get 0) ;; get env pointer
      )
    )
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)