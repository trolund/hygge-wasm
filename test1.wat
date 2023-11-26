(module
  (type $i32_i32_=>_unit (func (param i32 i32)))
  (import "env" "writeInt" (func $writeInt (param i32)))
  (import "env" "writeS" (func $writeS (param i32 i32)))
  (memory (;0;) 1)
  (export "memory" (memory 0))
  (global $Sptr (mut i32) (i32.const 0))
  (global $arr_ptr (mut i32) (i32.const 0))
  (global $exit_code (mut i32) (i32.const 0))
  (global $fun_insertionSort*ptr (mut i32) (i32.const 0))
  (global $fun_printArray*ptr (mut i32) (i32.const 4))
  (global $heap_base (mut i32) (i32.const 187))
  (global $i (mut i32) (i32.const 0))
  (global $var_arr (mut i32) (i32.const 0))
  (table $func_table 2 funcref)
  (elem (;0;) (i32.const 0) func $fun_insertionSort)
  (elem (;1;) (i32.const 1) func $fun_printArray)
  (func $_start
    (if  ;; label = @1
      (i32.le_s
        (i32.const 10)
        (i32.const 1))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.ge_s
        (i32.add
          (global.get $heap_base)
          (i32.const 8))
        (i32.mul
          (memory.size)
          (i32.const 65536)))
      (then
        (drop
          (memory.grow
            (i32.div_s
              (i32.add
                (global.get $heap_base)
                (i32.const 8))
              (i32.const 65536))))))
    (global.get $heap_base)
    (global.set $heap_base
      (i32.add
        (global.get $heap_base)
        (i32.const 8)))
    (global.set $Sptr)
    (i32.store
      (i32.add
        (global.get $Sptr)
        (i32.const 0))
      (i32.const 0))
    (i32.store
      (i32.add
        (global.get $Sptr)
        (i32.const 4))
      (i32.const 10))
    (global.set $arr_ptr
      (global.get $Sptr))
    (global.get $arr_ptr)
    (if  ;; label = @1
      (i32.ge_s
        (i32.add
          (global.get $heap_base)
          (i32.mul
            (i32.const 10)
            (i32.const 4)))
        (i32.mul
          (memory.size)
          (i32.const 65536)))
      (then
        (drop
          (memory.grow
            (i32.div_s
              (i32.add
                (global.get $heap_base)
                (i32.mul
                  (i32.const 10)
                  (i32.const 4)))
              (i32.const 65536))))))
    (global.get $heap_base)
    (global.set $heap_base
      (i32.add
        (global.get $heap_base)
        (i32.mul
          (i32.const 10)
          (i32.const 4))))
    (i32.store)
    (global.set $i
      (i32.const 0))
    (block $loop_exit$5
      (loop $loop_begin$6
        (br_if $loop_exit$5
          (i32.eq
            (i32.const 10)
            (global.get $i)))
        (i32.store
          (i32.add
            (i32.load
              (global.get $arr_ptr))
            (i32.mul
              (global.get $i)
              (i32.const 4)))
          (i32.const 0))
        (global.set $i
          (i32.add
            (global.get $i)
            (i32.const 1)))
        (br $loop_begin$6)))
    (global.set $var_arr
      (global.get $arr_ptr))
    (if  ;; label = @1
      (i32.lt_s
        (i32.const 0)
        (i32.const 0))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.ge_s
        (i32.const 0)
        (i32.load offset=4
          (global.get $var_arr)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (i32.store
      (i32.add
        (i32.load
          (global.get $var_arr))
        (i32.mul
          (i32.const 0)
          (i32.const 4)))
      (i32.const 500))
    (if  ;; label = @1
      (i32.lt_s
        (i32.const 1)
        (i32.const 0))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.ge_s
        (i32.const 1)
        (i32.load offset=4
          (global.get $var_arr)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (i32.store
      (i32.add
        (i32.load
          (global.get $var_arr))
        (i32.mul
          (i32.const 1)
          (i32.const 4)))
      (i32.const 3))
    (if  ;; label = @1
      (i32.lt_s
        (i32.const 2)
        (i32.const 0))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.ge_s
        (i32.const 2)
        (i32.load offset=4
          (global.get $var_arr)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (i32.store
      (i32.add
        (i32.load
          (global.get $var_arr))
        (i32.mul
          (i32.const 2)
          (i32.const 4)))
      (i32.const 11))
    (if  ;; label = @1
      (i32.lt_s
        (i32.const 3)
        (i32.const 0))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.ge_s
        (i32.const 3)
        (i32.load offset=4
          (global.get $var_arr)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (i32.store
      (i32.add
        (i32.load
          (global.get $var_arr))
        (i32.mul
          (i32.const 3)
          (i32.const 4)))
      (i32.const 22))
    (if  ;; label = @1
      (i32.lt_s
        (i32.const 4)
        (i32.const 0))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.ge_s
        (i32.const 4)
        (i32.load offset=4
          (global.get $var_arr)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (i32.store
      (i32.add
        (i32.load
          (global.get $var_arr))
        (i32.mul
          (i32.const 4)
          (i32.const 4)))
      (i32.const 45))
    (if  ;; label = @1
      (i32.lt_s
        (i32.const 5)
        (i32.const 0))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.ge_s
        (i32.const 5)
        (i32.load offset=4
          (global.get $var_arr)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (i32.store
      (i32.add
        (i32.load
          (global.get $var_arr))
        (i32.mul
          (i32.const 5)
          (i32.const 4)))
      (i32.const 61))
    (if  ;; label = @1
      (i32.lt_s
        (i32.const 6)
        (i32.const 0))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.ge_s
        (i32.const 6)
        (i32.load offset=4
          (global.get $var_arr)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (i32.store
      (i32.add
        (i32.load
          (global.get $var_arr))
        (i32.mul
          (i32.const 6)
          (i32.const 4)))
      (i32.const 100))
    (if  ;; label = @1
      (i32.lt_s
        (i32.const 7)
        (i32.const 0))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.ge_s
        (i32.const 7)
        (i32.load offset=4
          (global.get $var_arr)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (i32.store
      (i32.add
        (i32.load
          (global.get $var_arr))
        (i32.mul
          (i32.const 7)
          (i32.const 4)))
      (i32.const 200))
    (if  ;; label = @1
      (i32.lt_s
        (i32.const 8)
        (i32.const 0))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.ge_s
        (i32.const 8)
        (i32.load offset=4
          (global.get $var_arr)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (i32.store
      (i32.add
        (i32.load
          (global.get $var_arr))
        (i32.mul
          (i32.const 8)
          (i32.const 4)))
      (i32.const 34))
    (if  ;; label = @1
      (i32.lt_s
        (i32.const 9)
        (i32.const 0))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.ge_s
        (i32.const 9)
        (i32.load offset=4
          (global.get $var_arr)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (i32.store
      (i32.add
        (i32.load
          (global.get $var_arr))
        (i32.mul
          (i32.const 9)
          (i32.const 4)))
      (i32.const 80))
    (call $writeS
      (i32.load
        (i32.const 8))
      (i32.load offset=4
        (i32.const 8)))
    (call_indirect $func_table (type $i32_i32_=>_unit)
      (i32.load offset=4
        (global.get $fun_printArray*ptr))
      (global.get $var_arr)
      (i32.load
        (global.get $fun_printArray*ptr)))
    (call $writeS
      (i32.load
        (i32.const 39))
      (i32.load offset=4
        (i32.const 39)))
    (call_indirect $func_table (type $i32_i32_=>_unit)
      (i32.load offset=4
        (global.get $fun_insertionSort*ptr))
      (global.get $var_arr)
      (i32.load
        (global.get $fun_insertionSort*ptr)))
    (call $writeS
      (i32.load
        (i32.const 89))
      (i32.load offset=4
        (i32.const 89)))
    (call $writeS
      (i32.load
        (i32.const 139))
      (i32.load offset=4
        (i32.const 139)))
    (call_indirect $func_table (type $i32_i32_=>_unit)
      (i32.load offset=4
        (global.get $fun_printArray*ptr))
      (global.get $var_arr)
      (i32.load
        (global.get $fun_printArray*ptr)))
    (if  ;; label = @1
      (i32.lt_s
        (i32.const 0)
        (i32.const 0))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.ge_s
        (i32.const 0)
        (i32.load offset=4
          (global.get $var_arr)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.eqz
        (i32.eq
          (i32.load
            (i32.add
              (i32.load
                (global.get $var_arr))
              (i32.mul
                (i32.const 0)
                (i32.const 4))))
          (i32.const 3)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.lt_s
        (i32.const 1)
        (i32.const 0))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.ge_s
        (i32.const 1)
        (i32.load offset=4
          (global.get $var_arr)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.eqz
        (i32.eq
          (i32.load
            (i32.add
              (i32.load
                (global.get $var_arr))
              (i32.mul
                (i32.const 1)
                (i32.const 4))))
          (i32.const 11)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.lt_s
        (i32.const 2)
        (i32.const 0))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.ge_s
        (i32.const 2)
        (i32.load offset=4
          (global.get $var_arr)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.eqz
        (i32.eq
          (i32.load
            (i32.add
              (i32.load
                (global.get $var_arr))
              (i32.mul
                (i32.const 2)
                (i32.const 4))))
          (i32.const 22)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.lt_s
        (i32.const 3)
        (i32.const 0))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.ge_s
        (i32.const 3)
        (i32.load offset=4
          (global.get $var_arr)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.eqz
        (i32.eq
          (i32.load
            (i32.add
              (i32.load
                (global.get $var_arr))
              (i32.mul
                (i32.const 3)
                (i32.const 4))))
          (i32.const 34)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.lt_s
        (i32.const 4)
        (i32.const 0))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.ge_s
        (i32.const 4)
        (i32.load offset=4
          (global.get $var_arr)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.eqz
        (i32.eq
          (i32.load
            (i32.add
              (i32.load
                (global.get $var_arr))
              (i32.mul
                (i32.const 4)
                (i32.const 4))))
          (i32.const 45)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.lt_s
        (i32.const 5)
        (i32.const 0))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.ge_s
        (i32.const 5)
        (i32.load offset=4
          (global.get $var_arr)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.eqz
        (i32.eq
          (i32.load
            (i32.add
              (i32.load
                (global.get $var_arr))
              (i32.mul
                (i32.const 5)
                (i32.const 4))))
          (i32.const 61)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.lt_s
        (i32.const 6)
        (i32.const 0))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.ge_s
        (i32.const 6)
        (i32.load offset=4
          (global.get $var_arr)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.eqz
        (i32.eq
          (i32.load
            (i32.add
              (i32.load
                (global.get $var_arr))
              (i32.mul
                (i32.const 6)
                (i32.const 4))))
          (i32.const 80)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.lt_s
        (i32.const 7)
        (i32.const 0))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.ge_s
        (i32.const 7)
        (i32.load offset=4
          (global.get $var_arr)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.eqz
        (i32.eq
          (i32.load
            (i32.add
              (i32.load
                (global.get $var_arr))
              (i32.mul
                (i32.const 7)
                (i32.const 4))))
          (i32.const 100)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.lt_s
        (i32.const 8)
        (i32.const 0))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.ge_s
        (i32.const 8)
        (i32.load offset=4
          (global.get $var_arr)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.eqz
        (i32.eq
          (i32.load
            (i32.add
              (i32.load
                (global.get $var_arr))
              (i32.mul
                (i32.const 8)
                (i32.const 4))))
          (i32.const 200)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.lt_s
        (i32.const 9)
        (i32.const 0))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.ge_s
        (i32.const 9)
        (i32.load offset=4
          (global.get $var_arr)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.eqz
        (i32.eq
          (i32.load
            (i32.add
              (i32.load
                (global.get $var_arr))
              (i32.mul
                (i32.const 9)
                (i32.const 4))))
          (i32.const 500)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (call $writeS
      (i32.load
        (i32.const 168))
      (i32.load offset=4
        (i32.const 168))))
  (func $fun_insertionSort (param $cenv i32) (param $arg_arr i32)
    (local $var_i i32) (local $var_j i32) (local $var_key i32) (local $var_len i32)
    (local.set $var_len
      (i32.load offset=4
        (local.get $arg_arr)))
    (local.set $var_i
      (i32.const 0))
    (local.set $var_i
      (i32.const 1))
    (block $loop_exit$0
      (loop $loop_begin$1
        (br_if $loop_exit$0
          (i32.eqz
            (i32.lt_s
              (local.get $var_i)
              (local.get $var_len))))
        (if  ;; label = @3
          (i32.lt_s
            (local.get $var_i)
            (i32.const 0))
          (then
            (global.set $exit_code
              (i32.const 42))
            (unreachable)))
        (if  ;; label = @3
          (i32.ge_s
            (local.get $var_i)
            (i32.load offset=4
              (local.get $arg_arr)))
          (then
            (global.set $exit_code
              (i32.const 42))
            (unreachable)))
        (local.set $var_key
          (i32.load
            (i32.add
              (i32.load
                (local.get $arg_arr))
              (i32.mul
                (local.get $var_i)
                (i32.const 4)))))
        (local.set $var_j
          (i32.sub
            (local.get $var_i)
            (i32.const 1)))
        (block $loop_exit
          (loop $loop_begin
            (br_if $loop_exit
              (i32.eqz
                (if (result i32)  ;; label = @5
                  (i32.ge_s
                    (local.get $var_j)
                    (i32.const 0))
                  (then
                    (if  ;; label = @6
                      (i32.lt_s
                        (local.get $var_j)
                        (i32.const 0))
                      (then
                        (global.set $exit_code
                          (i32.const 42))
                        (unreachable)))
                    (if  ;; label = @6
                      (i32.ge_s
                        (local.get $var_j)
                        (i32.load offset=4
                          (local.get $arg_arr)))
                      (then
                        (global.set $exit_code
                          (i32.const 42))
                        (unreachable)))
                    (i32.gt_s
                      (i32.load
                        (i32.add
                          (i32.load
                            (local.get $arg_arr))
                          (i32.mul
                            (local.get $var_j)
                            (i32.const 4))))
                      (local.get $var_key)))
                  (else
                    (i32.const 0)))))
            (if  ;; label = @5
              (i32.lt_s
                (i32.add
                  (local.get $var_j)
                  (i32.const 1))
                (i32.const 0))
              (then
                (global.set $exit_code
                  (i32.const 42))
                (unreachable)))
            (if  ;; label = @5
              (i32.ge_s
                (i32.add
                  (local.get $var_j)
                  (i32.const 1))
                (i32.load offset=4
                  (local.get $arg_arr)))
              (then
                (global.set $exit_code
                  (i32.const 42))
                (unreachable)))
            (i32.add
              (i32.load
                (local.get $arg_arr))
              (i32.mul
                (i32.add
                  (local.get $var_j)
                  (i32.const 1))
                (i32.const 4)))
            (if  ;; label = @5
              (i32.lt_s
                (local.get $var_j)
                (i32.const 0))
              (then
                (global.set $exit_code
                  (i32.const 42))
                (unreachable)))
            (if  ;; label = @5
              (i32.ge_s
                (local.get $var_j)
                (i32.load offset=4
                  (local.get $arg_arr)))
              (then
                (global.set $exit_code
                  (i32.const 42))
                (unreachable)))
            (i32.load
              (i32.add
                (i32.load
                  (local.get $arg_arr))
                (i32.mul
                  (local.get $var_j)
                  (i32.const 4))))
            (i32.store)
            (local.set $var_j
              (i32.sub
                (local.get $var_j)
                (i32.const 1)))
            (br $loop_begin)))
        (if  ;; label = @3
          (i32.lt_s
            (i32.add
              (local.get $var_j)
              (i32.const 1))
            (i32.const 0))
          (then
            (global.set $exit_code
              (i32.const 42))
            (unreachable)))
        (if  ;; label = @3
          (i32.ge_s
            (i32.add
              (local.get $var_j)
              (i32.const 1))
            (i32.load offset=4
              (local.get $arg_arr)))
          (then
            (global.set $exit_code
              (i32.const 42))
            (unreachable)))
        (i32.store
          (i32.add
            (i32.load
              (local.get $arg_arr))
            (i32.mul
              (i32.add
                (local.get $var_j)
                (i32.const 1))
              (i32.const 4)))
          (local.get $var_key))
        (i32.load
          (i32.add
            (i32.load
              (local.get $arg_arr))
            (i32.mul
              (i32.add
                (local.get $var_j)
                (i32.const 1))
              (i32.const 4))))
        (local.set $var_i
          (i32.add
            (local.get $var_i)
            (i32.const 1)))
        (br $loop_begin$1))))
  (func $fun_printArray (param $cenv i32) (param $arg_arr$2 i32)
    (local $var_x i32)
    (local.set $var_x
      (i32.const 0))
    (if  ;; label = @1
      (i32.lt_s
        (local.get $var_x)
        (i32.const 0))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (if  ;; label = @1
      (i32.ge_s
        (local.get $var_x)
        (i32.load offset=4
          (local.get $arg_arr$2)))
      (then
        (global.set $exit_code
          (i32.const 42))
        (unreachable)))
    (call $writeInt
      (i32.load
        (i32.add
          (i32.load
            (local.get $arg_arr$2))
          (i32.mul
            (local.get $var_x)
            (i32.const 4)))))
    (local.set $var_x
      (i32.add
        (local.get $var_x)
        (i32.const 1)))
    (block $loop_exit$3
      (loop $loop_begin$4
        (br_if $loop_exit$3
          (i32.eqz
            (i32.lt_s
              (local.get $var_x)
              (i32.load offset=4
                (local.get $arg_arr$2)))))
        (if  ;; label = @3
          (i32.lt_s
            (local.get $var_x)
            (i32.const 0))
          (then
            (global.set $exit_code
              (i32.const 42))
            (unreachable)))
        (if  ;; label = @3
          (i32.ge_s
            (local.get $var_x)
            (i32.load offset=4
              (local.get $arg_arr$2)))
          (then
            (global.set $exit_code
              (i32.const 42))
            (unreachable)))
        (call $writeInt
          (i32.load
            (i32.add
              (i32.load
                (local.get $arg_arr$2))
              (i32.mul
                (local.get $var_x)
                (i32.const 4)))))
        (local.set $var_x
          (i32.add
            (local.get $var_x)
            (i32.const 1)))
        (br $loop_begin$4))))
  (data (;0;) (i32.const 0) "\00")
  (data (;1;) (i32.const 4) "\01")
  (data (;2;) (i32.const 8) "\14\00\00\00\13\00\00\00\11\00\00\00")
  (data (;3;) (i32.const 20) "\f0\9f\98\b0 initial array:")
  (data (;4;) (i32.const 39) "3\00\00\00&\00\00\00$\00\00\00")
  (data (;5;) (i32.const 51) "\f0\9f\a4\94 sorting array... (insertion sort)")
  (data (;6;) (i32.const 89) "e\00\00\00&\00\00\00&\00\00\00")
  (data (;7;) (i32.const 101) "--------------------------------------")
  (data (;8;) (i32.const 139) "\97\00\00\00\11\00\00\00\0f\00\00\00")
  (data (;9;) (i32.const 151) "\e2\9c\85 sorted array:")
  (data (;10;) (i32.const 168) "\b4\00\00\00\07\00\00\00\05\00\00\00")
  (data (;11;) (i32.const 180) "done\e2\9c\85")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
  (type (;1;) (func (param i32)))
  (type (;2;) (func)))
