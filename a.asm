.data:

.text:
    mv fp, sp  # Initialize frame pointer
    li t0, 2
    li t1, 2
    add t0, t0, t1
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    li a0, 4  # length * 4 (in bytes)
    mul a0, a0, t0  # Multiply array length to get size by number of structs
    li a7, 9  # RARS syscall: Sbrk
    ecall
    mv t0, a0  # Move syscall result (struct mem address) to target, stores the address of the allocated memory block in t0
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    li t0, 40
    li t1, 2
    add t0, t0, t1
    li t2, 4  # Load the size of each element in the array
    li t3, 1  # Load the starting index
    li t4, 5  # Load the ending index
    li t1, 1  # Initialize the counter to 1
loop:
    mul t5, t2, t3  # Calculate the offset from the base address
    add t6, t0, t5  # Calculate the address of the element
    sw t0, 0(t6)  # Store the value in the element
    addi t1, t1, 1  # Increment the counter
    addi t3, t3, 1  # Increment the index
    blt t3, t4, loop  # Loop if the index is less than the ending index
    mv t1, t0  # Load variable 'arr'
    lw t1, 0(t1)  # Load array length
    mv t2, t1  # Load variable 'len'
    li s1, 4
    beq t2, s1, eq_true
    li t2, 0  # Comparison result is false
    j eq_end
eq_true:
    li t2, 1  # Comparison result is true
eq_end:
    addi t2, t2, -1
    beqz t2, assert_true  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true:
    mv t1, t2  # Move 'let' scope result to 'let' target register
    mv t0, t1  # Move 'let' scope result to 'let' target register
    li a7, 10  # RARS syscall: Exit
    ecall  # Successful exit with code 0


