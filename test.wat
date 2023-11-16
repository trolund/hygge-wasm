(module
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $Sptr (;0;) (mut i32) i32.const 0)
  (global $Sptr$0 (;1;) (mut i32) i32.const 0)
  (global $Sptr$1 (;2;) (mut i32) i32.const 0)
  (global $arr_ptr (;3;) (mut i32) i32.const 0)
  (global $exit_code (;4;) (mut i32) i32.const 0)
  (global $heap_base (;5;) i32 i32.const 17)
  (global $i (;6;) (mut i32) i32.const 0)
  (global $var_arr (;7;) (mut i32) i32.const 0)
  (global $var_str (;8;) (mut i32) i32.const 0)
  (global $var_tup (;9;) (mut i32) i32.const 0)
  (global $var_x (;10;) (mut i32) i32.const 0)
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    i32.const 42 ;; push 42 on stack
    global.set $var_x ;; set local var, have been hoisted
    ;; Start of let
    i32.const 3 ;; push 3 on stack
    i32.const 1 ;; put one on stack
    i32.le_s ;; check if length is <= 1
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of struct contructor
    i32.const 8 ;; size of struct
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
    i32.const 3 ;; push 3 on stack
    i32.store ;; store int field in memory
    global.get $Sptr ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    global.set $arr_ptr ;; set struct pointer var, have been hoisted
    global.get $arr_ptr ;; get struct pointer var, have been hoisted
    i32.const 3 ;; push 3 on stack
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    i32.store ;; store pointer to data
    i32.const 0
    global.set $i ;; , have been hoisted
    (block $loop_exit 
      (loop $loop_begin 
        i32.const 3 ;; push 3 on stack
        global.get $i ;; get i, have been hoisted
        i32.eq
        br_if $loop_exit
        ;; start of loop body
        global.get $arr_ptr ;; get struct pointer var, have been hoisted
        i32.load ;; load data pointer
        global.get $i ;; get index, have been hoisted
        i32.const 4 ;; byte offset
        i32.mul ;; multiply index with byte offset
        i32.add ;; add offset to base address
        i32.const 42 ;; push 42 on stack
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
    ;; start of struct contructor
    i32.const 12 ;; size of struct
    call $malloc ;; call malloc function
    global.set $Sptr$0 ;; set struct pointer var, have been hoisted
    global.get $Sptr$0 ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field _1
    i32.const 0 ;; leave pointer to string on stack
    i32.store ;; store int field in memory
    global.get $Sptr$0 ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field _2
    i32.const 40 ;; push 40 on stack
    i32.const 2 ;; push 2 on stack
    i32.add
    i32.store ;; store int field in memory
    global.get $Sptr$0 ;; get struct pointer var, have been hoisted
    i32.const 8 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field _3
    i32.const 1 ;; push true on stack
    i32.store ;; store int field in memory
    global.get $Sptr$0 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    global.set $var_tup ;; set local var, have been hoisted
    ;; Start of let
    ;; start of struct contructor
    i32.const 4 ;; size of struct
    call $malloc ;; call malloc function
    global.set $Sptr$1 ;; set struct pointer var, have been hoisted
    global.get $Sptr$1 ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 42 ;; push 42 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$1 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    global.set $var_str ;; set local var, have been hoisted
    i32.const 0 ;; push 0 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    i32.const 0 ;; push 0 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load ;; load data pointer
    i32.const 0 ;; push 0 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    global.get $var_str ;; get local var: var_str, have been hoisted
    global.get $var_tup ;; get local var: var_tup, have been hoisted
    i32.const 0 ;; push 0 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    i32.const 0 ;; push 0 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load ;; load data pointer
    i32.const 0 ;; push 0 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    global.get $var_x ;; get local var: var_x, have been hoisted
    i32.add
    ;; Start of field select
    global.get $var_str ;; get local var: var_str, have been hoisted
    i32.load offset=0 ;; load field: f
    ;; End of field select
    i32.add
    ;; Start of field select
    global.get $var_tup ;; get local var: var_tup, have been hoisted
    i32.load offset=4 ;; load field: _2
    ;; End of field select
    i32.add
    i32.store offset=4 ;; store int in struct
    global.get $var_tup ;; get local var: var_tup, have been hoisted
    i32.load offset=4 ;; load int from struct
    i32.store offset=0 ;; store int in struct
    global.get $var_str ;; get local var: var_str, have been hoisted
    i32.load offset=0 ;; load int from struct
    i32.store ;; store value in elem pos
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load ;; load data pointer
    i32.const 0 ;; push 0 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load int from elem pos
    global.set $var_x ;; set local var, have been hoisted
    global.get $var_x ;; set local var, have been hoisted
    drop
    global.get $var_x ;; get local var: var_x, have been hoisted
    i32.const 42 ;; push 42 on stack
    i32.const 4 ;; push 4 on stack
    i32.mul
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    i32.const 0 ;; push 0 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    i32.const 0 ;; push 0 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load ;; load data pointer
    i32.const 0 ;; push 0 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 42 ;; push 42 on stack
    i32.const 4 ;; push 4 on stack
    i32.mul
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; Start of field select
    global.get $var_str ;; get local var: var_str, have been hoisted
    i32.load offset=0 ;; load field: f
    ;; End of field select
    i32.const 42 ;; push 42 on stack
    i32.const 4 ;; push 4 on stack
    i32.mul
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; Start of field select
    global.get $var_tup ;; get local var: var_tup, have been hoisted
    i32.load offset=4 ;; load field: _2
    ;; End of field select
    i32.const 42 ;; push 42 on stack
    i32.const 4 ;; push 4 on stack
    i32.mul
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
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (data (i32.const 0) "\0c\00\00\00\05\00\00\00\05\00\00\00")
  (data (i32.const 12) "Hello")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)