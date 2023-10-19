(module
  (import "env" "malloc" (;0;) (func $malloc (param i32) (result i32)))
  (import "env" "readInt" (;1;) (func $readInt  (result i32)))
  (import "env" "writeInt" (;2;) (func $writeInt (param i32) ))
  (import "env" "writeS" (;3;) (func $writeS (param i32) (param i32) ))
  (memory (;0;) (export "memory") 1)
  (global $Sptr (;0;) (mut i32) i32.const 0)
  (global $Sptr$0 (;1;) (mut i32) i32.const 0)
  (global $exit_code (;2;) (mut i32) i32.const 0)
  (global $heap_base (;3;) i32 i32.const 56)
  (global $var_by3 (;4;) (mut i32) i32.const 0)
  (global $var_by5 (;5;) (mut i32) i32.const 0)
  (global $var_i (;6;) (mut i32) i32.const 0)
  (global $var_y (;7;) (mut i32) i32.const 0)
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
		global.set $var_i ;; set local var, have been hoisted
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
		call $readInt ;; call host function
		i32.store ;; store int field in memory
		global.get $Sptr$0 ;; push struct address to stack, have been hoisted
		;; end of struct contructor
		global.set $var_y ;; set local var, have been hoisted
		(block $loop_exit 
			(loop $loop_begin 
				;; Start of field select
				global.get $var_i ;; get local var: var_i, have been hoisted
				i32.load offset=0 ;; load field: value
				;; End of field select
				;; Start of field select
				global.get $var_y ;; get local var: var_y, have been hoisted
				i32.load offset=0 ;; load field: value
				;; End of field select
				i32.lt_s
				i32.eqz
				br_if $loop_exit
				;; Start of let
				;; Start of field select
				global.get $var_i ;; get local var: var_i, have been hoisted
				i32.load offset=0 ;; load field: value
				;; End of field select
				i32.const 3 ;; push 3 on stack
				i32.rem_s
				i32.const 0 ;; push 0 on stack
				i32.eq
				global.set $var_by3 ;; set local var, have been hoisted
				;; Start of let
				;; Start of field select
				global.get $var_i ;; get local var: var_i, have been hoisted
				i32.load offset=0 ;; load field: value
				;; End of field select
				i32.const 5 ;; push 5 on stack
				i32.rem_s
				i32.const 0 ;; push 0 on stack
				i32.eq
				global.set $var_by5 ;; set local var, have been hoisted
				global.get $var_by3 ;; get local var: var_by3, have been hoisted
				(if 
					(then
						global.get $var_by5 ;; get local var: var_by5, have been hoisted
						(if 
							(then
								i32.const 0 ;; leave pointer to string on stack
								i32.load ;; Load string pointer
								i32.const 0 ;; leave pointer to string on stack
								i32.const 4 ;; length offset
								i32.add ;; add offset to pointer
								i32.load ;; Load string length
								call $writeS ;; call host function
							)
							(else
								i32.const 24 ;; leave pointer to string on stack
								i32.load ;; Load string pointer
								i32.const 24 ;; leave pointer to string on stack
								i32.const 4 ;; length offset
								i32.add ;; add offset to pointer
								i32.load ;; Load string length
								call $writeS ;; call host function
							)
						)
					)
					(else
						global.get $var_by5 ;; get local var: var_by5, have been hoisted
						(if 
							(then
								i32.const 40 ;; leave pointer to string on stack
								i32.load ;; Load string pointer
								i32.const 40 ;; leave pointer to string on stack
								i32.const 4 ;; length offset
								i32.add ;; add offset to pointer
								i32.load ;; Load string length
								call $writeS ;; call host function
							)
							(else
								;; Start of field select
								global.get $var_i ;; get local var: var_i, have been hoisted
								i32.load offset=0 ;; load field: value
								;; End of field select
								call $writeInt ;; call host function
							)
						)
					)
				)
				;; End of let
				;; End of let
				global.get $var_i ;; get local var: var_i, have been hoisted
				;; Start of field select
				global.get $var_i ;; get local var: var_i, have been hoisted
				i32.load offset=0 ;; load field: value
				;; End of field select
				i32.const 1 ;; push 1 on stack
				i32.add
				i32.store offset=0 ;; store int in struct
				global.get $var_i ;; get local var: var_i, have been hoisted
				i32.load offset=0 ;; load int from struct
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
  (data (i32.const 0) "\08\00\00\00\10\00\00\00")
  (data (i32.const 8) "FizzBuzz")
  (data (i32.const 24) "\20\00\00\00\08\00\00\00")
  (data (i32.const 32) "Fizz")
  (data (i32.const 40) "\30\00\00\00\08\00\00\00")
  (data (i32.const 48) "Buzz")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)