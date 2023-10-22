(module
  (type $i32_i32_=>_f32 (;0;) (func (param i32) (param i32) (result f32)))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $Sptr (;0;) (mut i32) i32.const 0)
  (global $Sptr$0 (;1;) (mut i32) i32.const 0)
  (global $Sptr$1 (;2;) (mut i32) i32.const 0)
  (global $Sptr$4 (;3;) (mut i32) i32.const 0)
  (global $exit_code (;4;) (mut i32) i32.const 0)
  (global $fun_toString*ptr (;5;) (mut i32) i32.const 66)
  (global $heap_base (;6;) i32 i32.const 70)
  (global $var_c (;7;) (mut i32) i32.const 0)
  (global $var_r (;8;) (mut i32) i32.const 0)
  (global $var_s (;9;) (mut i32) i32.const 0)
  (table $func_table (;0;) 1 funcref)
  (elem (i32.const 0) (;0;) $fun_toString)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    ;; start of struct contructor
    i32.const 3 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr ;; set struct pointer var, have been hoisted
    global.get $Sptr ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field name
    i32.const 0 ;; leave pointer to string on stack
    i32.store ;; store int field in memory
    global.get $Sptr ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field area
    f32.const 10.000000
    f32.const 10.000000
    f32.mul
    f32.const 3.140000
    f32.mul
    f32.store ;; store float field (area) in memory
    global.get $Sptr ;; get struct pointer var, have been hoisted
    i32.const 8 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field radius
    f32.const 10.000000
    f32.store ;; store float field (radius) in memory
    global.get $Sptr ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    global.set $var_c ;; set local var, have been hoisted
    ;; Start of let
    ;; start of struct contructor
    i32.const 3 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr$0 ;; set struct pointer var, have been hoisted
    global.get $Sptr$0 ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field name
    i32.const 20 ;; leave pointer to string on stack
    i32.store ;; store int field in memory
    global.get $Sptr$0 ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field area
    f32.const 2.000000
    f32.const 2.000000
    f32.mul
    f32.store ;; store float field (area) in memory
    global.get $Sptr$0 ;; get struct pointer var, have been hoisted
    i32.const 8 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field side
    f32.const 2.000000
    f32.store ;; store float field (side) in memory
    global.get $Sptr$0 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    global.set $var_s ;; set local var, have been hoisted
    ;; Start of let
    ;; start of struct contructor
    i32.const 4 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    global.set $Sptr$1 ;; set struct pointer var, have been hoisted
    global.get $Sptr$1 ;; get struct pointer var, have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field name
    i32.const 40 ;; leave pointer to string on stack
    i32.store ;; store int field in memory
    global.get $Sptr$1 ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field area
    f32.const 3.000000
    f32.const 4.000000
    f32.mul
    f32.store ;; store float field (area) in memory
    global.get $Sptr$1 ;; get struct pointer var, have been hoisted
    i32.const 8 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field width
    f32.const 3.000000
    f32.store ;; store float field (width) in memory
    global.get $Sptr$1 ;; get struct pointer var, have been hoisted
    i32.const 12 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field height
    f32.const 4.000000
    f32.store ;; store float field (height) in memory
    global.get $Sptr$1 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    global.set $var_r ;; set local var, have been hoisted
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_toString*ptr ;; get global var: fun_toString*ptr
    i32.load offset=4 ;; load closure environment pointer
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
    i32.const 1 ;; push 1 on stack
    i32.store ;; store int field in memory
    global.get $Sptr$4 ;; get struct pointer var, have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    global.get $var_c ;; get local var: var_c, have been hoisted
    i32.store ;; store int field in memory
    global.get $Sptr$4 ;; push struct address to stack, have been hoisted
    ;; end of struct contructor
    ;; End of union contructor
    global.get $fun_toString*ptr ;; get global var: fun_toString*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_f32) ;; call function
    ;; end of application
    f32.const 10.000000
    f32.const 10.000000
    f32.mul
    f32.const 3.140000
    f32.mul
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
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_toString (;1;) (param $cenv i32) (param $arg_o i32) (result f32) 
    ;; local variables declarations:
    (local $match_var__ i32)
    (local $match_var_s i32)
    (local $match_var_s$2 i32)
    (local $match_var_s$3 i32)

    (block $match_end (result f32)
      ;; case for id: $1, label: Shape
      local.get $arg_o ;; get local var: arg_o
      i32.load ;; load label
      i32.const 1 ;; put label id 1 on stack
      i32.eq ;; check if index is equal to target
      (if 
        (then
          local.get $arg_o ;; get local var: arg_o
          i32.load offset=4 ;; load data pointer
          local.set $match_var_s ;; set local var
          ;; Start of field select
          local.get $match_var_s ;; get local var: match_var_s
          f32.load offset=4 ;; load field: area
          ;; End of field select
          br $match_end ;; break out of match
        )
      )
      ;; case for id: $2, label: Circle
      local.get $arg_o ;; get local var: arg_o
      i32.load ;; load label
      i32.const 2 ;; put label id 2 on stack
      i32.eq ;; check if index is equal to target
      (if 
        (then
          local.get $arg_o ;; get local var: arg_o
          i32.load offset=4 ;; load data pointer
          local.set $match_var_s$2 ;; set local var
          ;; Start of field select
          local.get $match_var_s$2 ;; get local var: match_var_s$2
          f32.load offset=8 ;; load field: radius
          ;; End of field select
          br $match_end ;; break out of match
        )
      )
      ;; case for id: $3, label: Square
      local.get $arg_o ;; get local var: arg_o
      i32.load ;; load label
      i32.const 3 ;; put label id 3 on stack
      i32.eq ;; check if index is equal to target
      (if 
        (then
          local.get $arg_o ;; get local var: arg_o
          i32.load offset=4 ;; load data pointer
          local.set $match_var_s$3 ;; set local var
          ;; Start of field select
          local.get $match_var_s$3 ;; get local var: match_var_s$3
          f32.load offset=8 ;; load field: side
          ;; End of field select
          br $match_end ;; break out of match
        )
      )
      ;; case for id: $4, label: None
      local.get $arg_o ;; get local var: arg_o
      i32.load ;; load label
      i32.const 4 ;; put label id 4 on stack
      i32.eq ;; check if index is equal to target
      (if 
        (then
          local.get $arg_o ;; get local var: arg_o
          i32.load offset=4 ;; load data pointer
          local.set $match_var__ ;; set local var
          f32.const 0.000000
          br $match_end ;; break out of match
        )
      )
      ;; no case was matched, therefore return exit error code
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    )
  )
  (data (i32.const 0) "\08\00\00\00\0c\00\00\00")
  (data (i32.const 8) "Circle")
  (data (i32.const 20) "\1c\00\00\00\0c\00\00\00")
  (data (i32.const 28) "Square")
  (data (i32.const 40) "\30\00\00\00\12\00\00\00")
  (data (i32.const 48) "Rectangle")
  (data (i32.const 66) "\00")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)