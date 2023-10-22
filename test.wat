(module
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $Sptr (;0;) (mut i32) i32.const 0)
  (global $exit_code (;1;) (mut i32) i32.const 0)
  (global $heap_base (;2;) i32 i32.const 48)
  (global $var_s (;3;) (mut i32) i32.const 0)
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    i32.const 1
    (if (result i32)
      (then
        i32.const 1
      )
      (else
        i32.const 0
      )
    )
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; Start of let
    ;; start of struct contructor
    i32.const 4 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr ;; set struct pointer var, have been hoisted
    global.get $Sptr ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field name
    i32.const 0 ;; leave pointer to string on stack
    i32.store ;; store int field in memory
    global.get $Sptr ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field area
    f32.const 3.000000
    f32.const 4.000000
    f32.mul
    f32.store ;; store float field (area) in memory
    global.get $Sptr ;; get struct pointer var, have been hoisted
    i32.const 8 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field width
    i32.const 100 ;; push 100 on stack
    i32.store ;; store int field in memory
    global.get $Sptr ;; get struct pointer var, have been hoisted
    i32.const 12 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field height
    i32.const 200 ;; push 200 on stack
    i32.store ;; store int field in memory
    global.get $Sptr ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    global.set $var_s ;; set local var, have been hoisted
    i32.const 1
    (if (result i32)
      (then
        ;; Start of field select
        global.get $var_s ;; get local var: var_s, have been hoisted
        i32.load offset=0 ;; load field: name
        ;; End of field select
      )
      (else
        i32.const 26 ;; leave pointer to string on stack
      )
    )
    i32.load offset=4 ;; load string length
    i32.const 2 ;; push 2 on stack
    i32.div_s ;; divide by 2
    i32.const 9 ;; push 9 on stack
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
  (data (i32.const 0) "\08\00\00\00\12\00\00\00")
  (data (i32.const 8) "Rectangle")
  (data (i32.const 26) "\22\00\00\00\0e\00\00\00")
  (data (i32.const 34) "unknown")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)