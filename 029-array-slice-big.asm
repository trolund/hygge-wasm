.data:

.text:
    mv fp, sp  # Initialize frame pointer
    li t0, 10
    mv t1, t0  # Load variable 'x'
    li t2, 0
    blt t2, t1, length_ok  # Check if length is less then 1
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
    mv t1, a0  # Move syscall result (struct mem address) to target
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    mv t6, t1  # Move adrress to t6
    mv t1, t0  # Load variable 'x'
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
    li t1, 0
    li a2, 4  # Load the size of each element in the array
    li a3, 0  # Load the starting index
loop_begin:
    mul s1, a2, a3  # Calculate the offset (index) from the base address
    add s2, t5, s1  # Calculate the address of the element
    sw t1, 0(s2)  # Store the value in the element
    addi a3, a3, 1  # Increment the index
    blt a3, t4, loop_begin  # Loop if the index is less than the ending index
    mv t1, t6  # Move struct array mem address to target register
    # Allocation done
    li t2, 0
while_loop_begin:
    mv s1, t2  # Load variable 'i'
    mv s2, t1  # Load variable 'arr'
    lw s2, 4(s2)  # Load array length
    blt s1, s2, less_true
    li s1, 0  # Comparison result is false
    j less_end
less_true:
    li s1, 1  # Comparison result is true
less_end:
    beqz s1, while_loop_end  # Jump if 'while' loop condition is false
    # Array element assignment begin
    mv s1, t1  # Load variable 'arr'
    lw s1, 0(s1)  # Copying array address to target register
    lw s5, -4(s1)  # Copying array length to target register + 4
    # Index begin
    mv s2, t2  # Load variable 'i'
    blt s2, s5, index_ok  # Check if index less then length
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
index_ok:  # Index is ok
    li a7, 0  # Set a7 to 0
    bge s2, a7, index_ok_0  # Check if index >= 0
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # load exit code
    ecall  # Call exit
index_ok_0:  # Index is ok
    # Right hand side begin
    mv s3, t2  # Load variable 'i'
    li s4, 4  # Loading size of array element
    mul s2, s2, s4  # Multiplying index by size of array element
    add s1, s1, s2  # Adding index to array address
    sw s2, 0(s1)  # Copying index to array address
    sw s3, 0(s1)  # Assigning value to array element
    mv s1, s3  # Copying assigned value to target register
    mv s1, t2  # Load variable 'i'
    li s2, 1
    add s1, s1, s2
    mv t2, s1  # Assignment to variable i
    j while_loop_begin  # Next iteration of the 'while' loop
while_loop_end:
    # Array slice begin
    li s1, 4
    li a7, 0  # Set a7 to 0
    bge s1, a7, start_index_ok  # Check if start index >= 0
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # load exit code
    ecall  # Call exit
start_index_ok:  # start index is ok
    li s2, 10
    sub s4, s2, s1  # Subtracting start index from end index
    li s5, 0
    blt s5, s4, length_ok_1  # Check if length is less then 1
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
    mv s2, a0  # Move syscall result (struct mem address) to target + 1u
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    mv t6, s2  # Move array struct adrress to t6
    sw s1, 4(t6)  # Initialize array length field
    mv t4, s1  # Move length to t4
    mv t2, t1  # Load variable 'arr'
    li s1, 4
    lw s3, 4(t2)  # Load length to t5
    ble s1, s3, start_index_ok_2  # Check if start_index < length_of_original_array
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # load exit code
    ecall  # Call exit
start_index_ok_2:  # start index is ok
    li s1, 10
    lw s3, 4(t2)  # Load length to t5
    ble s1, s3, end_index_ok  # Check if end_index < length_of_original_array
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # load exit code
    ecall  # Call exit
end_index_ok:  # end index is ok
    li a0, 4  # (in bytes)
    mul t4, t4, a0  # Multiply start index by 4
    add t5, t5, t4  # Add start index to array struct address
    sw t5, 0(t6)  # Initialize array data pointer field
    mv s1, t6  # Move array struct address to target
    mv s2, s1  # Load variable 'sliced'
    lw s2, 4(s2)  # Load array length
    li s3, 6
    beq s2, s3, eq_true
    li s2, 0  # Comparison result is false
    j eq_end
