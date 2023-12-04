(module
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $Sptr (;0;) (mut i32) (i32.const 0))
  (global $arr_ptr (;1;) (mut i32) (i32.const 0))
  (global $exit_code (;2;) (mut i32) (i32.const 0))
  (global $heap_base (;3;) i32 (i32.const 0))
  (global $i (;4;) (mut i32) (i32.const 0))
  (global $var_arr (;5;) (mut i32) (i32.const 0))
  (global $var_i (;6;) (mut i32) (i32.const 0))
  (global $var_len (;7;) (mut i32) (i32.const 0))
  (global $var_len2 (;8;) (mut i32) (i32.const 0))
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)   
    ;; execution start here:
    ;; Start of let
    (global.set $var_len ;; set local var, have been hoisted
      (i32.const 530000) ;; push 530000 on stack
    )
    ;; Start of let
    (global.set $var_arr ;; set local var, have been hoisted
      (if 
          (i32.le_s ;; check if length is <= 1
            (global.get $var_len) ;; get local var: var_len, have been hoisted
            (i32.const 1) ;; put one on stack
          )
        (then
          (global.set $exit_code ;; set exit code
            (i32.const 42) ;; error exit code push to stack
          )
          (unreachable) ;; exit program
        )
      )
      (global.set $arr_ptr ;; set struct pointer var, have been hoisted
        ;; start of struct contructor
        (global.set $Sptr ;; set struct pointer var, have been hoisted
          (i32.const 8) ;; size of struct
          (call $malloc) ;; call malloc function
        )
        (i32.store ;; store int field in memory
          (i32.add ;; add offset to base address
            (global.get $Sptr) ;; get struct pointer var, have been hoisted
            (i32.const 0) ;; push field offset to stack
          )
          ;; init field (data)
          (i32.const 0) ;; push 0 on stack
        )
        (i32.store ;; store int field in memory
          (i32.add ;; add offset to base address
            (global.get $Sptr) ;; get struct pointer var, have been hoisted
            (i32.const 4) ;; push field offset to stack
          )
          ;; init field (length)
          (global.get $var_len) ;; get local var: var_len, have been hoisted
        )
        (global.get $Sptr) ;; push struct address to stack, have been hoisted
        ;; end of struct contructor
      )
      (i32.store ;; store pointer to data
        (global.get $arr_ptr) ;; get struct pointer var, have been hoisted
        (i32.mul ;; multiply length with 4 to get size
          (global.get $var_len) ;; get local var: var_len, have been hoisted
          (i32.const 4) ;; 4 bytes
        )
        (call $malloc) ;; call malloc function
      )
      (global.set $i ;; , have been hoisted
        (i32.const 0)
      )
      (block $loop_exit 
        (loop $loop_begin 
          (br_if $loop_exit
            (i32.eq
              (global.get $var_len) ;; get local var: var_len, have been hoisted
              (global.get $i) ;; get i, have been hoisted
            )
          )
          (i32.store ;; store value in elem pos
            ;; start of loop body
            (i32.add ;; add offset to base address
              (i32.load ;; load data pointer
                (global.get $arr_ptr) ;; get struct pointer var, have been hoisted
              )
              (i32.mul ;; multiply index with byte offset
                (global.get $i) ;; get index, have been hoisted
                (i32.const 4) ;; byte offset
              )
            )
            (i32.const 100) ;; push 100 on stack
          )
          ;; end of loop body
          (global.set $i ;; write to i, have been hoisted
            (i32.add ;; add 1 to i
              (global.get $i) ;; get i, have been hoisted
              (i32.const 1) ;; increment by 1
            )
          )
          (br $loop_begin)
        )
      )
      (global.get $arr_ptr) ;; leave pointer to allocated array struct on stack, have been hoisted
    )
    ;; Start of let
    (global.set $var_len2 ;; set local var, have been hoisted
      ;; start array length node
      (i32.load offset=4
        (global.get $var_arr) ;; get local var: var_arr, have been hoisted
      )
      ;; end array length node
    )
    (if 
        (i32.eqz ;; invert assertion
          (i32.eq ;; equality check
            (global.get $var_len) ;; get local var: var_len, have been hoisted
            (global.get $var_len2) ;; get local var: var_len2, have been hoisted
          )
        )
      (then
        (global.set $exit_code ;; set exit code
          (i32.const 42) ;; error exit code push to stack
        )
        (unreachable) ;; exit program
      )
    )
    ;; Start of let
    (global.set $var_i ;; set local var, have been hoisted
      (i32.const 0) ;; push 0 on stack
    )
    (block $loop_exit$0 
      (loop $loop_begin$1 
        (br_if $loop_exit$0 ;; if false break
          (i32.eqz ;; evaluate loop condition
            (i32.lt_s
              (global.get $var_i) ;; get local var: var_i, have been hoisted
              ;; start array length node
              (i32.load offset=4
                (global.get $var_arr) ;; get local var: var_arr, have been hoisted
              )
              ;; end array length node
            )
          )
        )
        (drop ;; drop value of loop body
          (if 
              (i32.eqz ;; invert assertion
                (i32.eq ;; equality check
                  (if 
                      (i32.lt_s ;; check if index is >= 0
                        (global.get $var_i) ;; get local var: var_i, have been hoisted
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
                        (global.get $var_i) ;; get local var: var_i, have been hoisted
                        (i32.load offset=4
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
                  (i32.load ;; load value
                    (i32.add ;; add offset to base address
                      (i32.load ;; load data pointer
                        (global.get $var_arr) ;; get local var: var_arr, have been hoisted
                      )
                      (i32.mul ;; multiply index with byte offset
                        (global.get $var_i) ;; get local var: var_i, have been hoisted
                        (i32.const 4) ;; byte offset
                      )
                    )
                  )
                  ;; end array element access node
                  (i32.const 100) ;; push 100 on stack
                )
              )
            (then
              (global.set $exit_code ;; set exit code
                (i32.const 42) ;; error exit code push to stack
              )
              (unreachable) ;; exit program
            )
          )
          (global.set $var_i ;; set local var, have been hoisted
            (i32.add
              (global.get $var_i) ;; get local var: var_i, have been hoisted
              (i32.const 1) ;; push 1 on stack
            )
          )
          (global.get $var_i) ;; set local var, have been hoisted
        )
        (br $loop_begin$1) ;; jump to beginning of loop
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