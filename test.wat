(module
  (type $i32_=>_i32 (func (param i32) (result i32)))
  (type $i32_i32_=>_i32 (func (param i32) (param i32) (result i32)))
  (import "env" "malloc" (func $malloc (param i32) (result i32)
))
  (memory (export "memory") 1)
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (data (i32.const 8) "\02")
  (data (i32.const 12) "\03")
  (data (i32.const 16) "\04")
  (global $exit_code (mut i32) i32.const 0)
  (global $fun_makeCal*ptr (mut i32) i32.const 0)
  (global $fun_makeCal/anonymous$11*ptr (mut i32) i32.const 16)
  (global $fun_makeCal/anonymous$3*ptr (mut i32) i32.const 8)
  (global $fun_makeCal/anonymous$7*ptr (mut i32) i32.const 12)
  (global $fun_makeCal/anonymous*ptr (mut i32) i32.const 4)
  (global $heap_base i32 i32.const 20)
  (global $var_c1 (mut i32) i32.const 0)
  (global $var_c2 (mut i32) i32.const 0)
  (global $var_count (mut i32) i32.const 0)
  (table $func_table 5 funcref)
  (elem (i32.const 0) $fun_makeCal)
  (elem (i32.const 1) $fun_makeCal/anonymous)
  (elem (i32.const 2) $fun_makeCal/anonymous$3)
  (elem (i32.const 3) $fun_makeCal/anonymous$7)
  (elem (i32.const 4) $fun_makeCal/anonymous$11)
  (func $_start  (result i32) ;; entry point of program (main function)
 
    ;; execution start here:
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_makeCal*ptr ;; get global var: fun_makeCal*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    global.get $fun_makeCal*ptr ;; get global var: fun_makeCal*ptr
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    ;; end of application
    global.set $var_c1 ;; set local var, have been hoisted
    ;; start of application
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=0 ;; load field: add
    ;; End of field select
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    i32.const 2 ;; push 2 on stack
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=0 ;; load field: add
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 2 ;; push 2 on stack
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
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=0 ;; load field: add
    ;; End of field select
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    i32.const 4 ;; push 4 on stack
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=0 ;; load field: add
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 6 ;; push 6 on stack
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
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=8 ;; load field: mul
    ;; End of field select
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    i32.const 2 ;; push 2 on stack
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=8 ;; load field: mul
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 12 ;; push 12 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
       )
      )
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_makeCal*ptr ;; get global var: fun_makeCal*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    global.get $fun_makeCal*ptr ;; get global var: fun_makeCal*ptr
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    ;; end of application
    global.set $var_c2 ;; set local var, have been hoisted
    ;; start of application
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c2 ;; get local var: var_c2, have been hoisted
    i32.load offset=0 ;; load field: add
    ;; End of field select
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    i32.const 10 ;; push 10 on stack
    ;; Start of field select
    global.get $var_c2 ;; get local var: var_c2, have been hoisted
    i32.load offset=0 ;; load field: add
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 10 ;; push 10 on stack
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
    ;; Start of field select
    global.get $var_c2 ;; get local var: var_c2, have been hoisted
    i32.load offset=12 ;; load field: div
    ;; End of field select
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    i32.const 2 ;; push 2 on stack
    ;; Start of field select
    global.get $var_c2 ;; get local var: var_c2, have been hoisted
    i32.load offset=12 ;; load field: div
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 5 ;; push 5 on stack
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
    ;; Start of field select
    global.get $var_c2 ;; get local var: var_c2, have been hoisted
    i32.load offset=4 ;; load field: sub
    ;; End of field select
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    i32.const 2 ;; push 2 on stack
    ;; Start of field select
    global.get $var_c2 ;; get local var: var_c2, have been hoisted
    i32.load offset=4 ;; load field: sub
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 3 ;; push 3 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
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
  (func $fun_makeCal (param $cenv i32) (result i32) ;; function fun_makeCal
    ;; local variables declarations:
    (local $Sptr i32)
    (local $Sptr$0 i32)
    (local $Sptr$1 i32)
    (local $Sptr$10 i32)
    (local $Sptr$13 i32)
    (local $Sptr$14 i32)
    (local $Sptr$2 i32)
    (local $Sptr$5 i32)
    (local $Sptr$6 i32)
    (local $Sptr$9 i32)
 
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
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr ;; push struct address to stack
    ;; end of struct contructor
    global.set $var_count ;; set local var, have been hoisted
    ;; start of struct contructor
    i32.const 4 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$0 ;; set struct pointer var
    local.get $Sptr$0 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field add
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
    i32.const 1 ;; push 1 on stack
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
    i32.const 1 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$1 ;; set struct pointer var
    local.get $Sptr$1 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field count
    global.get $var_count ;; get local var: var_count, have been hoisted
    i32.store ;; store int field in memory
    local.get $Sptr$1 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$2 ;; get pointer to return struct
    i32.store ;; store int field in memory
    local.get $Sptr$0 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field sub
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
    i32.const 2 ;; push 2 on stack
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
    i32.const 1 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$5 ;; set struct pointer var
    local.get $Sptr$5 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field count
    global.get $var_count ;; get local var: var_count, have been hoisted
    i32.store ;; store int field in memory
    local.get $Sptr$5 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$6 ;; get pointer to return struct
    i32.store ;; store int field in memory
    local.get $Sptr$0 ;; get struct pointer var
    i32.const 8 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field mul
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
    i32.const 3 ;; push 3 on stack
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
    ;; init field count
    global.get $var_count ;; get local var: var_count, have been hoisted
    i32.store ;; store int field in memory
    local.get $Sptr$9 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$10 ;; get pointer to return struct
    i32.store ;; store int field in memory
    local.get $Sptr$0 ;; get struct pointer var
    i32.const 12 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field div
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$14 ;; set struct pointer var
    local.get $Sptr$14 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 4 ;; push 4 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$14 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$14 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 1 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$13 ;; set struct pointer var
    local.get $Sptr$13 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field count
    global.get $var_count ;; get local var: var_count, have been hoisted
    i32.store ;; store int field in memory
    local.get $Sptr$13 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$14 ;; get pointer to return struct
    i32.store ;; store int field in memory
    local.get $Sptr$0 ;; push struct address to stack
    ;; end of struct contructor
    ;; End of let
  )
  (func $fun_makeCal/anonymous (param $cenv i32) (param $arg_v i32) (result i32) ;; function fun_makeCal/anonymous
    ;; local variables declarations:
    (local $Sptr i32)
 
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    ;; Start of field select
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load offset=0 ;; load field: value
    ;; End of field select
    local.get $arg_v ;; get local var: arg_v
    i32.add
    i32.store offset=0 ;; store int in struct
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load offset=0 ;; load int from struct
  )
  (func $fun_makeCal/anonymous$11 (param $cenv i32) (param $arg_v$12 i32) (result i32) ;; function fun_makeCal/anonymous$11
    ;; local variables declarations:
    (local $Sptr i32)
 
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    ;; Start of field select
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load offset=0 ;; load field: value
    ;; End of field select
    local.get $arg_v$12 ;; get local var: arg_v$12
    i32.div_s
    i32.store offset=0 ;; store int in struct
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load offset=0 ;; load int from struct
  )
  (func $fun_makeCal/anonymous$3 (param $cenv i32) (param $arg_v$4 i32) (result i32) ;; function fun_makeCal/anonymous$3
    ;; local variables declarations:
    (local $Sptr i32)
 
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    ;; Start of field select
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load offset=0 ;; load field: value
    ;; End of field select
    local.get $arg_v$4 ;; get local var: arg_v$4
    i32.sub
    i32.store offset=0 ;; store int in struct
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load offset=0 ;; load int from struct
  )
  (func $fun_makeCal/anonymous$7 (param $cenv i32) (param $arg_v$8 i32) (result i32) ;; function fun_makeCal/anonymous$7
    ;; local variables declarations:
    (local $Sptr i32)
 
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    ;; Start of field select
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load offset=0 ;; load field: value
    ;; End of field select
    local.get $arg_v$8 ;; get local var: arg_v$8
    i32.mul
    i32.store offset=0 ;; store int in struct
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load offset=0 ;; load int from struct
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)