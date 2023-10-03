(module
  (type $anonymous_type (func  (result i32)))
  (type $fun_makeCounter_type (func  (result i32)))
  (memory (export "memory") 1)
  (data (i32.const 0) "\00")
  (global $heap_base i32 i32.const 4)
  (table $func_table 2 funcref)
  (elem (i32.const 0) $fun_makeCounter)
  (elem (i32.const 1) $anonymous)
  (func $_start  (result i32) ;; entry point of program (main function)    ;; local variables declarations:
    (local $fun_makeCounter i32)
    (local $var_c1 i32)
    (local $var_c2 i32)
 
    ;; execution start here:
    i32.const 0 ;; pointer to function
    i32.load ;; load function pointer
    local.set $fun_makeCounter ;; set local var
    ;; Start of let
    call $fun_makeCounter ;; call function fun_makeCounter
    local.set $var_c1 ;; set local var
    ;; Start of let
    call $fun_makeCounter ;; call function fun_makeCounter
    local.set $var_c2 ;; set local var
    ;; Load expression to be applied as a function
    local.get $fun_makeCounter
    call_indirect  (result i32) ;; call function fun_makeCounter
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
    ;; Load expression to be applied as a function
    local.get $fun_makeCounter
    call_indirect  (result i32) ;; call function fun_makeCounter
    i32.const 2 ;; push 2 on stack
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
    ;; Load expression to be applied as a function
    local.get $fun_makeCounter
    call_indirect  (result i32) ;; call function fun_makeCounter
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
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $anonymous  (result i32) ;; function anonymous 
    local.get $var_x
    i32.const 1 ;; push 1 on stack
    i32.add
    local.set $var_x ;; set local var
  )
  (func $fun_makeCounter  (result i32) ;; function fun_makeCounter    ;; local variables declarations:
    (local $var_x i32)
 
    ;; Start of let
    i32.const 0 ;; push 0 on stack
    local.set $var_x ;; set local var
    call $anonymous
    ;; End of let
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)