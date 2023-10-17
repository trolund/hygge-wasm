(module
  (type $i32_i32_i32_=>_i32 (;0;) (func (param i32) (param i32) (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) i32.const 0)
  (global $fun_f*ptr (;1;) (mut i32) i32.const 0)
  (global $heap_base (;2;) i32 i32.const 4)
  (global $var_g (;3;) (mut i32) i32.const 0)
  (global $var_g$0 (;4;) (mut i32) i32.const 0)
  (table $func_table (;0;) 1 funcref)
  (elem (i32.const 0) (;0;) $fun_f)
  (func $_start (;0;)  (result i32) ;; entry point of program (main function) 
    ;; execution start here:
    ;; Start of let
    i32.const 200 ;; push 200 on stack
    global.set $var_g ;; set local var, have been hoisted
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f*ptr ;; get global var: fun_f*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    i32.const 2 ;; push 2 on stack
    i32.const 4 ;; push 4 on stack
    global.get $fun_f*ptr ;; get global var: fun_f*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 6 ;; push 6 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
       )
      )
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_f (;0;) (param $cenv i32) (param $arg_x i32) (param $arg_y i32) (result i32) ;; function fun_f 
    ;; Start of let
    local.get $arg_x ;; get local var: arg_x
    local.get $arg_y ;; get local var: arg_y
    i32.add
    global.set $var_g$0 ;; set local var, have been hoisted
    global.get $var_g$0 ;; get local var: var_g$0, have been hoisted
    i32.const 6 ;; push 6 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
       )
      )
    global.get $var_g$0 ;; get local var: var_g$0, have been hoisted
    ;; End of let
  )
  (data (i32.const 0) "\00")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "f" (func $fun_f))
  (export "heap_base_ptr" (global $heap_base))
  (export "var_g" (global $var_g))
  (export "var_g$0" (global $var_g$0))
)