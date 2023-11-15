(module
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) i32.const 0)
  (global $heap_base (;1;) i32 i32.const 0)
  (global $var_x (;2;) (mut i32) i32.const 0)
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    i32.const 5 ;; push 5 on stack
    i32.const 10 ;; push 10 on stack
    i32.add
    i32.const -1 ;; push -1 on stack
    i32.mul ;; multiply with -1
    global.set $var_x ;; set local var, have been hoisted
    global.get $var_x ;; get local var: var_x, have been hoisted
    i32.const 0 ;; push 0 on stack
    i32.lt_s
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_x ;; get local var: var_x, have been hoisted
    i32.const -15 ;; push -15 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
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
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)