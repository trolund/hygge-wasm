(module
  (import "env" "writeS" (;0;) (func $writeS (param i32) (param i32) (param i32) ))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $heap_base (;1;) i32 (i32.const 116))
  (global $var_s (;2;) (mut i32) (i32.const 0))
  (global $var_s2 (;3;) (mut i32) (i32.const 0))
  (global $var_s3 (;4;) (mut i32) (i32.const 0))
  (global $var_s4 (;5;) (mut i32) (i32.const 0))
  (func $_start (;0;)   
    ;; execution start here:
    ;; Start of let
    i32.const 0 ;; leave pointer to string on stack
    global.set $var_s ;; set local var, have been promoted
    global.get $var_s ;; get local var: var_s, have been promoted
    i32.load ;; Load string pointer
    global.get $var_s ;; get local var: var_s, have been promoted
    i32.load offset=4 ;; Load string length
    i32.const 1 ;; newline
    call $writeS ;; call host function
    global.get $var_s ;; get local var: var_s, have been promoted
    i32.load offset=8 ;; load string length
    i32.const 18 ;; push 18 on stack
    i32.eq ;; equality check
    i32.eqz ;; invert assertion
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    ;; Start of let
    i32.const 30 ;; leave pointer to string on stack
    global.set $var_s2 ;; set local var, have been promoted
    global.get $var_s2 ;; get local var: var_s2, have been promoted
    i32.load ;; Load string pointer
    global.get $var_s2 ;; get local var: var_s2, have been promoted
    i32.load offset=4 ;; Load string length
    i32.const 0 ;; newline
    call $writeS ;; call host function
    ;; Start of let
    i32.const 58 ;; leave pointer to string on stack
    global.set $var_s3 ;; set local var, have been promoted
    global.get $var_s3 ;; get local var: var_s3, have been promoted
    i32.load ;; Load string pointer
    global.get $var_s3 ;; get local var: var_s3, have been promoted
    i32.load offset=4 ;; Load string length
    i32.const 0 ;; newline
    call $writeS ;; call host function
    global.get $var_s3 ;; get local var: var_s3, have been promoted
    i32.load offset=8 ;; load string length
    i32.const 25 ;; push 25 on stack
    i32.eq ;; equality check
    i32.eqz ;; invert assertion
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    ;; Start of let
    i32.const 101 ;; leave pointer to string on stack
    global.set $var_s4 ;; set local var, have been promoted
    global.get $var_s4 ;; get local var: var_s4, have been promoted
    i32.load ;; Load string pointer
    global.get $var_s4 ;; get local var: var_s4, have been promoted
    i32.load offset=4 ;; Load string length
    i32.const 0 ;; newline
    call $writeS ;; call host function
    ;; End of let
    ;; End of let
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (data (i32.const 0) "\0c\00\00\00\12\00\00\00\12\00\00\00")
  (data (i32.const 12) "hygge println test")
  (data (i32.const 30) "\2a\00\00\00\10\00\00\00\10\00\00\00")
  (data (i32.const 42) "hygge print test")
  (data (i32.const 58) "\46\00\00\00\1f\00\00\00\19\00\00\00")
  (data (i32.const 70) "𝄞𝄞𝄞 - hygge print test")
  (data (i32.const 101) "\71\00\00\00\03\00\00\00\01\00\00\00")
  (data (i32.const 113) "✅")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)