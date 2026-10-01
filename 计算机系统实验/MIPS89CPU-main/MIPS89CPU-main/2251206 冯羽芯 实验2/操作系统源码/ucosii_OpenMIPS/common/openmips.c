/**************************************************************** 
***********              第一段：一些宏定义              ********** 
*****************************************************************/ 
#include "includes.h" 
#define BOTH_EMPTY (UART_LS_TEMT | UART_LS_THRE) 

/* 循环等待，直到 UART 控制器的发送 FIFO 为空、移位寄存器为空，表示数据发送完毕 */ 
#define WAIT_FOR_XMITR \
        do { \
                lsr = REG8(UART_BASE + UART_LS_REG); \
        } while ((lsr & BOTH_EMPTY) != BOTH_EMPTY)
 
/* 循环等待，直到 UART 控制器发送 FIFO 为空，此时不一定发送完毕，但是可以接着通过 
UART控制器发送数据 */ 
#define WAIT_FOR_THRE \
        do { \
                lsr = REG8(UART_BASE + UART_LS_REG); \
        } while ((lsr & UART_LS_THRE) != UART_LS_THRE)
 
/* 给用户任务使用的堆栈，大小是 256 个字，其中 OS_STK 就是 int 类型，其在 os_cpu.h  
中定义 */ 
#define TASK_STK_SIZE 256 
OS_STK TaskStartStk[TASK_STK_SIZE]; 
 
/* 要通过 UART 发送的字符串 */ 
char Info[103]={0xC9,0xCF,0xB5,0xDB,0xCB,0xB5,0xD2,0xAA,0xD3,0xD0,0xB9,0xE2,0xA3,0xAC,0xD3,0xDA,0xCA,0xC7,0xBE,0xCD,0xD3,0xD0,0xC1,0xCB,0xB9,0xE2,0x0D,0x0A,0xC9,0xCF,0xB5,0xDB,0xCB,0xB5,0xD2,0xAA,0xD3,0xD0,0xCC,0xEC,0xBF,0xD5,0xA3,0xAC,0xD3,0xDA,0xCA,0xC7,0xBE,0xCD,0xD3,0xD0,0xC1,0xCB,0xCC,0xEC,0xBF,0xD5,0x0D,0x0A,0xC9,0xCF,0xB5,0xDB,0xCB,0xB5,0xD2,0xAA,0xD3,0xD0,0xC2,0xBD,0xB5,0xD8,0xBA,0xCD,0xBA,0xA3,0xD1,0xF3,0xA3,0xAC,0xD3,0xDA,0xCA,0xC7,0xBE,0xCD,0xD3,0xD0,0xC1,0xCB,0xC2,0xBD,0xB5,0xD8,0xBA,0xCD,0xBA,0xA3,0xD1,0xF3,0x0D};

/**************************************************************** 
***********       第二段：与 UART 控制器相关的函数定义      ********** 
*****************************************************************/

void uart_init(void)             /* UART 控制器初始化函数 */ 
{ 
        INT32U divisor; 

        /* 计算分频系数 */ 
                divisor = (INT32U) IN_CLK/(16 * UART_BAUD_RATE); 

        /* 设置分频系数寄存器 */ 
        REG8(UART_BASE + UART_LC_REG)   = 0x80; 
        REG8(UART_BASE + UART_DLB1_REG) = divisor & 0x000000ff;
                REG8(UART_BASE + UART_DLB2_REG) = (divisor >> 8) & 0x000000ff; 
        REG8(UART_BASE + UART_LC_REG)   = 0x00; 

        /* 禁止 UART 控制器的所有中断 */ 
        REG8(UART_BASE + UART_IE_REG) = 0x00; 

        /* 设置数据格式：8 位数据位、1 位停止位、没有奇偶校验位 */ 
        REG8(UART_BASE + UART_LC_REG) = UART_LC_WLEN8 | (UART_LC_ONE_STOP | UART_LC_NO_PARITY);
                
        /* 通过 UART 输出 UART 控制器初始化完毕信息 */ 
        uart_print_str("UART initialize done ! \n"); 
        return; 
}

