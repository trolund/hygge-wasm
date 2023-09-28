(module
  (type $fun_f_type (func (param i32) (result i32)))
  (import "env" "malloc" (func $malloc (param i32) (result i32)))
  (memory (export "memory") 1)
  (data (i32.const 0) "\00")
  (data (i32.const 12) "Hello")
  (data (i32.const 44) "Hej")
  (global $heap_base i32 i32.const 50)
  (table $func_table 1 funcref)
  (elem (i32.const 0) $fun_f)
  (func $_start  (result i32) ;; entry point of program (main function)    ;; local variables declarations:
    (local $Sptr i32)
    (local $fun_f i32)
    (local $var_t i32)
 
    ;; execution start here:
    i32.const 0 ;; pointer to function
    i32.load ;; load function pointer
    local.set $fun_f ;; set local var
    ;; Start of let
    ;; start of struct contructor
    i32.const 3 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr ;; set struct pointer var
    local.get $Sptr ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field _1
    i32.const 4 ;; offset in memory
    i32.const 12 ;; data pointer to store
    i32.store ;; store size in bytes
    i32.const 8 ;; offset in memory
    i32.const 10 ;; length to store
    i32.store ;; store data pointer
    i32.const 4 ;; leave pointer to string on stack
    i32.store ;; store field in memory
    local.get $Sptr ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field _2
    i32.const 40 ;; push 40 on stack
    i32.const 2 ;; push 2 on stack
    i32.add
    i32.store ;; store field in memory
    local.get $Sptr ;; get struct pointer var
    i32.const 8 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field _3
    local.get $fun_f
    i32.store ;; store field in memory
    local.get $Sptr ;; push struct address to stack
    ;; end of struct contructor
    local.set $var_t ;; set local var
    local.get $var_t
    i32.const 0 ;; offset of field
    i32.add ;; add offset
    i32.const 36 ;; offset in memory
    i32.const 44 ;; data pointer to store
    i32.store ;; store size in bytes
    i32.const 40 ;; offset in memory
    i32.const 6 ;; length to store
    i32.store ;; store data pointer
    i32.const 36 ;; leave pointer to string on stack
    i32.store ;; store int in struct
    i32.const 36 ;; offset in memory
    i32.const 44 ;; data pointer to store
    i32.store ;; store size in bytes
    i32.const 40 ;; offset in memory
    i32.const 6 ;; length to store
    i32.store ;; store data pointer
    i32.const 36 ;; leave pointer to string on stack
    i32.const 3 ;; push 3 on stack
    ;; Load expression to be applied as a function
    ;; Start of field select
    local.get $var_t
    i32.const 8 ;; push field offset to stack
    i32.add ;; add offset to base address
    i32.load ;; load field
    ;; End of field select
    call_indirect (param i32) (result i32) ;; call function
    i32.const 3 ;; push 3 on stack
    ;; Load expression to be applied as a function
    ;; Start of field select
    local.get $var_t
    i32.const 8 ;; push field offset to stack
    i32.add ;; add offset to base address
    i32.load ;; load field
    ;; End of field select
    call_indirect (param i32) (result i32) ;; call function
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