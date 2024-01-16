(module
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $heap_base (;1;) i32 (i32.const 0))
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)   
    ;; execution start here:
    (if 
        (i32.eqz ;; invert assertion
          (f32.lt
            (f32.sqrt ;; sqrt of f32 value
              (f32.add
                (f32.const 12.000000) ;; push 12.000000 on stack
                (f32.const 0.100000) ;; push 0.100000 on stack
              )
            )
            (f32.const 3.500000) ;; push 3.500000 on stack
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
          (f32.lt
            (f32.sqrt ;; sqrt of f32 value
              (f32.add
                (f32.const 12.000000) ;; push 12.000000 on stack
                (f32.const 0.200000) ;; push 0.200000 on stack
              )
            )
            (f32.const 3.500000) ;; push 3.500000 on stack
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
          (f32.lt
            (f32.sqrt ;; sqrt of f32 value
              (f32.add
                (f32.const 12.000000) ;; push 12.000000 on stack
                (f32.const 0.300000) ;; push 0.300000 on stack
              )
            )
            (f32.const 3.550000) ;; push 3.550000 on stack
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
          (f32.lt
            (f32.sqrt ;; sqrt of f32 value
              (f32.const 2.000000) ;; push 2.000000 on stack
            )
            (f32.const 1.500000) ;; push 1.500000 on stack
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
          (f32.eq ;; equality check
            (f32.sqrt ;; sqrt of f32 value
              (f32.const 1.000000) ;; push 1.000000 on stack
            )
            (f32.const 1.000000) ;; push 1.000000 on stack
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