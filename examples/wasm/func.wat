(module
  (func $add (param i32 i32) (result i32)
    local.get 0 ;; Get the first parameter
    local.get 1 ;; Get the second parameter
    i32.add)     ;; Add the two parameters

  (func $multiply (param i32 i32) (result i32)
    local.get 0 ;; Get the first parameter
    local.get 1 ;; Get the second parameter
    i32.mul)     ;; Multiply the two parameters

  (func $main
    ;; Call the add function with arguments 5 and 3
    i32.const 5
    i32.const 3
    call $add

    ;; Call the multiply function with arguments 7 and 2
    i32.const 7
    i32.const 2
    call $multiply
    drop) ;; Drop the unused result

  (export "main" (func $main))
)
