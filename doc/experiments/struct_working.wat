(module
  ;; types
  (type $A (struct (field (mut i32))))
  (type $B (struct (field (mut i32)) (field (mut i32))))
  (type $C (struct (field (mut i32)) (field (mut i32))))

  (global $var (;2;) (mut (ref null $A)) (ref.null $A))

  ;; functions
  (func $_start (;0;)  (result i32 i32 i32 i32 i32) 

    (ref.test (ref $B) ;; false!
      (struct.new $A
        (i32.const 10)
      )
    )

    (ref.test (ref $A) ;; false!
      (struct.new $B
        (i32.const 10)
        (i32.const 20)
      )
    )

    (ref.test (ref eq) ;; true!
      (struct.new $B
        (i32.const 10)
        (i32.const 20)
      )
    )

    (ref.test (ref $C) ;; true! 
      (struct.new $B
        (i32.const 10)
        (i32.const 20)
      )
    )

    (ref.test (ref $B) ;; false! 
      (struct.new $A
        (i32.const 10)
      )
    )

    (;
    
    (drop
      (ref.cast (ref $C) ;; casts! 
        (struct.new $B
          (i32.const 10)
          (i32.const 20)
        )
      )
    )
    ;)

    (;
    (drop
      (ref.cast (ref $A) ;; failes cast! 
        (struct.new $B
          (i32.const 10)
          (i32.const 20)
        )
      )
    )
    ;)
    (drop
      (ref.cast (ref eq) ;; true!
        (struct.new $A
          (i32.const 10)
        )
      )
    )

    (global.set $var
      (struct.new $A
        (i32.const 20)
      )
    )

    (drop 
      (ref.cast (ref $B)
        (global.get $var)
      )
    )

  )
  (export "_start" (func $_start))
)