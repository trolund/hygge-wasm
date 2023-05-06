.data:

.text:
    mv fp, sp  # Initialize frame pointer
    addi sp, sp, -4  # Extend the stack for variable x1
    # Variable x1 allocation: register t0, frame pos. 1 
    li t0, 1
    addi sp, sp, -4  # Extend the stack for variable x2
    # Variable x2 allocation: register t1, frame pos. 2 
    li t1, 2
    addi sp, sp, -4  # Extend the stack for variable x3
    # Variable x3 allocation: register t2, frame pos. 3 
    li t2, 3
    addi sp, sp, -4  # Extend the stack for variable x4
    # Variable x4 allocation: register s1, frame pos. 4 
    li s1, 4
    addi sp, sp, -4  # Extend the stack for variable x5
    # Variable x5 allocation: register s2, frame pos. 5 
    li s2, 5
    addi sp, sp, -4  # Extend the stack for variable x6
    # Variable x6 allocation: register s3, frame pos. 6 
    li s3, 6
    addi sp, sp, -4  # Extend the stack for variable x7
    # Variable x7 allocation: register s4, frame pos. 7 
    li s4, 7
    addi sp, sp, -4  # Extend the stack for variable x8
    # Variable x8 allocation: register s5, frame pos. 8 
    li s5, 8
    addi sp, sp, -4  # Extend the stack for variable x9
    # Variable x9 allocation: register s6, frame pos. 9 
    li s6, 9
    addi sp, sp, -4  # Extend the stack for variable x10
    # Variable x10 allocation: register s7, frame pos. 10 
    li s7, 10
    addi sp, sp, -4  # Extend the stack for variable x11
    # Variable x11 allocation: register s8, frame pos. 11 
    li s8, 11
    addi sp, sp, -4  # Extend the stack for variable x12
    # Variable x12 allocation: register s9, frame pos. 12 
    li s9, 12
    addi sp, sp, -4  # Extend the stack for variable x13
    # Variable x13 allocation: register s10, frame pos. 13 
    li s10, 13
    addi sp, sp, -4  # Extend the stack for variable x14
    # Variable x14 allocation: register s11, frame pos. 14 
    li s11, 14
    addi sp, sp, -4  # Extend the stack for variable x15
    # Variable x15 allocation: register t3, frame pos. 15 
    li t3, 15
    addi sp, sp, -4  # Extend the stack for variable $anf
    # Variable $anf allocation: register t4, frame pos. 16 
    li t4, 3
    addi sp, sp, -4  # Extend the stack for variable $anf_0
    # Variable $anf_0 allocation: register t5, frame pos. 17 
    li t5, 2
    addi sp, sp, -4  # Extend the stack for variable $anf_1
    # Variable $anf_1 allocation: register t6, frame pos. 18 
    blt t4, t5, less_true
    li t6, 0  # Comparison result is false
    j less_end
less_true:
    li t6, 1  # Comparison result is true
less_end:
    # Variable $anf_12 allocation: register t4, frame pos. 16 
    bnez t6, if_true  # Jump when 'if' condition is true
    # Variable $anf_3 allocation: register t6, frame pos. 17 
    li t6, 16
    # Variable $anf_4 allocation: register t5, frame pos. 18 
    li t5, 17
    sw t0, -4(fp)  # Spill variable x1 from register t0 to stack
    addi sp, sp, -4  # Extend the stack for variable $anf_5
    # Variable $anf_5 allocation: register t0, frame pos. 19 
    li t0, 18
    sw t1, -8(fp)  # Spill variable x2 from register t1 to stack
    addi sp, sp, -4  # Extend the stack for variable $anf_6
    # Variable $anf_6 allocation: register t1, frame pos. 20 
    li t1, 19
    sw t2, -12(fp)  # Spill variable x3 from register t2 to stack
    addi sp, sp, -4  # Extend the stack for variable $anf_7
    # Variable $anf_7 allocation: register t2, frame pos. 21 
    li t2, 20
    sw s1, -16(fp)  # Spill variable x4 from register s1 to stack
    addi sp, sp, -4  # Extend the stack for variable $anf_8
    # Variable $anf_8 allocation: register s1, frame pos. 22 
    add s1, t1, t2  # $anf_8 <- $anf_6 + $anf_7
    # Variable $anf_9 allocation: register t1, frame pos. 20 
    add t1, t0, s1  # $anf_9 <- $anf_5 + $anf_8
    # Variable $anf_10 allocation: register t0, frame pos. 19 
    add t0, t5, t1  # $anf_10 <- $anf_4 + $anf_9
    # Variable $anf_11 allocation: register t5, frame pos. 18 
    add t5, t6, t0  # $anf_11 <- $anf_3 + $anf_10
    mv t4, t5  # $anf_12 <- $anf_11
    j if_end  # Jump to skip the 'true' branch of 'if' code
