(module
  (type $i32_=>_i32 (;0;) (func (param i32) (result i32)))
  (type $i32_i32_=>_i32 (;1;) (func (param i32) (param i32) (result i32)))
  (type $i32_i32_i32_=>_i32 (;2;) (func (param i32) (param i32) (param i32) (result i32)))
  (type $i32_i32_i32_i32_=>_i32 (;3;) (func (param i32) (param i32) (param i32) (param i32) (result i32)))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) i32.const 0)
  (global $fun_f0*ptr (;1;) (mut i32) i32.const 0)
  (global $fun_f0/anonymous*ptr (;2;) (mut i32) i32.const 4)
  (global $fun_f1*ptr (;3;) (mut i32) i32.const 8)
  (global $fun_f1/anonymous*ptr (;4;) (mut i32) i32.const 12)
  (global $fun_f2*ptr (;5;) (mut i32) i32.const 16)
  (global $fun_f2/anonymous*ptr (;6;) (mut i32) i32.const 20)
  (global $fun_f3*ptr (;7;) (mut i32) i32.const 24)
  (global $fun_f3/anonymous*ptr (;8;) (mut i32) i32.const 28)
  (global $fun_f4*ptr (;9;) (mut i32) i32.const 32)
  (global $fun_f4/anonymous*ptr (;10;) (mut i32) i32.const 36)
  (global $fun_f5*ptr (;11;) (mut i32) i32.const 40)
  (global $fun_f6*ptr (;12;) (mut i32) i32.const 60)
  (global $fun_g$33*ptr (;13;) (mut i32) i32.const 64)
  (global $fun_g$33/anonymous*ptr (;14;) (mut i32) i32.const 68)
  (global $fun_g$33/anonymous/anonymous*ptr (;15;) (mut i32) i32.const 72)
  (global $fun_g$33/anonymous/anonymous/anonymous*ptr (;16;) (mut i32) i32.const 76)
  (global $fun_g*ptr (;17;) (mut i32) i32.const 44)
  (global $fun_g/anonymous*ptr (;18;) (mut i32) i32.const 48)
  (global $fun_k*ptr (;19;) (mut i32) i32.const 52)
  (global $fun_k/anonymous*ptr (;20;) (mut i32) i32.const 56)
  (global $heap_base (;21;) i32 i32.const 80)
  (global $var_c1 (;22;) (mut i32) i32.const 0)
  (global $var_c2 (;23;) (mut i32) i32.const 0)
  (global $var_c3 (;24;) (mut i32) i32.const 0)
  (global $var_c4 (;25;) (mut i32) i32.const 0)
  (global $var_c5 (;26;) (mut i32) i32.const 0)
  (global $var_c6 (;27;) (mut i32) i32.const 0)
  (global $var_c7 (;28;) (mut i32) i32.const 0)
  (global $var_x (;29;) (mut i32) i32.const 0)
  (table $func_table (;0;) 20 funcref)
  (elem (i32.const 0) (;0;) $fun_f0)
  (elem (i32.const 1) (;1;) $fun_f0/anonymous)
  (elem (i32.const 2) (;2;) $fun_f1)
  (elem (i32.const 3) (;3;) $fun_f1/anonymous)
  (elem (i32.const 4) (;4;) $fun_f2)
  (elem (i32.const 5) (;5;) $fun_f2/anonymous)
  (elem (i32.const 6) (;6;) $fun_f3)
  (elem (i32.const 7) (;7;) $fun_f3/anonymous)
  (elem (i32.const 8) (;8;) $fun_f4)
  (elem (i32.const 9) (;9;) $fun_f4/anonymous)
  (elem (i32.const 10) (;10;) $fun_f5)
  (elem (i32.const 11) (;11;) $fun_g)
  (elem (i32.const 12) (;12;) $fun_g/anonymous)
  (elem (i32.const 13) (;13;) $fun_k)
  (elem (i32.const 14) (;14;) $fun_k/anonymous)
  (elem (i32.const 15) (;15;) $fun_f6)
  (elem (i32.const 16) (;16;) $fun_g$33)
  (elem (i32.const 17) (;17;) $fun_g$33/anonymous)
  (elem (i32.const 18) (;18;) $fun_g$33/anonymous/anonymous)
  (elem (i32.const 19) (;19;) $fun_g$33/anonymous/anonymous/anonymous)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    i32.const 5 ;; push 5 on stack
    global.set $var_x ;; set local var, have been hoisted
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f0*ptr ;; get global var: fun_f0*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 3 ;; push 3 on stack
    global.get $fun_f0*ptr ;; get global var: fun_f0*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    global.set $var_c1 ;; set local var, have been hoisted
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f1*ptr ;; get global var: fun_f1*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 3 ;; push 3 on stack
    global.get $fun_f1*ptr ;; get global var: fun_f1*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    global.set $var_c2 ;; set local var, have been hoisted
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f2*ptr ;; get global var: fun_f2*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 3 ;; push 3 on stack
    global.get $fun_f2*ptr ;; get global var: fun_f2*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    global.set $var_c3 ;; set local var, have been hoisted
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f3*ptr ;; get global var: fun_f3*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 3 ;; push 3 on stack
    global.get $fun_f3*ptr ;; get global var: fun_f3*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    global.set $var_c4 ;; set local var, have been hoisted
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f4*ptr ;; get global var: fun_f4*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 3 ;; push 3 on stack
    global.get $fun_f4*ptr ;; get global var: fun_f4*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    global.set $var_c5 ;; set local var, have been hoisted
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f5*ptr ;; get global var: fun_f5*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 1 ;; push 1 on stack
    i32.const 2 ;; push 2 on stack
    global.get $fun_f5*ptr ;; get global var: fun_f5*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    global.set $var_c6 ;; set local var, have been hoisted
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
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    ;; end of application
    i32.const 6 ;; push 6 on stack
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
    global.get $var_c2 ;; get local var: var_c2, have been hoisted
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_c2 ;; get local var: var_c2, have been hoisted
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    ;; end of application
    i32.const 3 ;; push 3 on stack
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
    global.get $var_c3 ;; get local var: var_c3, have been hoisted
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_c3 ;; get local var: var_c3, have been hoisted
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    ;; end of application
    i32.const 10 ;; push 10 on stack
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
    global.get $var_c4 ;; get local var: var_c4, have been hoisted
    i32.load offset=4 ;; load closure environment pointer
    i32.const 3 ;; push 3 on stack
    global.get $var_c4 ;; get local var: var_c4, have been hoisted
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 6 ;; push 6 on stack
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
    global.get $var_c5 ;; get local var: var_c5, have been hoisted
    i32.load offset=4 ;; load closure environment pointer
    i32.const 3 ;; push 3 on stack
    global.get $var_c5 ;; get local var: var_c5, have been hoisted
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 9 ;; push 9 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_c6 ;; get local var: var_c6, have been hoisted
    i32.const 15 ;; push 15 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_c7 ;; get local var: var_c7, have been hoisted
    i32.const 25 ;; push 25 on stack
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
    ;; End of let
    ;; End of let
    ;; End of let
    ;; End of let
    ;; End of let
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_f0 (;1;) (param $cenv i32) (param $arg_x i32) (result i32) 
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
    i32.const 3 ;; push 3 on stack
    i32.store ;; store int field in memory
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
    i32.const 2 ;; size of struct
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
    i32.store ;; store int field in memory
    local.get $Sptr$0 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$1 ;; get pointer to return struct
    ;; End of let
  )
  (func $fun_f0/anonymous (;2;) (param $cenv i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr i32)

    local.get 0 ;; get env pointer
    i32.load offset=4 ;; load value at offset: 4
    ;; Start of field select
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load offset=0 ;; load field: value
    ;; End of field select
    i32.add
  )
  (func $fun_f1 (;3;) (param $cenv i32) (param $arg_x$2 i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr$3 i32)
    (local $Sptr$4 i32)

    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$4 ;; set struct pointer var
    local.get $Sptr$4 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 3 ;; push 3 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$4 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$4 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 1 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$3 ;; set struct pointer var
    local.get $Sptr$3 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field x
    local.get $arg_x$2 ;; get local var: arg_x$2
    i32.store ;; store int field in memory
    local.get $Sptr$3 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$4 ;; get pointer to return struct
  )
  (func $fun_f1/anonymous (;4;) (param $cenv i32) (result i32) 
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
  )
  (func $fun_f2 (;5;) (param $cenv i32) (param $arg_x$5 i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr$6 i32)
    (local $Sptr$7 i32)

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
    i32.const 5 ;; push 5 on stack
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
    i32.const 0 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$6 ;; set struct pointer var
    local.get $Sptr$6 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$7 ;; get pointer to return struct
  )
  (func $fun_f2/anonymous (;6;) (param $cenv i32) (result i32) 
    i32.const 10 ;; push 10 on stack
  )
  (func $fun_f3 (;7;) (param $cenv i32) (param $arg_x$8 i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr$10 i32)
    (local $Sptr$9 i32)

    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$10 ;; set struct pointer var
    local.get $Sptr$10 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 7 ;; push 7 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$10 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$10 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 1 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$9 ;; set struct pointer var
    local.get $Sptr$9 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field x
    local.get $arg_x$8 ;; get local var: arg_x$8
    i32.store ;; store int field in memory
    local.get $Sptr$9 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$10 ;; get pointer to return struct
  )
  (func $fun_f3/anonymous (;8;) (param $cenv i32) (param $arg_y i32) (result i32) 
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    local.get $arg_y ;; get local var: arg_y
    i32.add
  )
  (func $fun_f4 (;9;) (param $cenv i32) (param $arg_x$11 i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr$12 i32)
    (local $Sptr$15 i32)
    (local $Sptr$16 i32)
    (local $var_a$13 i32)

    ;; Start of let
    ;; start of struct contructor
    i32.const 1 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$12 ;; set struct pointer var
    local.get $Sptr$12 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field value
    i32.const 3 ;; push 3 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$12 ;; push struct address to stack
    ;; end of struct contructor
    local.set $var_a$13 ;; set local var
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$16 ;; set struct pointer var
    local.get $Sptr$16 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 9 ;; push 9 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$16 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$16 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$15 ;; set struct pointer var
    local.get $Sptr$15 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field a
    local.get $var_a$13 ;; get local var: var_a$13
    i32.store ;; store int field in memory
    local.get $Sptr$15 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field x
    local.get $arg_x$11 ;; get local var: arg_x$11
    i32.store ;; store int field in memory
    local.get $Sptr$15 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$16 ;; get pointer to return struct
    ;; End of let
  )
  (func $fun_f4/anonymous (;10;) (param $cenv i32) (param $arg_y$14 i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr$12 i32)

    local.get 0 ;; get env pointer
    i32.load offset=4 ;; load value at offset: 4
    local.get $arg_y$14 ;; get local var: arg_y$14
    i32.add
    ;; Start of field select
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load offset=0 ;; load field: value
    ;; End of field select
    i32.add
  )
  (func $fun_f5 (;11;) (param $cenv i32) (param $arg_x$17 i32) (param $arg_y$18 i32) (result i32) 
    ;; local variables declarations:
    (local $var_f0 i32)
    (local $var_f1 i32)

    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_g*ptr ;; get global var: fun_g*ptr
    i32.load offset=4 ;; load closure environment pointer
    local.get $arg_x$17 ;; get local var: arg_x$17
    global.get $fun_g*ptr ;; get global var: fun_g*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    local.set $var_f0 ;; set local var
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_k*ptr ;; get global var: fun_k*ptr
    i32.load offset=4 ;; load closure environment pointer
    local.get $arg_y$18 ;; get local var: arg_y$18
    global.get $fun_k*ptr ;; get global var: fun_k*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    local.set $var_f1 ;; set local var
    ;; start of application
    ;; Load expression to be applied as a function
    local.get $var_f0 ;; get local var: var_f0
    i32.load offset=4 ;; load closure environment pointer
    local.get $arg_x$17 ;; get local var: arg_x$17
    local.get $var_f0 ;; get local var: var_f0
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    ;; start of application
    ;; Load expression to be applied as a function
    local.get $var_f1 ;; get local var: var_f1
    i32.load offset=4 ;; load closure environment pointer
    local.get $arg_y$18 ;; get local var: arg_y$18
    local.get $var_f1 ;; get local var: var_f1
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.add
    i32.const 2 ;; push 2 on stack
    i32.add
    ;; End of let
    ;; End of let
  )
  (func $fun_f6 (;12;) (param $cenv i32) (param $arg_x$31 i32) (param $arg_y$32 i32) (param $arg_z i32) (result i32) 
    ;; local variables declarations:
    (local $var_f0$44 i32)
    (local $var_f1$45 i32)
    (local $var_f2 i32)

    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_g$33*ptr ;; get global var: fun_g$33*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 10 ;; push 10 on stack
    global.get $fun_g$33*ptr ;; get global var: fun_g$33*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    local.set $var_f0$44 ;; set local var
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    local.get $var_f0$44 ;; get local var: var_f0$44
    i32.load offset=4 ;; load closure environment pointer
    local.get $arg_x$31 ;; get local var: arg_x$31
    local.get $var_f0$44 ;; get local var: var_f0$44
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    local.set $var_f1$45 ;; set local var
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    local.get $var_f1$45 ;; get local var: var_f1$45
    i32.load offset=4 ;; load closure environment pointer
    local.get $arg_y$32 ;; get local var: arg_y$32
    local.get $var_f1$45 ;; get local var: var_f1$45
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
  (func $fun_g (;13;) (param $cenv i32) (param $arg_x$19 i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr$20 i32)
    (local $Sptr$23 i32)
    (local $Sptr$24 i32)
    (local $var_a$21 i32)

    ;; Start of let
    ;; start of struct contructor
    i32.const 1 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$20 ;; set struct pointer var
    local.get $Sptr$20 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field value
    i32.const 3 ;; push 3 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$20 ;; push struct address to stack
    ;; end of struct contructor
    local.set $var_a$21 ;; set local var
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$24 ;; set struct pointer var
    local.get $Sptr$24 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 12 ;; push 12 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$24 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$24 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$23 ;; set struct pointer var
    local.get $Sptr$23 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field a
    local.get $var_a$21 ;; get local var: var_a$21
    i32.store ;; store int field in memory
    local.get $Sptr$23 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field x
    local.get $arg_x$19 ;; get local var: arg_x$19
    i32.store ;; store int field in memory
    local.get $Sptr$23 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$24 ;; get pointer to return struct
    ;; End of let
  )
  (func $fun_g$33 (;14;) (param $cenv i32) (param $arg_m i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr$42 i32)
    (local $Sptr$43 i32)
    (local $var_a$34 i32)

    ;; Start of let
    i32.const 3 ;; push 3 on stack
    local.set $var_a$34 ;; set local var
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$43 ;; set struct pointer var
    local.get $Sptr$43 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 17 ;; push 17 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$43 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$43 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$42 ;; set struct pointer var
    local.get $Sptr$42 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field a
    local.get $var_a$34 ;; get local var: var_a$34
    i32.store ;; store int field in memory
    local.get $Sptr$42 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field m
    local.get $arg_m ;; get local var: arg_m
    i32.store ;; store int field in memory
    local.get $Sptr$42 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$43 ;; get pointer to return struct
    ;; End of let
  )
  (func $fun_g$33/anonymous (;15;) (param $cenv i32) (param $arg_x$35 i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr$40 i32)
    (local $Sptr$41 i32)
    (local $var_b i32)

    ;; Start of let
    i32.const 3 ;; push 3 on stack
    local.set $var_b ;; set local var
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$41 ;; set struct pointer var
    local.get $Sptr$41 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 18 ;; push 18 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$41 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$41 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 4 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$40 ;; set struct pointer var
    local.get $Sptr$40 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field a
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.store ;; store int field in memory
    local.get $Sptr$40 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field b
    local.get $var_b ;; get local var: var_b
    i32.store ;; store int field in memory
    local.get $Sptr$40 ;; get struct pointer var
    i32.const 8 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field m
    local.get 0 ;; get env pointer
    i32.load offset=4 ;; load value at offset: 4
    i32.store ;; store int field in memory
    local.get $Sptr$40 ;; get struct pointer var
    i32.const 12 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field x
    local.get $arg_x$35 ;; get local var: arg_x$35
    i32.store ;; store int field in memory
    local.get $Sptr$40 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$41 ;; get pointer to return struct
    ;; End of let
  )
  (func $fun_g$33/anonymous/anonymous (;16;) (param $cenv i32) (param $arg_y$36 i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr$38 i32)
    (local $Sptr$39 i32)
    (local $var_c i32)

    ;; Start of let
    i32.const 3 ;; push 3 on stack
    local.set $var_c ;; set local var
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$39 ;; set struct pointer var
    local.get $Sptr$39 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 19 ;; push 19 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$39 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$39 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 6 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$38 ;; set struct pointer var
    local.get $Sptr$38 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field a
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.store ;; store int field in memory
    local.get $Sptr$38 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field b
    local.get 0 ;; get env pointer
    i32.load offset=4 ;; load value at offset: 4
    i32.store ;; store int field in memory
    local.get $Sptr$38 ;; get struct pointer var
    i32.const 8 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field c
    local.get $var_c ;; get local var: var_c
    i32.store ;; store int field in memory
    local.get $Sptr$38 ;; get struct pointer var
    i32.const 12 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field m
    local.get 0 ;; get env pointer
    i32.load offset=8 ;; load value at offset: 8
    i32.store ;; store int field in memory
    local.get $Sptr$38 ;; get struct pointer var
    i32.const 16 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field x
    local.get 0 ;; get env pointer
    i32.load offset=12 ;; load value at offset: 12
    i32.store ;; store int field in memory
    local.get $Sptr$38 ;; get struct pointer var
    i32.const 20 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field y
    local.get $arg_y$36 ;; get local var: arg_y$36
    i32.store ;; store int field in memory
    local.get $Sptr$38 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$39 ;; get pointer to return struct
    ;; End of let
  )
  (func $fun_g$33/anonymous/anonymous/anonymous (;17;) (param $cenv i32) (param $arg_z$37 i32) (result i32) 
    local.get 0 ;; get env pointer
    i32.load offset=16 ;; load value at offset: 16
    local.get 0 ;; get env pointer
    i32.load offset=20 ;; load value at offset: 20
    i32.add
    local.get $arg_z$37 ;; get local var: arg_z$37
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
  )
  (func $fun_g/anonymous (;18;) (param $cenv i32) (param $arg_y$22 i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr$20 i32)

    local.get 0 ;; get env pointer
    i32.load offset=4 ;; load value at offset: 4
    local.get $arg_y$22 ;; get local var: arg_y$22
    i32.add
    ;; Start of field select
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load offset=0 ;; load field: value
    ;; End of field select
    i32.add
  )
  (func $fun_k (;19;) (param $cenv i32) (param $arg_x$25 i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr$26 i32)
    (local $Sptr$29 i32)
    (local $Sptr$30 i32)
    (local $var_a$27 i32)

    ;; Start of let
    ;; start of struct contructor
    i32.const 1 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$26 ;; set struct pointer var
    local.get $Sptr$26 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field value
    i32.const 4 ;; push 4 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$26 ;; push struct address to stack
    ;; end of struct contructor
    local.set $var_a$27 ;; set local var
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$30 ;; set struct pointer var
    local.get $Sptr$30 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 14 ;; push 14 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$30 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$30 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$29 ;; set struct pointer var
    local.get $Sptr$29 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field a
    local.get $var_a$27 ;; get local var: var_a$27
    i32.store ;; store int field in memory
    local.get $Sptr$29 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field x
    local.get $arg_x$25 ;; get local var: arg_x$25
    i32.store ;; store int field in memory
    local.get $Sptr$29 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$30 ;; get pointer to return struct
    ;; End of let
  )
  (func $fun_k/anonymous (;20;) (param $cenv i32) (param $arg_y$28 i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr$26 i32)

    local.get 0 ;; get env pointer
    i32.load offset=4 ;; load value at offset: 4
    local.get $arg_y$28 ;; get local var: arg_y$28
    i32.add
    ;; Start of field select
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load offset=0 ;; load field: value
    ;; End of field select
    i32.add
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (data (i32.const 8) "\02")
  (data (i32.const 12) "\03")
  (data (i32.const 16) "\04")
  (data (i32.const 20) "\05")
  (data (i32.const 24) "\06")
  (data (i32.const 28) "\07")
  (data (i32.const 32) "\08")
  (data (i32.const 36) "\09")
  (data (i32.const 40) "\0a")
  (data (i32.const 44) "\0b")
  (data (i32.const 48) "\0c")
  (data (i32.const 52) "\0d")
  (data (i32.const 56) "\0e")
  (data (i32.const 60) "\0f")
  (data (i32.const 64) "\10")
  (data (i32.const 68) "\11")
  (data (i32.const 72) "\12")
  (data (i32.const 76) "\13")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)