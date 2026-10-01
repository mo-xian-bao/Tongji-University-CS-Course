# Simple test: verify ADD instruction writes to registers correctly
# Test ADD with data hazard (reading and writing same register)

.text
    # Initialize registers
    ADDI $s5, $zero, 10      # $s5 = 10
    ADDI $t1, $zero, 20      # $t1 = 20
    
    # Test ADD with data hazard
    ADD $s5, $s5, $t1        # $s5 = $s5 + $t1 = 10 + 20 = 30
    
    # Store result
    SW $s5, 0($zero)         # MEM[0] = 30
    
    # Test another register
    ADDI $s6, $zero, 5       # $s6 = 5
    ADDI $t2, $zero, 15      # $t2 = 15
    ADD $s6, $s6, $t2        # $s6 = $s6 + $t2 = 5 + 15 = 20
    SW $s6, 1($zero)         # MEM[1] = 20
    
    HALT
