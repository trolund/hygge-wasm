This exsample lets the prgram use an index to point to a function - therefore basicly a function pointer.

```wat
(module
  
  (type $add-func (func (param i32 i32) (result i32)))
  (type $sub-func (func (param i32 i32) (result i32)))
  (table $func-table 2 funcref) ;; Define a function table with space for 2 function pointers

  (elem (i32.const 0) $add) ;; Populate the function table with function pointers
  (elem (i32.const 1) $sub)

  (func $add (type $add-func) (param $a i32) (param $b i32) (result i32)
    (local.get $a)
    (local.get $b)
    (i32.add)
  )

  (func $sub (type $sub-func) (param $a i32) (param $b i32) (result i32)
    (local.get $a)
    (local.get $b)
    (i32.sub)
  )

  (func (export "_start") (result i32)
    (i32.const 4) ;; arg 1
    (i32.const 4) ;; arg 2
    (i32.const 0) ;; index of function
    (call_indirect (type $add-func)) ;; Call the function indirectly

    (i32.const 0)
    return
  )
)
```

### This is how AssemblyScript does it:

```ts
function f(i: i32): i32 { return i * 3 }
const g: (i: i32) => i32 = f;
const r: i32 = g(3);
```

Compile to:

    global0 have been initialized to 32. on this position in memory is the value [1]

    global0 = f
    global1 = g
    global2 = r
    
    [1] is the index of the function f in the table. 

```wat
(module
  (table $table0 2 2 funcref)
  (memory $memory (;0;) (export "memory") 1)
  (global $global0 i32 (i32.const 32))
  (global $global1 (mut i32) (i32.const 0))
  (global $global2 (mut i32) (i32.const 0))
  (global $global3 i32 (i32.const 44))
  (global $global4 (mut i32) (i32.const 32812))
  (global $global5 i32 (i32.const 32812))
  (elem $elem0 (i32.const 1) funcref (ref.func $func0))
  (func $func0 (param $var0 i32) (result i32)
    local.get $var0
    i32.const 3
    i32.mul
    return
  )
  (func $func1
    i32.const 3
    i32.const 1
    global.set $global1
    global.get $global0
    i32.load
    call_indirect (param i32) (result i32)
    global.set $global2
  )
  (func $_start (;2;) (export "_start")
    call $func1
  )
  (data (i32.const 12) "\1c\00\00\00\00\00\00\00\00\00\00\00\04\00\00\00\08\00\00\00\01\00\00\00\00\00\00\00\00\00\00\00")
)
```