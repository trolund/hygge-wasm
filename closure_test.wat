(type $code-f64-f64 (func (param $env (ref $clos-f64-f64)) (param $y f64) (result f64)))
(type $clos-f64-f64 (struct (field $code (ref $code-f64-f64)))
(type $inner-clos (struct (extend $clos-f64-f64) (field $x f64) (field $a f64))

(func $outer (param $x f64) (result (ref $clos-f64-f64))
  (struct.new $inner-clos
    (ref.func $inner)                       ;; code
    (local.get $x)                          ;; x
    (f64.add (local.get $x) (f64.const 1))  ;; a
  )  ;; (ref $clos-f64-f64) by subtyping
)

(func $inner (param $clos (ref $clos-f64-f64)) (param $y f64) (result f64)
  (local $env (ref $inner-clos))
  (local.set $env
    (ref.cast (local.get $clos) (rtt.get (ref $inner-clos)))
  )
  (local.get $y)
  (struct.get $inner-clos $a (local.get $env))
  (f64.add)
  (struct.get $inner-clos $x (local.get $env))
  (f64.add)
)

(func $caller (result f64)
  (local $clos (ref $clos-f64-f64))
  (local.set $clos (call $outer (f64.const 1)))
  (call_ref
    (local.get $clos)
    (f64.const 2)
    (struct.get $clos-f64-f64 $code (local.get $clos))
  )
)