(module
  (type $fun_f_type (func (param i32) (param i32) (result i32)))
  (import "env" "malloc" (func $malloc (param i32) (result i32) 
))
  (import "env" "readInt" (func $readInt  (result i32) 
))
  (import "env" "writeInt" (func $writeInt (param i32)  
))
  (import "env" "writeS" (func $writeS (param i32) (param i32)  
))
  (memory (export "memory") 1)
  (data (i32.const 8) "--------------------------")
  (data (i32.const 68) "--------------------------")
  (data (i32.const 128) "--------------------------")
  (data (i32.const 188) "None")
  (global $heap_base i32  i32.const 196
)  (func $_start  (result i32)  ;; entry point of program (main function)
    ;; local variables declarations:
    (local $Sptr i32)
    (local $Sptr$2 i32)
    (local $Sptr$5 i32)
    (local $_ i32)
    (local $arr_ptr i32)
    (local $arr_slice_ptr i32)
    (local $i i32)
    (local $match_var__ i32)
    (local $match_var_v i32)
    (local $v i32)
    (local $var_arr i32)
    (local $var_o i32)
    (local $var_sliced i32)
    (local $var_x i32)
 
    ;; execution start here:
    ;; Start of let
    call $readInt ;; call host function
    local.set $var_x ;; set local var
    i32.const 0 ;; offset in memory
    i32.const 8 ;; data pointer to store
    i32.store ;; store size in bytes
    i32.const 4 ;; offset in memory
    i32.const 52 ;; length to store
    i32.store ;; store data pointer
    i32.const 0 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 0 ;; offset in memory
    i32.const 8 ;; data pointer to store
    i32.store ;; store size in bytes
    i32.const 4 ;; offset in memory
    i32.const 52 ;; length to store
    i32.store ;; store data pointer
    i32.const 0 ;; leave pointer to string on stack
    i32.const 4 ;; length offset
    i32.add ;; add offset to pointer
    i32.load ;; Load string length
    call $writeS ;; call host function
    ;; Start of let
    local.get $var_x
    i32.const 1 ;; put one on stack
    i32.le_s ;; check if length is <= 1
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
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
    local.get $var_x
    i32.store ;; store field in memory
    local.get $Sptr ;; push struct address to stack
    ;; end of struct contructor
    local.set $arr_ptr ;; set struct pointer var
    local.get $arr_ptr ;; get struct pointer var
    local.get $var_x
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    i32.store ;; store pointer to data
    (block $loop_exit 
      (loop $loop_begin 
      local.get $var_x
      local.get $i ;; get i
      i32.eq
      br_if $loop_exit
      local.get $arr_ptr ;; get struct pointer var
      i32.const 8 ;; byte offset
      i32.add ;; add offset to base address
      local.get $i ;; get index
      i32.const 4 ;; byte offset
      i32.mul ;; multiply index with byte offset
      i32.add ;; add offset to base address
      i32.const 0 ;; push 0 on stack
      i32.store ;; store value in elem pos
      local.get $i ;; get i
      i32.const 1 ;; increment by 1
      i32.add ;; add 1 to i
      local.set $i ;; write to i
      br $loop_begin

)
      nop

    )
    local.get $arr_ptr ;; leave pointer to allocated array struct on stack
    local.set $var_arr ;; set local var
    local.get $var_arr
    local.get $var_x
    i32.const 2 ;; push 2 on stack
    i32.div_s
    call $fun_f ;; call function fun_f
    i32.const 0 ;; push 0 on stack
    local.set $var_x ;; set local var
    local.get $var_x
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      ) ;; check that index is >= 0 - if not return 42
    local.get $var_x
    local.get $var_arr
    i32.const 4 ;; offset of length field
    i32.add ;; add offset to base address
    i32.load ;; load length
    i32.ge_u ;; check if index is < length
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      ) ;; check that index is < length - if not return 42
    local.get $var_arr
    i32.load ;; load data pointer
    local.get $var_x
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    call $writeInt ;; call host function
    local.get $var_x
    i32.const 1 ;; push 1 on stack
    i32.add
    local.set $var_x ;; set local var
    (block $loop_exit$0 
      (loop $loop_begin$1 
      local.get $var_x
      ;; start array length node
      local.get $var_arr
      i32.const 4 ;; offset of length field
      i32.add ;; add offset to base address
      i32.load ;; load length
      ;; end array length node
      i32.lt_s
      i32.eqz
      br_if $loop_exit$0
      local.get $var_x
      i32.const 0 ;; put zero on stack
      i32.lt_s ;; check if index is >= 0
      (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      ) ;; check that index is >= 0 - if not return 42
      local.get $var_x
      local.get $var_arr
      i32.const 4 ;; offset of length field
      i32.add ;; add offset to base address
      i32.load ;; load length
      i32.ge_u ;; check if index is < length
      (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      ) ;; check that index is < length - if not return 42
      local.get $var_arr
      i32.load ;; load data pointer
      local.get $var_x
      i32.const 4 ;; byte offset
      i32.mul ;; multiply index with byte offset
      i32.add ;; add offset to base address
      i32.load ;; load value
      ;; end array element access node
      call $writeInt ;; call host function
      local.get $var_x
      i32.const 1 ;; push 1 on stack
      i32.add
      local.set $var_x ;; set local var
      br $loop_begin$1

)
      nop

    )
    i32.const 60 ;; offset in memory
    i32.const 68 ;; data pointer to store
    i32.store ;; store size in bytes
    i32.const 64 ;; offset in memory
    i32.const 52 ;; length to store
    i32.store ;; store data pointer
    i32.const 60 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 60 ;; offset in memory
    i32.const 68 ;; data pointer to store
    i32.store ;; store size in bytes
    i32.const 64 ;; offset in memory
    i32.const 52 ;; length to store
    i32.store ;; store data pointer
    i32.const 60 ;; leave pointer to string on stack
    i32.const 4 ;; length offset
    i32.add ;; add offset to pointer
    i32.load ;; Load string length
    call $writeS ;; call host function
    ;; Start of let
    ;; start array slice
    ;; start array length node
    local.get $var_arr
    i32.const 4 ;; offset of length field
    i32.add ;; add offset to base address
    i32.load ;; load length
    ;; end array length node
    local.get $var_x
    i32.const 2 ;; push 2 on stack
    i32.div_s
    i32.sub ;; subtract end from start
    i32.const 1 ;; put one on stack
    i32.lt_u ;; check if difference is < 1
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      ) ;; check that difference is <= 1 - if not return 42
    ;; start array length node
    local.get $var_arr
    i32.const 4 ;; offset of length field
    i32.add ;; add offset to base address
    i32.load ;; load length
    ;; end array length node
    local.get $var_arr
    i32.const 4 ;; offset of length field
    i32.add ;; add offset to base address
    i32.load ;; load length
    i32.gt_u ;; check if end is < length
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      ) ;; check that end is < length - if not return 42
    local.get $var_x
    i32.const 2 ;; push 2 on stack
    i32.div_s
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if start is >= 0
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      ) ;; check that start is >= 0 - if not return 42
    local.get $var_x
    i32.const 2 ;; push 2 on stack
    i32.div_s
    local.get $var_arr
    i32.const 4 ;; offset of length field
    i32.add ;; add offset to base address
    i32.load ;; load length
    i32.ge_u ;; check if start is < length
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      ) ;; check that start is < length - if not return 42
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$2 ;; set struct pointer var
    local.get $Sptr$2 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    i32.const 0 ;; push 0 on stack
    i32.store ;; store field in memory
    local.get $Sptr$2 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field length
    ;; start array length node
    local.get $var_arr
    i32.const 4 ;; offset of length field
    i32.add ;; add offset to base address
    i32.load ;; load length
    ;; end array length node
    local.get $var_x
    i32.const 2 ;; push 2 on stack
    i32.div_s
    i32.sub
    i32.store ;; store field in memory
    local.get $Sptr$2 ;; push struct address to stack
    ;; end of struct contructor
    local.set $arr_slice_ptr ;; set struct pointer var
    local.get $arr_slice_ptr ;; get struct pointer var
    local.get $var_arr
    i32.load ;; Load data pointer from array struct
    local.get $var_x
    i32.const 2 ;; push 2 on stack
    i32.div_s
    i32.const 4 ;; offset of data field
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.store ;; store pointer to data
    local.get $arr_slice_ptr ;; leave pointer to allocated array struct on stack
    ;; end array slice
    local.set $var_sliced ;; set local var
    i32.const 0 ;; push 0 on stack
    local.set $var_x ;; set local var
    local.get $var_x
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      ) ;; check that index is >= 0 - if not return 42
    local.get $var_x
    local.get $var_sliced
    i32.const 4 ;; offset of length field
    i32.add ;; add offset to base address
    i32.load ;; load length
    i32.ge_u ;; check if index is < length
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      ) ;; check that index is < length - if not return 42
    local.get $var_sliced
    i32.load ;; load data pointer
    local.get $var_x
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    call $writeInt ;; call host function
    local.get $var_x
    i32.const 1 ;; push 1 on stack
    i32.add
    local.set $var_x ;; set local var
    (block $loop_exit$3 
      (loop $loop_begin$4 
      local.get $var_x
      ;; start array length node
      local.get $var_sliced
      i32.const 4 ;; offset of length field
      i32.add ;; add offset to base address
      i32.load ;; load length
      ;; end array length node
      i32.lt_s
      i32.eqz
      br_if $loop_exit$3
      local.get $var_x
      i32.const 0 ;; put zero on stack
      i32.lt_s ;; check if index is >= 0
      (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      ) ;; check that index is >= 0 - if not return 42
      local.get $var_x
      local.get $var_sliced
      i32.const 4 ;; offset of length field
      i32.add ;; add offset to base address
      i32.load ;; load length
      i32.ge_u ;; check if index is < length
      (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      ) ;; check that index is < length - if not return 42
      local.get $var_sliced
      i32.load ;; load data pointer
      local.get $var_x
      i32.const 4 ;; byte offset
      i32.mul ;; multiply index with byte offset
      i32.add ;; add offset to base address
      i32.load ;; load value
      ;; end array element access node
      call $writeInt ;; call host function
      local.get $var_x
      i32.const 1 ;; push 1 on stack
      i32.add
      local.set $var_x ;; set local var
      br $loop_begin$4

)
      nop

    )
    i32.const 120 ;; offset in memory
    i32.const 128 ;; data pointer to store
    i32.store ;; store size in bytes
    i32.const 124 ;; offset in memory
    i32.const 52 ;; length to store
    i32.store ;; store data pointer
    i32.const 120 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 120 ;; offset in memory
    i32.const 128 ;; data pointer to store
    i32.store ;; store size in bytes
    i32.const 124 ;; offset in memory
    i32.const 52 ;; length to store
    i32.store ;; store data pointer
    i32.const 120 ;; leave pointer to string on stack
    i32.const 4 ;; length offset
    i32.add ;; add offset to pointer
    i32.load ;; Load string length
    call $writeS ;; call host function
    ;; Start of let
    ;; Start of union contructor
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$5 ;; set struct pointer var
    local.get $Sptr$5 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field id
    i32.const 1 ;; push 1 on stack
    i32.store ;; store field in memory
    local.get $Sptr$5 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    local.get $var_sliced
    i32.store ;; store field in memory
    local.get $Sptr$5 ;; push struct address to stack
    ;; end of struct contructor
    ;; End of union contructor
    local.set $var_o ;; set local var
    (block $match_end 
      ;; case for id: $1, label: Some
      local.get $var_o
      i32.load ;; load label
      i32.const 1 ;; put label id 1 on stack
      i32.eq ;; check if index is equal to target
      (if (then
      local.get $var_o
      i32.const 4 ;; offset of data field
      i32.add ;; add offset to base address
      i32.load ;; load data pointer
      local.set $match_var_v ;; set local var
      ;; start array length node
      local.get $match_var_v
      i32.const 4 ;; offset of length field
      i32.add ;; add offset to base address
      i32.load ;; load length
      ;; end array length node
      call $writeInt ;; call host function
      br $match_end ;; break out of match
       )
      )
      ;; case for id: $2, label: None
      local.get $var_o
      i32.load ;; load label
      i32.const 2 ;; put label id 2 on stack
      i32.eq ;; check if index is equal to target
      (if (then
      local.get $var_o
      i32.const 4 ;; offset of data field
      i32.add ;; add offset to base address
      i32.load ;; load data pointer
      local.set $match_var__ ;; set local var
      i32.const 180 ;; offset in memory
      i32.const 188 ;; data pointer to store
      i32.store ;; store size in bytes
      i32.const 184 ;; offset in memory
      i32.const 8 ;; length to store
      i32.store ;; store data pointer
      i32.const 180 ;; leave pointer to string on stack
      i32.load ;; Load string pointer
      i32.const 180 ;; offset in memory
      i32.const 188 ;; data pointer to store
      i32.store ;; store size in bytes
      i32.const 184 ;; offset in memory
      i32.const 8 ;; length to store
      i32.store ;; store data pointer
      i32.const 180 ;; leave pointer to string on stack
      i32.const 4 ;; length offset
      i32.add ;; add offset to pointer
      i32.load ;; Load string length
      call $writeS ;; call host function
      br $match_end ;; break out of match
       )
      )
      ;; no case was matched, therefore return exit error code
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

    )
    ;; End of let
    ;; End of let
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_f (param $arr i32) (param $i i32) (result i32)  ;; function fun_f
 
    local.get $i
    ;; start array length node
    local.get $arr
    i32.const 4 ;; offset of length field
    i32.add ;; add offset to base address
    i32.load ;; load length
    ;; end array length node
    i32.lt_s
    (if  (result i32)
     (then
      local.get $i
      i32.const 0 ;; put zero on stack
      i32.lt_s ;; check if index is >= 0
      (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      ) ;; check that index is >= 0 - if not return 42
      local.get $i
      local.get $arr
      i32.const 4 ;; offset of length field
      i32.add ;; add offset to base address
      i32.load ;; load length
      i32.ge_u ;; check if index is < length
      (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      ) ;; check that index is < length - if not return 42
      local.get $arr
      i32.load ;; load data pointer
      local.get $i
      i32.const 4 ;; byte offset
      i32.mul ;; multiply index with byte offset
      i32.add ;; add offset to base address
      local.get $i
      i32.const 1 ;; push 1 on stack
      i32.add
      i32.store ;; store value in elem pos
      local.get $arr
      local.get $i
      i32.const 1 ;; push 1 on stack
      i32.add
      call $fun_f ;; call function fun_f

     )
     (else
      local.get $arr

     )
    )
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)