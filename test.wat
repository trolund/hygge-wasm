(module
  (type $i32_i32_=> (;0;) (func (param i32) (param i32) ))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (import "env" "writeInt" (;1;) (func $writeInt (param i32) ))
  (import "env" "writeS" (;2;) (func $writeS (param i32) (param i32) ))
  (memory (;0;) (export "memory") 1)
  (global $Sptr (;0;) (mut i32) i32.const 0)
  (global $Sptr$0 (;1;) (mut i32) i32.const 0)
  (global $exit_code (;2;) (mut i32) i32.const 0)
  (global $fun_countdown*ptr (;3;) (mut i32) i32.const 0)
  (global $fun_countdownRec*ptr (;4;) (mut i32) i32.const 4)
  (global $heap_base (;5;) i32 i32.const 52)
  (table $func_table (;0;) 2 funcref)
  (elem (i32.const 0) (;0;) $fun_countdown)
  (elem (i32.const 1) (;1;) $fun_countdownRec)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr$0 ;; set struct pointer var, have been hoisted
    global.get $Sptr$0 ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$0 ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$0 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 0 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr ;; set struct pointer var, have been hoisted
    global.get $Sptr ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    global.get $Sptr$0 ;; get pointer to return struct, have been hoisted
    global.set $fun_countdown*ptr
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_countdown*ptr ;; get global var: fun_countdown*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 20 ;; push 20 on stack
    global.get $fun_countdown*ptr ;; get global var: fun_countdown*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>) ;; call function
    ;; end of application
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_countdown (;1;) (param $cenv i32) (param $arg_start i32)  
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_countdownRec*ptr ;; get global var: fun_countdownRec*ptr
    i32.load offset=4 ;; load closure environment pointer
    local.get $arg_start ;; get local var: arg_start
    global.get $fun_countdownRec*ptr ;; get global var: fun_countdownRec*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>) ;; call function
    ;; end of application
  )
  (func $fun_countdownRec (;2;) (param $cenv i32) (param $arg_curr i32)  
    local.get $arg_curr ;; get local var: arg_curr
    i32.const 0 ;; push 0 on stack
    i32.lt_s
    (if 
      (then
        i32.const 8 ;; leave pointer to string on stack
        i32.load ;; Load string pointer
        i32.const 8 ;; leave pointer to string on stack
        i32.load offset=4 ;; Load string length
        call $writeS ;; call host function
      )
      (else
        i32.const 22 ;; leave pointer to string on stack
        i32.load ;; Load string pointer
        i32.const 22 ;; leave pointer to string on stack
        i32.load offset=4 ;; Load string length
        call $writeS ;; call host function
        local.get $arg_curr ;; get local var: arg_curr
        call $writeInt ;; call host function
        ;; start of application
        ;; Load expression to be applied as a function
        global.get $fun_countdownRec*ptr ;; get global var: fun_countdownRec*ptr
        i32.load offset=4 ;; load closure environment pointer
        local.get $arg_curr ;; get local var: arg_curr
        i32.const 1 ;; push 1 on stack
        i32.sub
        global.get $fun_countdownRec*ptr ;; get global var: fun_countdownRec*ptr
        i32.load ;; load table index
        call_indirect (type $i32_i32_=>) ;; call function
        ;; end of application
      )
    )
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (data (i32.const 8) "\10\00\00\00\06\00\00\00")
  (data (i32.const 16) "Go!")
  (data (i32.const 22) "\1e\00\00\00\16\00\00\00")
  (data (i32.const 30) "Countdown: ")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)