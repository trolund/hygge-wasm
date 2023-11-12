(module
  (type $i32_=>_i32 (;0;) (func (param i32) (result i32)))
  (type $i32_i32_=>_i32 (;1;) (func (param i32) (param i32) (result i32)))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) i32.const 0)
  (global $fun_app*ptr (;1;) (mut i32) i32.const 4)
  (global $fun_makeShoppingList*ptr (;2;) (mut i32) i32.const 0)
  (global $fun_mil*ptr (;3;) (mut i32) i32.const 8)
  (global $fun_piz*ptr (;4;) (mut i32) i32.const 12)
  (global $heap_base (;5;) i32 i32.const 16)
  (global $var_c1 (;6;) (mut i32) i32.const 0)
  (global $var_c2 (;7;) (mut i32) i32.const 0)
  (global $var_l (;8;) (mut i32) i32.const 0)
  (global $var_l2 (;9;) (mut i32) i32.const 0)
  (table $func_table (;0;) 4 funcref)
  (elem (i32.const 0) (;0;) $fun_makeShoppingList)
  (elem (i32.const 1) (;1;) $fun_app)
  (elem (i32.const 2) (;2;) $fun_mil)
  (elem (i32.const 3) (;3;) $fun_piz)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    ;; Load expression to be applied as a function
    global.get $fun_makeShoppingList*ptr ;; get global var: fun_makeShoppingList*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $fun_makeShoppingList*ptr ;; get global var: fun_makeShoppingList*ptr
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    global.set $var_c1 ;; set local var, have been hoisted
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=0 ;; load field: addApples
    ;; End of field select
    i32.load offset=4 ;; load closure environment pointer
    i32.const 2 ;; push 2 on stack
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=0 ;; load field: addApples
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    drop
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=4 ;; load field: addMilke
    ;; End of field select
    i32.load offset=4 ;; load closure environment pointer
    i32.const 3 ;; push 3 on stack
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=4 ;; load field: addMilke
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    drop
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=8 ;; load field: addPizza
    ;; End of field select
    i32.load offset=4 ;; load closure environment pointer
    i32.const 4 ;; push 4 on stack
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=8 ;; load field: addPizza
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    drop
    ;; Start of let
    ;; Start of field select
    global.get $var_c1 ;; get local var: var_c1, have been hoisted
    i32.load offset=12 ;; load field: theList
    ;; End of field select
    global.set $var_l ;; set local var, have been hoisted
    ;; Start of field select
    global.get $var_l ;; get local var: var_l, have been hoisted
    i32.load offset=0 ;; load field: apple
    ;; End of field select
    i32.const 2 ;; push 2 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; Start of field select
    global.get $var_l ;; get local var: var_l, have been hoisted
    i32.load offset=4 ;; load field: milk
    ;; End of field select
    i32.const 3 ;; push 3 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; Start of field select
    global.get $var_l ;; get local var: var_l, have been hoisted
    i32.load offset=8 ;; load field: pizza
    ;; End of field select
    i32.const 4 ;; push 4 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; Start of let
    ;; Load expression to be applied as a function
    global.get $fun_makeShoppingList*ptr ;; get global var: fun_makeShoppingList*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $fun_makeShoppingList*ptr ;; get global var: fun_makeShoppingList*ptr
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    global.set $var_c2 ;; set local var, have been hoisted
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c2 ;; get local var: var_c2, have been hoisted
    i32.load offset=0 ;; load field: addApples
    ;; End of field select
    i32.load offset=4 ;; load closure environment pointer
    i32.const 5 ;; push 5 on stack
    ;; Start of field select
    global.get $var_c2 ;; get local var: var_c2, have been hoisted
    i32.load offset=0 ;; load field: addApples
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    drop
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c2 ;; get local var: var_c2, have been hoisted
    i32.load offset=0 ;; load field: addApples
    ;; End of field select
    i32.load offset=4 ;; load closure environment pointer
    i32.const 2 ;; push 2 on stack
    ;; Start of field select
    global.get $var_c2 ;; get local var: var_c2, have been hoisted
    i32.load offset=0 ;; load field: addApples
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    drop
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c2 ;; get local var: var_c2, have been hoisted
    i32.load offset=4 ;; load field: addMilke
    ;; End of field select
    i32.load offset=4 ;; load closure environment pointer
    i32.const 6 ;; push 6 on stack
    ;; Start of field select
    global.get $var_c2 ;; get local var: var_c2, have been hoisted
    i32.load offset=4 ;; load field: addMilke
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    drop
    ;; Load expression to be applied as a function
    ;; Start of field select
    global.get $var_c2 ;; get local var: var_c2, have been hoisted
    i32.load offset=8 ;; load field: addPizza
    ;; End of field select
    i32.load offset=4 ;; load closure environment pointer
    i32.const 7 ;; push 7 on stack
    ;; Start of field select
    global.get $var_c2 ;; get local var: var_c2, have been hoisted
    i32.load offset=8 ;; load field: addPizza
    ;; End of field select
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    drop
    ;; Start of let
    ;; Start of field select
    global.get $var_c2 ;; get local var: var_c2, have been hoisted
    i32.load offset=12 ;; load field: theList
    ;; End of field select
    global.set $var_l2 ;; set local var, have been hoisted
    ;; Start of field select
    global.get $var_l2 ;; get local var: var_l2, have been hoisted
    i32.load offset=0 ;; load field: apple
    ;; End of field select
    i32.const 7 ;; push 7 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; Start of field select
    global.get $var_l2 ;; get local var: var_l2, have been hoisted
    i32.load offset=4 ;; load field: milk
    ;; End of field select
    i32.const 6 ;; push 6 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; Start of field select
    global.get $var_l2 ;; get local var: var_l2, have been hoisted
    i32.load offset=8 ;; load field: pizza
    ;; End of field select
    i32.const 7 ;; push 7 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; End of let
    ;; End of let
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_app (;1;) (param $cenv i32) (param $arg_x i32) (result i32) 
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    ;; Start of field select
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load offset=0 ;; load field: apple
    ;; End of field select
    local.get $arg_x ;; get local var: arg_x
    i32.add
    i32.store offset=0 ;; store int in struct
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load offset=0 ;; load int from struct
  )
  (func $fun_makeShoppingList (;2;) (param $cenv i32) (result i32) 
    ;; local variables declarations:
    (local $Sptr i32)
    (local $Sptr$0 i32)
    (local $Sptr$1 i32)
    (local $Sptr$3 i32)
    (local $Sptr$4 i32)
    (local $Sptr$6 i32)
    (local $Sptr$7 i32)
    (local $Sptr$8 i32)
    (local $var_list i32)

    ;; Start of let
    ;; start of struct contructor
    i32.const 12 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr ;; set struct pointer var
    local.get $Sptr ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field apple
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field milk
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr ;; get struct pointer var
    i32.const 8 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field pizza
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr ;; push struct address to stack
    ;; end of struct contructor
    local.set $var_list ;; set local var
    ;; start of struct contructor
    i32.const 8 ;; size of struct
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
    i32.const 4 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$0 ;; set struct pointer var
    local.get $Sptr$0 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field list
    local.get $var_list ;; get local var: var_list
    i32.store ;; store int field in memory
    local.get $Sptr$0 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$1 ;; get pointer to return struct
    global.set $fun_app*ptr
    ;; start of struct contructor
    i32.const 8 ;; size of struct
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
    i32.const 4 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$3 ;; set struct pointer var
    local.get $Sptr$3 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field list
    local.get $var_list ;; get local var: var_list
    i32.store ;; store int field in memory
    local.get $Sptr$3 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$4 ;; get pointer to return struct
    global.set $fun_mil*ptr
    ;; start of struct contructor
    i32.const 8 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$7 ;; set struct pointer var
    local.get $Sptr$7 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field f
    i32.const 3 ;; push 3 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$7 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field env
    i32.const 0 ;; push 0 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$7 ;; push struct address to stack
    ;; end of struct contructor
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    ;; start of struct contructor
    i32.const 4 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$6 ;; set struct pointer var
    local.get $Sptr$6 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field list
    local.get $var_list ;; get local var: var_list
    i32.store ;; store int field in memory
    local.get $Sptr$6 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store poninter in return struct
    local.get $Sptr$7 ;; get pointer to return struct
    global.set $fun_piz*ptr
    ;; start of struct contructor
    i32.const 16 ;; size of struct
    call $malloc ;; call malloc function
    local.set $Sptr$8 ;; set struct pointer var
    local.get $Sptr$8 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field addApples
    global.get $fun_app*ptr ;; get global var: fun_app*ptr
    i32.store ;; store int field in memory
    local.get $Sptr$8 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field addMilke
    global.get $fun_mil*ptr ;; get global var: fun_mil*ptr
    i32.store ;; store int field in memory
    local.get $Sptr$8 ;; get struct pointer var
    i32.const 8 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field addPizza
    global.get $fun_piz*ptr ;; get global var: fun_piz*ptr
    i32.store ;; store int field in memory
    local.get $Sptr$8 ;; get struct pointer var
    i32.const 12 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field theList
    local.get $var_list ;; get local var: var_list
    i32.store ;; store int field in memory
    local.get $Sptr$8 ;; push struct address to stack
    ;; end of struct contructor
    ;; End of let
  )
  (func $fun_mil (;3;) (param $cenv i32) (param $arg_x$2 i32) (result i32) 
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    ;; Start of field select
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load offset=4 ;; load field: milk
    ;; End of field select
    local.get $arg_x$2 ;; get local var: arg_x$2
    i32.add
    i32.store offset=4 ;; store int in struct
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load offset=4 ;; load int from struct
  )
  (func $fun_piz (;4;) (param $cenv i32) (param $arg_x$5 i32) (result i32) 
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    ;; Start of field select
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load offset=8 ;; load field: pizza
    ;; End of field select
    local.get $arg_x$5 ;; get local var: arg_x$5
    i32.add
    i32.store offset=8 ;; store int in struct
    local.get 0 ;; get env pointer
    i32.load offset=0 ;; load value at offset: 0
    i32.load offset=8 ;; load int from struct
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (data (i32.const 8) "\02")
  (data (i32.const 12) "\03")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)