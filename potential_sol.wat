(module
  (type $funcp (;0;) (struct (field $func (mut i32)) (field $cenv (mut eqref))))
  (type $i32_=>_funcp (;2;) (func (param (ref null eq)) (param i32) (result (ref $funcp))))
  (type $i32_=>_i32 (;2;) (func (param (ref null eq)) (param i32) (result i32)))
  (type $clos_inner (;3;) (struct (field $a (mut i32)) (field $x (mut i32))))
  ;; (type $clos_outer (;3;) (struct))
  ;; (type $mutable_i32 (;4;) (struct (field $value (mut i32))))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $fun_outer*ptr (;1;) (mut (ref null $funcp)) (ref.null $funcp))
  (global $fun_outer/anonymous*ptr (;2;) (mut (ref null $funcp)) (ref.null $funcp))
  (global $var_c1 (;4;) (mut (ref null $funcp)) (ref.null $funcp))
  (global $heap_base (;3;) (mut i32) (i32.const 0))
  (table $func_table (;0;) 2 funcref)
  (elem (i32.const 0) (;0;) $fun_outer)
  (elem (i32.const 1) (;1;) $fun_outer/anonymous)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    (global.set $fun_outer*ptr ;; init func pointer as the first thing when compiling lambda
      (struct.new $funcp
        (i32.const 0) ;; put function index on stack
        (ref.null eq) ;; null ref to empty closure environment
      )
    )
    (global.set $var_c1 ;; drop value of subtree
      ;; Load expression to be applied as a function
      (call_indirect (type $i32_=>_funcp) ;; call function
        (struct.get $funcp 1 ;; load closure environment pointer
            (global.get $fun_outer*ptr) ;; get global var: fun_outer*ptr
        )
        (i32.const 2) ;; push 2 on stack
        (struct.get $funcp 0 ;; load table index
            (global.get $fun_outer*ptr) ;; get global var: fun_outer*ptr
        )
      )
    )


    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            ;; Load expression to be applied as a function
            (call_indirect (type $i32_=>_i32) ;; call function
              (struct.get $funcp 1 ;; load closure environment pointer
                (global.get $var_c1) ;; get local var: var_c1, have been hoisted
              )
              (i32.const 2) ;; push 2 on stack
              (struct.get $funcp 0 ;; load table index
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


    (i32.const 10) ;; push 10 on stack
    ;; if execution reaches here, the program is successful
  )
  (func $fun_outer (;1;) (param $cenv (ref null eq)) (param $arg_x i32) (result (ref $funcp)) 
     ;; local variables declarations:
    (local $var_a i32)
    ;;(local $clos (ref $clos_outer))

    ;; cast closure environment to $clos_outer

    ;; Start of let
    (local.set $var_a ;; set local var
      (i32.add
        (local.get $arg_x) ;; get local var: arg_x
        (i32.const 1) ;; push 1 on stack
      )
    )
    ;; return function pointer
    (struct.new $funcp
      ;; init field (f)
      (i32.const 1) ;; push 1 on stack
      ;; init field (cenv)
      (struct.new $clos_inner
        ;; init field (a)
        (local.get $var_a) ;; get local var: var_a
        ;; init field (x)
        (local.get $arg_x) ;; get local var: arg_x
      )
    )
    ;; End of let
  )
  (func $fun_outer/anonymous (;2;) (param $cenv (ref null eq)) (param $arg_y i32) (result i32)
    ;; local variables declarations:
    (local $clos (ref $clos_inner))

    ;; cast closure environment to $clos_outer
    (local.set $clos
      (ref.cast (ref $clos_inner)
        (local.get $cenv) ;; get local var: cenv
      )
    )

    ;; body of function
    (i32.add
      (i32.add
        (local.get $arg_y) ;; get local var: arg_y
        (struct.get $clos_inner 0 ;; load field (a)
          (local.get $clos) ;; get env pointer
        )
      )
      (struct.get $clos_inner 1 ;; load field (a)
        (local.get $clos) ;; get env pointer
      )
    )
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)