(module
  (type $i32_i32_i32_=>_i32 (;0;) (func (param i32) (param i32) (param i32) (result i32)))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $Sptr (;0;) (mut i32) i32.const 0)
  (global $Sptr$1 (;1;) (mut i32) i32.const 0)
  (global $Sptr$2 (;2;) (mut i32) i32.const 0)
  (global $Sptr$3 (;3;) (mut i32) i32.const 0)
  (global $Sptr$4 (;4;) (mut i32) i32.const 0)
  (global $arr_ptr (;5;) (mut i32) i32.const 0)
  (global $exit_code (;6;) (mut i32) i32.const 0)
  (global $fun_toString*ptr (;7;) (mut i32) i32.const 0)
  (global $heap_base (;8;) i32 i32.const 4)
  (global $i (;9;) (mut i32) i32.const 0)
  (global $var_arr (;10;) (mut i32) i32.const 0)
  (global $var_n (;11;) (mut i32) i32.const 0)
  (global $var_x (;12;) (mut i32) i32.const 0)
  (table $func_table (;0;) 1 funcref)
  (elem (i32.const 0) (;0;) $fun_toString)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    i32.const 10 ;; push 10 on stack
    global.set $var_n ;; set local var, have been hoisted
    ;; Start of let
    i32.const 12 ;; push 12 on stack
    global.set $var_x ;; set local var, have been hoisted
    ;; Start of let
    global.get $var_n ;; get local var: var_n, have been hoisted
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
    global.get $var_n ;; get local var: var_n, have been hoisted
    i32.store ;; store int field in memory
    global.get $Sptr ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    global.set $arr_ptr ;; set struct pointer var, have been hoisted
    global.get $arr_ptr ;; get struct pointer var, have been hoisted
    global.get $var_n ;; get local var: var_n, have been hoisted
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    i32.store ;; store pointer to data
    i32.const 0
    global.set $i ;; , have been hoisted
    (block $loop_exit 
      (loop $loop_begin 
        global.get $var_n ;; get local var: var_n, have been hoisted
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
        i32.const 1994 ;; push 1994 on stack
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
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_toString*ptr ;; get global var: fun_toString*ptr
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of union contructor
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr$1 ;; set struct pointer var, have been hoisted
    global.get $Sptr$1 ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field id
    i32.const 1 ;; push 1 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$1 ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    i32.const 5 ;; push 5 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$1 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    ;; End of union contructor
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    global.get $fun_toString*ptr ;; get global var: fun_toString*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 1994 ;; push 1994 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_toString*ptr ;; get global var: fun_toString*ptr
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of union contructor
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr$2 ;; set struct pointer var, have been hoisted
    global.get $Sptr$2 ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field id
    i32.const 4 ;; push 4 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$2 ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$2 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    ;; End of union contructor
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    global.get $fun_toString*ptr ;; get global var: fun_toString*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 0 ;; push 0 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_toString*ptr ;; get global var: fun_toString*ptr
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of union contructor
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr$3 ;; set struct pointer var, have been hoisted
    global.get $Sptr$3 ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field id
    i32.const 2 ;; push 2 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$3 ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.store ;; store int field in memory
    global.get $Sptr$3 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    ;; End of union contructor
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    global.get $fun_toString*ptr ;; get global var: fun_toString*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 10 ;; push 10 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_toString*ptr ;; get global var: fun_toString*ptr
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of union contructor
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr$4 ;; set struct pointer var, have been hoisted
    global.get $Sptr$4 ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field id
    i32.const 3 ;; push 3 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$4 ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    i32.const 5 ;; push 5 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$4 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    ;; End of union contructor
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    global.get $fun_toString*ptr ;; get global var: fun_toString*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    global.get $var_x ;; get local var: var_x, have been hoisted
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
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_toString (;1;) (param $cenv i32) (param $arg_o i32) (param $arg_arr i32) (result i32) 
    ;; local variables declarations:
    (local $match_var__ i32)
    (local $match_var_a i32)
    (local $match_var_i i32)
    (local $match_var_i$0 i32)

    (block $match_end (result i32)
      ;; case for id: $1, label: Index
      local.get $arg_o ;; get local var: arg_o
      i32.load ;; load label
      i32.const 1 ;; put label id 1 on stack
      i32.eq ;; check if index is equal to target
      (if 
        (then
          local.get $arg_o ;; get local var: arg_o
          i32.load offset=4 ;; load data pointer
          local.set $match_var_i ;; set local var
          local.get $match_var_i ;; get local var: match_var_i
          i32.const 0 ;; put zero on stack
          i32.lt_s ;; check if index is >= 0
          (if 
            (then
              i32.const 42 ;; error exit code push to stack
              global.set $exit_code ;; set exit code
              unreachable ;; exit program
            )
          )
          local.get $match_var_i ;; get local var: match_var_i
          local.get $arg_arr ;; get local var: arg_arr
          i32.load offset=4 ;; load length
          i32.ge_u ;; check if index is < length
          (if 
            (then
              i32.const 42 ;; error exit code push to stack
              global.set $exit_code ;; set exit code
              unreachable ;; exit program
            )
          )
          local.get $arg_arr ;; get local var: arg_arr
          i32.load ;; load data pointer
          local.get $match_var_i ;; get local var: match_var_i
          i32.const 4 ;; byte offset
          i32.mul ;; multiply index with byte offset
          i32.add ;; add offset to base address
          i32.load ;; load value
          ;; end array element access node
          br $match_end ;; break out of match
        )
      )
      ;; case for id: $2, label: Length
      local.get $arg_o ;; get local var: arg_o
      i32.load ;; load label
      i32.const 2 ;; put label id 2 on stack
      i32.eq ;; check if index is equal to target
      (if 
        (then
          local.get $arg_o ;; get local var: arg_o
          i32.load offset=4 ;; load data pointer
          local.set $match_var_a ;; set local var
          ;; start array length node
          local.get $match_var_a ;; get local var: match_var_a
          i32.load offset=4 ;; load length
          ;; end array length node
          br $match_end ;; break out of match
        )
      )
      ;; case for id: $3, label: Assign
      local.get $arg_o ;; get local var: arg_o
      i32.load ;; load label
      i32.const 3 ;; put label id 3 on stack
      i32.eq ;; check if index is equal to target
      (if 
        (then
          local.get $arg_o ;; get local var: arg_o
          i32.load offset=4 ;; load data pointer
          local.set $match_var_i$0 ;; set local var
          local.get $match_var_i$0 ;; get local var: match_var_i$0
          i32.const 0 ;; put zero on stack
          i32.lt_s ;; check if index is >= 0
          (if 
            (then
              i32.const 42 ;; error exit code push to stack
              global.set $exit_code ;; set exit code
              unreachable ;; exit program
            )
          )
          local.get $match_var_i$0 ;; get local var: match_var_i$0
          local.get $arg_arr ;; get local var: arg_arr
          i32.load offset=4 ;; load length
          i32.ge_u ;; check if index is < length
          (if 
            (then
              i32.const 42 ;; error exit code push to stack
              global.set $exit_code ;; set exit code
              unreachable ;; exit program
            )
          )
          local.get $arg_arr ;; get local var: arg_arr
          i32.load ;; load data pointer
          local.get $match_var_i$0 ;; get local var: match_var_i$0
          i32.const 4 ;; byte offset
          i32.mul ;; multiply index with byte offset
          i32.add ;; add offset to base address
          global.get $var_x ;; get local var: var_x, have been hoisted
          i32.store ;; store value in elem pos
          local.get $arg_arr ;; get local var: arg_arr
          i32.load ;; load data pointer
          local.get $match_var_i$0 ;; get local var: match_var_i$0
          i32.const 4 ;; byte offset
          i32.mul ;; multiply index with byte offset
          i32.add ;; add offset to base address
          i32.load ;; load int from elem pos
          br $match_end ;; break out of match
        )
      )
      ;; case for id: $4, label: None
      local.get $arg_o ;; get local var: arg_o
      i32.load ;; load label
      i32.const 4 ;; put label id 4 on stack
      i32.eq ;; check if index is equal to target
      (if 
        (then
          local.get $arg_o ;; get local var: arg_o
          i32.load offset=4 ;; load data pointer
          local.set $match_var__ ;; set local var
          i32.const 0 ;; push 0 on stack
          br $match_end ;; break out of match
        )
      )
      ;; no case was matched, therefore return exit error code
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    )
  )
  (data (i32.const 0) "\00")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)