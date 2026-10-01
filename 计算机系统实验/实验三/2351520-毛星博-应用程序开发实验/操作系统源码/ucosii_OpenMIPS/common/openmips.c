/****************************************************************
***********              第一段：一些宏定义              **********
*****************************************************************/
#include "includes.h"
#include <stdlib.h>

#define BOTH_EMPTY (UART_LS_TEMT | UART_LS_THRE)

/* 循环等待，直到 UART 控制器的发送 FIFO 为空、移位寄存器为空，表示数据发送完毕
 */
#define WAIT_FOR_XMITR                       \
    do                                       \
    {                                        \
        lsr = REG8(UART_BASE + UART_LS_REG); \
    } while ((lsr & BOTH_EMPTY) != BOTH_EMPTY)

/* 循环等待，直到 UART 控制器发送 FIFO
为空，此时不一定发送完毕，但是可以接着通过 UART控制器发送数据 */
#define WAIT_FOR_THRE                        \
    do                                       \
    {                                        \
        lsr = REG8(UART_BASE + UART_LS_REG); \
    } while ((lsr & UART_LS_THRE) != UART_LS_THRE)

/* 给用户任务使用的堆栈，大小是 512 个字，提供充足的安全冗余 */
#define TASK_STK_SIZE 512
OS_STK TaskStartStk[TASK_STK_SIZE];

/* 帧缓冲区尺寸：适配最大 30x30 迷宫（每格 2 字符宽 = 60 列 + 边距 + 边框） */
#define FB_ROWS 36
#define FB_COLS 80

/****************************************************************
***********       第二段：与 UART 控制器相关的函数定义      **********
*****************************************************************/

void uart_init(void) /* UART 控制器初始化函数 */
{
    INT32U divisor;

    /* 计算分频系数 */
    divisor = (INT32U)IN_CLK / (16 * UART_BAUD_RATE);

    /* 设置分频系数寄存器 */
    REG8(UART_BASE + UART_LC_REG) = 0x80;
    REG8(UART_BASE + UART_DLB1_REG) = divisor & 0x000000ff;
    REG8(UART_BASE + UART_DLB2_REG) = (divisor >> 8) & 0x000000ff;
    REG8(UART_BASE + UART_LC_REG) = 0x00;

    /* 禁止 UART 控制器的所有中断 */
    REG8(UART_BASE + UART_IE_REG) = 0x00;

    /* 设置数据格式：8 位数据位、1 位停止位、没有奇偶校验位 */
    REG8(UART_BASE + UART_LC_REG) =
        UART_LC_WLEN8 | (UART_LC_ONE_STOP | UART_LC_NO_PARITY);

    /* 通过 UART 输出 UART 控制器初始化完毕信息 */
    uart_print_str("UART initialize done ! \n");
    return;
}

void uart_putc(char c) /* 通过 UART 输出字节 */
{
    unsigned char lsr;
    WAIT_FOR_THRE;                     /* 等待发送 FIFO 空 */
    REG8(UART_BASE + UART_TH_REG) = c; /* 通过 UART 输出字节 */
    if (c == '\n')
    { /* 如果是换行符，那么增加一个回车符 */
        WAIT_FOR_THRE;
        REG8(UART_BASE + UART_TH_REG) = '\r'; /* 通过 UART 输出回车符 */
    }
    WAIT_FOR_XMITR; /* 等待发送数据完毕 */
}

void uart_print_str(char *str) /* 通过 UART 输出字符串 */
{
    INT32U i = 0;
    OS_CPU_SR cpu_sr;
    OS_ENTER_CRITICAL() /*不希望输出字符串的过程被打断，所以进入临界区 */

    while (str[i] != 0)
    {
        uart_putc(str[i]); /* 调用函数 uart_putc 依次输出每个字节 */
        i++;
    }

    OS_EXIT_CRITICAL() /* 输出字符串结束，退出临界区 */
}

/****************************************************************
***********  第二段附1：原始 UART 输出（无 CRLF 转换，用于 ANSI 转义）**********
*****************************************************************/

