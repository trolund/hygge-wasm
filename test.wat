(module
  (type $fun_f_type (func (param i32) (result i32)))
  (type $fun_t_type (func (param i32) (result i32)))
  (memory (export "memory") 1)
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (global $heap_base i32 i32.const 8)
  (table $func_table 2 funcref)
  (elem (i32.const 0) $fun_t)
  (elem (i32.const 1) $fun_k)
  (func $_start  (result i32) ;; entry point of program (main function) 
    ref.func $fun_k  
    call $fun_t
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_k (param $x i32) (result i32) ;; function fun_f 
    local.get $x ;; push x on stack
    local.get $x ;; push x on stack
    i32.add ;; x + x
  )
  (func $fun_t (param $fun_k funcref) (result i32) ;; function fun_t 
    i32.const 2 ;; push 2 on stack
    call $fun_k ;; call fun_k
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)