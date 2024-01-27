(module
  (type $s|value-i32 (;0;) (struct (field $value (mut i32))))
  (type $clos_fun_makeCounter (;1;) (struct (field $z (mut i32))))
  (type $s|func-i32|cenv-eqref (;2;) (struct (field $func (mut i32)) (field $cenv (mut eqref))))
  (type $clos_fun_f (;3;) (struct (field $x (mut i32)) (field $y (mut i32)) (field $z (mut i32))))
  (type $clos_fun_f$0 (;4;) (struct (field $x (mut i32)) (field $y (mut i32)) (field $z (mut i32))))
  (type $s|x-s|value-i32|y-i32|z-s|value-i32 (;5;) (struct (field $x (ref null $s|value-i32)) (field $y (mut i32)) (field $z (ref null $s|value-i32))))
  (type $eq_=>_i32 (;6;) (func (param (ref null eq)) (result i32)))
  (type $eq_i32_=>_s|func-i32|cenv-eqref (;7;) (func (param (ref null eq)) (param i32) (result (ref null $s|func-i32|cenv-eqref))))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $fun_f$0*ptr (;1;) (mut (ref null $s|func-i32|cenv-eqref)) (ref.null $s|func-i32|cenv-eqref))
  (global $fun_f*ptr (;2;) (mut (ref null $s|func-i32|cenv-eqref)) (ref.null $s|func-i32|cenv-eqref))
  (global $fun_makeCounter*ptr (;3;) (mut (ref null $s|func-i32|cenv-eqref)) (ref.null $s|func-i32|cenv-eqref))
  (global $heap_base (;4;) (mut i32) (i32.const 0))
  (global $var_c1 (;5;) (mut (ref null $s|func-i32|cenv-eqref)) (ref.null $s|func-i32|cenv-eqref))
  (global $var_c2 (;6;) (mut (ref null $s|func-i32|cenv-eqref)) (ref.null $s|func-i32|cenv-eqref))
  (global $var_c3 (;7;) (mut (ref null $s|func-i32|cenv-eqref)) (ref.null $s|func-i32|cenv-eqref))
  (global $var_z (;8;) (mut (ref null $s|value-i32)) (ref.null $s|value-i32))
  (table $func_table (;0;) 3 funcref)
  (elem (i32.const 0) (;0;) $fun_makeCounter)
  (elem (i32.const 1) (;1;) $fun_f)
  (elem (i32.const 2) (;2;) $fun_f$0)
  (func $_start (;0;)   
    ;; execution start here:
    ;; Start of let
    (global.set $var_z ;; set local var, have been promoted
      (struct.new $s|value-i32
        (i32.const 2) ;; push 2 on stack
      )
    )
    (global.set $fun_makeCounter*ptr
      (struct.new $s|func-i32|cenv-eqref
        (i32.const 0) ;; put function index on stack
        (ref.null eq) ;; null ref
      )
    )
    ;; Start of let
    (global.set $var_c1 ;; set local var, have been promoted
      ;; Load expression to be applied as a function
      (call_indirect (type $eq_i32_=>_i32) ;; call function
        (struct.get $s|func-i32|cenv-eqref 1 ;; load closure environment pointer
          (global.get $fun_makeCounter*ptr) ;; get global var: fun_makeCounter*ptr
        )
        (i32.const 2) ;; push 2 on stack
        (struct.get $s|func-i32|cenv-eqref 0 ;; load table index
          (global.get $fun_makeCounter*ptr) ;; get global var: fun_makeCounter*ptr
        )
      )
    )
    ;; Start of let
    (global.set $var_c2 ;; set local var, have been promoted
      ;; Load expression to be applied as a function
      (call_indirect (type $eq_i32_=>_i32) ;; call function
        (struct.get $s|func-i32|cenv-eqref 1 ;; load closure environment pointer
          (global.get $fun_makeCounter*ptr) ;; get global var: fun_makeCounter*ptr
        )
        (i32.const 4) ;; push 4 on stack
        (struct.get $s|func-i32|cenv-eqref 0 ;; load table index
          (global.get $fun_makeCounter*ptr) ;; get global var: fun_makeCounter*ptr
        )
      )
    )
    ;; Start of let
    (global.set $var_c3 ;; set local var, have been promoted
      ;; Load expression to be applied as a function
      (call_indirect (type $eq_i32_=>_i32) ;; call function
        (struct.get $s|func-i32|cenv-eqref 1 ;; load closure environment pointer
          (global.get $fun_makeCounter*ptr) ;; get global var: fun_makeCounter*ptr
        )
        (i32.const 8) ;; push 8 on stack
        (struct.get $s|func-i32|cenv-eqref 0 ;; load table index
          (global.get $fun_makeCounter*ptr) ;; get global var: fun_makeCounter*ptr
        )
      )
    )
    (if 
      (i32.eqz ;; invert assertion
        (i32.eq ;; equality check
          ;; Load expression to be applied as a function
          (call_indirect (type $eq_=>_i32) ;; call function
            (struct.get $s|func-i32|cenv-eqref 1 ;; load closure environment pointer
              (global.get $var_c1) ;; get local var: var_c1, have been promoted
            )
            (struct.get $s|func-i32|cenv-eqref 0 ;; load table index
              (global.get $var_c1) ;; get local var: var_c1, have been promoted
            )
          )
          (i32.const 12) ;; push 12 on stack
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
            (struct.get $s|func-i32|cenv-eqref 1 ;; load closure environment pointer
              (global.get $var_c2) ;; get local var: var_c2, have been promoted
            )
            (struct.get $s|func-i32|cenv-eqref 0 ;; load table index
              (global.get $var_c2) ;; get local var: var_c2, have been promoted
            )
          )
          (i32.const 32) ;; push 32 on stack
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
            (struct.get $s|func-i32|cenv-eqref 1 ;; load closure environment pointer
              (global.get $var_c2) ;; get local var: var_c2, have been promoted
            )
            (struct.get $s|func-i32|cenv-eqref 0 ;; load table index
              (global.get $var_c2) ;; get local var: var_c2, have been promoted
            )
          )
          (i32.const 640) ;; push 640 on stack
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
            (struct.get $s|func-i32|cenv-eqref 1 ;; load closure environment pointer
              (global.get $var_c3) ;; get local var: var_c3, have been promoted
            )
            (struct.get $s|func-i32|cenv-eqref 0 ;; load table index
              (global.get $var_c3) ;; get local var: var_c3, have been promoted
            )
          )
          (i32.const 96) ;; push 96 on stack
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
            (struct.get $s|func-i32|cenv-eqref 1 ;; load closure environment pointer
              (global.get $var_c3) ;; get local var: var_c3, have been promoted
            )
            (struct.get $s|func-i32|cenv-eqref 0 ;; load table index
              (global.get $var_c3) ;; get local var: var_c3, have been promoted
            )
          )
          (i32.const 5376) ;; push 5376 on stack
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
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (func $fun_f (;1;) (param $cenv (ref null eq)) (result i32) 
     ;; local variables declarations:
    (local $clos (ref $clos_fun_f))

    (local.set $clos
      (ref.cast (ref $clos_fun_f)
        (local.get 0) ;; get cenv
      )
    )
    (global.set $fun_f$0*ptr
      (struct.new $s|func-i32|cenv-eqref
        (i32.const 2) ;; put function index on stack
        (ref.null eq) ;; null ref
      )
    )
    (global.set $fun_f$0*ptr
      (struct.new $s|func-i32|cenv-eqref
        (i32.const 2) ;; push 2 on stack
        (struct.new $s|x-s|value-i32|y-i32|z-s|value-i32
          (struct.get $clos_fun_f 0 ;; load value at index: 0
            (local.get $clos) ;; get env pointer
          )
          (struct.get $clos_fun_f 1 ;; load value at index: 1
            (local.get $clos) ;; get env pointer
          )
          (struct.get $clos_fun_f 2 ;; load value at index: 2
            (local.get $clos) ;; get env pointer
          )
        )
      )
    )
    (drop ;; drop value of subtree
      ;; Load expression to be applied as a function
      (call_indirect (type $eq_=>_i32) ;; call function
        (struct.get $s|func-i32|cenv-eqref 1 ;; load closure environment pointer
          (global.get $fun_f$0*ptr) ;; get global var: fun_f$0*ptr
        )
        (struct.get $s|func-i32|cenv-eqref 0 ;; load table index
          (global.get $fun_f$0*ptr) ;; get global var: fun_f$0*ptr
        )
      )
    )
    ;; Start of field select
    (struct.get $s|value-i32 0 ;; load field: value
      (struct.get $clos_fun_f 0 ;; load value at index: 0
        (local.get $clos) ;; get env pointer
      )
    )
    ;; End of field select
  )
  (func $fun_f$0 (;2;) (param $cenv (ref null eq)) (result i32) 
     ;; local variables declarations:
    (local $clos (ref $clos_fun_f$0))

    (local.set $clos
      (ref.cast (ref $clos_fun_f$0)
        (local.get 0) ;; get cenv
      )
    )
    (drop ;; drop value of subtree
      (struct.set $s|value-i32 $value ;; set field: value
        (struct.get $clos_fun_f$0 2 ;; load value at index: 2
          (local.get $clos) ;; get env pointer
        )
        (i32.add
          ;; Start of field select
          (struct.get $s|value-i32 0 ;; load field: value
            (struct.get $clos_fun_f$0 2 ;; load value at index: 2
              (local.get $clos) ;; get env pointer
            )
          )
          ;; End of field select
          (i32.const 1) ;; push 1 on stack
        )
      )
      (struct.get $s|value-i32 $value ;; get field: value
        (struct.get $clos_fun_f$0 2 ;; load value at index: 2
          (local.get $clos) ;; get env pointer
        )
      )
    )
    (struct.set $s|value-i32 $value ;; set field: value
      (struct.get $clos_fun_f$0 0 ;; load value at index: 0
        (local.get $clos) ;; get env pointer
      )
      (i32.mul
        (i32.mul
          ;; Start of field select
          (struct.get $s|value-i32 0 ;; load field: value
            (struct.get $clos_fun_f$0 0 ;; load value at index: 0
              (local.get $clos) ;; get env pointer
            )
          )
          ;; End of field select
          (struct.get $clos_fun_f$0 1 ;; load value at index: 1
            (local.get $clos) ;; get env pointer
          )
        )
        ;; Start of field select
        (struct.get $s|value-i32 0 ;; load field: value
          (struct.get $clos_fun_f$0 2 ;; load value at index: 2
            (local.get $clos) ;; get env pointer
          )
        )
        ;; End of field select
      )
    )
    (struct.get $s|value-i32 $value ;; get field: value
      (struct.get $clos_fun_f$0 0 ;; load value at index: 0
        (local.get $clos) ;; get env pointer
      )
    )
  )
  (func $fun_makeCounter (;3;) (param $cenv (ref null eq)) (param $arg_k i32) (result (ref null $s|func-i32|cenv-eqref)) 
     ;; local variables declarations:
    (local $var_x (ref null $s|value-i32))
    (local $var_y i32)

    ;; Start of let
    (local.set $var_y ;; set local var
      (local.get $arg_k) ;; get local var: arg_k
    )
    ;; Start of let
    (local.set $var_x ;; set local var
      (struct.new $s|value-i32
        (i32.const 2) ;; push 2 on stack
      )
    )
    (global.set $fun_f*ptr
      (struct.new $s|func-i32|cenv-eqref
        (i32.const 1) ;; put function index on stack
        (ref.null eq) ;; null ref
      )
    )
    (global.set $fun_f*ptr
      (struct.new $s|func-i32|cenv-eqref
        (i32.const 1) ;; push 1 on stack
        (struct.new $s|x-s|value-i32|y-i32|z-s|value-i32
          (local.get $var_x) ;; get local var: var_x
          (local.get $var_y) ;; get local var: var_y
          (global.get $var_z) ;; get local var: var_z, have been promoted
        )
      )
    )
    (global.get $fun_f*ptr) ;; get global var: fun_f*ptr
    ;; End of let
    ;; End of let
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)