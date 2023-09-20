(module
  (import "env" "malloc" (func $malloc (param i32) (result i32) 
))
  (memory (export "memory") 1)
  (data (i32.const 0) "Hello")
  (global $heap_base i32  i32.const 10
)  (func $_start  (result i32)  ;; entry point of program (main function)
    ;; local variables declarations:
    (local $Sptr i32)
    (local $Sptr$0 i32)
    (local $Sptr$1 i32)
    (local $Sptr$2 i32)
    (local $Sptr$3 i32)
    (local $Sptr$4 i32)
    (local $var_s1 i32)
    (local $var_s2 i32)
    (local $var_s3 i32)
 
    ;; execution start here:
    ;; Start of field select
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr ;; set struct pointer var
    local.get $Sptr ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    f32.const 42.000000
    f32.store ;; store field in memory
    local.get $Sptr ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field g
    i32.const 1
    i32.store ;; store field in memory
    local.get $Sptr ;; push struct address to stack
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
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$0 ;; set struct pointer var
    local.get $Sptr$0 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$1 ;; set struct pointer var
    local.get $Sptr$1 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field g
    i32.const 0 ;; push 0 on stack
    i32.store ;; store field in memory
    local.get $Sptr$1 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field h
    i32.const 42 ;; push 42 on stack
    i32.store ;; store field in memory
    local.get $Sptr$1 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store field in memory
    local.get $Sptr$0 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field h
    i32.const 1 ;; push 1 on stack
    i32.store ;; store field in memory
    local.get $Sptr$0 ;; push struct address to stack
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
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$2 ;; set struct pointer var
    local.get $Sptr$2 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 42 ;; push 42 on stack
    i32.store ;; store field in memory
    local.get $Sptr$2 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field g
    i32.const 1
    i32.store ;; store field in memory
    local.get $Sptr$2 ;; push struct address to stack
    ;; end of struct contructor
    local.set $var_s1 ;; set local var
    ;; Start of let
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$3 ;; set struct pointer var
    local.get $Sptr$3 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field g
    local.get $var_s1
    i32.store ;; store field in memory
    local.get $Sptr$3 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 0 ;; push 0 on stack
    i32.store ;; store field in memory
    local.get $Sptr$3 ;; push struct address to stack
    ;; end of struct contructor
    local.set $var_s2 ;; set local var
    ;; Start of let
    ;; start of struct contructor
    i32.const 3 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$4 ;; set struct pointer var
    local.get $Sptr$4 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field h
    local.get $var_s2
    i32.store ;; store field in memory
    local.get $Sptr$4 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 0 ;; push 0 on stack
    i32.store ;; store field in memory
    local.get $Sptr$4 ;; get struct pointer var
    i32.const 8 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field g
    i32.const 0 ;; offset in memory
    i32.const 40 ;; size in bytes
    i32.store ;; store field in memory
    local.get $Sptr$4 ;; push struct address to stack
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
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)