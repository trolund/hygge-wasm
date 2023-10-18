(module
  (import "env" "readInt" (func $readInt  (result i32)))
  (import "env" "writeInt" (func $writeInt (param i32) ))
  (import "env" "writeS" (func $writeS (param i32) (param i32) ))
  (memory (export "memory") 1)
  (data (i32.const 8) "FizzBuzz")
  (data (i32.const 32) "Fizz")
  (data (i32.const 48) "Buzz")
  (global $heap_base i32  i32.const 56
)  (func $_start  (result i32) ;; entry point of program (main function)    ;; local variables declarations:
    (local $var_by3 i32)
    (local $var_by5 i32)
    (local $var_i i32)
    (local $var_y i32)
 
    ;; execution start here:
    ;; Start of let
    i32.const 0 ;; push 0 on stack
    local.set $var_i ;; set local var
    ;; Start of let
    call $readInt ;; call host function
    local.set $var_y ;; set local var
    (block $loop_exit 
      (loop $loop_begin 
      local.get $var_i
      local.get $var_y
      i32.lt_s
      i32.eqz
      br_if $loop_exit
      ;; Start of let
      local.get $var_i
      i32.const 3 ;; push 3 on stack
      i32.rem_s
      i32.const 0 ;; push 0 on stack
      i32.eq
      local.set $var_by3 ;; set local var
      ;; Start of let
      local.get $var_i
      i32.const 5 ;; push 5 on stack
      i32.rem_s
      i32.const 0 ;; push 0 on stack
      i32.eq
      local.set $var_by5 ;; set local var
      local.get $var_by3
      (if 
     (then
      local.get $var_by5
      (if 
     (then
      i32.const 0 ;; offset in memory
      i32.const 8 ;; data pointer to store
      i32.store ;; store size in bytes
      i32.const 4 ;; offset in memory
      i32.const 16 ;; length to store
      i32.store ;; store data pointer
      i32.const 0 ;; leave pointer to string on stack
      i32.load ;; Load string pointer
      i32.const 0 ;; offset in memory
      i32.const 8 ;; data pointer to store
      i32.store ;; store size in bytes
      i32.const 4 ;; offset in memory
      i32.const 16 ;; length to store
      i32.store ;; store data pointer
      i32.const 0 ;; leave pointer to string on stack
      i32.const 4 ;; length offset
      i32.add ;; add offset to pointer
      i32.load ;; Load string length
      call $writeS ;; call host function

     )
     (else
      i32.const 24 ;; offset in memory
      i32.const 32 ;; data pointer to store
      i32.store ;; store size in bytes
      i32.const 28 ;; offset in memory
      i32.const 8 ;; length to store
      i32.store ;; store data pointer
      i32.const 24 ;; leave pointer to string on stack
      i32.load ;; Load string pointer
      i32.const 24 ;; offset in memory
      i32.const 32 ;; data pointer to store
      i32.store ;; store size in bytes
      i32.const 28 ;; offset in memory
      i32.const 8 ;; length to store
      i32.store ;; store data pointer
      i32.const 24 ;; leave pointer to string on stack
      i32.const 4 ;; length offset
      i32.add ;; add offset to pointer
      i32.load ;; Load string length
      call $writeS ;; call host function

     )
    )

     )
     (else
      local.get $var_by5
      (if 
     (then
      i32.const 40 ;; offset in memory
      i32.const 48 ;; data pointer to store
      i32.store ;; store size in bytes
      i32.const 44 ;; offset in memory
      i32.const 8 ;; length to store
      i32.store ;; store data pointer
      i32.const 40 ;; leave pointer to string on stack
      i32.load ;; Load string pointer
      i32.const 40 ;; offset in memory
      i32.const 48 ;; data pointer to store
      i32.store ;; store size in bytes
      i32.const 44 ;; offset in memory
      i32.const 8 ;; length to store
      i32.store ;; store data pointer
      i32.const 40 ;; leave pointer to string on stack
      i32.const 4 ;; length offset
      i32.add ;; add offset to pointer
      i32.load ;; Load string length
      call $writeS ;; call host function

     )
     (else
      local.get $var_i
      call $writeInt ;; call host function

     )
    )

     )
    )
      ;; End of let
      ;; End of let
      local.get $var_i
      i32.const 1 ;; push 1 on stack
      i32.add
      local.set $var_i ;; set local var
      br $loop_begin

)
      nop

    )
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (export "_start" (func $_start))
  (export "heap_base_ptr" (global $heap_base))
)