(module
  (type $i32_i32_=>_i32 (;0;) (func (param i32) (param i32) (result i32)))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) i32.const 0)
  (global $fun_f*ptr (;1;) (mut i32) i32.const 0)
  (global $fun_g*ptr (;2;) (mut i32) i32.const 4)
  (global $fun_g/anonymous*ptr (;3;) (mut i32) i32.const 8)
  (global $fun_g/anonymous/anonymous*ptr (;4;) (mut i32) i32.const 12)
  (global $fun_g/anonymous/anonymous/anonymous*ptr (;5;) (mut i32) i32.const 16)
  (global $heap_base (;6;) i32 i32.const 20)
  (global $var_c7 (;7;) (mut i32) i32.const 0)
  (global $var_input (;8;) (mut i32) i32.const 0)
  (table $func_table (;0;) 5 funcref)
  (elem (i32.const 0) (;0;) $fun_f)
  (elem (i32.const 1) (;1;) $fun_g)
  (elem (i32.const 2) (;2;) $fun_g/anonymous)
  (elem (i32.const 3) (;3;) $fun_g/anonymous/anonymous)
  (elem (i32.const 4) (;4;) $fun_g/anonymous/anonymous/anonymous)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    i32.const 10 ;; push 10 on stack
    global.set $var_input ;; set local var, have been hoisted
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f*ptr ;; get global var: fun_f*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_input ;; get local var: var_input, have been hoisted
    global.get $fun_f*ptr ;; get global var: fun_f*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    global.set $var_c7 ;; set local var, have been hoisted
    global.get $var_c7 ;; get local var: var_c7, have been hoisted
    i32.const 200 ;; push 200 on stack
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
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_f (;1;) (param $cenv i32) (param $arg_x i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr$11 i32)
    (local $Sptr$12 i32)
    (local $var_f0 i32)
    (local $var_f1 i32)
    (local $var_f2 i32)

    local.get $arg_x ;; get local var: arg_x
    global.get $var_input ;; get local var: var_input, have been hoisted
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
    local.set $Sptr$12 ;; set struct pointer var
    local.get $Sptr$12 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 1 ;; push 1 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$12 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$12 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 0 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$11 ;; set struct pointer var
    local.get $Sptr$11 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$12 ;; get pointer to return struct
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
    i32.const 12 ;; push 12 on stack
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
    i32.const 13 ;; push 13 on stack
    local.get $var_f1 ;; get local var: var_f1
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    local.set $var_f2 ;; set local var
    ;; start of application
    ;; Load expression to be applied as a function
    local.get $var_f2 ;; get local var: var_f2
    i32.load offset=4 ;; load closure environment pointer
    i32.const 200 ;; push 200 on stack
    local.get $var_f2 ;; get local var: var_f2
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    ;; End of let
    ;; End of let
    ;; End of let
  )
  (func $fun_g (;2;) (param $cenv i32) (param $arg_x$0 i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr$10 i32)
    (local $Sptr$9 i32)
    (local $var_x i32)

    local.get $arg_x$0 ;; get local var: arg_x$0
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
    ;; Start of let
    i32.const 3 ;; push 3 on stack
    local.set $var_x ;; set local var
    local.get $var_x ;; get local var: var_x
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
    i32.const 2 ;; push 2 on stack
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
    i32.const 0 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$9 ;; set struct pointer var
    local.get $Sptr$9 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$10 ;; get pointer to return struct
    ;; End of let
  )
  (func $fun_g/anonymous (;3;) (param $cenv i32) (param $arg_x$1 i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr$7 i32)
    (local $Sptr$8 i32)
    (local $var_x$2 i32)

    local.get $arg_x$1 ;; get local var: arg_x$1
    i32.const 12 ;; push 12 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; Start of let
    i32.const 4 ;; push 4 on stack
    local.set $var_x$2 ;; set local var
    local.get $var_x$2 ;; get local var: var_x$2
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
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$8 ;; set struct pointer var
    local.get $Sptr$8 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 3 ;; push 3 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$8 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$8 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 0 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$7 ;; set struct pointer var
    local.get $Sptr$7 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$8 ;; get pointer to return struct
    ;; End of let
  )
  (func $fun_g/anonymous/anonymous (;4;) (param $cenv i32) (param $arg_x$3 i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr i32)
    (local $Sptr$6 i32)
    (local $var_x$4 i32)

    local.get $arg_x$3 ;; get local var: arg_x$3
    i32.const 13 ;; push 13 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; Start of let
    i32.const 5 ;; push 5 on stack
    local.set $var_x$4 ;; set local var
    local.get $var_x$4 ;; get local var: var_x$4
    i32.const 5 ;; push 5 on stack
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
    local.set $Sptr$6 ;; set struct pointer var
    local.get $Sptr$6 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 4 ;; push 4 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$6 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$6 ;; push struct address to stack
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
    local.get $Sptr$6 ;; get pointer to return struct
    ;; End of let
  )
  (func $fun_g/anonymous/anonymous/anonymous (;5;) (param $cenv i32) (param $arg_x$5 i32) (result i32) 
    local.get $arg_x$5 ;; get local var: arg_x$5
    i32.const 200 ;; push 200 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    local.get $arg_x$5 ;; get local var: arg_x$5
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (data (i32.const 8) "\02")
  (data (i32.const 12) "\03")
  (data (i32.const 16) "\04")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)