if_true:
    # Variable $anf_2 allocation: register t6, frame pos. 17 
    li t6, 1
    mv t4, t6  # $anf_12 <- $anf_2
    # Branch synchronization code begins here
    sw t0, -4(fp)  # Spill variable x1 from register t0 to stack
    sw t1, -8(fp)  # Spill variable x2 from register t1 to stack
    sw t2, -12(fp)  # Spill variable x3 from register t2 to stack
    sw s1, -16(fp)  # Spill variable x4 from register s1 to stack
    # Branch synchronization code ends here
if_end:
    # Variable y allocation: register t5, frame pos. 17 
    mv t5, t4  # y <- $anf_12
    # Variable $anf_13 allocation: register t4, frame pos. 16 
    lw t6, -4(fp)  # Load variable x1 onto register t6
    lw t0, -8(fp)  # Load variable x2 onto register t0
    add t4, t6, t0  # $anf_13 <- x1 + x2
    # Variable $anf_14 allocation: register t1, frame pos. 18 
    lw s1, -12(fp)  # Load variable x3 onto register s1
    add t1, t4, s1  # $anf_14 <- $anf_13 + x3
    # Variable $anf_15 allocation: register t4, frame pos. 16 
    lw t2, -16(fp)  # Load variable x4 onto register t2
    add t4, t1, t2  # $anf_15 <- $anf_14 + x4
    # Variable $anf_16 allocation: register t1, frame pos. 18 
    add t1, t4, s2  # $anf_16 <- $anf_15 + x5
    # Variable $anf_17 allocation: register t4, frame pos. 16 
    add t4, t1, s3  # $anf_17 <- $anf_16 + x6
    # Variable $anf_18 allocation: register t1, frame pos. 18 
    add t1, t4, s4  # $anf_18 <- $anf_17 + x7
    # Variable $anf_19 allocation: register t4, frame pos. 16 
    add t4, t1, s5  # $anf_19 <- $anf_18 + x8
    # Variable $anf_20 allocation: register t1, frame pos. 18 
    add t1, t4, s6  # $anf_20 <- $anf_19 + x9
    # Variable $anf_21 allocation: register t4, frame pos. 16 
    add t4, t1, s7  # $anf_21 <- $anf_20 + x10
    # Variable $anf_22 allocation: register t1, frame pos. 18 
    add t1, t4, s8  # $anf_22 <- $anf_21 + x11
    # Variable $anf_23 allocation: register t4, frame pos. 16 
    add t4, t1, s9  # $anf_23 <- $anf_22 + x12
    # Variable $anf_24 allocation: register t1, frame pos. 18 
    add t1, t4, s10  # $anf_24 <- $anf_23 + x13
    # Variable $anf_25 allocation: register t4, frame pos. 16 
    add t4, t1, s11  # $anf_25 <- $anf_24 + x14
    # Variable $anf_26 allocation: register t1, frame pos. 18 
    add t1, t4, t3  # $anf_26 <- $anf_25 + x15
    # Variable $anf_27 allocation: register t4, frame pos. 16 
    add t4, t1, t5  # $anf_27 <- $anf_26 + y
    # Variable res allocation: register t5, frame pos. 17 
    mv t5, t4  # res <- $anf_27
    # Variable $anf_73 allocation: register t4, frame pos. 16 
    li t4, 210
    # Variable $anf_74 allocation: register t1, frame pos. 18 
    beq t5, t4, eq_true
    li t1, 0  # Comparison result is false
    j eq_end
