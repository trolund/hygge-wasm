(module
  (type $fun_f_type (func (param i32) (result i32)))
  (type $fun_g_type (func (param i32) (result i32)))
  (type $fun_t_type (func (param i32) (param i32) (param i32) (result i32)))
  (memory (export "memory") 1)
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (data (i32.const 8) "\02")
  (global $heap_base i32 i32.const 12)
  (table $func_table 3 funcref)
  (elem (i32.const 0) $fun_f)
  (elem (i32.const 1) $fun_g)
  (elem (i32.const 2) $fun_t)
  (func $_start  (result i32) ;; entry point of program (main function)    ;; local variables declarations:
    (local $fun_f i32)
    (local $fun_g i32)
    (local $fun_t i32)
    (local $var_result i32)
 
    ;; execution start here:
    i32.const 0 ;; pointer to function
    i32.load ;; load function pointer
    local.set $fun_f ;; set local var
    i32.const 4 ;; pointer to function
    i32.load ;; load function pointer
    local.set $fun_g ;; set local var
    i32.const 8 ;; pointer to function
    i32.load ;; load function pointer
    local.set $fun_t ;; set local var
    ;; Start of let
    i32.const 2 ;; push 2 on stack
    local.get $fun_f
    local.get $fun_g
    call $fun_t ;; call function fun_t
    i32.const 2 ;; push 2 on stack
    call $fun_f ;; call function fun_f
    i32.add
    local.set $var_result ;; set local var
    local.get $var_result
    i32.const 12 ;; push 12 on stack
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
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_f (param $x i32) (result i32) ;; function fun_f 
    local.get $x
    local.get $x
    i32.add
  )
  (func $fun_g (param $x i32) (result i32) ;; function fun_g 
    local.get $x
    local.get $x
    i32.mul
  )
  (func $fun_t (param $x i32) (param $k i32) (param $o i32) (result i32) ;; function fun_t 
    local.get $x
    local.get $k ;; get table index
    call_indirect (param i32) (result i32) ;; call function k
    local.get $x
    local.get $o ;; get table index
    call_indirect (param i32) (result i32) ;; call function o
    i32.add
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)