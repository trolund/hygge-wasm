(module
  (type $i32_i32_=>_unit (;0;) (func (param i32) (param i32) ))
  (import "env" "writeInt" (;0;) (func $writeInt (param i32) ))
  (import "env" "writeS" (;1;) (func $writeS (param i32) (param i32) ))
  (memory (;0;) (export "memory") 1)
  (global $Sptr (;0;) (mut i32) (i32.const 0))
  (global $arr_ptr (;1;) (mut i32) (i32.const 0))
  (global $exit_code (;2;) (mut i32) (i32.const 0))
  (global $fun_insertionSort*ptr (;3;) (mut i32) (i32.const 0))
  (global $fun_printArray*ptr (;4;) (mut i32) (i32.const 4))
  (global $heap_base (;5;) (mut i32) (i32.const 187))
  (global $i (;6;) (mut i32) (i32.const 0))
  (global $var_arr (;7;) (mut i32) (i32.const 0))
  (table $func_table (;0;) 2 funcref)
  (elem (i32.const 0) (;0;) $fun_insertionSort)
  (elem (i32.const 1) (;1;) $fun_printArray)
  (func $_start (;0;)   
    ;; execution start here:
    ;; Start of let
    (global.set $var_arr ;; set local var, have been hoisted
      (if 
          (i32.le_s ;; check if length is <= 1
            (i32.const 10) ;; push 10 on stack
            (i32.const 1) ;; put one on stack
          )
        (then
          (global.set $exit_code ;; set exit code
            (i32.const 42) ;; error exit code push to stack
          )
          (unreachable) ;; exit program
        )
      )
      (global.set $arr_ptr ;; set struct pointer var, have been hoisted
        ;; start of struct contructor
        (if 
            (i32.ge_s ;; size need > current size
              (i32.add ;; find size need to allocate
                (global.get $heap_base) ;; get heap base
                (i32.const 8) ;; size of struct
              )
              (i32.mul ;; find current size
                (memory.size) ;; memory size
                (i32.const 65536) ;; page size
              )
            )
          (then
            (memory.grow ;; grow memory if needed
              (i32.div_s ;; grow memory!
                (i32.add ;; find size need to allocate
                  (global.get $heap_base) ;; get heap base
                  (i32.const 8) ;; size of struct
                )
                (i32.const 65536) ;; page size
              )
            )
            (drop) ;; drop new size
          )
        )
        (global.set $Sptr ;; set struct pointer var, have been hoisted
          (global.get $heap_base) ;; leave current heap base address
          (global.set $heap_base ;; set base pointer
            (i32.add ;; add size to heap base
              (global.get $heap_base) ;; get current heap base
              (i32.const 8) ;; size of struct
            )
          )
        )
        (i32.store ;; store int field in memory
          (i32.add ;; add offset to base address
            (global.get $Sptr) ;; get struct pointer var, have been hoisted
            (i32.const 0) ;; push field offset to stack
          )
          ;; init field (data)
          (i32.const 0) ;; push 0 on stack
        )
        (i32.store ;; store int field in memory
          (i32.add ;; add offset to base address
            (global.get $Sptr) ;; get struct pointer var, have been hoisted
            (i32.const 4) ;; push field offset to stack
          )
          ;; init field (length)
          (i32.const 10) ;; push 10 on stack
        )
        (global.get $Sptr) ;; push struct address to stack, have been hoisted
        ;; end of struct contructor
      )
      (i32.store ;; store pointer to data
        (global.get $arr_ptr) ;; get struct pointer var, have been hoisted
        (if 
            (i32.ge_s ;; size need > current size
              (i32.add ;; find size need to allocate
                (global.get $heap_base) ;; get heap base
                (i32.mul ;; multiply length with 4 to get size
                  (i32.const 10) ;; push 10 on stack
                  (i32.const 4) ;; 4 bytes
                )
              )
              (i32.mul ;; find current size
                (memory.size) ;; memory size
                (i32.const 65536) ;; page size
              )
            )
          (then
            (memory.grow ;; grow memory if needed
              (i32.div_s ;; grow memory!
                (i32.add ;; find size need to allocate
                  (global.get $heap_base) ;; get heap base
                  (i32.mul ;; multiply length with 4 to get size
                    (i32.const 10) ;; push 10 on stack
                    (i32.const 4) ;; 4 bytes
                  )
                )
                (i32.const 65536) ;; page size
              )
            )
            (drop) ;; drop new size
          )
        )
        (global.get $heap_base) ;; leave current heap base address
        (global.set $heap_base ;; set heap base
          (i32.add ;; add size to heap base
            (global.get $heap_base) ;; current base address
            (i32.mul ;; multiply length with 4 to get size
              (i32.const 10) ;; push 10 on stack
              (i32.const 4) ;; 4 bytes
            )
          )
        )
      )
      (global.set $i ;; , have been hoisted
        (i32.const 0)
      )
      (block $loop_exit$5 
        (loop $loop_begin$6 
          (i32.eq
            (i32.const 10) ;; push 10 on stack
            (global.get $i) ;; get i, have been hoisted
          )
          (br_if $loop_exit$5)
          (i32.store ;; store value in elem pos
            ;; start of loop body
            (i32.add ;; add offset to base address
              (i32.mul ;; multiply index with byte offset
                (i32.load ;; load data pointer
                  (global.get $arr_ptr) ;; get struct pointer var, have been hoisted
                )
                (global.get $i) ;; get index, have been hoisted
                (i32.const 4) ;; byte offset
              )
            )
            (i32.const 0) ;; push 0 on stack
          )
          ;; end of loop body
          (global.set $i ;; write to i, have been hoisted
            (i32.add ;; add 1 to i
              (global.get $i) ;; get i, have been hoisted
              (i32.const 1) ;; increment by 1
            )
          )
          (br $loop_begin$6)
        )
      )
      (global.get $arr_ptr) ;; leave pointer to allocated array struct on stack, have been hoisted
    )
    (if 
        (i32.lt_s ;; check if index is >= 0
          (i32.const 0) ;; push 0 on stack
          (i32.const 0) ;; put zero on stack
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.ge_s ;; check if index is < length
          (i32.const 0) ;; push 0 on stack
          (i32.load offset=4
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (i32.store ;; store value in elem pos
      (i32.add ;; add offset to base address
        (i32.mul ;; multiply index with byte offset
          (i32.load ;; load data pointer
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
          (i32.const 0) ;; push 0 on stack
          (i32.const 4) ;; byte offset
        )
      )
      (i32.const 500) ;; push 500 on stack
    )
    (i32.load ;; load int from elem pos
      (i32.add ;; add offset to base address
        (i32.mul ;; multiply index with byte offset
          (i32.load ;; load data pointer
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
          (i32.const 0) ;; push 0 on stack
          (i32.const 4) ;; byte offset
        )
      )
    )
    (drop)
    (if 
        (i32.lt_s ;; check if index is >= 0
          (i32.const 1) ;; push 1 on stack
          (i32.const 0) ;; put zero on stack
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.ge_s ;; check if index is < length
          (i32.const 1) ;; push 1 on stack
          (i32.load offset=4
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (i32.store ;; store value in elem pos
      (i32.add ;; add offset to base address
        (i32.mul ;; multiply index with byte offset
          (i32.load ;; load data pointer
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
          (i32.const 1) ;; push 1 on stack
          (i32.const 4) ;; byte offset
        )
      )
      (i32.const 3) ;; push 3 on stack
    )
    (i32.load ;; load int from elem pos
      (i32.add ;; add offset to base address
        (i32.mul ;; multiply index with byte offset
          (i32.load ;; load data pointer
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
          (i32.const 1) ;; push 1 on stack
          (i32.const 4) ;; byte offset
        )
      )
    )
    (drop)
    (if 
        (i32.lt_s ;; check if index is >= 0
          (i32.const 2) ;; push 2 on stack
          (i32.const 0) ;; put zero on stack
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.ge_s ;; check if index is < length
          (i32.const 2) ;; push 2 on stack
          (i32.load offset=4
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (i32.store ;; store value in elem pos
      (i32.add ;; add offset to base address
        (i32.mul ;; multiply index with byte offset
          (i32.load ;; load data pointer
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
          (i32.const 2) ;; push 2 on stack
          (i32.const 4) ;; byte offset
        )
      )
      (i32.const 11) ;; push 11 on stack
    )
    (i32.load ;; load int from elem pos
      (i32.add ;; add offset to base address
        (i32.mul ;; multiply index with byte offset
          (i32.load ;; load data pointer
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
          (i32.const 2) ;; push 2 on stack
          (i32.const 4) ;; byte offset
        )
      )
    )
    (drop)
    (if 
        (i32.lt_s ;; check if index is >= 0
          (i32.const 3) ;; push 3 on stack
          (i32.const 0) ;; put zero on stack
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.ge_s ;; check if index is < length
          (i32.const 3) ;; push 3 on stack
          (i32.load offset=4
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (i32.store ;; store value in elem pos
      (i32.add ;; add offset to base address
        (i32.mul ;; multiply index with byte offset
          (i32.load ;; load data pointer
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
          (i32.const 3) ;; push 3 on stack
          (i32.const 4) ;; byte offset
        )
      )
      (i32.const 22) ;; push 22 on stack
    )
    (i32.load ;; load int from elem pos
      (i32.add ;; add offset to base address
        (i32.mul ;; multiply index with byte offset
          (i32.load ;; load data pointer
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
          (i32.const 3) ;; push 3 on stack
          (i32.const 4) ;; byte offset
        )
      )
    )
    (drop)
    (if 
        (i32.lt_s ;; check if index is >= 0
          (i32.const 4) ;; push 4 on stack
          (i32.const 0) ;; put zero on stack
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.ge_s ;; check if index is < length
          (i32.const 4) ;; push 4 on stack
          (i32.load offset=4
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (i32.store ;; store value in elem pos
      (i32.add ;; add offset to base address
        (i32.mul ;; multiply index with byte offset
          (i32.load ;; load data pointer
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
          (i32.const 4) ;; push 4 on stack
          (i32.const 4) ;; byte offset
        )
      )
      (i32.const 45) ;; push 45 on stack
    )
    (i32.load ;; load int from elem pos
      (i32.add ;; add offset to base address
        (i32.mul ;; multiply index with byte offset
          (i32.load ;; load data pointer
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
          (i32.const 4) ;; push 4 on stack
          (i32.const 4) ;; byte offset
        )
      )
    )
    (drop)
    (if 
        (i32.lt_s ;; check if index is >= 0
          (i32.const 5) ;; push 5 on stack
          (i32.const 0) ;; put zero on stack
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.ge_s ;; check if index is < length
          (i32.const 5) ;; push 5 on stack
          (i32.load offset=4
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (i32.store ;; store value in elem pos
      (i32.add ;; add offset to base address
        (i32.mul ;; multiply index with byte offset
          (i32.load ;; load data pointer
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
          (i32.const 5) ;; push 5 on stack
          (i32.const 4) ;; byte offset
        )
      )
      (i32.const 61) ;; push 61 on stack
    )
    (i32.load ;; load int from elem pos
      (i32.add ;; add offset to base address
        (i32.mul ;; multiply index with byte offset
          (i32.load ;; load data pointer
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
          (i32.const 5) ;; push 5 on stack
          (i32.const 4) ;; byte offset
        )
      )
    )
    (drop)
    (if 
        (i32.lt_s ;; check if index is >= 0
          (i32.const 6) ;; push 6 on stack
          (i32.const 0) ;; put zero on stack
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.ge_s ;; check if index is < length
          (i32.const 6) ;; push 6 on stack
          (i32.load offset=4
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (i32.store ;; store value in elem pos
      (i32.add ;; add offset to base address
        (i32.mul ;; multiply index with byte offset
          (i32.load ;; load data pointer
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
          (i32.const 6) ;; push 6 on stack
          (i32.const 4) ;; byte offset
        )
      )
      (i32.const 100) ;; push 100 on stack
    )
    (i32.load ;; load int from elem pos
      (i32.add ;; add offset to base address
        (i32.mul ;; multiply index with byte offset
          (i32.load ;; load data pointer
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
          (i32.const 6) ;; push 6 on stack
          (i32.const 4) ;; byte offset
        )
      )
    )
    (drop)
    (if 
        (i32.lt_s ;; check if index is >= 0
          (i32.const 7) ;; push 7 on stack
          (i32.const 0) ;; put zero on stack
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.ge_s ;; check if index is < length
          (i32.const 7) ;; push 7 on stack
          (i32.load offset=4
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (i32.store ;; store value in elem pos
      (i32.add ;; add offset to base address
        (i32.mul ;; multiply index with byte offset
          (i32.load ;; load data pointer
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
          (i32.const 7) ;; push 7 on stack
          (i32.const 4) ;; byte offset
        )
      )
      (i32.const 200) ;; push 200 on stack
    )
    (i32.load ;; load int from elem pos
      (i32.add ;; add offset to base address
        (i32.mul ;; multiply index with byte offset
          (i32.load ;; load data pointer
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
          (i32.const 7) ;; push 7 on stack
          (i32.const 4) ;; byte offset
        )
      )
    )
    (drop)
    (if 
        (i32.lt_s ;; check if index is >= 0
          (i32.const 8) ;; push 8 on stack
          (i32.const 0) ;; put zero on stack
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.ge_s ;; check if index is < length
          (i32.const 8) ;; push 8 on stack
          (i32.load offset=4
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (i32.store ;; store value in elem pos
      (i32.add ;; add offset to base address
        (i32.mul ;; multiply index with byte offset
          (i32.load ;; load data pointer
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
          (i32.const 8) ;; push 8 on stack
          (i32.const 4) ;; byte offset
        )
      )
      (i32.const 34) ;; push 34 on stack
    )
    (i32.load ;; load int from elem pos
      (i32.add ;; add offset to base address
        (i32.mul ;; multiply index with byte offset
          (i32.load ;; load data pointer
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
          (i32.const 8) ;; push 8 on stack
          (i32.const 4) ;; byte offset
        )
      )
    )
    (drop)
    (if 
        (i32.lt_s ;; check if index is >= 0
          (i32.const 9) ;; push 9 on stack
          (i32.const 0) ;; put zero on stack
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.ge_s ;; check if index is < length
          (i32.const 9) ;; push 9 on stack
          (i32.load offset=4
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (i32.store ;; store value in elem pos
      (i32.add ;; add offset to base address
        (i32.mul ;; multiply index with byte offset
          (i32.load ;; load data pointer
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
          (i32.const 9) ;; push 9 on stack
          (i32.const 4) ;; byte offset
        )
      )
      (i32.const 80) ;; push 80 on stack
    )
    (i32.load ;; load int from elem pos
      (i32.add ;; add offset to base address
        (i32.mul ;; multiply index with byte offset
          (i32.load ;; load data pointer
            (global.get $var_arr) ;; get local var: var_arr, have been hoisted
          )
          (i32.const 9) ;; push 9 on stack
          (i32.const 4) ;; byte offset
        )
      )
    )
    (drop)
    (i32.load ;; Load string pointer
      (i32.const 8) ;; leave pointer to string on stack
    )
    (i32.load offset=4
      (i32.const 8) ;; leave pointer to string on stack
    )
    (call $writeS) ;; call host function
    ;; Load expression to be applied as a function
    (call_indirect (type $i32_i32_=>_unit) ;; call function
      (i32.load offset=4
        (global.get $fun_printArray*ptr) ;; get global var: fun_printArray*ptr
      )
      (global.get $var_arr) ;; get local var: var_arr, have been hoisted
      (i32.load ;; load table index
        (global.get $fun_printArray*ptr) ;; get global var: fun_printArray*ptr
      )
    )
    (i32.load ;; Load string pointer
      (i32.const 39) ;; leave pointer to string on stack
    )
    (i32.load offset=4
      (i32.const 39) ;; leave pointer to string on stack
    )
    (call $writeS) ;; call host function
    ;; Load expression to be applied as a function
    (call_indirect (type $i32_i32_=>_unit) ;; call function
      (i32.load offset=4
        (global.get $fun_insertionSort*ptr) ;; get global var: fun_insertionSort*ptr
      )
      (global.get $var_arr) ;; get local var: var_arr, have been hoisted
      (i32.load ;; load table index
        (global.get $fun_insertionSort*ptr) ;; get global var: fun_insertionSort*ptr
      )
    )
    (i32.load ;; Load string pointer
      (i32.const 89) ;; leave pointer to string on stack
    )
    (i32.load offset=4
      (i32.const 89) ;; leave pointer to string on stack
    )
    (call $writeS) ;; call host function
    (i32.load ;; Load string pointer
      (i32.const 139) ;; leave pointer to string on stack
    )
    (i32.load offset=4
      (i32.const 139) ;; leave pointer to string on stack
    )
    (call $writeS) ;; call host function
    ;; Load expression to be applied as a function
    (call_indirect (type $i32_i32_=>_unit) ;; call function
      (i32.load offset=4
        (global.get $fun_printArray*ptr) ;; get global var: fun_printArray*ptr
      )
      (global.get $var_arr) ;; get local var: var_arr, have been hoisted
      (i32.load ;; load table index
        (global.get $fun_printArray*ptr) ;; get global var: fun_printArray*ptr
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (if 
                (i32.lt_s ;; check if index is >= 0
                  (i32.const 0) ;; push 0 on stack
                  (i32.const 0) ;; put zero on stack
                )
              (then
                (global.set $exit_code ;; set exit code
                  (i32.const 42) ;; error exit code push to stack
                )
                (unreachable) ;; exit program
              )
            )
            (if 
                (i32.ge_s ;; check if index is < length
                  (i32.const 0) ;; push 0 on stack
                  (i32.load offset=4
                    (global.get $var_arr) ;; get local var: var_arr, have been hoisted
                  )
                )
              (then
                (global.set $exit_code ;; set exit code
                  (i32.const 42) ;; error exit code push to stack
                )
                (unreachable) ;; exit program
              )
            )
            (i32.load ;; load value
              (i32.add ;; add offset to base address
                (i32.mul ;; multiply index with byte offset
                  (i32.load ;; load data pointer
                    (global.get $var_arr) ;; get local var: var_arr, have been hoisted
                  )
                  (i32.const 0) ;; push 0 on stack
                  (i32.const 4) ;; byte offset
                )
              )
            )
            ;; end array element access node
            (i32.const 3) ;; push 3 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (if 
                (i32.lt_s ;; check if index is >= 0
                  (i32.const 1) ;; push 1 on stack
                  (i32.const 0) ;; put zero on stack
                )
              (then
                (global.set $exit_code ;; set exit code
                  (i32.const 42) ;; error exit code push to stack
                )
                (unreachable) ;; exit program
              )
            )
            (if 
                (i32.ge_s ;; check if index is < length
                  (i32.const 1) ;; push 1 on stack
                  (i32.load offset=4
                    (global.get $var_arr) ;; get local var: var_arr, have been hoisted
                  )
                )
              (then
                (global.set $exit_code ;; set exit code
                  (i32.const 42) ;; error exit code push to stack
                )
                (unreachable) ;; exit program
              )
            )
            (i32.load ;; load value
              (i32.add ;; add offset to base address
                (i32.mul ;; multiply index with byte offset
                  (i32.load ;; load data pointer
                    (global.get $var_arr) ;; get local var: var_arr, have been hoisted
                  )
                  (i32.const 1) ;; push 1 on stack
                  (i32.const 4) ;; byte offset
                )
              )
            )
            ;; end array element access node
            (i32.const 11) ;; push 11 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (if 
                (i32.lt_s ;; check if index is >= 0
                  (i32.const 2) ;; push 2 on stack
                  (i32.const 0) ;; put zero on stack
                )
              (then
                (global.set $exit_code ;; set exit code
                  (i32.const 42) ;; error exit code push to stack
                )
                (unreachable) ;; exit program
              )
            )
            (if 
                (i32.ge_s ;; check if index is < length
                  (i32.const 2) ;; push 2 on stack
                  (i32.load offset=4
                    (global.get $var_arr) ;; get local var: var_arr, have been hoisted
                  )
                )
              (then
                (global.set $exit_code ;; set exit code
                  (i32.const 42) ;; error exit code push to stack
                )
                (unreachable) ;; exit program
              )
            )
            (i32.load ;; load value
              (i32.add ;; add offset to base address
                (i32.mul ;; multiply index with byte offset
                  (i32.load ;; load data pointer
                    (global.get $var_arr) ;; get local var: var_arr, have been hoisted
                  )
                  (i32.const 2) ;; push 2 on stack
                  (i32.const 4) ;; byte offset
                )
              )
            )
            ;; end array element access node
            (i32.const 22) ;; push 22 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (if 
                (i32.lt_s ;; check if index is >= 0
                  (i32.const 3) ;; push 3 on stack
                  (i32.const 0) ;; put zero on stack
                )
              (then
                (global.set $exit_code ;; set exit code
                  (i32.const 42) ;; error exit code push to stack
                )
                (unreachable) ;; exit program
              )
            )
            (if 
                (i32.ge_s ;; check if index is < length
                  (i32.const 3) ;; push 3 on stack
                  (i32.load offset=4
                    (global.get $var_arr) ;; get local var: var_arr, have been hoisted
                  )
                )
              (then
                (global.set $exit_code ;; set exit code
                  (i32.const 42) ;; error exit code push to stack
                )
                (unreachable) ;; exit program
              )
            )
            (i32.load ;; load value
              (i32.add ;; add offset to base address
                (i32.mul ;; multiply index with byte offset
                  (i32.load ;; load data pointer
                    (global.get $var_arr) ;; get local var: var_arr, have been hoisted
                  )
                  (i32.const 3) ;; push 3 on stack
                  (i32.const 4) ;; byte offset
                )
              )
            )
            ;; end array element access node
            (i32.const 34) ;; push 34 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (if 
                (i32.lt_s ;; check if index is >= 0
                  (i32.const 4) ;; push 4 on stack
                  (i32.const 0) ;; put zero on stack
                )
              (then
                (global.set $exit_code ;; set exit code
                  (i32.const 42) ;; error exit code push to stack
                )
                (unreachable) ;; exit program
              )
            )
            (if 
                (i32.ge_s ;; check if index is < length
                  (i32.const 4) ;; push 4 on stack
                  (i32.load offset=4
                    (global.get $var_arr) ;; get local var: var_arr, have been hoisted
                  )
                )
              (then
                (global.set $exit_code ;; set exit code
                  (i32.const 42) ;; error exit code push to stack
                )
                (unreachable) ;; exit program
              )
            )
            (i32.load ;; load value
              (i32.add ;; add offset to base address
                (i32.mul ;; multiply index with byte offset
                  (i32.load ;; load data pointer
                    (global.get $var_arr) ;; get local var: var_arr, have been hoisted
                  )
                  (i32.const 4) ;; push 4 on stack
                  (i32.const 4) ;; byte offset
                )
              )
            )
            ;; end array element access node
            (i32.const 45) ;; push 45 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (if 
                (i32.lt_s ;; check if index is >= 0
                  (i32.const 5) ;; push 5 on stack
                  (i32.const 0) ;; put zero on stack
                )
              (then
                (global.set $exit_code ;; set exit code
                  (i32.const 42) ;; error exit code push to stack
                )
                (unreachable) ;; exit program
              )
            )
            (if 
                (i32.ge_s ;; check if index is < length
                  (i32.const 5) ;; push 5 on stack
                  (i32.load offset=4
                    (global.get $var_arr) ;; get local var: var_arr, have been hoisted
                  )
                )
              (then
                (global.set $exit_code ;; set exit code
                  (i32.const 42) ;; error exit code push to stack
                )
                (unreachable) ;; exit program
              )
            )
            (i32.load ;; load value
              (i32.add ;; add offset to base address
                (i32.mul ;; multiply index with byte offset
                  (i32.load ;; load data pointer
                    (global.get $var_arr) ;; get local var: var_arr, have been hoisted
                  )
                  (i32.const 5) ;; push 5 on stack
                  (i32.const 4) ;; byte offset
                )
              )
            )
            ;; end array element access node
            (i32.const 61) ;; push 61 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (if 
                (i32.lt_s ;; check if index is >= 0
                  (i32.const 6) ;; push 6 on stack
                  (i32.const 0) ;; put zero on stack
                )
              (then
                (global.set $exit_code ;; set exit code
                  (i32.const 42) ;; error exit code push to stack
                )
                (unreachable) ;; exit program
              )
            )
            (if 
                (i32.ge_s ;; check if index is < length
                  (i32.const 6) ;; push 6 on stack
                  (i32.load offset=4
                    (global.get $var_arr) ;; get local var: var_arr, have been hoisted
                  )
                )
              (then
                (global.set $exit_code ;; set exit code
                  (i32.const 42) ;; error exit code push to stack
                )
                (unreachable) ;; exit program
              )
            )
            (i32.load ;; load value
              (i32.add ;; add offset to base address
                (i32.mul ;; multiply index with byte offset
                  (i32.load ;; load data pointer
                    (global.get $var_arr) ;; get local var: var_arr, have been hoisted
                  )
                  (i32.const 6) ;; push 6 on stack
                  (i32.const 4) ;; byte offset
                )
              )
            )
            ;; end array element access node
            (i32.const 80) ;; push 80 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (if 
                (i32.lt_s ;; check if index is >= 0
                  (i32.const 7) ;; push 7 on stack
                  (i32.const 0) ;; put zero on stack
                )
              (then
                (global.set $exit_code ;; set exit code
                  (i32.const 42) ;; error exit code push to stack
                )
                (unreachable) ;; exit program
              )
            )
            (if 
                (i32.ge_s ;; check if index is < length
                  (i32.const 7) ;; push 7 on stack
                  (i32.load offset=4
                    (global.get $var_arr) ;; get local var: var_arr, have been hoisted
                  )
                )
              (then
                (global.set $exit_code ;; set exit code
                  (i32.const 42) ;; error exit code push to stack
                )
                (unreachable) ;; exit program
              )
            )
            (i32.load ;; load value
              (i32.add ;; add offset to base address
                (i32.mul ;; multiply index with byte offset
                  (i32.load ;; load data pointer
                    (global.get $var_arr) ;; get local var: var_arr, have been hoisted
                  )
                  (i32.const 7) ;; push 7 on stack
                  (i32.const 4) ;; byte offset
                )
              )
            )
            ;; end array element access node
            (i32.const 100) ;; push 100 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (if 
                (i32.lt_s ;; check if index is >= 0
                  (i32.const 8) ;; push 8 on stack
                  (i32.const 0) ;; put zero on stack
                )
              (then
                (global.set $exit_code ;; set exit code
                  (i32.const 42) ;; error exit code push to stack
                )
                (unreachable) ;; exit program
              )
            )
            (if 
                (i32.ge_s ;; check if index is < length
                  (i32.const 8) ;; push 8 on stack
                  (i32.load offset=4
                    (global.get $var_arr) ;; get local var: var_arr, have been hoisted
                  )
                )
              (then
                (global.set $exit_code ;; set exit code
                  (i32.const 42) ;; error exit code push to stack
                )
                (unreachable) ;; exit program
              )
            )
            (i32.load ;; load value
              (i32.add ;; add offset to base address
                (i32.mul ;; multiply index with byte offset
                  (i32.load ;; load data pointer
                    (global.get $var_arr) ;; get local var: var_arr, have been hoisted
                  )
                  (i32.const 8) ;; push 8 on stack
                  (i32.const 4) ;; byte offset
                )
              )
            )
            ;; end array element access node
            (i32.const 200) ;; push 200 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (if 
                (i32.lt_s ;; check if index is >= 0
                  (i32.const 9) ;; push 9 on stack
                  (i32.const 0) ;; put zero on stack
                )
              (then
                (global.set $exit_code ;; set exit code
                  (i32.const 42) ;; error exit code push to stack
                )
                (unreachable) ;; exit program
              )
            )
            (if 
                (i32.ge_s ;; check if index is < length
                  (i32.const 9) ;; push 9 on stack
                  (i32.load offset=4
                    (global.get $var_arr) ;; get local var: var_arr, have been hoisted
                  )
                )
              (then
                (global.set $exit_code ;; set exit code
                  (i32.const 42) ;; error exit code push to stack
                )
                (unreachable) ;; exit program
              )
            )
            (i32.load ;; load value
              (i32.add ;; add offset to base address
                (i32.mul ;; multiply index with byte offset
                  (i32.load ;; load data pointer
                    (global.get $var_arr) ;; get local var: var_arr, have been hoisted
                  )
                  (i32.const 9) ;; push 9 on stack
                  (i32.const 4) ;; byte offset
                )
              )
            )
            ;; end array element access node
            (i32.const 500) ;; push 500 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (i32.load ;; Load string pointer
      (i32.const 168) ;; leave pointer to string on stack
    )
    (i32.load offset=4
      (i32.const 168) ;; leave pointer to string on stack
    )
    (call $writeS) ;; call host function
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (func $fun_insertionSort (;1;) (param $cenv i32) (param $arg_arr i32)  
     ;; local variables declarations:
    (local $var_i i32)
    (local $var_j i32)
    (local $var_key i32)
    (local $var_len i32)

    ;; Start of let
    (local.set $var_len ;; set local var
      ;; start array length node
      (i32.load offset=4
        (local.get $arg_arr) ;; get local var: arg_arr
      )
      ;; end array length node
    )
    ;; Start of let
    (local.set $var_i ;; set local var
      (i32.const 0) ;; push 0 on stack
    )
    (local.tee $var_i ;; set local var
      (i32.const 1) ;; push 1 on stack
    )
    (drop)
    (block $loop_exit$0 
      (loop $loop_begin$1 
        (i32.eqz
          (i32.lt_s
            (local.get $var_i) ;; get local var: var_i
            (local.get $var_len) ;; get local var: var_len
          )
        )
        (br_if $loop_exit$0)
        ;; Start of let
        (local.set $var_key ;; set local var
          (if 
              (i32.lt_s ;; check if index is >= 0
                (local.get $var_i) ;; get local var: var_i
                (i32.const 0) ;; put zero on stack
              )
            (then
              (global.set $exit_code ;; set exit code
                (i32.const 42) ;; error exit code push to stack
              )
              (unreachable) ;; exit program
            )
          )
          (if 
              (i32.ge_s ;; check if index is < length
                (local.get $var_i) ;; get local var: var_i
                (i32.load offset=4
                  (local.get $arg_arr) ;; get local var: arg_arr
                )
              )
            (then
              (global.set $exit_code ;; set exit code
                (i32.const 42) ;; error exit code push to stack
              )
              (unreachable) ;; exit program
            )
          )
          (i32.load ;; load value
            (i32.add ;; add offset to base address
              (i32.mul ;; multiply index with byte offset
                (i32.load ;; load data pointer
                  (local.get $arg_arr) ;; get local var: arg_arr
                )
                (local.get $var_i) ;; get local var: var_i
                (i32.const 4) ;; byte offset
              )
            )
          )
          ;; end array element access node
        )
        ;; Start of let
        (local.set $var_j ;; set local var
          (i32.sub
            (local.get $var_i) ;; get local var: var_i
            (i32.const 1) ;; push 1 on stack
          )
        )
        (block $loop_exit 
          (loop $loop_begin 
            (i32.eqz
              (if (result i32)
                  (i32.ge_s
                    (local.get $var_j) ;; get local var: var_j
                    (i32.const 0) ;; push 0 on stack
                  )
                (then
                  (i32.gt_s
                    (if 
                        (i32.lt_s ;; check if index is >= 0
                          (local.get $var_j) ;; get local var: var_j
                          (i32.const 0) ;; put zero on stack
                        )
                      (then
                        (global.set $exit_code ;; set exit code
                          (i32.const 42) ;; error exit code push to stack
                        )
                        (unreachable) ;; exit program
                      )
                    )
                    (if 
                        (i32.ge_s ;; check if index is < length
                          (local.get $var_j) ;; get local var: var_j
                          (i32.load offset=4
                            (local.get $arg_arr) ;; get local var: arg_arr
                          )
                        )
                      (then
                        (global.set $exit_code ;; set exit code
                          (i32.const 42) ;; error exit code push to stack
                        )
                        (unreachable) ;; exit program
                      )
                    )
                    (i32.load ;; load value
                      (i32.add ;; add offset to base address
                        (i32.mul ;; multiply index with byte offset
                          (i32.load ;; load data pointer
                            (local.get $arg_arr) ;; get local var: arg_arr
                          )
                          (local.get $var_j) ;; get local var: var_j
                          (i32.const 4) ;; byte offset
                        )
                      )
                    )
                    ;; end array element access node
                    (local.get $var_key) ;; get local var: var_key
                  )
                )
                (else
                  (i32.const 0) ;; push 0 on stack
                )
              )
            )
            (br_if $loop_exit)
            (if 
                (i32.lt_s ;; check if index is >= 0
                  (i32.add
                    (local.get $var_j) ;; get local var: var_j
                    (i32.const 1) ;; push 1 on stack
                  )
                  (i32.const 0) ;; put zero on stack
                )
              (then
                (global.set $exit_code ;; set exit code
                  (i32.const 42) ;; error exit code push to stack
                )
                (unreachable) ;; exit program
              )
            )
            (if 
                (i32.ge_s ;; check if index is < length
                  (i32.add
                    (local.get $var_j) ;; get local var: var_j
                    (i32.const 1) ;; push 1 on stack
                  )
                  (i32.load offset=4
                    (local.get $arg_arr) ;; get local var: arg_arr
                  )
                )
              (then
                (global.set $exit_code ;; set exit code
                  (i32.const 42) ;; error exit code push to stack
                )
                (unreachable) ;; exit program
              )
            )
            (i32.store ;; store value in elem pos
              (i32.add ;; add offset to base address
                (i32.mul ;; multiply index with byte offset
                  (i32.load ;; load data pointer
                    (local.get $arg_arr) ;; get local var: arg_arr
                  )
                  (i32.add
                    (local.get $var_j) ;; get local var: var_j
                    (i32.const 1) ;; push 1 on stack
                  )
                  (i32.const 4) ;; byte offset
                )
              )
              (if 
                  (i32.lt_s ;; check if index is >= 0
                    (local.get $var_j) ;; get local var: var_j
                    (i32.const 0) ;; put zero on stack
                  )
                (then
                  (global.set $exit_code ;; set exit code
                    (i32.const 42) ;; error exit code push to stack
                  )
                  (unreachable) ;; exit program
                )
              )
              (if 
                  (i32.ge_s ;; check if index is < length
                    (local.get $var_j) ;; get local var: var_j
                    (i32.load offset=4
                      (local.get $arg_arr) ;; get local var: arg_arr
                    )
                  )
                (then
                  (global.set $exit_code ;; set exit code
                    (i32.const 42) ;; error exit code push to stack
                  )
                  (unreachable) ;; exit program
                )
              )
              (i32.load ;; load value
                (i32.add ;; add offset to base address
                  (i32.mul ;; multiply index with byte offset
                    (i32.load ;; load data pointer
                      (local.get $arg_arr) ;; get local var: arg_arr
                    )
                    (local.get $var_j) ;; get local var: var_j
                    (i32.const 4) ;; byte offset
                  )
                )
              )
              ;; end array element access node
            )
            (i32.load ;; load int from elem pos
              (i32.add ;; add offset to base address
                (i32.mul ;; multiply index with byte offset
                  (i32.load ;; load data pointer
                    (local.get $arg_arr) ;; get local var: arg_arr
                  )
                  (i32.add
                    (local.get $var_j) ;; get local var: var_j
                    (i32.const 1) ;; push 1 on stack
                  )
                  (i32.const 4) ;; byte offset
                )
              )
            )
            (drop)
            (local.tee $var_j ;; set local var
              (i32.sub
                (local.get $var_j) ;; get local var: var_j
                (i32.const 1) ;; push 1 on stack
              )
            )
            (br $loop_begin)
          )
        )
        (if 
            (i32.lt_s ;; check if index is >= 0
              (i32.add
                (local.get $var_j) ;; get local var: var_j
                (i32.const 1) ;; push 1 on stack
              )
              (i32.const 0) ;; put zero on stack
            )
          (then
            (global.set $exit_code ;; set exit code
              (i32.const 42) ;; error exit code push to stack
            )
            (unreachable) ;; exit program
          )
        )
        (if 
            (i32.ge_s ;; check if index is < length
              (i32.add
                (local.get $var_j) ;; get local var: var_j
                (i32.const 1) ;; push 1 on stack
              )
              (i32.load offset=4
                (local.get $arg_arr) ;; get local var: arg_arr
              )
            )
          (then
            (global.set $exit_code ;; set exit code
              (i32.const 42) ;; error exit code push to stack
            )
            (unreachable) ;; exit program
          )
        )
        (i32.store ;; store value in elem pos
          (i32.add ;; add offset to base address
            (i32.mul ;; multiply index with byte offset
              (i32.load ;; load data pointer
                (local.get $arg_arr) ;; get local var: arg_arr
              )
              (i32.add
                (local.get $var_j) ;; get local var: var_j
                (i32.const 1) ;; push 1 on stack
              )
              (i32.const 4) ;; byte offset
            )
          )
          (local.get $var_key) ;; get local var: var_key
        )
        (i32.load ;; load int from elem pos
          (i32.add ;; add offset to base address
            (i32.mul ;; multiply index with byte offset
              (i32.load ;; load data pointer
                (local.get $arg_arr) ;; get local var: arg_arr
              )
              (i32.add
                (local.get $var_j) ;; get local var: var_j
                (i32.const 1) ;; push 1 on stack
              )
              (i32.const 4) ;; byte offset
            )
          )
        )
        ;; End of let
        ;; End of let
        (drop)
        (local.get $var_i) ;; get local var: var_i
        (local.tee $var_i ;; set local var
          (i32.add
            (local.get $var_i) ;; get local var: var_i
            (i32.const 1) ;; push 1 on stack
          )
        )
        (drop)
        (drop)
        (br $loop_begin$1)
      )
    )
    ;; End of let
    ;; End of let
  )
  (func $fun_printArray (;2;) (param $cenv i32) (param $arg_arr$2 i32)  
     ;; local variables declarations:
    (local $var_x i32)

    ;; Start of let
    (local.set $var_x ;; set local var
      (i32.const 0) ;; push 0 on stack
    )
    (if 
        (i32.lt_s ;; check if index is >= 0
          (local.get $var_x) ;; get local var: var_x
          (i32.const 0) ;; put zero on stack
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.ge_s ;; check if index is < length
          (local.get $var_x) ;; get local var: var_x
          (i32.load offset=4
            (local.get $arg_arr$2) ;; get local var: arg_arr$2
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (i32.load ;; load value
      (i32.add ;; add offset to base address
        (i32.mul ;; multiply index with byte offset
          (i32.load ;; load data pointer
            (local.get $arg_arr$2) ;; get local var: arg_arr$2
          )
          (local.get $var_x) ;; get local var: var_x
          (i32.const 4) ;; byte offset
        )
      )
    )
    ;; end array element access node
    (call $writeInt) ;; call host function
    (local.tee $var_x ;; set local var
      (i32.add
        (local.get $var_x) ;; get local var: var_x
        (i32.const 1) ;; push 1 on stack
      )
    )
    (drop)
    (block $loop_exit$3 
      (loop $loop_begin$4 
        (i32.eqz
          (i32.lt_s
            (local.get $var_x) ;; get local var: var_x
            ;; start array length node
            (i32.load offset=4
              (local.get $arg_arr$2) ;; get local var: arg_arr$2
            )
            ;; end array length node
          )
        )
        (br_if $loop_exit$3)
        (if 
            (i32.lt_s ;; check if index is >= 0
              (local.get $var_x) ;; get local var: var_x
              (i32.const 0) ;; put zero on stack
            )
          (then
            (global.set $exit_code ;; set exit code
              (i32.const 42) ;; error exit code push to stack
            )
            (unreachable) ;; exit program
          )
        )
        (if 
            (i32.ge_s ;; check if index is < length
              (local.get $var_x) ;; get local var: var_x
              (i32.load offset=4
                (local.get $arg_arr$2) ;; get local var: arg_arr$2
              )
            )
          (then
            (global.set $exit_code ;; set exit code
              (i32.const 42) ;; error exit code push to stack
            )
            (unreachable) ;; exit program
          )
        )
        (i32.load ;; load value
          (i32.add ;; add offset to base address
            (i32.mul ;; multiply index with byte offset
              (i32.load ;; load data pointer
                (local.get $arg_arr$2) ;; get local var: arg_arr$2
              )
              (local.get $var_x) ;; get local var: var_x
              (i32.const 4) ;; byte offset
            )
          )
        )
        ;; end array element access node
        (call $writeInt) ;; call host function
        (local.tee $var_x ;; set local var
          (i32.add
            (local.get $var_x) ;; get local var: var_x
            (i32.const 1) ;; push 1 on stack
          )
        )
        (br $loop_begin$4)
      )
    )
    ;; End of let
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (data (i32.const 8) "\14\00\00\00\13\00\00\00\11\00\00\00")
  (data (i32.const 20) "😰 initial array:")
  (data (i32.const 39) "\33\00\00\00\26\00\00\00\24\00\00\00")
  (data (i32.const 51) "🤔 sorting array... (insertion sort)")
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