void uart_putc(char c)            /* 通过 UART 输出字节 */ 
{ 
        unsigned char lsr; 
        WAIT_FOR_THRE;            /* 等待发送 FIFO 空 */ 
        REG8(UART_BASE + UART_TH_REG) = c;   /* 通过 UART 输出字节 */ 
        if(c == '\n') {           /* 如果是换行符，那么增加一个回车符 */ 
                WAIT_FOR_THRE; 
                REG8(UART_BASE + UART_TH_REG) = '\r';  /* 通过 UART 输出回车符 */ 
        } 
        WAIT_FOR_XMITR;           /* 等待发送数据完毕 */ 
   
} 
 
void uart_print_str(char* str)    /* 通过 UART 输出字符串 */ 
{ 
       INT32U i=0; 
       OS_CPU_SR cpu_sr; 
       OS_ENTER_CRITICAL()        /*不希望输出字符串的过程被打断，所以进入临界区 */ 
        
       while(str[i]!=0) 
       { 
                uart_putc(str[i]);      /* 调用函数 uart_putc 依次输出每个字节 */ 
                i++; 
       } 
         
       OS_EXIT_CRITICAL()         /* 输出字符串结束，退出临界区 */ 
         
}

/**************************************************************** 
***********        第三段：与 GPIO 模块相关的函数定义      ********** 
*****************************************************************/ 
 
void gpio_init()                  /* GPIO 模块初始化函数 */ 
{ 
        REG32(GPIO_BASE + GPIO_OE_REG) = 0xffffffff;   /* 所有输出端口使能*/ 
        REG32(GPIO_BASE + GPIO_INTE_REG) = 0x00000000; /* 禁用所有中断*/ 
        gpio_out(0x0f0f0f0f);                          /* 输出 0x0f0f0f0f*/ 
 
       /* 通过 UART 输出 GPIO 模块初始化完毕信息 */ 
        uart_print_str("GPIO initialize done ! \n"); 
        return; 
} 
 
void gpio_out(INT32U number)      /* GPIO 模块输出函数 */ 
{ 
        REG32(GPIO_BASE + GPIO_OUT_REG) = number; 
} 
 
INT32U gpio_in()                  /* 读取 GPIO 模块输入的函数 */ 
{ 
        INT32U temp = 0; 
        temp = REG32(GPIO_BASE + GPIO_IN_REG); 
        return temp; 
}

/**************************************************************** 
***********             第四段：定时器初始化函数           ********* 
*****************************************************************/ 
 
void OSInitTick(void) 
{ 
    /* 每个 Tick 代表一个时钟节拍，会引发一次中断，依据每秒有多少个 Tick，计算 
    Compare 寄存器的初值 */ 
    INT32U compare = (INT32U)(IN_CLK / OS_TICKS_PER_SEC); 
     
    /* 清零 Count 寄存器、设置 Compare 寄存器 */ 
    asm volatile("mtc0 %0,$9"  : :"r"(0x0));  
    asm volatile("mtc0 %0,$11" : :"r"(compare));   
 
    /* 设置 Status 寄存器，以使能时钟中断 */ 
    asm volatile("mtc0 %0,$12" : :"r"(0x10000401)); 
 
    return;
} 
 
/**************************************************************** 
***********                第五段：用户任务              ********* 
*****************************************************************/ 
 
void  TaskStart (void *pdata) 
{ 
    INT32U count = 0; 
    pdata = pdata; 
    OSInitTick();       /* 在用户任务中初始化定时器、允许时钟中断 */  
    for (;;) {            /* 一般而言，任务都是一个永不结束的循环 */ 
        if(count <= 102) 
        { 
            uart_putc(Info[count]);   /* 输出 Info 数组中的两个字节，对应一个汉字 */ 
            uart_putc(Info[count+1]); 
        } 
        gpio_out(count);  /* 通过 GPIO 输出 count 的值 */ 
        count = count + 2;    /* count 的值加 2 */ 
        OSTimeDly(10);    /* 等待 10 个 Tick 后，再次执行该任务 */ 
    } 
     
} 
 
/**************************************************************** 
***********                 第六段：主函数               ********* 
*****************************************************************/ 
 
void main() 
{ 
    OSInit();                  /* µC/OS-II 初始化 */ 

    uart_init();               /* UART 控制器初始化 */ 

    gpio_init();               /* GPIO 模块初始化 */ 

    /* 创建用户任务 */ 
    OSTaskCreate(TaskStart, (void *)0, &TaskStartStk[TASK_STK_SIZE - 1], 0); 

    OSStart();                  /* µC/OS-II 启动 */ 
   
}