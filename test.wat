(module
  (type $i32_=>_i32 (;0;) (func (param i32) (result i32)))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $fun_makeCounters*ptr (;1;) (mut i32) (i32.const 0))
  (global $fun_makeCounters/anonymous$3*ptr (;2;) (mut i32) (i32.const 8))
  (global $fun_makeCounters/anonymous*ptr (;3;) (mut i32) (i32.const 4))
  (global $heap_base (;4;) i32 (i32.const 12))
  (global $var_c1 (;5;) (mut i32) (i32.const 0))
  (global $var_c2 (;6;) (mut i32) (i32.const 0))
  (table $func_table (;0;) 3 funcref)
  (elem (i32.const 0) (;0;) $fun_makeCounters)
  (elem (i32.const 1) (;1;) $fun_makeCounters/anonymous)
  (elem (i32.const 2) (;2;) $fun_makeCounters/anonymous$3)
  (func $_start (;0;)   
    ;; execution start here:
    ;; Start of let
    ;; Load expression to be applied as a function
    global.get $fun_makeCounters*ptr ;; get global var: fun_makeCounters*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $fun_makeCounters*ptr ;; get global var: fun_makeCounters*ptr
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    global.set $var_c1 ;; set local var, have been promoted
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been promoted
    i32.load ;; load field: f1
    ;; End of field select
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been promoted
    i32.load ;; load field: f1
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    i32.const 1 ;; push 1 on stack
    i32.eq ;; equality check
    i32.eqz ;; invert assertion
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been promoted
    i32.load offset=4 ;; load field: f2
    ;; End of field select
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been promoted
    i32.load offset=4 ;; load field: f2
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    i32.const 2 ;; push 2 on stack
    i32.eq ;; equality check
    i32.eqz ;; invert assertion
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    ;; Start of let
    ;; Load expression to be applied as a function
    global.get $fun_makeCounters*ptr ;; get global var: fun_makeCounters*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $fun_makeCounters*ptr ;; get global var: fun_makeCounters*ptr
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    global.set $var_c2 ;; set local var, have been promoted
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c2 ;; get local var: var_c2, have been promoted
    i32.load offset=4 ;; load field: f2
    ;; End of field select
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of field select
    global.get $var_c2 ;; get local var: var_c2, have been promoted
    i32.load offset=4 ;; load field: f2
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    i32.const 1 ;; push 1 on stack
    i32.eq ;; equality check
    i32.eqz ;; invert assertion
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c2 ;; get local var: var_c2, have been promoted
    i32.load ;; load field: f1
    ;; End of field select
    i32.load offset=4 ;; load closure environment pointer
    ;; Start of field select
    global.get $var_c2 ;; get local var: var_c2, have been promoted
    i32.load ;; load field: f1
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    i32.const 2 ;; push 2 on stack
    i32.eq ;; equality check
    i32.eqz ;; invert assertion
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (func $fun_makeCounters (;1;) (param $cenv i32) (result i32) 
     ;; local variables declarations:
    (local $Sptr i32)
    (local $Sptr$0 i32)
    (local $Sptr$1 i32)
    (local $Sptr$2 i32)
    (local $Sptr$4 i32)
    (local $Sptr$5 i32)
    (local $var_i i32)

    ;; Start of let
    ;; start of struct contructor
    i32.const 4 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr ;; set struct pointer var
    local.get $Sptr ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field (value)
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr ;; push struct address to stack
    ;; end of struct contructor
    local.set $var_i ;; set local var
    ;; start of struct contructor
    i32.const 8 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$0 ;; set struct pointer var
    local.get $Sptr$0 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field (f1)
    ;; start of struct contructor
    i32.const 8 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$1 ;; set struct pointer var
    local.get $Sptr$1 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field (func)
    i32.const 1 ;; push 1 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$1 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field (cenv)
    ;; start of struct contructor
    i32.const 4 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$2 ;; set struct pointer var
    local.get $Sptr$2 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field (i)
    local.get $var_i ;; get local var: var_i
    i32.store ;; store int field in memory
    local.get $Sptr$2 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store int field in memory
    local.get $Sptr$1 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store int field in memory
    local.get $Sptr$0 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field (f2)
    ;; start of struct contructor
    i32.const 8 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$4 ;; set struct pointer var
    local.get $Sptr$4 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field (func)
    i32.const 2 ;; push 2 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$4 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field (cenv)
    ;; start of struct contructor
    i32.const 4 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$5 ;; set struct pointer var
    local.get $Sptr$5 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field (i)
    local.get $var_i ;; get local var: var_i
    i32.store ;; store int field in memory
    local.get $Sptr$5 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store int field in memory
    local.get $Sptr$4 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store int field in memory
    local.get $Sptr$0 ;; push struct address to stack
    ;; end of struct contructor
    ;; End of let
  )
  (func $fun_makeCounters/anonymous (;2;) (param $cenv i32) (result i32) 
    local.get 0 ;; get env pointer
    i32.load ;; load value at offset: 0
    local.get 0 ;; get env pointer
    i32.load ;; load value at offset: 0
    ;; Start of field select
    local.get 0 ;; get env pointer
    i32.load ;; load value at offset: 0
    i32.load ;; load field: value
    ;; End of field select
    i32.const 1 ;; push 1 on stack
    i32.add
    i32.store ;; store int in struct
    i32.load ;; load int from struct
  )
  (func $fun_makeCounters/anonymous$3 (;3;) (param $cenv i32) (result i32) 
    local.get 0 ;; get env pointer
    i32.load ;; load value at offset: 0
    local.get 0 ;; get env pointer
    i32.load ;; load value at offset: 0
    ;; Start of field select
    local.get 0 ;; get env pointer
    i32.load ;; load value at offset: 0
    i32.load ;; load field: value
    ;; End of field select
    i32.const 1 ;; push 1 on stack
    i32.add
    i32.store ;; store int in struct
    i32.load ;; load int from struct
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (data (i32.const 8) "\02")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)