(module
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $Sptr (;0;) (mut i32) i32.const 0)
  (global $Sptr$0 (;1;) (mut i32) i32.const 0)
  (global $exit_code (;2;) (mut i32) i32.const 0)
  (global $heap_base (;3;) i32 i32.const 0)
  (global $var_x (;4;) (mut i32) i32.const 0)
  (global $var_y (;5;) (mut i32) i32.const 0)
  (table $func_table (;0;) 0 funcref)
  (func $_start (;0;)  (result i32) ;; entry point of program (main function) 
		;; execution start here:
		;; Start of let
		;; start of struct contructor
		i32.const 1 ;; size of struct
		i32.const 4 ;; 4 bytes
		i32.mul ;; multiply length with 4 to get size
		call $malloc ;; call malloc function
		global.set $Sptr ;; set struct pointer var, have been hoisted
		global.get $Sptr ;; get struct pointer var, have been hoisted
		i32.const 0 ;; push field offset to stack
		i32.add ;; add offset to base address
		;; init field value
		i32.const 0 ;; push 0 on stack
		i32.store ;; store int field in memory
		global.get $Sptr ;; push struct address to stack, have been hoisted
		;; end of struct contructor
		global.set $var_x ;; set local var, have been hoisted
		;; Start of let
		;; start of struct contructor
		i32.const 1 ;; size of struct
		i32.const 4 ;; 4 bytes
		i32.mul ;; multiply length with 4 to get size
		call $malloc ;; call malloc function
		global.set $Sptr$0 ;; set struct pointer var, have been hoisted
		global.get $Sptr$0 ;; get struct pointer var, have been hoisted
		i32.const 0 ;; push field offset to stack
		i32.add ;; add offset to base address
		;; init field value
		i32.const 10 ;; push 10 on stack
		i32.store ;; store int field in memory
		global.get $Sptr$0 ;; push struct address to stack, have been hoisted
		;; end of struct contructor
		global.set $var_y ;; set local var, have been hoisted
		(block $loop_exit 
			(loop $loop_begin 
				;; Start of field select
				global.get $var_x ;; get local var: var_x, have been hoisted
				i32.load offset=0 ;; load field: value
				;; End of field select
				;; Start of field select
				global.get $var_y ;; get local var: var_y, have been hoisted
				i32.load offset=0 ;; load field: value
				;; End of field select
				i32.add
				i32.const 50 ;; push 50 on stack
				i32.eq
				i32.eqz
				i32.eqz
				br_if $loop_exit
				global.get $var_x ;; get local var: var_x, have been hoisted
				;; Start of field select
				global.get $var_x ;; get local var: var_x, have been hoisted
				i32.load offset=0 ;; load field: value
				;; End of field select
				i32.const 1 ;; push 1 on stack
				i32.add
				i32.store offset=0 ;; store int in struct
				global.get $var_x ;; get local var: var_x, have been hoisted
				i32.load offset=0 ;; load int from struct
				global.get $var_y ;; get local var: var_y, have been hoisted
				;; Start of field select
				global.get $var_y ;; get local var: var_y, have been hoisted
				i32.load offset=0 ;; load field: value
				;; End of field select
				i32.const 1 ;; push 1 on stack
				i32.add
				i32.store offset=0 ;; store int in struct
				global.get $var_y ;; get local var: var_y, have been hoisted
				i32.load offset=0 ;; load int from struct
				br $loop_begin
			)
			nop
		)
		;; Start of field select
		global.get $var_x ;; get local var: var_x, have been hoisted
		i32.load offset=0 ;; load field: value
		;; End of field select
		;; Start of field select
		global.get $var_y ;; get local var: var_y, have been hoisted
		i32.load offset=0 ;; load field: value
		;; End of field select
		i32.add
		i32.const 50 ;; push 50 on stack
		i32.eq
		i32.eqz ;; invert assertion
		(if 
			(then
				i32.const 42 ;; error exit code push to stack
				global.set $exit_code ;; set exit code
				unreachable ;; exit program
			)
		)
		;; End of let
		;; End of let
		;; if execution reaches here, the program is successful
		i32.const 0 ;; exit code 0
		return ;; return the exit code
  )
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)