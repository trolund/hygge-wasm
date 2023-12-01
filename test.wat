(module
  (type $struct_f*i32 (;0;) (struct (field $f (mut i32))))
  (type $struct_g*$struct_f*i32_f*i32 (;1;) (struct (field $g (ref null $struct_f*i32)) (field $f (mut i32))))
  (type $struct_f*i32_h*$struct_g*$struct_f*i32_f*i32_g*i32 (;2;) (struct (field $f (mut i32)) (field $h (ref null $struct_g*$struct_f*i32_f*i32)) (field $g (mut i32))))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $heap_base (;1;) (mut i32) (i32.const 17))
  (global $var_s1 (;2;) (mut (ref null $struct_f*i32)) (ref.null $struct_f*i32))
  (global $var_s2 (;3;) (mut (ref null $struct_g*$struct_f*i32_f*i32)) (ref.null $struct_g*$struct_f*i32_f*i32))
  (global $var_s3 (;4;) (mut (ref null $struct_f*i32_h*$struct_g*$struct_f*i32_f*i32_g*i32)) (ref.null $struct_f*i32_h*$struct_g*$struct_f*i32_f*i32_g*i32))
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)   
    ;; execution start here:
    ;; Start of let
    (global.set $var_s1 ;; set local var, have been hoisted
      (struct.new $struct_f*i32
        (i32.const 3) ;; push 3 on stack
      )
    )
    ;; Start of let
    (global.set $var_s2 ;; set local var, have been hoisted
      (struct.new $struct_g*$struct_f*i32_f*i32
        (global.get $var_s1) ;; get local var: var_s1, have been hoisted
        (i32.const 3) ;; push 3 on stack
      )
    )
    ;; Start of let
    (global.set $var_s3 ;; set local var, have been hoisted
      (struct.new $struct_f*i32_h*$struct_g*$struct_f*i32_f*i32_g*i32
        (i32.const 3) ;; push 3 on stack
        (global.get $var_s2) ;; get local var: var_s2, have been hoisted
        (i32.const 0) ;; leave pointer to string on stack
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            ;; Start of field select
            (struct.get $struct_f*i32 0 ;; load field: f
              ;; Start of field select
              (struct.get $struct_g*$struct_f*i32_f*i32 0 ;; load field: g
                ;; Start of field select
                (struct.get $struct_f*i32_h*$struct_g*$struct_f*i32_f*i32_g*i32 1 ;; load field: h
                  (global.get $var_s3) ;; get local var: var_s3, have been hoisted
                )
                ;; End of field select
              )
              ;; End of field select
            )
            ;; End of field select
            (i32.const 3) ;; push 3 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (drop ;; drop value of subtree
      (struct.set $struct_f*i32 $f ;; set field: f
        ;; Start of field select
        (struct.get $struct_g*$struct_f*i32_f*i32 0 ;; load field: g
          ;; Start of field select
          (struct.get $struct_f*i32_h*$struct_g*$struct_f*i32_f*i32_g*i32 1 ;; load field: h
            (global.get $var_s3) ;; get local var: var_s3, have been hoisted
          )
          ;; End of field select
        )
        ;; End of field select
        (struct.set $struct_g*$struct_f*i32_f*i32 $f ;; set field: f
          ;; Start of field select
          (struct.get $struct_f*i32_h*$struct_g*$struct_f*i32_f*i32_g*i32 1 ;; load field: h
            (global.get $var_s3) ;; get local var: var_s3, have been hoisted
          )
          ;; End of field select
          (struct.set $struct_f*i32_h*$struct_g*$struct_f*i32_f*i32_g*i32 $f ;; set field: f
            (global.get $var_s3) ;; get local var: var_s3, have been hoisted
            (i32.const 42) ;; push 42 on stack
          )
          (struct.get $struct_f*i32_h*$struct_g*$struct_f*i32_f*i32_g*i32 $f ;; get field: f
            (global.get $var_s3) ;; get local var: var_s3, have been hoisted
          )
        )
        (struct.get $struct_g*$struct_f*i32_f*i32 $f ;; get field: f
          ;; Start of field select
          (struct.get $struct_f*i32_h*$struct_g*$struct_f*i32_f*i32_g*i32 1 ;; load field: h
            (global.get $var_s3) ;; get local var: var_s3, have been hoisted
          )
          ;; End of field select
        )
      )
      (struct.get $struct_f*i32 $f ;; get field: f
        ;; Start of field select
        (struct.get $struct_g*$struct_f*i32_f*i32 0 ;; load field: g
          ;; Start of field select
          (struct.get $struct_f*i32_h*$struct_g*$struct_f*i32_f*i32_g*i32 1 ;; load field: h
            (global.get $var_s3) ;; get local var: var_s3, have been hoisted
          )
          ;; End of field select
        )
        ;; End of field select
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            ;; Start of field select
            (struct.get $struct_f*i32_h*$struct_g*$struct_f*i32_f*i32_g*i32 0 ;; load field: f
              (global.get $var_s3) ;; get local var: var_s3, have been hoisted
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
          (i32.eq ;; equality check
            ;; Start of field select
            (struct.get $struct_g*$struct_f*i32_f*i32 1 ;; load field: f
              ;; Start of field select
              (struct.get $struct_f*i32_h*$struct_g*$struct_f*i32_f*i32_g*i32 1 ;; load field: h
                (global.get $var_s3) ;; get local var: var_s3, have been hoisted
              )
              ;; End of field select
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
          (i32.eq ;; equality check
            ;; Start of field select
            (struct.get $struct_f*i32 0 ;; load field: f
              ;; Start of field select
              (struct.get $struct_g*$struct_f*i32_f*i32 0 ;; load field: g
                ;; Start of field select
                (struct.get $struct_f*i32_h*$struct_g*$struct_f*i32_f*i32_g*i32 1 ;; load field: h
                  (global.get $var_s3) ;; get local var: var_s3, have been hoisted
                )
                ;; End of field select
              )
              ;; End of field select
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
    ;; End of let
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (data (i32.const 0) "\0c\00\00\00\05\00\00\00\05\00\00\00")
  (data (i32.const 12) "Hello")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)