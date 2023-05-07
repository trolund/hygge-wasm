.data:

.text:
    mv fp, sp  # Initialize frame pointer
    li t0, 42
    li t1, 2
    slli t0, t0, 1
    li t0, 42
    li t1, 4
    slli t0, t0, 2
    li t0, 42
    li t1, 6
    mul t0, t0, t1
    li t0, 42
    li t1, 8
    slli t0, t0, 3
    li t0, 42
    li t1, 12
    mul t0, t0, t1
    li t1, 2
    slli t0, t0, 1
    li a7, 10  # RARS syscall: Exit
    ecall  # Successful exit with code 0