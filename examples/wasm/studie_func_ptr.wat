(module
 (type $i32_=>_i32 (func (param i32) (result i32)))
 (type $none_=>_none (func))
 (global $assembly/index/g i32 (i32.const 32))
 (global $~argumentsLength (mut i32) (i32.const 0))
 (global $assembly/index/r (mut i32) (i32.const 0))
 (global $~lib/memory/__data_end i32 (i32.const 44))
 (global $~lib/memory/__stack_pointer (mut i32) (i32.const 32812))
 (global $~lib/memory/__heap_base i32 (i32.const 32812))
 (data  (i32.const 12) "\1c\00\00\00\00\00\00\00\00\00\00\00\04\00\00\00\08\00\00\00\01\00\00\00\00\00\00\00\00\00\00\00")
 (table  2 2 funcref)
 (elem  (i32.const 1) $assembly/index/f)
 (memory (export "memory") 1)
 (export "_start" (func $~start))
 (func $assembly/index/f (param $i i32) (result i32)
  local.get $i
  i32.const 3
  i32.mul
  return
 )
 (func $start:assembly/index
  i32.const 3
  i32.const 1
  global.set $~argumentsLength
  global.get $assembly/index/g
  i32.load 
  call_indirect  (type $i32_=>_i32)
  global.set $assembly/index/r
 )
 (func $~start
  call $start:assembly/index
 )
)
