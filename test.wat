(module
  (type $fun_f_type (func (param i32) (result i32)))
  (import "env" "malloc" (func $malloc (param i32) (result i32)))
  (memory (export "memory") 1)
  (data (i32.const 0) "\00")
  (global $heap_base i32 i32.const 4)
  (table $func_table 1 funcref)
  (elem (i32.const 0) $fun_f)
  (func $_start  (result i32) ;; entry point of program (main function)    ;; local variables declarations:
    (local $Sptr i32)
    (local $arr_ptr i32)
    (local $fun_f i32)
    (local $i i32)
    (local $var_arr4 i32)
 
    ;; execution start here:
    i32.const 0 ;; pointer to function
    i32.load ;; load function pointer
    local.set $fun_f ;; set local var
    ;; Start of let
    i32.const 2 ;; push 2 on stack
    i32.const 2 ;; push 2 on stack
    i32.add
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
    i32.const 2 ;; push 2 on stack
    i32.const 2 ;; push 2 on stack
    i32.add
    i32.store ;; store field in memory
    local.get $Sptr ;; push struct address to stack
    ;; end of struct contructor
    local.set $arr_ptr ;; set struct pointer var
    local.get $arr_ptr ;; get struct pointer var
    i32.const 2 ;; push 2 on stack
    i32.const 2 ;; push 2 on stack
    i32.add
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    i32.store ;; store pointer to data
    (block $loop_exit 
      (loop $loop_begin 
      i32.const 2 ;; push 2 on stack
      i32.const 2 ;; push 2 on stack
      i32.add
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
      local.get $fun_f
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
    local.set $var_arr4 ;; set local var
    i32.const 3 ;; push 3 on stack
    call $fun_f ;; call function fun_f
    i32.const 3 ;; push 3 on stack
    ;; Load expression to be applied as a function
    i32.const 0 ;; push 0 on stack
    i32.const 0 ;; put zero on stack
    i32.lt_s ;; check if index is >= 0
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      ) ;; check that index is >= 0 - if not return 42
    i32.const 0 ;; push 0 on stack
    local.get $var_arr4
    i32.const 4 ;; offset of length field
    i32.add ;; add offset to base address
    i32.load ;; load length
    i32.ge_u ;; check if index is < length
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      ) ;; check that index is < length - if not return 42
    local.get $var_arr4
    i32.load ;; load data pointer
    i32.const 0 ;; push 0 on stack
    i32.const 4 ;; byte offset
    i32.mul ;; multiply index with byte offset
    i32.add ;; add offset to base address
    i32.load ;; load value
    ;; end array element access node
    call_indirect (param i32) (result i32) ;; call function
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
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_f (param $x i32) (result i32) ;; function fun_f 
    local.get $x
    i32.const 1 ;; push 1 on stack
    i32.add
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)