/* 发送单个字符，不进行 CRLF 转换（用于 ANSI 转义序列和帧缓冲渲染） */
static void uart_putc_raw(char c)
{
    volatile unsigned char lsr;
    do
    {
        lsr = REG8(UART_BASE + UART_LS_REG);
    } while ((lsr & UART_LS_THRE) == 0);
    REG8(UART_BASE + UART_TH_REG) = c;
}

/* 发送字符串（无 CRLF 转换） */
static void uart_send_str(const char *s)
{
    while (*s)
    {
        uart_putc_raw(*s++);
    }
}

/* 发送 ANSI 光标定位序列：\033[row;colH */
static void uart_ansi_pos(int row, int col)
{
    char buf[12];
    int i, j;
    unsigned int num;

    uart_putc_raw(27); /* ESC */
    uart_putc_raw('[');

    /* 转换 row 为字符串 */
    num = (unsigned int)row;
    if (num == 0)
    {
        uart_putc_raw('0');
    }
    else
    {
        i = 0;
        while (num > 0)
        {
            buf[i++] = '0' + (char)(num % 10);
            num /= 10;
        }
        for (j = i - 1; j >= 0; j--)
        {
            uart_putc_raw(buf[j]);
        }
    }

    uart_putc_raw(';');

    /* 转换 col 为字符串 */
    num = (unsigned int)col;
    if (num == 0)
    {
        uart_putc_raw('0');
    }
    else
    {
        i = 0;
        while (num > 0)
        {
            buf[i++] = '0' + (char)(num % 10);
            num /= 10;
        }
        for (j = i - 1; j >= 0; j--)
        {
            uart_putc_raw(buf[j]);
        }
    }

    uart_putc_raw('H');
}

/* 发送 ANSI 转义序列字符串 */
static void uart_ansi_seq(const char *seq)
{
    uart_send_str(seq);
}

/****************************************************************
***********  第二段附1b：UART 输入函数（键盘读取）   **********
*****************************************************************/

/* 从 UART 读取一个字符，无数据时返回 0（非阻塞） */
static char uart_getc(void)
{
    unsigned char lsr;
    lsr = REG8(UART_BASE + UART_LS_REG);
    if (lsr & 0x01)
    {                                               /* Data Ready? */
        return (char)REG8(UART_BASE + UART_TH_REG); /* 读 RBR（与 THR 同地址） */
    }
    return 0;
}

/* 读取键盘输入，处理方向键转义序列（ESC [ A/B/C/D），返回归一化键码
 * 返回 0 表示无输入，正数表示方向/确认，负数表示难度选择 */
#define K_NONE 0
#define K_UP 1
#define K_DOWN 2
#define K_LEFT 3
#define K_RIGHT 4
#define K_CONFIRM 5
#define K_EASY 10
#define K_MEDIUM 11
#define K_HARD 12
#define K_HELL 13

static int uart_get_key(void)
{
    char c;
    static int esc_state = 0; /* 0=正常, 1=收到ESC, 2=收到ESC[ */

    c = uart_getc();
    if (c == 0)
        return K_NONE;

    if (esc_state == 0)
    {
        if (c == 27)
        { /* ESC */
            esc_state = 1;
            return K_NONE;
        }
        /* 单字符按键 */
        if (c == 'w' || c == 'W')
            return K_UP;
        if (c == 's' || c == 'S')
            return K_DOWN;
        if (c == 'a' || c == 'A')
            return K_LEFT;
        if (c == 'd' || c == 'D')
            return K_RIGHT;
        if (c == '\r' || c == ' ')
            return K_CONFIRM; /* Enter 或 空格 */
        if (c == '1' || c == 'e' || c == 'E')
            return K_EASY;
        if (c == '2' || c == 'm' || c == 'M')
            return K_MEDIUM;
        if (c == '3' || c == 'h' || c == 'H')
            return K_HARD;
        if (c == '4' || c == 'l' || c == 'L')
            return K_HELL;
        return K_NONE;
    }
    else if (esc_state == 1)
    {
        if (c == '[')
        {
            esc_state = 2;
            return K_NONE;
        }
        esc_state = 0; /* 非法序列，重置 */
        return K_NONE;
    }
    else
    { /* esc_state == 2 */
        esc_state = 0;
        if (c == 'A')
            return K_UP;
        if (c == 'B')
            return K_DOWN;
        if (c == 'C')
            return K_RIGHT;
        if (c == 'D')
            return K_LEFT;
        return K_NONE;
    }
}

