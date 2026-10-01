# Test SRA encoding
addi $t0, $zero, 100    # $t0 = 100
sra  $t0, $t0, 1        # $t0 = 100 >> 1 = 50
sw   $t0, 0($zero)      # MEM[0] = 50
halt
