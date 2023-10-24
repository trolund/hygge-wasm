(module
  (type $i32_=>_i32 (;0;) (func (param i32) (result i32)))
  (type $i32_i32_i32_=>_i32 (;1;) (func (param i32) (param i32) (param i32) (result i32)))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) i32.const 0)
  (global $fun_f_inner*ptr (;1;) (mut i32) i32.const 4)
  (global $fun_f_outer*ptr (;2;) (mut i32) i32.const 0)
  (global $heap_base (;3;) i32 i32.const 8)
  (global $var_inner (;4;) (mut i32) i32.const 0)
  (table $func_table (;0;) 2 funcref)
  (elem (i32.const 0) (;0;) $fun_f_outer)
  (elem (i32.const 1) (;1;) $fun_f_inner)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f_outer*ptr ;; get global var: fun_f_outer*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $fun_f_outer*ptr ;; get global var: fun_f_outer*ptr
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    ;; end of application
    global.set $var_inner ;; set local var, have been hoisted
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $var_inner ;; get local var: var_inner, have been hoisted
    i32.load offset=4 ;; load closure environment pointer
    i32.const 1 ;; push 1 on stack
    i32.const 2 ;; push 2 on stack
    global.get $var_inner ;; get local var: var_inner, have been hoisted
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 7 ;; push 7 on stack
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
  (func $fun_f_inner (;1;) (param $cenv i32) (param $arg_x i32) (param $arg_y i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr i32)

    local.get $arg_x ;; get local var: arg_x
    local.get $arg_y ;; get local var: arg_y
    i32.add
    i32.const 2 ;; push 2 on stack
    i32.add
    ;; Start of field select
    local.get $var_a ;; get local var: var_a
    i32.load offset=0 ;; load field: value
    ;; End of field select
    i32.add
  )
  (func $fun_f_outer (;2;) (param $cenv i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr i32)
    (local $var_a i32)

    ;; Start of let
    ;; start of struct contructor
    i32.const 1 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr ;; set struct pointer var
    local.get $Sptr ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field value
    i32.const 3 ;; push 3 on stack
    i32.store ;; store int field in memory
    local.get $Sptr ;; push struct address to stack
    ;; end of struct contructor
    local.set $var_a ;; set local var
    global.get $fun_f_inner*ptr ;; get global var: fun_f_inner*ptr
    ;; End of let
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)