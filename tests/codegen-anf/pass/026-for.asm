.data:

.text:
    mv fp, sp  # Initialize frame pointer
    li t0, 0
    li t1, 10
while_loop_begin:
    mv t2, t0  # Load variable 'x'
    mv s1, t1  # Load variable 'y'
    beq t2, s1, eq_true
    li t2, 0  # Comparison result is false
    j eq_end
eq_true:
    li t2, 1  # Comparison result is true
eq_end:
    seqz t2, t2
    beqz t2, while_loop_end  # Jump if 'while' loop condition is false
    mv t2, t0  # Load variable 'x'
    li s1, 1
    sub t2, t2, s1
    mv t0, t2  # Assignment to variable x
    mv t2, t0  # Load variable 'x'
    li s1, 2
    add t2, t2, s1
    mv t0, t2  # Assignment to variable x
    mv t2, t1  # Load variable 'y'
    li s1, 1
    sub t2, t2, s1
    mv t1, t2  # Assignment to variable y
    j while_loop_begin  # Next iteration of the 'while' loop
while_loop_end:
    mv t2, t0  # Load variable 'x'
    mv s1, t1  # Load variable 'y'
    beq t2, s1, eq_true_0
    li t2, 0  # Comparison result is false
    j eq_end_1
eq_true_0:
    li t2, 1  # Comparison result is true
eq_end_1:
    addi t2, t2, -1
    beqz t2, assert_true  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true:
    mv t2, t0  # Load variable 'x'
    li s1, 5
    beq t2, s1, eq_true_3
    li t2, 0  # Comparison result is false
    j eq_end_4
eq_true_3:
    li t2, 1  # Comparison result is true
eq_end_4:
    addi t2, t2, -1
    beqz t2, assert_true_2  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_2:
    mv t1, t2  # Move 'let' scope result to 'let' target register
    mv t0, t1  # Move 'let' scope result to 'let' target register
    li a7, 10  # RARS syscall: Exit
    ecall  # Successful exit with code 0


