(module
  (type (;0;) (func (param i32) (result i32)))
  (type (;1;) (func (param i32 i32) (result i32)))
  (type (;2;) (func (result i32)))
  (import "env" "malloc" (func (;0;) (type 0)))
  (func (;1;) (type 2) (result i32)
    global.get 2
    i32.load offset=4
    i32.const 2
    global.get 2
    i32.load
    call_indirect (type 1)
    global.set 4
    global.get 2
    i32.load offset=4
    i32.const 4
    global.get 2
    i32.load
    call_indirect (type 1)
    global.set 5
    global.get 2
    i32.load offset=4
    i32.const 8
    global.get 2
    i32.load
    call_indirect (type 1)
    global.set 6
    global.get 4
    i32.load offset=4
    global.get 4
    i32.load
    call_indirect (type 0)
    i32.const 4
    i32.eq
    i32.eqz
    if  ;; label = @1
      i32.const 42
      global.set 0
      unreachable
    end
    global.get 4
    i32.load offset=4
    global.get 4
    i32.load
    call_indirect (type 0)
    i32.const 8
    i32.eq
    i32.eqz
    if  ;; label = @1
      i32.const 42
      global.set 0
      unreachable
    end
    global.get 5
    i32.load offset=4
    global.get 5
    i32.load
    call_indirect (type 0)
    i32.const 8
    i32.eq
    i32.eqz
    if  ;; label = @1
      i32.const 42
      global.set 0
      unreachable
    end
    global.get 6
    i32.load offset=4
    global.get 6
    i32.load
    call_indirect (type 0)
    i32.const 16
    i32.eq
    i32.eqz
    if  ;; label = @1
      i32.const 42
      global.set 0
      unreachable
    end
    global.get 6
    i32.load offset=4
    global.get 6
    i32.load
    call_indirect (type 0)
    i32.const 128
    i32.eq
    i32.eqz
    if  ;; label = @1
      i32.const 42
      global.set 0
      unreachable
    end
    i32.const 0
    return)
  (func (;2;) (type 0) (param i32) (result i32)
    (local i32)
    local.get 0
    i32.load
    local.get 0
    i32.load
    i32.load
    local.get 0
    i32.load offset=4
    i32.mul
    i32.store
    local.get 0
    i32.load
    i32.load)
  (func (;3;) (type 1) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32)
    local.get 1
    local.set 6
    i32.const 1
    i32.const 4
    i32.mul
    call 0
    local.set 2
    local.get 2
    i32.const 0
    i32.add
    i32.const 2
    i32.store
    local.get 2
    local.set 5
    i32.const 2
    i32.const 4
    i32.mul
    call 0
    local.set 4
    local.get 4
    i32.const 0
    i32.add
    i32.const 1
    i32.store
    local.get 4
    i32.const 4
    i32.add
    i32.const 0
    i32.store
    local.get 4
    i32.const 4
    i32.add
    i32.const 2
    i32.const 4
    i32.mul
    call 0
    local.set 3
    local.get 3
    i32.const 0
    i32.add
    local.get 5
    i32.store
    local.get 3
    i32.const 4
    i32.add
    local.get 6
    i32.store
    local.get 3
    i32.store
    local.get 4
    global.set 1
    global.get 1)
  (table (;0;) 2 funcref)
  (memory (;0;) 1)
  (global (;0;) (mut i32) (i32.const 0))
  (global (;1;) (mut i32) (i32.const 4))
  (global (;2;) (mut i32) (i32.const 0))
  (global (;3;) i32 (i32.const 8))
  (global (;4;) (mut i32) (i32.const 0))
  (global (;5;) (mut i32) (i32.const 0))
  (global (;6;) (mut i32) (i32.const 0))
  (export "memory" (memory 0))
  (export "_start" (func 1))
  (export "exit_code" (global 0))
  (export "heap_base_ptr" (global 3))
  (elem (;0;) (i32.const 0) func 3)
  (elem (;1;) (i32.const 1) func 2)
  (data (;0;) (i32.const 0) "\00")
  (data (;1;) (i32.const 4) "\01"))
