(module
  (func $main  (result i32) ;; entry point of program (main function) 
    ;; execution start here:
    (local $var_x_0 i32) ;; delcare local var $var_x_0
    i32.const 0 ;; push 0 on stack
    local.set $var_x_0 ;; set local var
    (local $var_x_0 i32) ;; delcare local var $var_x_0
    i32.const 42 ;; push 42 on stack
    local.set $var_x_0 ;; set local var
    i32.const 3 ;; push 3 on stack
    local.get $var_x_0
    i32.lt_s
    (if  (result i32)
 (then
i32.const 1 ;; 

) (else
i32.const 0 ;; 

)
)
    (if 
 (then
nop ;; 

) (else
i32.const 42 ;; 
return ;; 

)
)
    local.get $var_x_0
    (local $var_x_0 i32) ;; delcare local var $var_x_0
    i32.const 42 ;; push 42 on stack
    local.set $var_x_0 ;; set local var
    i32.const 3 ;; push 3 on stack
    local.get $var_x_0
    i32.lt_s
    (if  (result i32)
 (then
i32.const 1 ;; 

) (else
i32.const 0 ;; 

)
)
    (if 
 (then
nop ;; 

) (else
i32.const 42 ;; 
return ;; 

)
)
    i32.const 3 ;; push 3 on stack
    i32.lt_s
    (if  (result i32)
 (then
(local $var_x_0 i32) ;; delcare local var $var_x_0
i32.const 42 ;; push 42 on stack
local.set $var_x_0 ;; set local var
i32.const 3 ;; push 3 on stack
local.get $var_x_0 ;; 
i32.lt_s ;; 
(if  (result i32)
 (then
i32.const 1 ;; 

) (else
i32.const 0 ;; 

)
) ;; 
(if 
 (then
nop ;; 

) (else
i32.const 42 ;; 
return ;; 

)
) ;; 
i32.const 1 ;; 

) (else
(local $var_x_0 i32) ;; delcare local var $var_x_0
i32.const 42 ;; push 42 on stack
local.set $var_x_0 ;; set local var
i32.const 3 ;; push 3 on stack
local.get $var_x_0 ;; 
i32.lt_s ;; 
(if  (result i32)
 (then
i32.const 1 ;; 

) (else
i32.const 0 ;; 

)
) ;; 
(if 
 (then
nop ;; 

) (else
i32.const 42 ;; 
return ;; 

)
) ;; 
i32.const 0 ;; 

)
)
    (if 
 (then
nop ;; 

) (else
i32.const 42 ;; 
return ;; 

)
)
    ;; if execution reaches here, the program is successful
    i32.const 0 ;; exit code 0
    return ;; return the exit code
  )
  (export "main" (func $main))
)