(module
  (import "env" "malloc" (func $malloc (param i32) (result i32)
))
  (import "env" "writeS" (func $writeS (param i32) (param i32) 
))
  (memory (export "memory") 1)
  (data (i32.const 8) "should not print!")
  (global $Sptr (mut i32) i32.const 0)
  (global $arr_ptr (mut i32) i32.const 0)
  (global $exit_code (mut i32) i32.const 0)
  (global $heap_base i32 i32.const 42)
  (global $i (mut i32) i32.const 0)
  (global $var_arr (mut i32) i32.const 0)
  (global $var_i (mut i32) i32.const 0)
  (global $var_y (mut i32) i32.const 0)
  (func $_start  (result i32) ;; entry point of program (main function)
 
    ;; execution start here:
    ;; Start of let
    i32.const 2 ;; push 2 on stack
    i32.const 1 ;; put one on stack
    i32.le_s ;; check if length is <= 1
    (if (then
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
       )
      ) ;; check that length of array is bigger then 1 - if not return 42
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr ;; set struct pointer var, have been hoisted
    global.get $Sptr ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    global.get $Sptr ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field length
    i32.const 2 ;; push 2 on stack
    i32.store ;; store int field in memory
    global.get $Sptr ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    global.set $arr_ptr ;; set struct pointer var, have been hoisted
    global.get $arr_ptr ;; get struct pointer var, have been hoisted
    i32.const 2 ;; push 2 on stack
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    i32.store ;; store pointer to data
    i32.const 0
    global.set $i ;; , have been hoisted
    (block $loop_exit 
      (loop $loop_begin 
      i32.const 2 ;; push 2 on stack
      global.get $i ;; get i, have been hoisted
      i32.eq
      br_if $loop_exit
      ;; start of loop body
      global.get $arr_ptr ;; get struct pointer var, have been hoisted
      i32.load ;; load data pointer 4233
      global.get $i ;; get index, have been hoisted
      i32.const 4 ;; byte offset
      i32.mul ;; multiply index with byte offset
      i32.add ;; add offset to base address
      i32.const 1 ;; push 1 on stack
      i32.store ;; store value in elem pos
      ;; end of loop body
      global.get $i ;; get i, have been hoisted
      i32.const 1 ;; increment by 1
      i32.add ;; add 1 to i
      global.set $i ;; write to i, have been hoisted
      br $loop_begin

)

    )
    global.get $arr_ptr ;; leave pointer to allocated array struct on stack, have been hoisted
    global.set $var_arr ;; set local var, have been hoisted
    ;; Start of let
    i32.const 2 ;; push 2 on stack
    i32.const 3 ;; push 3 on stack
    i32.sub
    global.set $var_i ;; set local var, have been hoisted
    ;; Start of let
    global.get $var_i ;; get local var: var_i, have been hoisted
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if (then
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
       )
      ) ;; check that index is >= 0 - if not return 42
    global.get $var_i ;; get local var: var_i, have been hoisted
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.const 4 ;; offset of length field
    i32.add ;; add offset to base address
    i32.load ;; load length
    i32.ge_u ;; check if index is < length
    (if (then
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
       )
      ) ;; check that index is < length - if not return 42
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load ;; load data pointer
    global.get $var_i ;; get local var: var_i, have been hoisted
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    global.set $var_y ;; set local var, have been hoisted
    i32.const 0 ;; offset in memory
    i32.const 8 ;; data pointer to store
    i32.store ;; store size in bytes
    i32.const 4 ;; offset in memory
    i32.const 34 ;; length to store
    i32.store ;; store data pointer
    i32.const 0 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 0 ;; offset in memory
    i32.const 8 ;; data pointer to store
    i32.store ;; store size in bytes
    i32.const 4 ;; offset in memory
    i32.const 34 ;; length to store
    i32.store ;; store data pointer
    i32.const 0 ;; leave pointer to string on stack
    i32.const 4 ;; length offset
    i32.add ;; add offset to pointer
    i32.load ;; Load string length
    call $writeS ;; call host function
    ;; End of let
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)