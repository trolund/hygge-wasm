(module
  (type $i32_=>_i32 (func (param i32) (result i32)))
  (import "env" "malloc" (func $malloc (param i32) (result i32)))
  (memory (export "memory") 1)
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (data (i32.const 8) "\02")
  (global $fun_makeCounters*ptr (mut i32) i32.const 0)
  (global $fun_makeCounters/anonymous$2*ptr (mut i32) i32.const 8)
  (global $fun_makeCounters/anonymous*ptr (mut i32) i32.const 4)
  (global $heap_base i32 i32.const 12)
  (global $var_c1 (mut i32) i32.const 0)
  (global $var_c2 (mut i32) i32.const 0)
  (global $var_i (mut i32) i32.const 0)
  (table $func_table 3 funcref)
  (elem (i32.const 0) $fun_makeCounters)
  (elem (i32.const 1) $fun_makeCounters/anonymous)
  (elem (i32.const 2) $fun_makeCounters/anonymous$2)
  (func $_start  (result i32) ;; entry point of program (main function) 
    ;; execution start here:
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_makeCounters*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    global.get $fun_makeCounters*ptr
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    ;; end of application
    global.set $var_c1 ;; set local var, have been hoisted
    ;; start of application
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c1 ;; , have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    i32.load ;; load field
    ;; End of field select
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    ;; Start of field select
    global.get $var_c1 ;; , have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    i32.load ;; load field
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    ;; end of application
    i32.const 1 ;; push 1 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      )
    ;; start of application
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c1 ;; , have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    i32.load ;; load field
    ;; End of field select
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    ;; Start of field select
    global.get $var_c1 ;; , have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    i32.load ;; load field
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    ;; end of application
    i32.const 2 ;; push 2 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      )
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_makeCounters*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    global.get $fun_makeCounters*ptr
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    ;; end of application
    global.set $var_c2 ;; set local var, have been hoisted
    ;; start of application
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c2 ;; , have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    i32.load ;; load field
    ;; End of field select
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    ;; Start of field select
    global.get $var_c2 ;; , have been hoisted
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    i32.load ;; load field
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    ;; end of application
    i32.const 1 ;; push 1 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      )
    ;; start of application
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c2 ;; , have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    i32.load ;; load field
    ;; End of field select
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    ;; Start of field select
    global.get $var_c2 ;; , have been hoisted
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    i32.load ;; load field
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    ;; end of application
    i32.const 2 ;; push 2 on stack
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
  (func $fun_makeCounters (param $cenv i32) (result i32) ;; function fun_makeCounters    ;; local variables declarations:
    (local $Sptr i32)
    (local $Sptr$0 i32)
    (local $Sptr$1 i32)
    (local $Sptr$3 i32)
    (local $Sptr$4 i32)
 
    ;; Start of let
    i32.const 0 ;; push 0 on stack
    global.set $var_i ;; set local var, have been hoisted
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr ;; set struct pointer var
    local.get $Sptr ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f1
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$1 ;; set struct pointer var
    local.get $Sptr$1 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 1 ;; push 1 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$1 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$1 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 1 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$0 ;; set struct pointer var
    local.get $Sptr$0 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field i
    global.get $var_i ;; , have been hoisted
    i32.store ;; store int field in memory
    local.get $Sptr$0 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$1 ;; get pointer to return struct
    i32.store ;; store int field in memory
    local.get $Sptr ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f2
    ;; start of struct contructor
    i32.const 2 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$4 ;; set struct pointer var
    local.get $Sptr$4 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 2 ;; push 2 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$4 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$4 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 1 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr$3 ;; set struct pointer var
    local.get $Sptr$3 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field i
    global.get $var_i ;; , have been hoisted
    i32.store ;; store int field in memory
    local.get $Sptr$3 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$4 ;; get pointer to return struct
    i32.store ;; store int field in memory
    local.get $Sptr ;; push struct address to stack
    ;; end of struct contructor
    ;; End of let
  )
  (func $fun_makeCounters/anonymous (param $cenv i32) (result i32) ;; function fun_makeCounters/anonymous 
    local.get 0 ;; get env
    local.get 0
    i32.load offset=0
    i32.const 1 ;; push 1 on stack
    i32.add
    i32.store offset=0 ;; store i32 value in env
    local.get 0
    i32.load offset=0
  )
  (func $fun_makeCounters/anonymous$2 (param $cenv i32) (result i32) ;; function fun_makeCounters/anonymous$2 
    local.get 0 ;; get env
    local.get 0
    i32.load offset=0
    i32.const 1 ;; push 1 on stack
    i32.add
    i32.store offset=0 ;; store i32 value in env
    local.get 0
    i32.load offset=0
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)