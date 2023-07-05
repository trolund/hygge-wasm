# Testing 

All test must have a **'_start'** function as its entry point, otherwise the program will have no way to run the tests.
The **'_start'** function is a convention in WebAssembly that represents the entry point of the module.

Wasm code (.wat file):
```wat
(module
(func (export "_start") (result i32)
    ;; load 42 onto the stack
    i32.const 42
    ;; return the second value (42)
    return
  )
)
```

The following code will start execution as soon as it is loaded in to the VM. 
Seen here: https://developer.mozilla.org/en-US/docs/WebAssembly/Reference/Control_flow/loop

```wat
(start 1) ;; run the first function automatically
```