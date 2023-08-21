(module
  (func $main  (result i32) ;; entry point of program (main function) 
    ;; execution start here:
    i32.const 0
    i32.const 4 ;; push 4 on stack
    i32.const 2 ;; push 2 on stack
    i32.mul
    i32.const 8 ;; push 8 on stack
    i32.eq
    i32.or
    (if
 (then
nop ;; 

) (else
i32.const 42 ;; 
return ;; 

)
)
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (export "main" (func $main))
)