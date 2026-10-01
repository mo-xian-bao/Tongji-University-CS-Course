#include "includes.h"

#define BOTH_EMPTY (UART_LS_TEMT | UART_LS_THRE)

#define TASK_STK_SIZE      256
#define TOWER_COUNT        3
#define MAX_DISKS          4
#define MIN_MOVE_COUNT     15

#define BTN_CONFIRM_MASK   0x00000001
#define SW_A_MASK          0x00000002
#define SW_B_MASK          0x00000004
#define SW_C_MASK          0x00000008
#define SW_RESTART_MASK    0x00000010
#define CONTROL_MASK       (SW_A_MASK | SW_B_MASK | SW_C_MASK | SW_RESTART_MASK)

#define STAGE_SELECT_FROM  0
#define STAGE_SELECT_TO    1
#define GPIO_SEG_OFF       0x0000FFFF

OS_STK TaskStartStk[TASK_STK_SIZE];

INT32U towers[TOWER_COUNT][MAX_DISKS];
INT32U tower_size[TOWER_COUNT];
INT32U move_count;
INT32U selected_from;
INT32U game_stage;
INT32U game_finished;
INT32U last_confirm;

static void uart_print_uint(INT32U value);
static void uart_print_tower_name(INT32U tower_id);
static void uart_print_disk_cell(INT32U disk);
static void gpio_show_progress(void);
static void game_init(void);
static void draw_board(void);
static INT32U decode_tower_select(INT32U input_value);
static INT32U restart_requested(INT32U input_value);
static INT32U try_move(INT32U from_tower, INT32U to_tower);
static INT32U game_completed(void);
static void handle_confirm(INT32U input_value);

#define WAIT_FOR_XMITR                              \
    do {                                           \
        lsr = REG8(UART_BASE + UART_LS_REG);       \
    } while ((lsr & BOTH_EMPTY) != BOTH_EMPTY)

#define WAIT_FOR_THRE                               \
    do {                                           \
        lsr = REG8(UART_BASE + UART_LS_REG);       \
    } while ((lsr & UART_LS_THRE) != UART_LS_THRE)

void uart_init(void)
{
    INT32U divisor;

    divisor = (INT32U)IN_CLK / (16 * UART_BAUD_RATE);

    REG8(UART_BASE + UART_LC_REG) = 0x80;
    REG8(UART_BASE + UART_DLB1_REG) = divisor & 0x000000ff;
    REG8(UART_BASE + UART_DLB2_REG) = (divisor >> 8) & 0x000000ff;
    REG8(UART_BASE + UART_LC_REG) = 0x00;

    REG8(UART_BASE + UART_IE_REG) = 0x00;

    REG8(UART_BASE + UART_LC_REG) =
        UART_LC_WLEN8 | (UART_LC_ONE_STOP | UART_LC_NO_PARITY);

    uart_print_str("UART initialize done !\n");
}

void uart_putc(char c)
{
    unsigned char lsr;

    WAIT_FOR_THRE;
    REG8(UART_BASE + UART_TH_REG) = c;

    if (c == '\n') {
        WAIT_FOR_THRE;
        REG8(UART_BASE + UART_TH_REG) = '\r';
    }

    WAIT_FOR_XMITR;
}

void uart_print_str(char *str)
{
    INT32U i;
    OS_CPU_SR cpu_sr;

    i = 0;
    OS_ENTER_CRITICAL();

    while (str[i] != 0) {
        uart_putc(str[i]);
        i++;
    }

    OS_EXIT_CRITICAL();
}

void gpio_init(void)
{
    REG32(GPIO_BASE + GPIO_OE_REG) = 0xffffffff;
    REG32(GPIO_BASE + GPIO_INTE_REG) = 0x00000000;
    REG32(GPIO_BASE + GPIO_OUT_REG) = GPIO_SEG_OFF;

    uart_print_str("GPIO initialize done !\n");
}

