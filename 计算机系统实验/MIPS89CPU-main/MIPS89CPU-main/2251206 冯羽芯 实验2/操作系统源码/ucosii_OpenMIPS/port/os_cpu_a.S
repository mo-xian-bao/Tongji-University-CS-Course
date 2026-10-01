/*
*********************************************************************************************************
*                                               uC/OS-II
*                                         The Real-Time Kernel
*
*                             (c) Copyright 2010, Micrium, Inc., Weston, FL
*                                           All Rights Reserved
*
*                                               MIPS14K
*                                              MicroMips
*
* File    : os_cpu_a.S
* Version : v2.90
* By	  : NB
*********************************************************************************************************
*/
/*
*********************************************************************************************************
*                                          PUBLIC FUNCTIONS
*********************************************************************************************************
*/

    .global  OSStartHighRdy
    .global  OSIntCtxSw
    .global  OS_CPU_SR_Save
    .global  OS_CPU_SR_Restore
    .global  InterruptHandler
    .global  ExceptionHandler
    .global  TickInterruptClear
    .global  CoreTmrInit
    .global  TickISR
    .global  DisableInterruptSource
    .global  EnableInterruptSource

/*
*********************************************************************************************************
*                           CONSTANTS USED TO ACCESS TASK CONTEXT STACK
*********************************************************************************************************
*/

.equ    STK_OFFSET_SR,      4
.equ    STK_OFFSET_EPC,     STK_OFFSET_SR    + 4
.equ    STK_OFFSET_LO,      STK_OFFSET_EPC   + 4
.equ    STK_OFFSET_HI,      STK_OFFSET_LO    + 4
.equ    STK_OFFSET_GPR1,    STK_OFFSET_HI    + 4
.equ    STK_OFFSET_GPR2,    STK_OFFSET_GPR1  + 4
.equ    STK_OFFSET_GPR3,    STK_OFFSET_GPR2  + 4
.equ    STK_OFFSET_GPR4,    STK_OFFSET_GPR3  + 4
.equ    STK_OFFSET_GPR5,    STK_OFFSET_GPR4  + 4
.equ    STK_OFFSET_GPR6,    STK_OFFSET_GPR5  + 4
.equ    STK_OFFSET_GPR7,    STK_OFFSET_GPR6  + 4
.equ    STK_OFFSET_GPR8,    STK_OFFSET_GPR7  + 4
.equ    STK_OFFSET_GPR9,    STK_OFFSET_GPR8  + 4
.equ    STK_OFFSET_GPR10,   STK_OFFSET_GPR9  + 4
.equ    STK_OFFSET_GPR11,   STK_OFFSET_GPR10 + 4
.equ    STK_OFFSET_GPR12,   STK_OFFSET_GPR11 + 4
.equ    STK_OFFSET_GPR13,   STK_OFFSET_GPR12 + 4
.equ    STK_OFFSET_GPR14,   STK_OFFSET_GPR13 + 4
.equ    STK_OFFSET_GPR15,   STK_OFFSET_GPR14 + 4
.equ    STK_OFFSET_GPR16,   STK_OFFSET_GPR15 + 4
.equ    STK_OFFSET_GPR17,   STK_OFFSET_GPR16 + 4
.equ    STK_OFFSET_GPR18,   STK_OFFSET_GPR17 + 4
.equ    STK_OFFSET_GPR19,   STK_OFFSET_GPR18 + 4
.equ    STK_OFFSET_GPR20,   STK_OFFSET_GPR19 + 4
.equ    STK_OFFSET_GPR21,   STK_OFFSET_GPR20 + 4
.equ    STK_OFFSET_GPR22,   STK_OFFSET_GPR21 + 4
.equ    STK_OFFSET_GPR23,   STK_OFFSET_GPR22 + 4
.equ    STK_OFFSET_GPR24,   STK_OFFSET_GPR23 + 4
.equ    STK_OFFSET_GPR25,   STK_OFFSET_GPR24 + 4
.equ    STK_OFFSET_GPR26,   STK_OFFSET_GPR25 + 4
.equ    STK_OFFSET_GPR27,   STK_OFFSET_GPR26 + 4
.equ    STK_OFFSET_GPR28,   STK_OFFSET_GPR27 + 4
.equ    STK_OFFSET_GPR30,   STK_OFFSET_GPR28 + 4
.equ    STK_OFFSET_GPR31,   STK_OFFSET_GPR30 + 4 
.equ    STK_CTX_SIZE,       STK_OFFSET_GPR31 + 4

/* 
    la 指令用来将指定的地址加载到寄存器，等价于两条机器指令，如下， 
    其中%hi(addr)表示addr的高16bit，%lo(addr)表示addr的低16bit 
    la rt, addr   =>   lui   $2, %hi(addr) 
                       addiu $2, $2, %lo(addr)
*/

/*************              定义了stack段          ****************/ 
        .section .stack, "aw", @nobits 
.space  0x10000 
 
/**********    定义了vectors段，其中存放异常处理例程   ***************/ 
        .section .vectors, "ax" 
 
/*************      复位异常，对应的入口地址是0x0      ***************/ 
        .org 0x0 
