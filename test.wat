(module
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $heap_base (;1;) i32 (i32.const 0))
  (func $_start (;0;)   
    ;; execution start here:
    f32.const 4.000000 ;; push 4.000000 on stack
    f32.const 5.000000 ;; push 5.000000 on stack
    f32.add
    f32.const 9.000000 ;; push 9.000000 on stack
    f32.eq ;; equality check
    i32.eqz ;; invert assertion
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    ;; if execution reaches here, the program is successful
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)