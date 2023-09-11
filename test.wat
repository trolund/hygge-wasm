(module
  (memory (export "memory") 1)
  (data (i32.const 28) "Hello")
  (func $main  (result i32)  ;; entry point of program (main function)
    ;; local variables declarations:
    (local $var_s1 i32)
    (local $var_s2 i32)
    (local $var_s3 i32)
 
    ;; execution start here:
    ;; Start of let
    ;; start of struct contructor
    i32.const 0 ;; push field address to stack at end
    ;; init field f
    i32.const 3 ;; push 3 on stack
    i32.store ;; store field in memory
    i32.const 4 ;; push field address to stack at end
    ;; init field g
    i32.const 1
    i32.store ;; store field in memory
    i32.const 0 ;; push struct address to stack
    ;; end of struct contructor
    local.set $var_s1 ;; set local var
    ;; Start of let
    ;; start of struct contructor
    i32.const 8 ;; push field address to stack at end
    ;; init field g
    local.get $var_s1
    i32.store ;; store field in memory
    i32.const 12 ;; push field address to stack at end
    ;; init field f
    i32.const 3 ;; push 3 on stack
    i32.store ;; store field in memory
    i32.const 8 ;; push struct address to stack
    ;; end of struct contructor
    local.set $var_s2 ;; set local var
    ;; Start of let
    ;; start of struct contructor
    i32.const 16 ;; push field address to stack at end
    ;; init field f
    i32.const 3 ;; push 3 on stack
    i32.store ;; store field in memory
    i32.const 20 ;; push field address to stack at end
    ;; init field h
    local.get $var_s2
    i32.store ;; store field in memory
    i32.const 24 ;; push field address to stack at end
    ;; init field g
    i32.const 28 ;; offset in memory
    i32.const 40 ;; size in bytes
    i32.store ;; store field in memory
    i32.const 16 ;; push struct address to stack
    ;; end of struct contructor
    local.set $var_s3 ;; set local var
    ;; Start of field select
    ;; Start of field select
    ;; Start of field select
    local.get $var_s3
    i32.const 4 ;; push field offset to stack
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
    i32.const 3 ;; push 3 on stack
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
    ;; Start of field select
    ;; Start of field select
    local.get $var_s3
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    i32.load ;; load field
    ;; End of field select
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    i32.load ;; load field
    ;; End of field select
    i32.const 0 ;; offset of field
    i32.add ;; add offset
    ;; Start of field select
    local.get $var_s3
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    i32.load ;; load field
    ;; End of field select
    i32.const 4 ;; offset of field
    i32.add ;; add offset
    local.get $var_s3
    i32.const 0 ;; offset of field
    i32.add ;; add offset
    i32.const 42 ;; push 42 on stack
    i32.store ;; store int in struct
    i32.const 42 ;; push 42 on stack
    i32.store ;; store int in struct
    local.get $var_s3
    i32.const 0 ;; offset of field
    i32.add ;; add offset
    i32.const 42 ;; push 42 on stack
    i32.store ;; store int in struct
    i32.const 42 ;; push 42 on stack
    i32.store ;; store int in struct
    ;; Start of field select
    local.get $var_s3
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    i32.load ;; load field
    ;; End of field select
    i32.const 4 ;; offset of field
    i32.add ;; add offset
    local.get $var_s3
    i32.const 0 ;; offset of field
    i32.add ;; add offset
    i32.const 42 ;; push 42 on stack
    i32.store ;; store int in struct
    i32.const 42 ;; push 42 on stack
    i32.store ;; store int in struct
    local.get $var_s3
    i32.const 0 ;; offset of field
    i32.add ;; add offset
    i32.const 42 ;; push 42 on stack
    i32.store ;; store int in struct
    i32.const 42 ;; push 42 on stack
    ;; Start of field select
    local.get $var_s3
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
    ;; Start of field select
    ;; Start of field select
    local.get $var_s3
    i32.const 4 ;; push field offset to stack
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
    ;; Start of field select
    ;; Start of field select
    ;; Start of field select
    local.get $var_s3
    i32.const 4 ;; push field offset to stack
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