(module
  (type $i32_=>_i32 (;0;) (func (param i32) (result i32)))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $fun_f*ptr (;1;) (mut i32) (i32.const 0))
  (global $fun_f/anonymous*ptr (;2;) (mut i32) (i32.const 36))
  (global $heap_base (;3;) i32 (i32.const 78))
  (global $var_f0 (;4;) (mut i32) (i32.const 0))
  (table $func_table (;0;) 2 funcref)
  (elem (i32.const 0) (;0;) $fun_f)
  (elem (i32.const 1) (;1;) $fun_f/anonymous)
  (func $_start (;0;)   
    ;; execution start here:
    ;; Start of let
    (global.set $var_f0 ;; set local var, have been hoisted
      ;; Load expression to be applied as a function
      (call_indirect (type $i32_=>_i32) ;; call function
        (i32.load offset=4
          (global.get $fun_f*ptr) ;; get global var: fun_f*ptr
        )
        (i32.load ;; load table index
          (global.get $fun_f*ptr) ;; get global var: fun_f*ptr
        )
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            ;; Load expression to be applied as a function
            (call_indirect (type $i32_=>_i32) ;; call function
              (i32.load offset=4
                (global.get $var_f0) ;; get local var: var_f0, have been hoisted
              )
              (i32.load ;; load table index
                (global.get $var_f0) ;; get local var: var_f0, have been hoisted
              )
            )
            (i32.const 9) ;; push 9 on stack
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
    ;; if execution reaches here, the program is successful
  )
  (func $fun_f (;1;) (param $cenv i32) (result i32) 
     ;; local variables declarations:
    (local $Sptr i32)
    (local $Sptr$0 i32)
    (local $Sptr$1 i32)
    (local $var_fl i32)
    (local $var_s i32)
    (local $var_s0 i32)

    ;; Start of let
    (local.set $var_s ;; set local var
      ;; start of struct contructor
      (local.set $Sptr ;; set struct pointer var
        (i32.const 4) ;; size of struct
        (call $malloc) ;; call malloc function
      )
      (i32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (local.get $Sptr) ;; get struct pointer var
          (i32.const 0) ;; push field offset to stack
        )
        ;; init field (value)
        (i32.const 4) ;; leave pointer to string on stack
      )
      (local.get $Sptr) ;; push struct address to stack
      ;; end of struct contructor
    )
    ;; Start of let
    (local.set $var_s0 ;; set local var
      (i32.const 20) ;; leave pointer to string on stack
    )
    ;; Start of let
    (local.set $var_fl ;; set local var
      (i32.const 2) ;; push 2 on stack
    )
    (i32.store ;; store poninter in return struct
      (i32.add ;; add offset
        ;; start of struct contructor
        (local.set $Sptr$1 ;; set struct pointer var
          (i32.const 8) ;; size of struct
          (call $malloc) ;; call malloc function
        )
        (i32.store ;; store int field in memory
          (i32.add ;; add offset to base address
            (local.get $Sptr$1) ;; get struct pointer var
            (i32.const 0) ;; push field offset to stack
          )
          ;; init field (f)
          (i32.const 1) ;; push 1 on stack
        )
        (i32.store ;; store int field in memory
          (i32.add ;; add offset to base address
            (local.get $Sptr$1) ;; get struct pointer var
            (i32.const 4) ;; push field offset to stack
          )
          ;; init field (env)
          (i32.const 0) ;; push 0 on stack
        )
        (local.get $Sptr$1) ;; push struct address to stack
        ;; end of struct contructor
        (i32.const 4) ;; 4 byte offset
      )
      ;; start of struct contructor
      (local.set $Sptr$0 ;; set struct pointer var
        (i32.const 12) ;; size of struct
        (call $malloc) ;; call malloc function
      )
      (i32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (local.get $Sptr$0) ;; get struct pointer var
          (i32.const 0) ;; push field offset to stack
        )
        ;; init field (fl)
        (local.get $var_fl) ;; get local var: var_fl
      )
      (i32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (local.get $Sptr$0) ;; get struct pointer var
          (i32.const 4) ;; push field offset to stack
        )
        ;; init field (s)
        (local.get $var_s) ;; get local var: var_s
      )
      (i32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (local.get $Sptr$0) ;; get struct pointer var
          (i32.const 8) ;; push field offset to stack
        )
        ;; init field (s0)
        (local.get $var_s0) ;; get local var: var_s0
      )
      (local.get $Sptr$0) ;; push struct address to stack
      ;; end of struct contructor
    )
    (local.get $Sptr$1) ;; get pointer to return struct
    ;; End of let
    ;; End of let
    ;; End of let
  )
  (func $fun_f/anonymous (;2;) (param $cenv i32) (result i32) 
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (i32.load offset=8
              ;; Start of field select
              (i32.load offset=0
                (i32.load offset=4
                  (local.get 0) ;; get env pointer
                )
              )
              ;; End of field select
            )
            (i32.load offset=8
              (i32.load offset=8
                (local.get 0) ;; get env pointer
              )
            )
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (drop ;; drop value of subtree
      (i32.store ;; store int in struct
        (i32.load offset=4
          (local.get 0) ;; get env pointer
        )
        (i32.const 59) ;; leave pointer to string on stack
      )
      (i32.load offset=0
        (i32.load offset=4
          (local.get 0) ;; get env pointer
        )
      )
    )
    (i32.add
      (i32.load offset=8
        ;; Start of field select
        (i32.load offset=0
          (i32.load offset=4
            (local.get 0) ;; get env pointer
          )
        )
        ;; End of field select
      )
      (i32.load offset=0
        (local.get 0) ;; get env pointer
      )
    )
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\10\00\00\00\04\00\00\00\04\00\00\00")
  (data (i32.const 16) "jazz")
  (data (i32.const 20) "\20\00\00\00\04\00\00\00\04\00\00\00")
  (data (i32.const 32) "buzz")
  (data (i32.const 36) "\01")
  (data (i32.const 59) "\47\00\00\00\07\00\00\00\07\00\00\00")
  (data (i32.const 71) "changed")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)