/****************************************************************
***********  第二段附2：内存/字符串工具函数**********
*****************************************************************/

static void my_memset(void *dst, unsigned char val, int n)
{
    unsigned char *d = (unsigned char *)dst;
    int i;
    for (i = 0; i < n; i++)
    {
        d[i] = val;
    }
}

static void my_memcpy(void *dst, const void *src, int n)
{
    unsigned char *d = (unsigned char *)dst;
    const unsigned char *s = (const unsigned char *)src;
    int i;
    for (i = 0; i < n; i++)
    {
        d[i] = s[i];
    }
}

static int my_memcmp(const void *a, const void *b, int n)
{
    const unsigned char *pa = (const unsigned char *)a;
    const unsigned char *pb = (const unsigned char *)b;
    int i;
    for (i = 0; i < n; i++)
    {
        if (pa[i] != pb[i])
            return 1;
    }
    return 0;
}

static int my_strlen(const char *s)
{
    int len = 0;
    while (*s++)
        len++;
    return len;
}

/* 将无符号整数转换为十进制字符串，返回字符串长度 */
static int int_to_str(unsigned int num, char *buf)
{
    char tmp[12];
    int i = 0;
    int j;

    if (num == 0)
    {
        buf[0] = '0';
        buf[1] = '\0';
        return 1;
    }

    while (num > 0)
    {
        tmp[i++] = '0' + (char)(num % 10);
        num /= 10;
    }

    for (j = 0; j < i; j++)
    {
        buf[j] = tmp[i - 1 - j];
    }
    buf[i] = '\0';
    return i;
}

/****************************************************************
***********  第二段附3：帧缓冲区系统   **********
*****************************************************************/

static char fb_new[FB_ROWS][FB_COLS];
static char fb_old[FB_ROWS][FB_COLS];
static int fb_first_frame = 1;       /* 首帧需要全屏清除 + 绘制 */
static int fb_active_rows = FB_ROWS; /* 当前实际使用的行数（避免超出终端高度导致滚屏错位） */

/* 设置帧缓冲实际使用的行数 */
static void fb_set_rows(int rows)
{
    if (rows < 1)
        rows = 1;
    if (rows > FB_ROWS)
        rows = FB_ROWS;
    fb_active_rows = rows;
}

/* 清空新帧缓冲区（仅清空活跃行） */
static void fb_clear(void)
{
    int r;
    for (r = 0; r < fb_active_rows; r++)
    {
        my_memset(fb_new[r], ' ', FB_COLS);
    }
}

/* 在帧缓冲区的 (row, col) 处写入字符串 */
static void fb_write_str(int row, int col, const char *s)
{
    if (row < 0 || row >= FB_ROWS)
        return;
    while (*s && col < FB_COLS)
    {
        fb_new[row][col++] = *s++;
    }
}

/* 在帧缓冲区的 (row, col) 处写入重复字符 */
static void fb_write_rep(int row, int col, char c, int count)
{
    int i;
    if (row < 0 || row >= FB_ROWS)
        return;
    for (i = 0; i < count && (col + i) < FB_COLS; i++)
    {
        fb_new[row][col + i] = c;
    }
}

/* 在帧缓冲区的 (row, col) 处写入单个字符 */
static void fb_write_char(int row, int col, char c)
{
    if (row >= 0 && row < FB_ROWS && col >= 0 && col < FB_COLS)
    {
        fb_new[row][col] = c;
    }
}

