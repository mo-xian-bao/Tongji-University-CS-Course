import re
import sys

# CPU的内存起始地址 (必须与PCPU.v中的PC初始值匹配)
PC_START_ADDR = 0x00400000

# 1. 移除了不支持的指令别名: ANDI, ORI, XORI, SLLV, SRLV, SRAV
OPCODES = {
    'NOP': 0x00, 'HALT': 0x01, 'ADD': 0x02, 'SUB': 0x03,
    'AND': 0x04, 'OR': 0x05, 'XOR': 0x06, 'SLL': 0x07,
    'SRL': 0x08, 'SRA': 0x09, 'CMP': 0x0A, 'LOAD': 0x0B,
    'STORE': 0x0C, 'ADDI': 0x0D, 'BZ': 0x0E, 'BN': 0x0F, 'JMP': 0x10,
    # MIPS标准别名
    'LW': 0x0B, 'SW': 0x0C, 'BEQ': 0x0E, 'BLT': 0x0F, 'J': 0x10,
    'ADDIU': 0x0D, 
    'MOVE': 0x02  # move $rd, $rs -> add $rd, $rs, $0
}

# 寄存器别名映射 (MIPS标准)
REGISTER_ALIASES = {
    'zero': 0, 'at': 1, 'v0': 2, 'v1': 3,
    'a0': 4, 'a1': 5, 'a2': 6, 'a3': 7,
    't0': 8, 't1': 9, 't2': 10, 't3': 11,
    't4': 12, 't5': 13, 't6': 14, 't7': 15,
    's0': 16, 's1': 17, 's2': 18, 's3': 19,
    's4': 20, 's5': 21, 's6': 22, 's7': 23,
    't8': 24, 't9': 25, 'k0': 26, 'k1': 27,
    'gp': 28, 'sp': 29, 'fp': 30, 'ra': 31
}

def parse_register(reg_str):
    """解析寄存器，支持 $0, $zero, $t0 等多种格式"""
    reg_str = reg_str.strip().lower()
    if reg_str.startswith('$'):
        reg_str = reg_str[1:]
    
    if reg_str.isdigit():
        return int(reg_str)
    
    if reg_str in REGISTER_ALIASES:
        return REGISTER_ALIASES[reg_str]
    
    raise ValueError(f'无效寄存器: {reg_str}')

def parse_immediate(imm_str):
    """解析立即数，支持十进制、十六进制和负数"""
    imm_str = imm_str.strip()
    if imm_str.startswith('0x') or imm_str.startswith('0X'):
        return int(imm_str, 16)
    return int(imm_str)

def encode_r_type(opcode, rd, rs, rt, shamt=0):
    return (opcode << 26) | (rs << 21) | (rt << 16) | (rd << 11) | (shamt << 6)

def encode_i_type(opcode, rs, rt, immediate):
    return (opcode << 26) | (rs << 21) | (rt << 16) | (immediate & 0xFFFF)

def encode_j_type(opcode, address):
    return (opcode << 26) | (address & 0x3FFFFFF)

def parse_instruction_line(line):
    """解析指令行，支持MIPS标准格式"""
    for comment_char in ['#', ';']:
        if comment_char in line:
            line = line.split(comment_char)[0]
    line = line.strip()
    
    label = None
    if ':' in line:
        label = line.split(':')[0].strip()
        line = line.split(':', 1)[1].strip()
    
    return label, line

def tokenize_instruction(line):
    """将指令行分解为标记，正确处理 offset($reg) 格式"""
    mem_pattern = r'(\w+)\s+(\$\w+)\s*,\s*(-?\w+)\s*\(\s*(\$\w+)\s*\)'
    match = re.match(mem_pattern, line, re.IGNORECASE)
    if match:
        return [match.group(1), match.group(2), match.group(3), match.group(4)]
    
    line = line.replace('(', ' ').replace(')', ' ')
    tokens = re.split(r'[,\s]+', line)
    return [t for t in tokens if t]

