(module
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $heap_base (;1;) i32 (i32.const 0))
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)   
    ;; execution start here:
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (i32.const 12) ;; push 12 on stack
            (i32.const 10) ;; push 10 on stack
            (i32.gt_s
              (i32.const 12) ;; push 12 on stack
              (i32.const 10) ;; push 10 on stack
            )
            (select)
            (i32.const 12) ;; push 12 on stack
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
            (i32.const 120) ;; push 120 on stack
            (i32.const 1) ;; push 1 on stack
            (i32.gt_s
              (i32.const 120) ;; push 120 on stack
              (i32.const 1) ;; push 1 on stack
            )
            (select)
            (i32.const 120) ;; push 120 on stack
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
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)