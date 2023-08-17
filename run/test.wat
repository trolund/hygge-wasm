(module
  (func $start  (result i32) ;; function 1 
   i32.const 41
   i32.const 42
   i32.add
   return
)
  (export "start" (func $start))
)