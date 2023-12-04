(module
  (import "wasi_snapshot_preview1" "fd_write" (;0;) (func $fd_write (param i32) (param i32) (param i32) (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $heap_base (;1;) i32 (i32.const 58))
  (global $var_s (;2;) (mut i32) (i32.const 0))
  (global $var_s2 (;3;) (mut i32) (i32.const 0))
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)   
    ;; execution start here:
    ;; Start of let
    (global.set $var_s ;; set local var, have been hoisted
      (i32.const 0) ;; leave pointer to string on stack
    )
    (i32.const 1) ;; 1 for stdout
    (global.get $var_s) ;; get local var: var_s, have been hoisted
    (i32.add ;; Load string length
      (i32.const 4) ;; offset to length
      (global.get $var_s) ;; get local var: var_s, have been hoisted
    )
    (i32.const 0) ;; 1 for stdout
    (drop
      (call $fd_write) ;; call host function
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (i32.load offset=8
              (global.get $var_s) ;; get local var: var_s, have been hoisted
            )
            (i32.const 18) ;; push 18 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    ;; Start of let
    (global.set $var_s2 ;; set local var, have been hoisted
      (i32.const 30) ;; leave pointer to string on stack
    )
    (i32.const 1) ;; 1 for stdout
    (global.get $var_s2) ;; get local var: var_s2, have been hoisted
    (i32.add ;; Load string length
      (i32.const 4) ;; offset to length
      (global.get $var_s2) ;; get local var: var_s2, have been hoisted
    )
    (i32.const 0) ;; 1 for stdout
    (drop
      (call $fd_write) ;; call host function
    )
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (data (i32.const 0) "\0c\00\00\00\12\00\00\00\12\00\00\00")
  (data (i32.const 12) "hygge println test")
  (data (i32.const 30) "\2a\00\00\00\10\00\00\00\10\00\00\00")
  (data (i32.const 42) "hygge print test")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)