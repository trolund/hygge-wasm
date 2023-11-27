(module
  (type $sType (;0;) (struct (field $f (mut i32))))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $heap_base (;1;) (mut i32) (i32.const 0))
  (global $var_s1 (;2;) (mut i32) (i32.const 0))
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    (drop
      (struct.new $sType
        (i32.const 10)
      )
    )
    (i32.const 10) ;; push 10 on stack
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)