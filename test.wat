(module
  (type $i32_i32_=>_i32 (func (param i32) (param i32) (result i32)))
  (import "env" "malloc" (func $malloc (param i32) (result i32)
))
  (memory (export "memory") 1)
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (global $fun_multiplier*ptr (mut i32) i32.const 0)
  (global $fun_multiplier/anonymous*ptr (mut i32) i32.const 4)
  (global $heap_base i32 i32.const 8)
  (global $var_multiplyByThree (mut i32) i32.const 0)
  (global $var_multiplyByTwo (mut i32) i32.const 0)
  (table $func_table 2 funcref)
  (elem (i32.const 0) $fun_multiplier)
  (elem (i32.const 1) $fun_multiplier/anonymous)
  (func $_start  (result i32) ;; entry point of program (main function)
 
    ;; execution start here:
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_multiplier*ptr ;; get global var: fun_multiplier*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    i32.const 2 ;; push 2 on stack
    global.get $fun_multiplier*ptr ;; get global var: fun_multiplier*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    global.set $var_multiplyByTwo ;; set local var, have been hoisted
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_multiplier*ptr ;; get global var: fun_multiplier*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    i32.const 3 ;; push 3 on stack
    global.get $fun_multiplier*ptr ;; get global var: fun_multiplier*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    global.set $var_multiplyByThree ;; set local var, have been hoisted
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $var_multiplyByTwo ;; get local var: var_multiplyByTwo, have been hoisted
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    i32.const 5 ;; push 5 on stack
    global.get $var_multiplyByTwo ;; get local var: var_multiplyByTwo, have been hoisted
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 10 ;; push 10 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $var_multiplyByThree ;; get local var: var_multiplyByThree, have been hoisted
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    i32.const 5 ;; push 5 on stack
    global.get $var_multiplyByThree ;; get local var: var_multiplyByThree, have been hoisted
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 15 ;; push 15 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
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
  (func $fun_multiplier (param $cenv i32) (param $factor i32) (result i32) ;; function fun_multiplier
    ;; local variables declarations:
    (local $Sptr i32)
    (local $Sptr$0 i32)
 
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
    i32.store ;; store int field in memory
    local.get $Sptr$0 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$0 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 1 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr ;; set struct pointer var
    local.get $Sptr ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field factor
    local.get $factor ;; get local var: factor
    i32.store ;; store int field in memory
    local.get $Sptr ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$0 ;; get pointer to return struct
  )
  (func $fun_multiplier/anonymous (param $cenv i32) (param $number i32) (result i32) ;; function fun_multiplier/anonymous
 
    local.get $number ;; get local var: number
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.mul
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)