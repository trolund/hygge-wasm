(module
  (import "env" "malloc" (func $malloc (param i32) (result i32) 
))
  (memory (export "memory") 1)
  (data (i32.const 0) "hallo")
  (global $heap_base i32  i32.const 10
)  (func $_start  (result i32)  ;; entry point of program (main function)
    ;; local variables declarations:
    (local $Sptr i32)
    (local $i i32)
    (local $structPointer i32)
    (local $var_arr i32)
    (local $var_len i32)
    (local $var_x i32)
 
    ;; execution start here:
    ;; Start of let
    i32.const 0 ;; offset in memory
    i32.const 40 ;; size in bytes
    local.set $var_x ;; set local var
    ;; Start of let
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr ;; set struct pointer var
    local.get $Sptr ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field length
    i32.const 2 ;; push 2 on stack
    i32.const 2 ;; push 2 on stack
    i32.add
    i32.store ;; store field in memory
    local.get $Sptr ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    i32.const 0 ;; push 0 on stack
    i32.store ;; store field in memory
    local.get $Sptr ;; push struct address to stack
    ;; end of struct contructor
    local.set $structPointer ;; set struct pointer var
    i32.const 2 ;; push 2 on stack
    i32.const 2 ;; push 2 on stack
    i32.add
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    (block $loop_exit
      (loop $loop_begin 
      i32.const 2 ;; push 2 on stack
      i32.const 2 ;; push 2 on stack
      i32.add
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
      i32.const 40 ;; push 40 on stack
      i32.const 2 ;; push 2 on stack
      i32.add
      i32.store ;; store value in elem pos
      local.get $i ;; get i
      i32.const 1 ;; increment by 1
      i32.add ;; add 1 to i
      local.set $i ;; write to i
      br $loop_begin

)
      nop

)
    local.get $structPointer ;; get struct pointer var
    i32.const 4 ;; offset of data field
    i32.add ;; add offset to base address to get data pointer field
    i32.const 2 ;; push 2 on stack
    i32.const 2 ;; push 2 on stack
    i32.add
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    i32.store ;; store pointer to data
    local.get $structPointer ;; leave pointer to allocated array struct on stack
    local.set $var_arr ;; set local var
    ;; Start of let
    ;; start array length node
    local.get $var_arr
    i32.load ;; load length
    ;; end array length node
    local.set $var_len ;; set local var
    local.get $var_len
    i32.const 4 ;; push 4 on stack
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