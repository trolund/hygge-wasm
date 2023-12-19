(module
  (import "env" "writeInt" (;0;) (func $writeInt (param i32) (param i32) ))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $heap_base (;1;) i32 (i32.const 0))
  (global $var_i (;2;) (mut i32) (i32.const 0))
  (global $var_n (;3;) (mut i32) (i32.const 0))
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)   
    ;; execution start here:
    ;; Start of let
    (global.set $var_i ;; set local var, have been hoisted
      (i32.const 0) ;; push 0 on stack
    )
    ;; Start of let
    (global.set $var_n ;; set local var, have been hoisted
      (i32.const 10) ;; push 10 on stack
    )
    (drop ;; drop value of init node
      (global.set $var_i ;; set local var, have been hoisted
        (i32.const 0) ;; push 0 on stack
      )
      (global.get $var_i) ;; set local var, have been hoisted
    )
    (block $loop_exit 
      (loop $loop_begin 
        (br_if $loop_exit ;; if false break
          (i32.eqz ;; evaluate loop condition
            (i32.lt_s
              (global.get $var_i) ;; get local var: var_i, have been hoisted
              (global.get $var_n) ;; get local var: var_n, have been hoisted
            )
          )
        )
        (global.get $var_i) ;; get local var: var_i, have been hoisted
        (i32.const 1) ;; newline
        (call $writeInt) ;; call host function
        (drop ;; drop value of subtree
          (drop
            (global.get $var_i) ;; get local var: var_i, have been hoisted
            (global.set $var_i ;; set local var, have been hoisted
              (i32.add
                (global.get $var_i) ;; get local var: var_i, have been hoisted
                (i32.const 1) ;; push 1 on stack
              )
            )
            (global.get $var_i) ;; set local var, have been hoisted
          )
        )
        (br $loop_begin) ;; jump to beginning of loop
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (global.get $var_i) ;; get local var: var_i, have been hoisted
            (global.get $var_n) ;; get local var: var_n, have been hoisted
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
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)