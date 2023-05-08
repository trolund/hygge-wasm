.data:

.text:
    mv fp, sp  # Initialize frame pointer
    li t0, 5
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
    li t0, 5
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
    # Array slice begin
    li t1, 2
    li a7, 0  # Set a7 to 0
    bge t1, a7, start_index_ok  # Check if start index >= 0
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # load exit code
    ecall  # Call exit
start_index_ok:  # start index is ok
    li t2, 4
    sub s2, t2, t1  # Subtracting start index from end index
    li s3, 0
    blt s3, s2, length_ok_0  # Check if length is less then 1
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
length_ok_0:  # length is ok
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    li a0, 8  # Amount of memory to allocate for the array struct {data, length} (in bytes)
    li a7, 9  # RARS syscall: Sbrk
    ecall
    mv t2, a0  # Move syscall result (struct mem address) to target + 1u
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    mv t6, t2  # Move array struct adrress to t6
    sw t1, 4(t6)  # Initialize array length field
    mv t4, t1  # Move length to t4
    mv t0, t0  # Load variable 'arr'
    li t1, 2
    lw s1, 4(t0)  # Load length to t5
    blt t1, s1, start_index_ok_1  # Check if start_index < length_of_original_array
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # load exit code
    ecall  # Call exit
start_index_ok_1:  # start index is ok
    li t1, 4
    lw s1, 4(t0)  # Load length to t5
    blt t1, s1, end_index_ok  # Check if end_index < length_of_original_array
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # load exit code
    ecall  # Call exit
end_index_ok:  # end index is ok
    li a0, 4  # (in bytes)
    mul t4, t4, a0  # Multiply start index by 4
    add t5, t5, t4  # Add start index to array struct address
    sw t5, 0(t6)  # Initialize array data pointer field
    mv t1, t6  # Move array struct address to target
    mv t2, t1  # Load variable 'sliced'
    lw t2, 4(t2)  # Load array length
    li s1, 2
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


