(module
  (type $s_i32-f32-i32 (;0;) (struct (field $i (mut i32)) (field $a (mut f32)) (field $b (mut i32))))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $heap_base (;1;) (mut i32) (i32.const 0))
  (global $var_s (;2;) (mut (ref null $s_i32-f32-i32)) (ref.null $s_i32-f32-i32))
  (global $var_s1 (;3;) (mut (ref null $s_i32-f32-i32)) (ref.null $s_i32-f32-i32))
  (func $_start (;0;)   
    ;; execution start here:
    ;; Start of let
    (global.set $var_s ;; set local var, have been promoted
      (struct.new $s_i32-f32-i32
        (i32.const 42) ;; push 42 on stack
        (f32.const 93.199997) ;; push 93.199997 on stack
        (i32.const 90) ;; push 90 on stack
      )
    )
    ;; Start of let
    (global.set $var_s1 ;; set local var, have been promoted
      (struct.new $s_i32-f32-i32
        (i32.const 42) ;; push 42 on stack
        (f32.const 93.199997) ;; push 93.199997 on stack
        (i32.const 90) ;; push 90 on stack
      )
    )
    (drop ;; drop value of subtree
      (struct.set $s_i32-f32-i32 $b ;; set field: b
        (global.get $var_s) ;; get local var: var_s, have been promoted
        (i32.const 100) ;; push 100 on stack
      )
      (struct.get $s_i32-f32-i32 $b ;; get field: b
        (global.get $var_s) ;; get local var: var_s, have been promoted
      )
    )
    (if 
      (i32.eqz ;; invert assertion
        (i32.eq ;; equality check
          ;; Start of field select
          (struct.get $s_i32-f32-i32 2 ;; load field: b
            (global.get $var_s) ;; get local var: var_s, have been promoted
          )
          ;; End of field select
          (i32.const 100) ;; push 100 on stack
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
          ;; Start of field select
          (struct.get $s_i32-f32-i32 0 ;; load field: i
            (global.get $var_s) ;; get local var: var_s, have been promoted
          )
          ;; End of field select
          (i32.const 42) ;; push 42 on stack
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
          ;; Start of field select
          (struct.get $s_i32-f32-i32 1 ;; load field: a
            (global.get $var_s) ;; get local var: var_s, have been promoted
          )
          ;; End of field select
          (f32.const 93.199997) ;; push 93.199997 on stack
        )
      )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)