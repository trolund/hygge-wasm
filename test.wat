(module
  (import "env" "writeInt" (;0;) (func $writeInt (param i32) ))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) i32.const 0)
  (global $heap_base (;1;) i32 i32.const 0)
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    i32.const 1 ;; push true on stack
    (if (result i32)
      (then
        i32.const 1 ;; push 1 on stack
      )
      (else
        i32.const 0 ;; push false on stack
        (if (result i32)
          (then
            i32.const 0 ;; push false on stack
          )
          (else
            i32.const 0 ;; push 0 on stack
          )
        )
      )
    )
    call $writeInt ;; call host function
    i32.const 1 ;; push true on stack
    (if (result i32)
      (then
        i32.const 0 ;; push false on stack
        (if (result i32)
          (then
            i32.const 1 ;; push 1 on stack
          )
          (else
            i32.const 0 ;; push false on stack
          )
        )
      )
      (else
        i32.const 0 ;; push 0 on stack
      )
    )
    i32.eqz
    call $writeInt ;; call host function
    i32.const 2 ;; push 2 on stack
    i32.const 3 ;; push 3 on stack
    i32.eq
    (if (result i32)
      (then
        i32.const 1 ;; push 1 on stack
      )
      (else
        i32.const 4 ;; push 4 on stack
        i32.const 0 ;; push 0 on stack
        i32.lt_s
        (if (result i32)
          (then
            i32.const 1 ;; push 1 on stack
            i32.const 1 ;; push 1 on stack
            i32.eq
          )
          (else
            i32.const 0 ;; push 0 on stack
          )
        )
      )
    )
    i32.eqz
    call $writeInt ;; call host function
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)