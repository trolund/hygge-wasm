(module
  (type $i32_i32_=>_unit (;0;) (func (param i32) (param i32) ))
  (import "env" "writeInt" (;0;) (func $writeInt (param i32) ))
  (import "env" "writeS" (;1;) (func $writeS (param i32) (param i32) ))
  (memory (;0;) (export "memory") 1)
  (global $Sptr (;0;) (mut i32) (i32.const 0))
  (global $arr_ptr (;1;) (mut i32) (i32.const 0))
  (global $exit_code (;2;) (mut i32) (i32.const 0))
  (global $fun_bubbleSort*ptr (;3;) (mut i32) (i32.const 0))
  (global $fun_printArray*ptr (;4;) (mut i32) (i32.const 4))
  (global $heap_base (;5;) (mut i32) (i32.const 184))
  (global $i (;6;) (mut i32) (i32.const 0))
  (global $var_arr (;7;) (mut i32) (i32.const 0))
  (table $func_table (;0;) 2 funcref)
  (elem (i32.const 0) (;0;) $fun_bubbleSort)
  (elem (i32.const 1) (;1;) $fun_printArray)
  (func $_start (;0;)   
    ;; execution start here:
    ;; Start of let
    i32.const 10 ;; push 10 on stack
    i32.const 1 ;; put one on stack
    i32.le_s ;; check if length is <= 1
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    ;; start of struct contructor
    global.get $heap_base ;; get heap base
    i32.const 8 ;; size of struct
    i32.add ;; find size need to allocate
    memory.size ;; memory size
    i32.const 65536 ;; page size
    i32.mul ;; find current size
    i32.ge_s ;; size need > current size
    if 
      global.get $heap_base ;; get heap base
      i32.const 8 ;; size of struct
      i32.add ;; find size need to allocate
      i32.const 65536 ;; page size
      i32.div_s ;; grow memory!
      memory.grow ;; grow memory if needed
      drop ;; drop new size
    end
    global.get $heap_base ;; leave current heap base address
    global.get $heap_base ;; get current heap base
    i32.const 8 ;; size of struct
    i32.add ;; add size to heap base
    global.set $heap_base ;; set base pointer
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
    i32.const 10 ;; push 10 on stack
    i32.store ;; store int field in memory
    global.get $Sptr ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    global.set $arr_ptr ;; set struct pointer var, have been hoisted
    global.get $arr_ptr ;; get struct pointer var, have been hoisted
    global.get $heap_base ;; get heap base
    i32.const 10 ;; push 10 on stack
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    i32.add ;; find size need to allocate
    memory.size ;; memory size
    i32.const 65536 ;; page size
    i32.mul ;; find current size
    i32.ge_s ;; size need > current size
    if 
      global.get $heap_base ;; get heap base
      i32.const 10 ;; push 10 on stack
      i32.const 4 ;; 4 bytes
      i32.mul ;; multiply length with 4 to get size
      i32.add ;; find size need to allocate
      i32.const 65536 ;; page size
      i32.div_s ;; grow memory!
      memory.grow ;; grow memory if needed
      drop ;; drop new size
    end
    global.get $heap_base ;; leave current heap base address
    global.get $heap_base ;; current base address
    i32.const 10 ;; push 10 on stack
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    i32.add ;; add size to heap base
    global.set $heap_base ;; set heap base
    i32.store ;; store pointer to data
    i32.const 0
    global.set $i ;; , have been hoisted
    block $loop_exit$9 
      loop $loop_begin$10 
        i32.const 10 ;; push 10 on stack
        global.get $i ;; get i, have been hoisted
        i32.eq
        br_if $loop_exit$9
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
        br $loop_begin$10
      end
    end
    global.get $arr_ptr ;; leave pointer to allocated array struct on stack, have been hoisted
    global.set $var_arr ;; set local var, have been hoisted
    i32.const 0 ;; push 0 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 0 ;; push 0 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load ;; load data pointer
    i32.const 0 ;; push 0 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.const 500 ;; push 500 on stack
    i32.store ;; store value in elem pos
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load ;; load data pointer
    i32.const 0 ;; push 0 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load int from elem pos
    drop ;; drop value of subtree
    i32.const 1 ;; push 1 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 1 ;; push 1 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load ;; load data pointer
    i32.const 1 ;; push 1 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.const 3 ;; push 3 on stack
    i32.store ;; store value in elem pos
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load ;; load data pointer
    i32.const 1 ;; push 1 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load int from elem pos
    drop ;; drop value of subtree
    i32.const 2 ;; push 2 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 2 ;; push 2 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load ;; load data pointer
    i32.const 2 ;; push 2 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.const 11 ;; push 11 on stack
    i32.store ;; store value in elem pos
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load ;; load data pointer
    i32.const 2 ;; push 2 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load int from elem pos
    drop ;; drop value of subtree
    i32.const 3 ;; push 3 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 3 ;; push 3 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
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
    drop ;; drop value of subtree
    i32.const 4 ;; push 4 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 4 ;; push 4 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
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
    drop ;; drop value of subtree
    i32.const 5 ;; push 5 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 5 ;; push 5 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
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
    drop ;; drop value of subtree
    i32.const 6 ;; push 6 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 6 ;; push 6 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
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
    drop ;; drop value of subtree
    i32.const 7 ;; push 7 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 7 ;; push 7 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
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
    drop ;; drop value of subtree
    i32.const 8 ;; push 8 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 8 ;; push 8 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
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
    drop ;; drop value of subtree
    i32.const 9 ;; push 9 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 9 ;; push 9 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
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
    drop ;; drop value of subtree
    i32.const 8 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 8 ;; leave pointer to string on stack
    i32.load offset=4 ;; Load string length
    call $writeS ;; call host function
    ;; Load expression to be applied as a function
    global.get $fun_printArray*ptr ;; get global var: fun_printArray*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    global.get $fun_printArray*ptr ;; get global var: fun_printArray*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_unit) ;; call function
    i32.const 39 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 39 ;; leave pointer to string on stack
    i32.load offset=4 ;; Load string length
    call $writeS ;; call host function
    ;; Load expression to be applied as a function
    global.get $fun_bubbleSort*ptr ;; get global var: fun_bubbleSort*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    global.get $fun_bubbleSort*ptr ;; get global var: fun_bubbleSort*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_unit) ;; call function
    i32.const 86 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 86 ;; leave pointer to string on stack
    i32.load offset=4 ;; Load string length
    call $writeS ;; call host function
    i32.const 136 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 136 ;; leave pointer to string on stack
    i32.load offset=4 ;; Load string length
    call $writeS ;; call host function
    ;; Load expression to be applied as a function
    global.get $fun_printArray*ptr ;; get global var: fun_printArray*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    global.get $fun_printArray*ptr ;; get global var: fun_printArray*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_unit) ;; call function
    i32.const 0 ;; push 0 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 0 ;; push 0 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load ;; load data pointer
    i32.const 0 ;; push 0 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 3 ;; push 3 on stack
    i32.eq ;; equality check
    i32.eqz ;; invert assertion
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 1 ;; push 1 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 1 ;; push 1 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load ;; load data pointer
    i32.const 1 ;; push 1 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 11 ;; push 11 on stack
    i32.eq ;; equality check
    i32.eqz ;; invert assertion
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 2 ;; push 2 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 2 ;; push 2 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load ;; load data pointer
    i32.const 2 ;; push 2 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 22 ;; push 22 on stack
    i32.eq ;; equality check
    i32.eqz ;; invert assertion
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 3 ;; push 3 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 3 ;; push 3 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load ;; load data pointer
    i32.const 3 ;; push 3 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 34 ;; push 34 on stack
    i32.eq ;; equality check
    i32.eqz ;; invert assertion
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 4 ;; push 4 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 4 ;; push 4 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load ;; load data pointer
    i32.const 4 ;; push 4 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 45 ;; push 45 on stack
    i32.eq ;; equality check
    i32.eqz ;; invert assertion
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 5 ;; push 5 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 5 ;; push 5 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load ;; load data pointer
    i32.const 5 ;; push 5 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 61 ;; push 61 on stack
    i32.eq ;; equality check
    i32.eqz ;; invert assertion
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 6 ;; push 6 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 6 ;; push 6 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load ;; load data pointer
    i32.const 6 ;; push 6 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 80 ;; push 80 on stack
    i32.eq ;; equality check
    i32.eqz ;; invert assertion
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 7 ;; push 7 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 7 ;; push 7 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load ;; load data pointer
    i32.const 7 ;; push 7 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 100 ;; push 100 on stack
    i32.eq ;; equality check
    i32.eqz ;; invert assertion
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 8 ;; push 8 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 8 ;; push 8 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load ;; load data pointer
    i32.const 8 ;; push 8 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 200 ;; push 200 on stack
    i32.eq ;; equality check
    i32.eqz ;; invert assertion
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 9 ;; push 9 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 9 ;; push 9 on stack
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    global.get $var_arr ;; get local var: var_arr, have been hoisted
    i32.load ;; load data pointer
    i32.const 9 ;; push 9 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 500 ;; push 500 on stack
    i32.eq ;; equality check
    i32.eqz ;; invert assertion
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    i32.const 165 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 165 ;; leave pointer to string on stack
    i32.load offset=4 ;; Load string length
    call $writeS ;; call host function
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (func $fun_bubbleSort (;1;) (param $cenv i32) (param $arg_arr i32)  
     ;; local variables declarations:
    (local $var_i i32)
    (local $var_i$0 i32)
    (local $var_len i32)
    (local $var_swapped i32)
    (local $var_temp i32)
    (local $var_temp$1 i32)

    ;; Start of let
    i32.const 0 ;; push false on stack
    local.set $var_swapped ;; set local var
    ;; Start of let
    ;; start array length node
    local.get $arg_arr ;; get local var: arg_arr
    i32.load offset=4 ;; load length
    ;; end array length node
    local.set $var_len ;; set local var
    i32.const 0 ;; push false on stack
    local.tee $var_swapped ;; set local var
    drop ;; drop value of subtree
    ;; Start of let
    i32.const 0 ;; push 0 on stack
    local.set $var_i ;; set local var
    i32.const 0 ;; push 0 on stack
    local.tee $var_i ;; set local var
    drop ;; drop value of init node
    block $loop_exit 
      loop $loop_begin 
        local.get $var_i ;; get local var: var_i
        local.get $var_len ;; get local var: var_len
        i32.const 1 ;; push 1 on stack
        i32.sub
        i32.lt_s
        i32.eqz ;; evaluate loop condition
        br_if $loop_exit ;; if false break
        local.get $var_i ;; get local var: var_i
        i32.const 0 ;; put zero on stack
        i32.lt_s ;; check if index is >= 0
        if 
          i32.const 42 ;; error exit code push to stack
          global.set $exit_code ;; set exit code
          unreachable ;; exit program
        end
        local.get $var_i ;; get local var: var_i
        local.get $arg_arr ;; get local var: arg_arr
        i32.load offset=4 ;; load length
        i32.ge_s ;; check if index is < length
        if 
          i32.const 42 ;; error exit code push to stack
          global.set $exit_code ;; set exit code
          unreachable ;; exit program
        end
        local.get $arg_arr ;; get local var: arg_arr
        i32.load ;; load data pointer
        local.get $var_i ;; get local var: var_i
        i32.const 4 ;; byte offset
        i32.mul ;; multiply index with byte offset
        i32.add ;; add offset to base address
        i32.load ;; load value
        ;; end array element access node
        local.get $var_i ;; get local var: var_i
        i32.const 1 ;; push 1 on stack
        i32.add
        i32.const 0 ;; put zero on stack
        i32.lt_s ;; check if index is >= 0
        if 
          i32.const 42 ;; error exit code push to stack
          global.set $exit_code ;; set exit code
          unreachable ;; exit program
        end
        local.get $var_i ;; get local var: var_i
        i32.const 1 ;; push 1 on stack
        i32.add
        local.get $arg_arr ;; get local var: arg_arr
        i32.load offset=4 ;; load length
        i32.ge_s ;; check if index is < length
        if 
          i32.const 42 ;; error exit code push to stack
          global.set $exit_code ;; set exit code
          unreachable ;; exit program
        end
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
        i32.gt_s
        if 
          ;; Start of let
          local.get $var_i ;; get local var: var_i
          i32.const 0 ;; put zero on stack
          i32.lt_s ;; check if index is >= 0
          if 
            i32.const 42 ;; error exit code push to stack
            global.set $exit_code ;; set exit code
            unreachable ;; exit program
          end
          local.get $var_i ;; get local var: var_i
          local.get $arg_arr ;; get local var: arg_arr
          i32.load offset=4 ;; load length
          i32.ge_s ;; check if index is < length
          if 
            i32.const 42 ;; error exit code push to stack
            global.set $exit_code ;; set exit code
            unreachable ;; exit program
          end
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
          if 
            i32.const 42 ;; error exit code push to stack
            global.set $exit_code ;; set exit code
            unreachable ;; exit program
          end
          local.get $var_i ;; get local var: var_i
          local.get $arg_arr ;; get local var: arg_arr
          i32.load offset=4 ;; load length
          i32.ge_s ;; check if index is < length
          if 
            i32.const 42 ;; error exit code push to stack
            global.set $exit_code ;; set exit code
            unreachable ;; exit program
          end
          local.get $arg_arr ;; get local var: arg_arr
          i32.load ;; load data pointer
          local.get $var_i ;; get local var: var_i
          i32.const 4 ;; byte offset
          i32.mul ;; multiply index with byte offset
          i32.add ;; add offset to base address
          local.get $var_i ;; get local var: var_i
          i32.const 1 ;; push 1 on stack
          i32.add
          i32.const 0 ;; put zero on stack
          i32.lt_s ;; check if index is >= 0
          if 
            i32.const 42 ;; error exit code push to stack
            global.set $exit_code ;; set exit code
            unreachable ;; exit program
          end
          local.get $var_i ;; get local var: var_i
          i32.const 1 ;; push 1 on stack
          i32.add
          local.get $arg_arr ;; get local var: arg_arr
          i32.load offset=4 ;; load length
          i32.ge_s ;; check if index is < length
          if 
            i32.const 42 ;; error exit code push to stack
            global.set $exit_code ;; set exit code
            unreachable ;; exit program
          end
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
          i32.store ;; store value in elem pos
          local.get $arg_arr ;; get local var: arg_arr
          i32.load ;; load data pointer
          local.get $var_i ;; get local var: var_i
          i32.const 4 ;; byte offset
          i32.mul ;; multiply index with byte offset
          i32.add ;; add offset to base address
          i32.load ;; load int from elem pos
          drop ;; drop value of subtree
          local.get $var_i ;; get local var: var_i
          i32.const 1 ;; push 1 on stack
          i32.add
          i32.const 0 ;; put zero on stack
          i32.lt_s ;; check if index is >= 0
          if 
            i32.const 42 ;; error exit code push to stack
            global.set $exit_code ;; set exit code
            unreachable ;; exit program
          end
          local.get $var_i ;; get local var: var_i
          i32.const 1 ;; push 1 on stack
          i32.add
          local.get $arg_arr ;; get local var: arg_arr
          i32.load offset=4 ;; load length
          i32.ge_s ;; check if index is < length
          if 
            i32.const 42 ;; error exit code push to stack
            global.set $exit_code ;; set exit code
            unreachable ;; exit program
          end
          local.get $arg_arr ;; get local var: arg_arr
          i32.load ;; load data pointer
          local.get $var_i ;; get local var: var_i
          i32.const 1 ;; push 1 on stack
          i32.add
          i32.const 4 ;; byte offset
          i32.mul ;; multiply index with byte offset
          i32.add ;; add offset to base address
          local.get $var_temp ;; get local var: var_temp
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
          drop ;; drop value of subtree
          i32.const 1 ;; push true on stack
          local.tee $var_swapped ;; set local var
          drop ;; drop value of subtree
          ;; End of let
        else
        end
        local.get $var_i ;; get local var: var_i
        local.get $var_i ;; get local var: var_i
        i32.const 1 ;; push 1 on stack
        i32.add
        local.tee $var_i ;; set local var
        drop
        drop ;; drop value of subtree
        br $loop_begin ;; jump to beginning of loop
      end
    end
    ;; End of let
    block $loop_exit$4 
      loop $loop_begin$5 
        local.get $var_swapped ;; get local var: var_swapped
        i32.eqz ;; evaluate loop condition
        br_if $loop_exit$4 ;; if false break
        i32.const 0 ;; push false on stack
        local.tee $var_swapped ;; set local var
        drop ;; drop value of subtree
        ;; Start of let
        i32.const 0 ;; push 0 on stack
        local.set $var_i$0 ;; set local var
        i32.const 0 ;; push 0 on stack
        local.tee $var_i$0 ;; set local var
        drop ;; drop value of init node
        block $loop_exit$2 
          loop $loop_begin$3 
            local.get $var_i$0 ;; get local var: var_i$0
            local.get $var_len ;; get local var: var_len
            i32.const 1 ;; push 1 on stack
            i32.sub
            i32.lt_s
            i32.eqz ;; evaluate loop condition
            br_if $loop_exit$2 ;; if false break
            local.get $var_i$0 ;; get local var: var_i$0
            i32.const 0 ;; put zero on stack
            i32.lt_s ;; check if index is >= 0
            if 
              i32.const 42 ;; error exit code push to stack
              global.set $exit_code ;; set exit code
              unreachable ;; exit program
            end
            local.get $var_i$0 ;; get local var: var_i$0
            local.get $arg_arr ;; get local var: arg_arr
            i32.load offset=4 ;; load length
            i32.ge_s ;; check if index is < length
            if 
              i32.const 42 ;; error exit code push to stack
              global.set $exit_code ;; set exit code
              unreachable ;; exit program
            end
            local.get $arg_arr ;; get local var: arg_arr
            i32.load ;; load data pointer
            local.get $var_i$0 ;; get local var: var_i$0
            i32.const 4 ;; byte offset
            i32.mul ;; multiply index with byte offset
            i32.add ;; add offset to base address
            i32.load ;; load value
            ;; end array element access node
            local.get $var_i$0 ;; get local var: var_i$0
            i32.const 1 ;; push 1 on stack
            i32.add
            i32.const 0 ;; put zero on stack
            i32.lt_s ;; check if index is >= 0
            if 
              i32.const 42 ;; error exit code push to stack
              global.set $exit_code ;; set exit code
              unreachable ;; exit program
            end
            local.get $var_i$0 ;; get local var: var_i$0
            i32.const 1 ;; push 1 on stack
            i32.add
            local.get $arg_arr ;; get local var: arg_arr
            i32.load offset=4 ;; load length
            i32.ge_s ;; check if index is < length
            if 
              i32.const 42 ;; error exit code push to stack
              global.set $exit_code ;; set exit code
              unreachable ;; exit program
            end
            local.get $arg_arr ;; get local var: arg_arr
            i32.load ;; load data pointer
            local.get $var_i$0 ;; get local var: var_i$0
            i32.const 1 ;; push 1 on stack
            i32.add
            i32.const 4 ;; byte offset
            i32.mul ;; multiply index with byte offset
            i32.add ;; add offset to base address
            i32.load ;; load value
            ;; end array element access node
            i32.gt_s
            if 
              ;; Start of let
              local.get $var_i$0 ;; get local var: var_i$0
              i32.const 0 ;; put zero on stack
              i32.lt_s ;; check if index is >= 0
              if 
                i32.const 42 ;; error exit code push to stack
                global.set $exit_code ;; set exit code
                unreachable ;; exit program
              end
              local.get $var_i$0 ;; get local var: var_i$0
              local.get $arg_arr ;; get local var: arg_arr
              i32.load offset=4 ;; load length
              i32.ge_s ;; check if index is < length
              if 
                i32.const 42 ;; error exit code push to stack
                global.set $exit_code ;; set exit code
                unreachable ;; exit program
              end
              local.get $arg_arr ;; get local var: arg_arr
              i32.load ;; load data pointer
              local.get $var_i$0 ;; get local var: var_i$0
              i32.const 4 ;; byte offset
              i32.mul ;; multiply index with byte offset
              i32.add ;; add offset to base address
              i32.load ;; load value
              ;; end array element access node
              local.set $var_temp$1 ;; set local var
              local.get $var_i$0 ;; get local var: var_i$0
              i32.const 0 ;; put zero on stack
              i32.lt_s ;; check if index is >= 0
              if 
                i32.const 42 ;; error exit code push to stack
                global.set $exit_code ;; set exit code
                unreachable ;; exit program
              end
              local.get $var_i$0 ;; get local var: var_i$0
              local.get $arg_arr ;; get local var: arg_arr
              i32.load offset=4 ;; load length
              i32.ge_s ;; check if index is < length
              if 
                i32.const 42 ;; error exit code push to stack
                global.set $exit_code ;; set exit code
                unreachable ;; exit program
              end
              local.get $arg_arr ;; get local var: arg_arr
              i32.load ;; load data pointer
              local.get $var_i$0 ;; get local var: var_i$0
              i32.const 4 ;; byte offset
              i32.mul ;; multiply index with byte offset
              i32.add ;; add offset to base address
              local.get $var_i$0 ;; get local var: var_i$0
              i32.const 1 ;; push 1 on stack
              i32.add
              i32.const 0 ;; put zero on stack
              i32.lt_s ;; check if index is >= 0
              if 
                i32.const 42 ;; error exit code push to stack
                global.set $exit_code ;; set exit code
                unreachable ;; exit program
              end
              local.get $var_i$0 ;; get local var: var_i$0
              i32.const 1 ;; push 1 on stack
              i32.add
              local.get $arg_arr ;; get local var: arg_arr
              i32.load offset=4 ;; load length
              i32.ge_s ;; check if index is < length
              if 
                i32.const 42 ;; error exit code push to stack
                global.set $exit_code ;; set exit code
                unreachable ;; exit program
              end
              local.get $arg_arr ;; get local var: arg_arr
              i32.load ;; load data pointer
              local.get $var_i$0 ;; get local var: var_i$0
              i32.const 1 ;; push 1 on stack
              i32.add
              i32.const 4 ;; byte offset
              i32.mul ;; multiply index with byte offset
              i32.add ;; add offset to base address
              i32.load ;; load value
              ;; end array element access node
              i32.store ;; store value in elem pos
              local.get $arg_arr ;; get local var: arg_arr
              i32.load ;; load data pointer
              local.get $var_i$0 ;; get local var: var_i$0
              i32.const 4 ;; byte offset
              i32.mul ;; multiply index with byte offset
              i32.add ;; add offset to base address
              i32.load ;; load int from elem pos
              drop ;; drop value of subtree
              local.get $var_i$0 ;; get local var: var_i$0
              i32.const 1 ;; push 1 on stack
              i32.add
              i32.const 0 ;; put zero on stack
              i32.lt_s ;; check if index is >= 0
              if 
                i32.const 42 ;; error exit code push to stack
                global.set $exit_code ;; set exit code
                unreachable ;; exit program
              end
              local.get $var_i$0 ;; get local var: var_i$0
              i32.const 1 ;; push 1 on stack
              i32.add
              local.get $arg_arr ;; get local var: arg_arr
              i32.load offset=4 ;; load length
              i32.ge_s ;; check if index is < length
              if 
                i32.const 42 ;; error exit code push to stack
                global.set $exit_code ;; set exit code
                unreachable ;; exit program
              end
              local.get $arg_arr ;; get local var: arg_arr
              i32.load ;; load data pointer
              local.get $var_i$0 ;; get local var: var_i$0
              i32.const 1 ;; push 1 on stack
              i32.add
              i32.const 4 ;; byte offset
              i32.mul ;; multiply index with byte offset
              i32.add ;; add offset to base address
              local.get $var_temp$1 ;; get local var: var_temp$1
              i32.store ;; store value in elem pos
              local.get $arg_arr ;; get local var: arg_arr
              i32.load ;; load data pointer
              local.get $var_i$0 ;; get local var: var_i$0
              i32.const 1 ;; push 1 on stack
              i32.add
              i32.const 4 ;; byte offset
              i32.mul ;; multiply index with byte offset
              i32.add ;; add offset to base address
              i32.load ;; load int from elem pos
              drop ;; drop value of subtree
              i32.const 1 ;; push true on stack
              local.tee $var_swapped ;; set local var
              drop ;; drop value of subtree
              ;; End of let
            else
            end
            local.get $var_i$0 ;; get local var: var_i$0
            local.get $var_i$0 ;; get local var: var_i$0
            i32.const 1 ;; push 1 on stack
            i32.add
            local.tee $var_i$0 ;; set local var
            drop
            drop ;; drop value of subtree
            br $loop_begin$3 ;; jump to beginning of loop
          end
        end
        ;; End of let
        br $loop_begin$5 ;; jump to beginning of loop
      end
    end
    ;; End of let
    ;; End of let
  )
  (func $fun_printArray (;2;) (param $cenv i32) (param $arg_arr$6 i32)  
     ;; local variables declarations:
    (local $var_x i32)

    ;; Start of let
    i32.const 0 ;; push 0 on stack
    local.set $var_x ;; set local var
    local.get $var_x ;; get local var: var_x
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    local.get $var_x ;; get local var: var_x
    local.get $arg_arr$6 ;; get local var: arg_arr$6
    i32.load offset=4 ;; load length
    i32.ge_s ;; check if index is < length
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    local.get $arg_arr$6 ;; get local var: arg_arr$6
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
    drop ;; drop value of the body
    block $loop_exit$7 
      loop $loop_begin$8 
        local.get $var_x ;; get local var: var_x
        ;; start array length node
        local.get $arg_arr$6 ;; get local var: arg_arr$6
        i32.load offset=4 ;; load length
        ;; end array length node
        i32.lt_s
        i32.eqz ;; evaluate loop condition
        br_if $loop_exit$7 ;; if false break
        local.get $var_x ;; get local var: var_x
        i32.const 0 ;; put zero on stack
        i32.lt_s ;; check if index is >= 0
        if 
          i32.const 42 ;; error exit code push to stack
          global.set $exit_code ;; set exit code
          unreachable ;; exit program
        end
        local.get $var_x ;; get local var: var_x
        local.get $arg_arr$6 ;; get local var: arg_arr$6
        i32.load offset=4 ;; load length
        i32.ge_s ;; check if index is < length
        if 
          i32.const 42 ;; error exit code push to stack
          global.set $exit_code ;; set exit code
          unreachable ;; exit program
        end
        local.get $arg_arr$6 ;; get local var: arg_arr$6
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
        drop ;; drop value of loop body
        br $loop_begin$8 ;; jump to beginning of loop
      end
    end
    ;; End of let
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (data (i32.const 8) "\14\00\00\00\13\00\00\00\11\00\00\00")
  (data (i32.const 20) "😰 initial array:")
  (data (i32.const 39) "\33\00\00\00\23\00\00\00\21\00\00\00")
  (data (i32.const 51) "🤔 sorting array... (bubble sort)")
  (data (i32.const 86) "\62\00\00\00\26\00\00\00\26\00\00\00")
  (data (i32.const 98) "--------------------------------------")
  (data (i32.const 136) "\94\00\00\00\11\00\00\00\0f\00\00\00")
  (data (i32.const 148) "✅ sorted array:")
  (data (i32.const 165) "\b1\00\00\00\07\00\00\00\05\00\00\00")
  (data (i32.const 177) "done✅")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)