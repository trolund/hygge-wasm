(module
  (import "env" "read" (func $read (result i32)))
  (import "env" "write" (func $write (param i32)))
  (memory (export "memory") 1)

  
  (func $start
    (call $read)     ;; Read user input
    (call $write)    ;; Write the input to the console
  )
  
  (export "_start" (func $start))
)
