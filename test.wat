(module
  (type $i32_=>_i32 (;0;) (func (param i32) (result i32)))
  (import "env" "writeS" (;0;) (func $writeS (param i32) (param i32) ))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) i32.const 0)
  (global $fun_fail*ptr (;1;) (mut i32) i32.const 0)
  (global $heap_base (;2;) i32 i32.const 20)
  (table $func_table (;0;) 1 funcref)
  (elem (i32.const 0) (;0;) $fun_fail)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    i32.const 0 ;; push false on stack
    (if (result i32)
      (then
        ;; Load expression to be applied as a function
        global.get $fun_fail*ptr ;; get global var: fun_fail*ptr
        i32.load offset=4 ;; load closure environment pointer
        global.get $fun_fail*ptr ;; get global var: fun_fail*ptr
        i32.load ;; load table index
        call_indirect (type $i32_=>_i32) ;; call function
      )
      (else
        i32.const 0 ;; push 0 on stack
      )
    )
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_fail (;1;) (param $cenv i32) (result i32) 
    i32.const 0 ;; push false on stack
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    i32.const 4 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 4 ;; leave pointer to string on stack
    i32.load offset=4 ;; Load string length
    call $writeS ;; call host function
    i32.const 0 ;; push false on stack
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\10\00\00\00\04\00\00\00\04\00\00\00")
  (data (i32.const 16) "fail")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)