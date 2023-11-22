(module
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $heap_base (;1;) i32 (i32.const 0))
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    (i32.eqz ;; invert assertion
      (f32.eq ;; equality check
        (f32.add
          (f32.const 4.000000) ;; push 4.000000 on stack
          (f32.const 5.000000) ;; push 5.000000 on stack
        )
        (f32.const 9.000000) ;; push 9.000000 on stack
      )
    )
    (if 
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    ;; if execution reaches here, the program is successful
    (i32.const 0) ;; exit code 0
    (return) ;; return the exit code
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)