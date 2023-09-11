(module
  (memory (export "memory") 1)
  (data (i32.const 52) "Hello")
  (global $Sptr (mut i32)  i32.const 0
)  (global $Sptr$0 (mut i32)  i32.const 8
)  (global $Sptr$1 (mut i32)  i32.const 16
)  (global $Sptr$2 (mut i32)  i32.const 24
)  (global $Sptr$3 (mut i32)  i32.const 32
)  (global $Sptr$4 (mut i32)  i32.const 40
)  (func $main  (result i32)  ;; entry point of program (main function)
    ;; local variables declarations:
    (local $var_s1 i32)
    (local $var_s2 i32)
    (local $var_s3 i32)
 
    ;; execution start here:
    ;; Start of field select
    ;; start of struct contructor
    i32.const 0 ;; push field address to stack
    ;; init field f
    f32.const 42.000000
    f32.store ;; store field in memory
    i32.const 4 ;; push field address to stack at end
    ;; init field g
    i32.const 1
    i32.store ;; store field in memory
    i32.const 0 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    f32.load ;; load field
    ;; End of field select
    f32.const 42.000000
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
    ;; Start of field select
    ;; Start of field select
    ;; start of struct contructor
    i32.const 8 ;; push field address to stack at end
    ;; init field f
    ;; start of struct contructor
    i32.const 16 ;; push field address to stack at end
    ;; init field g
    i32.const 0 ;; push 0 on stack
    i32.store ;; store field in memory
    i32.const 20 ;; push field address to stack at end
    ;; init field h
    i32.const 42 ;; push 42 on stack
    i32.store ;; store field in memory
    i32.const 16 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store field in memory
    i32.const 12 ;; push field address to stack at end
    ;; init field h
    i32.const 1 ;; push 1 on stack
    i32.store ;; store field in memory
    i32.const 8 ;; push struct address to stack
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
    ;; Start of let
    ;; start of struct contructor
    i32.const 24 ;; push field address to stack at end
    ;; init field f
    i32.const 42 ;; push 42 on stack
    i32.store ;; store field in memory
    i32.const 28 ;; push field address to stack at end
    ;; init field g
    i32.const 1
    i32.store ;; store field in memory
    i32.const 24 ;; push struct address to stack
    ;; end of struct contructor
    local.set $var_s1 ;; set local var
    ;; Start of let
    ;; start of struct contructor
    i32.const 32 ;; push field address to stack at end
    ;; init field g
    local.get $var_s1
    i32.store ;; store field in memory
    i32.const 36 ;; push field address to stack at end
    ;; init field f
    i32.const 0 ;; push 0 on stack
    i32.store ;; store field in memory
    i32.const 32 ;; push struct address to stack
    ;; end of struct contructor
    local.set $var_s2 ;; set local var
    ;; Start of let
    ;; start of struct contructor
    i32.const 40 ;; push field address to stack at end
    ;; init field h
    local.get $var_s2
    i32.store ;; store field in memory
    i32.const 44 ;; push field address to stack at end
    ;; init field f
    i32.const 0 ;; push 0 on stack
    i32.store ;; store field in memory
    i32.const 48 ;; push field address to stack at end
    ;; init field g
    i32.const 52 ;; offset in memory
    i32.const 40 ;; size in bytes
    i32.store ;; store field in memory
    i32.const 40 ;; push struct address to stack
    ;; end of struct contructor
    local.set $var_s3 ;; set local var
    ;; Start of field select
    ;; Start of field select
    ;; Start of field select
    local.get $var_s3
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    i32.load ;; load field
    ;; End of field select
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    i32.load ;; load field
    ;; End of field select
    i32.const 0 ;; push field offset to stack
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
    ;; End of let
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (export "main" (func $main))
)