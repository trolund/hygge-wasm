(module
  (type $i32_i32_i32_=>_i32 (;0;) (func (param i32) (param i32) (param i32) (result i32)))
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (import "env" "readInt" (;1;) (func $readInt  (result i32)))
  (import "env" "writeInt" (;2;) (func $writeInt (param i32) (param i32) ))
  (import "env" "writeS" (;3;) (func $writeS (param i32) (param i32) (param i32) ))
  (memory (;0;) (export "memory") 1)
  (global $Sptr (;0;) (mut i32) (i32.const 0))
  (global $Sptr$2 (;1;) (mut i32) (i32.const 0))
  (global $Sptr$5 (;2;) (mut i32) (i32.const 0))
  (global $arr_ptr (;3;) (mut i32) (i32.const 0))
  (global $arr_slice_ptr (;4;) (mut i32) (i32.const 0))
  (global $exit_code (;5;) (mut i32) (i32.const 0))
  (global $fun_f*ptr (;6;) (mut i32) (i32.const 38))
  (global $heap_base (;7;) i32 (i32.const 134))
  (global $i (;8;) (mut i32) (i32.const 0))
  (global $match_var__ (;9;) (mut i32) (i32.const 0))
  (global $match_var_v (;10;) (mut i32) (i32.const 0))
  (global $var_arr (;11;) (mut i32) (i32.const 0))
  (global $var_o (;12;) (mut i32) (i32.const 0))
  (global $var_sliced (;13;) (mut i32) (i32.const 0))
  (global $var_x (;14;) (mut i32) (i32.const 0))
  (table $func_table (;0;) 1 funcref)
  (elem (i32.const 0) (;0;) $fun_f)
  (func $_start (;0;)   
    ;; execution start here:
    ;; Start of let
    (global.set $var_x ;; set local var, have been promoted
      (call $readInt) ;; call host function
    )
    (i32.load ;; Load string pointer
      (i32.const 0) ;; leave pointer to string on stack
    )
    (i32.load offset=4
      (i32.const 0) ;; leave pointer to string on stack
    )
    (i32.const 1) ;; newline
    (call $writeS) ;; call host function
    ;; Start of let
    (global.set $var_arr ;; set local var, have been promoted
      (if 
          (i32.le_s ;; check if length is <= 1
            (global.get $var_x) ;; get local var: var_x, have been promoted
            (i32.const 1) ;; put one on stack
          )
        (then
          (global.set $exit_code ;; set exit code
            (i32.const 42) ;; error exit code push to stack
          )
          (unreachable) ;; exit program
        )
      )
      (global.set $arr_ptr ;; set struct pointer var, have been promoted
        ;; start of struct contructor
        (global.set $Sptr ;; set struct pointer var, have been promoted
          (i32.const 8) ;; size of struct
          (call $malloc) ;; call malloc function
        )
        (i32.store ;; store int field in memory
          (i32.add ;; add offset to base address
            (global.get $Sptr) ;; get struct pointer var, have been promoted
            (i32.const 0) ;; push field offset to stack
          )
          ;; init field (data)
          (i32.const 0) ;; push 0 on stack
        )
        (i32.store ;; store int field in memory
          (i32.add ;; add offset to base address
            (global.get $Sptr) ;; get struct pointer var, have been promoted
            (i32.const 4) ;; push field offset to stack
          )
          ;; init field (length)
          (global.get $var_x) ;; get local var: var_x, have been promoted
        )
        (global.get $Sptr) ;; push struct address to stack, have been promoted
        ;; end of struct contructor
      )
      (i32.store ;; store pointer to data
        (global.get $arr_ptr) ;; get struct pointer var, have been promoted
        (i32.mul ;; multiply length with 4 to get size
          (global.get $var_x) ;; get local var: var_x, have been promoted
          (i32.const 4) ;; 4 bytes
        )
        (call $malloc) ;; call malloc function
      )
      (global.set $i ;; , have been promoted
        (i32.const 0)
      )
      (block $loop_exit 
        (loop $loop_begin 
          (br_if $loop_exit
            (i32.eq
              (global.get $var_x) ;; get local var: var_x, have been promoted
              (global.get $i) ;; get i, have been promoted
            )
          )
          (i32.store ;; store value in elem pos
            ;; start of loop body
            (i32.add ;; add offset to base address
              (i32.load ;; load data pointer
                (global.get $arr_ptr) ;; get struct pointer var, have been promoted
              )
              (i32.mul ;; multiply index with byte offset
                (global.get $i) ;; get index, have been promoted
                (i32.const 4) ;; byte offset
              )
            )
            (i32.const 0) ;; push 0 on stack
          )
          ;; end of loop body
          (global.set $i ;; write to i, have been promoted
            (i32.add ;; add 1 to i
              (global.get $i) ;; get i, have been promoted
              (i32.const 1) ;; increment by 1
            )
          )
          (br $loop_begin)
        )
      )
      (global.get $arr_ptr) ;; leave pointer to allocated array struct on stack, have been promoted
    )
    (drop ;; drop value of subtree
      ;; Load expression to be applied as a function
      (call_indirect (type $i32_i32_i32_=>_i32) ;; call function
        (i32.load offset=4
          (global.get $fun_f*ptr) ;; get global var: fun_f*ptr
        )
        (global.get $var_arr) ;; get local var: var_arr, have been promoted
        (i32.div_s
          (global.get $var_x) ;; get local var: var_x, have been promoted
          (i32.const 2) ;; push 2 on stack
        )
        (i32.load ;; load table index
          (global.get $fun_f*ptr) ;; get global var: fun_f*ptr
        )
      )
    )
    (drop ;; drop value of subtree
      (global.set $var_x ;; set local var, have been promoted
        (i32.const 0) ;; push 0 on stack
      )
      (global.get $var_x) ;; set local var, have been promoted
    )
    (drop ;; drop value of the body
      (if 
          (i32.lt_s ;; check if index is >= 0
            (global.get $var_x) ;; get local var: var_x, have been promoted
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
            (global.get $var_x) ;; get local var: var_x, have been promoted
            (i32.load offset=4
              (global.get $var_arr) ;; get local var: var_arr, have been promoted
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
            (global.get $var_arr) ;; get local var: var_arr, have been promoted
          )
          (i32.mul ;; multiply index with byte offset
            (global.get $var_x) ;; get local var: var_x, have been promoted
            (i32.const 4) ;; byte offset
          )
        )
      )
      ;; end array element access node
      (i32.const 1) ;; newline
      (call $writeInt) ;; call host function
      (global.set $var_x ;; set local var, have been promoted
        (i32.add
          (global.get $var_x) ;; get local var: var_x, have been promoted
          (i32.const 1) ;; push 1 on stack
        )
      )
      (global.get $var_x) ;; set local var, have been promoted
    )
    (block $loop_exit$0 
      (loop $loop_begin$1 
        (br_if $loop_exit$0 ;; if false break
          (i32.eqz ;; evaluate loop condition
            (i32.lt_s
              (global.get $var_x) ;; get local var: var_x, have been promoted
              ;; start array length node
              (i32.load offset=4
                (global.get $var_arr) ;; get local var: var_arr, have been promoted
              )
              ;; end array length node
            )
          )
        )
        (drop ;; drop value of loop body
          (if 
              (i32.lt_s ;; check if index is >= 0
                (global.get $var_x) ;; get local var: var_x, have been promoted
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
                (global.get $var_x) ;; get local var: var_x, have been promoted
                (i32.load offset=4
                  (global.get $var_arr) ;; get local var: var_arr, have been promoted
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
                (global.get $var_arr) ;; get local var: var_arr, have been promoted
              )
              (i32.mul ;; multiply index with byte offset
                (global.get $var_x) ;; get local var: var_x, have been promoted
                (i32.const 4) ;; byte offset
              )
            )
          )
          ;; end array element access node
          (i32.const 1) ;; newline
          (call $writeInt) ;; call host function
          (global.set $var_x ;; set local var, have been promoted
            (i32.add
              (global.get $var_x) ;; get local var: var_x, have been promoted
              (i32.const 1) ;; push 1 on stack
            )
          )
          (global.get $var_x) ;; set local var, have been promoted
        )
        (br $loop_begin$1) ;; jump to beginning of loop
      )
    )
    (i32.load ;; Load string pointer
      (i32.const 42) ;; leave pointer to string on stack
    )
    (i32.load offset=4
      (i32.const 42) ;; leave pointer to string on stack
    )
    (i32.const 1) ;; newline
    (call $writeS) ;; call host function
    ;; Start of let
    (global.set $var_sliced ;; set local var, have been promoted
      ;; start array slice
      (if 
          (i32.lt_s ;; check if difference is < 1
            (i32.sub ;; subtract end from start
              ;; start array length node
              (i32.load offset=4
                (global.get $var_arr) ;; get local var: var_arr, have been promoted
              )
              ;; end array length node
              (i32.div_s
                (global.get $var_x) ;; get local var: var_x, have been promoted
                (i32.const 2) ;; push 2 on stack
              )
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
      (if 
          (i32.gt_s ;; check if end is < length
            ;; start array length node
            (i32.load offset=4
              (global.get $var_arr) ;; get local var: var_arr, have been promoted
            )
            ;; end array length node
            (i32.load offset=4
              (global.get $var_arr) ;; get local var: var_arr, have been promoted
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
          (i32.lt_s ;; check if start is >= 0
            (i32.div_s
              (global.get $var_x) ;; get local var: var_x, have been promoted
              (i32.const 2) ;; push 2 on stack
            )
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
          (i32.ge_s ;; check if start is < length
            (i32.div_s
              (global.get $var_x) ;; get local var: var_x, have been promoted
              (i32.const 2) ;; push 2 on stack
            )
            (i32.load offset=4
              (global.get $var_arr) ;; get local var: var_arr, have been promoted
            )
          )
        (then
          (global.set $exit_code ;; set exit code
            (i32.const 42) ;; error exit code push to stack
          )
          (unreachable) ;; exit program
        )
      )
      (global.set $arr_slice_ptr ;; set struct pointer var, have been promoted
        ;; start of struct contructor
        (global.set $Sptr$2 ;; set struct pointer var, have been promoted
          (i32.const 8) ;; size of struct
          (call $malloc) ;; call malloc function
        )
        (i32.store ;; store int field in memory
          (i32.add ;; add offset to base address
            (global.get $Sptr$2) ;; get struct pointer var, have been promoted
            (i32.const 0) ;; push field offset to stack
          )
          ;; init field (data)
          (i32.const 0) ;; push 0 on stack
        )
        (i32.store ;; store int field in memory
          (i32.add ;; add offset to base address
            (global.get $Sptr$2) ;; get struct pointer var, have been promoted
            (i32.const 4) ;; push field offset to stack
          )
          ;; init field (length)
          (i32.sub
            ;; start array length node
            (i32.load offset=4
              (global.get $var_arr) ;; get local var: var_arr, have been promoted
            )
            ;; end array length node
            (i32.div_s
              (global.get $var_x) ;; get local var: var_x, have been promoted
              (i32.const 2) ;; push 2 on stack
            )
          )
        )
        (global.get $Sptr$2) ;; push struct address to stack, have been promoted
        ;; end of struct contructor
      )
      (i32.store ;; store pointer to data
        (global.get $arr_slice_ptr) ;; get struct pointer var, have been promoted
        (i32.add ;; add offset to base address
          (i32.load ;; Load data pointer from array struct
            (global.get $var_arr) ;; get local var: var_arr, have been promoted
          )
          (i32.mul ;; multiply index with byte offset
            (i32.div_s
              (global.get $var_x) ;; get local var: var_x, have been promoted
              (i32.const 2) ;; push 2 on stack
            )
            (i32.const 4) ;; offset of data field
          )
        )
      )
      (global.get $arr_slice_ptr) ;; leave pointer to allocated array struct on stack, have been promoted
      ;; end array slice
    )
    (drop ;; drop value of subtree
      (global.set $var_x ;; set local var, have been promoted
        (i32.const 0) ;; push 0 on stack
      )
      (global.get $var_x) ;; set local var, have been promoted
    )
    (drop ;; drop value of the body
      (if 
          (i32.lt_s ;; check if index is >= 0
            (global.get $var_x) ;; get local var: var_x, have been promoted
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
            (global.get $var_x) ;; get local var: var_x, have been promoted
            (i32.load offset=4
              (global.get $var_sliced) ;; get local var: var_sliced, have been promoted
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
            (global.get $var_sliced) ;; get local var: var_sliced, have been promoted
          )
          (i32.mul ;; multiply index with byte offset
            (global.get $var_x) ;; get local var: var_x, have been promoted
            (i32.const 4) ;; byte offset
          )
        )
      )
      ;; end array element access node
      (i32.const 1) ;; newline
      (call $writeInt) ;; call host function
      (global.set $var_x ;; set local var, have been promoted
        (i32.add
          (global.get $var_x) ;; get local var: var_x, have been promoted
          (i32.const 1) ;; push 1 on stack
        )
      )
      (global.get $var_x) ;; set local var, have been promoted
    )
    (block $loop_exit$3 
      (loop $loop_begin$4 
        (br_if $loop_exit$3 ;; if false break
          (i32.eqz ;; evaluate loop condition
            (i32.lt_s
              (global.get $var_x) ;; get local var: var_x, have been promoted
              ;; start array length node
              (i32.load offset=4
                (global.get $var_sliced) ;; get local var: var_sliced, have been promoted
              )
              ;; end array length node
            )
          )
        )
        (drop ;; drop value of loop body
          (if 
              (i32.lt_s ;; check if index is >= 0
                (global.get $var_x) ;; get local var: var_x, have been promoted
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
                (global.get $var_x) ;; get local var: var_x, have been promoted
                (i32.load offset=4
                  (global.get $var_sliced) ;; get local var: var_sliced, have been promoted
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
                (global.get $var_sliced) ;; get local var: var_sliced, have been promoted
              )
              (i32.mul ;; multiply index with byte offset
                (global.get $var_x) ;; get local var: var_x, have been promoted
                (i32.const 4) ;; byte offset
              )
            )
          )
          ;; end array element access node
          (i32.const 1) ;; newline
          (call $writeInt) ;; call host function
          (global.set $var_x ;; set local var, have been promoted
            (i32.add
              (global.get $var_x) ;; get local var: var_x, have been promoted
              (i32.const 1) ;; push 1 on stack
            )
          )
          (global.get $var_x) ;; set local var, have been promoted
        )
        (br $loop_begin$4) ;; jump to beginning of loop
      )
    )
    (i32.load ;; Load string pointer
      (i32.const 80) ;; leave pointer to string on stack
    )
    (i32.load offset=4
      (i32.const 80) ;; leave pointer to string on stack
    )
    (i32.const 1) ;; newline
    (call $writeS) ;; call host function
    ;; Start of let
    (global.set $var_o ;; set local var, have been promoted
      ;; Start of union contructor
      ;; start of struct contructor
      (global.set $Sptr$5 ;; set struct pointer var, have been promoted
        (i32.const 8) ;; size of struct
        (call $malloc) ;; call malloc function
      )
      (i32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (global.get $Sptr$5) ;; get struct pointer var, have been promoted
          (i32.const 0) ;; push field offset to stack
        )
        ;; init field (id)
        (i32.const 1) ;; push 1 on stack
      )
      (i32.store ;; store int field in memory
        (i32.add ;; add offset to base address
          (global.get $Sptr$5) ;; get struct pointer var, have been promoted
          (i32.const 4) ;; push field offset to stack
        )
        ;; init field (data)
        (global.get $var_sliced) ;; get local var: var_sliced, have been promoted
      )
      (global.get $Sptr$5) ;; push struct address to stack, have been promoted
      ;; end of struct contructor
      ;; End of union contructor
    )
    (block $match_end 
      ;; case for id: $1, label: Some
      (if 
          (i32.eq ;; check if index is equal to target
            (i32.load ;; load label
              (global.get $var_o) ;; get local var: var_o, have been promoted
            )
            (i32.const 1) ;; put label id 1 on stack
          )
        (then
          (global.set $match_var_v ;; set local var, have been promoted
            (i32.load offset=4
              (global.get $var_o) ;; get local var: var_o, have been promoted
            )
          )
          ;; start array length node
          (i32.load offset=4
            (global.get $match_var_v) ;; get local var: match_var_v, have been promoted
          )
          ;; end array length node
          (i32.const 1) ;; newline
          (call $writeInt) ;; call host function
          (br $match_end) ;; break out of match
        )
      )
      ;; case for id: $2, label: None
      (if 
          (i32.eq ;; check if index is equal to target
            (i32.load ;; load label
              (global.get $var_o) ;; get local var: var_o, have been promoted
            )
            (i32.const 2) ;; put label id 2 on stack
          )
        (then
          (global.set $match_var__ ;; set local var, have been promoted
            (i32.load offset=4
              (global.get $var_o) ;; get local var: var_o, have been promoted
            )
          )
          (i32.load ;; Load string pointer
            (i32.const 118) ;; leave pointer to string on stack
          )
          (i32.load offset=4
            (i32.const 118) ;; leave pointer to string on stack
          )
          (i32.const 1) ;; newline
          (call $writeS) ;; call host function
          (br $match_end) ;; break out of match
        )
      )
      ;; no case was matched, therefore return exit error code
      (global.set $exit_code ;; set exit code
        (i32.const 42) ;; error exit code push to stack
      )
      (unreachable) ;; exit program
    )
    ;; End of let
    ;; End of let
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (func $fun_f (;1;) (param $cenv i32) (param $arg_arr i32) (param $arg_i i32) (result i32) 
    (if (result i32)
        (i32.lt_s
          (local.get $arg_i) ;; get local var: arg_i
          ;; start array length node
          (i32.load offset=4
            (local.get $arg_arr) ;; get local var: arg_arr
          )
          ;; end array length node
        )
      (then
        (drop ;; drop value of subtree
          (if 
              (i32.lt_s ;; check if index is >= 0
                (local.get $arg_i) ;; get local var: arg_i
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
                (local.get $arg_i) ;; get local var: arg_i
                (i32.load offset=4
                  (local.get $arg_arr) ;; get local var: arg_arr
                )
              )
            (then
              (global.set $exit_code ;; set exit code
                (i32.const 42) ;; error exit code push to stack
              )
              (unreachable) ;; exit program
            )
          )
          (i32.store ;; store value in elem pos
            (i32.add ;; add offset to base address
              (i32.load ;; load data pointer
                (local.get $arg_arr) ;; get local var: arg_arr
              )
              (i32.mul ;; multiply index with byte offset
                (local.get $arg_i) ;; get local var: arg_i
                (i32.const 4) ;; byte offset
              )
            )
            (i32.add
              (local.get $arg_i) ;; get local var: arg_i
              (i32.const 1) ;; push 1 on stack
            )
          )
          (i32.load ;; load int from elem pos
            (i32.add ;; add offset to base address
              (i32.load ;; load data pointer
                (local.get $arg_arr) ;; get local var: arg_arr
              )
              (i32.mul ;; multiply index with byte offset
                (local.get $arg_i) ;; get local var: arg_i
                (i32.const 4) ;; byte offset
              )
            )
          )
        )
        ;; Load expression to be applied as a function
        (call_indirect (type $i32_i32_i32_=>_i32) ;; call function
          (i32.load offset=4
            (global.get $fun_f*ptr) ;; get global var: fun_f*ptr
          )
          (local.get $arg_arr) ;; get local var: arg_arr
          (i32.add
            (local.get $arg_i) ;; get local var: arg_i
            (i32.const 1) ;; push 1 on stack
          )
          (i32.load ;; load table index
            (global.get $fun_f*ptr) ;; get global var: fun_f*ptr
          )
        )
      )
      (else
        (local.get $arg_arr) ;; get local var: arg_arr
      )
    )
  )
  (data (i32.const 0) "\0c\00\00\00\1a\00\00\00\1a\00\00\00")
  (data (i32.const 12) "--------------------------")
  (data (i32.const 38) "\00")
  (data (i32.const 42) "\36\00\00\00\1a\00\00\00\1a\00\00\00")
  (data (i32.const 54) "--------------------------")
  (data (i32.const 80) "\5c\00\00\00\1a\00\00\00\1a\00\00\00")
  (data (i32.const 92) "--------------------------")
  (data (i32.const 118) "\82\00\00\00\04\00\00\00\04\00\00\00")
  (data (i32.const 130) "None")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)