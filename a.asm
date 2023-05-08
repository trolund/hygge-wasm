.data:

.text:
    mv fp, sp  # Initialize frame pointer
    addi sp, sp, -4  # Extend the stack for variable $anf_11
    # Variable $anf_11 allocation: register t0, frame pos. 1 
    li t0, 4
    addi sp, sp, -4  # Extend the stack for variable $anf_12
    # Variable $anf_12 allocation: register t1, frame pos. 2 
    li t1, 2
    addi sp, sp, -4  # Extend the stack for variable $anf_13
    # Variable $anf_13 allocation: register t2, frame pos. 3 
    div t2, t0, t1  # $anf_13 <- $anf_11 / $anf_12
    # Variable $anf_14 allocation: register t0, frame pos. 1 
    li t0, 2
    # Variable $anf_15 allocation: register t1, frame pos. 2 
    beq t2, t0, eq_true
    li t1, 0  # Comparison result is false
    j eq_end
eq_true:
    li t1, 1  # Comparison result is true
eq_end:
    # Variable $anf_16 allocation: register t2, frame pos. 1 
    addi t2, t1, -1
    beqz t2, assert_true  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true:
    # Variable $anf_5 allocation: register t1, frame pos. 1 
    li t1, 45
    # Variable $anf_6 allocation: register t2, frame pos. 2 
    li t2, 5
    # Variable $anf_7 allocation: register t0, frame pos. 3 
    div t0, t1, t2  # $anf_7 <- $anf_5 / $anf_6
    # Variable $anf_8 allocation: register t1, frame pos. 1 
    li t1, 9
    # Variable $anf_9 allocation: register t2, frame pos. 2 
    beq t0, t1, eq_true_17
    li t2, 0  # Comparison result is false
    j eq_end_18
eq_true_17:
    li t2, 1  # Comparison result is true
eq_end_18:
    # Variable $anf_10 allocation: register t0, frame pos. 1 
    addi t0, t2, -1
    beqz t0, assert_true_19  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_19:
    # Variable $anf allocation: register t2, frame pos. 1 
    li t2, 50
    # Variable $anf_0 allocation: register t0, frame pos. 2 
    li t0, 5
    # Variable $anf_1 allocation: register t1, frame pos. 3 
    div t1, t2, t0  # $anf_1 <- $anf / $anf_0
    # Variable $anf_2 allocation: register t2, frame pos. 1 
    li t2, 10
    # Variable $anf_3 allocation: register t0, frame pos. 2 
    beq t1, t2, eq_true_20
    li t0, 0  # Comparison result is false
    j eq_end_21
eq_true_20:
    li t0, 1  # Comparison result is true
eq_end_21:
    # Variable $anf_4 allocation: register t1, frame pos. 1 
    addi t1, t0, -1
    beqz t1, assert_true_22  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_22:
    lw t0, 0(fp)  # Load variable $result onto register t0
    mv t0, t1  # $result <- $anf_4
    li a7, 10  # RARS syscall: Exit
    ecall  # Successful exit with code 0


