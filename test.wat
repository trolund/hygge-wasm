(module
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) i32.const 0)
  (global $heap_base (;1;) i32 i32.const 0)
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    f32.const 1.000000 ;; push 1.000000 on stack
    f32.neg ;; negate
    f32.const 0.000000 ;; push 0.000000 on stack
    f32.lt
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    f32.const 100.000000 ;; push 100.000000 on stack
    f32.neg ;; negate
    f32.const 99.000000 ;; push 99.000000 on stack
    f32.neg ;; negate
    f32.lt
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)