.data:

.text:
    mv fp, sp  # Initialize frame pointer
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    li a0, 8  # Amount of memory to allocate for the array struct {data, length} (in bytes)
    li a7, 9  # RARS syscall: Sbrk
    ecall
    mv t0, a0  # Move syscall result (struct mem address) to target
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    mv t6, t0  # Move adrress to t6
    li t0, 2
    li t1, 2
    add t0, t0, t1
    sw t0, 4(t6)  # Initialize array length field
    mv t4, t0  # Move length to t4
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    li a0, 4  # 4 (bytes)
    mul a0, a0, t0  # Multiply length * 4 to get array size
    li a7, 9  # RARS syscall: Sbrk
    ecall
    mv t2, a0  # Move syscall result (array data mem address) to target+2
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    sw t2, 0(t6)  # Initialize array data field
    mv t5, t2  # Move array data address to t6
    li t0, 40
    li t1, 2
    add t0, t0, t1
    li a2, 4  # Load the size of each element in the array
    li a3, 0  # Load the starting index
loop:
    mul t1, a2, a3  # Calculate the offset (index) from the base address
    add t1, t5, t1  # Calculate the address of the element
    sw t0, 0(t1)  # Store the value in the element
    addi a3, a3, 1  # Increment the index
    blt a3, t4, loop  # Loop if the index is less than the ending index
    mv t0, t6  # Move array mem address to target register
    # Allocation done
    # Array element lookup
    mv t1, t0  # Load variable 'arr'
    lw t2, 0(t1)  # Load array data pointer
    li t1, 2
    add t1, t1, t2  # Compute array element address
    li t3, 4  # Load the size of each element in the array
    mul t1, t1, t3  # Calculate the offset (index) from the base address
    lw t1, 0(t1)  # Load array element
    mv t2, t1  # Load variable 'x'
    li s1, 42
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


