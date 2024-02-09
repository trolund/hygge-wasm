(module
  (type $A (;0;) (struct (field $f (mut i32)) (field $g (mut i32))))
  (type $B (;2;) (struct (field $g (ref null $A)) (field $f (mut i32))))
  (type $C (;1;) (struct (field $f (mut i32)) (field $h (ref null $B)) (field $g (mut i32))))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;3;) (mut i32) (i32.const 0))
  (global $heap_base (;4;) (mut i32) (i32.const 17))
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)  (result i32) 
    i32.const 0
  )
  (data (i32.const 0) "\0c\00\00\00\05\00\00\00\05\00\00\00")
  (data (i32.const 12) "Hello")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)


