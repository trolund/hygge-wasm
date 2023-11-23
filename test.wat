(module
  (type $i32_i32_i32_=>_i32 (;0;) (func (param i32) (param i32) (param i32) (result i32)))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (import "env" "readInt" (;1;) (func $readInt  (result i32)))
  (import "env" "writeInt" (;2;) (func $writeInt (param i32) ))
  (import "env" "writeS" (;3;) (func $writeS (param i32) (param i32) ))
  (memory (;0;) (export "memory") 1)
  (global $Sptr (;0;) (mut i32) (i32.const 0))
  (global $Sptr$2 (;1;) (mut i32) (i32.const 0))
  (global $Sptr$5 (;2;) (mut i32) (i32.const 0))
  (global $arr_ptr (;3;) (mut i32) (i32.const 0))
  (global $arr_slice_ptr (;4;) (mut i32) (i32.const 0))
  (global $exit_code (;5;) (mut i32) (i32.const 0))
  (global $fun_f*ptr (;6;) (mut i32) (i32.const 38))
  (global $heap_base (;7;) i32 (i32.const 134))
  (global $i (;8;) (mut i32) (i32.const 0))
  (global $match_var__ (;9;) (mut i32) (i32.const 0))
  (global $match_var_v (;10;) (mut i32) (i32.const 0))
  (global $var_arr (;11;) (mut i32) (i32.const 0))
  (global $var_o (;12;) (mut i32) (i32.const 0))
  (global $var_sliced (;13;) (mut i32) (i32.const 0))
  (global $var_x (;14;) (mut i32) (i32.const 0))
  (table $func_table (;0;) 1 funcref)
  (elem (i32.const 0) (;0;) $fun_f)
  (func $_start (;0;)   
    ;; execution start here:
    ;; Start of let
    call $readInt ;; call host function
    global.set $var_x ;; set local var, have been hoisted
    i32.const 0 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 0 ;; leave pointer to string on stack
    i32.load offset=4 ;; Load string length
    call $writeS ;; call host function
    ;; Start of let
    global.get $var_x ;; get local var: var_x, have been hoisted
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
    ;; init field (data)
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    global.get $Sptr ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field (length)
    global.get $var_x ;; get local var: var_x, have been hoisted
    i32.store ;; store int field in memory
    global.get $Sptr ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    global.set $arr_ptr ;; set struct pointer var, have been hoisted
    global.get $arr_ptr ;; get struct pointer var, have been hoisted
    global.get $var_x ;; get local var: var_x, have been hoisted
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    i32.store ;; store pointer to data
    i32.const 0
    global.set $i ;; , have been hoisted
    (block $loop_exit 
      (loop $loop_begin 
        global.get $var_x ;; get local var: var_x, have been hoisted
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
    global.set $var_arr ;; set local var, have been hoisted
    ;; Load expression to be applied as a function
    global.get $fun_f*ptr ;; get global var: fun_f*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    global.get $var_x ;; get local var: var_x, have been hoisted
    i32.const 2 ;; push 2 on stack
    i32.div_s
    global.get $fun_f*ptr ;; get global var: fun_f*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    drop
    i32.const 0 ;; push 0 on stack
    global.set $var_x ;; set local var, have been hoisted
    global.get $var_x ;; get local var: var_x, have been hoisted
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_x ;; get local var: var_x, have been hoisted
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
    global.get $var_x ;; get local var: var_x, have been hoisted
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    call $writeInt ;; call host function
    global.get $var_x ;; get local var: var_x, have been hoisted
    i32.const 1 ;; push 1 on stack
    i32.add
    global.set $var_x ;; set local var, have been hoisted
    (block $loop_exit$0 
      (loop $loop_begin$1 
        global.get $var_x ;; get local var: var_x, have been hoisted
        ;; start array length node
        global.get $var_arr ;; get local var: var_arr, have been hoisted
        i32.load offset=4 ;; load length
        ;; end array length node
        i32.lt_s
        i32.eqz
        br_if $loop_exit$0
        global.get $var_x ;; get local var: var_x, have been hoisted
        i32.const 0 ;; put zero on stack
        i32.lt_s ;; check if index is >= 0
        (if 
          (then
            i32.const 42 ;; error exit code push to stack
            global.set $exit_code ;; set exit code
            unreachable ;; exit program
          )
        )
        global.get $var_x ;; get local var: var_x, have been hoisted
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
        global.get $var_x ;; get local var: var_x, have been hoisted
        i32.const 4 ;; byte offset
        i32.mul ;; multiply index with byte offset
        i32.add ;; add offset to base address
        i32.load ;; load value
        ;; end array element access node
        call $writeInt ;; call host function
        global.get $var_x ;; get local var: var_x, have been hoisted
        i32.const 1 ;; push 1 on stack
        i32.add
        global.set $var_x ;; set local var, have been hoisted
        global.get $var_x ;; set local var, have been hoisted
        br $loop_begin$1
      )
    )
    i32.const 42 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 42 ;; leave pointer to string on stack
    i32.load offset=4 ;; Load string length
    call $writeS ;; call host function
    ;; Start of let
    ;; start array slice
    ;; start array length node
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    ;; end array length node
    global.get $var_x ;; get local var: var_x, have been hoisted
    i32.const 2 ;; push 2 on stack
    i32.div_s
    i32.sub ;; subtract end from start
    i32.const 1 ;; put one on stack
    i32.lt_s ;; check if difference is < 1
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start array length node
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    ;; end array length node
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.gt_s ;; check if end is < length
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_x ;; get local var: var_x, have been hoisted
    i32.const 2 ;; push 2 on stack
    i32.div_s
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if start is >= 0
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_x ;; get local var: var_x, have been hoisted
    i32.const 2 ;; push 2 on stack
    i32.div_s
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if start is < length
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
    global.set $Sptr$2 ;; set struct pointer var, have been hoisted
    global.get $Sptr$2 ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field (data)
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$2 ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field (length)
    ;; start array length node
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    ;; end array length node
    global.get $var_x ;; get local var: var_x, have been hoisted
    i32.const 2 ;; push 2 on stack
    i32.div_s
    i32.sub
    i32.store ;; store int field in memory
    global.get $Sptr$2 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    global.set $arr_slice_ptr ;; set struct pointer var, have been hoisted
    global.get $arr_slice_ptr ;; get struct pointer var, have been hoisted
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load ;; Load data pointer from array struct
    global.get $var_x ;; get local var: var_x, have been hoisted
    i32.const 2 ;; push 2 on stack
    i32.div_s
    i32.const 4 ;; offset of data field
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.store ;; store pointer to data
    global.get $arr_slice_ptr ;; leave pointer to allocated array struct on stack, have been hoisted
    ;; end array slice
    global.set $var_sliced ;; set local var, have been hoisted
    i32.const 0 ;; push 0 on stack
    global.set $var_x ;; set local var, have been hoisted
    global.get $var_x ;; get local var: var_x, have been hoisted
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_x ;; get local var: var_x, have been hoisted
    global.get $var_sliced ;; get local var: var_sliced, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_sliced ;; get local var: var_sliced, have been hoisted
    i32.load ;; load data pointer
    global.get $var_x ;; get local var: var_x, have been hoisted
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    call $writeInt ;; call host function
    global.get $var_x ;; get local var: var_x, have been hoisted
    i32.const 1 ;; push 1 on stack
    i32.add
    global.set $var_x ;; set local var, have been hoisted
    (block $loop_exit$3 
      (loop $loop_begin$4 
        global.get $var_x ;; get local var: var_x, have been hoisted
        ;; start array length node
        global.get $var_sliced ;; get local var: var_sliced, have been hoisted
        i32.load offset=4 ;; load length
        ;; end array length node
        i32.lt_s
        i32.eqz
        br_if $loop_exit$3
        global.get $var_x ;; get local var: var_x, have been hoisted
        i32.const 0 ;; put zero on stack
        i32.lt_s ;; check if index is >= 0
        (if 
          (then
            i32.const 42 ;; error exit code push to stack
            global.set $exit_code ;; set exit code
            unreachable ;; exit program
          )
        )
        global.get $var_x ;; get local var: var_x, have been hoisted
        global.get $var_sliced ;; get local var: var_sliced, have been hoisted
        i32.load offset=4 ;; load length
        i32.ge_s ;; check if index is < length
        (if 
          (then
            i32.const 42 ;; error exit code push to stack
            global.set $exit_code ;; set exit code
            unreachable ;; exit program
          )
        )
        global.get $var_sliced ;; get local var: var_sliced, have been hoisted
        i32.load ;; load data pointer
        global.get $var_x ;; get local var: var_x, have been hoisted
        i32.const 4 ;; byte offset
        i32.mul ;; multiply index with byte offset
        i32.add ;; add offset to base address
        i32.load ;; load value
        ;; end array element access node
        call $writeInt ;; call host function
        global.get $var_x ;; get local var: var_x, have been hoisted
        i32.const 1 ;; push 1 on stack
        i32.add
        global.set $var_x ;; set local var, have been hoisted
        global.get $var_x ;; set local var, have been hoisted
        br $loop_begin$4
      )
    )
    i32.const 80 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 80 ;; leave pointer to string on stack
    i32.load offset=4 ;; Load string length
    call $writeS ;; call host function
    ;; Start of let
    ;; Start of union contructor
    ;; start of struct contructor
    i32.const 8 ;; size of struct
    call $malloc ;; call malloc function
    global.set $Sptr$5 ;; set struct pointer var, have been hoisted
    global.get $Sptr$5 ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field (id)
    i32.const 1 ;; push 1 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$5 ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field (data)
    global.get $var_sliced ;; get local var: var_sliced, have been hoisted
    i32.store ;; store int field in memory
    global.get $Sptr$5 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    ;; End of union contructor
    global.set $var_o ;; set local var, have been hoisted
    (block $match_end 
      ;; case for id: $1, label: Some
      global.get $var_o ;; get local var: var_o, have been hoisted
      i32.load ;; load label
      i32.const 1 ;; put label id 1 on stack
      i32.eq ;; check if index is equal to target
      (if 
        (then
          global.get $var_o ;; get local var: var_o, have been hoisted
          i32.load offset=4 ;; load data pointer
          global.set $match_var_v ;; set local var, have been hoisted
          ;; start array length node
          global.get $match_var_v ;; get local var: match_var_v, have been hoisted
          i32.load offset=4 ;; load length
          ;; end array length node
          call $writeInt ;; call host function
          br $match_end ;; break out of match
        )
      )
      ;; case for id: $2, label: None
      global.get $var_o ;; get local var: var_o, have been hoisted
      i32.load ;; load label
      i32.const 2 ;; put label id 2 on stack
      i32.eq ;; check if index is equal to target
      (if 
        (then
          global.get $var_o ;; get local var: var_o, have been hoisted
          i32.load offset=4 ;; load data pointer
          global.set $match_var__ ;; set local var, have been hoisted
          i32.const 118 ;; leave pointer to string on stack
          i32.load ;; Load string pointer
          i32.const 118 ;; leave pointer to string on stack
          i32.load offset=4 ;; Load string length
          call $writeS ;; call host function
          br $match_end ;; break out of match
        )
      )
      ;; no case was matched, therefore return exit error code
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    )
    ;; End of let
    ;; End of let
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (func $fun_f (;1;) (param $cenv i32) (param $arg_arr i32) (param $arg_i i32) (result i32) 
        local.get $arg_i ;; get local var: arg_i
        ;; start array length node
        local.get $arg_arr ;; get local var: arg_arr
        i32.load offset=4 ;; load length
        ;; end array length node
        i32.lt_s
    (if (result i32)
      (then
        local.get $arg_i ;; get local var: arg_i
        i32.const 0 ;; put zero on stack
        i32.lt_s ;; check if index is >= 0
        (if 
          (then
            i32.const 42 ;; error exit code push to stack
            global.set $exit_code ;; set exit code
            unreachable ;; exit program
          )
        )
        local.get $arg_i ;; get local var: arg_i
        local.get $arg_arr ;; get local var: arg_arr
        i32.load offset=4 ;; load length
        i32.ge_s ;; check if index is < length
        (if 
          (then
            i32.const 42 ;; error exit code push to stack
            global.set $exit_code ;; set exit code
            unreachable ;; exit program
          )
        )
        local.get $arg_arr ;; get local var: arg_arr
        i32.load ;; load data pointer
        local.get $arg_i ;; get local var: arg_i
        i32.const 4 ;; byte offset
        i32.mul ;; multiply index with byte offset
        i32.add ;; add offset to base address
        local.get $arg_i ;; get local var: arg_i
        i32.const 1 ;; push 1 on stack
        i32.add
        i32.store ;; store value in elem pos
        local.get $arg_arr ;; get local var: arg_arr
        i32.load ;; load data pointer
        local.get $arg_i ;; get local var: arg_i
        i32.const 4 ;; byte offset
        i32.mul ;; multiply index with byte offset
        i32.add ;; add offset to base address
        i32.load ;; load int from elem pos
        drop
        ;; Load expression to be applied as a function
        global.get $fun_f*ptr ;; get global var: fun_f*ptr
        i32.load offset=4 ;; load closure environment pointer
        local.get $arg_arr ;; get local var: arg_arr
        local.get $arg_i ;; get local var: arg_i
        i32.const 1 ;; push 1 on stack
        i32.add
        global.get $fun_f*ptr ;; get global var: fun_f*ptr
        i32.load ;; load table index
        call_indirect (type $i32_i32_i32_=>_i32) ;; call function
      )
      (else
        local.get $arg_arr ;; get local var: arg_arr
      )
    )
  )
  (data (i32.const 0) "\0c\00\00\00\1a\00\00\00\1a\00\00\00")
  (data (i32.const 12) "--------------------------")
  (data (i32.const 38) "\00")
  (data (i32.const 42) "\36\00\00\00\1a\00\00\00\1a\00\00\00")
  (data (i32.const 54) "--------------------------")
  (data (i32.const 80) "\5c\00\00\00\1a\00\00\00\1a\00\00\00")
  (data (i32.const 92) "--------------------------")
  (data (i32.const 118) "\82\00\00\00\04\00\00\00\04\00\00\00")
  (data (i32.const 130) "None")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)