(module
  (type $struct_*i32 (;0;) (array (mut i32)))
  (type $struct_value*i32 (;1;) (struct (field $value (mut i32))))
  (type $struct_ (;2;) (array (mut i32)))
  (type $struct__=>_i32 (;3;) (func (param (ref $struct_)) (result i32)))
  (type $struct_x*struct_value*i32_y*i32 (;4;) (struct (field $x (ref null $struct_value*i32)) (field $y (mut i32))))
  (type $struct_f*i32_env*i32 (;5;) (struct (field $f (mut i32)) (field $env (mut i32))))
  (type $struct_*i32_i32_=>_i32 (;6;) (func (param (ref $struct_*i32)) (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $fun_makeCounter*ptr (;1;) (mut i32) (i32.const 0))
  (global $fun_makeCounter/anonymous*ptr (;2;) (mut i32) (i32.const 4))
  (global $heap_base (;3;) (mut i32) (i32.const 8))
  (global $var_c1 (;4;) (mut i32) (i32.const 0))
  (global $var_c2 (;5;) (mut i32) (i32.const 0))
  (global $var_c3 (;6;) (mut i32) (i32.const 0))
  (table $func_table (;0;) 2 funcref)
  (elem (i32.const 0) (;0;) $fun_makeCounter)
  (elem (i32.const 1) (;1;) $fun_makeCounter/anonymous)
  (func $_start (;0;)   
    ;; execution start here:
    ;; Start of let
    (global.set $var_c1 ;; set local var, have been hoisted
      ;; Load expression to be applied as a function
      (call_indirect (type $struct_*i32_i32_=>_i32) ;; call function
        (i32.load offset=4
          (global.get $fun_makeCounter*ptr) ;; get global var: fun_makeCounter*ptr
        )
        (i32.const 2) ;; push 2 on stack
        (i32.load ;; load table index
          (global.get $fun_makeCounter*ptr) ;; get global var: fun_makeCounter*ptr
        )
      )
    )
    ;; Start of let
    (global.set $var_c2 ;; set local var, have been hoisted
      ;; Load expression to be applied as a function
      (call_indirect (type $struct_*i32_i32_=>_i32) ;; call function
        (i32.load offset=4
          (global.get $fun_makeCounter*ptr) ;; get global var: fun_makeCounter*ptr
        )
        (i32.const 4) ;; push 4 on stack
        (i32.load ;; load table index
          (global.get $fun_makeCounter*ptr) ;; get global var: fun_makeCounter*ptr
        )
      )
    )
    ;; Start of let
    (global.set $var_c3 ;; set local var, have been hoisted
      ;; Load expression to be applied as a function
      (call_indirect (type $struct_*i32_i32_=>_i32) ;; call function
        (i32.load offset=4
          (global.get $fun_makeCounter*ptr) ;; get global var: fun_makeCounter*ptr
        )
        (i32.const 8) ;; push 8 on stack
        (i32.load ;; load table index
          (global.get $fun_makeCounter*ptr) ;; get global var: fun_makeCounter*ptr
        )
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            ;; Load expression to be applied as a function
            (call_indirect (type $struct__=>_i32) ;; call function
              (i32.load offset=4
                (global.get $var_c1) ;; get local var: var_c1, have been hoisted
              )
              (i32.load ;; load table index
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
            (call_indirect (type $struct__=>_i32) ;; call function
              (i32.load offset=4
                (global.get $var_c1) ;; get local var: var_c1, have been hoisted
              )
              (i32.load ;; load table index
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
            (call_indirect (type $struct__=>_i32) ;; call function
              (i32.load offset=4
                (global.get $var_c2) ;; get local var: var_c2, have been hoisted
              )
              (i32.load ;; load table index
                (global.get $var_c2) ;; get local var: var_c2, have been hoisted
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
            (call_indirect (type $struct__=>_i32) ;; call function
              (i32.load offset=4
                (global.get $var_c3) ;; get local var: var_c3, have been hoisted
              )
              (i32.load ;; load table index
                (global.get $var_c3) ;; get local var: var_c3, have been hoisted
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
            (call_indirect (type $struct__=>_i32) ;; call function
              (i32.load offset=4
                (global.get $var_c3) ;; get local var: var_c3, have been hoisted
              )
              (i32.load ;; load table index
                (global.get $var_c3) ;; get local var: var_c3, have been hoisted
              )
            )
            (i32.const 128) ;; push 128 on stack
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
    ;; if execution reaches here, the program is successful
  )
  (func $fun_makeCounter (;1;) (param $cenv (ref $struct_*i32)) (param $arg_y i32) (result i32) 
     ;; local variables declarations:
    (local $var_x (ref $struct_value*i32))

    ;; Start of let
    (local.set $var_x ;; set local var
      (struct.new $struct_value*i32
        (i32.const 2) ;; push 2 on stack
      )
    )
    (struct.new $struct_f*i32_env*i32
      (i32.const 1) ;; push 1 on stack
      (struct.new $struct_x*struct_value*i32_y*i32
        (local.get $var_x) ;; get local var: var_x
        (local.get $arg_y) ;; get local var: arg_y
      )
    )
    ;; End of let
  )
  (func $fun_makeCounter/anonymous (;2;) (param $cenv (ref $struct_)) (result i32) 
    (struct.set $struct_value*i32 $value ;; set field: value
      (i32.load offset=0
        (local.get 0) ;; get env pointer
      )
      (i32.mul
        ;; Start of field select
        (struct.get $struct_value*i32 0 ;; load field: value
          (i32.load offset=0
            (local.get 0) ;; get env pointer
          )
        )
        ;; End of field select
        (i32.load offset=4
          (local.get 0) ;; get env pointer
        )
      )
    )
    (struct.get $struct_value*i32 $value ;; get field: value
      (i32.load offset=0
        (local.get 0) ;; get env pointer
      )
    )
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)