_reset:   
    lui $28,0x0        /* 寄存器$28即全局指针寄存器gp */ 
    la $29,_stack_addr /* 寄存器$29即堆栈指针寄存器sp 堆栈的最高地址 */ 
    la $26,main        /* 寄存器$26、$27留给异常处理程序使用 */ 
    jr $26 
    nop 
 
/*************      中断异常，对应的入口地址是0x20     ***************/ 
        .org 0x20 
    la $26,InterruptHandler 
    jr $26 
    nop 
 
/****  系统调用异常、无效指令、溢出异常、自陷异常，对应的入口地址是0x40  ****/ 
        .org 0x40 
    la $26,ExceptionHandler 
    jr $26 
    nop

    .section .text,"ax",@progbits
    .set noreorder
    .set noat

/*
*********************************************************************************************************
*                                           OSStartHighRdy()
* 执行该优先级最高的任务
* Description: Starts the highest priority task that is available to run.  OSStartHighRdy() MUST:
*
*              a) Call OSTaskSwHook()
*              b) Set OSRunning to TRUE
*              c) Switch to the highest priority task.
*
*              The stack frame of the task to resume is assumed to look as follows:
*
*              OSTCBHighRdy->OSTCBStkPtr + 0x00    Free Entry                    (LOW Memory)
*                                        + 0x04    Status Register
*                                        + 0x08    EPC
*                                        + 0x0C    Special Purpose LO Register
*                                        + 0x10    Special Purpose HI Register
*                                        + 0x14    GPR[1]
*                                        + 0x18    GPR[2]
*                                        + 0x1C    GPR[3]
*                                        + 0x20    GPR[4]
*                                               |
*                                               |
*                                              \ /
*                                               V
*                                        + 0x80    GPR[28]
*                                        + 0x84    GPR[30]
*                                        + 0x88    GPR[31]                       (HIGH Memory)
*                              
* Note(s): 1) OSTaskStkInit(), which is responsible for initializing each task's stack, sets bit 0 of the
*             entry corresponding to the Status register.  Thus, interrupts will be enabled when each
*             task first runs.
*********************************************************************************************************
*/

    .ent OSStartHighRdy
OSStartHighRdy:

/**************************************************************** 
*************    第一段：调用钩子函数 OSTaskSwHook    ************* 
*****************************************************************/

    la    $8,  OSTaskSwHook                    /* Call OSTaskSwHook()                                  */
    
    /* 2025/05 注释：删除下面的代码 */
    /* Mask off the ISAMode bit                            */
    /* addu  $9,  $31, $0                         
       srl   $9,  16
       andi  $31, 0xFFFE
       sll   $9,  16
       addu  $31, $31, $9
    */
    
    jalr  $8                                   /* 调用钩子函数 OSTaskSwHook */
    nop

/**************************************************************** 
***********    第二段：设置操作系统运行标志 OSRunning    *********** 
*****************************************************************/

    addi  $8,  $0, 1                           /* Indicate that the OS is running                      */
    la    $9,  OSRunning
    sb    $8,  0($9)                           /* 设置 OSRunning 为 1，表示操作系统在运行中 */

/**************************************************************** 
***********              第三段：堆栈恢复              *********** 
*****************************************************************/

    la    $8,  OSTCBHighRdy                    /* Update the current TCB                               */
    lw    $9,  0($8)                           /* 得到当前就绪的最高优先级任务的任务控制块 */
    lw    $29, 0($9)                           /* 得到当前就绪的最高优先级任务的堆栈指针 */

    lw    $8,  STK_OFFSET_SR($29)              /* Restore the Status register                          */
    mtc0  $8,  $12, 0

    lw    $8,  STK_OFFSET_EPC($29)             /* Restore the EPC                                      */
    mtc0  $8,  $14, 0

    lw    $8,  STK_OFFSET_LO($29)              /* Restore the contents of the LO and HI registers      */
    lw    $9,  STK_OFFSET_HI($29)
    mtlo  $8
    mthi  $9

    lw    $31, STK_OFFSET_GPR31($29)           /* Restore the General Purpose Registers                */
    lw    $30, STK_OFFSET_GPR30($29) 
    lw    $28, STK_OFFSET_GPR28($29)
    lw    $27, STK_OFFSET_GPR27($29) 
    lw    $26, STK_OFFSET_GPR26($29) 
    lw    $25, STK_OFFSET_GPR25($29) 
    lw    $24, STK_OFFSET_GPR24($29) 
    lw    $23, STK_OFFSET_GPR23($29) 
    lw    $22, STK_OFFSET_GPR22($29) 
    lw    $21, STK_OFFSET_GPR21($29) 
    lw    $20, STK_OFFSET_GPR20($29) 
    lw    $19, STK_OFFSET_GPR19($29) 
    lw    $18, STK_OFFSET_GPR18($29) 
    lw    $17, STK_OFFSET_GPR17($29) 
    lw    $16, STK_OFFSET_GPR16($29) 
    lw    $15, STK_OFFSET_GPR15($29) 
    lw    $14, STK_OFFSET_GPR14($29) 
    lw    $13, STK_OFFSET_GPR13($29) 
    lw    $12, STK_OFFSET_GPR12($29) 
    lw    $11, STK_OFFSET_GPR11($29) 
    lw    $10, STK_OFFSET_GPR10($29) 
    lw    $9,  STK_OFFSET_GPR9($29)  
    lw    $8,  STK_OFFSET_GPR8($29)  
    lw    $7,  STK_OFFSET_GPR7($29)  
    lw    $6,  STK_OFFSET_GPR6($29)  
    lw    $5,  STK_OFFSET_GPR5($29)  
    lw    $4,  STK_OFFSET_GPR4($29)  
    lw    $3,  STK_OFFSET_GPR3($29) 
    lw    $2,  STK_OFFSET_GPR2($29)  
    lw    $1,  STK_OFFSET_GPR1($29) 
    
    /* 2025/05 注释：可以去掉 ei 指令 */
    /* ei */