/* 差分渲染：比较 fb_new 与 fb_old，仅通过 ANSI 光标定位输出变化行 */
static void fb_render(void)
{
    int r;
    int any_change = 0;

    if (fb_first_frame)
    {
        /* 首帧：清屏，然后输出活跃行。
         * 输出行数 = fb_active_rows，不会超出终端高度，避免滚屏导致后续光标定位错位 */
        uart_ansi_seq("\033[2J\033[H");
        for (r = 0; r < fb_active_rows; r++)
        {
            int c;
            for (c = 0; c < FB_COLS; c++)
            {
                uart_putc_raw(fb_new[r][c]);
            }
        }
        fb_first_frame = 0;
        any_change = 1;
    }
    else
    {
        /* 差分更新：仅输出改变的活跃行 */
        for (r = 0; r < fb_active_rows; r++)
        {
            if (my_memcmp(fb_new[r], fb_old[r], FB_COLS) != 0)
            {
                /* 定位光标并输出整行 */
                uart_ansi_pos(r + 1, 1);
                {
                    int c;
                    for (c = 0; c < FB_COLS; c++)
                    {
                        uart_putc_raw(fb_new[r][c]);
                    }
                }
                any_change = 1;
            }
        }
        /* 渲染后隐藏光标 */
        if (any_change)
        {
            uart_ansi_seq("\033[?25l");
        }
    }

    /* 将 fb_new 复制到 fb_old */
    for (r = 0; r < fb_active_rows; r++)
    {
        my_memcpy(fb_old[r], fb_new[r], FB_COLS);
    }
}

/* 强制下一帧为全屏刷新（用于切换界面时） */
static void fb_force_full_refresh(void)
{
    fb_first_frame = 1;
}

/****************************************************************
***********        第三段：与 GPIO 模块相关的函数定义      **********
*****************************************************************/

void gpio_init() /* GPIO 模块初始化函数 */
{
    REG32(GPIO_BASE + GPIO_OE_REG) = 0xffffffff;   /* 所有输出端口使能*/
    REG32(GPIO_BASE + GPIO_INTE_REG) = 0x00000000; /* 禁用所有中断*/
    gpio_out(0x0f0f0f0f);                          /* 输出 0x0f0f0f0f*/

    /* 通过 UART 输出 GPIO 模块初始化完毕信息 */
    uart_print_str("GPIO initialize done ! \n");
    return;
}

void gpio_out(INT32U number) /* GPIO 模块输出函数 */
{
    REG32(GPIO_BASE + GPIO_OUT_REG) = number;
}

INT32U gpio_in() /* 读取 GPIO 模块输入的函数 */
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
    asm volatile("mtc0 %0,$9" : : "r"(0x0));
    asm volatile("mtc0 %0,$11" : : "r"(compare));

    /* 设置 Status 寄存器，以使能时钟中断 */
    asm volatile("mtc0 %0,$12" : : "r"(0x10000401));

    return;
}

/****************************************************************
***********                第五段：用户任务              *********
*****************************************************************/

// 1代表墙壁(#)，0代表通路(.)
const int maze_easy[10 * 10] = {
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1,
    0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1,
    1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1,
    0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};

const int maze_medium[15 * 15] = {
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0,
    0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0,
    0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1,
    1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1,
    1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1,
    0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1,
    1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0,
    0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0, 0, 0,
    0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};

const int maze_hard[20 * 20] = {
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1,
    0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1,
    1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1,
    0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1,
    1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,
    0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0,
    1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1,
    0, 1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1,
    1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1,
    0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1,
    1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1,
    0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1,
    1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1,
    1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0,
    1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1,
    1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};

const int maze_hell[30 * 30] = {
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1,
    1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1,
    1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1,
    1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1,
    1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1,
    1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1,
    1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1,
    1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1,
    1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1,
    1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1,
    1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1,
    1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1,
    1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1,
    1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
    1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1,
    1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1,
    1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1,
    1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 1,
    1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1,
    1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1,
    1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1,
    1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1,
    1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1,
    1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1,
    1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};

const int *active_map;
int board_size;
int exit_row;
int exit_col;
int player_row;
int player_col;

/* 读取 CP0 Count 寄存器作为随机种子（硬件时钟计数器，每次按键时刻不同） */
INT32U get_random_seed(void)
{
    INT32U cnt;
    asm volatile("mfc0 %0,$9" : "=r"(cnt));
    return cnt;
}

