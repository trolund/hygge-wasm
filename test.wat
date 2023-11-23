(module
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $heap_base (;1;) i32 (i32.const 0))
  (global $var_a (;2;) (mut i32) (i32.const 0))
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)   
    ;; execution start here:
    ;; Start of let
    (global.set $var_a ;; set local var, have been hoisted
      (i32.const 50) ;; push 50 on stack
    )
    (global.set $var_a ;; set local var, have been hoisted
      (i32.rem_s
        (global.get $var_a) ;; get local var: var_a, have been hoisted
        (i32.const 3) ;; push 3 on stack
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (global.get $var_a) ;; get local var: var_a, have been hoisted
            (i32.const 2) ;; push 2 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (global.set $var_a ;; set local var, have been hoisted
      (i32.rem_s
        (global.get $var_a) ;; get local var: var_a, have been hoisted
        (i32.const 2) ;; push 2 on stack
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (global.get $var_a) ;; get local var: var_a, have been hoisted
            (i32.const 0) ;; push 0 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)