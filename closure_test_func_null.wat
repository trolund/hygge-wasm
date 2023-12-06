;; this eksample shows how to call a function with a null reference
;; the function $func takes a reference to a struct as its first parameter
;; the function _start calls $func with a null reference
;; the function $func returns 200
(type $A (struct (field (mut i32))))
(func $_start (;0;)  (result i32) 
    ;; call $func with a null reference
    (call $func 
      (ref.null $A) 
      (i32.const 10)
    )
  )

(func $func (param $cenv (ref null $A)) (param $x i32) (result i32)
  (i32.const 200)
)
(export "_start" (func $_start))