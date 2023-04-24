.data:
string_val:
    .string "None"
string_val_4:
    .string "None"
string_val_8:
    .string "None"

.text:
    mv fp, sp  # Initialize frame pointer
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    li a0, 8  # Amount of memory to allocate on heap for one label (in bytes)
    li a7, 9  # RARS syscall: Sbrk
    ecall
    mv t0, a0  # Move syscall result to target (pointer to label)
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    li t1, 1
    sw t1, 0(t0)  # Store label on heap
    li t2, 42
    sw t2, 4(t0)  # Store node on heap
    mv t1, t0  # Load variable 'x'
    li s1, 1  # Load label id: 1, label: Some
    lw s2, 0(t1)  # Load label id from heap
    bne s2, s1, case_end  # Compare label id with target (Branch if Not Equal)
    lw t0, 4(t1)  # Load value from heap
    mv s3, t0  # Load variable 'x'
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    mv a0, s3  # Copy to a0 for printing
    li a7, 1  # RARS syscall: PrintInt
    ecall
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    li a7, 11  # RARS syscall: PrintChar
    li a0, 10  # Character to print (newline)
    ecall
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    j match_end  # Jump to match end
case_end:  # Case end id: 1, label: Some
    li s1, 2  # Load label id: 2, label: None
    lw s2, 0(t1)  # Load label id from heap
    bne s2, s1, case_end_0  # Compare label id with target (Branch if Not Equal)
    lw t0, 4(t1)  # Load value from heap
    la s3, string_val
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    mv a0, s3  # Copy to a0 for printing
    li a7, 4  # RARS syscall: PrintString
    ecall
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    li a7, 11  # RARS syscall: PrintChar
    li a0, 10  # Character to print (newline)
    ecall
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    j match_end  # Jump to match end
case_end_0:  # Case end id: 2, label: None
match_end:  # match end label
    lw t1, 4(t1)  # Load label value from heap
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    li a0, 8  # Amount of memory to allocate on heap for one label (in bytes)
    li a7, 9  # RARS syscall: Sbrk
    ecall
    mv t1, a0  # Move syscall result to target (pointer to label)
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    li t2, 2
    sw t2, 0(t1)  # Store label on heap
    sw s1, 4(t1)  # Store node on heap
    mv t2, t1  # Load variable 'y'
    li s2, 1  # Load label id: 1, label: Some
    lw s3, 0(t2)  # Load label id from heap
    bne s3, s2, case_end_2  # Compare label id with target (Branch if Not Equal)
    lw t1, 4(t2)  # Load value from heap
    mv s4, t1  # Load variable 'y'
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    mv a0, s4  # Copy to a0 for printing
    li a7, 1  # RARS syscall: PrintInt
    ecall
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    li a7, 11  # RARS syscall: PrintChar
    li a0, 10  # Character to print (newline)
    ecall
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    j match_end_1  # Jump to match end
case_end_2:  # Case end id: 1, label: Some
    li s2, 2  # Load label id: 2, label: None
    lw s3, 0(t2)  # Load label id from heap
    bne s3, s2, case_end_3  # Compare label id with target (Branch if Not Equal)
    lw t1, 4(t2)  # Load value from heap
    la s4, string_val_4
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    mv a0, s4  # Copy to a0 for printing
    li a7, 4  # RARS syscall: PrintString
    ecall
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    li a7, 11  # RARS syscall: PrintChar
    li a0, 10  # Character to print (newline)
    ecall
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    j match_end_1  # Jump to match end
case_end_3:  # Case end id: 2, label: None
match_end_1:  # match end label
    lw t2, 4(t2)  # Load label value from heap
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    li a0, 8  # Amount of memory to allocate on heap for one label (in bytes)
    li a7, 9  # RARS syscall: Sbrk
    ecall
    mv t2, a0  # Move syscall result to target (pointer to label)
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    li s1, 1
    sw s1, 0(t2)  # Store label on heap
    li s2, 100
    sw s2, 4(t2)  # Store node on heap
    mv s1, t2  # Load variable 'z'
    li s3, 1  # Load label id: 1, label: Some
    lw s4, 0(s1)  # Load label id from heap
    bne s4, s3, case_end_6  # Compare label id with target (Branch if Not Equal)
    lw t2, 4(s1)  # Load value from heap
    mv s5, t2  # Load variable 'z'
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    mv a0, s5  # Copy to a0 for printing
    li a7, 1  # RARS syscall: PrintInt
    ecall
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    li a7, 11  # RARS syscall: PrintChar
    li a0, 10  # Character to print (newline)
    ecall
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    j match_end_5  # Jump to match end
case_end_6:  # Case end id: 1, label: Some
    li s3, 2  # Load label id: 2, label: None
    lw s4, 0(s1)  # Load label id from heap
    bne s4, s3, case_end_7  # Compare label id with target (Branch if Not Equal)
    lw t2, 4(s1)  # Load value from heap
    la s5, string_val_8
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    mv a0, s5  # Copy to a0 for printing
    li a7, 4  # RARS syscall: PrintString
    ecall
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    # Before system call: save registers
    addi sp, sp, -8  # Update stack pointer to make room for saved registers
    sw a7, 0(sp)
    sw a0, 4(sp)
    li a7, 11  # RARS syscall: PrintChar
    li a0, 10  # Character to print (newline)
    ecall
    # After system call: restore registers
    lw a7, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8  # Restore stack pointer after register restoration
    j match_end_5  # Jump to match end
case_end_7:  # Case end id: 2, label: None
match_end_5:  # match end label
    lw s1, 4(s1)  # Load label value from heap
    mv t2, s1  # Move 'let' scope result to 'let' target register
    mv t1, t2  # Move 'let' scope result to 'let' target register
    mv t0, t1  # Move 'let' scope result to 'let' target register
    li a7, 10  # RARS syscall: Exit
    ecall  # Successful exit with code 0


