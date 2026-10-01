import sys

# 简单的MIPS汇编器 - 生成纯HEX格式
labels = {}
pc = 0

# 寄存器映射
regs = {
    '$zero': 0, '$at': 1, '$v0': 2, '$v1': 3, '$a0': 4, '$a1': 5, '$a2': 6, '$a3': 7,
    '$t0': 8, '$t1': 9, '$t2': 10, '$t3': 11, '$t4': 12, '$t5': 13, '$t6': 14, '$t7': 15,
    '$s0': 16, '$s1': 17, '$s2': 18, '$s3': 19, '$s4': 20, '$s5': 21, '$s6': 22, '$s7': 23,
    '$t8': 24, '$t9': 25, '$k0': 26, '$k1': 27, '$gp': 28, '$sp': 29, '$fp': 30, '$ra': 31
}

def parse_reg(s):
    return regs[s]

def r_type(opcode, rs, rt, rd, shamt, funct):
    return (opcode << 26) | (rs << 21) | (rt << 16) | (rd << 11) | (shamt << 6) | funct

def i_type(opcode, rs, rt, imm):
    return (opcode << 26) | (rs << 21) | (rt << 16) | (imm & 0xFFFF)

def j_type(opcode, addr):
    return (opcode << 26) | (addr & 0x3FFFFFF)

def assemble(line, current_pc):
    parts = line.replace(',', ' ').split()
    if not parts: return None, False
    
    op = parts[0]
    is_branch_or_jump = False
    
    try:
        code = 0
        if op == 'add':
            code = r_type(0, parse_reg(parts[2]), parse_reg(parts[3]), parse_reg(parts[1]), 0, 0x20)
        elif op == 'mult':
            code = r_type(0, parse_reg(parts[1]), parse_reg(parts[2]), 0, 0, 0x18)
        elif op == 'mflo':
            code = r_type(0, 0, 0, parse_reg(parts[1]), 0, 0x12)
        elif op == 'sll':
            code = r_type(0, 0, parse_reg(parts[2]), parse_reg(parts[1]), int(parts[3]), 0x00)
            
        elif op == 'addiu':
            code = i_type(0x09, parse_reg(parts[2]), parse_reg(parts[1]), int(parts[3], 0))
        elif op == 'slt': # R-type
            code = r_type(0, parse_reg(parts[2]), parse_reg(parts[3]), parse_reg(parts[1]), 0, 0x2a)
        elif op == 'slti':
            code = i_type(0x0a, parse_reg(parts[2]), parse_reg(parts[1]), int(parts[3], 0))
        elif op == 'beq':
            offset = labels[parts[3]] - (current_pc + 1)
            code = i_type(0x04, parse_reg(parts[1]), parse_reg(parts[2]), offset)
            is_branch_or_jump = True
        elif op == 'bne':
            offset = labels[parts[3]] - (current_pc + 1)
            code = i_type(0x05, parse_reg(parts[1]), parse_reg(parts[2]), offset)
            is_branch_or_jump = True
            
        elif op == 'lw':
            # lw $t6, 0($t5) -> parts: lw, $t6, 0($t5)
            # parse 0($t5)
            offset_reg = parts[2]
            idx = offset_reg.find('(')
            offset = int(offset_reg[:idx])
            base = parse_reg(offset_reg[idx+1:-1])
            code = i_type(0x23, base, parse_reg(parts[1]), offset)
            
        elif op == 'sw':
            offset_reg = parts[2]
            idx = offset_reg.find('(')
            offset = int(offset_reg[:idx])
            base = parse_reg(offset_reg[idx+1:-1])
            code = i_type(0x2b, base, parse_reg(parts[1]), offset)
            
        elif op == 'j':
            target = labels[parts[1]]
            # J target is absolute index (word address), but in MIPS J instruction takes 26 bits
            # Target address = (PC+4)[31:28] | (target << 2)
            # Here we assume target is within the same 256MB block and we just pass the word index
            # Actually for our simple CPU, we might just use the word index directly if our CPU logic expects that
            # Standard MIPS: target is (address >> 2)
            # Our simulator/CPU: usually expects (0x00400000 + offset*4) >> 2 ?
            # Let's assume the label value IS the word offset from 0x00400000
            # So we need to add base address? 
            # Usually: target address = 0x00400000 + label * 4
            # Instruction field = (0x00400000 + label * 4) >> 2
            abs_addr = 0x00400000 + target * 4
            code = j_type(0x02, abs_addr >> 2)
            is_branch_or_jump = True
            
        elif op == 'nop':
            code = 0
            
        else:
            print(f"Unknown instruction: {op}")
            return 0, False
            
        return code, is_branch_or_jump
        
    except Exception as e:
        print(f"Error assembling line: {line}")
        print(e)
        return 0, False

# Read ASM file
with open('verify_optimized.asm', 'r') as f:
    lines = [l.strip() for l in f.readlines()]

# Preprocess: remove comments and empty lines
clean_lines = []
for line in lines:
    # Remove comments
    if '#' in line:
        line = line[:line.find('#')].strip()
    if not line:
        continue
    
    # Handle labels
    if ':' in line:
        label = line[:line.find(':')]
        labels[label] = pc
        # Check if there is code after label on same line
        rest = line[line.find(':')+1:].strip()
        if rest:
            clean_lines.append(rest)
            pc += 1
    else:
        clean_lines.append(line)
        pc += 1

# Pass 2: Generate Code
pc = 0
hex_output = ""

for line in clean_lines:
    code, is_branch = assemble(line, pc)
    hex_output += f"{code:08x}\n"
    pc += 1

print(hex_output)