eq_true:
    li t1, 1  # Comparison result is true
eq_end:
    # Variable $anf_75 allocation: register t5, frame pos. 16 
    addi t5, t1, -1
    beqz t5, assert_true  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true:
    # Variable $anf_70 allocation: register t1, frame pos. 16 
    li t1, 1
    # Variable $anf_71 allocation: register t5, frame pos. 17 
    beq t6, t1, eq_true_76
    li t5, 0  # Comparison result is false
    j eq_end_77
eq_true_76:
    li t5, 1  # Comparison result is true
eq_end_77:
    # Variable $anf_72 allocation: register t6, frame pos. 1 
    addi t6, t5, -1
    beqz t6, assert_true_78  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_78:
    # Variable $anf_67 allocation: register t5, frame pos. 1 
    li t5, 2
    # Variable $anf_68 allocation: register t6, frame pos. 16 
    beq t0, t5, eq_true_79
    li t6, 0  # Comparison result is false
    j eq_end_80
eq_true_79:
    li t6, 1  # Comparison result is true
eq_end_80:
    # Variable $anf_69 allocation: register t0, frame pos. 1 
    addi t0, t6, -1
    beqz t0, assert_true_81  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_81:
    # Variable $anf_64 allocation: register t6, frame pos. 1 
    li t6, 3
    # Variable $anf_65 allocation: register t0, frame pos. 2 
    beq s1, t6, eq_true_82
    li t0, 0  # Comparison result is false
    j eq_end_83
eq_true_82:
    li t0, 1  # Comparison result is true
eq_end_83:
    # Variable $anf_66 allocation: register s1, frame pos. 1 
    addi s1, t0, -1
    beqz s1, assert_true_84  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_84:
    # Variable $anf_61 allocation: register t0, frame pos. 1 
    li t0, 4
    # Variable $anf_62 allocation: register s1, frame pos. 2 
    beq t2, t0, eq_true_85
    li s1, 0  # Comparison result is false
    j eq_end_86
eq_true_85:
    li s1, 1  # Comparison result is true
eq_end_86:
    # Variable $anf_63 allocation: register t2, frame pos. 1 
    addi t2, s1, -1
    beqz t2, assert_true_87  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_87:
    # Variable $anf_58 allocation: register s1, frame pos. 1 
    li s1, 5
    # Variable $anf_59 allocation: register t2, frame pos. 2 
    beq s2, s1, eq_true_88
    li t2, 0  # Comparison result is false
    j eq_end_89
eq_true_88:
    li t2, 1  # Comparison result is true
eq_end_89:
    # Variable $anf_60 allocation: register s2, frame pos. 1 
    addi s2, t2, -1
    beqz s2, assert_true_90  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_90:
    # Variable $anf_55 allocation: register t2, frame pos. 1 
    li t2, 6
    # Variable $anf_56 allocation: register s2, frame pos. 2 
    beq s3, t2, eq_true_91
    li s2, 0  # Comparison result is false
    j eq_end_92
eq_true_91:
    li s2, 1  # Comparison result is true
eq_end_92:
    # Variable $anf_57 allocation: register s3, frame pos. 1 
    addi s3, s2, -1
    beqz s3, assert_true_93  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_93:
    # Variable $anf_52 allocation: register s2, frame pos. 1 
    li s2, 7
    # Variable $anf_53 allocation: register s3, frame pos. 2 
    beq s4, s2, eq_true_94
    li s3, 0  # Comparison result is false
    j eq_end_95
eq_true_94:
    li s3, 1  # Comparison result is true
eq_end_95:
    # Variable $anf_54 allocation: register s4, frame pos. 1 
    addi s4, s3, -1
    beqz s4, assert_true_96  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_96:
    # Variable $anf_49 allocation: register s3, frame pos. 1 
    li s3, 8
    # Variable $anf_50 allocation: register s4, frame pos. 2 
    beq s5, s3, eq_true_97
    li s4, 0  # Comparison result is false
    j eq_end_98
