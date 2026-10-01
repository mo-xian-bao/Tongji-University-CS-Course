#ifndef _SETJMP_H
#define _SETJMP_H

/* 
 * 缓冲区结构：
 * 0: EBX, 1: ESI, 2: EDI, 3: EBP, 4: ESP, 5: EIP
 */
typedef struct {
    int regs[6]; 
} jmp_buf;

void longjmp(jmp_buf env, int val);
int setjmp(jmp_buf env);

#endif