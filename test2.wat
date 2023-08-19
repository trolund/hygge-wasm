(module
  (func $main  (result i32) ;; main function 
    i32.const 1
    (if
 (then
i32.const 30
return

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