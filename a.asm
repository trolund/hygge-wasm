.data:

.text:
    mv fp, sp  # Initialize frame pointer
    li t0, 5
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    li a0, 8  # Amount of memory to allocate for the array struct {data, length} (in bytes)
    li a7, 9  # RARS syscall: Sbrk
    ecall
    mv t1, a0  # Move syscall result (struct mem address) to target
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    mv t6, t1  # Move adrress to t6
    mv t1, t0  # Load variable 'n'
    sw t1, 4(t6)  # Initialize array length field
    mv t4, t1  # Move length to t4
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    li a0, 4  # 4 (bytes)
    mul a0, a0, t1  # Multiply length * 4 to get array size
    li a7, 9  # RARS syscall: Sbrk
    ecall
    mv s1, a0  # Move syscall result (array data mem address) to target+2
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    sw s1, 0(t6)  # Initialize array data field
    mv t5, s1  # Move array data address to t6
    li t1, 1
    li a2, 4  # Load the size of each element in the array
    li a3, 0  # Load the starting index
loop:
    mul s1, a2, a3  # Calculate the offset (index) from the base address
    add s2, t5, s1  # Calculate the address of the element
    sw t1, 0(s2)  # Store the value in the element
    addi a3, a3, 1  # Increment the index
    blt a3, t4, loop  # Loop if the index is less than the ending index
    mv t1, t6  # Move array mem address to target register
    # Allocation done
    # Array element assignment begin
    mv t2, t1  # Load variable 'arr'
    lw t2, 0(t2)  # Copying array address to target register
    # Index begin
    li s1, 0
    # Right hand side begin
    # Array element lookup
    mv s2, t1  # Load variable 'arr'
    lw s3, 0(s2)  # Load array data pointer
    li s2, 0
    li t3, 4  # Load the size of each element in the array
    mul s2, s2, t3  # Calculate the offset (index) from the base address
    add s2, s2, s3  # Compute array element address
    lw s2, 0(s2)  # Load array element
    mv s3, t0  # Load variable 'n'
    add s2, s2, s3
    li s3, 4  # Loading size of array element
    mul s1, s1, s3  # Multiplying index by size of array element
    sw s1, 0(t2)  # Copying index to array address
    sw s2, 0(t2)  # Assigning value to array element
    mv t2, s2  # Copying assigned value to target register
    # Array element assignment begin
    mv t2, t1  # Load variable 'arr'
    lw t2, 0(t2)  # Copying array address to target register
    # Index begin
    li s1, 1
    # Right hand side begin
    # Array element lookup
    mv s2, t1  # Load variable 'arr'
    lw s3, 0(s2)  # Load array data pointer
    li s2, 1
    li t3, 4  # Load the size of each element in the array
    mul s2, s2, t3  # Calculate the offset (index) from the base address
    add s2, s2, s3  # Compute array element address
    lw s2, 0(s2)  # Load array element
    mv s3, t0  # Load variable 'n'
    add s2, s2, s3
    li s3, 1
    add s2, s2, s3
    li s3, 4  # Loading size of array element
    mul s1, s1, s3  # Multiplying index by size of array element
    sw s1, 0(t2)  # Copying index to array address
    sw s2, 0(t2)  # Assigning value to array element
    mv t2, s2  # Copying assigned value to target register
    # Array element lookup
    mv t2, t1  # Load variable 'arr'
    lw s1, 0(t2)  # Load array data pointer
    li t2, 0
    li t3, 4  # Load the size of each element in the array
    mul t2, t2, t3  # Calculate the offset (index) from the base address
    add t2, t2, s1  # Compute array element address
    lw t2, 0(t2)  # Load array element
    li s1, 6
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
    # Array element lookup
    mv t2, t1  # Load variable 'arr'
    lw s1, 0(t2)  # Load array data pointer
    li t2, 1
    li t3, 4  # Load the size of each element in the array
    mul t2, t2, t3  # Calculate the offset (index) from the base address
    add t2, t2, s1  # Compute array element address
    lw t2, 0(t2)  # Load array element
    li s1, 7
    beq t2, s1, eq_true_1
    li t2, 0  # Comparison result is false
    j eq_end_2
eq_true_1:
    li t2, 1  # Comparison result is true
eq_end_2:
    addi t2, t2, -1
    beqz t2, assert_true_0  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_0:
    mv t1, t2  # Move 'let' scope result to 'let' target register
    mv t0, t1  # Move 'let' scope result to 'let' target register
    li a7, 10  # RARS syscall: Exit
    ecall  # Successful exit with code 0