/**************************************************************** 
***********              第四段：跳转到任务              ********** 
*****************************************************************/

    jr    $31                                  /* 进入优先级最高的任务执行 */
    addi  $29, $29, STK_CTX_SIZE               /* 调整堆栈指针 */

    .end OSStartHighRdy

/*
*********************************************************************************************************
*                                             OSIntCtxSw()
*
* Description: This function is used to perform a context switch following an ISR.
*
*              OSIntCtxSw() implements the following pseudo-code:
*
*                  OSTaskSwHook();
*                  OSPrioCur = OSPrioHighRdy;
*                  OSTCBCur  = OSTCBHighRdy;
*                  SP        = OSTCBHighRdy->OSTCBStkPtr;
*                  Restore the Status register and the EPC to their prior states;
*                  Restore the LO and HI registers;
*                  Restore each of the general purpose registers;
*                  Adjust the stack pointer;
*                  Execute an eret instruction to begin executing the new task;
*
*              Upon entry, the registers of the task being suspended have already been saved onto that
*              task's stack and the SP for the task has been saved in its OS_TCB by the ISR.
*
*              The stack frame of the task to resume is assumed to look as follows:
*
*              OSTCBHighRdy->OSTCBStkPtr + 0x00    Free Entry                    (LOW Memory)
*                                        + 0x04    Status Register
*                                        + 0x08    EPC
*                                        + 0x0C    Special Purpose LO Register
*                                        + 0x10    Special Purpose HI Register
*                                        + 0x14    GPR[1]
*                                        + 0x18    GPR[2]
*                                        + 0x1C    GPR[3]
*                                        + 0x20    GPR[4]
*                                               |
*                                               |
*                                              \ /
*                                               V
*                                        + 0x80    GPR[28]
*                                        + 0x84    GPR[30]
*                                        + 0x88    GPR[31]                       (HIGH Memory)
*********************************************************************************************************
*/            

    .ent OSIntCtxSw
OSIntCtxSw:

/**************************************************************** 
*************    第一段：调用钩子函数 OSTaskSwHook    ************* 
*****************************************************************/

    la    $8,  OSTaskSwHook                    /* Call OSTaskSwHook()                                  */
    
    /* 2025/05 注释：删除下面的代码 */
    /* Mask off the ISAMode bit                            */
    /* addu  $9,  $31, $0                         
       srl   $9,  16
       andi  $31, 0xFFFE
       sll   $9,  16
       addu  $31, $31, $9
    */
    
    jalr  $8
    nop

/**************************************************************** 
*************           第二段：设置当前任务        *************** 
*****************************************************************/

    la    $8,  OSPrioHighRdy                   /* Update the current priority                          */
    lbu   $9,  0($8) 
    la    $10, OSPrioCur
    sb    $9,  0($10)                          /* OSPrioCur 是当前任务的优先级，此处就是将 */
                                               /* OSPrioCur 变为最高优先级任务的优先级     */

    la    $8,  OSTCBHighRdy                    /* Update the current TCB                               */
    lw    $9,  0($8)
    la    $10, OSTCBCur
    sw    $9,  0($10)                          /* OSTCBCur 指向当前任务的 TCB，此处就是将 */ 
                                               /* OSTCBCur 指向最高优先级任务的 TCB */

