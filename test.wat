(module
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (import "env" "writeInt" (;1;) (func $writeInt (param i32) (param i32) ))
  (import "env" "writeS" (;2;) (func $writeS (param i32) (param i32) (param i32) ))
  (memory (;0;) (export "memory") 1)
  (global $Sptr (;0;) (mut i32) (i32.const 0))
  (global $exit_code (;1;) (mut i32) (i32.const 0))
  (global $heap_base (;2;) i32 (i32.const 14))
  (global $var_s1 (;3;) (mut i32) (i32.const 0))
  (global $var_stop (;4;) (mut i32) (i32.const 0))
  (global $var_x (;5;) (mut i32) (i32.const 0))
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)   
    ;; execution start here:
    ;; Start of let
    i32.const 0 ;; push 0 on stack
    global.set $var_x ;; set local var, have been promoted
    ;; Start of let
    i32.const 10000 ;; push 10000 on stack
    global.set $var_stop ;; set local var, have been promoted
    block $loop_exit 
      loop $loop_begin 
        global.get $var_x ;; get local var: var_x, have been promoted
        global.get $var_stop ;; get local var: var_stop, have been promoted
        i32.lt_s
        i32.eqz ;; evaluate loop condition
        br_if $loop_exit ;; if false break
        ;; Start of let
        ;; start of struct contructor
        i32.const 8 ;; size of struct
        call $malloc ;; call malloc function
        global.set $Sptr ;; set struct pointer var, have been promoted
        global.get $Sptr ;; get struct pointer var, have been promoted
        i32.const 0 ;; push field offset to stack
        i32.add ;; add offset to base address
        ;; init field (f)
        i32.const 42 ;; push 42 on stack
        global.get $var_x ;; get local var: var_x, have been promoted
        i32.add
        i32.store ;; store int field in memory
        global.get $Sptr ;; get struct pointer var, have been promoted
        i32.const 4 ;; push field offset to stack
        i32.add ;; add offset to base address
        ;; init field (i)
        i32.const 42 ;; push 42 on stack
        i32.store ;; store int field in memory
        global.get $Sptr ;; push struct address to stack, have been promoted
        ;; end of struct contructor
        global.set $var_s1 ;; set local var, have been promoted
        ;; Start of field select
        global.get $var_s1 ;; get local var: var_s1, have been promoted
        i32.load offset=4 ;; load field: i
        ;; End of field select
        i32.const 42 ;; push 42 on stack
        i32.eq ;; equality check
        i32.eqz ;; invert assertion
        if 
          i32.const 42 ;; error exit code push to stack
          global.set $exit_code ;; set exit code
          unreachable ;; exit program
        end
        ;; Start of field select
        global.get $var_s1 ;; get local var: var_s1, have been promoted
        i32.load ;; load field: f
        ;; End of field select
        i32.const 42 ;; push 42 on stack
        global.get $var_x ;; get local var: var_x, have been promoted
        i32.add
        i32.eq ;; equality check
        i32.eqz ;; invert assertion
        if 
          i32.const 42 ;; error exit code push to stack
          global.set $exit_code ;; set exit code
          unreachable ;; exit program
        end
        global.get $var_x ;; get local var: var_x, have been promoted
        i32.const 0 ;; newline
        call $writeInt ;; call host function
        i32.const 0 ;; leave pointer to string on stack
        i32.load ;; Load string pointer
        i32.const 0 ;; leave pointer to string on stack
        i32.load offset=4 ;; Load string length
        i32.const 0 ;; newline
        call $writeS ;; call host function
        global.get $var_x ;; get local var: var_x, have been promoted
        global.get $var_x ;; get local var: var_x, have been promoted
        i32.const 1 ;; push 1 on stack
        i32.add
        global.set $var_x ;; set local var, have been promoted
        global.get $var_x ;; set local var, have been promoted
        drop
        ;; End of let
        drop ;; drop value of loop body
        br $loop_begin ;; jump to beginning of loop
      end
    end
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (data (i32.const 0) "\0c\00\00\00\02\00\00\00\02\00\00\00")
  (data (i32.const 12) ", ")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)