(module
  (func $main  (result i32)  ;; entry point of program (main function)
    ;; local variables declarations:
  
    ;; execution start here:
    f32.const 3.140000
    f32.const 1.000000
    f32.sub
    f32.const 2.140000
    f32.eq
    (if 
 (then
nop ;; do nothing - if all correct

) (else
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