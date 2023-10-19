(module
  (type $i32_=>_f32 (;0;) (func (param i32) (result f32)))
  (type $i32_f32_i32_=>_i32 (;1;) (func (param i32) (param f32) (param i32) (result i32)))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) i32.const 0)
  (global $fun_makeCounter*ptr (;1;) (mut i32) i32.const 0)
  (global $fun_makeCounter/anonymous*ptr (;2;) (mut i32) i32.const 4)
  (global $heap_base (;3;) i32 i32.const 8)
  (global $var_c1 (;4;) (mut i32) i32.const 0)
  (global $var_c2 (;5;) (mut i32) i32.const 0)
  (global $var_x (;6;) (mut f32) f32.const 0.000000)
  (global $var_y (;7;) (mut f32) f32.const 0.000000)
  (table $func_table (;0;) 2 funcref)
  (elem (i32.const 0) (;0;) $fun_makeCounter)
  (elem (i32.const 1) (;1;) $fun_makeCounter/anonymous)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    f32.const 5.000000
    global.set $var_x ;; set local var, have been hoisted
    ;; Start of let
    f32.const 7.000000
    global.set $var_y ;; set local var, have been hoisted
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_makeCounter*ptr ;; get global var: fun_makeCounter*ptr
    i32.load offset=4 ;; load closure environment pointer
    f32.const 2.000000
    i32.const 1
    global.get $fun_makeCounter*ptr ;; get global var: fun_makeCounter*ptr
    i32.load ;; load table index
    call_indirect (type $i32_f32_i32_=>_i32) ;; call function
    ;; end of application
    global.set $var_c1 ;; set local var, have been hoisted
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_makeCounter*ptr ;; get global var: fun_makeCounter*ptr
    i32.load offset=4 ;; load closure environment pointer
    f32.const 2.000000
    i32.const 0
    global.get $fun_makeCounter*ptr ;; get global var: fun_makeCounter*ptr
    i32.load ;; load table index
    call_indirect (type $i32_f32_i32_=>_i32) ;; call function
    ;; end of application
    global.set $var_c2 ;; set local var, have been hoisted
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load ;; load table index
    call_indirect (type $i32_=>_f32) ;; call function
    ;; end of application
    global.get $var_x ;; get local var: var_x, have been hoisted
    f32.eq
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
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load ;; load table index
    call_indirect (type $i32_=>_f32) ;; call function
    ;; end of application
    global.get $var_y ;; get local var: var_y, have been hoisted
    f32.eq
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
    global.get $var_c2 ;; get local var: var_c2, have been hoisted
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_c2 ;; get local var: var_c2, have been hoisted
    i32.load ;; load table index
    call_indirect (type $i32_=>_f32) ;; call function
    ;; end of application
    global.get $var_y ;; get local var: var_y, have been hoisted
    f32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; End of let
    ;; End of let
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_makeCounter (;1;) (param $cenv i32) (param $arg_x f32) (param $arg_y i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr i32)
    (local $Sptr$0 i32)
    (local $Sptr$1 i32)
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
    f32.const 3.000000
    f32.store ;; store float field (value) in memory
    local.get $Sptr ;; push struct address to stack
    ;; end of struct contructor
    local.set $var_a ;; set local var
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
    i32.const 3 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$0 ;; set struct pointer var
    local.get $Sptr$0 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field a
    local.get $var_a ;; get local var: var_a
    i32.store ;; store int field in memory
    local.get $Sptr$0 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field x
    local.get $arg_x ;; get local var: arg_x
    f32.store ;; store float field (x) in memory
    local.get $Sptr$0 ;; get struct pointer var
    i32.const 8 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field y
    local.get $arg_y ;; get local var: arg_y
    i32.store ;; store int field in memory
    local.get $Sptr$0 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$1 ;; get pointer to return struct
    ;; End of let
  )
  (func $fun_makeCounter/anonymous (;2;) (param $cenv i32) (result f32) 
    ;; local variables declarations:
    (local $Sptr i32)

    local.get 0 ;; get env pointer
    i32.load offset=8 ;; load value at offset: 8
    (if (result f32)
      (then
        local.get 0 ;; get env pointer
        i32.load offset=0 ;; load value at offset: 0
        local.get 0 ;; get env pointer
        f32.load offset=4 ;; load value at offset: 4
        ;; Start of field select
        local.get 0 ;; get env pointer
        i32.load offset=0 ;; load value at offset: 0
        f32.load offset=0 ;; load field: value
        ;; End of field select
        f32.add
        f32.store offset=0 ;; store float in struct
        local.get 0 ;; get env pointer
        i32.load offset=0 ;; load value at offset: 0
        f32.load offset=0 ;; load float from struct
      )
      (else
        local.get 0 ;; get env pointer
        i32.load offset=0 ;; load value at offset: 0
        local.get 0 ;; get env pointer
        f32.load offset=4 ;; load value at offset: 4
        ;; Start of field select
        local.get 0 ;; get env pointer
        i32.load offset=0 ;; load value at offset: 0
        f32.load offset=0 ;; load field: value
        ;; End of field select
        f32.add
        f32.const 2.000000
        f32.add
        f32.store offset=0 ;; store float in struct
        local.get 0 ;; get env pointer
        i32.load offset=0 ;; load value at offset: 0
        f32.load offset=0 ;; load float from struct
      )
    )
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)