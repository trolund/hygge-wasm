(module
  (type $i32_=>_i32 (;0;) (func (param i32) (result i32)))
  (memory (;0;) (export "memory") 1)
  (global $exit_code (;0;) (mut i32) (i32.const 0))
  (global $fun__start$1*ptr (;1;) (mut i32) (i32.const 8))
  (global $fun__start$1/anonymous*ptr (;2;) (mut i32) (i32.const 12))
  (global $fun__start*ptr (;3;) (mut i32) (i32.const 0))
  (global $fun__start/anonymous*ptr (;4;) (mut i32) (i32.const 4))
  (global $heap_base (;5;) (mut i32) (i32.const 16))
  (global $var_c1 (;6;) (mut i32) (i32.const 0))
  (table $func_table (;0;) 4 funcref)
  (elem (i32.const 0) (;0;) $fun__start)
  (elem (i32.const 1) (;1;) $fun__start/anonymous)
  (elem (i32.const 2) (;2;) $fun__start$1)
  (elem (i32.const 3) (;3;) $fun__start$1/anonymous)
  (func $_start (;0;)   
    ;; execution start here:
    ;; Start of let
    ;; Load expression to be applied as a function
    global.get $fun__start$1*ptr ;; get global var: fun__start$1*ptr
    i32.load offset=4 ;; load closure environment pointer
    global.get $fun__start$1*ptr ;; get global var: fun__start$1*ptr
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    global.set $var_c1 ;; set local var, have been promoted
    ;; Load expression to be applied as a function
    global.get $var_c1 ;; get local var: var_c1, have been promoted
    i32.load offset=4 ;; load closure environment pointer
    global.get $var_c1 ;; get local var: var_c1, have been promoted
    i32.load ;; load table index
    call_indirect (type $i32_=>_i32) ;; call function
    i32.const 10 ;; push 10 on stack
    i32.eq ;; equality check
    i32.eqz ;; invert assertion
    if 
      i32.const 42 ;; error exit code push to stack
      global.set $exit_code ;; set exit code
      unreachable ;; exit program
    end
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (func $fun__start (;1;) (param $cenv i32) (result i32) 
     ;; local variables declarations:
    (local $Sptr i32)
    (local $Sptr$0 i32)

    ;; start of struct contructor
    global.get $heap_base ;; get heap base
    i32.const 8 ;; size of struct
    i32.add ;; find size need to allocate
    memory.size ;; memory size
    i32.const 65536 ;; page size
    i32.mul ;; find current size
    i32.ge_s ;; size need > current size
    if 
      global.get $heap_base ;; get heap base
      i32.const 8 ;; size of struct
      i32.add ;; find size need to allocate
      i32.const 65536 ;; page size
      i32.div_s ;; grow memory!
      memory.grow ;; grow memory if needed
      drop ;; drop new size
    end
    global.get $heap_base ;; leave current heap base address
    global.get $heap_base ;; get current heap base
    i32.const 8 ;; size of struct
    i32.add ;; add size to heap base
    global.set $heap_base ;; set base pointer
    local.set $Sptr ;; set struct pointer var
    local.get $Sptr ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field (func)
    i32.const 1 ;; push 1 on stack
    i32.store ;; store int field in memory
    local.get $Sptr ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field (cenv)
    ;; start of struct contructor
    global.get $heap_base ;; get heap base
    i32.const 0 ;; size of struct
    i32.add ;; find size need to allocate
    memory.size ;; memory size
    i32.const 65536 ;; page size
    i32.mul ;; find current size
    i32.ge_s ;; size need > current size
    if 
      global.get $heap_base ;; get heap base
      i32.const 0 ;; size of struct
      i32.add ;; find size need to allocate
      i32.const 65536 ;; page size
      i32.div_s ;; grow memory!
      memory.grow ;; grow memory if needed
      drop ;; drop new size
    end
    global.get $heap_base ;; leave current heap base address
    global.get $heap_base ;; get current heap base
    i32.const 0 ;; size of struct
    i32.add ;; add size to heap base
    global.set $heap_base ;; set base pointer
    local.set $Sptr$0 ;; set struct pointer var
    local.get $Sptr$0 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store int field in memory
    local.get $Sptr ;; push struct address to stack
    ;; end of struct contructor
  )
  (func $fun__start$1 (;2;) (param $cenv i32) (result i32) 
     ;; local variables declarations:
    (local $Sptr$2 i32)
    (local $Sptr$3 i32)

    ;; start of struct contructor
    global.get $heap_base ;; get heap base
    i32.const 8 ;; size of struct
    i32.add ;; find size need to allocate
    memory.size ;; memory size
    i32.const 65536 ;; page size
    i32.mul ;; find current size
    i32.ge_s ;; size need > current size
    if 
      global.get $heap_base ;; get heap base
      i32.const 8 ;; size of struct
      i32.add ;; find size need to allocate
      i32.const 65536 ;; page size
      i32.div_s ;; grow memory!
      memory.grow ;; grow memory if needed
      drop ;; drop new size
    end
    global.get $heap_base ;; leave current heap base address
    global.get $heap_base ;; get current heap base
    i32.const 8 ;; size of struct
    i32.add ;; add size to heap base
    global.set $heap_base ;; set base pointer
    local.set $Sptr$2 ;; set struct pointer var
    local.get $Sptr$2 ;; get struct pointer var
    i32.const 0 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field (func)
    i32.const 3 ;; push 3 on stack
    i32.store ;; store int field in memory
    local.get $Sptr$2 ;; get struct pointer var
    i32.const 4 ;; push field offset to stack
    i32.add ;; add offset to base address
    ;; init field (cenv)
    ;; start of struct contructor
    global.get $heap_base ;; get heap base
    i32.const 0 ;; size of struct
    i32.add ;; find size need to allocate
    memory.size ;; memory size
    i32.const 65536 ;; page size
    i32.mul ;; find current size
    i32.ge_s ;; size need > current size
    if 
      global.get $heap_base ;; get heap base
      i32.const 0 ;; size of struct
      i32.add ;; find size need to allocate
      i32.const 65536 ;; page size
      i32.div_s ;; grow memory!
      memory.grow ;; grow memory if needed
      drop ;; drop new size
    end
    global.get $heap_base ;; leave current heap base address
    global.get $heap_base ;; get current heap base
    i32.const 0 ;; size of struct
    i32.add ;; add size to heap base
    global.set $heap_base ;; set base pointer
    local.set $Sptr$3 ;; set struct pointer var
    local.get $Sptr$3 ;; push struct address to stack
    ;; end of struct contructor
    i32.store ;; store int field in memory
    local.get $Sptr$2 ;; push struct address to stack
    ;; end of struct contructor
  )
  (func $fun__start$1/anonymous (;3;) (param $cenv i32) (result i32) 
    i32.const 10 ;; push 10 on stack
  )
  (func $fun__start/anonymous (;4;) (param $cenv i32) (result i32) 
    i32.const 20 ;; push 20 on stack
  )
  (data (i32.const 0) "\00")
  (data (i32.const 4) "\01")
  (data (i32.const 8) "\02")
  (data (i32.const 12) "\03")
  (export "_start" (func $_start))
  (export "exit_code" (global $exit_code))
  (export "heap_base_ptr" (global $heap_base))
)