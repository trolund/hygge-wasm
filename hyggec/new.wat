;; Define two simple functions
(func $printToConsole (import "env" "printToConsole") (param $message i32))
(func $printToAlert (import "env" "printToAlert") (param $message i32))

;; Define a function that takes a function index and a message index
(func $callPrintFunction (param $printerIndex i32) (param $messageIndex i32)
  ;; Call the specified function with the given message
  call_indirect (type $printerType) (local.get $printerIndex) (local.get $messageIndex)
)

;; Define a data segment with the message "Hello, World!"
(data (i32.const 0) "Hello, World!")

;; Define the function types
(type $printerType (func (param i32)))

;; Export the functions
(export "callPrintToConsole" $callPrintFunction)
(export "callPrintToAlert" $callPrintFunction)

;; Declare the start function (entry point)
(start $start)

;; The start function
(func $start
  ;; Call the printToConsole function with the message
  (call $callPrintFunction (i32.const 0) (i32.const 0))
  
  ;; Call the printToAlert function with the message
  (call $callPrintFunction (i32.const 1) (i32.const 0))
)