eq_true_97:
    li s4, 1  # Comparison result is true
eq_end_98:
    # Variable $anf_51 allocation: register s5, frame pos. 1 
    addi s5, s4, -1
    beqz s5, assert_true_99  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_99:
    # Variable $anf_46 allocation: register s4, frame pos. 1 
    li s4, 9
    # Variable $anf_47 allocation: register s5, frame pos. 2 
    beq s6, s4, eq_true_100
    li s5, 0  # Comparison result is false
    j eq_end_101
eq_true_100:
    li s5, 1  # Comparison result is true
eq_end_101:
    # Variable $anf_48 allocation: register s6, frame pos. 1 
    addi s6, s5, -1
    beqz s6, assert_true_102  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_102:
    # Variable $anf_43 allocation: register s5, frame pos. 1 
    li s5, 10
    # Variable $anf_44 allocation: register s6, frame pos. 2 
    beq s7, s5, eq_true_103
    li s6, 0  # Comparison result is false
    j eq_end_104
eq_true_103:
    li s6, 1  # Comparison result is true
eq_end_104:
    # Variable $anf_45 allocation: register s7, frame pos. 1 
    addi s7, s6, -1
    beqz s7, assert_true_105  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_105:
    # Variable $anf_40 allocation: register s6, frame pos. 1 
    li s6, 11
    # Variable $anf_41 allocation: register s7, frame pos. 2 
    beq s8, s6, eq_true_106
    li s7, 0  # Comparison result is false
    j eq_end_107
eq_true_106:
    li s7, 1  # Comparison result is true
eq_end_107:
    # Variable $anf_42 allocation: register s8, frame pos. 1 
    addi s8, s7, -1
    beqz s8, assert_true_108  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_108:
    # Variable $anf_37 allocation: register s7, frame pos. 1 
    li s7, 12
    # Variable $anf_38 allocation: register s8, frame pos. 2 
    beq s9, s7, eq_true_109
    li s8, 0  # Comparison result is false
    j eq_end_110
eq_true_109:
    li s8, 1  # Comparison result is true
eq_end_110:
    # Variable $anf_39 allocation: register s9, frame pos. 1 
    addi s9, s8, -1
    beqz s9, assert_true_111  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_111:
    # Variable $anf_34 allocation: register s8, frame pos. 1 
    li s8, 13
    # Variable $anf_35 allocation: register s9, frame pos. 2 
    beq s10, s8, eq_true_112
    li s9, 0  # Comparison result is false
    j eq_end_113
eq_true_112:
    li s9, 1  # Comparison result is true
eq_end_113:
    # Variable $anf_36 allocation: register s10, frame pos. 1 
    addi s10, s9, -1
    beqz s10, assert_true_114  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_114:
    # Variable $anf_31 allocation: register s9, frame pos. 1 
    li s9, 14
    # Variable $anf_32 allocation: register s10, frame pos. 2 
    beq s11, s9, eq_true_115
    li s10, 0  # Comparison result is false
    j eq_end_116
eq_true_115:
    li s10, 1  # Comparison result is true
eq_end_116:
    # Variable $anf_33 allocation: register s11, frame pos. 1 
    addi s11, s10, -1
    beqz s11, assert_true_117  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_117:
    # Variable $anf_28 allocation: register s10, frame pos. 1 
    li s10, 15
    # Variable $anf_29 allocation: register s11, frame pos. 2 
    beq t3, s10, eq_true_118
    li s11, 0  # Comparison result is false
    j eq_end_119
eq_true_118:
    li s11, 1  # Comparison result is true
eq_end_119:
    # Variable $anf_30 allocation: register t3, frame pos. 1 
    addi t3, s11, -1
    beqz t3, assert_true_120  # Jump if assertion OK
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Assertion violation exit code
    ecall
assert_true_120:
    lw s11, 0(fp)  # Load variable $result onto register s11
    mv s11, t3  # $result <- $anf_30
    li a7, 10  # RARS syscall: Exit
    ecall  # Successful exit with code 0


