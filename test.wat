(module
  (type $arr_i32 (;0;) (array (mut i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $heap_base (;1;) (mut i32) (i32.const 0))
  (global $var_arr (;2;) (mut (ref null $arr_i32)) (ref.null $arr_i32))
  (global $var_len (;3;) (mut i32) (i32.const 0))
  (global $var_val (;4;) (mut i32) (i32.const 0))
  (global $var_val2 (;5;) (mut i32) (i32.const 0))
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)   
    ;; execution start here:
    ;; Start of let
    (global.set $var_arr ;; set local var, have been hoisted
      (if 
          (i32.le_s ;; check if length is <= 1
            (i32.add
              (i32.const 2) ;; push 2 on stack
              (i32.const 2) ;; push 2 on stack
            )
            (i32.const 1) ;; put one on stack
          )
        (then
          (global.set $exit_code ;; set exit code
            (i32.const 42) ;; error exit code push to stack
          )
          (unreachable) ;; exit program
        )
      )
      (array.new $arr_i32
        (i32.add
          (i32.const 40) ;; push 40 on stack
          (i32.const 2) ;; push 2 on stack
        )
        (i32.add
          (i32.const 2) ;; push 2 on stack
          (i32.const 2) ;; push 2 on stack
        )
      )
    )
    ;; Start of let
    (global.set $var_len ;; set local var, have been hoisted
      (array.len ;; get length
        (global.get $var_arr) ;; get local var: var_arr, have been hoisted
      )
    )
    ;; Start of let
    (global.set $var_val ;; set local var, have been hoisted
      (if 
          (i32.lt_s ;; check if index is >= 0
            (i32.const 1) ;; push 1 on stack
            (i32.const 0) ;; put zero on stack
          )
        (then
          (global.set $exit_code ;; set exit code
            (i32.const 42) ;; error exit code push to stack
          )
          (unreachable) ;; exit program
        )
      )
      (if 
          (i32.ge_s ;; check if index is < length
            (i32.const 1) ;; push 1 on stack
            (array.len ;; get length
              (global.get $var_arr) ;; get local var: var_arr, have been hoisted
            )
          )
        (then
          (global.set $exit_code ;; set exit code
            (i32.const 42) ;; error exit code push to stack
          )
          (unreachable) ;; exit program
        )
      )
      (array.get $arr_i32
        (global.get $var_arr) ;; get local var: var_arr, have been hoisted
        (i32.const 1) ;; push 1 on stack
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (global.get $var_len) ;; get local var: var_len, have been hoisted
            (i32.const 4) ;; push 4 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (global.get $var_val) ;; get local var: var_val, have been hoisted
            (i32.const 42) ;; push 42 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    (drop ;; drop value of subtree
      (if 
          (i32.lt_s ;; check if index is >= 0
            (i32.const 1) ;; push 1 on stack
            (i32.const 0) ;; put zero on stack
          )
        (then
          (global.set $exit_code ;; set exit code
            (i32.const 42) ;; error exit code push to stack
          )
          (unreachable) ;; exit program
        )
      )
      (if 
          (i32.ge_s ;; check if index is < length
            (i32.const 1) ;; push 1 on stack
            (array.len ;; get length
              (global.get $var_arr) ;; get local var: var_arr, have been hoisted
            )
          )
        (then
          (global.set $exit_code ;; set exit code
            (i32.const 42) ;; error exit code push to stack
          )
          (unreachable) ;; exit program
        )
      )
      (array.set $arr_i32
        (global.get $var_arr) ;; get local var: var_arr, have been hoisted
        (i32.const 1) ;; push 1 on stack
        (i32.const 200) ;; push 200 on stack
      )
      (i32.const 200) ;; push 200 on stack
    )
    ;; Start of let
    (global.set $var_val2 ;; set local var, have been hoisted
      (if 
          (i32.lt_s ;; check if index is >= 0
            (i32.const 1) ;; push 1 on stack
            (i32.const 0) ;; put zero on stack
          )
        (then
          (global.set $exit_code ;; set exit code
            (i32.const 42) ;; error exit code push to stack
          )
          (unreachable) ;; exit program
        )
      )
      (if 
          (i32.ge_s ;; check if index is < length
            (i32.const 1) ;; push 1 on stack
            (array.len ;; get length
              (global.get $var_arr) ;; get local var: var_arr, have been hoisted
            )
          )
        (then
          (global.set $exit_code ;; set exit code
            (i32.const 42) ;; error exit code push to stack
          )
          (unreachable) ;; exit program
        )
      )
      (array.get $arr_i32
        (global.get $var_arr) ;; get local var: var_arr, have been hoisted
        (i32.const 1) ;; push 1 on stack
      )
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (global.get $var_val2) ;; get local var: var_val2, have been hoisted
            (i32.const 200) ;; push 200 on stack
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    ;; End of let
    ;; End of let
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)