void gpio_out(INT32U number)
{
    REG32(GPIO_BASE + GPIO_OUT_REG) = number;
}

INT32U gpio_in(void)
{
    return REG32(GPIO_BASE + GPIO_IN_REG);
}

void OSInitTick(void)
{
    INT32U compare;

    compare = (INT32U)(IN_CLK / OS_TICKS_PER_SEC);

    asm volatile("mtc0 %0,$9" : : "r"(0x0));
    asm volatile("mtc0 %0,$11" : : "r"(compare));
    asm volatile("mtc0 %0,$12" : : "r"(0x10000401));
}

static void uart_print_uint(INT32U value)
{
    char digits[10];
    INT32U count;

    if (value == 0) {
        uart_putc('0');
        return;
    }

    count = 0;
    while (value > 0) {
        digits[count] = (char)('0' + (value % 10));
        value = value / 10;
        count++;
    }

    while (count > 0) {
        count--;
        uart_putc(digits[count]);
    }
}

static void uart_print_tower_name(INT32U tower_id)
{
    uart_putc((char)('A' + tower_id));
}

static void uart_print_disk_cell(INT32U disk)
{
    switch (disk) {
    case 1:
        uart_print_str("  1  ");
        break;
    case 2:
        uart_print_str("  2  ");
        break;
    case 3:
        uart_print_str("  3  ");
        break;
    case 4:
        uart_print_str("  4  ");
        break;
    default:
        uart_print_str("     ");
        break;
    }
}

static void gpio_show_progress(void)
{
    INT32U led_value;

    led_value = (move_count & 0x0000FFFF) << 16;
    gpio_out(led_value | GPIO_SEG_OFF);
}

static void game_init(void)
{
    INT32U tower_id;
    INT32U disk_id;

    for (tower_id = 0; tower_id < TOWER_COUNT; tower_id++) {
        tower_size[tower_id] = 0;
        for (disk_id = 0; disk_id < MAX_DISKS; disk_id++) {
            towers[tower_id][disk_id] = 0;
        }
    }

    towers[0][0] = 4;
    towers[0][1] = 3;
    towers[0][2] = 2;
    towers[0][3] = 1;
    tower_size[0] = MAX_DISKS;

    move_count = 0;
    selected_from = 0;
    game_stage = STAGE_SELECT_FROM;
    game_finished = 0;
    gpio_show_progress();
}

static void draw_board(void)
{
    INT32U level;
    INT32U tower_id;
    INT32U disk;

    uart_print_str("\n========================================\n");
    uart_print_str("           Tower of Hanoi\n");
    uart_print_str("========================================\n");
    uart_print_str("Controls: SW1=A  SW2=B  SW3=C\n");
    uart_print_str("          SW4=Restart  N17=Confirm\n");
    uart_print_str("Moves: ");
    uart_print_uint(move_count);
    uart_print_str(" / Minimum: ");
    uart_print_uint(MIN_MOVE_COUNT);
    uart_print_str("\n");

    if (game_finished != 0) {
        uart_print_str("Status: Puzzle solved. Use SW4 + N17 to restart.\n");
    } else if (game_stage == STAGE_SELECT_FROM) {
        uart_print_str("Status: Select the source tower.\n");
    } else {
        uart_print_str("Status: Select the destination tower for ");
        uart_print_tower_name(selected_from);
        uart_print_str(".\n");
    }

    uart_print_str("\n      A       B       C\n");
    uart_print_str("    +-----+ +-----+ +-----+\n");

    for (level = MAX_DISKS; level > 0; level--) {
        uart_print_str("    |");
        for (tower_id = 0; tower_id < TOWER_COUNT; tower_id++) {
            if ((level - 1) < tower_size[tower_id]) {
                disk = towers[tower_id][level - 1];
            } else {
                disk = 0;
            }
            uart_print_disk_cell(disk);
            uart_print_str("|");
        }
        uart_print_str("\n");
    }

    uart_print_str("    +-----+ +-----+ +-----+\n");
}

