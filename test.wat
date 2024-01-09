(module
  (type $i32_i32_=>_i32 (;0;) (func (param i32) (param i32) (result i32)))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $Sptr (;0;) (mut i32) (i32.const 0))
  (global $Sptr$2 (;1;) (mut i32) (i32.const 0))
  (global $Sptr$3 (;2;) (mut i32) (i32.const 0))
  (global $Sptr$4 (;3;) (mut i32) (i32.const 0))
  (global $Sptr$5 (;4;) (mut i32) (i32.const 0))
  (global $exit_code (;5;) (mut i32) (i32.const 0))
  (global $fun_matcher*ptr (;6;) (mut i32) (i32.const 0))
  (global $heap_base (;7;) i32 (i32.const 4))
  (global $var_x (;8;) (mut i32) (i32.const 0))
  (global $var_y (;9;) (mut i32) (i32.const 0))
  (global $var_z (;10;) (mut i32) (i32.const 0))
  (table $func_table (;0;) 1 funcref)
  (elem (i32.const 0) (;0;) $fun_matcher)
  (func $_start (;0;)   
    ;; execution start here:
    ;; Start of let
    (global.set $var_x ;; set local var, have been hoisted
      ;; Start of union contructor
      ;; start of struct contructor
      (global.set $Sptr ;; set struct pointer var, have been hoisted
        (i32.const 8) ;; size of struct
        (call $malloc) ;; call malloc function
      )
      (i32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (global.get $Sptr) ;; get struct pointer var, have been hoisted
          (i32.const 0) ;; push field offset to stack
        )
        ;; init field (id)
        (i32.const 1) ;; push 1 on stack
      )
      (i32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (global.get $Sptr) ;; get struct pointer var, have been hoisted
          (i32.const 4) ;; push field offset to stack
        )
        ;; init field (data)
        ;; Start of union contructor
        ;; start of struct contructor
        (global.set $Sptr$2 ;; set struct pointer var, have been hoisted
          (i32.const 8) ;; size of struct
          (call $malloc) ;; call malloc function
        )
        (i32.store ;; store int field in memory
          (i32.add ;; add offset to base address
            (global.get $Sptr$2) ;; get struct pointer var, have been hoisted
            (i32.const 0) ;; push field offset to stack
          )
          ;; init field (id)
          (i32.const 2) ;; push 2 on stack
        )
        (i32.store ;; store int field in memory
          (i32.add ;; add offset to base address
            (global.get $Sptr$2) ;; get struct pointer var, have been hoisted
            (i32.const 4) ;; push field offset to stack
          )
          ;; init field (data)
          (i32.const 42) ;; push 42 on stack
        )
        (global.get $Sptr$2) ;; push struct address to stack, have been hoisted
        ;; end of struct contructor
        ;; End of union contructor
      )
      (global.get $Sptr) ;; push struct address to stack, have been hoisted
      ;; end of struct contructor
      ;; End of union contructor
    )
    ;; Start of let
    (global.set $var_y ;; set local var, have been hoisted
      ;; Start of union contructor
      ;; start of struct contructor
      (global.set $Sptr$3 ;; set struct pointer var, have been hoisted
        (i32.const 8) ;; size of struct
        (call $malloc) ;; call malloc function
      )
      (i32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (global.get $Sptr$3) ;; get struct pointer var, have been hoisted
          (i32.const 0) ;; push field offset to stack
        )
        ;; init field (id)
        (i32.const 4) ;; push 4 on stack
      )
      (i32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (global.get $Sptr$3) ;; get struct pointer var, have been hoisted
          (i32.const 4) ;; push field offset to stack
        )
        ;; init field (data)
        (i32.const 0) ;; push 0 on stack
      )
      (global.get $Sptr$3) ;; push struct address to stack, have been hoisted
      ;; end of struct contructor
      ;; End of union contructor
    )
    ;; Start of let
    (global.set $var_z ;; set local var, have been hoisted
      ;; Start of union contructor
      ;; start of struct contructor
      (global.set $Sptr$4 ;; set struct pointer var, have been hoisted
        (i32.const 8) ;; size of struct
        (call $malloc) ;; call malloc function
      )
      (i32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (global.get $Sptr$4) ;; get struct pointer var, have been hoisted
          (i32.const 0) ;; push field offset to stack
        )
        ;; init field (id)
        (i32.const 1) ;; push 1 on stack
      )
      (i32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (global.get $Sptr$4) ;; get struct pointer var, have been hoisted
          (i32.const 4) ;; push field offset to stack
        )
        ;; init field (data)
        ;; Start of union contructor
        ;; start of struct contructor
        (global.set $Sptr$5 ;; set struct pointer var, have been hoisted
          (i32.const 8) ;; size of struct
          (call $malloc) ;; call malloc function
        )
        (i32.store ;; store int field in memory
          (i32.add ;; add offset to base address
            (global.get $Sptr$5) ;; get struct pointer var, have been hoisted
            (i32.const 0) ;; push field offset to stack
          )
          ;; init field (id)
          (i32.const 3) ;; push 3 on stack
        )
        (f32.store ;; store int field in memory
          (i32.add ;; add offset to base address
            (global.get $Sptr$5) ;; get struct pointer var, have been hoisted
            (i32.const 4) ;; push field offset to stack
          )
          ;; init field (data)
          (f32.const 3.140000) ;; push 3.140000 on stack
        )
        (global.get $Sptr$5) ;; push struct address to stack, have been hoisted
        ;; end of struct contructor
        ;; End of union contructor
      )
      (global.get $Sptr$4) ;; push struct address to stack, have been hoisted
      ;; end of struct contructor
      ;; End of union contructor
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            ;; Load expression to be applied as a function
            (call_indirect (type $i32_i32_=>_i32) ;; call function
              (i32.load offset=4
                (global.get $fun_matcher*ptr) ;; get global var: fun_matcher*ptr
              )
              (global.get $var_x) ;; get local var: var_x, have been hoisted
              (i32.load ;; load table index
                (global.get $fun_matcher*ptr) ;; get global var: fun_matcher*ptr
              )
            )
            (i32.const 42) ;; push 42 on stack
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
          (i32.eq ;; equality check
            ;; Load expression to be applied as a function
            (call_indirect (type $i32_i32_=>_i32) ;; call function
              (i32.load offset=4
                (global.get $fun_matcher*ptr) ;; get global var: fun_matcher*ptr
              )
              (global.get $var_y) ;; get local var: var_y, have been hoisted
              (i32.load ;; load table index
                (global.get $fun_matcher*ptr) ;; get global var: fun_matcher*ptr
              )
            )
            (i32.const 0) ;; push 0 on stack
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
          (i32.eq ;; equality check
            ;; Load expression to be applied as a function
            (call_indirect (type $i32_i32_=>_i32) ;; call function
              (i32.load offset=4
                (global.get $fun_matcher*ptr) ;; get global var: fun_matcher*ptr
              )
              (global.get $var_z) ;; get local var: var_z, have been hoisted
              (i32.load ;; load table index
                (global.get $fun_matcher*ptr) ;; get global var: fun_matcher*ptr
              )
            )
            (i32.const 0) ;; push 0 on stack
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
  (func $fun_matcher (;1;) (param $cenv i32) (param $arg_x i32) (result i32) 
     ;; local variables declarations:
    (local $match_var__ f32)
    (local $match_var__$1 i32)
    (local $match_var_v i32)
    (local $match_var_x i32)

    (block $match_end (result i32)
      ;; case for id: $1, label: Some
      (if 
          (i32.eq ;; check if index is equal to target
            (i32.load ;; load label
              (local.get $arg_x) ;; get local var: arg_x
            )
            (i32.const 1) ;; put label id 1 on stack
          )
        (then
          (local.set $match_var_x ;; set local var
            (i32.load offset=4
              (local.get $arg_x) ;; get local var: arg_x
            )
          )
          (block $match_end$0 (result i32)
            ;; case for id: $2, label: I
            (if 
                (i32.eq ;; check if index is equal to target
                  (i32.load ;; load label
                    (local.get $match_var_x) ;; get local var: match_var_x
                  )
                  (i32.const 2) ;; put label id 2 on stack
                )
              (then
                (local.set $match_var_v ;; set local var
                  (i32.load offset=4
                    (local.get $match_var_x) ;; get local var: match_var_x
                  )
                )
                (local.get $match_var_v) ;; get local var: match_var_v
                (br $match_end$0) ;; break out of match
              )
            )
            ;; case for id: $3, label: F
            (if 
                (i32.eq ;; check if index is equal to target
                  (i32.load ;; load label
                    (local.get $match_var_x) ;; get local var: match_var_x
                  )
                  (i32.const 3) ;; put label id 3 on stack
                )
              (then
                (local.set $match_var__ ;; set local var
                  (f32.load offset=4
                    (local.get $match_var_x) ;; get local var: match_var_x
                  )
                )
                (i32.const 0) ;; push 0 on stack
                (br $match_end$0) ;; break out of match
              )
            )
            ;; no case was matched, therefore return exit error code
            (global.set $exit_code ;; set exit code
              (i32.const 42) ;; error exit code push to stack
            )
            (unreachable) ;; exit program
          )
          (br $match_end) ;; break out of match
        )
      )
      ;; case for id: $4, label: None
      (if 
          (i32.eq ;; check if index is equal to target
            (i32.load ;; load label
              (local.get $arg_x) ;; get local var: arg_x
            )
            (i32.const 4) ;; put label id 4 on stack
          )
        (then
          (local.set $match_var__$1 ;; set local var
            (i32.load offset=4
              (local.get $arg_x) ;; get local var: arg_x
            )
          )
          (i32.const 0) ;; push 0 on stack
          (br $match_end) ;; break out of match
        )
      )
      ;; no case was matched, therefore return exit error code
      (global.set $exit_code ;; set exit code
        (i32.const 42) ;; error exit code push to stack
      )
      (unreachable) ;; exit program
    )
  )
  (data (i32.const 0) "\00")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)