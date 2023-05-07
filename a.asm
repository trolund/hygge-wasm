.data:

.text:
    mv fp, sp  # Initialize frame pointer
    li t0, 4
    li t1, 0
    blt t1, t0, length_ok  # Check if length is less then 1
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
length_ok:  # length is ok
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
    li t0, 4
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
    li t0, 42
    li a2, 4  # Load the size of each element in the array
    li a3, 0  # Load the starting index
loop_begin:
    mul t2, a2, a3  # Calculate the offset (index) from the base address
    add s1, t5, t2  # Calculate the address of the element
    sw t0, 0(s1)  # Store the value in the element
    addi a3, a3, 1  # Increment the index
    blt a3, t4, loop_begin  # Loop if the index is less than the ending index
    mv t0, t6  # Move struct array mem address to target register
    # Allocation done
    mv t1, t0  # Load variable 'arr'
    lw t2, 0(t1)  # Load array data pointer
    lw s3, 4(t1)  # Copying array length to target register + 4
    li t1, 2
    blt t1, s3, index_ok  # Check if index less then length
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
index_ok:  # Index is ok
    li a7, 0  # Set a7 to 0
    bge t1, a7, index_ok_0  # Check if index >= 0
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
index_ok_0:  # Index is ok
    li t3, 4  # Load the size of each element in the array
    mul t1, t1, t3  # Calculate the offset (index) from the base address
    add t1, t1, t2  # Compute array element address
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
    # Array slice begin
    li t2, 1
    li s1, 2
    sub t2, s1, t2  # Subtracting start index from end index
    li s1, 0
    blt s1, t2, length_ok_1  # Check if length is less then 1
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
length_ok_1:  # length is ok
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    li a0, 8  # Amount of memory to allocate for the array struct {data, length} (in bytes)
    li a7, 9  # RARS syscall: Sbrk
    ecall
    mv s1, a0  # Move syscall result (struct mem address) to target + 1u
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    mv t6, s1  # Move array struct adrress to t6
    sw t2, 4(t6)  # Initialize array length field
    mv t4, t2  # Move length to t4
    mv t1, t0  # Load variable 'arr'
    li t2, 1
    li a0, 4  # (in bytes)
    mul t4, t4, a0  # Multiply start index by 4
    add t6, t6, t4  # Add start index to array struct address
    sw s2, 0(t6)  # Initialize array data pointer field
    mv t2, t6  # Move array struct address to target
    mv s1, t2  # Load variable 'sliced'
    lw s2, 0(s1)  # Load array data pointer
    lw s5, 4(s1)  # Copying array length to target register + 4
    li s1, 0
    blt s1, s5, index_ok_2  # Check if index less then length
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
index_ok_2:  # Index is ok
    li a7, 0  # Set a7 to 0
    bge s1, a7, index_ok_3  # Check if index >= 0
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
index_ok_3:  # Index is ok
    li t3, 4  # Load the size of each element in the array
    mul s1, s1, t3  # Calculate the offset (index) from the base address
    add s1, s1, s2  # Compute array element address
    lw s1, 0(s1)  # Load array element
    mv s2, s1  # Load variable 'y'
    li s3, 42
    beq s2, s3, eq_true_5
    li s2, 0  # Comparison result is false
    j eq_end_6
eq_true_5:
    li s2, 1  # Comparison result is true
eq_end_6:
    addi s2, s2, -1
    beqz s2, assert_true_4  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_4:
    # Array element assignment begin
    mv s2, t0  # Load variable 'arr'
    lw s2, 0(s2)  # Copying array address to target register
    lw s6, -4(s2)  # Copying array length to target register + 4
    # Index begin
    li s3, 1
    blt s3, s6, index_ok_7  # Check if index less then length
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
index_ok_7:  # Index is ok
    li a7, 0  # Set a7 to 0
    bge s3, a7, index_ok_8  # Check if index >= 0
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # load exit code
    ecall  # Call exit
index_ok_8:  # Index is ok
    # Right hand side begin
    li s4, 3
    li s5, 4  # Loading size of array element
    mul s3, s3, s5  # Multiplying index by size of array element
    add s2, s2, s3  # Adding index to array address
    sw s3, 0(s2)  # Copying index to array address
    sw s4, 0(s2)  # Assigning value to array element
    mv s2, s4  # Copying assigned value to target register
    mv s2, t0  # Load variable 'arr'
    lw s3, 0(s2)  # Load array data pointer
    lw s6, 4(s2)  # Copying array length to target register + 4
    li s2, 1
    blt s2, s6, index_ok_10  # Check if index less then length
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
index_ok_10:  # Index is ok
    li a7, 0  # Set a7 to 0
    bge s2, a7, index_ok_11  # Check if index >= 0
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
index_ok_11:  # Index is ok
    li t3, 4  # Load the size of each element in the array
    mul s2, s2, t3  # Calculate the offset (index) from the base address
    add s2, s2, s3  # Compute array element address
    lw s2, 0(s2)  # Load array element
    li s3, 3
    beq s2, s3, eq_true_12
    li s2, 0  # Comparison result is false
    j eq_end_13
eq_true_12:
    li s2, 1  # Comparison result is true
eq_end_13:
    addi s2, s2, -1
    beqz s2, assert_true_9  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_9:
    mv s2, t2  # Load variable 'sliced'
    lw s3, 0(s2)  # Load array data pointer
    lw s6, 4(s2)  # Copying array length to target register + 4
    li s2, 0
    blt s2, s6, index_ok_15  # Check if index less then length
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
index_ok_15:  # Index is ok
    li a7, 0  # Set a7 to 0
    bge s2, a7, index_ok_16  # Check if index >= 0
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
index_ok_16:  # Index is ok
    li t3, 4  # Load the size of each element in the array
    mul s2, s2, t3  # Calculate the offset (index) from the base address
    add s2, s2, s3  # Compute array element address
    lw s2, 0(s2)  # Load array element
    li s3, 3
    beq s2, s3, eq_true_17
    li s2, 0  # Comparison result is false
    j eq_end_18
eq_true_17:
    li s2, 1  # Comparison result is true
eq_end_18:
    addi s2, s2, -1
    beqz s2, assert_true_14  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_14:
    mv s1, s2  # Move 'let' scope result to 'let' target register
    mv t2, s1  # Move 'let' scope result to 'let' target register
    mv t1, t2  # Move 'let' scope result to 'let' target register
    mv t0, t1  # Move 'let' scope result to 'let' target register
    li a7, 10  # RARS syscall: Exit
    ecall  # Successful exit with code 0


