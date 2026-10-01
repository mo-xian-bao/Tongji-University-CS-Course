import sys

# 简单的MIPS汇编器 - 自动插入NOP版
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
        elif op == 'lw':
            offset, base = parts[2].split('(')
            base = base.rstrip(')')
            code = i_type(0x23, parse_reg(base), parse_reg(parts[1]), int(offset, 0))
        elif op == 'sw':
            offset, base = parts[2].split('(')
            base = base.rstrip(')')
            code = i_type(0x2b, parse_reg(base), parse_reg(parts[1]), int(offset, 0))
            
        elif op == 'lui':
            # lui rt, imm
            code = i_type(0x0f, 0, parse_reg(parts[1]), int(parts[2], 0))
            
        elif op == 'ori':
            # ori rt, rs, imm
            code = i_type(0x0d, parse_reg(parts[2]), parse_reg(parts[1]), int(parts[3], 0))

        elif op == 'beq':
            is_branch_or_jump = True
            label = parts[3]
            target = labels[label]
            offset = (target - (current_pc + 1)) # Delay slot accounts for +1, so offset based on next instr
            code = i_type(0x04, parse_reg(parts[1]), parse_reg(parts[2]), offset)
        elif op == 'bne':
            is_branch_or_jump = True
            label = parts[3]
            target = labels[label]
            offset = (target - (current_pc + 1))
            code = i_type(0x05, parse_reg(parts[1]), parse_reg(parts[2]), offset)
            
        elif op == 'j':
            is_branch_or_jump = True
            label = parts[1]
            target = labels[label]
            # PC base = 0x00400000. Target physical address = target * 4 + 0x00400000
            # J index = (Physical Address) >> 2 = target + 0x00100000
            code = j_type(0x02, target + 0x00100000)
        
        elif op == 'nop':
            code = 0
            
        else:
            return 0, False
            
        return code, is_branch_or_jump

    except Exception as e:
        # print(f"Error: {e} in {line}")
        return 0, False

# 汇编源码
try:
    # 优先读取 verify_optimized.asm
    filename = 'verify_optimized.asm'
    with open(filename, 'r', encoding='utf-8') as f:
        source_code = f.read()
except FileNotFoundError:
    print(f"Error: {filename} not found.")
    sys.exit(1)
except UnicodeDecodeError:
    # 尝试 gbk
    with open(filename, 'r', encoding='gbk') as f:
        source_code = f.read()

lines = []
for l in source_code.split('\n'):
    # Remove comments (everything after #)
    clean_l = l.split('#')[0].strip()
    if clean_l and not clean_l.startswith('.'):
        lines.append(clean_l)

# Pass 1: Calculate addresses with NOPs
pc = 0
clean_lines = []
for line in lines:
    if line.endswith(':'):
        labels[line[:-1]] = pc
    else:
        clean_lines.append(line)
        pc += 1
        # Check if we need to add NOP slot
        parts = line.split()
        # 注意：verify_optimized.asm 已经手动安排了延迟槽指令，
        # 所以这里不需要自动插入 NOP，除非是原版 verify_algorithm.asm
        # 但为了通用性，我们这里假设 verify_optimized.asm 里的跳转指令后紧跟的就是延迟槽指令
        # 如果代码里显式写了 nop，那就是 nop
        # 
        # 关键点：verify_optimized.asm 是为了“填满”延迟槽而优化的。
        # 这意味着汇编器不应该再自动插入 NOP，而是直接生成代码。
        # 
        # 但是，gen_coe_v2.py 原本逻辑是自动插入 NOP。
        # 如果我们要支持 verify_optimized.asm，我们需要一个不插入 NOP 的版本。
        # 
        # 让我们修改逻辑：不再自动插入 NOP。
        # 因为 verify_optimized.asm 里的指令顺序已经考虑了延迟槽。
        # 例如：
        # beq ...
        # sll ... (这就是延迟槽指令)
        
        # 所以 Pass 1 只需要计数
        pass

# Pass 2: Generate Code
pc = 0
coe_output = "memory_initialization_radix=16;\nmemory_initialization_vector=\n"

for line in clean_lines:
    code, is_branch = assemble(line, pc)
    coe_output += f"{code:08x},\n"
    pc += 1
    
    # 不再自动插入 NOP
    # if is_branch:
    #    coe_output += f"00000000,\n"
    #    pc += 1

coe_output = coe_output.rstrip(',\n') + ";\n"
print(coe_output)
