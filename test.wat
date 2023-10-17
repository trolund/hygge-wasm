(module
  (type $i32_=>_i32 (;0;) (func (param i32) (result i32)))
  (type $i32_i32_=>_i32 (;1;) (func (param i32) (param i32) (result i32)))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) i32.const 0)
  (global $fun_clos*ptr (;1;) (mut i32) i32.const 8)
  (global $fun_clos/anonymous*ptr (;2;) (mut i32) i32.const 12)
  (global $fun_f*ptr (;3;) (mut i32) i32.const 0)
  (global $fun_h*ptr (;4;) (mut i32) i32.const 4)
  (global $heap_base (;5;) i32 i32.const 16)
  (global $var_x (;6;) (mut i32) i32.const 0)
  (table $func_table (;0;) 4 funcref)
  (elem (i32.const 0) (;0;) $fun_f)
  (elem (i32.const 1) (;1;) $fun_h)
  (elem (i32.const 2) (;2;) $fun_clos)
  (elem (i32.const 3) (;3;) $fun_clos/anonymous)
  (func $_start (;0;)  (result i32) ;; entry point of program (main function) 
    ;; execution start here:
    ;; Start of let
    i32.const 40 ;; push 40 on stack
    global.set $var_x ;; set local var, have been hoisted
    ;; start of application
    ;; Load expression to be applied as a function
    i32.const -1 ;; load unused closure environment pointer
    global.get $fun_f*ptr ;; get global var: fun_f*ptr
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    ;; end of application
    i32.const 80 ;; push 80 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
       )
      )
    ;; start of application
    ;; Load expression to be applied as a function
    i32.const -1 ;; load unused closure environment pointer
    global.get $fun_f*ptr ;; get global var: fun_f*ptr
    global.get $fun_h*ptr ;; get global var: fun_h*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 80 ;; push 80 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
       )
      )
    ;; start of application
    ;; Load expression to be applied as a function
    i32.const -1 ;; load unused closure environment pointer
    ;; start of application
    ;; Load expression to be applied as a function
    i32.const -1 ;; load unused closure environment pointer
    i32.const 41 ;; push 41 on stack
    global.get $fun_clos*ptr ;; get global var: fun_clos*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    global.get $fun_h*ptr ;; get global var: fun_h*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 42 ;; push 42 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
       )
      )
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_clos (;0;) (param $cenv i32) (param $arg_x i32) (result i32) ;; function fun_clos    ;; local variables declarations:
    (local $Sptr i32)
    (local $Sptr$0 i32)
 
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$0 ;; set struct pointer var
    local.get $Sptr$0 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 3 ;; push 3 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$0 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$0 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 1 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr ;; set struct pointer var
    local.get $Sptr ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field x
    local.get $arg_x ;; get local var: arg_x
    i32.store ;; store int field in memory
    local.get $Sptr ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$0 ;; get pointer to return struct
  )
  (func $fun_clos/anonymous (;0;) (param $cenv i32) (result i32) ;; function fun_clos/anonymous 
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.const 1 ;; push 1 on stack
    i32.add
  )
  (func $fun_f (;0;) (param $cenv i32) (result i32) ;; function fun_f 
    i32.const 40 ;; push 40 on stack
    global.get $var_x ;; get local var: var_x, have been hoisted
    i32.add
  )
  (func $fun_h (;0;) (param $cenv i32) (param $arg_k i32) (result i32) ;; function fun_h 
    ;; start of application
    ;; Load expression to be applied as a function
    local.get $arg_k ;; get local var: arg_k
    i32.load offset=4 ;; load closure environment pointer
    local.get $arg_k ;; get local var: arg_k
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    ;; end of application
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (data (i32.const 8) "\02")
  (data (i32.const 12) "\03")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)