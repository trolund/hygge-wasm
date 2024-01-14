(module
  (type $i32_=>_i32 (;0;) (func (param i32) (result i32)))
  (type $i32_i32_=>_i32 (;1;) (func (param i32) (param i32) (result i32)))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (import "env" "readInt" (;1;) (func $readInt  (result i32)))
  (import "env" "writeInt" (;2;) (func $writeInt (param i32) ))
  (import "env" "writeS" (;3;) (func $writeS (param i32) (param i32) ))
  (memory (;0;) (export "memory") 1)
  (global $Sptr$15 (;0;) (mut i32) i32.const 0)
  (global $exit_code (;1;) (mut i32) i32.const 0)
  (global $fun_makeCal*ptr (;2;) (mut i32) i32.const 0)
  (global $fun_makeCal/anonymous$11*ptr (;3;) (mut i32) i32.const 16)
  (global $fun_makeCal/anonymous$3*ptr (;4;) (mut i32) i32.const 8)
  (global $fun_makeCal/anonymous$7*ptr (;5;) (mut i32) i32.const 12)
  (global $fun_makeCal/anonymous*ptr (;6;) (mut i32) i32.const 4)
  (global $heap_base (;7;) i32 i32.const 416)
  (global $var_action (;8;) (mut i32) i32.const 0)
  (global $var_cal (;9;) (mut i32) i32.const 0)
  (global $var_input (;10;) (mut i32) i32.const 0)
  (global $var_res (;11;) (mut i32) i32.const 0)
  (table $func_table (;0;) 5 funcref)
  (elem (i32.const 0) (;0;) $fun_makeCal)
  (elem (i32.const 1) (;1;) $fun_makeCal/anonymous)
  (elem (i32.const 2) (;2;) $fun_makeCal/anonymous$3)
  (elem (i32.const 3) (;3;) $fun_makeCal/anonymous$7)
  (elem (i32.const 4) (;4;) $fun_makeCal/anonymous$11)
  (func $_start (;0;)  (result i32) ;; entry point of program (main function) 
    ;; execution start here:
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_makeCal*ptr ;; get global var: fun_makeCal*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $fun_makeCal*ptr ;; get global var: fun_makeCal*ptr
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    ;; end of application
    global.set $var_cal ;; set local var, have been hoisted
    ;; Start of let
    ;; start of struct contructor
    i32.const 1 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr$15 ;; set struct pointer var, have been hoisted
    global.get $Sptr$15 ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field value
    i32.const 1 ;; push 1 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$15 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    global.set $var_res ;; set local var, have been hoisted
    (block $loop_exit 
      (loop $loop_begin 
      ;; Start of field select
      global.get $var_res ;; get local var: var_res, have been hoisted
      i32.load offset=0 ;; load field: value
      ;; End of field select
      i32.const 0 ;; push 0 on stack
      i32.gt_s
      i32.eqz
      br_if $loop_exit
      i32.const 20 ;; leave pointer to string on stack
      i32.load ;; Load string pointer
      i32.const 20 ;; leave pointer to string on stack
      i32.const 4 ;; length offset
      i32.add ;; add offset to pointer
      i32.load ;; Load string length
      call $writeS ;; call host function
      ;; Start of let
      call $readInt ;; call host function
      global.set $var_input ;; set local var, have been hoisted
      i32.const 60 ;; leave pointer to string on stack
      i32.load ;; Load string pointer
      i32.const 60 ;; leave pointer to string on stack
      i32.const 4 ;; length offset
      i32.add ;; add offset to pointer
      i32.load ;; Load string length
      call $writeS ;; call host function
      i32.const 108 ;; leave pointer to string on stack
      i32.load ;; Load string pointer
      i32.const 108 ;; leave pointer to string on stack
      i32.const 4 ;; length offset
      i32.add ;; add offset to pointer
      i32.load ;; Load string length
      call $writeS ;; call host function
      i32.const 144 ;; leave pointer to string on stack
      i32.load ;; Load string pointer
      i32.const 144 ;; leave pointer to string on stack
      i32.const 4 ;; length offset
      i32.add ;; add offset to pointer
      i32.load ;; Load string length
      call $writeS ;; call host function
      i32.const 164 ;; leave pointer to string on stack
      i32.load ;; Load string pointer
      i32.const 164 ;; leave pointer to string on stack
      i32.const 4 ;; length offset
      i32.add ;; add offset to pointer
      i32.load ;; Load string length
      call $writeS ;; call host function
      i32.const 184 ;; leave pointer to string on stack
      i32.load ;; Load string pointer
      i32.const 184 ;; leave pointer to string on stack
      i32.const 4 ;; length offset
      i32.add ;; add offset to pointer
      i32.load ;; Load string length
      call $writeS ;; call host function
      i32.const 204 ;; leave pointer to string on stack
      i32.load ;; Load string pointer
      i32.const 204 ;; leave pointer to string on stack
      i32.const 4 ;; length offset
      i32.add ;; add offset to pointer
      i32.load ;; Load string length
      call $writeS ;; call host function
      i32.const 224 ;; leave pointer to string on stack
      i32.load ;; Load string pointer
      i32.const 224 ;; leave pointer to string on stack
      i32.const 4 ;; length offset
      i32.add ;; add offset to pointer
      i32.load ;; Load string length
      call $writeS ;; call host function
      i32.const 248 ;; leave pointer to string on stack
      i32.load ;; Load string pointer
      i32.const 248 ;; leave pointer to string on stack
      i32.const 4 ;; length offset
      i32.add ;; add offset to pointer
      i32.load ;; Load string length
      call $writeS ;; call host function
      ;; Start of let
      call $readInt ;; call host function
      global.set $var_action ;; set local var, have been hoisted
      i32.const 296 ;; leave pointer to string on stack
      i32.load ;; Load string pointer
      i32.const 296 ;; leave pointer to string on stack
      i32.const 4 ;; length offset
      i32.add ;; add offset to pointer
      i32.load ;; Load string length
      call $writeS ;; call host function
      global.get $var_action ;; get local var: var_action, have been hoisted
      i32.const 1 ;; push 1 on stack
      i32.eq
      (if  (result i32)
     (then
      global.get $var_res ;; get local var: var_res, have been hoisted
      ;; start of application
      ;; Load expression to be applied as a function
      ;; Start of field select
      global.get $var_cal ;; get local var: var_cal, have been hoisted
      i32.load offset=0 ;; load field: add
      ;; End of field select
      i32.load offset=4 ;; load closure environment pointer
      global.get $var_input ;; get local var: var_input, have been hoisted
      ;; Start of field select
      global.get $var_cal ;; get local var: var_cal, have been hoisted
      i32.load offset=0 ;; load field: add
      ;; End of field select
      i32.load ;; load table index
      call_indirect (type $i32_i32_=>_i32) ;; call function
      ;; end of application
      i32.store offset=0 ;; store int in struct
      global.get $var_res ;; get local var: var_res, have been hoisted
      i32.load offset=0 ;; load int from struct

     )
     (else
      global.get $var_action ;; get local var: var_action, have been hoisted
      i32.const 2 ;; push 2 on stack
      i32.eq
      (if  (result i32)
     (then
      global.get $var_res ;; get local var: var_res, have been hoisted
      ;; start of application
      ;; Load expression to be applied as a function
      ;; Start of field select
      global.get $var_cal ;; get local var: var_cal, have been hoisted
      i32.load offset=4 ;; load field: sub
      ;; End of field select
      i32.load offset=4 ;; load closure environment pointer
      global.get $var_input ;; get local var: var_input, have been hoisted
      ;; Start of field select
      global.get $var_cal ;; get local var: var_cal, have been hoisted
      i32.load offset=4 ;; load field: sub
      ;; End of field select
      i32.load ;; load table index
      call_indirect (type $i32_i32_=>_i32) ;; call function
      ;; end of application
      i32.store offset=0 ;; store int in struct
      global.get $var_res ;; get local var: var_res, have been hoisted
      i32.load offset=0 ;; load int from struct

     )
     (else
      global.get $var_action ;; get local var: var_action, have been hoisted
      i32.const 3 ;; push 3 on stack
      i32.eq
      (if  (result i32)
     (then
      global.get $var_res ;; get local var: var_res, have been hoisted
      ;; start of application
      ;; Load expression to be applied as a function
      ;; Start of field select
      global.get $var_cal ;; get local var: var_cal, have been hoisted
      i32.load offset=8 ;; load field: mul
      ;; End of field select
      i32.load offset=4 ;; load closure environment pointer
      global.get $var_input ;; get local var: var_input, have been hoisted
      ;; Start of field select
      global.get $var_cal ;; get local var: var_cal, have been hoisted
      i32.load offset=8 ;; load field: mul
      ;; End of field select
      i32.load ;; load table index
      call_indirect (type $i32_i32_=>_i32) ;; call function
      ;; end of application
      i32.store offset=0 ;; store int in struct
      global.get $var_res ;; get local var: var_res, have been hoisted
      i32.load offset=0 ;; load int from struct

     )
     (else
      global.get $var_action ;; get local var: var_action, have been hoisted
      i32.const 4 ;; push 4 on stack
      i32.eq
      (if  (result i32)
     (then
      global.get $var_res ;; get local var: var_res, have been hoisted
      ;; start of application
      ;; Load expression to be applied as a function
      ;; Start of field select
      global.get $var_cal ;; get local var: var_cal, have been hoisted
      i32.load offset=12 ;; load field: div
      ;; End of field select
      i32.load offset=4 ;; load closure environment pointer
      global.get $var_input ;; get local var: var_input, have been hoisted
      ;; Start of field select
      global.get $var_cal ;; get local var: var_cal, have been hoisted
      i32.load offset=12 ;; load field: div
      ;; End of field select
      i32.load ;; load table index
      call_indirect (type $i32_i32_=>_i32) ;; call function
      ;; end of application
      i32.store offset=0 ;; store int in struct
      global.get $var_res ;; get local var: var_res, have been hoisted
      i32.load offset=0 ;; load int from struct

     )
     (else
      global.get $var_action ;; get local var: var_action, have been hoisted
      i32.const 5 ;; push 5 on stack
      i32.eq
      (if  (result i32)
     (then
      global.get $var_res ;; get local var: var_res, have been hoisted
      i32.const 0 ;; push 0 on stack
      i32.store offset=0 ;; store int in struct
      global.get $var_res ;; get local var: var_res, have been hoisted
      i32.load offset=0 ;; load int from struct

     )
     (else
      i32.const 0 ;; push 0 on stack

     )
    )

     )
    )

     )
    )

     )
    )

     )
    )
      i32.const 344 ;; leave pointer to string on stack
      i32.load ;; Load string pointer
      i32.const 344 ;; leave pointer to string on stack
      i32.const 4 ;; length offset
      i32.add ;; add offset to pointer
      i32.load ;; Load string length
      call $writeS ;; call host function
      ;; Start of field select
      global.get $var_res ;; get local var: var_res, have been hoisted
      i32.load offset=0 ;; load field: value
      ;; End of field select
      call $writeInt ;; call host function
      i32.const 368 ;; leave pointer to string on stack
      i32.load ;; Load string pointer
      i32.const 368 ;; leave pointer to string on stack
      i32.const 4 ;; length offset
      i32.add ;; add offset to pointer
      i32.load ;; Load string length
      call $writeS ;; call host function
      ;; End of let
      ;; End of let
      br $loop_begin

)
      nop

    )
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_makeCal (;0;) (param $cenv i32) (result i32) ;; function fun_makeCal    ;; local variables declarations:
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
    (local $var_count i32)
 
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
    local.set $var_count ;; set local var
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
    local.get $var_count ;; get local var: var_count
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
    local.get $var_count ;; get local var: var_count
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
    local.get $var_count ;; get local var: var_count
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
    local.get $var_count ;; get local var: var_count
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
  (func $fun_makeCal/anonymous (;0;) (param $cenv i32) (param $arg_v i32) (result i32) ;; function fun_makeCal/anonymous    ;; local variables declarations:
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
  (func $fun_makeCal/anonymous$11 (;0;) (param $cenv i32) (param $arg_v$12 i32) (result i32) ;; function fun_makeCal/anonymous$11    ;; local variables declarations:
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
  (func $fun_makeCal/anonymous$3 (;0;) (param $cenv i32) (param $arg_v$4 i32) (result i32) ;; function fun_makeCal/anonymous$3    ;; local variables declarations:
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
  (func $fun_makeCal/anonymous$7 (;0;) (param $cenv i32) (param $arg_v$8 i32) (result i32) ;; function fun_makeCal/anonymous$7    ;; local variables declarations:
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
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (data (i32.const 8) "\02")
  (data (i32.const 12) "\03")
  (data (i32.const 16) "\04")
  (data (i32.const 20) "\1c\00\00\00\20\00\00\00")
  (data (i32.const 28) "Enter a number: ")
  (data (i32.const 60) "\44\00\00\00\28\00\00\00")
  (data (i32.const 68) "--------------------")
  (data (i32.const 108) "\74\00\00\00\1c\00\00\00")
  (data (i32.const 116) "Enter action: ")
  (data (i32.const 144) "\98\00\00\00\0c\00\00\00")
  (data (i32.const 152) "1. Add")
  (data (i32.const 164) "\ac\00\00\00\0c\00\00\00")
  (data (i32.const 172) "2. Sub")
  (data (i32.const 184) "\c0\00\00\00\0c\00\00\00")
  (data (i32.const 192) "3. Mul")
  (data (i32.const 204) "\d4\00\00\00\0c\00\00\00")
  (data (i32.const 212) "4. Div")
  (data (i32.const 224) "\e8\00\00\00\10\00\00\00")
  (data (i32.const 232) "5. Reset")
  (data (i32.const 248) "\00\01\00\00\28\00\00\00")
  (data (i32.const 256) "--------------------")
  (data (i32.const 296) "\30\01\00\00\28\00\00\00")
  (data (i32.const 304) "--------------------")
  (data (i32.const 344) "\60\01\00\00\10\00\00\00")
  (data (i32.const 352) "Result: ")
  (data (i32.const 368) "\78\01\00\00\28\00\00\00")
  (data (i32.const 376) "--------------------")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)