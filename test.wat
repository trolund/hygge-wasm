(module
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $Sptr (;0;) (mut i32) i32.const 0)
  (global $exit_code (;1;) (mut i32) i32.const 0)
  (global $heap_base (;2;) i32 i32.const 0)
  (global $var_g (;3;) (mut i32) i32.const 0)
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)  (result i32) ;; entry point of program (main function) 
    ;; execution start here:
    ;; Start of let
    ;; start of struct contructor
    i32.const 1 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr ;; set struct pointer var, have been hoisted
    global.get $Sptr ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field value
    i32.const 142 ;; push 142 on stack
    i32.store ;; store int field in memory
    global.get $Sptr ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    global.set $var_g ;; set local var, have been hoisted
    ;; Start of field select
    global.get $var_g ;; get local var: var_g, have been hoisted
    i32.load offset=0 ;; load field: value
    ;; End of field select
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "g" (global $var_g))
  (export "heap_base_ptr" (global $heap_base))
)