eq_true:
    li s2, 1  # Comparison result is true
eq_end:
    addi s2, s2, -1
    beqz s2, assert_true  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true:
    li s2, 0
while_loop_begin_3:
    mv s3, s2  # Load variable 'j'
    mv s4, s1  # Load variable 'sliced'
    lw s4, 4(s4)  # Load array length
    blt s3, s4, less_true_5
    li s3, 0  # Comparison result is false
    j less_end_6
less_true_5:
    li s3, 1  # Comparison result is true
less_end_6:
    beqz s3, while_loop_end_4  # Jump if 'while' loop condition is false
    # Array element assignment begin
    mv s3, s1  # Load variable 'sliced'
    lw s3, 0(s3)  # Copying array address to target register
    lw s7, -4(s3)  # Copying array length to target register + 4
    # Index begin
    mv s4, s2  # Load variable 'j'
    blt s4, s7, index_ok_7  # Check if index less then length
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
index_ok_7:  # Index is ok
    li a7, 0  # Set a7 to 0
    bge s4, a7, index_ok_8  # Check if index >= 0
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # load exit code
    ecall  # Call exit
index_ok_8:  # Index is ok
    # Right hand side begin
    mv s5, s2  # Load variable 'j'
    li s6, 1000
    add s5, s5, s6
    li s6, 4  # Loading size of array element
    mul s4, s4, s6  # Multiplying index by size of array element
    add s3, s3, s4  # Adding index to array address
    sw s4, 0(s3)  # Copying index to array address
    sw s5, 0(s3)  # Assigning value to array element
    mv s3, s5  # Copying assigned value to target register
    mv s3, s2  # Load variable 'j'
    li s4, 1
    add s3, s3, s4
    mv s2, s3  # Assignment to variable j
    j while_loop_begin_3  # Next iteration of the 'while' loop
while_loop_end_4:
    li s3, 0
    mv s2, s3  # Assignment to variable j
while_loop_begin_9:
    mv s3, s2  # Load variable 'j'
    li s4, 4
    blt s3, s4, less_true_11
    li s3, 0  # Comparison result is false
    j less_end_12
less_true_11:
    li s3, 1  # Comparison result is true
less_end_12:
    beqz s3, while_loop_end_10  # Jump if 'while' loop condition is false
    mv s3, t1  # Load variable 'arr'
    lw s4, 0(s3)  # Load array data pointer
    lw s7, 4(s3)  # Copying array length to target register + 4
    mv s3, s2  # Load variable 'j'
    blt s3, s7, index_ok_14  # Check if index less then length
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
index_ok_14:  # Index is ok
    li a7, 0  # Set a7 to 0
    bge s3, a7, index_ok_15  # Check if index >= 0
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
index_ok_15:  # Index is ok
    li t3, 4  # Load the size of each element in the array
    mul s3, s3, t3  # Calculate the offset (index) from the base address
    add s3, s3, s4  # Compute array element address
    lw s3, 0(s3)  # Load array element
    mv s4, s2  # Load variable 'j'
    beq s3, s4, eq_true_16
    li s3, 0  # Comparison result is false
    j eq_end_17
eq_true_16:
    li s3, 1  # Comparison result is true
eq_end_17:
    addi s3, s3, -1
    beqz s3, assert_true_13  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_13:
    mv s3, s2  # Load variable 'j'
    li s4, 1
    add s3, s3, s4
    mv s2, s3  # Assignment to variable j
    j while_loop_begin_9  # Next iteration of the 'while' loop