/* 随机选取起点（迷宫上部）和出口（迷宫下部）的通路格子 */
void randomize_positions(void)
{
    INT32U seed = get_random_seed();
    int r, c, count, target;
    int third = board_size / 3;
    if (third < 2)
        third = 2;

    /* --- 随机起点：扫描上部 1/3 区域 --- */
    count = 0;
    for (r = 1; r < third; r++)
        for (c = 1; c < board_size - 1; c++)
            if (active_map[r * board_size + c] == 0)
                count++;

    if (count > 0)
    {
        target = seed % count;
        count = 0;
        for (r = 1; r < third; r++)
            for (c = 1; c < board_size - 1; c++)
                if (active_map[r * board_size + c] == 0)
                {
                    if (count == target)
                    {
                        player_row = r;
                        player_col = c;
                    }
                    count++;
                }
    }
    else
    {
        player_row = 1;
        player_col = 1;
    }

    /* --- 随机出口：扫描下部 1/3 区域 --- */
    count = 0;
    for (r = board_size - third; r < board_size - 1; r++)
        for (c = 1; c < board_size - 1; c++)
            if (active_map[r * board_size + c] == 0)
                count++;

    if (count > 0)
    {
        target = (seed / 7 + 13) % count; /* 用不同变换避免与起点相关 */
        count = 0;
        for (r = board_size - third; r < board_size - 1; r++)
            for (c = 1; c < board_size - 1; c++)
                if (active_map[r * board_size + c] == 0)
                {
                    if (count == target)
                    {
                        exit_row = r;
                        exit_col = c;
                    }
                    count++;
                }
    }
    /* 若下部无通路则保留难度选择时的默认值 */
}

/****************************************************************
***********    第五段附：帧缓冲屏幕构建函数           *********
*****************************************************************/

/* 迷宫标题行号（帧缓冲区中的行索引，下同） */
#define TITLE_ROW 0
/* 迷宫顶部起始行号 */
#define MAZE_TOP_ROW 2

/* 构建难度选择界面到帧缓冲区 */
static void build_difficulty_screen(void)
{
    int row;

    /* 难度选择界面约 11 行 */
    fb_set_rows(13);
    fb_clear();

    row = 2;
    fb_write_str(row, 25, "=== Select Difficulty ===");
    row += 2;
    fb_write_str(row, 22, "Switch RIGHT (S1) up -> Easy   (10x10)");
    row += 1;
    fb_write_str(row, 22, "Switch LEFT  (S2) up -> Medium (15x15)");
    row += 1;
    fb_write_str(row, 22, "Switch DOWN  (S3) up -> Hard   (20x20)");
    row += 1;
    fb_write_str(row, 22, "Switch UP    (S4) up -> Hell   (30x30)");
    row += 2;
    fb_write_str(row, 22, "Keys: 1/E=Easy  2/M=Medium  3/H=Hard  4/L=Hell");
    row += 1;
    fb_write_str(row, 24, "Set ONE switch & press N17 to confirm...");
}

/* 构建迷宫游戏界面到帧缓冲区 */
static void build_game_screen(const char *diff_name, const char *message)
{
    int r, c;
    int left_margin;
    char cell_char;
    int msg_row, hint_row;

    /* 根据迷宫大小动态计算需要的行数，避免超出终端高度导致滚屏 */
    msg_row = MAZE_TOP_ROW + board_size;
    hint_row = MAZE_TOP_ROW + board_size + 1;
    fb_set_rows(hint_row + 2); /* +1 空行作为底部边距 */
    fb_clear();

    /* 第 0 行：标题栏 */
    fb_write_str(TITLE_ROW, 2, "--- Maze Game [");
    fb_write_str(TITLE_ROW, 19, diff_name);
    fb_write_str(TITLE_ROW, 19 + my_strlen(diff_name), "]");

    /* 第 1 行：分隔线 */
    fb_write_rep(TITLE_ROW + 1, 0, '-', FB_COLS);

    /* 迷宫居中：每格 = 符号 + 空格 = 2 列 */
    left_margin = (FB_COLS - board_size * 2) / 2;
    if (left_margin < 1)
        left_margin = 1;

    /* 逐格绘制迷宫 */
    for (r = 0; r < board_size; r++)
    {
        int screen_row = MAZE_TOP_ROW + r;

        for (c = 0; c < board_size; c++)
        {
            int screen_col = left_margin + c * 2;

            if (r == player_row && c == player_col)
            {
                cell_char = '@'; /* 玩家位置 */
            }
            else if (r == exit_row && c == exit_col)
            {
                cell_char = '$'; /* 出口位置 */
            }
            else if (active_map[r * board_size + c] == 1)
            {
                cell_char = '#'; /* 墙壁 */
            }
            else
            {
                cell_char = '.'; /* 通路 */
            }

            fb_write_char(screen_row, screen_col, cell_char);
            /* 空格已在 fb_clear 中填充，无需额外写入 */
        }
    }

    /* 消息行：显示状态信息 */
    if (message != (char *)0)
    {
        fb_write_str(msg_row, 2, message);
    }

    /* 提示行 */
    fb_write_str(hint_row, 2, "WASD/Arrows:move | Enter/Space:confirm | N17+switches:GPIO");
}

