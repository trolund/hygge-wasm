(module
  (memory (export "memory") 1)
  (global $Sptr (mut i32)  i32.const 0
)  (global $Sptr$0 (mut i32)  i32.const 8
)  (func $main  (result i32)  ;; entry point of program (main function)
 
    ;; execution start here:
    ;; Start of field select
    ;; Start of field select
    ;; start of struct contructor
    i32.const 0 ;; push field address to stack at end
    ;; init field f
    ;; start of struct contructor
    i32.const 8 ;; push field address to stack at end
    ;; init field g
    i32.const 21 ;; push 21 on stack
    i32.store ;; store field in memory
    i32.const 12 ;; push field address to stack at end
    ;; init field h
    i32.const 42 ;; push 42 on stack
    i32.store ;; store field in memory
    i32.const 8 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store field in memory
    i32.const 4 ;; push field address to stack at end
    ;; init field h
    i32.const 200 ;; push 200 on stack
    i32.store ;; store field in memory
    i32.const 0 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    i32.load ;; load field
    ;; End of field select
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    i32.load ;; load field
    ;; End of field select
    i32.const 42 ;; push 42 on stack
    i32.eq
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