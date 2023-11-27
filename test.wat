(module
  (type $i32_=>_unit (;0;) (func (param i32) ))
  (type $sType (;1;) (struct (field $f (mut i32))))
  (type $sType$0 (;2;) (struct (field $f (mut i32))))
  (memory (;0;) (export "memory") 1)
  (global $Sptr (;0;) (mut (ref null $sType)) (ref.null $sType))
  (global $exit_code (;1;) (mut i32) (i32.const 0))
  (global $fun_f*ptr (;2;) (mut i32) (i32.const 0))
  (global $heap_base (;3;) (mut i32) (i32.const 4))
  (global $var_s1 (;4;) (mut (ref null $sType)) (ref.null $sType))
  (table $func_table (;0;) 1 funcref)
  (elem (i32.const 0) (;0;) $fun_f)
  (func $_start (;0;)   
    ;; execution start here:
    ;; Start of let
    (global.set $var_s1 ;; set local var, have been hoisted
      (global.set $Sptr ;; , have been hoisted
        (struct.new $sType
          (i32.add
            (i32.const 1) ;; push 1 on stack
            (i32.const 2) ;; push 2 on stack
          )
        )
      )
      (global.get $Sptr) ;; , have been hoisted
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            ;; Start of field select
            (struct.get $sType 0
              (global.get $var_s1) ;; get local var: var_s1, have been hoisted
            )
            ;; End of field select
            (i32.const 3) ;; push 3 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    ;; Load expression to be applied as a function
    (call_indirect (type $i32_=>_unit) ;; call function
      (i32.load offset=4
        (global.get $fun_f*ptr) ;; get global var: fun_f*ptr
      )
      (i32.load ;; load table index
        (global.get $fun_f*ptr) ;; get global var: fun_f*ptr
      )
    )
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (func $fun_f (;1;) (param $cenv i32)  
     ;; local variables declarations:
    (local $Sptr$1 (ref null $sType$0))
    (local $var_s1$2 (ref null $sType$0))

    ;; Start of let
    (local.set $var_s1$2 ;; set local var
      (local.tee $Sptr$1
        (struct.new $sType$0
          (i32.add
            (i32.add
              (i32.const 1) ;; push 1 on stack
              (i32.const 2) ;; push 2 on stack
            )
            (i32.const 3) ;; push 3 on stack
          )
        )
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            ;; Start of field select
            (struct.get $sType 0
              (local.get $var_s1$2) ;; get local var: var_s1$2
            )
            ;; End of field select
            (i32.const 6) ;; push 6 on stack
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
  )
  (data (i32.const 0) "\00")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)