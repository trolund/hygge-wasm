(module
  (type $i32_i32_=>_i32 (;0;) (func (param i32) (param i32) (result i32)))
  (type $i32_i32_i32_=>_i32 (;1;) (func (param i32) (param i32) (param i32) (result i32)))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $Sptr$2 (;0;) (mut i32) i32.const 0)
  (global $Sptr$3 (;1;) (mut i32) i32.const 0)
  (global $exit_code (;2;) (mut i32) i32.const 0)
  (global $fun_aux*ptr (;3;) (mut i32) i32.const 4)
  (global $fun_factorial*ptr (;4;) (mut i32) i32.const 0)
  (global $heap_base (;5;) i32 i32.const 8)
  (table $func_table (;0;) 2 funcref)
  (elem (i32.const 0) (;0;) $fun_factorial)
  (elem (i32.const 1) (;1;) $fun_aux)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr$3 ;; set struct pointer var, have been hoisted
    global.get $Sptr$3 ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$3 ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$3 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 0 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr$2 ;; set struct pointer var, have been hoisted
    global.get $Sptr$2 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    global.get $Sptr$3 ;; get pointer to return struct, have been hoisted
    global.set $fun_factorial*ptr
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_factorial*ptr ;; get global var: fun_factorial*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 0 ;; push 0 on stack
    global.get $fun_factorial*ptr ;; get global var: fun_factorial*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 1 ;; push 1 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_factorial*ptr ;; get global var: fun_factorial*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 5 ;; push 5 on stack
    global.get $fun_factorial*ptr ;; get global var: fun_factorial*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 120 ;; push 120 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_factorial*ptr ;; get global var: fun_factorial*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 10 ;; push 10 on stack
    global.get $fun_factorial*ptr ;; get global var: fun_factorial*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 3628800 ;; push 3628800 on stack
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
  (func $fun_aux (;1;) (param $cenv i32) (param $arg_n$0 i32) (param $arg_acc i32) (result i32) 
    local.get $arg_n$0 ;; get local var: arg_n$0
    i32.const 0 ;; push 0 on stack
    i32.eq
    (if (result i32)
      (then
        local.get $arg_acc ;; get local var: arg_acc
      )
      (else
        ;; start of application
        ;; Load expression to be applied as a function
        global.get $fun_aux*ptr ;; get global var: fun_aux*ptr
        i32.load offset=4 ;; load closure environment pointer
        local.get $arg_n$0 ;; get local var: arg_n$0
        i32.const 1 ;; push 1 on stack
        i32.sub
        local.get $arg_n$0 ;; get local var: arg_n$0
        local.get $arg_acc ;; get local var: arg_acc
        i32.mul
        global.get $fun_aux*ptr ;; get global var: fun_aux*ptr
        i32.load ;; load table index
        call_indirect (type $i32_i32_i32_=>_i32) ;; call function
        ;; end of application
      )
    )
  )
  (func $fun_factorial (;2;) (param $cenv i32) (param $arg_n i32) (result i32) 
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
    global.set $fun_aux*ptr
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_aux*ptr ;; get global var: fun_aux*ptr
    i32.load offset=4 ;; load closure environment pointer
    local.get $arg_n ;; get local var: arg_n
    i32.const 1 ;; push 1 on stack
    global.get $fun_aux*ptr ;; get global var: fun_aux*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)