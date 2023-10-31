(module
  (type $i32_i32_=>_i32 (;0;) (func (param i32) (param i32) (result i32)))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $Sptr (;0;) (mut i32) i32.const 0)
  (global $Sptr$1 (;1;) (mut i32) i32.const 0)
  (global $Sptr$2 (;2;) (mut i32) i32.const 0)
  (global $Sptr$3 (;3;) (mut i32) i32.const 0)
  (global $exit_code (;4;) (mut i32) i32.const 0)
  (global $fun_f*ptr (;5;) (mut i32) i32.const 0)
  (global $fun_matcher*ptr (;6;) (mut i32) i32.const 4)
  (global $heap_base (;7;) i32 i32.const 38)
  (global $var_x (;8;) (mut i32) i32.const 0)
  (global $var_y (;9;) (mut i32) i32.const 0)
  (table $func_table (;0;) 2 funcref)
  (elem (i32.const 0) (;0;) $fun_f)
  (elem (i32.const 1) (;1;) $fun_matcher)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    ;; Start of union contructor
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr ;; set struct pointer var, have been hoisted
    global.get $Sptr ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field id
    i32.const 1 ;; push 1 on stack
    i32.store ;; store int field in memory
    global.get $Sptr ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    i32.const 42 ;; push 42 on stack
    i32.store ;; store int field in memory
    global.get $Sptr ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    ;; End of union contructor
    global.set $var_x ;; set local var, have been hoisted
    ;; Start of let
    ;; Start of union contructor
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr$1 ;; set struct pointer var, have been hoisted
    global.get $Sptr$1 ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field id
    i32.const 2 ;; push 2 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$1 ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    i32.const 8 ;; leave pointer to string on stack
    i32.store ;; store int field in memory
    global.get $Sptr$1 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    ;; End of union contructor
    global.set $var_y ;; set local var, have been hoisted
    ;; Load expression to be applied as a function
    global.get $fun_matcher*ptr ;; get global var: fun_matcher*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_x ;; get local var: var_x, have been hoisted
    global.get $fun_matcher*ptr ;; get global var: fun_matcher*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    i32.const 144 ;; push 144 on stack
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
    global.get $fun_matcher*ptr ;; get global var: fun_matcher*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_y ;; get local var: var_y, have been hoisted
    global.get $fun_matcher*ptr ;; get global var: fun_matcher*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
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
    ;; Load expression to be applied as a function
    global.get $fun_matcher*ptr ;; get global var: fun_matcher*ptr
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of union contructor
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr$2 ;; set struct pointer var, have been hoisted
    global.get $Sptr$2 ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field id
    i32.const 1 ;; push 1 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$2 ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    i32.const 100 ;; push 100 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$2 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    ;; End of union contructor
    global.get $fun_matcher*ptr ;; get global var: fun_matcher*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    i32.const 202 ;; push 202 on stack
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
    global.get $fun_matcher*ptr ;; get global var: fun_matcher*ptr
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of union contructor
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr$3 ;; set struct pointer var, have been hoisted
    global.get $Sptr$3 ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field id
    i32.const 2 ;; push 2 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$3 ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    i32.const 26 ;; leave pointer to string on stack
    i32.store ;; store int field in memory
    global.get $Sptr$3 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    ;; End of union contructor
    global.get $fun_matcher*ptr ;; get global var: fun_matcher*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
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
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_f (;1;) (param $cenv i32) (param $arg_x i32) (result i32) 
    local.get $arg_x ;; get local var: arg_x
    i32.const 1 ;; push 1 on stack
    i32.add
  )
  (func $fun_matcher (;2;) (param $cenv i32) (param $arg_x$0 i32) (result i32) 
    ;; local variables declarations:
    (local $match_var_x i32)
    (local $match_var_z i32)
    (local $var_z i32)

    (block $match_end (result i32)
      ;; case for id: $1, label: foo
      local.get $arg_x$0 ;; get local var: arg_x$0
      i32.load ;; load label
      i32.const 1 ;; put label id 1 on stack
      i32.eq ;; check if index is equal to target
      (if 
        (then
          local.get $arg_x$0 ;; get local var: arg_x$0
          i32.load offset=4 ;; load data pointer
          local.set $match_var_x ;; set local var
          ;; Start of let
          i32.const 100 ;; push 100 on stack
          local.set $var_z ;; set local var
          ;; Load expression to be applied as a function
          global.get $fun_f*ptr ;; get global var: fun_f*ptr
          i32.load offset=4 ;; load closure environment pointer
          ;; Load expression to be applied as a function
          global.get $fun_f*ptr ;; get global var: fun_f*ptr
          i32.load offset=4 ;; load closure environment pointer
          local.get $match_var_x ;; get local var: match_var_x
          global.get $fun_f*ptr ;; get global var: fun_f*ptr
          i32.load ;; load table index
          call_indirect (type $i32_i32_=>_i32) ;; call function
          global.get $fun_f*ptr ;; get global var: fun_f*ptr
          i32.load ;; load table index
          call_indirect (type $i32_i32_=>_i32) ;; call function
          local.get $var_z ;; get local var: var_z
          i32.add
          ;; End of let
          br $match_end ;; break out of match
        )
      )
      ;; case for id: $2, label: bar
      local.get $arg_x$0 ;; get local var: arg_x$0
      i32.load ;; load label
      i32.const 2 ;; put label id 2 on stack
      i32.eq ;; check if index is equal to target
      (if 
        (then
          local.get $arg_x$0 ;; get local var: arg_x$0
          i32.load offset=4 ;; load data pointer
          local.set $match_var_z ;; set local var
          ;; Load expression to be applied as a function
          global.get $fun_f*ptr ;; get global var: fun_f*ptr
          i32.load offset=4 ;; load closure environment pointer
          local.get $match_var_z ;; get local var: match_var_z
          i32.load offset=4 ;; load string length
          i32.const 1 ;; push 1 on stack
          i32.shr_s ;; divide by 2
          global.get $fun_f*ptr ;; get global var: fun_f*ptr
          i32.load ;; load table index
          call_indirect (type $i32_i32_=>_i32) ;; call function
          br $match_end ;; break out of match
        )
      )
      ;; no case was matched, therefore return exit error code
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    )
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (data (i32.const 8) "\10\00\00\00\0a\00\00\00")
  (data (i32.const 16) "Hello")
  (data (i32.const 26) "\22\00\00\00\04\00\00\00")
  (data (i32.const 34) "Hi")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)