#include "setjmp.h"

int setjmp(jmp_buf env)
{
    /* 
     * 保存寄存器上下文 (x86)
     * 不需要保存 EAX, ECX, EDX (调用者保存寄存器)
     * 必须保存 EBX, ESI, EDI, EBP, ESP, EIP
     */
    __asm__ __volatile__ (
        "movl 8(%%ebp), %%edx   \n\t" /* 获取 env 指针 (第一个参数) */
        "movl %%ebx, 0(%%edx)   \n\t" /* 保存 EBX */
        "movl %%esi, 4(%%edx)   \n\t" /* 保存 ESI */
        "movl %%edi, 8(%%edx)   \n\t" /* 保存 EDI */
        "movl %%ebp, 12(%%edx)  \n\t" /* 保存 EBP (当前帧指针) */
        "leal 8(%%ebp), %%eax   \n\t" /* 计算调用者的 ESP (EBP+8) */
        "movl %%eax, 16(%%edx)  \n\t" /* 保存 ESP */
        "movl 4(%%ebp), %%eax   \n\t" /* 获取返回地址 (EIP) */
        "movl %%eax, 20(%%edx)  \n\t" /* 保存 EIP */
        : : : "edx", "eax"
    );

    return 0;
}

void longjmp(jmp_buf env, int val)
{
    /* 恢复寄存器并跳转 */
    __asm__ __volatile__ (
        "movl %0, %%edx         \n\t" /* env 指针放入 EDX */
        "movl %1, %%eax         \n\t" /* val 返回值放入 EAX */
        "movl 0(%%edx), %%ebx   \n\t" /* 恢复 EBX */
        "movl 4(%%edx), %%esi   \n\t" /* 恢复 ESI */
        "movl 8(%%edx), %%edi   \n\t" /* 恢复 EDI */
        "movl 12(%%edx), %%ebp  \n\t" /* 恢复 EBP */
        "movl 16(%%edx), %%esp  \n\t" /* 恢复 ESP */
        "jmp *20(%%edx)         \n\t" /* 跳转回保存的 EIP */
        : 
        : "m"(env), "m"(val) 
        : "edx", "eax"
    );
    
    /* 不会执行到这里 */
    while(1);
}