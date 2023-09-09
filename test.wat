(module
  (memory (export "memory") 1)
  (global $Sptr (mut i32)  i32.const 0
)  (global $Sptr$0 (mut i32)  i32.const 4
)  (func $main  (result i32)  ;; entry point of program (main function)
    ;; local variables declarations:
    (local $var_s1 i32)
    (local $var_s2 i32)
 
    ;; execution start here:
    ;; Start of let
    ;; start of struct contructor
    i32.const 0 ;; push field address to stack
    i32.const 42 ;; push 42 on stack
    i32.store ;; store field in memory
    i32.const 0 ;; push field address to stack
    ;; end of struct contructor
    local.set $var_s1 ;; set local var
    ;; Start of let
    ;; start of struct contructor
    i32.const 16 ;; push field address to stack
    i32.const 43 ;; push 43 on stack
    i32.store ;; store field in memory
    i32.const 4 ;; push field address to stack
    ;; end of struct contructor
    local.set $var_s2 ;; set local var
    ;; Start of field select
    local.get $var_s1
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply offset by 4
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
    local.get $var_s2
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply offset by 4
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    i32.load ;; load field
    ;; End of field select
    i32.const 43 ;; push 43 on stack
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
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (export "main" (func $main))
)