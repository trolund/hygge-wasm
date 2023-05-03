// ... before match
    // ... load label id from heap
    bne s2, s1, case_end  # Compare label id with target (Branch if Not Equal)
    // ... case code
    j match_end  # Jump to match end
case_end:  # Case end id: 1
    // ... load label id from heap
    bne s2, s1, case_end_0  # Compare label id with target (Branch if Not Equal)
    // ... case code
    j match_end  # Jump to match end
case_end_0:  # Case end id: 2
    // run time fail if no match
    li a7, 93  # RARS syscall: Exit2
    li a0, 42  # Load exit code
    ecall  # Call exit
match_end:  # match end label
// ... after match