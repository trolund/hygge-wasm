(module
  (type $i32_=>_i32 (;0;) (func (param i32) (result i32)))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) i32.const 0)
  (global $fun_f$0*ptr (;1;) (mut i32) i32.const 4)
  (global $fun_f*ptr (;2;) (mut i32) i32.const 0)
  (global $heap_base (;3;) i32 i32.const 8)
  (table $func_table (;0;) 2 funcref)
  (elem (i32.const 0) (;0;) $fun_f)
  (elem (i32.const 1) (;1;) $fun_f$0)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Load expression to be applied as a function
    global.get $fun_f*ptr ;; get global var: fun_f*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $fun_f*ptr ;; get global var: fun_f*ptr
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
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
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_f (;1;) (param $cenv i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr i32)
    (local $Sptr$1 i32)

    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$1 ;; set struct pointer var
    local.get $Sptr$1 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 1 ;; push 1 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$1 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$1 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 0 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr ;; set struct pointer var
    local.get $Sptr ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$1 ;; get pointer to return struct
    global.set $fun_f$0*ptr
    ;; Load expression to be applied as a function
    global.get $fun_f$0*ptr ;; get global var: fun_f$0*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $fun_f$0*ptr ;; get global var: fun_f$0*ptr
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
  )
  (func $fun_f$0 (;2;) (param $cenv i32) (result i32) 
    i32.const 2 ;; push 2 on stack
    i32.const 2 ;; push 2 on stack
    i32.add
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)