.intel_syntax noprefix
.text

.globl add
add:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov QWORD PTR [rbp-8], rcx
    mov QWORD PTR [rbp-16], rdx
    mov rax, QWORD PTR [rbp-8]
    mov rcx, QWORD PTR [rbp-16]
    add rax, rcx
    mov QWORD PTR [rbp-24], rax
    mov rax, QWORD PTR [rbp-24]
    jmp .add_return
    xor eax, eax
.add_return:
    mov rsp, rbp
    pop rbp
    ret
.add_bounds_error:
    ud2

.globl classify
classify:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov QWORD PTR [rbp-8], rcx
    mov rax, QWORD PTR [rbp-8]
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    mov QWORD PTR [rbp-16], rax
    mov rax, QWORD PTR [rbp-16]
    test rax, rax
    je .classify_L2
    mov rax, 1
    jmp .classify_return
    jmp .classify_L1
.classify_L2:
    mov rax, QWORD PTR [rbp-8]
    mov rcx, 0
    cmp rax, rcx
    setl al
    movzx rax, al
    mov QWORD PTR [rbp-24], rax
    mov rax, QWORD PTR [rbp-24]
    test rax, rax
    je .classify_L3
    mov rax, 2
    jmp .classify_return
    jmp .classify_L1
.classify_L3:
    mov rax, 0
    jmp .classify_return
.classify_L1:
    mov rax, QWORD PTR [rbp-32]
    jmp .classify_return
    xor eax, eax
.classify_return:
    mov rsp, rbp
    pop rbp
    ret
.classify_bounds_error:
    ud2

.globl main
main:
    push rbp
    mov rbp, rsp
    sub rsp, 336
    mov rax, 0
    mov QWORD PTR [rbp-8], rax
    mov rax, 0
    mov QWORD PTR [rbp-16], rax
.main_L1:
    mov rax, QWORD PTR [rbp-16]
    mov rcx, 4
    cmp rax, rcx
    setl al
    movzx rax, al
    mov QWORD PTR [rbp-24], rax
    mov rax, QWORD PTR [rbp-24]
    test rax, rax
    je .main_L3
    mov rax, QWORD PTR [rbp-16]
    mov rcx, 2
    cmp rax, rcx
    sete al
    movzx rax, al
    mov QWORD PTR [rbp-32], rax
    mov rax, QWORD PTR [rbp-32]
    test rax, rax
    je .main_L4
    jmp .main_L2
.main_L4:
    mov rax, QWORD PTR [rbp-8]
    mov rcx, QWORD PTR [rbp-16]
    add rax, rcx
    mov QWORD PTR [rbp-40], rax
    mov rax, QWORD PTR [rbp-40]
    mov QWORD PTR [rbp-8], rax
.main_L2:
    mov rax, QWORD PTR [rbp-16]
    mov rcx, 1
    add rax, rcx
    mov QWORD PTR [rbp-48], rax
    mov rax, QWORD PTR [rbp-48]
    mov QWORD PTR [rbp-16], rax
    jmp .main_L1
.main_L3:
    lea rax, [rbp-312]
    mov QWORD PTR [rbp-64], rax
    mov rax, QWORD PTR [rbp-64]
    mov rcx, 0
    cmp rcx, 0
    jl .main_bounds_error
    cmp rcx, 3
    jge .main_bounds_error
    mov rdx, 10
    mov QWORD PTR [rax+rcx*8], rdx
    mov rax, QWORD PTR [rbp-64]
    mov rcx, 1
    cmp rcx, 0
    jl .main_bounds_error
    cmp rcx, 3
    jge .main_bounds_error
    mov rdx, 20
    mov QWORD PTR [rax+rcx*8], rdx
    mov rax, QWORD PTR [rbp-64]
    mov rcx, 2
    cmp rcx, 0
    jl .main_bounds_error
    cmp rcx, 3
    jge .main_bounds_error
    mov rdx, 30
    mov QWORD PTR [rax+rcx*8], rdx
    mov rax, QWORD PTR [rbp-64]
    mov QWORD PTR [rbp-56], rax
    mov rax, QWORD PTR [rbp-56]
    mov rcx, 1
    cmp rcx, 0
    jl .main_bounds_error
    cmp rcx, 3
    jge .main_bounds_error
    mov rax, QWORD PTR [rax+rcx*8]
    mov QWORD PTR [rbp-72], rax
    mov rax, QWORD PTR [rbp-8]
    mov rcx, QWORD PTR [rbp-72]
    add rax, rcx
    mov QWORD PTR [rbp-80], rax
    mov rax, QWORD PTR [rbp-80]
    mov QWORD PTR [rbp-8], rax
    lea rax, [rbp-328]
    mov QWORD PTR [rbp-96], rax
    mov rax, QWORD PTR [rbp-96]
    mov rcx, 0
    mov rdx, 1
    mov QWORD PTR [rax+rcx*8], rdx
    mov rax, QWORD PTR [rbp-96]
    mov rcx, 1
    mov rdx, 2
    mov QWORD PTR [rax+rcx*8], rdx
    mov rax, QWORD PTR [rbp-96]
    mov QWORD PTR [rbp-88], rax
    mov rax, QWORD PTR [rbp-88]
    mov rcx, 0
    mov rdx, 3
    mov QWORD PTR [rax+rcx*8], rdx
    mov rax, 4
    mov QWORD PTR [rbp-104], rax
    lea rax, [rbp-104]
    mov QWORD PTR [rbp-120], rax
    mov rax, QWORD PTR [rbp-120]
    mov QWORD PTR [rbp-112], rax
    mov rax, QWORD PTR [rbp-112]
    mov rcx, 5
    mov QWORD PTR [rax], rcx
    mov rax, 2
    mov QWORD PTR [rbp-128], rax