/**************************************************************** 
*************            第三段：恢复现场          *************** 
*****************************************************************/

    lw    $29, 0($9)                           /* 加载最高优先级任务的堆栈指针 */

    lw    $8,  STK_OFFSET_SR($29)              /* Restore the Status register                          */
    mtc0  $8,  $12, 0 

    lw    $8,  STK_OFFSET_EPC($29)             /* Restore the EPC                                      */
    mtc0  $8,  $14, 0 

    lw    $8,  STK_OFFSET_LO($29)              /* Restore the contents of the LO and HI registers      */
    lw    $9,  STK_OFFSET_HI($29)
    mtlo  $8
    mthi  $9

    lw    $31, STK_OFFSET_GPR31($29)           /* Restore the General Purpose Registers                */
    lw    $30, STK_OFFSET_GPR30($29) 
    lw    $28, STK_OFFSET_GPR28($29)
    lw    $27, STK_OFFSET_GPR27($29) 
    lw    $26, STK_OFFSET_GPR26($29) 
    lw    $25, STK_OFFSET_GPR25($29) 
    lw    $24, STK_OFFSET_GPR24($29) 
    lw    $23, STK_OFFSET_GPR23($29) 
    lw    $22, STK_OFFSET_GPR22($29) 
    lw    $21, STK_OFFSET_GPR21($29) 
    lw    $20, STK_OFFSET_GPR20($29) 
    lw    $19, STK_OFFSET_GPR19($29) 
    lw    $18, STK_OFFSET_GPR18($29) 
    lw    $17, STK_OFFSET_GPR17($29) 
    lw    $16, STK_OFFSET_GPR16($29) 
    lw    $15, STK_OFFSET_GPR15($29) 
    lw    $14, STK_OFFSET_GPR14($29) 
    lw    $13, STK_OFFSET_GPR13($29) 
    lw    $12, STK_OFFSET_GPR12($29) 
    lw    $11, STK_OFFSET_GPR11($29) 
    lw    $10, STK_OFFSET_GPR10($29) 
    lw    $9,  STK_OFFSET_GPR9($29)  
    lw    $8,  STK_OFFSET_GPR8($29)  
    lw    $7,  STK_OFFSET_GPR7($29)  
    lw    $6,  STK_OFFSET_GPR6($29)  
    lw    $5,  STK_OFFSET_GPR5($29)  
    lw    $4,  STK_OFFSET_GPR4($29)  
    lw    $3,  STK_OFFSET_GPR3($29) 
    lw    $2,  STK_OFFSET_GPR2($29)  
    lw    $1,  STK_OFFSET_GPR1($29) 

    addi  $29, $29, STK_CTX_SIZE               /* Adjust the stack pointer                             */   

/**************************************************************** 
*************              第四段：返回            *************** 
*****************************************************************/

    /* 2025/05 注释：可以去掉下面的代码 */
    /* ei */

    eret                                       /* 返回                         */

    .end OSIntCtxSw

/*
*********************************************************************************************************
*                                          DISABLE INTERRUPTS
*                                   OS_CPU_SR  OS_CPU_SR_Save(void);
* 读取协处理器 CP0 中 Status 寄存器的值，同时禁止中断
* Description: This function saves the state of the Status register and then disables interrupts via this
*              register.  This objective is accomplished with a single instruction, di.  The di 
*              instruction's operand, $2, is the general purpose register to which the Status register's 
*              value is saved.  This value can be read by C functions that call OS_CPU_SR_Save().  
*
* Arguments  : None
*
* Returns    : The previous state of the Status register
*********************************************************************************************************
*/

    .ent OS_CPU_SR_Save
OS_CPU_SR_Save:

    /* 2025/05 修改：将 di 指令使用下面 5 条 MIPS32 中定义的指令代替  */
    ori   $2,$2,0x0 
    mfc0  $2,$12,0         # 获取 Status 寄存器的值，保存到寄存器$2中 
    addi  $3,$0,0xfffe     # 设置寄存器 $3 的值为 0xfffffffe 
    and   $3,$2,$3         # $3 与 $2 的值相与，结果保存到 $3 中 
    mtc0  $3,$12,0         # 修改后的寄存器 $3 的值保存到 Status 寄存器 
    jr    $31              # 返回 
    nop
    /* di    $2  */                            /* Disable interrupts, and move the old value of the... */
                                               /* ...Status register into v0 ($2)                      */
    .end OS_CPU_SR_Save

/*
*********************************************************************************************************
*                                          ENABLE INTERRUPTS
*                                  void OS_CPU_SR_Restore(OS_CPU_SR sr);
* 恢复 Status 寄存器的值
* Description: This function must be used in tandem with OS_CPU_SR_Save().  Calling OS_CPU_SR_Restore()
*              causes the value returned by OS_CPU_SR_Save() to be placed in the Status register. 
*
* Arguments  : The value to be placed in the Status register
*
* Returns    : None
*********************************************************************************************************
*/

    .ent OS_CPU_SR_Restore
OS_CPU_SR_Restore:

    jr    $31
    mtc0  $4, $12, 0                           /* Restore the status register to its previous state    */
    /* 参数是通过寄存器 a0（即 $4）传入的 */
    .end OS_CPU_SR_Restore

	/* 2025/05 将此句注释.section .timer_handler,"ax",@progbits */

/*
*********************************************************************************************************
*                                          InterruptHandler
*
* Description: This function handles all generated hardware interrupts, saving the current task's
*              context. The task is then restored once the pending interrupts have been processed.
*
*              The interrupted task's context is saved onto its stack as follows:
*
*
*              OSTCBHighRdy->OSTCBStkPtr + 0x00    Free Entry                    (LOW Memory)
*                                        + 0x04    Status Register
*                                        + 0x08    EPC
*                                        + 0x0C    Special Purpose LO Register
*                                        + 0x10    Special Purpose HI Register
*                                        + 0x14    GPR[1]
*                                        + 0x18    GPR[2]
*                                        + 0x1C    GPR[3]
*                                        + 0x20    GPR[4]
*                                               |
*                                               |
*                                              \ /
*                                               V
*                                        + 0x80    GPR[28]
*                                        + 0x84    GPR[30]
*                                        + 0x88    GPR[31]                       (HIGH Memory)
*********************************************************************************************************
*/

    .ent InterruptHandler
InterruptHandler:
    /* 2025/05 注释：可以去掉此处的 di 指令  */
    /* di */                                   /* Disable Interrupts                                   */

