.data:
string_val:
    .string "hygge"

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
    li t0, 1  # Bool value 'True'
    li a2, 4  # Load the size of each element in the array
    li a3, 0  # Load the starting index
loop_begin:
    mul t2, a2, a3  # Calculate the offset (index) from the base address
    add s1, t5, t2  # Calculate the address of the element
    sw t0, 0(s1)  # Store the value in the element
    addi a3, a3, 1  # Increment the index
    blt a3, t4, loop_begin  # Loop if the index is less than the ending index
    mv t0, t6  # Move array mem address to target register
    # Allocation done
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
    li t1, 2
    li t2, 2
    add t1, t1, t2
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
    li t1, 1067030938  # Float value 1.200000
    fmv.w.x ft0, t1
    li a2, 4  # Load the size of each element in the array
    li a3, 0  # Load the starting index
loop_begin_0:
    mul s1, a2, a3  # Calculate the offset (index) from the base address
    add s2, t5, s1  # Calculate the address of the element
    sw t1, 0(s2)  # Store the value in the element
    addi a3, a3, 1  # Increment the index
    blt a3, t4, loop_begin_0  # Loop if the index is less than the ending index
    mv t1, t6  # Move array mem address to target register
    # Allocation done
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    li a0, 8  # Amount of memory to allocate for the array struct {data, length} (in bytes)
    li a7, 9  # RARS syscall: Sbrk
    ecall
    mv t2, a0  # Move syscall result (struct mem address) to target
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    mv t6, t2  # Move adrress to t6
    li t2, 2
    li s1, 2
    add t2, t2, s1
    sw t2, 4(t6)  # Initialize array length field
    mv t4, t2  # Move length to t4
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    li a0, 4  # 4 (bytes)
    mul a0, a0, t2  # Multiply length * 4 to get array size
    li a7, 9  # RARS syscall: Sbrk
    ecall
    mv s2, a0  # Move syscall result (array data mem address) to target+2
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    sw s2, 0(t6)  # Initialize array data field
    mv t5, s2  # Move array data address to t6
    la t2, string_val
    li a2, 4  # Load the size of each element in the array
    li a3, 0  # Load the starting index
loop_begin_1:
    mul s2, a2, a3  # Calculate the offset (index) from the base address
    add s3, t5, s2  # Calculate the address of the element
    sw t2, 0(s3)  # Store the value in the element
    addi a3, a3, 1  # Increment the index
    blt a3, t4, loop_begin_1  # Loop if the index is less than the ending index
    mv t2, t6  # Move array mem address to target register
    # Allocation done
    mv s1, t0  # Load variable 'arr'
    lw s1, 4(s1)  # Load array length
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    li a0, 8  # Amount of memory to allocate for the array struct {data, length} (in bytes)
    li a7, 9  # RARS syscall: Sbrk
    ecall
    mv s2, a0  # Move syscall result (struct mem address) to target
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    mv t6, s2  # Move adrress to t6
    li s2, 2
    li s3, 2
    add s2, s2, s3
    sw s2, 4(t6)  # Initialize array length field
    mv t4, s2  # Move length to t4
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    li a0, 4  # 4 (bytes)
    mul a0, a0, s2  # Multiply length * 4 to get array size
    li a7, 9  # RARS syscall: Sbrk
    ecall
    mv s4, a0  # Move syscall result (array data mem address) to target+2
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    sw s4, 0(t6)  # Initialize array data field
    mv t5, s4  # Move array data address to t6
    la s2, fun_f  # Load variable 'f'
    li a2, 4  # Load the size of each element in the array
    li a3, 0  # Load the starting index
loop_begin_2:
    mul s4, a2, a3  # Calculate the offset (index) from the base address
    add s5, t5, s4  # Calculate the address of the element
    sw s2, 0(s5)  # Store the value in the element
    addi a3, a3, 1  # Increment the index
    blt a3, t4, loop_begin_2  # Loop if the index is less than the ending index
    mv s2, t6  # Move array mem address to target register
    # Allocation done
    mv s3, s1  # Load variable 'len'
    li s4, 4
    beq s3, s4, eq_true
    li s3, 0  # Comparison result is false
    j eq_end
eq_true:
    li s3, 1  # Comparison result is true
