(module
  (type $i32_i32_=> (func (param i32) (param i32) ))
  (import "env" "malloc" (func $malloc (param i32) (result i32)
))
  (import "env" "writeFloat" (func $writeFloat (param f32) 
))
  (import "env" "writeS" (func $writeS (param i32) (param i32) 
))
  (memory (export "memory") 1)
  (data (i32.const 0) "\00")
  (data (i32.const 12) "Name: ")
  (data (i32.const 32) "; area: ")
  (data (i32.const 56) "Circle")
  (data (i32.const 76) "Square")
  (data (i32.const 96) "Rectangle")
  (global $Sptr (mut i32) i32.const 0)
  (global $Sptr$0 (mut i32) i32.const 0)
  (global $Sptr$1 (mut i32) i32.const 0)
  (global $fun_displayShape*ptr (mut i32) i32.const 0)
  (global $heap_base i32 i32.const 114)
  (global $var_c (mut i32) i32.const 0)
  (global $var_r (mut i32) i32.const 0)
  (global $var_s (mut i32) i32.const 0)
  (table $func_table 1 funcref)
  (elem (i32.const 0) $fun_displayShape)
  (func $_start  (result i32) ;; entry point of program (main function)
 
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
    i32.const 48 ;; offset in memory
    i32.const 56 ;; data pointer to store
    i32.store ;; store size in bytes
    i32.const 52 ;; offset in memory
    i32.const 12 ;; length to store
    i32.store ;; store data pointer
    i32.const 48 ;; leave pointer to string on stack
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
    i32.const 68 ;; offset in memory
    i32.const 76 ;; data pointer to store
    i32.store ;; store size in bytes
    i32.const 72 ;; offset in memory
    i32.const 12 ;; length to store
    i32.store ;; store data pointer
    i32.const 68 ;; leave pointer to string on stack
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
    i32.const 88 ;; offset in memory
    i32.const 96 ;; data pointer to store
    i32.store ;; store size in bytes
    i32.const 92 ;; offset in memory
    i32.const 18 ;; length to store
    i32.store ;; store data pointer
    i32.const 88 ;; leave pointer to string on stack
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
    global.get $fun_displayShape*ptr ;; get global var: fun_displayShape*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    global.get $var_c ;; get local var: var_c, have been hoisted
    global.get $fun_displayShape*ptr ;; get global var: fun_displayShape*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>) ;; call function
    ;; end of application
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_displayShape*ptr ;; get global var: fun_displayShape*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    global.get $var_s ;; get local var: var_s, have been hoisted
    global.get $fun_displayShape*ptr ;; get global var: fun_displayShape*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>) ;; call function
    ;; end of application
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_displayShape*ptr ;; get global var: fun_displayShape*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    global.get $var_r ;; get local var: var_r, have been hoisted
    global.get $fun_displayShape*ptr ;; get global var: fun_displayShape*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>) ;; call function
    ;; end of application
    global.get $var_c ;; get local var: var_c, have been hoisted
    global.get $var_s ;; get local var: var_s, have been hoisted
    global.get $var_r ;; get local var: var_r, have been hoisted
    f32.const 0.000000
    f32.store offset=4 ;; store float in struct
    global.get $var_r ;; get local var: var_r, have been hoisted
    f32.load offset=4 ;; load float from struct
    f32.store offset=4 ;; store float in struct
    global.get $var_s ;; get local var: var_s, have been hoisted
    f32.load offset=4 ;; load float from struct
    f32.store offset=4 ;; store float in struct
    global.get $var_c ;; get local var: var_c, have been hoisted
    f32.load offset=4 ;; load float from struct
    ;; Start of field select
    global.get $var_c ;; get local var: var_c, have been hoisted
    f32.load offset=4 ;; load field: area
    ;; End of field select
    ;; Start of field select
    global.get $var_s ;; get local var: var_s, have been hoisted
    f32.load offset=4 ;; load field: area
    ;; End of field select
    f32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      )
    ;; Start of field select
    global.get $var_s ;; get local var: var_s, have been hoisted
    f32.load offset=4 ;; load field: area
    ;; End of field select
    ;; Start of field select
    global.get $var_r ;; get local var: var_r, have been hoisted
    f32.load offset=4 ;; load field: area
    ;; End of field select
    f32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      )
    ;; Start of field select
    global.get $var_r ;; get local var: var_r, have been hoisted
    f32.load offset=4 ;; load field: area
    ;; End of field select
    f32.const 0.000000
    f32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      )
    ;; End of let
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_displayShape (param $cenv i32) (param $shape i32)  ;; function fun_displayShape
 
    i32.const 4 ;; offset in memory
    i32.const 12 ;; data pointer to store
    i32.store ;; store size in bytes
    i32.const 8 ;; offset in memory
    i32.const 12 ;; length to store
    i32.store ;; store data pointer
    i32.const 4 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 4 ;; offset in memory
    i32.const 12 ;; data pointer to store
    i32.store ;; store size in bytes
    i32.const 8 ;; offset in memory
    i32.const 12 ;; length to store
    i32.store ;; store data pointer
    i32.const 4 ;; leave pointer to string on stack
    i32.const 4 ;; length offset
    i32.add ;; add offset to pointer
    i32.load ;; Load string length
    call $writeS ;; call host function
    ;; Start of field select
    local.get $shape ;; get local var: shape
    i32.load offset=0 ;; load field: name
    ;; End of field select
    i32.load ;; Load string pointer
    ;; Start of field select
    local.get $shape ;; get local var: shape
    i32.load offset=0 ;; load field: name
    ;; End of field select
    i32.const 4 ;; length offset
    i32.add ;; add offset to pointer
    i32.load ;; Load string length
    call $writeS ;; call host function
    i32.const 24 ;; offset in memory
    i32.const 32 ;; data pointer to store
    i32.store ;; store size in bytes
    i32.const 28 ;; offset in memory
    i32.const 16 ;; length to store
    i32.store ;; store data pointer
    i32.const 24 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 24 ;; offset in memory
    i32.const 32 ;; data pointer to store
    i32.store ;; store size in bytes
    i32.const 28 ;; offset in memory
    i32.const 16 ;; length to store
    i32.store ;; store data pointer
    i32.const 24 ;; leave pointer to string on stack
    i32.const 4 ;; length offset
    i32.add ;; add offset to pointer
    i32.load ;; Load string length
    call $writeS ;; call host function
    ;; Start of field select
    local.get $shape ;; get local var: shape
    f32.load offset=4 ;; load field: area
    ;; End of field select
    call $writeFloat ;; call host function
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)