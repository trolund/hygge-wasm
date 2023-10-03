(module
  (type $fun_f_type (func (param i32) (result i32)))
  (type $fun_g_type (func (param i32) ))
  (type $fun_h_type (func (param i32) (result i32)))
  (import "env" "malloc" (func $malloc (param i32) (result i32)))
  (memory (export "memory") 1)
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (data (i32.const 8) "\02")
  (global $fun_f (mut i32) i32.const 0)
  (global $fun_g (mut i32) i32.const 1)
  (global $fun_h (mut i32) i32.const 2)
  (global $heap_base i32 i32.const 12)
  (table $func_table 3 funcref)
  (elem (i32.const 0) $fun_f)
  (elem (i32.const 1) $fun_g)
  (elem (i32.const 2) $fun_h)
  (func $_start  (result i32) ;; entry point of program (main function) 
    ;; execution start here:
    i32.const 1 ;; push 1 on stack
    ;; Load expression to be applied as a function
    global.get $fun_h
    call_indirect (param i32) (result i32) ;; call function
    i32.const 42 ;; push 42 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      )
    i32.const 42 ;; push 42 on stack
    ;; Load expression to be applied as a function
    global.get $fun_h
    call_indirect (param i32) (result i32) ;; call function
    i32.const 1 ;; push 1 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if (then
      i32.const 42 ;; error exit code push to stack
      return ;; return exit code
       )
      )
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_f (param $x i32) (result i32) ;; function fun_f 
    local.get $x
    i32.const 42 ;; push 42 on stack
    i32.lt_s
  )
  (func $fun_g (param $b i32)  ;; function fun_g    ;; local variables declarations:
    (local $Sptr i32)
 
    local.get $b
    (if  (result i32)
     (then
      i32.const 42 ;; push 42 on stack

     )
     (else
      i32.const 1 ;; push 1 on stack

     )
    )
    ;; start of struct contructor
    i32.const 1 ;; size of struct
    i32.const 4 ;; 4 bytes
    i32.mul ;; multiply length with 4 to get size
    call $malloc ;; call malloc function
    local.set $Sptr ;; set struct pointer var
    local.get $Sptr ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field b
    local.get $b
    i32.store ;; store field in memory
    local.get $Sptr ;; push struct address to stack
    ;; end of struct contructor
  )
  (func $fun_h (param $y i32) (result i32) ;; function fun_h 
    local.get $y
    ;; Load expression to be applied as a function
    global.get $fun_f
    call_indirect (param i32) (result i32) ;; call function
    (if  (result i32)
     (then
      local.get $y
      ;; Load expression to be applied as a function
      global.get $fun_f
      call_indirect (param i32) (result i32) ;; call function
      ;; Load expression to be applied as a function
      global.get $fun_g
      call_indirect (param i32) (result i32) ;; call function

     )
     (else
      i32.const 0
      ;; Load expression to be applied as a function
      global.get $fun_g
      call_indirect (param i32) (result i32) ;; call function

     )
    )
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)