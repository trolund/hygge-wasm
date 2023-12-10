(module
  (type $s_i32-eqref (;0;) (struct (field $func (mut i32)) (field $cenv (mut eqref))))
  (type $s_i32 (;1;) (struct (field $value (mut i32))))
  (type $clos_fun_makeCounter/anonymous (;2;) (struct (field $x (ref null $s_i32)) (field $y (ref null $s_i32))))
  (type $eq_=>_i32 (;3;) (func (param (ref null eq)) (result i32)))
  (type $s_s_i32-s_i32 (;4;) (struct (field $x (ref null $s_i32)) (field $y (ref null $s_i32))))
  (type $eq_=>_s_i32-eqref (;5;) (func (param (ref null eq)) (result (ref null $s_i32-eqref))))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $fun_makeCounter*ptr (;1;) (mut (ref null $s_i32-eqref)) (ref.null $s_i32-eqref))
  (global $fun_makeCounter/anonymous*ptr (;2;) (mut (ref null $s_i32-eqref)) (ref.null $s_i32-eqref))
  (global $heap_base (;3;) (mut i32) (i32.const 0))
  (global $var_c1 (;4;) (mut (ref null $s_i32-eqref)) (ref.null $s_i32-eqref))
  (global $var_c2 (;5;) (mut (ref null $s_i32-eqref)) (ref.null $s_i32-eqref))
  (table $func_table (;0;) 2 funcref)
  (elem (i32.const 0) (;0;) $fun_makeCounter)
  (elem (i32.const 1) (;1;) $fun_makeCounter/anonymous)
  (func $_start (;0;)   
    ;; execution start here:
    (global.set $fun_makeCounter*ptr
      (struct.new $s_i32-eqref
        (i32.const 0) ;; put function index on stack
        (ref.null eq) ;; null ref
      )
    )
    ;; Start of let
    (global.set $var_c1 ;; set local var, have been hoisted
      ;; Load expression to be applied as a function
      (call_indirect (type $eq_=>_s_i32-eqref) ;; call function
        (struct.get $s_i32-eqref 1 ;; load closure environment pointer
          (global.get $fun_makeCounter*ptr) ;; get global var: fun_makeCounter*ptr
        )
        (struct.get $s_i32-eqref 0 ;; load table index
          (global.get $fun_makeCounter*ptr) ;; get global var: fun_makeCounter*ptr
        )
      )
    )
    ;; Start of let
    (global.set $var_c2 ;; set local var, have been hoisted
      ;; Load expression to be applied as a function
      (call_indirect (type $eq_=>_s_i32-eqref) ;; call function
        (struct.get $s_i32-eqref 1 ;; load closure environment pointer
          (global.get $fun_makeCounter*ptr) ;; get global var: fun_makeCounter*ptr
        )
        (struct.get $s_i32-eqref 0 ;; load table index
          (global.get $fun_makeCounter*ptr) ;; get global var: fun_makeCounter*ptr
        )
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            ;; Load expression to be applied as a function
            (call_indirect (type $eq_=>_i32) ;; call function
              (struct.get $s_i32-eqref 1 ;; load closure environment pointer
                (global.get $var_c1) ;; get local var: var_c1, have been hoisted
              )
              (struct.get $s_i32-eqref 0 ;; load table index
                (global.get $var_c1) ;; get local var: var_c1, have been hoisted
              )
            )
            (i32.const 2) ;; push 2 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            ;; Load expression to be applied as a function
            (call_indirect (type $eq_=>_i32) ;; call function
              (struct.get $s_i32-eqref 1 ;; load closure environment pointer
                (global.get $var_c1) ;; get local var: var_c1, have been hoisted
              )
              (struct.get $s_i32-eqref 0 ;; load table index
                (global.get $var_c1) ;; get local var: var_c1, have been hoisted
              )
            )
            (i32.const 4) ;; push 4 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            ;; Load expression to be applied as a function
            (call_indirect (type $eq_=>_i32) ;; call function
              (struct.get $s_i32-eqref 1 ;; load closure environment pointer
                (global.get $var_c1) ;; get local var: var_c1, have been hoisted
              )
              (struct.get $s_i32-eqref 0 ;; load table index
                (global.get $var_c1) ;; get local var: var_c1, have been hoisted
              )
            )
            (i32.const 8) ;; push 8 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            ;; Load expression to be applied as a function
            (call_indirect (type $eq_=>_i32) ;; call function
              (struct.get $s_i32-eqref 1 ;; load closure environment pointer
                (global.get $var_c1) ;; get local var: var_c1, have been hoisted
              )
              (struct.get $s_i32-eqref 0 ;; load table index
                (global.get $var_c1) ;; get local var: var_c1, have been hoisted
              )
            )
            (i32.const 16) ;; push 16 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            ;; Load expression to be applied as a function
            (call_indirect (type $eq_=>_i32) ;; call function
              (struct.get $s_i32-eqref 1 ;; load closure environment pointer
                (global.get $var_c2) ;; get local var: var_c2, have been hoisted
              )
              (struct.get $s_i32-eqref 0 ;; load table index
                (global.get $var_c2) ;; get local var: var_c2, have been hoisted
              )
            )
            (i32.const 2) ;; push 2 on stack
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
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (func $fun_makeCounter (;1;) (param $cenv (ref null eq)) (result (ref null $s_i32-eqref)) 
     ;; local variables declarations:
    (local $var_x (ref $s_i32))
    (local $var_y (ref $s_i32))

    ;; Start of let
    (local.set $var_x ;; set local var
      (struct.new $s_i32
        (i32.const 1) ;; push 1 on stack
      )
    )
    ;; Start of let
    (local.set $var_y ;; set local var
      (struct.new $s_i32
        (i32.const 2) ;; push 2 on stack
      )
    )
    (struct.new $s_i32-eqref
      (i32.const 1) ;; push 1 on stack
      (struct.new $s_s_i32-s_i32
        (local.get $var_x) ;; get local var: var_x
        (local.get $var_y) ;; get local var: var_y
      )
    )
    ;; End of let
    ;; End of let
  )
  (func $fun_makeCounter/anonymous (;2;) (param $cenv (ref null eq)) (result i32) 
     ;; local variables declarations:
    (local $clos (ref $clos_fun_makeCounter/anonymous))

    (local.set $clos
      (ref.cast (ref $clos_fun_makeCounter/anonymous)
        (local.get 0) ;; get cenv
      )
    )
    (struct.set $s_i32 $value ;; set field: value
      (struct.get $clos_fun_makeCounter/anonymous 0 ;; load value at index: 0
        (local.get $clos) ;; get env pointer
      )
      (i32.mul
        ;; Start of field select
        (struct.get $s_i32 0 ;; load field: value
          (struct.get $clos_fun_makeCounter/anonymous 0 ;; load value at index: 0
            (local.get $clos) ;; get env pointer
          )
        )
        ;; End of field select
        ;; Start of field select
        (struct.get $s_i32 0 ;; load field: value
          (struct.get $clos_fun_makeCounter/anonymous 1 ;; load value at index: 1
            (local.get $clos) ;; get env pointer
          )
        )
        ;; End of field select
      )
    )
    (struct.get $s_i32 $value ;; get field: value
      (struct.get $clos_fun_makeCounter/anonymous 0 ;; load value at index: 0
        (local.get $clos) ;; get env pointer
      )
    )
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)