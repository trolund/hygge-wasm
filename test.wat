(module
  (type $s_i32-eqref (;0;) (struct (field $func (mut i32)) (field $cenv (mut eqref))))
  (type $eq_i32_i32_=>_i32 (;1;) (func (param (ref null eq)) (param i32) (param i32) (result i32)))
  (type $eq_i32_=>_i32 (;2;) (func (param (ref null eq)) (param i32) (result i32)))
  (type $s_ (;3;) (struct ))
  (type $eq_eq_i32_=>_i32 (;4;) (func (param (ref null eq)) (param (ref null $s_i32-eqref)) (param i32) (result i32)))
  (type $eq_i32_=>_s_i32-eqref (;5;) (func (param (ref null eq)) (param i32) (result (ref null $s_i32-eqref))))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $fun_applyFunToInt*ptr (;1;) (mut (ref null $s_i32-eqref)) (ref.null $s_i32-eqref))
  (global $fun_f*ptr (;2;) (mut (ref null $s_i32-eqref)) (ref.null $s_i32-eqref))
  (global $fun_g*ptr (;3;) (mut (ref null $s_i32-eqref)) (ref.null $s_i32-eqref))
  (global $fun_h*ptr (;4;) (mut (ref null $s_i32-eqref)) (ref.null $s_i32-eqref))
  (global $fun_inc*ptr (;5;) (mut (ref null $s_i32-eqref)) (ref.null $s_i32-eqref))
  (global $fun_makeFun*ptr (;6;) (mut (ref null $s_i32-eqref)) (ref.null $s_i32-eqref))
  (global $fun_makeFun/anonymous*ptr (;7;) (mut (ref null $s_i32-eqref)) (ref.null $s_i32-eqref))
  (global $fun_privateFun*ptr (;8;) (mut (ref null $s_i32-eqref)) (ref.null $s_i32-eqref))
  (global $heap_base (;9;) (mut i32) (i32.const 0))
  (global $var_plusOne (;10;) (mut (ref null $s_i32-eqref)) (ref.null $s_i32-eqref))
  (global $var_plusTwo (;11;) (mut (ref null $s_i32-eqref)) (ref.null $s_i32-eqref))
  (global $var_x (;12;) (mut i32) (i32.const 0))
  (global $var_y (;13;) (mut i32) (i32.const 0))
  (global $var_z (;14;) (mut i32) (i32.const 0))
  (table $func_table (;0;) 8 funcref)
  (elem (i32.const 0) (;0;) $fun_f)
  (elem (i32.const 1) (;1;) $fun_g)
  (elem (i32.const 2) (;2;) $fun_h)
  (elem (i32.const 3) (;3;) $fun_privateFun)
  (elem (i32.const 4) (;4;) $fun_applyFunToInt)
  (elem (i32.const 5) (;5;) $fun_makeFun)
  (elem (i32.const 6) (;6;) $fun_inc)
  (elem (i32.const 7) (;7;) $fun_makeFun/anonymous)
  (func $_start (;0;)   
    ;; execution start here:
    (global.set $fun_f*ptr
      (struct.new $s_i32-eqref
        (i32.const 0) ;; put function index on stack
        (ref.null eq) ;; null ref
      )
    )
    (global.set $fun_g*ptr
      (struct.new $s_i32-eqref
        (i32.const 1) ;; put function index on stack
        (ref.null eq) ;; null ref
      )
    )
    ;; Start of let
    (global.set $var_x ;; set local var, have been hoisted
      ;; Load expression to be applied as a function
      (call_indirect (type $eq_i32_i32_=>_i32) ;; call function
        (struct.get $s_i32-eqref 1 ;; load closure environment pointer
          (global.get $fun_f*ptr) ;; get global var: fun_f*ptr
        )
        (i32.const 1) ;; push 1 on stack
        (i32.const 2) ;; push 2 on stack
        (struct.get $s_i32-eqref 0 ;; load table index
          (global.get $fun_f*ptr) ;; get global var: fun_f*ptr
        )
      )
    )
    ;; Start of let
    (global.set $var_y ;; set local var, have been hoisted
      ;; Load expression to be applied as a function
      (call_indirect (type $eq_i32_i32_=>_i32) ;; call function
        (struct.get $s_i32-eqref 1 ;; load closure environment pointer
          (global.get $fun_g*ptr) ;; get global var: fun_g*ptr
        )
        (i32.const 1) ;; push 1 on stack
        (i32.const 2) ;; push 2 on stack
        (struct.get $s_i32-eqref 0 ;; load table index
          (global.get $fun_g*ptr) ;; get global var: fun_g*ptr
        )
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (i32.add
              (global.get $var_x) ;; get local var: var_x, have been hoisted
              (i32.const 1) ;; push 1 on stack
            )
            (global.get $var_y) ;; get local var: var_y, have been hoisted
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (global.set $fun_h*ptr
      (struct.new $s_i32-eqref
        (i32.const 2) ;; put function index on stack
        (ref.null eq) ;; null ref
      )
    )
    ;; Start of let
    (global.set $var_z ;; set local var, have been hoisted
      ;; Load expression to be applied as a function
      (call_indirect (type $eq_i32_=>_i32) ;; call function
        (struct.get $s_i32-eqref 1 ;; load closure environment pointer
          (global.get $fun_h*ptr) ;; get global var: fun_h*ptr
        )
        (i32.const 40) ;; push 40 on stack
        (struct.get $s_i32-eqref 0 ;; load table index
          (global.get $fun_h*ptr) ;; get global var: fun_h*ptr
        )
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (global.get $var_z) ;; get local var: var_z, have been hoisted
            (i32.const 42) ;; push 42 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (global.set $fun_applyFunToInt*ptr
      (struct.new $s_i32-eqref
        (i32.const 4) ;; put function index on stack
        (ref.null eq) ;; null ref
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            ;; Load expression to be applied as a function
            (call_indirect (type $eq_eq_i32_=>_i32) ;; call function
              (struct.get $s_i32-eqref 1 ;; load closure environment pointer
                (global.get $fun_applyFunToInt*ptr) ;; get global var: fun_applyFunToInt*ptr
              )
              (global.get $fun_h*ptr) ;; get global var: fun_h*ptr
              (i32.const 1) ;; push 1 on stack
              (struct.get $s_i32-eqref 0 ;; load table index
                (global.get $fun_applyFunToInt*ptr) ;; get global var: fun_applyFunToInt*ptr
              )
            )
            (i32.const 3) ;; push 3 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (global.set $fun_makeFun*ptr
      (struct.new $s_i32-eqref
        (i32.const 5) ;; put function index on stack
        (ref.null eq) ;; null ref
      )
    )
    ;; Start of let
    (global.set $var_plusOne ;; set local var, have been hoisted
      ;; Load expression to be applied as a function
      (call_indirect (type $eq_i32_=>_s_i32-eqref) ;; call function
        (struct.get $s_i32-eqref 1 ;; load closure environment pointer
          (global.get $fun_makeFun*ptr) ;; get global var: fun_makeFun*ptr
        )
        (i32.const 1) ;; push true on stack
        (struct.get $s_i32-eqref 0 ;; load table index
          (global.get $fun_makeFun*ptr) ;; get global var: fun_makeFun*ptr
        )
      )
    )
    ;; Start of let
    (global.set $var_plusTwo ;; set local var, have been hoisted
      ;; Load expression to be applied as a function
      (call_indirect (type $eq_i32_=>_s_i32-eqref) ;; call function
        (struct.get $s_i32-eqref 1 ;; load closure environment pointer
          (global.get $fun_makeFun*ptr) ;; get global var: fun_makeFun*ptr
        )
        (i32.const 0) ;; push false on stack
        (struct.get $s_i32-eqref 0 ;; load table index
          (global.get $fun_makeFun*ptr) ;; get global var: fun_makeFun*ptr
        )
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            ;; Load expression to be applied as a function
            (call_indirect (type $eq_i32_=>_i32) ;; call function
              (struct.get $s_i32-eqref 1 ;; load closure environment pointer
                (global.get $var_plusOne) ;; get local var: var_plusOne, have been hoisted
              )
              (i32.const 42) ;; push 42 on stack
              (struct.get $s_i32-eqref 0 ;; load table index
                (global.get $var_plusOne) ;; get local var: var_plusOne, have been hoisted
              )
            )
            (i32.const 43) ;; push 43 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            ;; Load expression to be applied as a function
            (call_indirect (type $eq_i32_=>_i32) ;; call function
              (struct.get $s_i32-eqref 1 ;; load closure environment pointer
                (global.get $var_plusTwo) ;; get local var: var_plusTwo, have been hoisted
              )
              (i32.const 42) ;; push 42 on stack
              (struct.get $s_i32-eqref 0 ;; load table index
                (global.get $var_plusTwo) ;; get local var: var_plusTwo, have been hoisted
              )
            )
            (i32.const 44) ;; push 44 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            ;; Load expression to be applied as a function
            (call_indirect (type $eq_i32_=>_i32) ;; call function
              (struct.get $s_i32-eqref 1 ;; load closure environment pointer
                ;; Load expression to be applied as a function
                (call_indirect (type $eq_i32_=>_s_i32-eqref) ;; call function
                  (struct.get $s_i32-eqref 1 ;; load closure environment pointer
                    (global.get $fun_makeFun*ptr) ;; get global var: fun_makeFun*ptr
                  )
                  (i32.const 1) ;; push true on stack
                  (struct.get $s_i32-eqref 0 ;; load table index
                    (global.get $fun_makeFun*ptr) ;; get global var: fun_makeFun*ptr
                  )
                )
              )
              (i32.const 42) ;; push 42 on stack
              (struct.get $s_i32-eqref 0 ;; load table index
                ;; Load expression to be applied as a function
                (call_indirect (type $eq_i32_=>_s_i32-eqref) ;; call function
                  (struct.get $s_i32-eqref 1 ;; load closure environment pointer
                    (global.get $fun_makeFun*ptr) ;; get global var: fun_makeFun*ptr
                  )
                  (i32.const 1) ;; push true on stack
                  (struct.get $s_i32-eqref 0 ;; load table index
                    (global.get $fun_makeFun*ptr) ;; get global var: fun_makeFun*ptr
                  )
                )
              )
            )
            (i32.const 43) ;; push 43 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    ;; End of let
    ;; End of let
    ;; End of let
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (func $fun_applyFunToInt (;1;) (param $cenv (ref null eq)) (param $arg_f (ref null $s_i32-eqref)) (param $arg_x$3 i32) (result i32) 
    ;; Load expression to be applied as a function
    (call_indirect (type $eq_i32_=>_i32) ;; call function
      (struct.get $s_i32-eqref 1 ;; load closure environment pointer
        (local.get $arg_f) ;; get local var: arg_f
      )
      (local.get $arg_x$3) ;; get local var: arg_x$3
      (struct.get $s_i32-eqref 0 ;; load table index
        (local.get $arg_f) ;; get local var: arg_f
      )
    )
  )
  (func $fun_f (;2;) (param $cenv (ref null eq)) (param $arg_x i32) (param $arg_y i32) (result i32) 
    (i32.add
      (local.get $arg_x) ;; get local var: arg_x
      (local.get $arg_y) ;; get local var: arg_y
    )
  )
  (func $fun_g (;3;) (param $cenv (ref null eq)) (param $arg_x$0 i32) (param $arg_y$1 i32) (result i32) 
    (i32.add
      (i32.add
        (local.get $arg_x$0) ;; get local var: arg_x$0
        (local.get $arg_y$1) ;; get local var: arg_y$1
      )
      (i32.const 1) ;; push 1 on stack
    )
  )
  (func $fun_h (;4;) (param $cenv (ref null eq)) (param $arg_x$2 i32) (result i32) 
    (global.set $fun_privateFun*ptr
      (struct.new $s_i32-eqref
        (i32.const 3) ;; put function index on stack
        (ref.null eq) ;; null ref
      )
    )
    (global.set $fun_privateFun*ptr
      (struct.new $s_i32-eqref
        (i32.const 3) ;; push 3 on stack
        (struct.new $s_
        )
      )
    )
    ;; Load expression to be applied as a function
    (call_indirect (type $eq_i32_=>_i32) ;; call function
      (struct.get $s_i32-eqref 1 ;; load closure environment pointer
        (global.get $fun_privateFun*ptr) ;; get global var: fun_privateFun*ptr
      )
      (local.get $arg_x$2) ;; get local var: arg_x$2
      (struct.get $s_i32-eqref 0 ;; load table index
        (global.get $fun_privateFun*ptr) ;; get global var: fun_privateFun*ptr
      )
    )
  )
  (func $fun_inc (;5;) (param $cenv (ref null eq)) (param $arg_x$4 i32) (result i32) 
    (i32.add
      (local.get $arg_x$4) ;; get local var: arg_x$4
      (i32.const 1) ;; push 1 on stack
    )
  )
  (func $fun_makeFun (;6;) (param $cenv (ref null eq)) (param $arg_addOne i32) (result (ref null $s_i32-eqref)) 
    (if (result i32)
        (local.get $arg_addOne) ;; get local var: arg_addOne
      (then
        (global.set $fun_inc*ptr
          (struct.new $s_i32-eqref
            (i32.const 6) ;; put function index on stack
            (ref.null eq) ;; null ref
          )
        )
        (global.set $fun_inc*ptr
          (struct.new $s_i32-eqref
            (i32.const 6) ;; push 6 on stack
            (struct.new $s_
            )
          )
        )
        (global.get $fun_inc*ptr) ;; get global var: fun_inc*ptr
      )
      (else
        (struct.new $s_i32-eqref
          (i32.const 7) ;; push 7 on stack
          (struct.new $s_
          )
        )
      )
    )
  )
  (func $fun_makeFun/anonymous (;7;) (param $cenv (ref null eq)) (param $arg_x$5 i32) (result i32) 
    (i32.add
      (local.get $arg_x$5) ;; get local var: arg_x$5
      (i32.const 2) ;; push 2 on stack
    )
  )
  (func $fun_privateFun (;8;) (param $cenv (ref null eq)) (param $arg_z i32) (result i32) 
    (i32.add
      (local.get $arg_z) ;; get local var: arg_z
      (i32.const 2) ;; push 2 on stack
    )
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)