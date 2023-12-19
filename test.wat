(module
  (type $i32_i32_=>_unit (;0;) (func (param i32) (param i32) ))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $fun_f*ptr (;1;) (mut i32) (i32.const 0))
  (global $heap_base (;2;) i32 (i32.const 4))
  (global $var_i$0 (;3;) (mut i32) (i32.const 0))
  (global $var_n (;4;) (mut i32) (i32.const 0))
  (table $func_table (;0;) 1 funcref)
  (elem (i32.const 0) (;0;) $fun_f)
  (func $_start (;0;)   
    ;; execution start here:
    ;; Start of let
    (global.set $var_i$0 ;; set local var, have been hoisted
      (i32.const 0) ;; push 0 on stack
    )
    ;; Start of let
    (global.set $var_n ;; set local var, have been hoisted
      (i32.const 200) ;; push 200 on stack
    )
    (drop ;; drop value of init node
      (global.set $var_i$0 ;; set local var, have been hoisted
        (i32.const 0) ;; push 0 on stack
      )
      (global.get $var_i$0) ;; set local var, have been hoisted
    )
    (block $loop_exit$1 
      (loop $loop_begin$2 
        (br_if $loop_exit$1 ;; if false break
          (i32.eqz ;; evaluate loop condition
            (i32.lt_s
              (global.get $var_i$0) ;; get local var: var_i$0, have been hoisted
              (global.get $var_n) ;; get local var: var_n, have been hoisted
            )
          )
        )
        ;; Load expression to be applied as a function
        (call_indirect (type $i32_i32_=>_unit) ;; call function
          (i32.load offset=4
            (global.get $fun_f*ptr) ;; get global var: fun_f*ptr
          )
          (i32.add
            (global.get $var_i$0) ;; get local var: var_i$0, have been hoisted
            (i32.const 1) ;; push 1 on stack
          )
          (i32.load ;; load table index
            (global.get $fun_f*ptr) ;; get global var: fun_f*ptr
          )
        )
        (drop ;; drop value of subtree
          (drop
            (global.get $var_i$0) ;; get local var: var_i$0, have been hoisted
            (global.set $var_i$0 ;; set local var, have been hoisted
              (i32.add
                (global.get $var_i$0) ;; get local var: var_i$0, have been hoisted
                (i32.const 1) ;; push 1 on stack
              )
            )
            (global.get $var_i$0) ;; set local var, have been hoisted
          )
        )
        (br $loop_begin$2) ;; jump to beginning of loop
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (global.get $var_i$0) ;; get local var: var_i$0, have been hoisted
            (global.get $var_n) ;; get local var: var_n, have been hoisted
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
    ;; if execution reaches here, the program is successful
  )
  (func $fun_f (;1;) (param $cenv i32) (param $arg_n i32)  
     ;; local variables declarations:
    (local $var_cond i32)
    (local $var_i i32)

    ;; Start of let
    (local.set $var_i ;; set local var
      (i32.const 0) ;; push 0 on stack
    )
    ;; Start of let
    (local.set $var_cond ;; set local var
      (i32.const 1) ;; push true on stack
    )
    (block $loop_exit 
      (loop $loop_begin 
        (br_if $loop_exit ;; if false break
          (i32.eqz ;; evaluate loop condition
            (local.get $var_cond) ;; get local var: var_cond
          )
        )
        (drop ;; drop value of subtree
          (drop ;; drop value of subtree
            (local.tee $var_i ;; set local var
              (i32.add
                (local.get $var_i) ;; get local var: var_i
                (i32.const 1) ;; push 1 on stack
              )
            )
          )
          (local.tee $var_cond ;; set local var
            (i32.lt_s
              (local.get $var_i) ;; get local var: var_i
              (local.get $arg_n) ;; get local var: arg_n
            )
          )
        )
        (br $loop_begin) ;; jump to beginning of loop
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (local.get $var_i) ;; get local var: var_i
            (local.get $arg_n) ;; get local var: arg_n
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
  )
  (data (i32.const 0) "\00")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)