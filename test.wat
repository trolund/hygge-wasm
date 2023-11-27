(module
  (type $sType (;0;) (struct (field $f (mut i32))))
  (memory (;0;) (export "memory") 1)
  (global $Sptr (;0;) (mut (ref null $sType)) (ref.null $sType))
  (global $exit_code (;1;) (mut i32) (i32.const 0))
  (global $heap_base (;2;) (mut i32) (i32.const 0))
  (global $var_s1 (;3;) (mut (ref null $sType)) (ref.null $sType))
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    (global.set $var_s1 ;; set local var, have been hoisted
      (global.set $Sptr ;; , have been hoisted
        (struct.new $sType
          (i32.const 2)
        )
      )
      (global.get $Sptr) ;; , have been hoisted
    )
    (i32.const 10) ;; push 10 on stack
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)