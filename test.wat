(module
  (type $i32_i32_=>_i32 (;0;) (func (param i32) (param i32) (result i32)))
  (type $i32_i32_i32_i32_=>_i32 (;1;) (func (param i32) (param i32) (param i32) (param i32) (result i32)))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) i32.const 0)
  (global $fun_count*ptr (;1;) (mut i32) i32.const 16)
  (global $fun_f6*ptr (;2;) (mut i32) i32.const 0)
  (global $fun_g*ptr (;3;) (mut i32) i32.const 4)
  (global $fun_g/anonymous*ptr (;4;) (mut i32) i32.const 8)
  (global $fun_g/anonymous/anonymous*ptr (;5;) (mut i32) i32.const 12)
  (global $fun_g/anonymous/anonymous/anonymous*ptr (;6;) (mut i32) i32.const 20)
  (global $heap_base (;7;) i32 i32.const 24)
  (global $var_c7 (;8;) (mut i32) i32.const 0)
  (table $func_table (;0;) 6 funcref)
  (elem (i32.const 0) (;0;) $fun_f6)
  (elem (i32.const 1) (;1;) $fun_g)
  (elem (i32.const 2) (;2;) $fun_g/anonymous)
  (elem (i32.const 3) (;3;) $fun_g/anonymous/anonymous)
  (elem (i32.const 4) (;4;) $fun_count)
  (elem (i32.const 5) (;5;) $fun_g/anonymous/anonymous/anonymous)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f6*ptr ;; get global var: fun_f6*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 1 ;; push 1 on stack
    i32.const 2 ;; push 2 on stack
    i32.const 3 ;; push 3 on stack
    global.get $fun_f6*ptr ;; get global var: fun_f6*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    global.set $var_c7 ;; set local var, have been hoisted
    global.get $var_c7 ;; get local var: var_c7, have been hoisted
    i32.const 612 ;; push 612 on stack
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
  (func $fun_count (;1;) (param $cenv i32) (param $arg_curr i32) (result i32) 
    local.get $arg_curr ;; get local var: arg_curr
    local.get 0 ;; get env pointer
    i32.load offset=8 ;; load value at offset: 8
    i32.lt_s
    (if (result i32)
      (then
        ;; start of application
        ;; Load expression to be applied as a function
        global.get $fun_count*ptr ;; get global var: fun_count*ptr
        i32.load offset=4 ;; load closure environment pointer
        local.get $arg_curr ;; get local var: arg_curr
        i32.const 1 ;; push 1 on stack
        i32.add
        global.get $fun_count*ptr ;; get global var: fun_count*ptr
        i32.load ;; load table index
        call_indirect (type $i32_i32_=>_i32) ;; call function
        ;; end of application
      )
      (else
        local.get $arg_curr ;; get local var: arg_curr
      )
    )
  )
  (func $fun_f6 (;2;) (param $cenv i32) (param $arg_x i32) (param $arg_y i32) (param $arg_z i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr$10 i32)
    (local $Sptr$11 i32)
    (local $var_f0 i32)
    (local $var_f1 i32)
    (local $var_f2 i32)

    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$11 ;; set struct pointer var
    local.get $Sptr$11 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 1 ;; push 1 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$11 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$11 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 0 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$10 ;; set struct pointer var
    local.get $Sptr$10 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$11 ;; get pointer to return struct
    global.set $fun_g*ptr
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_g*ptr ;; get global var: fun_g*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 10 ;; push 10 on stack
    global.get $fun_g*ptr ;; get global var: fun_g*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    local.set $var_f0 ;; set local var
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    local.get $var_f0 ;; get local var: var_f0
    i32.load offset=4 ;; load closure environment pointer
    local.get $arg_x ;; get local var: arg_x
    local.get $var_f0 ;; get local var: var_f0
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    local.set $var_f1 ;; set local var
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    local.get $var_f1 ;; get local var: var_f1
    i32.load offset=4 ;; load closure environment pointer
    local.get $arg_y ;; get local var: arg_y
    local.get $var_f1 ;; get local var: var_f1
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    local.set $var_f2 ;; set local var
    ;; start of application
    ;; Load expression to be applied as a function
    local.get $var_f2 ;; get local var: var_f2
    i32.load offset=4 ;; load closure environment pointer
    local.get $arg_z ;; get local var: arg_z
    local.get $var_f2 ;; get local var: var_f2
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    ;; End of let
    ;; End of let
    ;; End of let
  )
  (func $fun_g (;3;) (param $cenv i32) (param $arg_m i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr$8 i32)
    (local $Sptr$9 i32)
    (local $var_a i32)

    ;; Start of let
    i32.const 3 ;; push 3 on stack
    local.set $var_a ;; set local var
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$9 ;; set struct pointer var
    local.get $Sptr$9 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 2 ;; push 2 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$9 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$9 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 1 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$8 ;; set struct pointer var
    local.get $Sptr$8 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field a
    local.get $var_a ;; get local var: var_a
    i32.store ;; store int field in memory
    local.get $Sptr$8 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$9 ;; get pointer to return struct
    ;; End of let
  )
  (func $fun_g/anonymous (;4;) (param $cenv i32) (param $arg_x$0 i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr$6 i32)
    (local $Sptr$7 i32)
    (local $var_b i32)

    ;; Start of let
    i32.const 3 ;; push 3 on stack
    local.set $var_b ;; set local var
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$7 ;; set struct pointer var
    local.get $Sptr$7 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 3 ;; push 3 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$7 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$7 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 3 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$6 ;; set struct pointer var
    local.get $Sptr$6 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field a
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.store ;; store int field in memory
    local.get $Sptr$6 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field b
    local.get $var_b ;; get local var: var_b
    i32.store ;; store int field in memory
    local.get $Sptr$6 ;; get struct pointer var
    i32.const 8 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field x
    local.get $arg_x$0 ;; get local var: arg_x$0
    i32.store ;; store int field in memory
    local.get $Sptr$6 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$7 ;; get pointer to return struct
    ;; End of let
  )
  (func $fun_g/anonymous/anonymous (;5;) (param $cenv i32) (param $arg_y$1 i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr i32)
    (local $Sptr$2 i32)
    (local $Sptr$4 i32)
    (local $Sptr$5 i32)
    (local $var_c i32)
    (local $var_m i32)

    ;; Start of let
    i32.const 200 ;; push 200 on stack
    local.set $var_m ;; set local var
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$2 ;; set struct pointer var
    local.get $Sptr$2 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 4 ;; push 4 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$2 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$2 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 5 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr ;; set struct pointer var
    local.get $Sptr ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field a
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.store ;; store int field in memory
    local.get $Sptr ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field b
    local.get 0 ;; get env pointer
    i32.load offset=4 ;; load value at offset: 4
    i32.store ;; store int field in memory
    local.get $Sptr ;; get struct pointer var
    i32.const 8 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field m
    local.get $var_m ;; get local var: var_m
    i32.store ;; store int field in memory
    local.get $Sptr ;; get struct pointer var
    i32.const 12 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field x
    local.get 0 ;; get env pointer
    i32.load offset=8 ;; load value at offset: 8
    i32.store ;; store int field in memory
    local.get $Sptr ;; get struct pointer var
    i32.const 16 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field y
    local.get $arg_y$1 ;; get local var: arg_y$1
    i32.store ;; store int field in memory
    local.get $Sptr ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$2 ;; get pointer to return struct
    global.set $fun_count*ptr
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_count*ptr ;; get global var: fun_count*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 10 ;; push 10 on stack
    global.get $fun_count*ptr ;; get global var: fun_count*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    local.set $var_c ;; set local var
    local.get $var_c ;; get local var: var_c
    local.get $var_m ;; get local var: var_m
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$5 ;; set struct pointer var
    local.get $Sptr$5 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 5 ;; push 5 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$5 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$5 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 6 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$4 ;; set struct pointer var
    local.get $Sptr$4 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field a
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.store ;; store int field in memory
    local.get $Sptr$4 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field b
    local.get 0 ;; get env pointer
    i32.load offset=4 ;; load value at offset: 4
    i32.store ;; store int field in memory
    local.get $Sptr$4 ;; get struct pointer var
    i32.const 8 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field c
    local.get $var_c ;; get local var: var_c
    i32.store ;; store int field in memory
    local.get $Sptr$4 ;; get struct pointer var
    i32.const 12 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field m
    local.get $var_m ;; get local var: var_m
    i32.store ;; store int field in memory
    local.get $Sptr$4 ;; get struct pointer var
    i32.const 16 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field x
    local.get 0 ;; get env pointer
    i32.load offset=8 ;; load value at offset: 8
    i32.store ;; store int field in memory
    local.get $Sptr$4 ;; get struct pointer var
    i32.const 20 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field y
    local.get $arg_y$1 ;; get local var: arg_y$1
    i32.store ;; store int field in memory
    local.get $Sptr$4 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$5 ;; get pointer to return struct
    ;; End of let
    ;; End of let
  )
  (func $fun_g/anonymous/anonymous/anonymous (;6;) (param $cenv i32) (param $arg_z$3 i32) (result i32) 
    local.get 0 ;; get env pointer
    i32.load offset=16 ;; load value at offset: 16
    local.get 0 ;; get env pointer
    i32.load offset=20 ;; load value at offset: 20
    i32.add
    local.get $arg_z$3 ;; get local var: arg_z$3
    i32.add
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.add
    local.get 0 ;; get env pointer
    i32.load offset=4 ;; load value at offset: 4
    i32.add
    local.get 0 ;; get env pointer
    i32.load offset=8 ;; load value at offset: 8
    i32.add
    local.get 0 ;; get env pointer
    i32.load offset=12 ;; load value at offset: 12
    i32.add
    local.get 0 ;; get env pointer
    i32.load offset=8 ;; load value at offset: 8
    i32.add
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (data (i32.const 8) "\02")
  (data (i32.const 12) "\03")
  (data (i32.const 16) "\04")
  (data (i32.const 20) "\05")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)