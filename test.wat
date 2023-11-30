(module
  (type $array_type (;0;) (array (mut i32)))
  (type $struct_type (;1;) (struct (field $data (ref null $array_type)) (field $length (mut i32))))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $heap_base (;1;) (mut i32) (i32.const 0))
  (global $var_arr (;2;) (mut (ref null $struct_type)) (ref.null $struct_type))
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    (global.set $var_arr ;; set local var, have been hoisted
      (if 
          (i32.le_s ;; check if length is <= 1
            (i32.add
              (i32.const 2) ;; push 2 on stack
              (i32.const 2) ;; push 2 on stack
            )
            (i32.const 1) ;; put one on stack
          )
        (then
          (global.set $exit_code ;; set exit code
            (i32.const 42) ;; error exit code push to stack
          )
          (unreachable) ;; exit program
        )
      )
      (struct.new $struct_type
        (array.new $array_type
          (i32.add
            (i32.const 40) ;; push 40 on stack
            (i32.const 2) ;; push 2 on stack
          )
          (i32.add
            (i32.const 2) ;; push 2 on stack
            (i32.const 2) ;; push 2 on stack
          )
        )
        (i32.add
          (i32.const 2) ;; push 2 on stack
          (i32.const 2) ;; push 2 on stack
        )
      )
    )
    (i32.const 0) ;; push 0 on stack
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)