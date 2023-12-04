(module
  (type $i32_i32_=>_unit (;0;) (func (param i32) (param i32) ))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (import "env" "writeFloat" (;1;) (func $writeFloat (param f32) (param i32) ))
  (import "env" "writeS" (;2;) (func $writeS (param i32) (param i32) (param i32) ))
  (memory (;0;) (export "memory") 1)
  (global $Sptr (;0;) (mut i32) (i32.const 0))
  (global $Sptr$0 (;1;) (mut i32) (i32.const 0))
  (global $Sptr$1 (;2;) (mut i32) (i32.const 0))
  (global $exit_code (;3;) (mut i32) (i32.const 0))
  (global $fun_displayShape*ptr (;4;) (mut i32) (i32.const 0))
  (global $heap_base (;5;) i32 (i32.const 99))
  (global $var_c (;6;) (mut i32) (i32.const 0))
  (global $var_r (;7;) (mut i32) (i32.const 0))
  (global $var_s (;8;) (mut i32) (i32.const 0))
  (table $func_table (;0;) 1 funcref)
  (elem (i32.const 0) (;0;) $fun_displayShape)
  (func $_start (;0;)   
    ;; execution start here:
    ;; Start of let
    (global.set $var_c ;; set local var, have been hoisted
      ;; start of struct contructor
      (global.set $Sptr ;; set struct pointer var, have been hoisted
        (i32.const 12) ;; size of struct
        (call $malloc) ;; call malloc function
      )
      (i32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (global.get $Sptr) ;; get struct pointer var, have been hoisted
          (i32.const 0) ;; push field offset to stack
        )
        ;; init field (name)
        (i32.const 42) ;; leave pointer to string on stack
      )
      (f32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (global.get $Sptr) ;; get struct pointer var, have been hoisted
          (i32.const 4) ;; push field offset to stack
        )
        ;; init field (area)
        (f32.mul
          (f32.mul
            (f32.const 10.000000) ;; push 10.000000 on stack
            (f32.const 10.000000) ;; push 10.000000 on stack
          )
          (f32.const 3.140000) ;; push 3.140000 on stack
        )
      )
      (f32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (global.get $Sptr) ;; get struct pointer var, have been hoisted
          (i32.const 8) ;; push field offset to stack
        )
        ;; init field (radius)
        (f32.const 10.000000) ;; push 10.000000 on stack
      )
      (global.get $Sptr) ;; push struct address to stack, have been hoisted
      ;; end of struct contructor
    )
    ;; Start of let
    (global.set $var_s ;; set local var, have been hoisted
      ;; start of struct contructor
      (global.set $Sptr$0 ;; set struct pointer var, have been hoisted
        (i32.const 12) ;; size of struct
        (call $malloc) ;; call malloc function
      )
      (i32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (global.get $Sptr$0) ;; get struct pointer var, have been hoisted
          (i32.const 0) ;; push field offset to stack
        )
        ;; init field (name)
        (i32.const 60) ;; leave pointer to string on stack
      )
      (f32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (global.get $Sptr$0) ;; get struct pointer var, have been hoisted
          (i32.const 4) ;; push field offset to stack
        )
        ;; init field (area)
        (f32.mul
          (f32.const 2.000000) ;; push 2.000000 on stack
          (f32.const 2.000000) ;; push 2.000000 on stack
        )
      )
      (f32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (global.get $Sptr$0) ;; get struct pointer var, have been hoisted
          (i32.const 8) ;; push field offset to stack
        )
        ;; init field (side)
        (f32.const 2.000000) ;; push 2.000000 on stack
      )
      (global.get $Sptr$0) ;; push struct address to stack, have been hoisted
      ;; end of struct contructor
    )
    ;; Start of let
    (global.set $var_r ;; set local var, have been hoisted
      ;; start of struct contructor
      (global.set $Sptr$1 ;; set struct pointer var, have been hoisted
        (i32.const 16) ;; size of struct
        (call $malloc) ;; call malloc function
      )
      (i32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (global.get $Sptr$1) ;; get struct pointer var, have been hoisted
          (i32.const 0) ;; push field offset to stack
        )
        ;; init field (name)
        (i32.const 78) ;; leave pointer to string on stack
      )
      (f32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (global.get $Sptr$1) ;; get struct pointer var, have been hoisted
          (i32.const 4) ;; push field offset to stack
        )
        ;; init field (area)
        (f32.mul
          (f32.const 3.000000) ;; push 3.000000 on stack
          (f32.const 4.000000) ;; push 4.000000 on stack
        )
      )
      (f32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (global.get $Sptr$1) ;; get struct pointer var, have been hoisted
          (i32.const 8) ;; push field offset to stack
        )
        ;; init field (width)
        (f32.const 3.000000) ;; push 3.000000 on stack
      )
      (f32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (global.get $Sptr$1) ;; get struct pointer var, have been hoisted
          (i32.const 12) ;; push field offset to stack
        )
        ;; init field (height)
        (f32.const 4.000000) ;; push 4.000000 on stack
      )
      (global.get $Sptr$1) ;; push struct address to stack, have been hoisted
      ;; end of struct contructor
    )
    ;; Load expression to be applied as a function
    (call_indirect (type $i32_i32_=>_unit) ;; call function
      (i32.load offset=4
        (global.get $fun_displayShape*ptr) ;; get global var: fun_displayShape*ptr
      )
      (global.get $var_c) ;; get local var: var_c, have been hoisted
      (i32.load ;; load table index
        (global.get $fun_displayShape*ptr) ;; get global var: fun_displayShape*ptr
      )
    )
    ;; Load expression to be applied as a function
    (call_indirect (type $i32_i32_=>_unit) ;; call function
      (i32.load offset=4
        (global.get $fun_displayShape*ptr) ;; get global var: fun_displayShape*ptr
      )
      (global.get $var_s) ;; get local var: var_s, have been hoisted
      (i32.load ;; load table index
        (global.get $fun_displayShape*ptr) ;; get global var: fun_displayShape*ptr
      )
    )
    ;; Load expression to be applied as a function
    (call_indirect (type $i32_i32_=>_unit) ;; call function
      (i32.load offset=4
        (global.get $fun_displayShape*ptr) ;; get global var: fun_displayShape*ptr
      )
      (global.get $var_r) ;; get local var: var_r, have been hoisted
      (i32.load ;; load table index
        (global.get $fun_displayShape*ptr) ;; get global var: fun_displayShape*ptr
      )
    )
    (drop ;; drop value of subtree
      (f32.load offset=4
        (global.get $var_c) ;; get local var: var_c, have been hoisted
        (f32.store offset=4 ;; store float in struct
          (global.get $var_c) ;; get local var: var_c, have been hoisted
          (f32.load offset=4
            (global.get $var_s) ;; get local var: var_s, have been hoisted
            (f32.store offset=4 ;; store float in struct
              (global.get $var_s) ;; get local var: var_s, have been hoisted
              (f32.load offset=4
                (global.get $var_r) ;; get local var: var_r, have been hoisted
                (f32.store offset=4 ;; store float in struct
                  (global.get $var_r) ;; get local var: var_r, have been hoisted
                  (f32.const 0.000000) ;; push 0.000000 on stack
                )
              )
            )
          )
        )
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (f32.eq ;; equality check
            ;; Start of field select
            (f32.load offset=4
              (global.get $var_c) ;; get local var: var_c, have been hoisted
            )
            ;; End of field select
            ;; Start of field select
            (f32.load offset=4
              (global.get $var_s) ;; get local var: var_s, have been hoisted
            )
            ;; End of field select
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (f32.eq ;; equality check
            ;; Start of field select
            (f32.load offset=4
              (global.get $var_s) ;; get local var: var_s, have been hoisted
            )
            ;; End of field select
            ;; Start of field select
            (f32.load offset=4
              (global.get $var_r) ;; get local var: var_r, have been hoisted
            )
            ;; End of field select
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (f32.eq ;; equality check
            ;; Start of field select
            (f32.load offset=4
              (global.get $var_r) ;; get local var: var_r, have been hoisted
            )
            ;; End of field select
            (f32.const 0.000000) ;; push 0.000000 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    ;; End of let
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (func $fun_displayShape (;1;) (param $cenv i32) (param $arg_shape i32)  
    (i32.load ;; Load string pointer
      (i32.const 4) ;; leave pointer to string on stack
    )
    (i32.load offset=4
      (i32.const 4) ;; leave pointer to string on stack
    )
    (i32.const 0) ;; newline
    (call $writeS) ;; call host function
    (i32.load ;; Load string pointer
      ;; Start of field select
      (i32.load offset=0
        (local.get $arg_shape) ;; get local var: arg_shape
      )
      ;; End of field select
    )
    (i32.load offset=4
      ;; Start of field select
      (i32.load offset=0
        (local.get $arg_shape) ;; get local var: arg_shape
      )
      ;; End of field select
    )
    (i32.const 0) ;; newline
    (call $writeS) ;; call host function
    (i32.load ;; Load string pointer
      (i32.const 22) ;; leave pointer to string on stack
    )
    (i32.load offset=4
      (i32.const 22) ;; leave pointer to string on stack
    )
    (i32.const 0) ;; newline
    (call $writeS) ;; call host function
    ;; Start of field select
    (f32.load offset=4
      (local.get $arg_shape) ;; get local var: arg_shape
    )
    ;; End of field select
    (i32.const 1) ;; newline
    (call $writeFloat) ;; call host function
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\10\00\00\00\06\00\00\00\06\00\00\00")
  (data (i32.const 16) "Name: ")
  (data (i32.const 22) "\22\00\00\00\08\00\00\00\08\00\00\00")
  (data (i32.const 34) "; area: ")
  (data (i32.const 42) "\36\00\00\00\06\00\00\00\06\00\00\00")
  (data (i32.const 54) "Circle")
  (data (i32.const 60) "\48\00\00\00\06\00\00\00\06\00\00\00")
  (data (i32.const 72) "Square")
  (data (i32.const 78) "\5a\00\00\00\09\00\00\00\09\00\00\00")
  (data (i32.const 90) "Rectangle")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)