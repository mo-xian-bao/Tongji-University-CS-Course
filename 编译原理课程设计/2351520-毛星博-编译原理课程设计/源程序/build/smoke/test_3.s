.intel_syntax noprefix
.text

.globl program_3_1__1
program_3_1__1:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    xor eax, eax
.program_3_1__1_return:
    mov rsp, rbp
    pop rbp
    ret

.globl program_3_1__2
program_3_1__2:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov QWORD PTR [rbp-8], rcx
    xor eax, eax
.program_3_1__2_return:
    mov rsp, rbp
    pop rbp
    ret

.globl program_3_2
program_3_2:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov rax, 1
    mov rcx, 2
    cmp rax, rcx
    setl al
    movzx rax, al
    mov QWORD PTR [rbp-8], rax
    mov rax, 3
    mov rcx, 4
    cmp rax, rcx
    setle al
    movzx rax, al
    mov QWORD PTR [rbp-16], rax
    mov rax, 5
    mov rcx, 6
    cmp rax, rcx
    setg al
    movzx rax, al
    mov QWORD PTR [rbp-24], rax
    mov rax, 7
    mov rcx, 8
    cmp rax, rcx
    setge al
    movzx rax, al
    mov QWORD PTR [rbp-32], rax
    mov rax, 9
    mov rcx, 10
    cmp rax, rcx
    sete al
    movzx rax, al
    mov QWORD PTR [rbp-40], rax
    mov rax, 11
    mov rcx, 12
    cmp rax, rcx
    setne al
    movzx rax, al
    mov QWORD PTR [rbp-48], rax
    xor eax, eax
.program_3_2_return:
    mov rsp, rbp
    pop rbp
    ret

.globl program_3_3
program_3_3:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov rax, 1
    mov rcx, 2
    add rax, rcx
    mov QWORD PTR [rbp-8], rax
    mov rax, 3
    mov rcx, 4
    sub rax, rcx
    mov QWORD PTR [rbp-16], rax
    xor eax, eax
.program_3_3_return:
    mov rsp, rbp
    pop rbp
    ret

.globl program_3_4
program_3_4:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov rax, 1
    mov rcx, 2
    imul rax, rcx
    mov QWORD PTR [rbp-8], rax
    mov rax, 3
    cqo
    mov rcx, 4
    idiv rcx
    mov QWORD PTR [rbp-16], rax
    xor eax, eax
.program_3_4_return:
    mov rsp, rbp
    pop rbp
    ret