/**************************************************************** 
*************      第一段：保护现场，寄存器压栈       ************** 
*****************************************************************/

    addi  $29, $29, -STK_CTX_SIZE              /* Adjust the stack pointer                             */

    sw    $1,  STK_OFFSET_GPR1($29)            /* Save the General Pupose Registers 保存整数寄存器      */
    sw    $2,  STK_OFFSET_GPR2($29)
    sw    $3,  STK_OFFSET_GPR3($29)
    sw    $4,  STK_OFFSET_GPR4($29)
    sw    $5,  STK_OFFSET_GPR5($29)
    sw    $6,  STK_OFFSET_GPR6($29)
    sw    $7,  STK_OFFSET_GPR7($29)
    sw    $8,  STK_OFFSET_GPR8($29)
    sw    $9,  STK_OFFSET_GPR9($29)
    sw    $10, STK_OFFSET_GPR10($29)
    sw    $11, STK_OFFSET_GPR11($29)
    sw    $12, STK_OFFSET_GPR12($29)
    sw    $13, STK_OFFSET_GPR13($29)
    sw    $14, STK_OFFSET_GPR14($29)
    sw    $15, STK_OFFSET_GPR15($29)
    sw    $16, STK_OFFSET_GPR16($29)
    sw    $17, STK_OFFSET_GPR17($29)
    sw    $18, STK_OFFSET_GPR18($29)
    sw    $19, STK_OFFSET_GPR19($29)
    sw    $20, STK_OFFSET_GPR20($29)
    sw    $21, STK_OFFSET_GPR21($29)
    sw    $22, STK_OFFSET_GPR22($29)
    sw    $23, STK_OFFSET_GPR23($29)
    sw    $24, STK_OFFSET_GPR24($29)
    sw    $25, STK_OFFSET_GPR25($29)
    sw    $26, STK_OFFSET_GPR26($29)
    sw    $27, STK_OFFSET_GPR27($29)
    sw    $28, STK_OFFSET_GPR28($29)
    sw    $30, STK_OFFSET_GPR30($29)
    sw    $31, STK_OFFSET_GPR31($29)
                                               /* Save the contents of the LO and HI registers         */
    mflo  $8
    mfhi  $9
    sw    $8,  STK_OFFSET_LO($29)              /* 保存寄存器LO */
    sw    $9,  STK_OFFSET_HI($29)              /* 保存寄存器HI */

    mfc0  $8,  $14, 0                          /* Save the EPC                                         */
    sw    $8,  STK_OFFSET_EPC($29)

    mfc0  $8,  $12, 0
    sw    $8,  STK_OFFSET_SR($29)              /* 保存寄存器 SR，也就是 Status 寄存器 */

/**************************************************************** 
*************      第二段：变量 OSIntNesting 加 1      ************* 
*****************************************************************/

    la    $8,  OSIntNesting                    /* See if OSIntNesting == 0                             */
    lbu   $9,  0($8)
    bne   $0,  $9, TICK_INC_NESTING            /* OSIntNesting 不为零，则转移到 */
    nop
    
    /* OSIntNesting 为零，则进行下面的操作 */
    la    $10, OSTCBCur                        /* Save the current task's stack pointer                */
    lw    $11, 0($10)
    sw    $29, 0($11)                          /* 将当前任务的堆栈指针保存到任务控制块 OSTCBCur 中*/

TICK_INC_NESTING:

    addi  $9,  $9, 1                           /* Increment OSIntNesting                               */
    sb    $9,  0($8)

/**************************************************************** 
*************            第三段：中断处理          *************** 
*****************************************************************/

INT_LOOP:

    mfc0  $8,  $13                             /* 读取 Cause 寄存器 */

/* 
    2025/05 修改：将此处指令使用一句指令代替
    li    $9,  0x3                             Mask out the "Interrupt Pending" field
    sll   $9,  16
    li    $10, 0xFC00
    addu  $9,  $10
*/
    li    $9, 0xff00                           /* 使 $9 为 0x0000ff00 */

    and   $8,  $9                              /* 获取 Cause 寄存器中的 IP 字段 */

    /* 通过 IP 字段判断是否有中断发生 */ 
    clz   $8,  $8                              /* Count leading zeros to find all pending interrupts   */
    move  $4,  $8
    la    $8,  BSP_Interrupt_Handler           /* Call BSP_Interrupt_Handler() to handle the interrupt */

    li    $9,  32                              /* Load the compared value for the loop(while cnt != 32)*/
    beq   $4,  $9, INT_LOOP_END                /* 中断个数为 0，那么转到 INT_LOOP_END */
    nop

    /* 2025/05 注释：删除下面的代码 */
    /* Mask off the ISAMode bit                            */
    /* addu  $9,  $31, $0                         
       srl   $9,  16
       andi  $31, 0xFFFE
       sll   $9,  16
       addu  $31, $31, $9
    */

    jalr  $8                                   /* 否则，进入具体的中断处理函数 BSP_Interrupt_Handler */
    nop

    b     INT_LOOP                             /* 处理结束一个中断后，继续处理其余中断 */
    nop

/**************************************************************** 
*************         第四段：中断处理结束        **************** 
****************************************************************/

