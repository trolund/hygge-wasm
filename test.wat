(module
  (type $fun_makeCounter_type (func (param i32) (result i32)))
  (type $fun_makeCounter/anonymous_type (func (param i32) (result i32)))
  (import "env" "malloc" (func $malloc (param i32) (result i32)))
  (memory (export "memory") 1)
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (global $fun_makeCounter*ptr (mut i32) i32.const 0)
  (global $fun_makeCounter/anonymous*ptr (mut i32) i32.const 4)
  (global $heap_base i32 i32.const 8)
  (table $func_table 2 funcref)
  (elem (i32.const 0) $fun_makeCounter)
  (elem (i32.const 1) $fun_makeCounter/anonymous)
  (func $_start  (result i32) ;; entry point of program (main function)    ;; local variables declarations:
    (local $Sptr$1 i32)
    (local $Sptr$2 i32)
    (local $var_c1 i32)
    (local $var_c2 i32)
 
    ;; execution start here:
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_makeCounter*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    global.get $fun_makeCounter*ptr
    i32.load ;; load table index
    call_indirect (param i32) (result i32) ;; call function
    ;; end of application
    local.set $var_c1 ;; set local var
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_makeCounter*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    global.get $fun_makeCounter*ptr
    i32.load ;; load table index
    call_indirect (param i32) (result i32) ;; call function
    ;; end of application
    local.set $var_c2 ;; set local var
    ;; start of application
    ;; Load expression to be applied as a function
    local.get $var_c1
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    local.get $var_c1
    i32.load ;; load table index
    call_indirect (param i32) (result i32) ;; call function
    ;; end of application
    i32.const 22 ;; push 22 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      )
    ;; start of application
    ;; Load expression to be applied as a function
    local.get $var_c1
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    local.get $var_c1
    i32.load ;; load table index
    call_indirect (param i32) (result i32) ;; call function
    ;; end of application
    i32.const 22 ;; push 22 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      )
    ;; start of application
    ;; Load expression to be applied as a function
    local.get $var_c2
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    local.get $var_c2
    i32.load ;; load table index
    call_indirect (param i32) (result i32) ;; call function
    ;; end of application
    i32.const 22 ;; push 22 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      )
    ;; End of let
    ;; End of let
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
    i32.const 0 ;; push 0 on stack
    i32.store ;; store field in memory
    local.get $Sptr$2 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 100 ;; push 100 on stack
    i32.store ;; store field in memory
    local.get $Sptr$2 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 0 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$1 ;; set struct pointer var
    local.get $Sptr$1 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$2 ;; get pointer to return struct
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_makeCounter (param $cenv i32) (result i32) ;; function fun_makeCounter    ;; local variables declarations:
    (local $Sptr i32)
    (local $Sptr$0 i32)
    (local $var_x i32)
 
    ;; Start of let
    i32.const 22 ;; push 22 on stack
    local.set $var_x ;; set local var
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
    i32.const 1 ;; push 1 on stack
    i32.store ;; store field in memory
    local.get $Sptr$0 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 100 ;; push 100 on stack
    i32.store ;; store field in memory
    local.get $Sptr$0 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 0 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr ;; set struct pointer var
    local.get $Sptr ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$0 ;; get pointer to return struct
    ;; End of let
  )
  (func $fun_makeCounter/anonymous (param $cenv i32) (result i32) ;; function fun_makeCounter/anonymous 
    i32.const 22 ;; push 22 on stack
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)