void TaskStart(void *pdata)
{
    INT32U count;
    INT32U data;
    int game_won;
    INT32U last_ready;
    INT32U ready;
    INT32U choice;
    int next_r, next_c;
    int restart;
    int selected;
    volatile int delay_loop;
    char *diff_name;
    char *status_msg;                              /* 指向当前状态消息字符串，NULL 表示无消息 */
    int key;                                       /* 键盘输入键码 */
    int last_key;                                  /* 上一次处理的键码（防重复触发） */
    int do_move;                                   /* 是否有移动请求 */
    int move_up, move_down, move_left, move_right; /* 移动方向标志 */

    count = 0;
    pdata = pdata;
    OSInitTick(); /* 在用户任务中初始化定时器、允许时钟中断 */

    for (;;)
    {
        /* ---- 难度选择界面 ---- */
        fb_force_full_refresh();
        build_difficulty_screen();
        fb_render();

        selected = 0;
        last_ready = 1; /* 初始为 1 */
        last_key = K_NONE;
        while (!selected)
        {
            data = gpio_in();
            ready = data << 31;
            choice = data >> 1;
            key = uart_get_key();

            if (ready && !last_ready)
            {
                if (choice & 0x00000001)
                {
                    active_map = maze_easy;
                    board_size = 10;
                    exit_row = 8;
                    exit_col = 8;
                    diff_name = "Easy 10x10";
                    selected = 1;
                }
                else if (choice & 0x00000002)
                {
                    active_map = maze_medium;
                    board_size = 15;
                    exit_row = 13;
                    exit_col = 13;
                    diff_name = "Medium 15x15";
                    selected = 1;
                }
                else if (choice & 0x00000004)
                {
                    active_map = maze_hard;
                    board_size = 20;
                    exit_row = 18;
                    exit_col = 18;
                    diff_name = "Hard 20x20";
                    selected = 1;
                }
                else if (choice & 0x00000008)
                {
                    active_map = maze_hell;
                    board_size = 30;
                    exit_row = 28;
                    exit_col = 28;
                    diff_name = "Hell 30x30";
                    selected = 1;
                }
            }
            last_ready = ready;

            /* 键盘选择难度（防重复触发） */
            if (!selected && key != K_NONE && key != last_key)
            {
                if (key == K_EASY)
                {
                    active_map = maze_easy;
                    board_size = 10;
                    exit_row = 8;
                    exit_col = 8;
                    diff_name = "Easy 10x10";
                    selected = 1;
                }
                else if (key == K_MEDIUM)
                {
                    active_map = maze_medium;
                    board_size = 15;
                    exit_row = 13;
                    exit_col = 13;
                    diff_name = "Medium 15x15";
                    selected = 1;
                }
                else if (key == K_HARD)
                {
                    active_map = maze_hard;
                    board_size = 20;
                    exit_row = 18;
                    exit_col = 18;
                    diff_name = "Hard 20x20";
                    selected = 1;
                }
                else if (key == K_HELL)
                {
                    active_map = maze_hell;
                    board_size = 30;
                    exit_row = 28;
                    exit_col = 28;
                    diff_name = "Hell 30x30";
                    selected = 1;
                }
            }
            last_key = key;

            /* 软件延时，避免轮询过快 */
            for (delay_loop = 0; delay_loop < 10000; delay_loop++)
            {
            }
        }

        /* 等待一小会儿，给用户看到选择反馈 */
        for (delay_loop = 0; delay_loop < 20000; delay_loop++)
        {
        }

        /* ---- 开始游戏 ---- */
        /* 随机初始化玩家起点和出口位置 */
        randomize_positions();
        game_won = 0;

        /* 初始无消息 */
        status_msg = (char *)0;

        /* 全屏刷新显示迷宫 */
        fb_force_full_refresh();
        build_game_screen(diff_name, status_msg);
        fb_render();

        last_ready = 1; /* 初始为 1，防止按键初始状态导致误判 */
        last_key = K_NONE;

        while (!game_won)
        {
            data = gpio_in();
            ready = data << 31;
            choice = data >> 1;
            key = uart_get_key();

            do_move = 0;
            move_up = 0;
            move_down = 0;
            move_left = 0;
            move_right = 0;

            /* GPIO 输入：检测 N17 确认键按下（上升沿） */
            if (ready && !last_ready)
            {
                do_move = 1;
                move_up = ((choice & 0x0000000F) == 0x00000008);
                move_down = ((choice & 0x0000000F) == 0x00000004);
                move_left = ((choice & 0x0000000F) == 0x00000002);
                move_right = ((choice & 0x0000000F) == 0x00000001);
            }
            last_ready = ready;

            /* 键盘输入（防重复触发） */
            if (!do_move && key != K_NONE && key != last_key)
            {
                if (key == K_UP)
                {
                    do_move = 1;
                    move_up = 1;
                }
                else if (key == K_DOWN)
                {
                    do_move = 1;
                    move_down = 1;
                }
                else if (key == K_LEFT)
                {
                    do_move = 1;
                    move_left = 1;
                }
                else if (key == K_RIGHT)
                {
                    do_move = 1;
                    move_right = 1;
                }
            }
            last_key = key;

            if (do_move)
            {
                /* 计算目标位置 */
                next_r = player_row;
                next_c = player_col;

                if (move_up)
                {
                    next_r = player_row - 1;
                }
                else if (move_down)
                {
                    next_r = player_row + 1;
                }
                else if (move_left)
                {
                    next_c = player_col - 1;
                }
                else if (move_right)
                {
                    next_c = player_col + 1;
                }

                /* 边界与墙壁检查 */
                if (next_r >= 0 && next_r < board_size && next_c >= 0 &&
                    next_c < board_size)
                {
                    if (active_map[next_r * board_size + next_c] == 0)
                    {
                        /* 合法移动：更新玩家位置 */
                        player_row = next_r;
                        player_col = next_c;

                        /* 判断是否到达终点 */
                        if (player_row == exit_row && player_col == exit_col)
                        {
                            game_won = 1;
                            status_msg = "You Win!";
                        }
                        else
                        {
                            status_msg = (char *)0; /* 正常移动，无消息 */
                        }

                        /* 差分渲染：只更新改变的行 */
                        build_game_screen(diff_name, status_msg);
                        fb_render();
                    }
                    else
                    {
                        /* 撞墙：显示提示消息 */
                        status_msg = "Oops! Hit a wall.";
                        build_game_screen(diff_name, status_msg);
                        fb_render();
                    }
                }
            }

            /* 软件延时，避免轮询过快 */
            for (delay_loop = 0; delay_loop < 10000; delay_loop++)
            {
            }
        }

        /* ---- 游戏胜利 ---- */
        status_msg = "You Win! Press N17 to restart...";
        build_game_screen(diff_name, status_msg);
        fb_render();

        /* 等待按下确认键重新开始 */
        restart = 0;
        last_ready = 1;
        last_key = K_NONE;
        while (!restart)
        {
            data = gpio_in();
            ready = data << 31;
            key = uart_get_key();

            if ((ready && !last_ready) || (key != K_NONE && key != last_key && key == K_CONFIRM))
            {
                restart = 1;
            }
            last_ready = ready;
            last_key = key;

            for (delay_loop = 0; delay_loop < 10000; delay_loop++)
            {
            }
        }
    }
}

/****************************************************************
***********                 第六段：主函数               *********
*****************************************************************/

void main()
{
    OSInit(); /* µC/OS-II 初始化 */

    uart_init(); /* UART 控制器初始化 */

    gpio_init(); /* GPIO 模块初始化 */

    /* 创建用户任务 */
    OSTaskCreate(TaskStart, (void *)0, &TaskStartStk[TASK_STK_SIZE - 1], 0);

    OSStart(); /* µC/OS-II 启动 */
}
