(module
  
  (type $add-func (func (param i32 i32) (result i32)))
  (type $sub-func (func (param i32 i32) (result i32)))
  (table $func-table 2 funcref) ;; Define a function table with space for 2 function pointers

  (elem (i32.const 0) $add) ;; Populate the function table with function pointers
  (elem (i32.const 1) $sub)

  (func $add (type $add-func) (param $a i32) (param $b i32) (result i32)
    (local.get $a)
    (local.get $b)
    (i32.add)
  )

  (func $sub (type $sub-func) (param $a i32) (param $b i32) (result i32)
    (local.get $a)
    (local.get $b)
    (i32.sub)
  )

  (func (export "_start") (result i32)
    (i32.const 4) ;; arg 1
    (i32.const 4) ;; arg 2
    (i32.const 1) ;; index of function
    (call_indirect (type $add-func)) ;; Call the function indirectly
    return
  )
)