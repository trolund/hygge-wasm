.data:

.text:
    mv fp, sp  # Initialize frame pointer
    li t0, 0
while_loop_begin:
    mv t1, t0  # Load variable 'i'
    li t2, 10
    blt t1, t2, less_true
    li t1, 0  # Comparison result is false
    j less_end
less_true:
    li t1, 1  # Comparison result is true
less_end:
    beqz t1, while_loop_end  # Jump if 'while' loop condition is false
    mv t1, t0  # Load variable 'i'
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    mv a0, t1  # Copy to a0 for printing
    li a7, 1  # RARS syscall: PrintInt
    ecall
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    mv t1, t0  # Load variable 'i'
    li t2, 1
    add t1, t1, t2
    mv t0, t1  # Assignment to variable i
    j while_loop_begin  # Next iteration of the 'while' loop
while_loop_end:
    mv t1, t0  # Load variable 'i'
    li t2, 10
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