while_loop_end_10:
    mv s3, t1  # Load variable 'arr'
    lw s4, 0(s3)  # Load array data pointer
    lw s7, 4(s3)  # Copying array length to target register + 4
    li s3, 4
    blt s3, s7, index_ok_19  # Check if index less then length
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
index_ok_19:  # Index is ok
    li a7, 0  # Set a7 to 0
    bge s3, a7, index_ok_20  # Check if index >= 0
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
index_ok_20:  # Index is ok
    li t3, 4  # Load the size of each element in the array
    mul s3, s3, t3  # Calculate the offset (index) from the base address
    add s3, s3, s4  # Compute array element address
    lw s3, 0(s3)  # Load array element
    li s4, 1000
    beq s3, s4, eq_true_21
    li s3, 0  # Comparison result is false
    j eq_end_22
eq_true_21:
    li s3, 1  # Comparison result is true
eq_end_22:
    addi s3, s3, -1
    beqz s3, assert_true_18  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_18:
    mv s3, t1  # Load variable 'arr'
    lw s4, 0(s3)  # Load array data pointer
    lw s7, 4(s3)  # Copying array length to target register + 4
    li s3, 5
    blt s3, s7, index_ok_24  # Check if index less then length
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
index_ok_24:  # Index is ok
    li a7, 0  # Set a7 to 0
    bge s3, a7, index_ok_25  # Check if index >= 0
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
index_ok_25:  # Index is ok
    li t3, 4  # Load the size of each element in the array
    mul s3, s3, t3  # Calculate the offset (index) from the base address
    add s3, s3, s4  # Compute array element address
    lw s3, 0(s3)  # Load array element
    li s4, 1001
    beq s3, s4, eq_true_26
    li s3, 0  # Comparison result is false
    j eq_end_27
eq_true_26:
    li s3, 1  # Comparison result is true
eq_end_27:
    addi s3, s3, -1
    beqz s3, assert_true_23  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_23:
    mv s3, t1  # Load variable 'arr'
    lw s4, 0(s3)  # Load array data pointer
    lw s7, 4(s3)  # Copying array length to target register + 4
    li s3, 6
    blt s3, s7, index_ok_29  # Check if index less then length
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
index_ok_29:  # Index is ok
    li a7, 0  # Set a7 to 0
    bge s3, a7, index_ok_30  # Check if index >= 0
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
index_ok_30:  # Index is ok
    li t3, 4  # Load the size of each element in the array
    mul s3, s3, t3  # Calculate the offset (index) from the base address
    add s3, s3, s4  # Compute array element address
    lw s3, 0(s3)  # Load array element
    li s4, 1002
    beq s3, s4, eq_true_31
    li s3, 0  # Comparison result is false
    j eq_end_32
eq_true_31:
    li s3, 1  # Comparison result is true
eq_end_32:
    addi s3, s3, -1
    beqz s3, assert_true_28  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_28:
    mv s3, t1  # Load variable 'arr'
    lw s4, 0(s3)  # Load array data pointer
    lw s7, 4(s3)  # Copying array length to target register + 4
    li s3, 7
    blt s3, s7, index_ok_34  # Check if index less then length
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
index_ok_34:  # Index is ok
    li a7, 0  # Set a7 to 0
    bge s3, a7, index_ok_35  # Check if index >= 0
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
index_ok_35:  # Index is ok
    li t3, 4  # Load the size of each element in the array
    mul s3, s3, t3  # Calculate the offset (index) from the base address
    add s3, s3, s4  # Compute array element address
    lw s3, 0(s3)  # Load array element
    li s4, 1003
    beq s3, s4, eq_true_36
    li s3, 0  # Comparison result is false
    j eq_end_37
eq_true_36:
    li s3, 1  # Comparison result is true
eq_end_37:
    addi s3, s3, -1
    beqz s3, assert_true_33  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_33:
    mv s2, s3  # Move 'let' scope result to 'let' target register
    mv s1, s2  # Move 'let' scope result to 'let' target register
    mv t2, s1  # Move 'let' scope result to 'let' target register
    mv t1, t2  # Move 'let' scope result to 'let' target register
    mv t0, t1  # Move 'let' scope result to 'let' target register
    li a7, 10  # RARS syscall: Exit
    ecall  # Successful exit with code 0


