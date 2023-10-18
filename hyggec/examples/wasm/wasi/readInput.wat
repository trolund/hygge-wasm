(module
  (type $write_type (func (param i32 i32 i32 i32) (result i32)))
  (import "wasi_snapshot_preview1" "fd_write" (func $fd_write (type $write_type)))
  (memory (export "memory") 1)
  (data (i32.const 8) "Hello, WASI!\n")

  (func $main (result i32)
    (i32.store (i32.const 0) (i32.const 8))  ;; iov.iov_base - This is a pointer to the start of the 'hello world\n' string
    (i32.store (i32.const 4) (i32.const 13))  ;; iov.iov_len - The length of the 'hello world\n' string
    ;; Prepare parameters for fd_write
    i32.const 0         ;; File descriptor (0 represents stdin)
    i32.const 0         ;; Pointer to the data to be written
    i32.const 1         ;; Length of the data
    i32.const 20        ;; Pointer to store the number of bytes written (not used in this example)

    ;; Call fd_write
    call $fd_write
  )

  (export "_start" (func $main))
)