eq_end:
    addi s3, s3, -1
    beqz s3, assert_true  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true:
    # Load expression to be applied as a function
    la s3, fun_f  # Load variable 'f'
    li s4, 3
    # Before function call: save caller-saved registers
    addi sp, sp, -64  # Update stack pointer to make room for saved registers
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    sw a3, 16(sp)
    sw a4, 20(sp)
    sw a5, 24(sp)
    sw a6, 28(sp)
    sw a7, 32(sp)
    sw t0, 36(sp)
    sw t1, 40(sp)
    sw t2, 44(sp)
    sw t3, 48(sp)
    sw t4, 52(sp)
    sw t5, 56(sp)
    sw t6, 60(sp)
    mv a0, s4  # Load function call argument 1
    addi sp, sp, 0  # Update stack pointer to make room for saved registers
    jalr ra, 0(s3)  # Function call
    # After function call
    # Restore registers used for extra arguments
    addi sp, sp, 0  # Restore stack pointer after register restoration
    mv s3, a0  # Copy function return value to target register
    # Restore caller-saved registers
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    lw a3, 16(sp)
    lw a4, 20(sp)
    lw a5, 24(sp)
    lw a6, 28(sp)
    lw a7, 32(sp)
    lw t0, 36(sp)
    lw t1, 40(sp)
    lw t2, 44(sp)
    lw t3, 48(sp)
    lw t4, 52(sp)
    lw t5, 56(sp)
    lw t6, 60(sp)
    addi sp, sp, 64  # Restore stack pointer after register restoration
    # Load expression to be applied as a function
    mv s4, s2  # Load variable 'arr3'
    lw s5, 0(s4)  # Load array data pointer
    li s4, 0
    li t3, 4  # Load the size of each element in the array
    mul s4, s4, t3  # Calculate the offset (index) from the base address
    add s4, s4, s5  # Compute array element address
    lw s4, 0(s4)  # Load array element
    li s5, 3
    # Before function call: save caller-saved registers
    addi sp, sp, -64  # Update stack pointer to make room for saved registers
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    sw a3, 16(sp)
    sw a4, 20(sp)
    sw a5, 24(sp)
    sw a6, 28(sp)
    sw a7, 32(sp)
    sw t0, 36(sp)
    sw t1, 40(sp)
    sw t2, 44(sp)
    sw t3, 48(sp)
    sw t4, 52(sp)
    sw t5, 56(sp)
    sw t6, 60(sp)
    mv a0, s5  # Load function call argument 1
    addi sp, sp, 0  # Update stack pointer to make room for saved registers
    jalr ra, 0(s4)  # Function call
    # After function call
    # Restore registers used for extra arguments
    addi sp, sp, 0  # Restore stack pointer after register restoration
    mv s4, a0  # Copy function return value to target register
    # Restore caller-saved registers
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    lw a3, 16(sp)
    lw a4, 20(sp)
    lw a5, 24(sp)
    lw a6, 28(sp)
    lw a7, 32(sp)
    lw t0, 36(sp)
    lw t1, 40(sp)
    lw t2, 44(sp)
    lw t3, 48(sp)
    lw t4, 52(sp)
    lw t5, 56(sp)
    lw t6, 60(sp)
    addi sp, sp, 64  # Restore stack pointer after register restoration
    beq s3, s4, eq_true_4
    li s3, 0  # Comparison result is false
    j eq_end_5
eq_true_4:
    li s3, 1  # Comparison result is true
eq_end_5:
    addi s3, s3, -1
    beqz s3, assert_true_3  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_3:
    mv s3, s2  # Load variable 'arr3'
    lw s3, 4(s3)  # Load array length
    li s4, 4
    beq s3, s4, eq_true_7
    li s3, 0  # Comparison result is false
    j eq_end_8
eq_true_7:
    li s3, 1  # Comparison result is true
eq_end_8:
    addi s3, s3, -1
    beqz s3, assert_true_6  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_6:
    mv s2, s3  # Move 'let' scope result to 'let' target register
    mv s1, s2  # Move 'let' scope result to 'let' target register
    mv t2, s1  # Move 'let' scope result to 'let' target register
    mv t1, t2  # Move 'let' scope result to 'let' target register
    mv t0, t1  # Move 'let' scope result to 'let' target register
    li a7, 10  # RARS syscall: Exit
    ecall  # Successful exit with code 0


fun_f:  # Code for function 'f'
    # Funtion prologue begins here
    # Save callee-saved registers
    addi sp, sp, -48  # Update stack pointer to make room for saved registers
    sw fp, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw s10, 40(sp)
    sw s11, 44(sp)
    addi fp, sp, 48  # Update frame pointer for the current function
    # End of function prologue.  Function body begins
    mv t0, a0  # Load variable 'x'
    li t1, 1
    add t0, t0, t1
    # End of function body.  Function epilogue begins
    mv a0, t0  # Move result of function into return value register
    # Restore callee-saved registers
    lw fp, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
    addi sp, sp, 48  # Restore stack pointer after register restoration
    jr ra  # End of function, return to caller