INT_LOOP_END:

    la    $8,  OSIntExit                       /* 中断处理结束后，调用函数 OSIntExit */

    /* 2025/05 注释：删除下面的代码 */
    /* Mask off the ISAMode bit                            */
    /* addu  $9,  $31, $0                         
       srl   $9,  16
       andi  $31, 0xFFFE
       sll   $9,  16
       addu  $31, $31, $9
    */

    jalr  $8
    nop

/**************************************************************** 
*************           第五段：恢复现场          **************** 
****************************************************************/

    lw    $8,  STK_OFFSET_SR($29)              /* Restore the Status register                          */
    mtc0  $8,  $12, 0

    lw    $8,  STK_OFFSET_EPC($29)             /* Restore the EPC                                      */
    mtc0  $8,  $14, 0

    lw    $8,  STK_OFFSET_LO($29)              /* Restore the contents of the LO and HI registers      */
    lw    $9,  STK_OFFSET_HI($29)
    mtlo  $8
    mtlo  $9

    lw    $31, STK_OFFSET_GPR31($29)           /* Restore the General Purpose Registers                */
    lw    $30, STK_OFFSET_GPR30($29)
    lw    $28, STK_OFFSET_GPR28($29)
    lw    $27, STK_OFFSET_GPR27($29)
    lw    $26, STK_OFFSET_GPR26($29)
    lw    $25, STK_OFFSET_GPR25($29)
    lw    $24, STK_OFFSET_GPR24($29)
    lw    $23, STK_OFFSET_GPR23($29)
    lw    $22, STK_OFFSET_GPR22($29)
    lw    $21, STK_OFFSET_GPR21($29)
    lw    $20, STK_OFFSET_GPR20($29)
    lw    $19, STK_OFFSET_GPR19($29)
    lw    $18, STK_OFFSET_GPR18($29)
    lw    $17, STK_OFFSET_GPR17($29)
    lw    $16, STK_OFFSET_GPR16($29)
    lw    $15, STK_OFFSET_GPR15($29)
    lw    $14, STK_OFFSET_GPR14($29)
    lw    $13, STK_OFFSET_GPR13($29)
    lw    $12, STK_OFFSET_GPR12($29)
    lw    $11, STK_OFFSET_GPR11($29)
    lw    $10, STK_OFFSET_GPR10($29)
    lw    $9,  STK_OFFSET_GPR9($29)
    lw    $8,  STK_OFFSET_GPR8($29)
    lw    $7,  STK_OFFSET_GPR7($29)
    lw    $6,  STK_OFFSET_GPR6($29)
    lw    $5,  STK_OFFSET_GPR5($29)
    lw    $4,  STK_OFFSET_GPR4($29)
    lw    $3,  STK_OFFSET_GPR3($29)
    lw    $2,  STK_OFFSET_GPR2($29)
    lw    $1,  STK_OFFSET_GPR1($29)

    addi  $29, $29, STK_CTX_SIZE               /* Adjust the stack pointer                             */

    /* 2025/05 注释：可以去掉 ei 指令 */
    /* ei */                                   /* Enable Interrupts                                   */

    eret

    .end InterruptHandler

    /* 2025/05 注释：可以去掉指令 */
    /* .section .gen_excpt,"ax",@progbits */

/*
*********************************************************************************************************
*                                          ExceptionHandler
*
* Description: This function handles all generated exceptions, saving the current task's context. The
*              task is then restored once the pending interrupts have been processed.
*
*              The interrupted task's context is saved onto its stack as follows:
*
*
*              OSTCBHighRdy->OSTCBStkPtr + 0x00    Free Entry                    (LOW Memory)
*                                        + 0x04    Status Register
*                                        + 0x08    EPC
*                                        + 0x0C    Special Purpose LO Register
*                                        + 0x10    Special Purpose HI Register
*                                        + 0x14    GPR[1]
*                                        + 0x18    GPR[2]
*                                        + 0x1C    GPR[3]
*                                        + 0x20    GPR[4]
*                                               |
*                                               |
*                                              \ /
*                                               V
*                                        + 0x80    GPR[28]
*                                        + 0x84    GPR[30]
*                                        + 0x88    GPR[31]                       (HIGH Memory)
*********************************************************************************************************
*/

    .ent ExceptionHandler
ExceptionHandler:
    /* 2025/05 注释：可以去掉此处的 di 指令  */
    /* di */

