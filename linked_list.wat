(module
  (import "env" "writeInt" (func $writeInt (param i32) ))
  (type $Node (struct (field $next (ref null $Node)) (field $value (mut i32))))
  (global $global (mut (ref null $Node)) (ref.null $Node))
  (global $globalBox (mut (ref null $Boxer)) (ref.null $Boxer))
  (export "global" (global $global))
  (export "globalBox" (global $globalBox))
  (export "_start" (func $_start))
  (type $Boxer (struct (field $value i32)))

  (func $_start
    (local $i i32)
    (loop $loop
      (global.set $global
        (struct.new $Node
          (global.get $global)
          (local.get $i)
        )
      )
      (local.set $i
        (i32.add
          (local.get $i)
          (i32.const 1)
        )
      )
      ;; print value of node
      (call $writeInt
        (struct.get $Node 1
          (global.get $global)
        )
      )

      (br_if $loop
        (i32.le_u
          (local.get $i)
          (i32.const 1000)
        )
      )
    )

    (global.set $globalBox
      (struct.new $Boxer
        (i32.const 42)
      )
    )
    ;; value of struct
    (call $writeInt
      (struct.get $Boxer 0
        (global.get $globalBox)
      )
    )

  )
)