(module
  (import "wasi_snapshot_preview1" "fd_read" (;0;) (func $fd_read (param i32) (param i32) (param i32) (param i32) (result i32)))
  (import "wasi_snapshot_preview1" "fd_write" (;1;) (func $fd_write (param i32) (param i32) (param i32) (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $heap_base (;1;) (mut i32) (i32.const 128))
  (global $var_x (;2;) (mut i32) (i32.const 0))
  (func $_start (;0;)   
    ;; execution start here:
    i32.const 1 ;; 1 for stdout
    i32.const 0 ;; leave pointer to string on stack
    i32.const 4 ;; offset to length
    i32.const 0 ;; leave pointer to string on stack
    i32.add ;; Load string length
    i32.const 0 ;; 1 for stdout
    call $fd_write ;; call host function
    drop
    ;; Start of let
    i32.const 0
    i32.const 45
    i32.const 1
    i32.const 49
    call $fd_read ;; call host function
    drop
    i32.const 45
    i32.load offset=8 ;; load string length
    global.set $var_x ;; set local var, have been promoted
    global.get $var_x ;; get local var: var_x, have been promoted
    i32.const 5 ;; push 5 on stack
    i32.gt_s
    if 
      i32.const 1 ;; 1 for stdout
      i32.const 57 ;; leave pointer to string on stack
      i32.const 4 ;; offset to length
      i32.const 57 ;; leave pointer to string on stack
      i32.add ;; Load string length
      i32.const 0 ;; 1 for stdout
      call $fd_write ;; call host function
      drop
    else
      i32.const 1 ;; 1 for stdout
      i32.const 88 ;; leave pointer to string on stack
      i32.const 4 ;; offset to length
      i32.const 88 ;; leave pointer to string on stack
      i32.add ;; Load string length
      i32.const 0 ;; 1 for stdout
      call $fd_write ;; call host function
      drop
    end
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (data (i32.const 0) "\0c\00\00\00\21\00\00\00\21\00\00\00")
  (data (i32.const 12) "Please insert two integer values:")
  (data (i32.const 45) "\35\00\00\00\01\00\00\00\00\00\00\00")
  (data (i32.const 57) "\45\00\00\00\13\00\00\00\13\00\00\00")
  (data (i32.const 69) "x is greater than 5")
  (data (i32.const 88) "\64\00\00\00\1c\00\00\00\1c\00\00\00")
  (data (i32.const 100) "x is less than or equal to 5")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)