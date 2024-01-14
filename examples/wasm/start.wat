(module
  (import "env" "writeTwoInts" (func $write (param i32) (param i32)))

  (func
    ;; create a local variable and initialize it to 0
    (local $i i32)

    (loop $my_loop

      ;; add one to $i
      local.get $i
      i32.const 1
      i32.add
      local.tee $i

      ;; log the current value of $i
      i32.const 0           ;; Memory offset (start of the buffer)
      local.get $i          ;; The value to print
      call $write

      ;; if $i is less than 10 branch to loop
      local.get $i
      i32.const 10
      i32.lt_s
      br_if $my_loop

    )
  )

  (start 1) ;; run the first function automatically
)
