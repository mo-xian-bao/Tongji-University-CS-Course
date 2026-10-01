/**************************************************************** 
***********              第一段：一些宏定义              ********** 
*****************************************************************/ 
#include "includes.h" 
#include <stdlib.h>

#define BOARD_SIZE 4

int board[BOARD_SIZE][BOARD_SIZE];

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
// char Info[103]={0xC9,0xCF,0xB5,0xDB,0xCB,0xB5,0xD2,0xAA,0xD3,0xD0,0xB9,0xE2,0xA3,0xAC,0xD3,0xDA,0xCA,0xC7,0xBE,0xCD,0xD3,0xD0,0xC1,0xCB,0xB9,0xE2,0x0D,0x0A,0xC9,0xCF,0xB5,0xDB,0xCB,0xB5,0xD2,0xAA,0xD3,0xD0,0xCC,0xEC,0xBF,0xD5,0xA3,0xAC,0xD3,0xDA,0xCA,0xC7,0xBE,0xCD,0xD3,0xD0,0xC1,0xCB,0xCC,0xEC,0xBF,0xD5,0x0D,0x0A,0xC9,0xCF,0xB5,0xDB,0xCB,0xB5,0xD2,0xAA,0xD3,0xD0,0xC2,0xBD,0xB5,0xD8,0xBA,0xCD,0xBA,0xA3,0xD1,0xF3,0xA3,0xAC,0xD3,0xDA,0xCA,0xC7,0xBE,0xCD,0xD3,0xD0,0xC1,0xCB,0xC2,0xBD,0xB5,0xD8,0xBA,0xCD,0xBA,0xA3,0xD1,0xF3,0x0D};

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

unsigned int my_rand(void) {
    static INT32U my_seed = 123456789; // 可以用时间或其它方式初始化
    my_seed = (1664525 * my_seed + 1013904223); // 32位乘法和加法
    return (my_seed >> 16) & 0x7FFF; // 取高15位，并确保结果为正
}

void add_new_tile(void) {
    int i, j;
    int empty_tiles = 0;
    for (i = 0; i < BOARD_SIZE; i++) {
        for (j = 0; j < BOARD_SIZE; j++) {
            if (board[i][j] == 0) {
                empty_tiles++;
            }
        }
    }
    if (empty_tiles == 0) return;

    int pos = my_rand() % empty_tiles;
    int count = 0;
    for (i = 0; i < BOARD_SIZE; i++) {
        for (j = 0; j < BOARD_SIZE; j++) {
            if (board[i][j] == 0) {
                if (count == pos) {
                    board[i][j] = (my_rand() % 10 == 0) ? 4 : 2;
                    return;
                }
                count++;
            }
        }
    }
}

void init_board(void) {
    int i, j;
    for (i = 0; i < BOARD_SIZE; i++) {
        for (j = 0; j < BOARD_SIZE; j++) {
            board[i][j] = 0;
        }
    }
    add_new_tile();
    add_new_tile();
}

void print_board(void) {
    int i, j, k, num;
    char buf[8]; // 足够存储一个 5 位整数 + 空格 + 字符串结束符

    for (i = 0; i < BOARD_SIZE; i++) {
        // 输出上边框
        uart_print_str("|--------|--------|--------|--------|\n");
        // 输出数字和左右边框
        uart_print_str("|");
        for (j = 0; j < BOARD_SIZE; j++) {
            num = board[i][j];

            // 将整数转换为字符串
            if (num == 0) {
                buf[0] = ' ';
                buf[1] = ' ';
                buf[2] = ' ';
                buf[3] = ' ';
                buf[4] = ' ';
                buf[5] = '\0';
            } else {
                for (k = 4; k >= 0; k--) {
                    buf[k] = (num % 10) + '0';
                    num /= 10;
                    if (num == 0) {
                        // 填充空格
                        while (k > 0) {
                            k--;
                            buf[k] = ' ';
                        }
                        break;
                    }
                }
                buf[5] = '\0';
            }

            uart_print_str("  ");
            uart_print_str(buf);
            uart_print_str(" |");
        }
        uart_print_str("\n");
    }
    uart_print_str("|--------|--------|--------|--------|\n");
}

int move_left(void) {
    int i, j, k;
    int moved = 0;
    for (i = 0; i < BOARD_SIZE; i++) {
        for (j = 1; j < BOARD_SIZE; j++) {
            if (board[i][j] != 0) {
                k = j; // Start from the current position
                while (k > 0) {
                    if (board[i][k - 1] == 0) {
                        // Move to the left
                        board[i][k - 1] = board[i][k];
                        board[i][k] = 0;
                        moved = 1;
                        k--; // Continue moving to the left
                    } else if (board[i][k - 1] == board[i][k]) {
                        // Merge with the left tile
                        board[i][k - 1] *= 2;
                        board[i][k] = 0;
                        moved = 1;
                        break; // Stop moving this tile
                    } else {
                        // Blocked by a different tile
                        break; // Stop moving this tile
                    }
                }
            }
        }
    }
    return moved;
}

