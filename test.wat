(module
  (type $i32_=>_f32 (func (param i32) (result f32)))
  (memory (export "memory") 1)
  (data (i32.const 0) "\00")
  (global $fun_f*ptr (mut i32) i32.const 0)
  (global $heap_base i32 i32.const 4)
  (table $func_table 1 funcref)
  (elem (i32.const 0) $fun_f)
  (func $_start  (result i32) ;; entry point of program (main function) 
    ;; execution start here:
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    global.get $fun_f*ptr
    i32.load ;; load table index
    call_indirect (type $i32_=>_f32) ;; call function
    ;; end of application
    f32.const 6.000000
    f32.eq
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
  (func $fun_f (param $cenv i32) (result f32) ;; function fun_f    ;; local variables declarations:
    (local $var_x f32)
    (local $var_y f32)
    (local $var_z f32)
 
    ;; Start of let
    f32.const 1.000000
    local.set $var_x ;; set local var
    ;; Start of let
    f32.const 2.000000
    local.set $var_y ;; set local var
    ;; Start of let
    f32.const 3.000000
    local.set $var_z ;; set local var
    local.get $var_x
    local.get $var_y
    f32.add
    local.get $var_z
    f32.add
    local.tee $var_z ;; set local var
    local.tee $var_y ;; set local var
    local.tee $var_x ;; set local var
    ;; End of let
    ;; End of let
    ;; End of let
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)