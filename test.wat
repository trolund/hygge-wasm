(module
  (import "env" "malloc" (func $malloc (param i32) (result i32) 
))
  (memory (export "memory") 1)
  (global $heap_base i32  i32.const 0
)  (func $_start  (result i32)  ;; entry point of program (main function)
    ;; local variables declarations:
    (local $Sptr i32)
    (local $arr_ptr i32)
    (local $i i32)
    (local $var_arr i32)
    (local $var_len i32)
    (local $var_len2 i32)
 
    ;; execution start here:
    ;; Start of let
    i32.const 530000000 ;; push 530000000 on stack
    local.set $var_len ;; set local var
    ;; Start of let
    local.get $var_len
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
    local.get $var_len
    i32.store ;; store field in memory
    local.get $Sptr ;; push struct address to stack
    ;; end of struct contructor
    local.set $arr_ptr ;; set struct pointer var
    local.get $arr_ptr ;; get struct pointer var
    local.get $var_len
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    i32.store ;; store pointer to data
    (block $loop_exit
      (loop $loop_begin 
      local.get $var_len
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
      i32.const 100 ;; push 100 on stack
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
    ;; Start of let
    ;; start array length node
    local.get $var_arr
    i32.const 4 ;; offset of length field
    i32.add ;; add offset to base address
    i32.load ;; load length
    ;; end array length node
    local.set $var_len2 ;; set local var
    local.get $var_len
    local.get $var_len2
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