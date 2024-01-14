(module
  (import "env" "read" (func $read (result externref)))
  (import "env" "write" (func $write (param externref)))
  (memory (export "memory") 1)

(func (export "main") (result i32)
    ;; Read user input
    call $read     
    ;; Write the input to the console
    call $write    
    ;; load 42 onto the stack
    i32.const 0
    ;; return the second value (42); the first is discarded
    return
  )
)


