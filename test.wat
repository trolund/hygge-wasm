(module
  (type $i32_i32_=>_i32 (func (param i32) (param i32) (result i32)))
  (type $i32_i32_i32_=>_i32 (func (param i32) (param i32) (param i32) (result i32)))
  (import "env" "malloc" (func $malloc (param i32) (result i32)
))
  (memory (export "memory") 1)
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (data (i32.const 8) "\02")
  (data (i32.const 12) "\03")
  (data (i32.const 16) "\04")
  (data (i32.const 20) "\05")
  (data (i32.const 24) "\06")
  (data (i32.const 28) "\07")
  (global $fun_applyFunToInt*ptr (mut i32) i32.const 16)
  (global $fun_f*ptr (mut i32) i32.const 0)
  (global $fun_g*ptr (mut i32) i32.const 4)
  (global $fun_h*ptr (mut i32) i32.const 8)
  (global $fun_inc*ptr (mut i32) i32.const 24)
  (global $fun_makeFun*ptr (mut i32) i32.const 20)
  (global $fun_makeFun/anonymous*ptr (mut i32) i32.const 28)
  (global $fun_privateFun*ptr (mut i32) i32.const 12)
  (global $heap_base i32 i32.const 32)
  (global $var_plusOne (mut i32) i32.const 0)
  (global $var_plusTwo (mut i32) i32.const 0)
  (global $var_x (mut i32) i32.const 0)
  (global $var_y (mut i32) i32.const 0)
  (global $var_z (mut i32) i32.const 0)
  (table $func_table 8 funcref)
  (elem (i32.const 0) $fun_f)
  (elem (i32.const 1) $fun_g)
  (elem (i32.const 2) $fun_h)
  (elem (i32.const 3) $fun_privateFun)
  (elem (i32.const 4) $fun_applyFunToInt)
  (elem (i32.const 5) $fun_makeFun)
  (elem (i32.const 6) $fun_inc)
  (elem (i32.const 7) $fun_makeFun/anonymous)
  (func $_start  (result i32) ;; entry point of program (main function)
 
    ;; execution start here:
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f*ptr ;; get global var: fun_f*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    i32.const 1 ;; push 1 on stack
    i32.const 2 ;; push 2 on stack
    global.get $fun_f*ptr ;; get global var: fun_f*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    global.set $var_x ;; set local var, have been hoisted
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_g*ptr ;; get global var: fun_g*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    i32.const 1 ;; push 1 on stack
    i32.const 2 ;; push 2 on stack
    global.get $fun_g*ptr ;; get global var: fun_g*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    global.set $var_y ;; set local var, have been hoisted
    global.get $var_x ;; get local var: var_x, have been hoisted
    i32.const 1 ;; push 1 on stack
    i32.add
    global.get $var_y ;; get local var: var_y, have been hoisted
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
    global.get $fun_h*ptr ;; get global var: fun_h*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    i32.const 40 ;; push 40 on stack
    global.get $fun_h*ptr ;; get global var: fun_h*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    global.set $var_z ;; set local var, have been hoisted
    global.get $var_z ;; get local var: var_z, have been hoisted
    i32.const 42 ;; push 42 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_applyFunToInt*ptr ;; get global var: fun_applyFunToInt*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    global.get $fun_h*ptr ;; get global var: fun_h*ptr
    i32.const 1 ;; push 1 on stack
    global.get $fun_applyFunToInt*ptr ;; get global var: fun_applyFunToInt*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 3 ;; push 3 on stack
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
    global.get $fun_makeFun*ptr ;; get global var: fun_makeFun*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    i32.const 1
    global.get $fun_makeFun*ptr ;; get global var: fun_makeFun*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    global.set $var_plusOne ;; set local var, have been hoisted
    ;; Start of let
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_makeFun*ptr ;; get global var: fun_makeFun*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    i32.const 0
    global.get $fun_makeFun*ptr ;; get global var: fun_makeFun*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    global.set $var_plusTwo ;; set local var, have been hoisted
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $var_plusOne ;; get local var: var_plusOne, have been hoisted
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    i32.const 42 ;; push 42 on stack
    global.get $var_plusOne ;; get local var: var_plusOne, have been hoisted
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 43 ;; push 43 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $var_plusTwo ;; get local var: var_plusTwo, have been hoisted
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    i32.const 42 ;; push 42 on stack
    global.get $var_plusTwo ;; get local var: var_plusTwo, have been hoisted
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 44 ;; push 44 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      )
    ;; start of application
    ;; Load expression to be applied as a function
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_makeFun*ptr ;; get global var: fun_makeFun*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    i32.const 1
    global.get $fun_makeFun*ptr ;; get global var: fun_makeFun*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    i32.const 42 ;; push 42 on stack
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_makeFun*ptr ;; get global var: fun_makeFun*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    i32.const 1
    global.get $fun_makeFun*ptr ;; get global var: fun_makeFun*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 43 ;; push 43 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      )
    ;; End of let
    ;; End of let
    ;; End of let
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_applyFunToInt (param $cenv i32) (param $f i32) (param $x i32) (result i32) ;; function fun_applyFunToInt
 
    ;; start of application
    ;; Load expression to be applied as a function
    local.get $f ;; get local var: f
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    local.get $x ;; get local var: x
    local.get $f ;; get local var: f
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
  )
  (func $fun_f (param $cenv i32) (param $x i32) (param $y i32) (result i32) ;; function fun_f
 
    local.get $x ;; get local var: x
    local.get $y ;; get local var: y
    i32.add
  )
  (func $fun_g (param $cenv i32) (param $x i32) (param $y i32) (result i32) ;; function fun_g
 
    local.get $x ;; get local var: x
    local.get $y ;; get local var: y
    i32.add
    i32.const 1 ;; push 1 on stack
    i32.add
  )
  (func $fun_h (param $cenv i32) (param $x i32) (result i32) ;; function fun_h
 
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_privateFun*ptr ;; get global var: fun_privateFun*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    local.get $x ;; get local var: x
    global.get $fun_privateFun*ptr ;; get global var: fun_privateFun*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
  )
  (func $fun_inc (param $cenv i32) (param $x i32) (result i32) ;; function fun_inc
 
    local.get $x ;; get local var: x
    i32.const 1 ;; push 1 on stack
    i32.add
  )
  (func $fun_makeFun (param $cenv i32) (param $addOne i32) (result i32) ;; function fun_makeFun
    ;; local variables declarations:
    (local $Sptr i32)
    (local $Sptr$0 i32)
 
    local.get $addOne ;; get local var: addOne
    (if  (result i32)
     (then
      global.get $fun_inc*ptr ;; get global var: fun_inc*ptr

     )
     (else
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
      i32.const 7 ;; push 7 on stack
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
      i32.const 0 ;; size of struct
      i32.const 4 ;; 4 bytes
      i32.mul ;; multiply length with 4 to get size
      call $malloc ;; call malloc function
      local.set $Sptr ;; set struct pointer var
      local.get $Sptr ;; push struct address to stack
      ;; end of struct contructor
      i32.store ;; store poninter in return struct
      local.get $Sptr$0 ;; get pointer to return struct

     )
    )
  )
  (func $fun_makeFun/anonymous (param $cenv i32) (param $x i32) (result i32) ;; function fun_makeFun/anonymous
 
    local.get $x ;; get local var: x
    i32.const 2 ;; push 2 on stack
    i32.add
  )
  (func $fun_privateFun (param $cenv i32) (param $z i32) (result i32) ;; function fun_privateFun
 
    local.get $z ;; get local var: z
    i32.const 2 ;; push 2 on stack
    i32.add
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)