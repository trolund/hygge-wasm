(module
  (type $i32_i32_=>_i32 (;0;) (func (param i32) (param i32) (result i32)))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $fun_outer*ptr (;1;) (mut i32) (i32.const 0))
  (global $fun_outer/anonymous*ptr (;2;) (mut i32) (i32.const 4))
  (global $heap_base (;3;) i32 (i32.const 8))
  (table $func_table (;0;) 2 funcref)
  (elem (i32.const 0) (;0;) $fun_outer)
  (elem (i32.const 1) (;1;) $fun_outer/anonymous)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    (drop ;; drop value of subtree
      ;; Load expression to be applied as a function
      (call_indirect (type $i32_i32_=>_i32) ;; call function
        (i32.load offset=4
          (global.get $fun_outer*ptr) ;; get global var: fun_outer*ptr
        )
        (i32.const 2) ;; push 2 on stack
        (i32.load ;; load table index
          (global.get $fun_outer*ptr) ;; get global var: fun_outer*ptr
        )
      )
    )
    (i32.const 10) ;; push 10 on stack
    ;; if execution reaches here, the program is successful
  )
  (func $fun_outer (;1;) (param $cenv i32) (param $arg_x i32) (result i32) 
     ;; local variables declarations:
    (local $Sptr i32)
    (local $Sptr$0 i32)
    (local $var_a i32)

    ;; Start of let
    (local.set $var_a ;; set local var
      (i32.add
        (local.get $arg_x) ;; get local var: arg_x
        (i32.const 1) ;; push 1 on stack
      )
    )
    ;; start of struct contructor
    (local.set $Sptr ;; set struct pointer var
      (i32.const 8) ;; size of struct
      (call $malloc) ;; call malloc function
    )
    (i32.store ;; store int field in memory
      (i32.add ;; add offset to base address
        (local.get $Sptr) ;; get struct pointer var
        (i32.const 0) ;; push field offset to stack
      )
      ;; init field (f)
      (i32.const 1) ;; push 1 on stack
    )
    (i32.store ;; store int field in memory
      (i32.add ;; add offset to base address
        (local.get $Sptr) ;; get struct pointer var
        (i32.const 4) ;; push field offset to stack
      )
      ;; init field (env)
      ;; start of struct contructor
      (local.set $Sptr$0 ;; set struct pointer var
        (i32.const 8) ;; size of struct
        (call $malloc) ;; call malloc function
      )
      (i32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (local.get $Sptr$0) ;; get struct pointer var
          (i32.const 0) ;; push field offset to stack
        )
        ;; init field (a)
        (local.get $var_a) ;; get local var: var_a
      )
      (i32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (local.get $Sptr$0) ;; get struct pointer var
          (i32.const 4) ;; push field offset to stack
        )
        ;; init field (x)
        (local.get $arg_x) ;; get local var: arg_x
      )
      (local.get $Sptr$0) ;; push struct address to stack
      ;; end of struct contructor
    )
    (local.get $Sptr) ;; push struct address to stack
    ;; end of struct contructor
    ;; End of let
  )
  (func $fun_outer/anonymous (;2;) (param $cenv i32) (param $arg_y i32) (result i32) 
    (i32.add
      (i32.add
        (local.get $arg_y) ;; get local var: arg_y
        (i32.load offset=0
          (local.get 0) ;; get env pointer
        )
      )
      (i32.load offset=4
        (local.get 0) ;; get env pointer
      )
    )
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)