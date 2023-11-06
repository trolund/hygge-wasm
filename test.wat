(module
  (type $i32_=>_i32 (;0;) (func (param i32) (result i32)))
  (type $i32_i32_=>_i32 (;1;) (func (param i32) (param i32) (result i32)))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) i32.const 0)
  (global $fun_clos*ptr (;1;) (mut i32) i32.const 4)
  (global $fun_clos/anonymous*ptr (;2;) (mut i32) i32.const 8)
  (global $fun_h*ptr (;3;) (mut i32) i32.const 0)
  (global $heap_base (;4;) i32 i32.const 12)
  (global $var_x (;5;) (mut i32) i32.const 0)
  (table $func_table (;0;) 3 funcref)
  (elem (i32.const 0) (;0;) $fun_h)
  (elem (i32.const 1) (;1;) $fun_clos)
  (elem (i32.const 2) (;2;) $fun_clos/anonymous)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    i32.const 40 ;; push 40 on stack
    global.set $var_x ;; set local var, have been hoisted
    ;; Load expression to be applied as a function
    global.get $fun_h*ptr ;; get global var: fun_h*ptr
    i32.load offset=4 ;; load closure environment pointer
    ;; Load expression to be applied as a function
    global.get $fun_clos*ptr ;; get global var: fun_clos*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 41 ;; push 41 on stack
    global.get $fun_clos*ptr ;; get global var: fun_clos*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    global.get $fun_h*ptr ;; get global var: fun_h*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    i32.const 82 ;; push 82 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
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
  (func $fun_clos (;1;) (param $cenv i32) (param $arg_y i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr i32)
    (local $Sptr$0 i32)

    ;; start of struct contructor
    i32.const 8 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$0 ;; set struct pointer var
    local.get $Sptr$0 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 2 ;; push 2 on stack
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
    i32.const 8 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr ;; set struct pointer var
    local.get $Sptr ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field x
    global.get $var_x ;; get local var: var_x, have been hoisted
    i32.store ;; store int field in memory
    local.get $Sptr ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field y
    local.get $arg_y ;; get local var: arg_y
    i32.store ;; store int field in memory
    local.get $Sptr ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$0 ;; get pointer to return struct
  )
  (func $fun_clos/anonymous (;2;) (param $cenv i32) (result i32) 
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    local.get 0 ;; get env pointer
    i32.load offset=4 ;; load value at offset: 4
    i32.add
    i32.const 1 ;; push 1 on stack
    i32.add
  )
  (func $fun_h (;3;) (param $cenv i32) (param $arg_k i32) (result i32) 
    ;; Load expression to be applied as a function
    local.get $arg_k ;; get local var: arg_k
    i32.load offset=4 ;; load closure environment pointer
    local.get $arg_k ;; get local var: arg_k
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (data (i32.const 8) "\02")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)