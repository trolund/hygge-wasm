(module
  ;; types
  (type $A (struct (field (mut i32))))
  (type $B (struct (field (mut i32)) (field (ref null $A))))

  (global $var (;2;) (mut (ref null $A)) (ref.null $A))

  ;; functions
  (func $_start (;0;)  (result i32) 

    (local $var (ref $B))

    (local.set $var
      (struct.new $B
        (i32.const 0)
        (ref.null $A)
      )
    )

    (i32.const 0)
  )
  (export "_start" (func $_start))
)