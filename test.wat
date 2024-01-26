(module
  (type $s_i32-eqref (;0;) (struct (field $func (mut i32)) (field $cenv (mut eqref))))
  (type $eq_i32_=>_i32 (;1;) (func (param (ref null eq)) (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $fun_g*ptr (;1;) (mut (ref null $s_i32-eqref)) (ref.null $s_i32-eqref))
  (global $heap_base (;2;) (mut i32) (i32.const 0))
  (table $func_table (;0;) 1 funcref)
  (elem (i32.const 0) (;0;) $fun_g)
  (func $_start (;0;)   
    ;; execution start here:
    (global.set $fun_g*ptr
      (struct.new $s_i32-eqref
        (i32.const 0) ;; put function index on stack
        (ref.null eq) ;; null ref
      )
    )
    (if 
      (i32.eqz ;; invert assertion
        (i32.eq ;; equality check
          ;; Load expression to be applied as a function
          (call_indirect (type $eq_i32_=>_i32) ;; call function
            (struct.get $s_i32-eqref 1 ;; load closure environment pointer
              (global.get $fun_g*ptr) ;; get global var: fun_g*ptr
            )
            (i32.const 10) ;; push 10 on stack
            (struct.get $s_i32-eqref 0 ;; load table index
              (global.get $fun_g*ptr) ;; get global var: fun_g*ptr
            )
          )
          (i32.const 50) ;; push 50 on stack
        )
      )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    ;; if execution reaches here, the program is successful
  )
  (func $fun_g (;1;) (param $cenv (ref null eq)) (param $arg_z i32) (result i32) 
    (if (result i32)
      (i32.lt_s
        (local.get $arg_z) ;; get local var: arg_z
        (i32.const 50) ;; push 50 on stack
      )
      (then
        ;; Load expression to be applied as a function
        (call_indirect (type $eq_i32_=>_i32) ;; call function
          (struct.get $s_i32-eqref 1 ;; load closure environment pointer
            (global.get $fun_g*ptr) ;; get global var: fun_g*ptr
          )
          (i32.add
            (local.get $arg_z) ;; get local var: arg_z
            (i32.const 1) ;; push 1 on stack
          )
          (struct.get $s_i32-eqref 0 ;; load table index
            (global.get $fun_g*ptr) ;; get global var: fun_g*ptr
          )
        )
      )
      (else
        (local.get $arg_z) ;; get local var: arg_z
      )
    )
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)