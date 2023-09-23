(module
  (type $fun_checkOption_type (func (param i32) (result i32)))
  (import "env" "malloc" (func $malloc (param i32) (result i32) 
))
  (memory (export "memory") 1)
  (global $heap_base i32  i32.const 0
)  (func $_start  (result i32)  ;; entry point of program (main function)
    ;; local variables declarations:
    (local $Sptr i32)
    (local $Sptr$0 i32)
    (local $_ i32)
    (local $match_result i32)
    (local $x i32)
 
    ;; execution start here:
    ;; Start of union contructor
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr ;; set struct pointer var
    local.get $Sptr ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field id
    i32.const 1 ;; push 1 on stack
    i32.store ;; store field in memory
    local.get $Sptr ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    i32.const 42 ;; push 42 on stack
    i32.store ;; store field in memory
    local.get $Sptr ;; push struct address to stack
    ;; end of struct contructor
    ;; End of union contructor
    call $fun_checkOption ;; call function fun_checkOption
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
    ;; Start of union contructor
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$0 ;; set struct pointer var
    local.get $Sptr$0 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field id
    i32.const 2 ;; push 2 on stack
    i32.store ;; store field in memory
    local.get $Sptr$0 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field data
    i32.const 0 ;; push 0 on stack
    i32.store ;; store field in memory
    local.get $Sptr$0 ;; push struct address to stack
    ;; end of struct contructor
    ;; End of union contructor
    call $fun_checkOption ;; call function fun_checkOption
    i32.const 0 ;; push 0 on stack
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
  (func $fun_checkOption (param $o i32) (result i32)  ;; function fun_checkOption
    ;; local variables declarations:
    (local $_ i32)
    (local $match_result i32)
    (local $x i32)
 
    (block $match_end  (result i32)
      ;; case for id: $1, label: Some
      local.get $o
      i32.load ;; load label
      i32.const 1 ;; put label id 1 on stack
      i32.eq ;; check if index is equal to target
      (if (then
      local.get $o
      i32.const 4 ;; offset of data field
      i32.add ;; add offset to base address
      i32.load ;; load data pointer
      br $match_end ;; break out of match
       )
      )
      ;; case for id: $2, label: None
      local.get $o
      i32.load ;; load label
      i32.const 2 ;; put label id 2 on stack
      i32.eq ;; check if index is equal to target
      (if (then
      local.get $o
      i32.const 4 ;; offset of data field
      i32.add ;; add offset to base address
      i32.load ;; load data pointer
      br $match_end ;; break out of match
       )
      )
      local.get $match_result ;; set result

    )
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)