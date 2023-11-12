(module
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) i32.const 0)
  (global $heap_base (;1;) i32 i32.const 0)
  (global $var_res (;2;) (mut i32) i32.const 0)
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    i32.const 1 ;; push 1 on stack
    i32.const 2 ;; push 2 on stack
    i32.const 3 ;; push 3 on stack
    i32.const 4 ;; push 4 on stack
    i32.const 5 ;; push 5 on stack
    i32.const 6 ;; push 6 on stack
    i32.const 7 ;; push 7 on stack
    i32.const 8 ;; push 8 on stack
    i32.const 9 ;; push 9 on stack
    i32.const 10 ;; push 10 on stack
    i32.const 11 ;; push 11 on stack
    i32.const 12 ;; push 12 on stack
    i32.const 13 ;; push 13 on stack
    i32.const 14 ;; push 14 on stack
    i32.const 15 ;; push 15 on stack
    i32.const 16 ;; push 16 on stack
    i32.const 17 ;; push 17 on stack
    i32.const 18 ;; push 18 on stack
    i32.const 19 ;; push 19 on stack
    i32.add
    i32.add
    i32.add
    i32.add
    i32.add
    i32.add
    i32.add
    i32.add
    i32.add
    i32.add
    i32.add
    i32.add
    i32.add
    i32.add
    i32.add
    i32.add
    i32.add
    i32.add
    global.set $var_res ;; set local var, have been hoisted
    global.get $var_res ;; get local var: var_res, have been hoisted
    i32.const 190 ;; push 190 on stack
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