(module
  (type $i32_f32_f32_=> (;0;) (func (param i32) (param f32) (param f32) ))
  (type $i32_i32_i32_=> (;1;) (func (param i32) (param i32) (param i32) ))
  (import "env" "readFloat" (;0;) (func $readFloat  (result f32)))
  (import "env" "readInt" (;1;) (func $readInt  (result i32)))
  (import "env" "writeFloat" (;2;) (func $writeFloat (param f32) ))
  (import "env" "writeInt" (;3;) (func $writeInt (param i32) ))
  (import "env" "writeS" (;4;) (func $writeS (param i32) (param i32) ))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) i32.const 0)
  (global $fun_printerFloat*ptr (;1;) (mut i32) i32.const 162)
  (global $fun_printerInt*ptr (;2;) (mut i32) i32.const 0)
  (global $heap_base (;3;) i32 i32.const 338)
  (global $var_x (;4;) (mut i32) i32.const 0)
  (global $var_x$2 (;5;) (mut f32) f32.const 0.000000)
  (global $var_y (;6;) (mut i32) i32.const 0)
  (global $var_y$3 (;7;) (mut f32) f32.const 0.000000)
  (table $func_table (;0;) 2 funcref)
  (elem (i32.const 0) (;0;) $fun_printerInt)
  (elem (i32.const 1) (;1;) $fun_printerFloat)
  (func $_start (;0;)  (result i32) ;; entry point of program (main function) 
    ;; execution start here:
    i32.const 60 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 60 ;; leave pointer to string on stack
    i32.const 4 ;; length offset
    i32.add ;; add offset to pointer
    i32.load ;; Load string length
    call $writeS ;; call host function
    i32.const 134 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 134 ;; leave pointer to string on stack
    i32.const 4 ;; length offset
    i32.add ;; add offset to pointer
    i32.load ;; Load string length
    call $writeS ;; call host function
    ;; Start of let
    call $readInt ;; call host function
    global.set $var_x ;; set local var, have been hoisted
    i32.const 148 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 148 ;; leave pointer to string on stack
    i32.const 4 ;; length offset
    i32.add ;; add offset to pointer
    i32.load ;; Load string length
    call $writeS ;; call host function
    ;; Start of let
    call $readInt ;; call host function
    global.set $var_y ;; set local var, have been hoisted
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_printerInt*ptr ;; get global var: fun_printerInt*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    global.get $var_x ;; get local var: var_x, have been hoisted
    global.get $var_y ;; get local var: var_y, have been hoisted
    global.get $fun_printerInt*ptr ;; get global var: fun_printerInt*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>) ;; call function
    ;; end of application
    i32.const 222 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 222 ;; leave pointer to string on stack
    i32.const 4 ;; length offset
    i32.add ;; add offset to pointer
    i32.load ;; Load string length
    call $writeS ;; call host function
    i32.const 310 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 310 ;; leave pointer to string on stack
    i32.const 4 ;; length offset
    i32.add ;; add offset to pointer
    i32.load ;; Load string length
    call $writeS ;; call host function
    ;; Start of let
    call $readFloat ;; call host function
    global.set $var_x$2 ;; set local var, have been hoisted
    i32.const 324 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 324 ;; leave pointer to string on stack
    i32.const 4 ;; length offset
    i32.add ;; add offset to pointer
    i32.load ;; Load string length
    call $writeS ;; call host function
    ;; Start of let
    call $readFloat ;; call host function
    global.set $var_y$3 ;; set local var, have been hoisted
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_printerFloat*ptr ;; get global var: fun_printerFloat*ptr
    i32.const 4 ;; 4 byte offset
    i32.add ;; add offset
    i32.load ;; load closure environment pointer
    global.get $var_x$2 ;; get local var: var_x$2, have been hoisted
    global.get $var_y$3 ;; get local var: var_y$3, have been hoisted
    global.get $fun_printerFloat*ptr ;; get global var: fun_printerFloat*ptr
    i32.load ;; load table index
    call_indirect (type $i32_f32_f32_=>) ;; call function
    ;; end of application
    ;; End of let
    ;; End of let
    ;; End of let
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_printerFloat (;0;) (param $cenv i32) (param $arg_x$0 f32) (param $arg_y$1 f32)  ;; function fun_printerFloat 
    i32.const 166 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 166 ;; leave pointer to string on stack
    i32.const 4 ;; length offset
    i32.add ;; add offset to pointer
    i32.load ;; Load string length
    call $writeS ;; call host function
    local.get $arg_x$0 ;; get local var: arg_x$0
    local.get $arg_y$1 ;; get local var: arg_y$1
    f32.add
    call $writeFloat ;; call host function
  )
  (func $fun_printerInt (;0;) (param $cenv i32) (param $arg_x i32) (param $arg_y i32)  ;; function fun_printerInt 
    i32.const 4 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 4 ;; leave pointer to string on stack
    i32.const 4 ;; length offset
    i32.add ;; add offset to pointer
    i32.load ;; Load string length
    call $writeS ;; call host function
    local.get $arg_x ;; get local var: arg_x
    local.get $arg_y ;; get local var: arg_y
    i32.add
    call $writeInt ;; call host function
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\0c\00\00\00\30\00\00\00")
  (data (i32.const 12) "The result of x + y is: ")
  (data (i32.const 60) "\44\00\00\00\42\00\00\00")
  (data (i32.const 68) "Please insert two integer values:")
  (data (i32.const 134) "\8e\00\00\00\06\00\00\00")
  (data (i32.const 142) "x: ")
  (data (i32.const 148) "\9c\00\00\00\06\00\00\00")
  (data (i32.const 156) "y: ")
  (data (i32.const 162) "\01")
  (data (i32.const 166) "\ae\00\00\00\30\00\00\00")
  (data (i32.const 174) "The result of x + y is: ")
  (data (i32.const 222) "\e6\00\00\00\50\00\00\00")
  (data (i32.const 230) "Please insert two floating-point values:")
  (data (i32.const 310) "\3e\01\00\00\06\00\00\00")
  (data (i32.const 318) "x: ")
  (data (i32.const 324) "\4c\01\00\00\06\00\00\00")
  (data (i32.const 332) "y: ")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)