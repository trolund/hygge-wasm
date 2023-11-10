(module
  (type $i32_=>_i32 (;0;) (func (param i32) (result i32)))
  (type $i32_i32_=>_i32 (;1;) (func (param i32) (param i32) (result i32)))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) i32.const 0)
  (global $fun_checkOption*ptr (;1;) (mut i32) i32.const 4)
  (global $fun_makeCounters*ptr (;2;) (mut i32) i32.const 0)
  (global $fun_makeCounters/anonymous$10*ptr (;3;) (mut i32) i32.const 16)
  (global $fun_makeCounters/anonymous$14*ptr (;4;) (mut i32) i32.const 20)
  (global $fun_makeCounters/anonymous$18*ptr (;5;) (mut i32) i32.const 24)
  (global $fun_makeCounters/anonymous$6*ptr (;6;) (mut i32) i32.const 12)
  (global $fun_makeCounters/anonymous*ptr (;7;) (mut i32) i32.const 8)
  (global $heap_base (;8;) i32 i32.const 28)
  (global $var_c1 (;9;) (mut i32) i32.const 0)
  (table $func_table (;0;) 7 funcref)
  (elem (i32.const 0) (;0;) $fun_makeCounters)
  (elem (i32.const 1) (;1;) $fun_checkOption)
  (elem (i32.const 2) (;2;) $fun_makeCounters/anonymous)
  (elem (i32.const 3) (;3;) $fun_makeCounters/anonymous$6)
  (elem (i32.const 4) (;4;) $fun_makeCounters/anonymous$10)
  (elem (i32.const 5) (;5;) $fun_makeCounters/anonymous$14)
  (elem (i32.const 6) (;6;) $fun_makeCounters/anonymous$18)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    ;; Load expression to be applied as a function
    global.get $fun_makeCounters*ptr ;; get global var: fun_makeCounters*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $fun_makeCounters*ptr ;; get global var: fun_makeCounters*ptr
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    global.set $var_c1 ;; set local var, have been hoisted
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=0 ;; load field: f1
    ;; End of field select
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=0 ;; load field: f1
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    i32.const 0 ;; push 0 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=4 ;; load field: f2
    ;; End of field select
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=4 ;; load field: f2
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    i32.const 0 ;; push 0 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=8 ;; load field: f3
    ;; End of field select
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=8 ;; load field: f3
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    i32.const 0 ;; push 0 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=12 ;; load field: f4
    ;; End of field select
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=12 ;; load field: f4
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    i32.const 0 ;; push 0 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=16 ;; load field: f5
    ;; End of field select
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=16 ;; load field: f5
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    i32.const 1 ;; push 1 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=0 ;; load field: f1
    ;; End of field select
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=0 ;; load field: f1
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    i32.const 1 ;; push 1 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=4 ;; load field: f2
    ;; End of field select
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=4 ;; load field: f2
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
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
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=8 ;; load field: f3
    ;; End of field select
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=8 ;; load field: f3
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
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
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=12 ;; load field: f4
    ;; End of field select
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=12 ;; load field: f4
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
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
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=16 ;; load field: f5
    ;; End of field select
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=16 ;; load field: f5
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    i32.const 2 ;; push 2 on stack
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
  (func $fun_checkOption (;1;) (param $cenv i32) (param $arg_o i32) (result i32) 
    ;; local variables declarations:
    (local $match_var__ i32)
    (local $match_var_x i32)

    (block $match_end (result i32)
      ;; case for id: $1, label: Some
      local.get $arg_o ;; get local var: arg_o
      i32.load ;; load label
      i32.const 1 ;; put label id 1 on stack
      i32.eq ;; check if index is equal to target
      (if 
        (then
          local.get $arg_o ;; get local var: arg_o
          i32.load offset=4 ;; load data pointer
          local.set $match_var_x ;; set local var
          local.get $match_var_x ;; get local var: match_var_x
          ;; Start of field select
          local.get 0 ;; get env pointer
          i32.load offset=0 ;; load value at offset: 0
          i32.load offset=0 ;; load field: value
          ;; End of field select
          i32.mul
          br $match_end ;; break out of match
        )
      )
      ;; case for id: $2, label: None
      local.get $arg_o ;; get local var: arg_o
      i32.load ;; load label
      i32.const 2 ;; put label id 2 on stack
      i32.eq ;; check if index is equal to target
      (if 
        (then
          local.get $arg_o ;; get local var: arg_o
          i32.load offset=4 ;; load data pointer
          local.set $match_var__ ;; set local var
          local.get 0 ;; get env pointer
          i32.load offset=0 ;; load value at offset: 0
          ;; Start of field select
          local.get 0 ;; get env pointer
          i32.load offset=0 ;; load value at offset: 0
          i32.load offset=0 ;; load field: value
          ;; End of field select
          i32.const 1 ;; push 1 on stack
          i32.add
          i32.store offset=0 ;; store int in struct
          local.get 0 ;; get env pointer
          i32.load offset=0 ;; load value at offset: 0
          i32.load offset=0 ;; load int from struct
          br $match_end ;; break out of match
        )
      )
      ;; no case was matched, therefore return exit error code
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    )
  )
  (func $fun_makeCounters (;2;) (param $cenv i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr i32)
    (local $Sptr$0 i32)
    (local $Sptr$1 i32)
    (local $Sptr$12 i32)
    (local $Sptr$13 i32)
    (local $Sptr$16 i32)
    (local $Sptr$17 i32)
    (local $Sptr$2 i32)
    (local $Sptr$20 i32)
    (local $Sptr$21 i32)
    (local $Sptr$4 i32)
    (local $Sptr$5 i32)
    (local $Sptr$8 i32)
    (local $Sptr$9 i32)
    (local $var_i i32)

    ;; Start of let
    ;; start of struct contructor
    i32.const 4 ;; size of struct
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
    local.set $var_i ;; set local var
    ;; start of struct contructor
    i32.const 8 ;; size of struct
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
    i32.const 4 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$0 ;; set struct pointer var
    local.get $Sptr$0 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field i
    local.get $var_i ;; get local var: var_i
    i32.store ;; store int field in memory
    local.get $Sptr$0 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$1 ;; get pointer to return struct
    global.set $fun_checkOption*ptr
    ;; start of struct contructor
    i32.const 20 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$2 ;; set struct pointer var
    local.get $Sptr$2 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f1
    ;; start of struct contructor
    i32.const 8 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$5 ;; set struct pointer var
    local.get $Sptr$5 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 2 ;; push 2 on stack
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
    i32.const 8 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$4 ;; set struct pointer var
    local.get $Sptr$4 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field checkOption
    global.get $fun_checkOption*ptr ;; get global var: fun_checkOption*ptr
    i32.store ;; store int field in memory
    local.get $Sptr$4 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field i
    local.get $var_i ;; get local var: var_i
    i32.store ;; store int field in memory
    local.get $Sptr$4 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$5 ;; get pointer to return struct
    i32.store ;; store int field in memory
    local.get $Sptr$2 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f2
    ;; start of struct contructor
    i32.const 8 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$9 ;; set struct pointer var
    local.get $Sptr$9 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 3 ;; push 3 on stack
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
    i32.const 8 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$8 ;; set struct pointer var
    local.get $Sptr$8 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field checkOption
    global.get $fun_checkOption*ptr ;; get global var: fun_checkOption*ptr
    i32.store ;; store int field in memory
    local.get $Sptr$8 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field i
    local.get $var_i ;; get local var: var_i
    i32.store ;; store int field in memory
    local.get $Sptr$8 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$9 ;; get pointer to return struct
    i32.store ;; store int field in memory
    local.get $Sptr$2 ;; get struct pointer var
    i32.const 8 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f3
    ;; start of struct contructor
    i32.const 8 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$13 ;; set struct pointer var
    local.get $Sptr$13 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 4 ;; push 4 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$13 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$13 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 8 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$12 ;; set struct pointer var
    local.get $Sptr$12 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field checkOption
    global.get $fun_checkOption*ptr ;; get global var: fun_checkOption*ptr
    i32.store ;; store int field in memory
    local.get $Sptr$12 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field i
    local.get $var_i ;; get local var: var_i
    i32.store ;; store int field in memory
    local.get $Sptr$12 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$13 ;; get pointer to return struct
    i32.store ;; store int field in memory
    local.get $Sptr$2 ;; get struct pointer var
    i32.const 12 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f4
    ;; start of struct contructor
    i32.const 8 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$17 ;; set struct pointer var
    local.get $Sptr$17 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 5 ;; push 5 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$17 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$17 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 8 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$16 ;; set struct pointer var
    local.get $Sptr$16 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field checkOption
    global.get $fun_checkOption*ptr ;; get global var: fun_checkOption*ptr
    i32.store ;; store int field in memory
    local.get $Sptr$16 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field i
    local.get $var_i ;; get local var: var_i
    i32.store ;; store int field in memory
    local.get $Sptr$16 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$17 ;; get pointer to return struct
    i32.store ;; store int field in memory
    local.get $Sptr$2 ;; get struct pointer var
    i32.const 16 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f5
    ;; start of struct contructor
    i32.const 8 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$21 ;; set struct pointer var
    local.get $Sptr$21 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 6 ;; push 6 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$21 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$21 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 4 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$20 ;; set struct pointer var
    local.get $Sptr$20 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field checkOption
    global.get $fun_checkOption*ptr ;; get global var: fun_checkOption*ptr
    i32.store ;; store int field in memory
    local.get $Sptr$20 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$21 ;; get pointer to return struct
    i32.store ;; store int field in memory
    local.get $Sptr$2 ;; push struct address to stack
    ;; end of struct contructor
    ;; End of let
  )
  (func $fun_makeCounters/anonymous (;3;) (param $cenv i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr$3 i32)

    ;; Load expression to be applied as a function
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of union contructor
    ;; start of struct contructor
    i32.const 8 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$3 ;; set struct pointer var
    local.get $Sptr$3 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field id
    i32.const 1 ;; push 1 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$3 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    ;; Start of field select
    local.get 0 ;; get env pointer
    i32.load offset=4 ;; load value at offset: 4
    i32.load offset=0 ;; load field: value
    ;; End of field select
    i32.store ;; store int field in memory
    local.get $Sptr$3 ;; push struct address to stack
    ;; end of struct contructor
    ;; End of union contructor
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
  )
  (func $fun_makeCounters/anonymous$10 (;4;) (param $cenv i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr$11 i32)

    ;; Load expression to be applied as a function
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of union contructor
    ;; start of struct contructor
    i32.const 8 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$11 ;; set struct pointer var
    local.get $Sptr$11 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field id
    i32.const 1 ;; push 1 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$11 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    ;; Start of field select
    local.get 0 ;; get env pointer
    i32.load offset=4 ;; load value at offset: 4
    i32.load offset=0 ;; load field: value
    ;; End of field select
    i32.const 4 ;; push 4 on stack
    i32.add
    i32.store ;; store int field in memory
    local.get $Sptr$11 ;; push struct address to stack
    ;; end of struct contructor
    ;; End of union contructor
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
  )
  (func $fun_makeCounters/anonymous$14 (;5;) (param $cenv i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr$15 i32)

    ;; Load expression to be applied as a function
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of union contructor
    ;; start of struct contructor
    i32.const 8 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$15 ;; set struct pointer var
    local.get $Sptr$15 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field id
    i32.const 1 ;; push 1 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$15 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    ;; Start of field select
    local.get 0 ;; get env pointer
    i32.load offset=4 ;; load value at offset: 4
    i32.load offset=0 ;; load field: value
    ;; End of field select
    i32.const 8 ;; push 8 on stack
    i32.add
    i32.store ;; store int field in memory
    local.get $Sptr$15 ;; push struct address to stack
    ;; end of struct contructor
    ;; End of union contructor
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
  )
  (func $fun_makeCounters/anonymous$18 (;6;) (param $cenv i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr$19 i32)

    ;; Load expression to be applied as a function
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of union contructor
    ;; start of struct contructor
    i32.const 8 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$19 ;; set struct pointer var
    local.get $Sptr$19 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field id
    i32.const 2 ;; push 2 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$19 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$19 ;; push struct address to stack
    ;; end of struct contructor
    ;; End of union contructor
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
  )
  (func $fun_makeCounters/anonymous$6 (;7;) (param $cenv i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr$7 i32)

    ;; Load expression to be applied as a function
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of union contructor
    ;; start of struct contructor
    i32.const 8 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$7 ;; set struct pointer var
    local.get $Sptr$7 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field id
    i32.const 1 ;; push 1 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$7 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    ;; Start of field select
    local.get 0 ;; get env pointer
    i32.load offset=4 ;; load value at offset: 4
    i32.load offset=0 ;; load field: value
    ;; End of field select
    i32.const 2 ;; push 2 on stack
    i32.add
    i32.store ;; store int field in memory
    local.get $Sptr$7 ;; push struct address to stack
    ;; end of struct contructor
    ;; End of union contructor
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (data (i32.const 8) "\02")
  (data (i32.const 12) "\03")
  (data (i32.const 16) "\04")
  (data (i32.const 20) "\05")
  (data (i32.const 24) "\06")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)