static INT32U decode_tower_select(INT32U input_value)
{
    INT32U switch_state;

    switch_state = input_value & (SW_A_MASK | SW_B_MASK | SW_C_MASK);

    if (switch_state == SW_A_MASK) {
        return 0;
    }
    if (switch_state == SW_B_MASK) {
        return 1;
    }
    if (switch_state == SW_C_MASK) {
        return 2;
    }

    return TOWER_COUNT;
}

static INT32U restart_requested(INT32U input_value)
{
    return (input_value & CONTROL_MASK) == SW_RESTART_MASK;
}

static INT32U try_move(INT32U from_tower, INT32U to_tower)
{
    INT32U moving_disk;

    if (tower_size[from_tower] == 0) {
        return 0;
    }

    moving_disk = towers[from_tower][tower_size[from_tower] - 1];

    if (tower_size[to_tower] > 0) {
        if (towers[to_tower][tower_size[to_tower] - 1] < moving_disk) {
            return 0;
        }
    }

    tower_size[from_tower]--;
    towers[from_tower][tower_size[from_tower]] = 0;
    towers[to_tower][tower_size[to_tower]] = moving_disk;
    tower_size[to_tower]++;

    return 1;
}

static INT32U game_completed(void)
{
    return tower_size[2] == MAX_DISKS;
}

static void handle_confirm(INT32U input_value)
{
    INT32U tower_id;

    if (restart_requested(input_value) != 0) {
        uart_print_str("\nRestarting puzzle...\n");
        game_init();
        draw_board();
        return;
    }

    tower_id = decode_tower_select(input_value);

    if (tower_id >= TOWER_COUNT) {
        uart_print_str("\nInvalid selection. Turn on exactly one of SW1, SW2 or SW3.\n");
        return;
    }

    if (game_finished != 0) {
        uart_print_str("\nThe puzzle is already solved. Use SW4 + N17 to restart.\n");
        return;
    }

    if (game_stage == STAGE_SELECT_FROM) {
        if (tower_size[tower_id] == 0) {
            uart_print_str("\nThat tower is empty. Choose a different source tower.\n");
            return;
        }

        selected_from = tower_id;
        game_stage = STAGE_SELECT_TO;
        uart_print_str("\nSource tower set to ");
        uart_print_tower_name(selected_from);
        uart_print_str(".\n");
        draw_board();
        return;
    }

    if (tower_id == selected_from) {
        uart_print_str("\nSource and destination towers must be different.\n");
        return;
    }

    if (try_move(selected_from, tower_id) == 0) {
        uart_print_str("\nIllegal move: a larger disk cannot be placed on a smaller disk.\n");
        return;
    }

    move_count++;
    game_stage = STAGE_SELECT_FROM;
    selected_from = 0;
    gpio_show_progress();

    if (game_completed() != 0) {
        game_finished = 1;
    }

    draw_board();

    if (game_finished != 0) {
        uart_print_str("Congratulations! You solved the Tower of Hanoi puzzle.\n");
    }
}

void TaskStart(void *pdata)
{
    INT32U input_value;
    INT32U confirm_pressed;

    pdata = pdata;
    OSInitTick();

    game_init();
    uart_print_str("\nWelcome to Tower of Hanoi!\n");
    uart_print_str("Move all disks from tower A to tower C.\n");
    draw_board();

    for (;;) {
        input_value = gpio_in();
        confirm_pressed = input_value & BTN_CONFIRM_MASK;

        if ((confirm_pressed != 0) && (last_confirm == 0)) {
            handle_confirm(input_value);
        }

        last_confirm = confirm_pressed;
        OSTimeDly(2);
    }
}

void main(void)
{
    OSInit();
    uart_init();
    gpio_init();
    OSTaskCreate(TaskStart, (void *)0, &TaskStartStk[TASK_STK_SIZE - 1], 0);
    OSStart();
}