def assemble(asm_file):
    """汇编主函数，支持MIPS标准格式"""
    with open(asm_file, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    labels = {}
    instructions = []
    pc = 0
    
    # 第一遍：收集标签 (PC是指令索引 0, 1, 2...)
    for line_num, line in enumerate(lines):
        label, inst_line = parse_instruction_line(line)
        
        if label:
            if label in labels:
                print(f'警告: 标签 "{label}" 在第 {line_num+1} 行被重复定义')
            labels[label] = pc
        
        if inst_line:
            instructions.append((inst_line, line_num + 1, pc))
            pc += 1
    
    # 第二遍：生成机器码
    machine_code = []
    
    for line, line_num, pc_index in instructions:
        parts = tokenize_instruction(line)
        if not parts:
            continue
        
        opcode_str = parts[0].upper()
        if opcode_str not in OPCODES:
            print(f'错误: 未知指令 "{opcode_str}" 在第 {line_num} 行')
            machine_code.append(0)
            continue
        
        opcode = OPCODES[opcode_str]
        
        try:
            # NOP, HALT
            if opcode_str in ['NOP', 'HALT']:
                code = encode_r_type(opcode, 0, 0, 0)
            
            # R型指令: ADD, SUB, AND, OR, XOR
            elif opcode_str in ['ADD', 'SUB', 'AND', 'OR', 'XOR']:
                rd = parse_register(parts[1])
                rs = parse_register(parts[2])
                rt = parse_register(parts[3])
                code = encode_r_type(opcode, rd, rs, rt)
            
            # MOVE伪指令: move $rd, $rs -> add $rd, $rs, $0
            elif opcode_str == 'MOVE':
                rd = parse_register(parts[1])
                rs = parse_register(parts[2])
                code = encode_r_type(OPCODES['ADD'], rd, rs, 0)
            
            # 移位指令: SLL, SRL, SRA (rd, rt, shamt)
            elif opcode_str in ['SLL', 'SRL', 'SRA']:
                rd = parse_register(parts[1])
                rt = parse_register(parts[2])
                shamt = parse_immediate(parts[3])
                # 3. [BUG FIX] SLL/SRL/SRA 编码修正
                # 格式: opcode, rd, rs=0, rt, shamt
                code = encode_r_type(opcode, rd, 0, rt, shamt)
            
            # CMP指令: cmp $rs, $rt
            elif opcode_str == 'CMP':
                rs = parse_register(parts[1])
                rt = parse_register(parts[2])
                code = encode_r_type(opcode, 0, rs, rt)
            
            # LOAD/LW: lw $rt, offset($rs)
            elif opcode_str in ['LOAD', 'LW']:
                rt = parse_register(parts[1])
                offset = parse_immediate(parts[2])
                rs = parse_register(parts[3])
                code = encode_i_type(opcode, rs, rt, offset)
            
            # STORE/SW: sw $rt, offset($rs)
            elif opcode_str in ['STORE', 'SW']:
                rt = parse_register(parts[1])
                offset = parse_immediate(parts[2])
                rs = parse_register(parts[3])
                code = encode_i_type(opcode, rs, rt, offset)
            
            # ADDI/ADDIU: addi $rt, $rs, imm
            elif opcode_str in ['ADDI', 'ADDIU']:
                rt = parse_register(parts[1])
                rs = parse_register(parts[2])
                imm = parse_immediate(parts[3])
                code = encode_i_type(opcode, rs, rt, imm)
            
            # BZ/BEQ, BN/BLT
            elif opcode_str in ['BZ', 'BEQ', 'BN', 'BLT']:
                rs = parse_register(parts[1])
                rt = parse_register(parts[2])
                label = parts[3]
                if label in labels:
                    # CPU 计算: PC = PC_branch + 4 + (offset << 2)
                    # 汇编器计算: offset = Target_PC_index - (Current_PC_index + 1)
                    offset = labels[label] - (pc_index + 1)
                else:
                    raise ValueError(f'未定义的标签: {label}')
                code = encode_i_type(opcode, rs, rt, offset & 0xFFFF)
            
            # JMP/J: j label
            elif opcode_str in ['JMP', 'J']:
                label = parts[1]
                if label in labels:
                    # 1. [BUG FIX] JMP 地址编码修正
                    # CPU 期望: {PC[31:28], ID_addr, 2'b00}
                    # ID_addr 是 (ByteAddress >> 2) & 0x03FFFFFF
                    target_instr_index = labels[label]
                    target_byte_addr = PC_START_ADDR + (target_instr_index * 4)
                    j_target_field = (target_byte_addr >> 2) & 0x03FFFFFF
                    code = encode_j_type(opcode, j_target_field)
                else:
                    raise ValueError(f'未定义的标签: {label}')
            
            else:
                raise ValueError(f'未处理的指令: {opcode_str}')
            
            machine_code.append(code)
            
        except Exception as e:
            print(f'汇编错误 (第 {line_num} 行): {line}')
            print(f'  -> 错误信息: {e}')
            machine_code.append(0) # 出错时插入 NOP
    
    return machine_code, labels

def generate_coe(machine_code, output_file):
    with open(output_file, 'w') as f:
        f.write('memory_initialization_radix=16;\n')
        f.write('memory_initialization_vector=\n')
        for i, code in enumerate(machine_code):
            end_char = ';' if i == len(machine_code) - 1 else ','
            f.write(f'{code:08x}{end_char}\n')

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('=' * 60)
        print('MIPS to Custom CPU Assembler (修复版)')
        print('=' * 60)
        print('用法: python assembler_fixed.py <input.asm> [output.coe]')
        print('\n支持的16条指令:')
        print('  R-type: add, sub, and, or, xor, sll, srl, sra, cmp')
        print('  I-type: addi, load(lw), store(sw), bz(beq), bn(blt)')
        print('  J-type: jmp(j)')
        print('  特殊: nop, halt')
        print('  伪指令: move')
        print('=' * 60)
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else input_file.replace('.asm', '.coe')
    
    print('=' * 60)
    print(f'开始汇编: {input_file}')
    print(f'CPU起始地址设为: 0x{PC_START_ADDR:X}')
    print('=' * 60)
    
    machine_code, labels = assemble(input_file)
    
    print('\n[标签表 (指令索引)]')
    if labels:
        for label, addr_idx in sorted(labels.items(), key=lambda x: x[1]):
            byte_addr = PC_START_ADDR + addr_idx * 4
            print(f'  {label:20s} -> 指令索引 = {addr_idx:<4d} (字节地址 = 0x{byte_addr:08X})')
    else:
        print('  (未定义标签)')
    
    generate_coe(machine_code, output_file)
    
    print(f'\n[输出]')
    print(f'  COE 文件: {output_file}')
    print(f'  总指令数: {len(machine_code)}')
    print('=' * 60)
    print('汇编完成!')