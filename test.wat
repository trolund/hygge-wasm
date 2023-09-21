(module
  (import "env" "malloc" (func $malloc (param i32) (result i32) 
))
  (memory (export "memory") 1)
  (global $heap_base i32  i32.const 0
)  (func $_start  (result i32)  ;; entry point of program (main function)
    ;; local variables declarations:
    (local $Sptr i32)
    (local $i i32)
    (local $structPointer i32)
    (local $var_arr i32)
    (local $var_n i32)
    (local $var_sum i32)
 
    ;; execution start here:
    ;; Start of let
    i32.const 5 ;; push 5 on stack
    local.set $var_n ;; set local var
    ;; Start of let
    local.get $var_n
    i32.const 1 ;; put one on stack
    i32.le_s ;; check if length is <= 1
    (if 
     (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
     (else

     )
    ) ;; check that length of array is bigger then 1 - if not return 42
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr ;; set struct pointer var
    local.get $Sptr ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    i32.const 0 ;; push 0 on stack
    i32.store ;; store field in memory
    local.get $Sptr ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field length
    local.get $var_n
    i32.store ;; store field in memory
    local.get $Sptr ;; push struct address to stack
    ;; end of struct contructor
    local.set $structPointer ;; set struct pointer var
    local.get $structPointer ;; get struct pointer var
    local.get $var_n
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    i32.store ;; store pointer to data
    (block $loop_exit
      (loop $loop_begin 
      local.get $var_n
      local.get $i ;; get i
      i32.eq
      br_if $loop_exit
      local.get $structPointer ;; get struct pointer var
      i32.const 8 ;; byte offset
      i32.add ;; add offset to base address
      local.get $i ;; get index
      i32.const 4 ;; byte offset
      i32.mul ;; multiply index with byte offset
      i32.add ;; add offset to base address
      i32.const 1 ;; push 1 on stack
      i32.store ;; store value in elem pos
      local.get $i ;; get i
      i32.const 1 ;; increment by 1
      i32.add ;; add 1 to i
      local.set $i ;; write to i
      br $loop_begin

)
      nop

)
    local.get $structPointer ;; leave pointer to allocated array struct on stack
    local.set $var_arr ;; set local var
    i32.const 0 ;; push 0 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if 
     (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
     (else

     )
    ) ;; check that index is >= 0 - if not return 42
    ;; lower bound check
    local.get $var_arr
    i32.const 4 ;; offset of length field
    i32.add ;; add offset to base address
    i32.load ;; load length
    i32.const 0 ;; push 0 on stack
    i32.ge_u ;; check if index is < length
    (if 
     (then
      i32.const 200 ;; error exit code push to stack
      return ;; return exit code

     )
     (else

     )
    ) ;; check that index is < length - if not return 42
    ;; lower bound check done
    local.get $var_arr
    i32.load ;; load data pointer
    i32.const 0 ;; push 0 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    ;; start array element access node
    local.get $var_arr
    i32.load ;; load data pointer
    i32.const 0 ;; push 0 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    local.get $var_n
    i32.add
    i32.store ;; store value in elem pos
    i32.const 1 ;; push 1 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if 
     (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
     (else

     )
    ) ;; check that index is >= 0 - if not return 42
    ;; lower bound check
    local.get $var_arr
    i32.const 4 ;; offset of length field
    i32.add ;; add offset to base address
    i32.load ;; load length
    i32.const 1 ;; push 1 on stack
    i32.ge_u ;; check if index is < length
    (if 
     (then
      i32.const 200 ;; error exit code push to stack
      return ;; return exit code

     )
     (else

     )
    ) ;; check that index is < length - if not return 42
    ;; lower bound check done
    local.get $var_arr
    i32.load ;; load data pointer
    i32.const 1 ;; push 1 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    ;; start array element access node
    local.get $var_arr
    i32.load ;; load data pointer
    i32.const 1 ;; push 1 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    local.get $var_n
    i32.add
    i32.const 1 ;; push 1 on stack
    i32.add
    i32.store ;; store value in elem pos
    i32.const 2 ;; push 2 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if 
     (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
     (else

     )
    ) ;; check that index is >= 0 - if not return 42
    ;; lower bound check
    local.get $var_arr
    i32.const 4 ;; offset of length field
    i32.add ;; add offset to base address
    i32.load ;; load length
    i32.const 2 ;; push 2 on stack
    i32.ge_u ;; check if index is < length
    (if 
     (then
      i32.const 200 ;; error exit code push to stack
      return ;; return exit code

     )
     (else

     )
    ) ;; check that index is < length - if not return 42
    ;; lower bound check done
    local.get $var_arr
    i32.load ;; load data pointer
    i32.const 2 ;; push 2 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    ;; start array element access node
    local.get $var_arr
    i32.load ;; load data pointer
    i32.const 2 ;; push 2 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    local.get $var_n
    i32.add
    i32.const 2 ;; push 2 on stack
    i32.add
    i32.store ;; store value in elem pos
    i32.const 3 ;; push 3 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if 
     (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
     (else

     )
    ) ;; check that index is >= 0 - if not return 42
    ;; lower bound check
    local.get $var_arr
    i32.const 4 ;; offset of length field
    i32.add ;; add offset to base address
    i32.load ;; load length
    i32.const 3 ;; push 3 on stack
    i32.ge_u ;; check if index is < length
    (if 
     (then
      i32.const 200 ;; error exit code push to stack
      return ;; return exit code

     )
     (else

     )
    ) ;; check that index is < length - if not return 42
    ;; lower bound check done
    local.get $var_arr
    i32.load ;; load data pointer
    i32.const 3 ;; push 3 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    ;; start array element access node
    local.get $var_arr
    i32.load ;; load data pointer
    i32.const 3 ;; push 3 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    local.get $var_n
    i32.add
    i32.const 3 ;; push 3 on stack
    i32.add
    i32.store ;; store value in elem pos
    i32.const 4 ;; push 4 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if 
     (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
     (else

     )
    ) ;; check that index is >= 0 - if not return 42
    ;; lower bound check
    local.get $var_arr
    i32.const 4 ;; offset of length field
    i32.add ;; add offset to base address
    i32.load ;; load length
    i32.const 4 ;; push 4 on stack
    i32.ge_u ;; check if index is < length
    (if 
     (then
      i32.const 200 ;; error exit code push to stack
      return ;; return exit code

     )
     (else

     )
    ) ;; check that index is < length - if not return 42
    ;; lower bound check done
    local.get $var_arr
    i32.load ;; load data pointer
    i32.const 4 ;; push 4 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    ;; start array element access node
    local.get $var_arr
    i32.load ;; load data pointer
    i32.const 4 ;; push 4 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    local.get $var_n
    i32.add
    i32.const 4 ;; push 4 on stack
    i32.add
    i32.store ;; store value in elem pos
    ;; start array element access node
    local.get $var_arr
    i32.load ;; load data pointer
    i32.const 0 ;; push 0 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 6 ;; push 6 on stack
    i32.eq
    (if 
     (then
      nop ;; do nothing - if all correct

     )
     (else
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
    )
    ;; start array element access node
    local.get $var_arr
    i32.load ;; load data pointer
    i32.const 1 ;; push 1 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 7 ;; push 7 on stack
    i32.eq
    (if 
     (then
      nop ;; do nothing - if all correct

     )
     (else
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
    )
    ;; start array element access node
    local.get $var_arr
    i32.load ;; load data pointer
    i32.const 2 ;; push 2 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 8 ;; push 8 on stack
    i32.eq
    (if 
     (then
      nop ;; do nothing - if all correct

     )
     (else
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
    )
    ;; start array element access node
    local.get $var_arr
    i32.load ;; load data pointer
    i32.const 3 ;; push 3 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 9 ;; push 9 on stack
    i32.eq
    (if 
     (then
      nop ;; do nothing - if all correct

     )
     (else
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
    )
    ;; start array element access node
    local.get $var_arr
    i32.load ;; load data pointer
    i32.const 4 ;; push 4 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 10 ;; push 10 on stack
    i32.eq
    (if 
     (then
      nop ;; do nothing - if all correct

     )
     (else
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
    )
    i32.const 1 ;; push 1 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if 
     (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
     (else

     )
    ) ;; check that index is >= 0 - if not return 42
    ;; lower bound check
    local.get $var_arr
    i32.const 4 ;; offset of length field
    i32.add ;; add offset to base address
    i32.load ;; load length
    i32.const 1 ;; push 1 on stack
    i32.ge_u ;; check if index is < length
    (if 
     (then
      i32.const 200 ;; error exit code push to stack
      return ;; return exit code

     )
     (else

     )
    ) ;; check that index is < length - if not return 42
    ;; lower bound check done
    local.get $var_arr
    i32.load ;; load data pointer
    i32.const 1 ;; push 1 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    ;; start array element access node
    local.get $var_arr
    i32.load ;; load data pointer
    i32.const 4 ;; push 4 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    local.get $var_n
    i32.add
    i32.const 5 ;; push 5 on stack
    i32.add
    i32.store ;; store value in elem pos
    ;; start array element access node
    local.get $var_arr
    i32.load ;; load data pointer
    i32.const 1 ;; push 1 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.const 20 ;; push 20 on stack
    i32.eq
    (if 
     (then
      nop ;; do nothing - if all correct

     )
     (else
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
    )
    ;; Start of let
    ;; start array element access node
    local.get $var_arr
    i32.load ;; load data pointer
    i32.const 0 ;; push 0 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    ;; start array element access node
    local.get $var_arr
    i32.load ;; load data pointer
    i32.const 1 ;; push 1 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.add
    ;; start array element access node
    local.get $var_arr
    i32.load ;; load data pointer
    i32.const 2 ;; push 2 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.add
    ;; start array element access node
    local.get $var_arr
    i32.load ;; load data pointer
    i32.const 3 ;; push 3 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.add
    ;; start array element access node
    local.get $var_arr
    i32.load ;; load data pointer
    i32.const 4 ;; push 4 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    i32.add
    local.set $var_sum ;; set local var
    local.get $var_sum
    i32.const 53 ;; push 53 on stack
    i32.eq
    (if 
     (then
      nop ;; do nothing - if all correct

     )
     (else
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
    )
    ;; End of let
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)