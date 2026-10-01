/**************************************************************** 
***********              第一段：三种加载、存储            ********* 
*****************************************************************/ 
#define REG8(addr)  *((volatile INT8U  *)(addr)) 
#define REG16(addr) *((volatile INT16U *)(addr)) 
#define REG32(addr) *((volatile INT32U *)(addr))

/**************************************************************** 
***********                第二段：系统时钟             ********** 
*****************************************************************/
#define IN_CLK 100000000             /* 输入时钟是 100MHz */

/**************************************************************** 
***********         第三段：与 UART 控制器有关的宏 串口相关参数、函数        ********** 
*****************************************************************/ 
 
#define UART_BAUD_RATE  9600          /* UART 串口速率是 9600bps */ 
#define UART_BASE       0x10000000    /* UART 控制器的起始地址 */ 
#define UART_LC_REG     0x00000003    /* Line Control 寄存器的偏移地址 */ 
#define UART_IE_REG     0x00000001    /* Interrupt Enable 寄存器的偏移地址 */ 
#define UART_TH_REG     0x00000000    /* Transmitter Holding 寄存器的偏移地址*/ 
#define UART_LS_REG     0x00000005    /* Line Status 寄存器的偏移地址 */ 
#define UART_DLB1_REG   0x00000000    /* 分频系数低字节的偏移地址 */ 
#define UART_DLB2_REG   0x00000001    /* 分频系数高字节的偏移地址 */ 
 
/* Line Status 寄存器的标志位 */ 
#define UART_LS_TEMT 0x40 /* 第 6bit 为发送数据空标志   */ 
#define UART_LS_THRE 0x20 /* 第 5bit 为发送 FIFO 空标志 */ 
 
/* Line Control 寄存器的标志位 */ 
#define UART_LC_NO_PARITY  0x00 /* 第 3bit 为 0，表示禁止奇偶校验 */ 
#define UART_LC_ONE_STOP   0x00 /* 第 2bit 为 0，表示 1 位停止位 */ 
#define UART_LC_WLEN8      0x03 /* 最低两位为 11，表示数据长度是 8 位 */ 
 
/* 一些函数声明 */ 
extern void uart_init(void);       /* UART 控制器初始化函数 */ 
extern void uart_putc(char);       /* UART 控制器输出字节函数 */ 
extern void uart_print_str(char*); /* UART 控制器输出字符串函数 */

/**************************************************************** 
***********         第四段：与 GPIO 模块有关的宏          ********** 
*****************************************************************/ 
 
#define GPIO_BASE     0x20000000   /* GPIO 模块的起始地址 */ 
#define GPIO_IN_REG   0x00000000   /* GPIO 模块输入寄存器的偏移地址 */ 
#define GPIO_OUT_REG  0x00000004   /* GPIO 模块输出寄存器的偏移地址 */ 
#define GPIO_OE_REG   0x00000008   /* GPIO 模块输出使能寄存器的偏移地址 */ 
#define GPIO_INTE_REG 0x0000000c   /* GPIO 模块中断使能寄存器的偏移地址 */ 
 
/* 一些函数声明 */ 
extern void gpio_init(void);       /* GPIO 模块初始化函数 */ 
extern void gpio_out(INT32U);      /* GPIO 模块输出函数 */ 
extern INT32U gpio_in(void);       /* 读取 GPIO 模块输入的函数 */

/**************************************************************** 
***********           第五段：主函数 main 声明           ********** 
*****************************************************************/ 
extern void main(void);