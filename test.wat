(module
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) i32.const 0)
  (global $heap_base (;1;) i32 i32.const 0)
  (global $var_a (;2;) (mut i32) i32.const 0)
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)  (result i32) ;; entry point of program (main function) 
    ;; execution start here:
    ;; Start of let
    i32.const 5 ;; push 5 on stack
    global.set $var_a ;; set local var, have been hoisted
    ;; Start AddAsgn/MinAsgn
    global.get $var_a ;; get local var: var_a, have been hoisted
    i32.const 1 ;; push 1 on stack
    i32.add
    global.set $var_a ;; , have been hoisted
    global.get $var_a ;; , have been hoisted
    ;; End AddAsgn/MinAsgn
    global.get $var_a ;; get local var: var_a, have been hoisted
    i32.const 6 ;; push 6 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
       )
      )
    ;; Start AddAsgn/MinAsgn
    global.get $var_a ;; get local var: var_a, have been hoisted
    i32.const 1 ;; push 1 on stack
    i32.add
    global.set $var_a ;; , have been hoisted
    global.get $var_a ;; , have been hoisted
    ;; End AddAsgn/MinAsgn
    global.get $var_a ;; get local var: var_a, have been hoisted
    i32.const 7 ;; push 7 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
       )
      )
    ;; Start AddAsgn/MinAsgn
    global.get $var_a ;; get local var: var_a, have been hoisted
    i32.const 10 ;; push 10 on stack
    i32.add
    global.set $var_a ;; , have been hoisted
    global.get $var_a ;; , have been hoisted
    ;; End AddAsgn/MinAsgn
    global.get $var_a ;; get local var: var_a, have been hoisted
    i32.const 17 ;; push 17 on stack
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
    return ;; return the exit code
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)