.main_L5:
    mov rax, QWORD PTR [rbp-128]
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    mov QWORD PTR [rbp-136], rax
    mov rax, QWORD PTR [rbp-136]
    test rax, rax
    je .main_L6
    mov rax, QWORD PTR [rbp-128]
    mov rcx, 1
    sub rax, rcx
    mov QWORD PTR [rbp-144], rax
    mov rax, QWORD PTR [rbp-144]
    mov QWORD PTR [rbp-128], rax
    jmp .main_L5
.main_L6:
.main_L7:
    mov rax, 1
    mov QWORD PTR [rbp-160], rax
    jmp .main_L8
    jmp .main_L7
.main_L8:
    mov rax, QWORD PTR [rbp-160]
    mov QWORD PTR [rbp-152], rax
    mov rax, QWORD PTR [rbp-8]
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    mov QWORD PTR [rbp-176], rax
    mov rax, QWORD PTR [rbp-176]
    test rax, rax
    je .main_L10
    mov rax, 1
    mov QWORD PTR [rbp-184], rax
    jmp .main_L9
.main_L10:
    mov rax, 0
    mov QWORD PTR [rbp-184], rax
.main_L9:
    mov rax, QWORD PTR [rbp-184]
    mov QWORD PTR [rbp-168], rax
    mov rax, 2
    mov QWORD PTR [rbp-200], rax
    mov rax, QWORD PTR [rbp-200]
    mov QWORD PTR [rbp-192], rax
    mov rax, QWORD PTR [rbp-88]
    mov rcx, 0
    mov rax, QWORD PTR [rax+rcx*8]
    mov QWORD PTR [rbp-208], rax
    mov rax, QWORD PTR [rbp-8]
    mov rcx, QWORD PTR [rbp-208]
    add rax, rcx
    mov QWORD PTR [rbp-216], rax
    mov rax, QWORD PTR [rbp-112]
    mov rax, QWORD PTR [rax]
    mov QWORD PTR [rbp-224], rax
    mov rax, QWORD PTR [rbp-216]
    mov rcx, QWORD PTR [rbp-224]
    add rax, rcx
    mov QWORD PTR [rbp-232], rax
    mov rax, QWORD PTR [rbp-232]
    mov rcx, QWORD PTR [rbp-128]
    add rax, rcx
    mov QWORD PTR [rbp-240], rax
    sub rsp, 32
    mov rcx, 0
    call classify
    add rsp, 32
    mov QWORD PTR [rbp-248], rax
    mov rax, QWORD PTR [rbp-240]
    mov rcx, QWORD PTR [rbp-248]
    add rax, rcx
    mov QWORD PTR [rbp-256], rax
    mov rax, QWORD PTR [rbp-256]
    mov rcx, QWORD PTR [rbp-152]
    add rax, rcx
    mov QWORD PTR [rbp-264], rax
    mov rax, QWORD PTR [rbp-264]
    mov rcx, QWORD PTR [rbp-168]
    add rax, rcx
    mov QWORD PTR [rbp-272], rax
    mov rax, QWORD PTR [rbp-272]
    mov rcx, QWORD PTR [rbp-192]
    add rax, rcx
    mov QWORD PTR [rbp-280], rax
    sub rsp, 32
    mov rcx, QWORD PTR [rbp-280]
    mov rdx, 6
    call add
    add rsp, 32
    mov QWORD PTR [rbp-288], rax
    mov rax, QWORD PTR [rbp-288]
    jmp .main_return
    xor eax, eax
.main_return:
    mov rsp, rbp
    pop rbp
    ret
.main_bounds_error:
    ud2
