(module
  (type $struct_f*i32_g*i32 (;0;) (struct (field $f (mut i32)) (field $g (mut i32))))
  (type $struct_g*ref*$struct_f*i32__f*i32 (;1;) (struct (field $g (ref null $struct_f*i32_g*i32)) (field $f (mut i32))))
  (memory (;0;) (export "memory") 1)
  (global $Sptr (;0;) (mut (ref null $struct_f*i32_g*i32)) (ref.null $struct_f*i32_g*i32))
  (global $Sptr$0 (;1;) (mut (ref null $struct_g*ref*$struct_f*i32__f*i32)) (ref.null $struct_g*ref*$struct_f*i32__f*i32))
  (global $exit_code (;2;) (mut i32) (i32.const 0))
  (global $heap_base (;3;) (mut i32) (i32.const 0))
  (global $var_s1 (;4;) (mut (ref null $struct_f*i32_g*i32)) (ref.null $struct_f*i32_g*i32))
  (global $var_s2 (;5;) (mut (ref null $struct_g*ref*$struct_f*i32__f*i32)) (ref.null $struct_g*ref*$struct_f*i32__f*i32))
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    (global.set $var_s1 ;; set local var, have been hoisted
      (global.set $Sptr ;; , have been hoisted
        (struct.new $struct_f*i32_g*i32
          (i32.const 3) ;; push 3 on stack
          (i32.const 1) ;; push true on stack
        )
      )
      (global.get $Sptr) ;; , have been hoisted
    )
    ;; Start of let
    (global.set $var_s2 ;; set local var, have been hoisted
      (global.set $Sptr$0 ;; , have been hoisted
        (struct.new $struct_g*ref*$struct_f*i32__f*i32
          (global.get $var_s1) ;; get local var: var_s1, have been hoisted
          (i32.const 3) ;; push 3 on stack
        )
      )
      (global.get $Sptr$0) ;; , have been hoisted
    )
    (i32.const 0) ;; push 0 on stack
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)