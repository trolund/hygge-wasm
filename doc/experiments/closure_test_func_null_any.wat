;; this eksample shows how to call a function with a null reference
;; the function $func takes a reference to a struct as its first parameter
;; the function _start calls $func with a null reference
;; the function $func returns 200
(type $clos (struct (field (mut i32))))
(type $p (struct (field (mut i32)) (field (ref null $clos))))
(func $_start (;0;)  (result i32 i32) 
    ;; call $func with a null reference
    ;; this is for functions that do not use the closure environment
    (call $func 
      (ref.null $p) 
      (i32.const 10)
    )

    ;; call $func0 with a clos struct reference
    ;; this is for functions that use the closure environment
    (call $func0 
      (struct.new $clos 
        (i32.const 200)
      )
      (i32.const 10)
    )
)
;; not using the closure environment
(func $func (param $cenv (ref null eq)) (param $x i32) (result i32)
  (local.get $x)
)
;; using the closure environment
(func $func0 (param $cenv (ref null eq)) (param $x i32) (result i32)
  ;; get the first field of the closure environment
  (local.get 0)
  (ref.cast (ref $clos))
  (struct.get $clos 0)
)
(export "_start" (func $_start))