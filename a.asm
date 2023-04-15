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
    la t0, fun_f  # Load variable 'f'
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
    # Load expression to be applied as a function
    la t1, fun_f  # Load variable 'f'
    li t2, 3
    # Before function call: save caller-saved registers
    addi sp, sp, -60  # Update stack pointer to make room for saved registers
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
    sw t2, 40(sp)
    sw t3, 44(sp)
    sw t4, 48(sp)
    sw t5, 52(sp)
    sw t6, 56(sp)
    mv a0, t2  # Load function call argument 1
    addi sp, sp, 0  # Update stack pointer to make room for saved registers
    jalr ra, 0(t1)  # Function call
    # After function call
    # Restore registers used for extra arguments
    addi sp, sp, 0  # Restore stack pointer after register restoration
    mv t1, a0  # Copy function return value to target register
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
    lw t2, 40(sp)
    lw t3, 44(sp)
    lw t4, 48(sp)
    lw t5, 52(sp)
    lw t6, 56(sp)
    addi sp, sp, 60  # Restore stack pointer after register restoration
    # Load expression to be applied as a function
    mv t2, t0  # Load variable 'arr4'
    lw s1, 0(t2)  # Load array data pointer
    li t2, 0
    li t3, 4  # Load the size of each element in the array
    mul t2, t2, t3  # Calculate the offset (index) from the base address
    add t2, t2, s1  # Compute array element address
    lw t2, 0(t2)  # Load array element
    li s1, 3
    # Before function call: save caller-saved registers
    addi sp, sp, -60  # Update stack pointer to make room for saved registers
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
    sw t3, 44(sp)
    sw t4, 48(sp)
    sw t5, 52(sp)
    sw t6, 56(sp)
    mv a0, s1  # Load function call argument 1
    addi sp, sp, 0  # Update stack pointer to make room for saved registers
    jalr ra, 0(t2)  # Function call
    # After function call
    # Restore registers used for extra arguments
    addi sp, sp, 0  # Restore stack pointer after register restoration
    mv t2, a0  # Copy function return value to target register
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
    lw t3, 44(sp)
    lw t4, 48(sp)
    lw t5, 52(sp)
    lw t6, 56(sp)
    addi sp, sp, 60  # Restore stack pointer after register restoration
    beq t1, t2, eq_true
    li t1, 0  # Comparison result is false
    j eq_end
eq_true:
    li t1, 1  # Comparison result is true
eq_end:
    addi t1, t1, -1
    beqz t1, assert_true  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true:
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
