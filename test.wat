(module
  (type $fun_f_type (func (param i32) (result i32)))
  (memory (export "memory") 1)
  (data (i32.const 0) "\00")
  (global $heap_base i32 i32.const 4)
  (table $func_table 1 funcref)
  (elem (i32.const 0) $fun_f)
  (func $_start  (result i32) ;; entry point of program (main function)    ;; local variables declarations:
    (local $fun_f i32)
    (local $var_x i32)
 
    ;; execution start here:
    ;; Start of let
    i32.const 1 ;; push 1 on stack
    local.set $var_x ;; set local var
    i32.const 0 ;; pointer to function
    i32.load ;; load function pointer
    local.set $fun_f ;; set local var
    local.get $var_x
    i32.const 1 ;; push 1 on stack
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
    i32.const 41 ;; push 41 on stack
    ;; Load expression to be applied as a function
    local.get $fun_f
    call_indirect (param i32) (result i32) ;; call function
    i32.const 42 ;; push 42 on stack
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
    i32.const 1 ;; push 1 on stack
    i32.add
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)