/**************************************************************** 
*************      第一段：保护现场，寄存器压栈       ************** 
*****************************************************************/

    addi  $29, $29, -STK_CTX_SIZE              /* Adjust the stack pointer                             */                      

    sw    $1,  STK_OFFSET_GPR1($29)            /* Save the General Pupose Registers                    */
    sw    $2,  STK_OFFSET_GPR2($29)
    sw    $3,  STK_OFFSET_GPR3($29)
    sw    $4,  STK_OFFSET_GPR4($29)
    sw    $5,  STK_OFFSET_GPR5($29)
    sw    $6,  STK_OFFSET_GPR6($29)
    sw    $7,  STK_OFFSET_GPR7($29)
    sw    $8,  STK_OFFSET_GPR8($29)
    sw    $9,  STK_OFFSET_GPR9($29)
    sw    $10, STK_OFFSET_GPR10($29)
    sw    $11, STK_OFFSET_GPR11($29)
    sw    $12, STK_OFFSET_GPR12($29)
    sw    $13, STK_OFFSET_GPR13($29)
    sw    $14, STK_OFFSET_GPR14($29)
    sw    $15, STK_OFFSET_GPR15($29)
    sw    $16, STK_OFFSET_GPR16($29)
    sw    $17, STK_OFFSET_GPR17($29)
    sw    $18, STK_OFFSET_GPR18($29)
    sw    $19, STK_OFFSET_GPR19($29)
    sw    $20, STK_OFFSET_GPR20($29)
    sw    $21, STK_OFFSET_GPR21($29)
    sw    $22, STK_OFFSET_GPR22($29)
    sw    $23, STK_OFFSET_GPR23($29)
    sw    $24, STK_OFFSET_GPR24($29)
    sw    $25, STK_OFFSET_GPR25($29)
    sw    $26, STK_OFFSET_GPR26($29)
    sw    $27, STK_OFFSET_GPR27($29)
    sw    $28, STK_OFFSET_GPR28($29)
    sw    $30, STK_OFFSET_GPR30($29)
    sw    $31, STK_OFFSET_GPR31($29)
                                               /* Save the contents of the LO and HI registers         */
    mflo  $8
    mfhi  $9
    sw    $8,  STK_OFFSET_LO($29)
    sw    $9,  STK_OFFSET_HI($29)

    mfc0  $8,  $14, 0                          /* Save the EPC                                         */
    addi  $8,  $8, 4
    sw    $8,  STK_OFFSET_EPC($29)
  
    mfc0  $8,  $12, 0
    sw    $8,  STK_OFFSET_SR($29)

    la    $10, OSTCBCur                        /* Save the current task's stack pointer                */
    lw    $11, 0($10)
    sw    $29, 0($11)                          /* 保存堆栈指针到任务控制块 */

/**************************************************************** 
*************            第二段：异常处理          *************** 
*****************************************************************/
  
    la    $8,  BSP_Exception_Handler           /* Call BSP_ISR_Handler() to handle the interrupt       */
    
    /* 2025/05 注释：删除下面的代码 */
    /* Mask off the ISAMode bit                            */
    /* addu  $9,  $31, $0                         
       srl   $9,  16
       andi  $31, 0xFFFE
       sll   $9,  16
       addu  $31, $31, $9
    */

    jalr  $8
    nop

/**************************************************************** 
*************            第三段：恢复现场          *************** 
*****************************************************************/
                                   
    la    $10, OSTCBCur
    lw    $9,  0($10)

    lw    $29, 0($9)                           /* 恢复新任务的堆栈指针到寄存器 sp */

    lw    $8,  STK_OFFSET_SR($29)              /* Restore the Status register                          */
    mtc0  $8,  $12, 0

    lw    $8,  STK_OFFSET_EPC($29)             /* Restore the EPC                                      */
    mtc0  $8,  $14, 0

    lw    $8,  STK_OFFSET_LO($29)              /* Restore the contents of the LO and HI registers      */
    lw    $9,  STK_OFFSET_HI($29)
    mtlo  $8
    mtlo  $9

    lw    $31, STK_OFFSET_GPR31($29)           /* Restore the General Purpose Registers                */
    lw    $30, STK_OFFSET_GPR30($29) 
    lw    $28, STK_OFFSET_GPR28($29)
    lw    $27, STK_OFFSET_GPR27($29) 
    lw    $26, STK_OFFSET_GPR26($29) 
    lw    $25, STK_OFFSET_GPR25($29) 
    lw    $24, STK_OFFSET_GPR24($29) 
    lw    $23, STK_OFFSET_GPR23($29) 
    lw    $22, STK_OFFSET_GPR22($29) 
    lw    $21, STK_OFFSET_GPR21($29) 
    lw    $20, STK_OFFSET_GPR20($29) 
    lw    $19, STK_OFFSET_GPR19($29) 
    lw    $18, STK_OFFSET_GPR18($29) 
    lw    $17, STK_OFFSET_GPR17($29) 
    lw    $16, STK_OFFSET_GPR16($29) 
    lw    $15, STK_OFFSET_GPR15($29) 
    lw    $14, STK_OFFSET_GPR14($29) 
    lw    $13, STK_OFFSET_GPR13($29) 
    lw    $12, STK_OFFSET_GPR12($29) 
    lw    $11, STK_OFFSET_GPR11($29) 
    lw    $10, STK_OFFSET_GPR10($29) 
    lw    $9,  STK_OFFSET_GPR9($29)  
    lw    $8,  STK_OFFSET_GPR8($29)  
    lw    $7,  STK_OFFSET_GPR7($29)  
    lw    $6,  STK_OFFSET_GPR6($29)  
    lw    $5,  STK_OFFSET_GPR5($29)  
    lw    $4,  STK_OFFSET_GPR4($29)  
    lw    $3,  STK_OFFSET_GPR3($29) 
    lw    $2,  STK_OFFSET_GPR2($29)  
    lw    $1,  STK_OFFSET_GPR1($29) 

    addi  $29, $29, STK_CTX_SIZE               /* Adjust the stack pointer                             */
    
    /* 2025/05 注释：可以去掉 ei 指令 */
    /* ei */

