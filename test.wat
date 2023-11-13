(module
  (type $i32_i32_=>_unit (;0;) (func (param i32) (param i32) ))
  (type $i32_i32_i32_i32_=>_i32 (;1;) (func (param i32) (param i32) (param i32) (param i32) (result i32)))
  (type $i32_i32_i32_i32_=>_unit (;2;) (func (param i32) (param i32) (param i32) (param i32) ))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (import "env" "writeInt" (;1;) (func $writeInt (param i32) ))
  (import "env" "writeS" (;2;) (func $writeS (param i32) (param i32) ))
  (memory (;0;) (export "memory") 1)
  (global $Sptr (;0;) (mut i32) i32.const 0)
  (global $arr_ptr (;1;) (mut i32) i32.const 0)
  (global $exit_code (;2;) (mut i32) i32.const 0)
  (global $fun_partition*ptr (;3;) (mut i32) i32.const 0)
  (global $fun_printArray*ptr (;4;) (mut i32) i32.const 8)
  (global $fun_quickSort*ptr (;5;) (mut i32) i32.const 4)
  (global $heap_base (;6;) i32 i32.const 187)
  (global $i (;7;) (mut i32) i32.const 0)
  (global $var_arr (;8;) (mut i32) i32.const 0)
  (table $func_table (;0;) 3 funcref)
  (elem (i32.const 0) (;0;) $fun_partition)
  (elem (i32.const 1) (;1;) $fun_quickSort)
  (elem (i32.const 2) (;2;) $fun_printArray)
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
    (block $loop_exit$7 
      (loop $loop_begin$8 
        i32.const 10 ;; push 10 on stack
        global.get $i ;; get i, have been hoisted
        i32.eq
        br_if $loop_exit$7
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
        br $loop_begin$8
      )
    )
    global.get $arr_ptr ;; leave pointer to allocated array struct on stack, have been hoisted
    global.set $var_arr ;; set local var, have been hoisted
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
    i32.const 50000 ;; push 50000 on stack
    i32.store ;; store value in elem pos
    global.get $var_arr ;; get local var: var_arr, have been hoisted
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
    i32.const 1 ;; push 1 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.const -3 ;; push -3 on stack
    i32.store ;; store value in elem pos
    global.get $var_arr ;; get local var: var_arr, have been hoisted
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
    i32.const 2 ;; push 2 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.const -11 ;; push -11 on stack
    i32.store ;; store value in elem pos
    global.get $var_arr ;; get local var: var_arr, have been hoisted
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
    i32.const 3 ;; push 3 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.const 22 ;; push 22 on stack
    i32.store ;; store value in elem pos
    global.get $var_arr ;; get local var: var_arr, have been hoisted
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
    i32.const 4 ;; push 4 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.const 45 ;; push 45 on stack
    i32.store ;; store value in elem pos
    global.get $var_arr ;; get local var: var_arr, have been hoisted
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
    i32.const 5 ;; push 5 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.const 61 ;; push 61 on stack
    i32.store ;; store value in elem pos
    global.get $var_arr ;; get local var: var_arr, have been hoisted
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
    i32.const 6 ;; push 6 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.const 100 ;; push 100 on stack
    i32.store ;; store value in elem pos
    global.get $var_arr ;; get local var: var_arr, have been hoisted
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
    i32.const 7 ;; push 7 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.const 200 ;; push 200 on stack
    i32.store ;; store value in elem pos
    global.get $var_arr ;; get local var: var_arr, have been hoisted
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
    i32.const 8 ;; push 8 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.const 34 ;; push 34 on stack
    i32.store ;; store value in elem pos
    global.get $var_arr ;; get local var: var_arr, have been hoisted
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
    i32.const 9 ;; push 9 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.const 80 ;; push 80 on stack
    i32.store ;; store value in elem pos
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load ;; load data pointer
    i32.const 9 ;; push 9 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load int from elem pos
    drop
    i32.const 12 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 12 ;; leave pointer to string on stack
    i32.load offset=4 ;; Load string length
    call $writeS ;; call host function
    ;; Load expression to be applied as a function
    global.get $fun_printArray*ptr ;; get global var: fun_printArray*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    global.get $fun_printArray*ptr ;; get global var: fun_printArray*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_unit) ;; call function
    i32.const 43 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 43 ;; leave pointer to string on stack
    i32.load offset=4 ;; Load string length
    call $writeS ;; call host function
    ;; Load expression to be applied as a function
    global.get $fun_quickSort*ptr ;; get global var: fun_quickSort*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.const 0 ;; push 0 on stack
    ;; start array length node
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    ;; end array length node
    i32.const 1 ;; push 1 on stack
    i32.sub
    global.get $fun_quickSort*ptr ;; get global var: fun_quickSort*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_i32_=>_unit) ;; call function
    i32.const 89 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 89 ;; leave pointer to string on stack
    i32.load offset=4 ;; Load string length
    call $writeS ;; call host function
    i32.const 139 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 139 ;; leave pointer to string on stack
    i32.load offset=4 ;; Load string length
    call $writeS ;; call host function
    ;; Load expression to be applied as a function
    global.get $fun_printArray*ptr ;; get global var: fun_printArray*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    global.get $fun_printArray*ptr ;; get global var: fun_printArray*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_unit) ;; call function
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
    i32.const 1 ;; push 1 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const -3 ;; push -3 on stack
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
    i32.const -11 ;; push -11 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
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
    i32.const 2 ;; push 2 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 22 ;; push 22 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
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
    i32.const 3 ;; push 3 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 34 ;; push 34 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
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
    i32.const 4 ;; push 4 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 45 ;; push 45 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
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
    i32.const 5 ;; push 5 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 61 ;; push 61 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
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
    i32.const 6 ;; push 6 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 80 ;; push 80 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
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
    i32.const 7 ;; push 7 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 100 ;; push 100 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
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
    i32.const 8 ;; push 8 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 200 ;; push 200 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
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
    i32.const 9 ;; push 9 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 50000 ;; push 50000 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    i32.const 168 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 168 ;; leave pointer to string on stack
    i32.load offset=4 ;; Load string length
    call $writeS ;; call host function
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_partition (;1;) (param $cenv i32) (param $arg_arr i32) (param $arg_low i32) (param $arg_high i32) (result i32) 
    ;; local variables declarations:
    (local $var_i i32)
    (local $var_j i32)
    (local $var_pivot i32)
    (local $var_temp i32)
    (local $var_temp$0 i32)

    ;; Start of let
    local.get $arg_high ;; get local var: arg_high
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    local.get $arg_high ;; get local var: arg_high
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
    local.get $arg_high ;; get local var: arg_high
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    local.set $var_pivot ;; set local var
    ;; Start of let
    local.get $arg_low ;; get local var: arg_low
    i32.const 1 ;; push 1 on stack
    i32.sub
    local.set $var_i ;; set local var
    ;; Start of let
    i32.const 0 ;; push 0 on stack
    local.set $var_j ;; set local var
    local.get $arg_low ;; get local var: arg_low
    local.tee $var_j ;; set local var
    drop
    (block $loop_exit 
      (loop $loop_begin 
        local.get $var_j ;; get local var: var_j
        local.get $arg_high ;; get local var: arg_high
        i32.lt_s
        i32.eqz
        br_if $loop_exit
        local.get $var_j ;; get local var: var_j
        i32.const 0 ;; put zero on stack
        i32.lt_s ;; check if index is >= 0
        (if 
          (then
            i32.const 42 ;; error exit code push to stack
            global.set $exit_code ;; set exit code
            unreachable ;; exit program
          )
        )
        local.get $var_j ;; get local var: var_j
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
        local.get $var_j ;; get local var: var_j
        i32.const 4 ;; byte offset
        i32.mul ;; multiply index with byte offset
        i32.add ;; add offset to base address
        i32.load ;; load value
        ;; end array element access node
        local.get $var_pivot ;; get local var: var_pivot
        i32.le_s
        (if 
          (then
            local.get $var_i ;; get local var: var_i
            i32.const 1 ;; push 1 on stack
            i32.add
            local.tee $var_i ;; set local var
            drop
            ;; Start of let
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
            local.set $var_temp ;; set local var
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
            local.get $var_j ;; get local var: var_j
            i32.const 0 ;; put zero on stack
            i32.lt_s ;; check if index is >= 0
            (if 
              (then
                i32.const 42 ;; error exit code push to stack
                global.set $exit_code ;; set exit code
                unreachable ;; exit program
              )
            )
            local.get $var_j ;; get local var: var_j
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
            local.get $var_j ;; get local var: var_j
            i32.const 4 ;; byte offset
            i32.mul ;; multiply index with byte offset
            i32.add ;; add offset to base address
            i32.load ;; load value
            ;; end array element access node
            i32.store ;; store value in elem pos
            local.get $arg_arr ;; get local var: arg_arr
            i32.load ;; load data pointer
            local.get $var_i ;; get local var: var_i
            i32.const 4 ;; byte offset
            i32.mul ;; multiply index with byte offset
            i32.add ;; add offset to base address
            i32.load ;; load int from elem pos
            drop
            local.get $var_j ;; get local var: var_j
            i32.const 0 ;; put zero on stack
            i32.lt_s ;; check if index is >= 0
            (if 
              (then
                i32.const 42 ;; error exit code push to stack
                global.set $exit_code ;; set exit code
                unreachable ;; exit program
              )
            )
            local.get $var_j ;; get local var: var_j
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
            local.get $var_j ;; get local var: var_j
            i32.const 4 ;; byte offset
            i32.mul ;; multiply index with byte offset
            i32.add ;; add offset to base address
            local.get $var_temp ;; get local var: var_temp
            i32.store ;; store value in elem pos
            local.get $arg_arr ;; get local var: arg_arr
            i32.load ;; load data pointer
            local.get $var_j ;; get local var: var_j
            i32.const 4 ;; byte offset
            i32.mul ;; multiply index with byte offset
            i32.add ;; add offset to base address
            i32.load ;; load int from elem pos
            drop
            ;; End of let
          )
          (else
          )
        )
        local.get $var_j ;; get local var: var_j
        local.get $var_j ;; get local var: var_j
        i32.const 1 ;; push 1 on stack
        i32.add
        local.tee $var_j ;; set local var
        drop
        drop
        br $loop_begin
      )
    )
    ;; Start of let
    local.get $var_i ;; get local var: var_i
    i32.const 1 ;; push 1 on stack
    i32.add
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
    i32.const 1 ;; push 1 on stack
    i32.add
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
    i32.const 1 ;; push 1 on stack
    i32.add
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    local.set $var_temp$0 ;; set local var
    local.get $var_i ;; get local var: var_i
    i32.const 1 ;; push 1 on stack
    i32.add
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
    i32.const 1 ;; push 1 on stack
    i32.add
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
    i32.const 1 ;; push 1 on stack
    i32.add
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    local.get $arg_high ;; get local var: arg_high
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    local.get $arg_high ;; get local var: arg_high
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
    local.get $arg_high ;; get local var: arg_high
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.store ;; store value in elem pos
    local.get $arg_arr ;; get local var: arg_arr
    i32.load ;; load data pointer
    local.get $var_i ;; get local var: var_i
    i32.const 1 ;; push 1 on stack
    i32.add
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load int from elem pos
    drop
    local.get $arg_high ;; get local var: arg_high
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    local.get $arg_high ;; get local var: arg_high
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
    local.get $arg_high ;; get local var: arg_high
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    local.get $var_temp$0 ;; get local var: var_temp$0
    i32.store ;; store value in elem pos
    local.get $arg_arr ;; get local var: arg_arr
    i32.load ;; load data pointer
    local.get $arg_high ;; get local var: arg_high
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load int from elem pos
    drop
    local.get $var_i ;; get local var: var_i
    i32.const 1 ;; push 1 on stack
    i32.add
    ;; End of let
    ;; End of let
    ;; End of let
    ;; End of let
  )
  (func $fun_printArray (;2;) (param $cenv i32) (param $arg_arr$4 i32)  
    ;; local variables declarations:
    (local $var_x i32)

    ;; Start of let
    i32.const 0 ;; push 0 on stack
    local.set $var_x ;; set local var
    local.get $var_x ;; get local var: var_x
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    local.get $var_x ;; get local var: var_x
    local.get $arg_arr$4 ;; get local var: arg_arr$4
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    local.get $arg_arr$4 ;; get local var: arg_arr$4
    i32.load ;; load data pointer
    local.get $var_x ;; get local var: var_x
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    call $writeInt ;; call host function
    local.get $var_x ;; get local var: var_x
    i32.const 1 ;; push 1 on stack
    i32.add
    local.tee $var_x ;; set local var
    drop
    (block $loop_exit$5 
      (loop $loop_begin$6 
        local.get $var_x ;; get local var: var_x
        ;; start array length node
        local.get $arg_arr$4 ;; get local var: arg_arr$4
        i32.load offset=4 ;; load length
        ;; end array length node
        i32.lt_s
        i32.eqz
        br_if $loop_exit$5
        local.get $var_x ;; get local var: var_x
        i32.const 0 ;; put zero on stack
        i32.lt_s ;; check if index is >= 0
        (if 
          (then
            i32.const 42 ;; error exit code push to stack
            global.set $exit_code ;; set exit code
            unreachable ;; exit program
          )
        )
        local.get $var_x ;; get local var: var_x
        local.get $arg_arr$4 ;; get local var: arg_arr$4
        i32.load offset=4 ;; load length
        i32.ge_s ;; check if index is < length
        (if 
          (then
            i32.const 42 ;; error exit code push to stack
            global.set $exit_code ;; set exit code
            unreachable ;; exit program
          )
        )
        local.get $arg_arr$4 ;; get local var: arg_arr$4
        i32.load ;; load data pointer
        local.get $var_x ;; get local var: var_x
        i32.const 4 ;; byte offset
        i32.mul ;; multiply index with byte offset
        i32.add ;; add offset to base address
        i32.load ;; load value
        ;; end array element access node
        call $writeInt ;; call host function
        local.get $var_x ;; get local var: var_x
        i32.const 1 ;; push 1 on stack
        i32.add
        local.tee $var_x ;; set local var
        br $loop_begin$6
      )
    )
    ;; End of let
  )
  (func $fun_quickSort (;3;) (param $cenv i32) (param $arg_arr$1 i32) (param $arg_low$2 i32) (param $arg_high$3 i32)  
    ;; local variables declarations:
    (local $var_pivotIndex i32)

    local.get $arg_low$2 ;; get local var: arg_low$2
    local.get $arg_high$3 ;; get local var: arg_high$3
    i32.lt_s
    (if 
      (then
        ;; Start of let
        ;; Load expression to be applied as a function
        global.get $fun_partition*ptr ;; get global var: fun_partition*ptr
        i32.load offset=4 ;; load closure environment pointer
        local.get $arg_arr$1 ;; get local var: arg_arr$1
        local.get $arg_low$2 ;; get local var: arg_low$2
        local.get $arg_high$3 ;; get local var: arg_high$3
        global.get $fun_partition*ptr ;; get global var: fun_partition*ptr
        i32.load ;; load table index
        call_indirect (type $i32_i32_i32_i32_=>_i32) ;; call function
        local.set $var_pivotIndex ;; set local var
        ;; Load expression to be applied as a function
        global.get $fun_quickSort*ptr ;; get global var: fun_quickSort*ptr
        i32.load offset=4 ;; load closure environment pointer
        local.get $arg_arr$1 ;; get local var: arg_arr$1
        local.get $arg_low$2 ;; get local var: arg_low$2
        local.get $var_pivotIndex ;; get local var: var_pivotIndex
        i32.const 1 ;; push 1 on stack
        i32.sub
        global.get $fun_quickSort*ptr ;; get global var: fun_quickSort*ptr
        i32.load ;; load table index
        call_indirect (type $i32_i32_i32_i32_=>_unit) ;; call function
        ;; Load expression to be applied as a function
        global.get $fun_quickSort*ptr ;; get global var: fun_quickSort*ptr
        i32.load offset=4 ;; load closure environment pointer
        local.get $arg_arr$1 ;; get local var: arg_arr$1
        local.get $var_pivotIndex ;; get local var: var_pivotIndex
        i32.const 1 ;; push 1 on stack
        i32.add
        local.get $arg_high$3 ;; get local var: arg_high$3
        global.get $fun_quickSort*ptr ;; get global var: fun_quickSort*ptr
        i32.load ;; load table index
        call_indirect (type $i32_i32_i32_i32_=>_unit) ;; call function
        ;; End of let
      )
      (else
      )
    )
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (data (i32.const 8) "\02")
  (data (i32.const 12) "\18\00\00\00\13\00\00\00\11\00\00\00")
  (data (i32.const 24) "😰 initial array:")
  (data (i32.const 43) "\37\00\00\00\22\00\00\00\20\00\00\00")
  (data (i32.const 55) "🤔 sorting array... (quick sort)")
  (data (i32.const 89) "\65\00\00\00\26\00\00\00\26\00\00\00")
  (data (i32.const 101) "--------------------------------------")
  (data (i32.const 139) "\97\00\00\00\11\00\00\00\0f\00\00\00")
  (data (i32.const 151) "✅ sorted array:")
  (data (i32.const 168) "\b4\00\00\00\07\00\00\00\05\00\00\00")
  (data (i32.const 180) "done✅")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)