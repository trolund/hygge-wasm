(module
  (type $i32_i32_=>_i32 (;0;) (func (param i32) (param i32) (result i32)))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (import "env" "writeInt" (;1;) (func $writeInt (param i32) (param i32) ))
  (import "env" "writeS" (;2;) (func $writeS (param i32) (param i32) (param i32) ))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $fun_countdown*ptr (;1;) (mut i32) (i32.const 0))
  (global $fun_countdownRec*ptr (;2;) (mut i32) (i32.const 4))
  (global $heap_base (;3;) i32 (i32.const 46))
  (table $func_table (;0;) 2 funcref)
  (elem (i32.const 0) (;0;) $fun_countdown)
  (elem (i32.const 1) (;1;) $fun_countdownRec)
  (func $_start (;0;)   
    ;; execution start here:
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            ;; Load expression to be applied as a function
            (call_indirect (type $i32_i32_=>_i32) ;; call function
              (i32.load offset=4
                (global.get $fun_countdown*ptr) ;; get global var: fun_countdown*ptr
              )
              (i32.const 10) ;; push 10 on stack
              (i32.load ;; load table index
                (global.get $fun_countdown*ptr) ;; get global var: fun_countdown*ptr
              )
            )
            (i32.const 99) ;; push 99 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    ;; if execution reaches here, the program is successful
  )
  (func $fun_countdown (;1;) (param $cenv i32) (param $arg_start i32) (result i32) 
     ;; local variables declarations:
    (local $Sptr i32)
    (local $Sptr$0 i32)
    (local $var_x i32)

    ;; Start of let
    (local.set $var_x ;; set local var
      (i32.const 100) ;; push 100 on stack
    )
    (global.set $fun_countdownRec*ptr
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
        ;; init field (func)
        (i32.const 1) ;; push 1 on stack
      )
      (i32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (local.get $Sptr) ;; get struct pointer var
          (i32.const 4) ;; push field offset to stack
        )
        ;; init field (cenv)
        ;; start of struct contructor
        (local.set $Sptr$0 ;; set struct pointer var
          (i32.const 4) ;; size of struct
          (call $malloc) ;; call malloc function
        )
        (i32.store ;; store int field in memory
          (i32.add ;; add offset to base address
            (local.get $Sptr$0) ;; get struct pointer var
            (i32.const 0) ;; push field offset to stack
          )
          ;; init field (x)
          (local.get $var_x) ;; get local var: var_x
        )
        (local.get $Sptr$0) ;; push struct address to stack
        ;; end of struct contructor
      )
      (local.get $Sptr) ;; push struct address to stack
      ;; end of struct contructor
    )
    ;; Load expression to be applied as a function
    (call_indirect (type $i32_i32_=>_i32) ;; call function
      (i32.load offset=4
        (global.get $fun_countdownRec*ptr) ;; get global var: fun_countdownRec*ptr
      )
      (local.get $arg_start) ;; get local var: arg_start
      (i32.load ;; load table index
        (global.get $fun_countdownRec*ptr) ;; get global var: fun_countdownRec*ptr
      )
    )
    ;; End of let
  )
  (func $fun_countdownRec (;2;) (param $cenv i32) (param $arg_curr i32) (result i32) 
    (if (result i32)
        (i32.lt_s
          (local.get $arg_curr) ;; get local var: arg_curr
          (i32.const 0) ;; push 0 on stack
        )
      (then
        (i32.load ;; Load string pointer
          (i32.const 8) ;; leave pointer to string on stack
        )
        (i32.load offset=4
          (i32.const 8) ;; leave pointer to string on stack
        )
        (i32.const 1) ;; newline
        (call $writeS) ;; call host function
        (i32.add
          (local.get $arg_curr) ;; get local var: arg_curr
          (i32.load offset=0
            (local.get 0) ;; get env pointer
          )
        )
      )
      (else
        (i32.load ;; Load string pointer
          (i32.const 23) ;; leave pointer to string on stack
        )
        (i32.load offset=4
          (i32.const 23) ;; leave pointer to string on stack
        )
        (i32.const 1) ;; newline
        (call $writeS) ;; call host function
        (i32.add
          (local.get $arg_curr) ;; get local var: arg_curr
          (i32.load offset=0
            (local.get 0) ;; get env pointer
          )
        )
        (i32.const 1) ;; newline
        (call $writeInt) ;; call host function
        ;; Load expression to be applied as a function
        (call_indirect (type $i32_i32_=>_i32) ;; call function
          (i32.load offset=4
            (global.get $fun_countdownRec*ptr) ;; get global var: fun_countdownRec*ptr
          )
          (i32.sub
            (local.get $arg_curr) ;; get local var: arg_curr
            (i32.const 1) ;; push 1 on stack
          )
          (i32.load ;; load table index
            (global.get $fun_countdownRec*ptr) ;; get global var: fun_countdownRec*ptr
          )
        )
      )
    )
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (data (i32.const 8) "\14\00\00\00\03\00\00\00\03\00\00\00")
  (data (i32.const 20) "Go!")
  (data (i32.const 23) "\23\00\00\00\0b\00\00\00\0b\00\00\00")
  (data (i32.const 35) "Countdown: ")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)