/**************************************************************** 
*************              第四段：返回            *************** 
*****************************************************************/

    eret                                   

    .end ExceptionHandler

/*
*********************************************************************************************************
*                                            TickInterruptClear()
*
* Description : This function writes a value of '0' to the Compare register so that the timer interrupt
*               pending is cleared
*
* Arguments   : None
*
* Returns     : None
*
* Note(s)     : This function MUST be called before OSStart due to the fact that the count register is
*               automatically started at run time. Because of this, the timer interrupt occurs during
*               the start up code and before the initialization of the Tick ISR, which should be done
*               in the first task
*********************************************************************************************************
*/

    .ent TickInterruptClear
TickInterruptClear:

    mtc0  $0,  $11                              /* Set up the period in the compare reg                 */
    jr    $31
    ehb

    .end TickInterruptClear

/*
*********************************************************************************************************
*                                            CoreTmrInit()
*
* Description: This function should initialize the timers used by your application
*
* Arguments  : tmr_reload($4) Value that the compare register is incremented by to simulate the correct
                              clock frequency
*
* Returns    : None
*********************************************************************************************************
*/

    .ent CoreTmrInit
CoreTmrInit:

    mtc0  $4,  $11          /* 设置Compare寄存器 */ 
    nop 
    mtc0  $0,  $9           /* 将Count寄存器清零 */ 
    jr    $31 
    nop

    .end CoreTmrInit

/*
*********************************************************************************************************
*                                              TickISR()
*
* Description : This function provides the ISR executed at each Core clock tick
*
* Arguments   : tmr_reload($4) Value that the compare register is incremented by to simulate the correct
*                              clock frequency
*
* Returns     : None
*********************************************************************************************************
*/

    .ent TickISR
TickISR:

/**************************************************************** 
***********             第一段：保存部分寄存器           ********** 
*****************************************************************/

    addiu $29, $29, -24
    sw    $16, 0x4($29)
    sw    $8,  0x8($29)
    sw    $31, 0xC($29) /* 将寄存器 $8、$16、$31 压栈 */

    /* 2025/05 注释：可以去掉下面的代码 */
    /*  move  $16, $31 */

/**************************************************************** 
***********           第二段：修改寄存器 Compre          ********** 
*****************************************************************/

    mfc0  $8,  $11                              /* 获得当前 Compare 寄存器的值 */
    addu  $8,  $4                               /* 加上传入的参数 */
    mtc0  $8,  $11                              /* 加法的结果作为 Compare 寄存器的新值 */

/**************************************************************** 
***********           第三段：调用函数 OSTimeTick        ********** 
*****************************************************************/

    la    $8,  OSTimeTick                       /* Call OSTimeTick() to signal to the OS a clock tick  */

    /* 2025/05 注释：删除下面的代码 */
    /* Mask off the ISAMode bit                            */
    /* addu  $9,  $31, $0                         
       srl   $9,  16
       andi  $31, 0xFFFE
       sll   $9,  16
       addu  $31, $31, $9
    */

    jalr  $8                                    /* 调用函数 OSTimeTick 以通知操作系统有一个时钟中断 */
    nop

/**************************************************************** 
***********             第四段：恢复部分寄存器           ********** 
*****************************************************************/
    /* 2025/05 注释：可以去掉下面的代码 */
    /* move  $31, $16 */
    lw $31, 0xC($29)         /* 从堆栈恢复寄存器 $8、$16、$31 */ 
    lw $16, 0x4($29) 
    lw $8,  0x8($29) 
    addiu $29,$29,24

/**************************************************************** 
***********                第五段：返回                 ********** 
*****************************************************************/

    jr    $31                /* 返回 */
    nop

    .end TickISR

/*
*********************************************************************************************************
*                                       DisableInterruptSource()
* 设置 Status 寄存器中 IM 字段指定位为 0，从而禁止指定的外部中断
* Description : This function disables a particular hardware interrupt source
*
* Arguments   : src_nbr($4) Hardware interrupt source to disable
*
* Returns     : None
*********************************************************************************************************
*/

    .ent DisableInterruptSource
DisableInterruptSource:

    mfc0  $8,  $12        /* 获取 Status 寄存器的值 */
    and   $8,  $4         /* 与传入的参数相与 */
    mtc0  $8,  $12        /* 结果再保存回 Status 寄存器 */
    jr    $31
    nop

    .end DisableInterruptSource

/*
*********************************************************************************************************
*                                       EnableInterruptSource()
* 设置 Status 寄存器中 IM 字段指定位为 1，从而使能指定的外部中断
* Description : This function enables a particular hardware interrupt source
*
* Arguments   : src_nbr($4) Hardware interrupt source to enable
*
* Returns     : None
*********************************************************************************************************
*/

    .ent EnableInterruptSource
EnableInterruptSource:

    /* 2025/05 注释：可以去掉下面的代码 */
    /* sll   $4,  10 */
    mfc0  $8,  $12       /* 获取 Status 寄存器的值 */
    or    $8,  $4        /* 与传入的参数相或 */
    mtc0  $8,  $12       /* 结果再保存回 Status 寄存器 */
    jr    $31
    nop

    .end EnableInterruptSource