int move_right(void) {
    int i, j, k;
    int moved = 0;
    for (i = 0; i < BOARD_SIZE; i++) {
        // 从右向左遍历，确保右边的方块先就位
        for (j = BOARD_SIZE - 2; j >= 0; j--) {
            if (board[i][j] != 0) {
                k = j; // k 是当前要移动的方块的位置
                // 持续向右移动 k，直到它无法再移动
                while (k < BOARD_SIZE - 1) {
                    if (board[i][k + 1] == 0) { // 如果右边是空格
                        // 向右移动
                        board[i][k + 1] = board[i][k];
                        board[i][k] = 0;
                        moved = 1;
                        k++; // 继续向右探索
                    } else if (board[i][k + 1] == board[i][k]) { // 如果右边是相同数字
                        // 合并
                        board[i][k + 1] *= 2;
                        board[i][k] = 0;
                        moved = 1;
                        break; // 合并后，此方块移动结束
                    } else {
                        // 被不同数字挡住
                        break; // 此方块移动结束
                    }
                }
            }
        }
    }
    return moved;
}

int move_up(void) {
    int i, j, k;
    int moved = 0;
    for (j = 0; j < BOARD_SIZE; j++) {
        // 从上到下遍历行
        for (i = 1; i < BOARD_SIZE; i++) {
            if (board[i][j] != 0) {
                k = i; // k 是当前要移动的方块的行位置
                // 持续向上移动 k
                while (k > 0) {
                    if (board[k - 1][j] == 0) { // 如果上方是空格
                        // 向上移动
                        board[k - 1][j] = board[k][j];
                        board[k][j] = 0;
                        moved = 1;
                        k--; // 继续向上探索
                    } else if (board[k - 1][j] == board[k][j]) { // 如果上方是相同数字
                        // 合并
                        board[k - 1][j] *= 2;
                        board[k][j] = 0;
                        moved = 1;
                        break; // 合并后，此方块移动结束
                    } else {
                        // 被不同数字挡住
                        break; // 此方块移动结束
                    }
                }
            }
        }
    }
    return moved;
}

int move_down(void) {
    int i, j, k;
    int moved = 0;
    for (j = 0; j < BOARD_SIZE; j++) {
        // 从下到上遍历行
        for (i = BOARD_SIZE - 2; i >= 0; i--) {
            if (board[i][j] != 0) {
                k = i; // k 是当前要移动的方块的行位置
                // 持续向下移动 k
                while (k < BOARD_SIZE - 1) {
                    if (board[k + 1][j] == 0) { // 如果下方是空格
                        // 向下移动
                        board[k + 1][j] = board[k][j];
                        board[k][j] = 0;
                        moved = 1;
                        k++; // 继续向下探索
                    } else if (board[k + 1][j] == board[k][j]) { // 如果下方是相同数字
                        // 合并
                        board[k + 1][j] *= 2;
                        board[k][j] = 0;
                        moved = 1;
                        break; // 合并后，此方块移动结束
                    } else {
                        // 被不同数字挡住
                        break; // 此方块移动结束
                    }
                }
            }
        }
    }
    return moved;
}

int is_game_over(void) {
    int i, j;
    for (i = 0; i < BOARD_SIZE; i++) {
        for (j = 0; j < BOARD_SIZE; j++) {
            if (board[i][j] == 0) return 0;
            if (i < BOARD_SIZE - 1 && board[i][j] == board[i + 1][j]) return 0;
            if (j < BOARD_SIZE - 1 && board[i][j] == board[i][j + 1]) return 0;
        }
    }
    return 1;
}

void  TaskStart (void *pdata) 
{ 
    INT32U count = 0; 
    INT32U data;
    INT32U moved;
    pdata = pdata; 
    OSInitTick();       /* 在用户任务中初始化定时器、允许时钟中断 */  

    init_board();
    uart_print_str("Welcome to 2048!\n");
    print_board();
    uart_print_str("Use switches to move left, right, up, down. Press N17 to confirm.\n");

    for (;;) {            /* 一般而言，任务都是一个永不结束的循环 */ 
        // if(count <= 102) 
        // { 
        //     uart_putc(Info[count]);   /* 输出 Info 数组中的两个字节，对应一个汉字 */ 
        //     uart_putc(Info[count+1]); 
        // } 
        // gpio_out(count);  /* 通过 GPIO 输出 count 的值 */ 
        // count = count + 2;    /* count 的值加 2 */ 
        // OSTimeDly(10);    /* 等待 10 个 Tick 后，再次执行该任务 */ 
        data = gpio_in();
        INT32U ready = data << 31; // 也就是只判断这一位，因为移出来的都是 0
        INT32U choice = data >> 1;
        
        if (ready) {
            moved = 0;

            INT32U up = (choice & 0x0000000F) == 0x00000008;
            INT32U down = (choice & 0x0000000F) == 0x00000004;
            INT32U left = (choice & 0x0000000F) == 0x00000002;
            INT32U right = (choice & 0x0000000F) == 0x00000001;

            if (up) {
                uart_print_str("Your choice is: up\n");
                moved = move_up();
            }
            else if (down) {
                uart_print_str("Your choice is: down\n");
                moved = move_down();
            }
            else if (left) {
                uart_print_str("Your choice is: left\n");
                moved = move_left();
            }
            else if (right) {
                uart_print_str("Your choice is: right\n");
                moved = move_right();
            }
            else {
                uart_print_str("Invalid move!\n");
                continue;
            }

            if (moved) {
                add_new_tile();
            }

            print_board();
            
            if (is_game_over()) {
                uart_print_str("Game Over!\n");
                break; // 结束游戏
            } else {
                uart_print_str("Enter move...\n");
            }
        }
        count = count + 1;
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