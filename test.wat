(module
  (type $i32_i32_=>_i32 (;0;) (func (param i32) (param i32) (result i32)))
  (type $i32_i32_i32_=>_i32 (;1;) (func (param i32) (param i32) (param i32) (result i32)))
  (import "env" "writeS" (;0;) (func $writeS (param i32) (param i32) ))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) i32.const 0)
  (global $fun_f*ptr (;1;) (mut i32) i32.const 0)
  (global $fun_f1*ptr (;2;) (mut i32) i32.const 8)
  (global $fun_f2*ptr (;3;) (mut i32) i32.const 16)
  (global $fun_f3*ptr (;4;) (mut i32) i32.const 40)
  (global $fun_f4*ptr (;5;) (mut i32) i32.const 44)
  (global $fun_f5*ptr (;6;) (mut i32) i32.const 48)
  (global $fun_g*ptr (;7;) (mut i32) i32.const 4)
  (global $fun_g1*ptr (;8;) (mut i32) i32.const 12)
  (global $fun_g2*ptr (;9;) (mut i32) i32.const 20)
  (global $fun_gr*ptr (;10;) (mut i32) i32.const 32)
  (global $fun_less*ptr (;11;) (mut i32) i32.const 36)
  (global $fun_ma*ptr (;12;) (mut i32) i32.const 24)
  (global $fun_mi*ptr (;13;) (mut i32) i32.const 28)
  (global $heap_base (;14;) i32 i32.const 70)
  (global $var_x (;15;) (mut i32) i32.const 0)
  (table $func_table (;0;) 13 funcref)
  (elem (i32.const 0) (;0;) $fun_f)
  (elem (i32.const 1) (;1;) $fun_g)
  (elem (i32.const 2) (;2;) $fun_f1)
  (elem (i32.const 3) (;3;) $fun_g1)
  (elem (i32.const 4) (;4;) $fun_f2)
  (elem (i32.const 5) (;5;) $fun_g2)
  (elem (i32.const 6) (;6;) $fun_ma)
  (elem (i32.const 7) (;7;) $fun_mi)
  (elem (i32.const 8) (;8;) $fun_gr)
  (elem (i32.const 9) (;9;) $fun_less)
  (elem (i32.const 10) (;10;) $fun_f3)
  (elem (i32.const 11) (;11;) $fun_f4)
  (elem (i32.const 12) (;12;) $fun_f5)
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    i32.const 1 ;; push 1 on stack
    global.set $var_x ;; set local var, have been hoisted
    global.get $var_x ;; get local var: var_x, have been hoisted
    i32.const 1 ;; push 1 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f*ptr ;; get global var: fun_f*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 41 ;; push 41 on stack
    global.get $fun_f*ptr ;; get global var: fun_f*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 41 ;; push 41 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_g*ptr ;; get global var: fun_g*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 41 ;; push 41 on stack
    global.get $fun_g*ptr ;; get global var: fun_g*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 42 ;; push 42 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_x ;; get local var: var_x, have been hoisted
    i32.const 1 ;; push 1 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f1*ptr ;; get global var: fun_f1*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 41 ;; push 41 on stack
    global.get $fun_f1*ptr ;; get global var: fun_f1*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 41 ;; push 41 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_g1*ptr ;; get global var: fun_g1*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 41 ;; push 41 on stack
    global.get $fun_g1*ptr ;; get global var: fun_g1*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 40 ;; push 40 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    global.get $var_x ;; get local var: var_x, have been hoisted
    i32.const 1 ;; push 1 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f2*ptr ;; get global var: fun_f2*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 41 ;; push 41 on stack
    global.get $fun_f2*ptr ;; get global var: fun_f2*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 40 ;; push 40 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_g2*ptr ;; get global var: fun_g2*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 41 ;; push 41 on stack
    global.get $fun_g2*ptr ;; get global var: fun_g2*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 42 ;; push 42 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_ma*ptr ;; get global var: fun_ma*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 1 ;; push 1 on stack
    i32.const 2 ;; push 2 on stack
    global.get $fun_ma*ptr ;; get global var: fun_ma*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 2 ;; push 2 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_mi*ptr ;; get global var: fun_mi*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 1 ;; push 1 on stack
    i32.const 2 ;; push 2 on stack
    global.get $fun_mi*ptr ;; get global var: fun_mi*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.const 1 ;; push 1 on stack
    i32.eq
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_gr*ptr ;; get global var: fun_gr*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 1 ;; push 1 on stack
    i32.const 2 ;; push 2 on stack
    global.get $fun_gr*ptr ;; get global var: fun_gr*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.eqz
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_less*ptr ;; get global var: fun_less*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 1 ;; push 1 on stack
    i32.const 2 ;; push 2 on stack
    global.get $fun_less*ptr ;; get global var: fun_less*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_less*ptr ;; get global var: fun_less*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 2 ;; push 2 on stack
    i32.const 2 ;; push 2 on stack
    global.get $fun_less*ptr ;; get global var: fun_less*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.eqz
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_gr*ptr ;; get global var: fun_gr*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 2 ;; push 2 on stack
    i32.const 2 ;; push 2 on stack
    global.get $fun_gr*ptr ;; get global var: fun_gr*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.eqz
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_gr*ptr ;; get global var: fun_gr*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 2 ;; push 2 on stack
    i32.const 1 ;; push 1 on stack
    global.get $fun_gr*ptr ;; get global var: fun_gr*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f3*ptr ;; get global var: fun_f3*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 1
    i32.const 0
    global.get $fun_f3*ptr ;; get global var: fun_f3*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f3*ptr ;; get global var: fun_f3*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 0
    i32.const 0
    global.get $fun_f3*ptr ;; get global var: fun_f3*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.eqz
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f3*ptr ;; get global var: fun_f3*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 1
    i32.const 1
    global.get $fun_f3*ptr ;; get global var: fun_f3*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f3*ptr ;; get global var: fun_f3*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 0
    i32.const 1
    global.get $fun_f3*ptr ;; get global var: fun_f3*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f4*ptr ;; get global var: fun_f4*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 1
    i32.const 0
    global.get $fun_f4*ptr ;; get global var: fun_f4*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.eqz
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f4*ptr ;; get global var: fun_f4*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 0
    i32.const 0
    global.get $fun_f4*ptr ;; get global var: fun_f4*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.eqz
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f4*ptr ;; get global var: fun_f4*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 1
    i32.const 1
    global.get $fun_f4*ptr ;; get global var: fun_f4*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f4*ptr ;; get global var: fun_f4*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 0
    i32.const 1
    global.get $fun_f4*ptr ;; get global var: fun_f4*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.eqz
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f5*ptr ;; get global var: fun_f5*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 1
    global.get $fun_f5*ptr ;; get global var: fun_f5*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.eqz
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    ;; start of application
    ;; Load expression to be applied as a function
    global.get $fun_f5*ptr ;; get global var: fun_f5*ptr
    i32.load offset=4 ;; load closure environment pointer
    i32.const 0
    global.get $fun_f5*ptr ;; get global var: fun_f5*ptr
    i32.load ;; load table index
    call_indirect (type $i32_i32_=>_i32) ;; call function
    ;; end of application
    i32.eqz ;; invert assertion
    (if 
      (then
        i32.const 42 ;; error exit code push to stack
        global.set $exit_code ;; set exit code
        unreachable ;; exit program
      )
    )
    i32.const 52 ;; leave pointer to string on stack
    i32.load ;; Load string pointer
    i32.const 52 ;; leave pointer to string on stack
    i32.load offset=4 ;; Load string length
    call $writeS ;; call host function
    ;; End of let
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (func $fun_f (;1;) (param $cenv i32) (param $arg_x i32) (result i32) 
    ;; Start PostIncr
    local.get $arg_x ;; get local var: arg_x
    local.get $arg_x
    i32.const 1
    i32.add
    local.set $arg_x
    ;; End PostIncr
  )
  (func $fun_f1 (;2;) (param $cenv i32) (param $arg_x$1 i32) (result i32) 
    ;; Start PostDecr
    local.get $arg_x$1 ;; get local var: arg_x$1
    local.get $arg_x$1
    i32.const 1
    i32.sub
    local.set $arg_x$1
    ;; End PostDecr
  )
  (func $fun_f2 (;3;) (param $cenv i32) (param $arg_x$3 i32) (result i32) 
    ;; Start AddAsgn/MinAsgn
    local.get $arg_x$3 ;; get local var: arg_x$3
    i32.const 1 ;; push 1 on stack
    i32.sub
    local.tee $arg_x$3
    ;; End AddAsgn/MinAsgn
  )
  (func $fun_f3 (;4;) (param $cenv i32) (param $arg_x$12 i32) (param $arg_y$13 i32) (result i32) 
    local.get $arg_x$12 ;; get local var: arg_x$12
    local.get $arg_y$13 ;; get local var: arg_y$13
    i32.or
  )
  (func $fun_f4 (;5;) (param $cenv i32) (param $arg_x$14 i32) (param $arg_y$15 i32) (result i32) 
    local.get $arg_x$14 ;; get local var: arg_x$14
    local.get $arg_y$15 ;; get local var: arg_y$15
    i32.and
  )
  (func $fun_f5 (;6;) (param $cenv i32) (param $arg_x$16 i32) (result i32) 
    local.get $arg_x$16 ;; get local var: arg_x$16
    i32.eqz
  )
  (func $fun_g (;7;) (param $cenv i32) (param $arg_x$0 i32) (result i32) 
    ;; Start PreIncr
    local.get $arg_x$0 ;; get local var: arg_x$0
    i32.const 1
    i32.add
    local.tee $arg_x$0
    ;; End PreIncr
  )
  (func $fun_g1 (;8;) (param $cenv i32) (param $arg_x$2 i32) (result i32) 
    ;; Start PreDecr
    local.get $arg_x$2 ;; get local var: arg_x$2
    i32.const 1
    i32.sub
    local.tee $arg_x$2
    ;; End PreDecr
  )
  (func $fun_g2 (;9;) (param $cenv i32) (param $arg_x$4 i32) (result i32) 
    ;; Start AddAsgn/MinAsgn
    local.get $arg_x$4 ;; get local var: arg_x$4
    i32.const 1 ;; push 1 on stack
    i32.add
    local.tee $arg_x$4
    ;; End AddAsgn/MinAsgn
  )
  (func $fun_gr (;10;) (param $cenv i32) (param $arg_x$8 i32) (param $arg_y$9 i32) (result i32) 
    local.get $arg_x$8 ;; get local var: arg_x$8
    local.get $arg_y$9 ;; get local var: arg_y$9
    i32.gt_s
  )
  (func $fun_less (;11;) (param $cenv i32) (param $arg_x$10 i32) (param $arg_y$11 i32) (result i32) 
    local.get $arg_x$10 ;; get local var: arg_x$10
    local.get $arg_y$11 ;; get local var: arg_y$11
    i32.lt_s
  )
  (func $fun_ma (;12;) (param $cenv i32) (param $arg_x$5 i32) (param $arg_y i32) (result i32) 
    ;; Max/min start
    local.get $arg_x$5 ;; get local var: arg_x$5
    local.get $arg_y ;; get local var: arg_y
    local.get $arg_x$5 ;; get local var: arg_x$5
    local.get $arg_y ;; get local var: arg_y
    i32.gt_s
    select
    ;; Max/min end
  )
  (func $fun_mi (;13;) (param $cenv i32) (param $arg_x$6 i32) (param $arg_y$7 i32) (result i32) 
    ;; Max/min start
    local.get $arg_x$6 ;; get local var: arg_x$6
    local.get $arg_y$7 ;; get local var: arg_y$7
    local.get $arg_x$6 ;; get local var: arg_x$6
    local.get $arg_y$7 ;; get local var: arg_y$7
    i32.lt_s
    select
    ;; Max/min end
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (data (i32.const 8) "\02")
  (data (i32.const 12) "\03")
  (data (i32.const 16) "\04")
  (data (i32.const 20) "\05")
  (data (i32.const 24) "\06")
  (data (i32.const 28) "\07")
  (data (i32.const 32) "\08")
  (data (i32.const 36) "\09")
  (data (i32.const 40) "\0a")
  (data (i32.const 44) "\0b")
  (data (i32.const 48) "\0c")
  (data (i32.const 52) "\3c\00\00\00\0a\00\00\00")
  (data (i32.const 60) "done!")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)