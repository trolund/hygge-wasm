.data:

.text:
    mv fp, sp  # Initialize frame pointer
    li t0, 3
    mv t1, t0  # Load variable 'x'
    seqz t1, t1
    mv t0, t1  # Move 'let' scope result to 'let' target register
    li a7, 10  # RARS syscall: Exit
    ecall  # Successful exit with code 0


