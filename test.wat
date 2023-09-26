(module
  (type $fun_f_type (func (param i32) (result i32)))
  (type $fun_fx_type (func (param i32) (result i32)))
  (memory (export "memory") 1)
  (global $heap_base i32  i32.const 0
)  (table $func_table 2 funcref)
  (elem (i32.const 0) $fun_f)
  (elem (i32.const 1) $fun_fx)
  (func $_start  (result i32) ;; entry point of program (main function)    ;; local variables declarations:
    (local $fun_f i32)
    (local $fun_fx i32)
    (local $var_g i32)
    (local $var_gx i32)
    (local $var_result i32)
    (local $var_resultx i32)
 
    ;; execution start here:
    i32.const 0 ;; pointer to function
    local.set $fun_f ;; set local var
    ;; Start of let
    local.get $fun_f
    local.set $var_g ;; set local var
    ;; Start of let
    i32.const 2 ;; push 2 on stack
    call $fun_f ;; call function fun_f
    local.set $var_result ;; set local var
    local.get $var_result
    i32.const 4 ;; push 4 on stack
    i32.eq
    (if 
     (then
      nop ;; do nothing - if all correct

     )
     (else
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
    )
    i32.const 1 ;; pointer to function
    local.set $fun_fx ;; set local var
    ;; Start of let
    local.get $fun_fx
    local.set $var_gx ;; set local var
    ;; Start of let
    i32.const 8 ;; push 8 on stack
    call $fun_fx ;; call function fun_fx
    local.set $var_resultx ;; set local var
    local.get $var_resultx
    i32.const 64 ;; push 64 on stack
    i32.eq
    (if 
     (then
      nop ;; do nothing - if all correct

     )
     (else
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
    )
    ;; End of let
    ;; End of let
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_f (param $x i32) (result i32) ;; function fun_f 
    local.get $x
    local.get $x
    i32.add
  )
  (func $fun_fx (param $x i32) (result i32) ;; function fun_fx 
    local.get $x
    local.get $x
    i32.mul
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)