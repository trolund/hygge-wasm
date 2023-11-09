(module
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) i32.const 0)
  (global $heap_base (;1;) i32 i32.const 56)
  (global $var_s (;2;) (mut i32) i32.const 0)
  (global $var_s0 (;3;) (mut i32) i32.const 0)
  (global $var_s1 (;4;) (mut i32) i32.const 0)
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    i32.const 0 ;; leave pointer to string on stack
    global.set $var_s ;; set local var, have been hoisted
    ;; Start of let
    i32.const 23 ;; leave pointer to string on stack
    global.set $var_s0 ;; set local var, have been hoisted
    ;; Start of let
    i32.const 40 ;; leave pointer to string on stack
    global.set $var_s1 ;; set local var, have been hoisted
    global.get $var_s1 ;; get local var: var_s1, have been hoisted
    i32.load offset=8 ;; load string length
    i32.const 2 ;; push 2 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_s0 ;; get local var: var_s0, have been hoisted
    i32.load offset=8 ;; load string length
    i32.const 5 ;; push 5 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_s ;; get local var: var_s, have been hoisted
    i32.load offset=8 ;; load string length
    i32.const 11 ;; push 11 on stack
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
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (data (i32.const 0) "\0c\00\00\00\0b\00\00\00\0b\00\00\00")
  (data (i32.const 12) "hello world")
  (data (i32.const 23) "\23\00\00\00\05\00\00\00\05\00\00\00")
  (data (i32.const 35) "hello")
  (data (i32.const 40) "\34\00\00\00\04\00\00\00\02\00\00\00")
  (data (i32.const 52) "🏁")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)