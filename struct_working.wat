;; works with wasm-as and wasm-tools
;; wasm-as --debug --enable-gc --enable-reference-types  --no-validation struct_working.wat
;; wasm-tools parse struct_working.wat -o struct_working.wasm
(module
  (type $sType (;0;) (struct (field $f (mut i32))))
  (func $_start (;0;)  (result i32) 
    ;; execution start here:
    ;; Start of let
    (drop
      (struct.new $sType
        (i32.const 10)
      )
    )
    (i32.const 10) ;; push 10 on stack
    ;; End of let
    ;; if execution reaches here, the program is successful
  )
  (export "_start" (func $_start))
)