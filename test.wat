(module
  (type $fun_f_type (func (param i32) (result i32)))
  (type $fun_g_type (func (param i32) (result i32)))
  (type $fun_t_type (func (param i32) (param i32) (param i32) (result i32)))
  (memory (export "memory") 1)
  (data (i32.const 0) "\00")
  (data (i32.const 8) "\01")
  (data (i32.const 16) "\02")
  (global $fun_f (mut i32) i32.const 0)
  (global $fun_g (mut i32) i32.const 1)
  (global $fun_t (mut i32) i32.const 2)
  (global $heap_base i32 i32.const 24)
  (table $func_table 3 funcref)
  (elem (i32.const 0) $fun_f)
  (elem (i32.const 1) $fun_g)
  (elem (i32.const 2) $fun_t)
  (func $_start  (result i32) ;; entry point of program (main function)    ;; local variables declarations:
    (local $var_result i32)
 
    ;; execution start here:
    ;; Start of let
    i32.const 2 ;; push 2 on stack
    global.get $fun_f
    global.get $fun_g
    ;; Load expression to be applied as a function
    global.get $fun_t
    call_indirect (param i32) (param i32) (param i32) (result i32) ;; call function
    i32.const 2 ;; push 2 on stack
    ;; Load expression to be applied as a function
    global.get $fun_f
    call_indirect (param i32) (result i32) ;; call function
    i32.add
    local.set $var_result ;; set local var
    local.get $var_result
    i32.const 12 ;; push 12 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
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
    ;; Load expression to be applied as a function
    local.get $k
    call_indirect (param i32) (result i32) ;; call function
    local.get $x
    ;; Load expression to be applied as a function
    local.get $o
    call_indirect (param i32) (result i32) ;; call function
    i32.add
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)