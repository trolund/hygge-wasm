(module
  (type $i32_i32_i32_=>_i32 (;0;) (func (param i32) (param i32) (param i32) (result i32)))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $Sptr (;0;) (mut i32) i32.const 0)
  (global $arr_ptr (;1;) (mut i32) i32.const 0)
  (global $exit_code (;2;) (mut i32) i32.const 0)
  (global $fun_linearSearch*ptr (;3;) (mut i32) i32.const 0)
  (global $heap_base (;4;) i32 i32.const 4)
  (global $i (;5;) (mut i32) i32.const 0)
  (global $var_sortedArray (;6;) (mut i32) i32.const 0)
  (table $func_table (;0;) 1 funcref)
  (elem (i32.const 0) (;0;) $fun_linearSearch)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    i32.const 10 ;; push 10 on stack
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
    i32.const 10 ;; push 10 on stack
    i32.store ;; store int field in memory
    global.get $Sptr ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    global.set $arr_ptr ;; set struct pointer var, have been hoisted
    global.get $arr_ptr ;; get struct pointer var, have been hoisted
    i32.const 10 ;; push 10 on stack
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    i32.store ;; store pointer to data
    i32.const 0
    global.set $i ;; , have been hoisted
    (block $loop_exit$0 
      (loop $loop_begin$1 
        i32.const 10 ;; push 10 on stack
        global.get $i ;; get i, have been hoisted
        i32.eq
        br_if $loop_exit$0
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
        br $loop_begin$1
      )
    )
    global.get $arr_ptr ;; leave pointer to allocated array struct on stack, have been hoisted
    global.set $var_sortedArray ;; set local var, have been hoisted
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
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load ;; load data pointer
    i32.const 0 ;; push 0 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.const 0 ;; push 0 on stack
    i32.store ;; store value in elem pos
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load ;; load data pointer
    i32.const 0 ;; push 0 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load int from elem pos
    drop
    i32.const 1 ;; push 1 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    i32.const 1 ;; push 1 on stack
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load ;; load data pointer
    i32.const 1 ;; push 1 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.const 3 ;; push 3 on stack
    i32.store ;; store value in elem pos
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load ;; load data pointer
    i32.const 1 ;; push 1 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load int from elem pos
    drop
    i32.const 2 ;; push 2 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    i32.const 2 ;; push 2 on stack
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load ;; load data pointer
    i32.const 2 ;; push 2 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.const 11 ;; push 11 on stack
    i32.store ;; store value in elem pos
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load ;; load data pointer
    i32.const 2 ;; push 2 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load int from elem pos
    drop
    i32.const 3 ;; push 3 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    i32.const 3 ;; push 3 on stack
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load ;; load data pointer
    i32.const 3 ;; push 3 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.const 22 ;; push 22 on stack
    i32.store ;; store value in elem pos
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load ;; load data pointer
    i32.const 3 ;; push 3 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load int from elem pos
    drop
    i32.const 4 ;; push 4 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    i32.const 4 ;; push 4 on stack
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load ;; load data pointer
    i32.const 4 ;; push 4 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.const 45 ;; push 45 on stack
    i32.store ;; store value in elem pos
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load ;; load data pointer
    i32.const 4 ;; push 4 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load int from elem pos
    drop
    i32.const 5 ;; push 5 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    i32.const 5 ;; push 5 on stack
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load ;; load data pointer
    i32.const 5 ;; push 5 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.const 61 ;; push 61 on stack
    i32.store ;; store value in elem pos
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load ;; load data pointer
    i32.const 5 ;; push 5 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load int from elem pos
    drop
    i32.const 6 ;; push 6 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    i32.const 6 ;; push 6 on stack
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load ;; load data pointer
    i32.const 6 ;; push 6 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.const 100 ;; push 100 on stack
    i32.store ;; store value in elem pos
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load ;; load data pointer
    i32.const 6 ;; push 6 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load int from elem pos
    drop
    i32.const 7 ;; push 7 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    i32.const 7 ;; push 7 on stack
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load ;; load data pointer
    i32.const 7 ;; push 7 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.const 200 ;; push 200 on stack
    i32.store ;; store value in elem pos
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load ;; load data pointer
    i32.const 7 ;; push 7 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load int from elem pos
    drop
    i32.const 8 ;; push 8 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    i32.const 8 ;; push 8 on stack
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load ;; load data pointer
    i32.const 8 ;; push 8 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.const 222 ;; push 222 on stack
    i32.store ;; store value in elem pos
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load ;; load data pointer
    i32.const 8 ;; push 8 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load int from elem pos
    drop
    i32.const 9 ;; push 9 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    i32.const 9 ;; push 9 on stack
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load ;; load data pointer
    i32.const 9 ;; push 9 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.const 245 ;; push 245 on stack
    i32.store ;; store value in elem pos
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.load ;; load data pointer
    i32.const 9 ;; push 9 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load int from elem pos
    drop
    ;; Load expression to be applied as a function
    global.get $fun_linearSearch*ptr ;; get global var: fun_linearSearch*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.const 22 ;; push 22 on stack
    global.get $fun_linearSearch*ptr ;; get global var: fun_linearSearch*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    i32.const 3 ;; push 3 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; Load expression to be applied as a function
    global.get $fun_linearSearch*ptr ;; get global var: fun_linearSearch*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.const 45 ;; push 45 on stack
    global.get $fun_linearSearch*ptr ;; get global var: fun_linearSearch*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    i32.const 4 ;; push 4 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; Load expression to be applied as a function
    global.get $fun_linearSearch*ptr ;; get global var: fun_linearSearch*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.const 245 ;; push 245 on stack
    global.get $fun_linearSearch*ptr ;; get global var: fun_linearSearch*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
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
    ;; Load expression to be applied as a function
    global.get $fun_linearSearch*ptr ;; get global var: fun_linearSearch*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.const 0 ;; push 0 on stack
    global.get $fun_linearSearch*ptr ;; get global var: fun_linearSearch*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
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
    ;; Load expression to be applied as a function
    global.get $fun_linearSearch*ptr ;; get global var: fun_linearSearch*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.const 100 ;; push 100 on stack
    global.get $fun_linearSearch*ptr ;; get global var: fun_linearSearch*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    i32.const 6 ;; push 6 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; Load expression to be applied as a function
    global.get $fun_linearSearch*ptr ;; get global var: fun_linearSearch*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.const 200 ;; push 200 on stack
    global.get $fun_linearSearch*ptr ;; get global var: fun_linearSearch*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    i32.const 7 ;; push 7 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; Load expression to be applied as a function
    global.get $fun_linearSearch*ptr ;; get global var: fun_linearSearch*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.const 222 ;; push 222 on stack
    global.get $fun_linearSearch*ptr ;; get global var: fun_linearSearch*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    i32.const 8 ;; push 8 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; Load expression to be applied as a function
    global.get $fun_linearSearch*ptr ;; get global var: fun_linearSearch*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.const 3 ;; push 3 on stack
    global.get $fun_linearSearch*ptr ;; get global var: fun_linearSearch*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    i32.const 1 ;; push 1 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; Load expression to be applied as a function
    global.get $fun_linearSearch*ptr ;; get global var: fun_linearSearch*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.const 11 ;; push 11 on stack
    global.get $fun_linearSearch*ptr ;; get global var: fun_linearSearch*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    i32.const 2 ;; push 2 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; Load expression to be applied as a function
    global.get $fun_linearSearch*ptr ;; get global var: fun_linearSearch*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.const 61 ;; push 61 on stack
    global.get $fun_linearSearch*ptr ;; get global var: fun_linearSearch*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    i32.const 5 ;; push 5 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; Load expression to be applied as a function
    global.get $fun_linearSearch*ptr ;; get global var: fun_linearSearch*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_sortedArray ;; get local var: var_sortedArray, have been hoisted
    i32.const 1 ;; push 1 on stack
    global.get $fun_linearSearch*ptr ;; get global var: fun_linearSearch*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    i32.const -1 ;; push -1 on stack
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
  (func $fun_linearSearch (;1;) (param $cenv i32) (param $arg_arr i32) (param $arg_target i32) (result i32) 
    ;; local variables declarations:
    (local $var_break i32)
    (local $var_i i32)
    (local $var_n i32)
    (local $var_result i32)

    ;; Start of let
    ;; start array length node
    local.get $arg_arr ;; get local var: arg_arr
    i32.load offset=4 ;; load length
    ;; end array length node
    local.set $var_n ;; set local var
    ;; Start of let
    i32.const 0 ;; push 0 on stack
    local.set $var_i ;; set local var
    ;; Start of let
    i32.const -1 ;; push -1 on stack
    local.set $var_result ;; set local var
    ;; Start of let
    i32.const 1 ;; push true on stack
    local.set $var_break ;; set local var
    (block $loop_exit 
      (loop $loop_begin 
        local.get $var_i ;; get local var: var_i
        local.get $var_n ;; get local var: var_n
        i32.lt_s
        (if (result i32)
          (then
            local.get $var_break ;; get local var: var_break
          )
          (else
            i32.const 0 ;; push 0 on stack
          )
        )
        i32.eqz
        br_if $loop_exit
        local.get $var_i ;; get local var: var_i
        i32.const 0 ;; put zero on stack
        i32.lt_s ;; check if index is >= 0
        (if 
          (then
            i32.const 42 ;; error exit code push to stack
            global.set $exit_code ;; set exit code
            unreachable ;; exit program
          )
        )
        local.get $var_i ;; get local var: var_i
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
        local.get $var_i ;; get local var: var_i
        i32.const 4 ;; byte offset
        i32.mul ;; multiply index with byte offset
        i32.add ;; add offset to base address
        i32.load ;; load value
        ;; end array element access node
        local.get $arg_target ;; get local var: arg_target
        i32.eq
        (if 
          (then
            local.get $var_i ;; get local var: var_i
            local.tee $var_result ;; set local var
            drop
            i32.const 0 ;; push false on stack
            local.tee $var_break ;; set local var
            drop
          )
          (else
          )
        )
        local.get $var_i ;; get local var: var_i
        i32.const 1 ;; push 1 on stack
        i32.add
        local.tee $var_i ;; set local var
        br $loop_begin
      )
    )
    local.get $var_result ;; get local var: var_result
    ;; End of let
    ;; End of let
    ;; End of let
    ;; End of let
  )
  (data (i32.const 0) "\00")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)