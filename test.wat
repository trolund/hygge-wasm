(module
  (import "env" "malloc" (func $malloc (param i32) (result i32)
))
  (import "env" "writeInt" (func $writeInt (param i32) 
))
  (import "env" "writeS" (func $writeS (param i32) (param i32) 
))
  (memory (export "memory") 1)
  (data (i32.const 8) "Done!")
  (global $Sptr (mut i32) i32.const 0)
  (global $Sptr$0 (mut i32) i32.const 0)
  (global $Sptr$5 (mut i32) i32.const 0)
  (global $Sptr$6 (mut i32) i32.const 0)
  (global $arr_ptr (mut i32) i32.const 0)
  (global $arr_ptr$1 (mut i32) i32.const 0)
  (global $arr_ptr$7 (mut i32) i32.const 0)
  (global $exit_code (mut i32) i32.const 0)
  (global $heap_base i32 i32.const 18)
  (global $i (mut i32) i32.const 0)
  (global $i$10 (mut i32) i32.const 0)
  (global $i$4 (mut i32) i32.const 0)
  (global $var_col (mut i32) i32.const 0)
  (global $var_i (mut i32) i32.const 0)
  (global $var_n (mut i32) i32.const 0)
  (global $var_outter (mut i32) i32.const 0)
  (global $var_res (mut i32) i32.const 0)
  (global $var_row (mut i32) i32.const 0)
  (global $var_temp (mut i32) i32.const 0)
  (func $_start  (result i32) ;; entry point of program (main function)
 
    ;; execution start here:
    ;; Start of let
    i32.const 10 ;; push 10 on stack
    global.set $var_n ;; set local var, have been hoisted
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
      i32.const 0 ;; push 0 on stack
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
    global.set $var_temp ;; set local var, have been hoisted
    ;; Start of let
    global.get $var_n ;; get local var: var_n, have been hoisted
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
    global.set $Sptr$0 ;; set struct pointer var, have been hoisted
    global.get $Sptr$0 ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$0 ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field length
    global.get $var_n ;; get local var: var_n, have been hoisted
    i32.store ;; store int field in memory
    global.get $Sptr$0 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    global.set $arr_ptr$1 ;; set struct pointer var, have been hoisted
    global.get $arr_ptr$1 ;; get struct pointer var, have been hoisted
    global.get $var_n ;; get local var: var_n, have been hoisted
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    i32.store ;; store pointer to data
    i32.const 0
    global.set $i$4 ;; , have been hoisted
    (block $loop_exit$2 
      (loop $loop_begin$3 
      global.get $var_n ;; get local var: var_n, have been hoisted
      global.get $i$4 ;; get i, have been hoisted
      i32.eq
      br_if $loop_exit$2
      ;; start of loop body
      global.get $arr_ptr$1 ;; get struct pointer var, have been hoisted
      i32.load ;; load data pointer 4233
      global.get $i$4 ;; get index, have been hoisted
      i32.const 4 ;; byte offset
      i32.mul ;; multiply index with byte offset
      i32.add ;; add offset to base address
      global.get $var_temp ;; get local var: var_temp, have been hoisted
      i32.store ;; store value in elem pos
      ;; end of loop body
      global.get $i$4 ;; get i, have been hoisted
      i32.const 1 ;; increment by 1
      i32.add ;; add 1 to i
      global.set $i$4 ;; write to i, have been hoisted
      br $loop_begin$3

)

    )
    global.get $arr_ptr$1 ;; leave pointer to allocated array struct on stack, have been hoisted
    global.set $var_col ;; set local var, have been hoisted
    ;; Start of let
    ;; start of struct contructor
    i32.const 1 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr$5 ;; set struct pointer var, have been hoisted
    global.get $Sptr$5 ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field value
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$5 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    global.set $var_i ;; set local var, have been hoisted
    (block $loop_exit$11 
      (loop $loop_begin$12 
      ;; Start of field select
      global.get $var_i ;; get local var: var_i, have been hoisted
      i32.load offset=0 ;; load field: value
      ;; End of field select
      ;; start array length node
      global.get $var_col ;; get local var: var_col, have been hoisted
      i32.const 4 ;; offset of length field
      i32.add ;; add offset to base address
      i32.load ;; load length
      ;; end array length node
      i32.lt_s
      i32.eqz
      br_if $loop_exit$11
      ;; Start of let
      global.get $var_n ;; get local var: var_n, have been hoisted
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
      global.set $Sptr$6 ;; set struct pointer var, have been hoisted
      global.get $Sptr$6 ;; get struct pointer var, have been hoisted
      i32.const 0 ;; push field offset to stack
      i32.add ;; add offset to base address
      ;; init field data
      i32.const 0 ;; push 0 on stack
      i32.store ;; store int field in memory
      global.get $Sptr$6 ;; get struct pointer var, have been hoisted
      i32.const 4 ;; push field offset to stack
      i32.add ;; add offset to base address
      ;; init field length
      global.get $var_n ;; get local var: var_n, have been hoisted
      i32.store ;; store int field in memory
      global.get $Sptr$6 ;; push struct address to stack, have been hoisted
      ;; end of struct contructor
      global.set $arr_ptr$7 ;; set struct pointer var, have been hoisted
      global.get $arr_ptr$7 ;; get struct pointer var, have been hoisted
      global.get $var_n ;; get local var: var_n, have been hoisted
      i32.const 4 ;; 4 bytes
      i32.mul ;; multiply length with 4 to get size
      call $malloc ;; call malloc function
      i32.store ;; store pointer to data
      i32.const 0
      global.set $i$10 ;; , have been hoisted
      (block $loop_exit$8 
      (loop $loop_begin$9 
      global.get $var_n ;; get local var: var_n, have been hoisted
      global.get $i$10 ;; get i, have been hoisted
      i32.eq
      br_if $loop_exit$8
      ;; start of loop body
      global.get $arr_ptr$7 ;; get struct pointer var, have been hoisted
      i32.load ;; load data pointer 4233
      global.get $i$10 ;; get index, have been hoisted
      i32.const 4 ;; byte offset
      i32.mul ;; multiply index with byte offset
      i32.add ;; add offset to base address
      i32.const 42 ;; push 42 on stack
      ;; Start of field select
      global.get $var_i ;; get local var: var_i, have been hoisted
      i32.load offset=0 ;; load field: value
      ;; End of field select
      i32.add
      i32.store ;; store value in elem pos
      ;; end of loop body
      global.get $i$10 ;; get i, have been hoisted
      i32.const 1 ;; increment by 1
      i32.add ;; add 1 to i
      global.set $i$10 ;; write to i, have been hoisted
      br $loop_begin$9

)

    )
      global.get $arr_ptr$7 ;; leave pointer to allocated array struct on stack, have been hoisted
      global.set $var_row ;; set local var, have been hoisted
      ;; Start of field select
      global.get $var_i ;; get local var: var_i, have been hoisted
      i32.load offset=0 ;; load field: value
      ;; End of field select
      call $writeInt ;; call host function
      ;; start array length node
      global.get $var_row ;; get local var: var_row, have been hoisted
      i32.const 4 ;; offset of length field
      i32.add ;; add offset to base address
      i32.load ;; load length
      ;; end array length node
      call $writeInt ;; call host function
      ;; Start of field select
      global.get $var_i ;; get local var: var_i, have been hoisted
      i32.load offset=0 ;; load field: value
      ;; End of field select
      i32.const 0 ;; put zero on stack
      i32.lt_s ;; check if index is >= 0
      (if (then
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
       )
      ) ;; check that index is >= 0 - if not return 42
      ;; Start of field select
      global.get $var_i ;; get local var: var_i, have been hoisted
      i32.load offset=0 ;; load field: value
      ;; End of field select
      global.get $var_col ;; get local var: var_col, have been hoisted
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
      global.get $var_col ;; get local var: var_col, have been hoisted
      i32.load ;; load data pointer
      ;; Start of field select
      global.get $var_i ;; get local var: var_i, have been hoisted
      i32.load offset=0 ;; load field: value
      ;; End of field select
      i32.const 4 ;; byte offset
      i32.mul ;; multiply index with byte offset
      i32.add ;; add offset to base address
      global.get $var_row ;; get local var: var_row, have been hoisted
      i32.store ;; store value in elem pos
      global.get $var_i ;; get local var: var_i, have been hoisted
      ;; Start of field select
      global.get $var_i ;; get local var: var_i, have been hoisted
      i32.load offset=0 ;; load field: value
      ;; End of field select
      i32.const 1 ;; push 1 on stack
      i32.add
      i32.store offset=0 ;; store int in struct
      global.get $var_i ;; get local var: var_i, have been hoisted
      i32.load offset=0 ;; load int from struct
      ;; End of let
      br $loop_begin$12

)
      nop

    )
    global.get $var_i ;; get local var: var_i, have been hoisted
    i32.const 0 ;; push 0 on stack
    i32.store offset=0 ;; store int in struct
    global.get $var_i ;; get local var: var_i, have been hoisted
    i32.load offset=0 ;; load int from struct
    (block $loop_exit$13 
      (loop $loop_begin$14 
      ;; Start of field select
      global.get $var_i ;; get local var: var_i, have been hoisted
      i32.load offset=0 ;; load field: value
      ;; End of field select
      ;; start array length node
      global.get $var_col ;; get local var: var_col, have been hoisted
      i32.const 4 ;; offset of length field
      i32.add ;; add offset to base address
      i32.load ;; load length
      ;; end array length node
      i32.lt_s
      i32.eqz
      br_if $loop_exit$13
      ;; Start of let
      ;; Start of field select
      global.get $var_i ;; get local var: var_i, have been hoisted
      i32.load offset=0 ;; load field: value
      ;; End of field select
      i32.const 0 ;; put zero on stack
      i32.lt_s ;; check if index is >= 0
      (if (then
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
       )
      ) ;; check that index is >= 0 - if not return 42
      ;; Start of field select
      global.get $var_i ;; get local var: var_i, have been hoisted
      i32.load offset=0 ;; load field: value
      ;; End of field select
      global.get $var_col ;; get local var: var_col, have been hoisted
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
      global.get $var_col ;; get local var: var_col, have been hoisted
      i32.load ;; load data pointer
      ;; Start of field select
      global.get $var_i ;; get local var: var_i, have been hoisted
      i32.load offset=0 ;; load field: value
      ;; End of field select
      i32.const 4 ;; byte offset
      i32.mul ;; multiply index with byte offset
      i32.add ;; add offset to base address
      i32.load ;; load value
      ;; end array element access node
      global.set $var_outter ;; set local var, have been hoisted
      ;; Start of let
      i32.const 0 ;; push 0 on stack
      i32.const 0 ;; put zero on stack
      i32.lt_s ;; check if index is >= 0
      (if (then
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
       )
      ) ;; check that index is >= 0 - if not return 42
      i32.const 0 ;; push 0 on stack
      global.get $var_outter ;; get local var: var_outter, have been hoisted
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
      global.get $var_outter ;; get local var: var_outter, have been hoisted
      i32.load ;; load data pointer
      i32.const 0 ;; push 0 on stack
      i32.const 4 ;; byte offset
      i32.mul ;; multiply index with byte offset
      i32.add ;; add offset to base address
      i32.load ;; load value
      ;; end array element access node
      global.set $var_res ;; set local var, have been hoisted
      global.get $var_res ;; get local var: var_res, have been hoisted
      call $writeInt ;; call host function
      global.get $var_res ;; get local var: var_res, have been hoisted
      i32.const 42 ;; push 42 on stack
      ;; Start of field select
      global.get $var_i ;; get local var: var_i, have been hoisted
      i32.load offset=0 ;; load field: value
      ;; End of field select
      i32.add
      i32.eq
      i32.eqz ;; invert assertion
      (if (then
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
       )
      )
      global.get $var_i ;; get local var: var_i, have been hoisted
      ;; Start of field select
      global.get $var_i ;; get local var: var_i, have been hoisted
      i32.load offset=0 ;; load field: value
      ;; End of field select
      i32.const 1 ;; push 1 on stack
      i32.add
      i32.store offset=0 ;; store int in struct
      global.get $var_i ;; get local var: var_i, have been hoisted
      i32.load offset=0 ;; load int from struct
      ;; End of let
      ;; End of let
      br $loop_begin$14

)
      nop

    )
    i32.const 0 ;; offset in memory
    i32.const 8 ;; data pointer to store
    i32.store ;; store size in bytes
    i32.const 4 ;; offset in memory
    i32.const 10 ;; length to store
    i32.store ;; store data pointer
    i32.const 0 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 0 ;; offset in memory
    i32.const 8 ;; data pointer to store
    i32.store ;; store size in bytes
    i32.const 4 ;; offset in memory
    i32.const 10 ;; length to store
    i32.store ;; store data pointer
    i32.const 0 ;; leave pointer to string on stack
    i32.const 4 ;; length offset
    i32.add ;; add offset to pointer
    i32.load ;; Load string length
    call $writeS ;; call host function
    ;; End of let
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