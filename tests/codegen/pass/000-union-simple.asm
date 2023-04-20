.data:
string_val:
    .string "Some"

.text:
    mv fp, sp  # Initialize frame pointer
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    li a0, 8  # Amount of memory to allocate on heap for one label (in bytes)
    li a7, 9  # RARS syscall: Sbrk
    ecall
    mv t0, a0  # Move syscall result to target (pointer to label)
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    la t1, string_val
    sw t1, 0(t0)  # Store label on heap
    li t2, 42
    sw t2, 4(t0)  # Store node on heap
    mv t1, t0  # Load variable 'x'
    mv t0, t1  # Move 'let' scope result to 'let' target register
    li a7, 10  # RARS syscall: Exit
    ecall  # Successful exit with code 0


