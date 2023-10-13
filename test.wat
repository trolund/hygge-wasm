(module
  (type $i32_i32_=> (func (param i32) (param i32) ))
  (type $i32_i32_=>_f32 (func (param i32) (param i32) (result f32)))
  (import "env" "malloc" (func $malloc (param i32) (result i32)
))
  (import "env" "writeInt" (func $writeInt (param i32) 
))
  (import "env" "writeS" (func $writeS (param i32) (param i32) 
))
  (memory (export "memory") 1)
  (data (i32.const 0) "\00")
  (data (i32.const 12) "None")
  (data (i32.const 20) "\01")
  (global $Sptr (mut i32) i32.const 0)
  (global $Sptr$0 (mut i32) i32.const 0)
  (global $Sptr$2 (mut i32) i32.const 0)
  (global $Sptr$3 (mut i32) i32.const 0)
  (global $Sptr$4 (mut i32) i32.const 0)
  (global $Sptr$5 (mut i32) i32.const 0)
  (global $Sptr$6 (mut i32) i32.const 0)
  (global $Sptr$7 (mut i32) i32.const 0)
  (global $fun_area*ptr (mut i32) i32.const 20)
  (global $fun_displayOption*ptr (mut i32) i32.const 0)
  (global $heap_base i32 i32.const 24)
  (table $func_table 2 funcref)
  (elem (i32.const 0) $fun_displayOption)
  (elem (i32.const 1) $fun_area)
  (func $_start  (result i32) ;; entry point of program (main function)
 
    ;; execution start here:
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_displayOption*ptr ;; get global var: fun_displayOption*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
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
    global.get $fun_displayOption*ptr ;; get global var: fun_displayOption*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>) ;; call function
    ;; end of application
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_displayOption*ptr ;; get global var: fun_displayOption*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    ;; Start of union contructor
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr$0 ;; set struct pointer var, have been hoisted
    global.get $Sptr$0 ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field id
    i32.const 2 ;; push 2 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$0 ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$0 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    ;; End of union contructor
    global.get $fun_displayOption*ptr ;; get global var: fun_displayOption*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>) ;; call function
    ;; end of application
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_area*ptr ;; get global var: fun_area*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
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
    i32.const 3 ;; push 3 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$2 ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    ;; start of struct contructor
    i32.const 1 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr$3 ;; set struct pointer var, have been hoisted
    global.get $Sptr$3 ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field radius
    f32.const 2.000000
    f32.store ;; store float field (radius) in memory
    global.get $Sptr$3 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    i32.store ;; store int field in memory
    global.get $Sptr$2 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    ;; End of union contructor
    global.get $fun_area*ptr ;; get global var: fun_area*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_f32) ;; call function
    ;; end of application
    f32.const 12.560000
    f32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_area*ptr ;; get global var: fun_area*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    ;; Start of union contructor
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr$4 ;; set struct pointer var, have been hoisted
    global.get $Sptr$4 ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field id
    i32.const 4 ;; push 4 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$4 ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr$5 ;; set struct pointer var, have been hoisted
    global.get $Sptr$5 ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field width
    f32.const 2.000000
    f32.store ;; store float field (width) in memory
    global.get $Sptr$5 ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field height
    f32.const 3.000000
    f32.store ;; store float field (height) in memory
    global.get $Sptr$5 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    i32.store ;; store int field in memory
    global.get $Sptr$4 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    ;; End of union contructor
    global.get $fun_area*ptr ;; get global var: fun_area*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_f32) ;; call function
    ;; end of application
    f32.const 6.000000
    f32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_area*ptr ;; get global var: fun_area*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    ;; Start of union contructor
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr$6 ;; set struct pointer var, have been hoisted
    global.get $Sptr$6 ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field id
    i32.const 5 ;; push 5 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$6 ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    ;; start of struct contructor
    i32.const 1 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr$7 ;; set struct pointer var, have been hoisted
    global.get $Sptr$7 ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field side
    f32.const 5.000000
    f32.store ;; store float field (side) in memory
    global.get $Sptr$7 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    i32.store ;; store int field in memory
    global.get $Sptr$6 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    ;; End of union contructor
    global.get $fun_area*ptr ;; get global var: fun_area*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_f32) ;; call function
    ;; end of application
    f32.const 25.000000
    f32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      )
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_area (param $cenv i32) (param $arg_s i32) (result f32) ;; function fun_area
    ;; local variables declarations:
    (local $c i32)
    (local $match_var_c i32)
    (local $match_var_r i32)
    (local $match_var_s i32)
    (local $r i32)
    (local $s i32)
 
    (block $match_end$1  (result i32)
      ;; case for id: $3, label: Circle
      local.get $arg_s ;; get local var: arg_s
      i32.load ;; load label
      i32.const 3 ;; put label id 3 on stack
      i32.eq ;; check if index is equal to target
      (if (then
      local.get $arg_s ;; get local var: arg_s
      i32.const 4 ;; offset of data field
      i32.add ;; add offset to base address
      i32.load ;; load data pointer
      local.set $match_var_c ;; set local var
      ;; Start of field select
      local.get $match_var_c ;; get local var: match_var_c
      f32.load offset=0 ;; load field: radius
      ;; End of field select
      ;; Start of field select
      local.get $match_var_c ;; get local var: match_var_c
      f32.load offset=0 ;; load field: radius
      ;; End of field select
      f32.mul
      f32.const 3.140000
      f32.mul
      br $match_end$1 ;; break out of match
       )
      )
      ;; case for id: $4, label: Rectangle
      local.get $arg_s ;; get local var: arg_s
      i32.load ;; load label
      i32.const 4 ;; put label id 4 on stack
      i32.eq ;; check if index is equal to target
      (if (then
      local.get $arg_s ;; get local var: arg_s
      i32.const 4 ;; offset of data field
      i32.add ;; add offset to base address
      i32.load ;; load data pointer
      local.set $match_var_r ;; set local var
      ;; Start of field select
      local.get $match_var_r ;; get local var: match_var_r
      f32.load offset=0 ;; load field: width
      ;; End of field select
      ;; Start of field select
      local.get $match_var_r ;; get local var: match_var_r
      f32.load offset=4 ;; load field: height
      ;; End of field select
      f32.mul
      br $match_end$1 ;; break out of match
       )
      )
      ;; case for id: $5, label: Square
      local.get $arg_s ;; get local var: arg_s
      i32.load ;; load label
      i32.const 5 ;; put label id 5 on stack
      i32.eq ;; check if index is equal to target
      (if (then
      local.get $arg_s ;; get local var: arg_s
      i32.const 4 ;; offset of data field
      i32.add ;; add offset to base address
      i32.load ;; load data pointer
      local.set $match_var_s ;; set local var
      ;; Start of field select
      local.get $match_var_s ;; get local var: match_var_s
      f32.load offset=0 ;; load field: side
      ;; End of field select
      ;; Start of field select
      local.get $match_var_s ;; get local var: match_var_s
      f32.load offset=0 ;; load field: side
      ;; End of field select
      f32.mul
      br $match_end$1 ;; break out of match
       )
      )
      ;; no case was matched, therefore return exit error code
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

    )
  )
  (func $fun_displayOption (param $cenv i32) (param $arg_o i32)  ;; function fun_displayOption
    ;; local variables declarations:
    (local $_ i32)
    (local $match_var__ i32)
    (local $match_var_x i32)
    (local $x i32)
 
    (block $match_end 
      ;; case for id: $1, label: Some
      local.get $arg_o ;; get local var: arg_o
      i32.load ;; load label
      i32.const 1 ;; put label id 1 on stack
      i32.eq ;; check if index is equal to target
      (if (then
      local.get $arg_o ;; get local var: arg_o
      i32.const 4 ;; offset of data field
      i32.add ;; add offset to base address
      i32.load ;; load data pointer
      local.set $match_var_x ;; set local var
      local.get $match_var_x ;; get local var: match_var_x
      call $writeInt ;; call host function
      br $match_end ;; break out of match
       )
      )
      ;; case for id: $2, label: None
      local.get $arg_o ;; get local var: arg_o
      i32.load ;; load label
      i32.const 2 ;; put label id 2 on stack
      i32.eq ;; check if index is equal to target
      (if (then
      local.get $arg_o ;; get local var: arg_o
      i32.const 4 ;; offset of data field
      i32.add ;; add offset to base address
      i32.load ;; load data pointer
      local.set $match_var__ ;; set local var
      i32.const 4 ;; offset in memory
      i32.const 12 ;; data pointer to store
      i32.store ;; store size in bytes
      i32.const 8 ;; offset in memory
      i32.const 8 ;; length to store
      i32.store ;; store data pointer
      i32.const 4 ;; leave pointer to string on stack
      i32.load ;; Load string pointer
      i32.const 4 ;; offset in memory
      i32.const 12 ;; data pointer to store
      i32.store ;; store size in bytes
      i32.const 8 ;; offset in memory
      i32.const 8 ;; length to store
      i32.store ;; store data pointer
      i32.const 4 ;; leave pointer to string on stack
      i32.const 4 ;; length offset
      i32.add ;; add offset to pointer
      i32.load ;; Load string length
      call $writeS ;; call host function
      br $match_end ;; break out of match
       )
      )
      ;; no case was matched, therefore return exit error code
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

    )
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)