(module
  (func $main  (result i32) ;; main function 
    i32.const 8
    i32.const 2
    i32.div_s
    i32.const 10
    i32.add
    i32.const 2
    i32.const 2
    i32.mul
    i32.const 10
    i32.add
    i32.const 8
    i32.const 2
    i32.div_s
    i32.const 10
    i32.add
    i32.eq
    (if
 (then
nop

) (else
i32.const 42
return

)
)
    i32.const 0
    return
  )
  (export "main" (func $main))
)