(module
  (func $main  (result i32)  ;; entry point of program (main function)
 
    ;; execution start here:
    f32.const 12.000000
    f32.const 0.100000
    f32.add
    f32.sqrt
    f32.const 3.500000
    f32.lt
    (if 
     (then
      nop ;; do nothing - if all correct

     )
     (else
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
    )
    f32.const 12.000000
    f32.const 0.200000
    f32.add
    f32.sqrt
    f32.const 3.500000
    f32.lt
    (if 
     (then
      nop ;; do nothing - if all correct

     )
     (else
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
    )
    f32.const 12.000000
    f32.const 0.300000
    f32.add
    f32.sqrt
    f32.const 3.550000
    f32.lt
    (if 
     (then
      nop ;; do nothing - if all correct

     )
     (else
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
    )
    f32.const 2.000000
    f32.sqrt
    f32.const 1.500000
    f32.lt
    (if 
     (then
      nop ;; do nothing - if all correct

     )
     (else
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
    )
    f32.const 1.000000
    f32.sqrt
    f32.const 1.000000
    f32.eq
    (if 
     (then
      nop ;; do nothing - if all correct

     )
     (else
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code

     )
    )
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (export "main" (func $main))
)