(module
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $Sptr (;0;) (mut i32) i32.const 0)
  (global $Sptr$0 (;1;) (mut i32) i32.const 0)
  (global $arr_ptr (;2;) (mut i32) i32.const 0)
  (global $arr_slice_ptr (;3;) (mut i32) i32.const 0)
  (global $exit_code (;4;) (mut i32) i32.const 0)
  (global $heap_base (;5;) i32 i32.const 0)
  (global $i (;6;) (mut i32) i32.const 0)
  (global $var_arr (;7;) (mut i32) i32.const 0)
  (global $var_sliced (;8;) (mut i32) i32.const 0)
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    i32.const 2 ;; push 2 on stack
    i32.const 2 ;; push 2 on stack
    i32.add
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
    i32.const 2 ;; push 2 on stack
    i32.add
    i32.store ;; store int field in memory
    global.get $Sptr ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    global.set $arr_ptr ;; set struct pointer var, have been hoisted
    global.get $arr_ptr ;; get struct pointer var, have been hoisted
    i32.const 2 ;; push 2 on stack
    i32.const 2 ;; push 2 on stack
    i32.add
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    i32.store ;; store pointer to data
    i32.const 0
    global.set $i ;; , have been hoisted
    (block $loop_exit 
      (loop $loop_begin 
        i32.const 2 ;; push 2 on stack
        i32.const 2 ;; push 2 on stack
        i32.add
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
        i32.const 40 ;; push 40 on stack
        i32.const 2 ;; push 2 on stack
        i32.add
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
    ;; start array slice
    i32.const 5 ;; push 5 on stack
    i32.const 1 ;; push 1 on stack
    i32.sub ;; subtract end from start
    i32.const 1 ;; put one on stack
    i32.lt_u ;; check if difference is < 1
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    i32.const 5 ;; push 5 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.gt_u ;; check if end is < length
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    i32.const 1 ;; push 1 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if start is >= 0
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    i32.const 1 ;; push 1 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_u ;; check if start is < length
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
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
    i32.const 5 ;; push 5 on stack
    i32.const 1 ;; push 1 on stack
    i32.sub
    i32.store ;; store int field in memory
    global.get $Sptr$0 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    global.set $arr_slice_ptr ;; set struct pointer var, have been hoisted
    global.get $arr_slice_ptr ;; get struct pointer var, have been hoisted
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load ;; Load data pointer from array struct
    i32.const 1 ;; push 1 on stack
    i32.const 4 ;; offset of data field
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.store ;; store pointer to data
    global.get $arr_slice_ptr ;; leave pointer to allocated array struct on stack, have been hoisted
    ;; end array slice
    global.set $var_sliced ;; set local var, have been hoisted
    global.get $var_sliced ;; get local var: var_sliced, have been hoisted
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