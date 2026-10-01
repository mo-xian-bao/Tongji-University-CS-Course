#include "Mouse.h"
#include "IOPort.h"
#include "CRT.h"
#include "Utility.h" // 用于 Panic 或 printf 调试（可选）

#include "video.h"

/* 读取 CPU 时间戳计数器 (64位) */
static inline unsigned long long rdtsc()
{
    unsigned int lo, hi;
    // rdtsc 指令将时间戳读入 EDX:EAX
    __asm__ __volatile__ ("rdtsc" : "=a" (lo), "=d" (hi));
    return ((unsigned long long)hi << 32) | lo;
}


/* 静态成员初始化 */
unsigned char Mouse::m_Buffer[4] = {0};
unsigned int  Mouse::m_ByteIndex = 0;

void Mouse::MouseWait(unsigned char type)
{
    unsigned int time_out = 100000;
    if (type == 0) // 等待数据可读
    {
        while (time_out--)
        {
            if ((IOPort::InByte(CMD_PORT) & 1) == 1)
                return;
        }
        return;
    }
    else // 等待端口可写
    {
        while (time_out--)
        {
            if ((IOPort::InByte(CMD_PORT) & 2) == 0)
                return;
        }
        return;
    }
}

void Mouse::Write(unsigned char data)
{
    // 1. 发送“写鼠标设备”命令到 0x64
    MouseWait(1);
    IOPort::OutByte(CMD_PORT, CMD_WRITE_TO_MOUSE);
    
    // 2. 发送数据到 0x60
    MouseWait(1);
    IOPort::OutByte(DATA_PORT, data);
}

void Mouse::Init()
{
    unsigned char status;

    // 1. 启用鼠标的端口
    MouseWait(1);
    IOPort::OutByte(CMD_PORT, CMD_ENABLE_MOUSE_PORT);

    // 2. 开启中断 (IRQ 12)
    MouseWait(1);
    IOPort::OutByte(CMD_PORT, 0x20); // 读命令字节
    MouseWait(0);
    status = IOPort::InByte(DATA_PORT);
    status |= 2; // 设置 Bit 1 (Enable IRQ 12)
    MouseWait(1);
    IOPort::OutByte(CMD_PORT, 0x60); // 写命令字节
    MouseWait(1);
    IOPort::OutByte(DATA_PORT, status);

    // 3. 启用滚轮模式 (信号序列200, 100, 80)
    // 必须严格按照顺序发送，中间不能出错
    
    // 200
    Write(MOUSE_CMD_SET_SAMPLE);
    MouseWait(0); IOPort::InByte(DATA_PORT); // ACK
    Write(200);
    MouseWait(0); IOPort::InByte(DATA_PORT); // ACK

    // 100
    Write(MOUSE_CMD_SET_SAMPLE);
    MouseWait(0); IOPort::InByte(DATA_PORT); // ACK
    Write(100);
    MouseWait(0); IOPort::InByte(DATA_PORT); // ACK

    // 80
    Write(MOUSE_CMD_SET_SAMPLE);
    MouseWait(0); IOPort::InByte(DATA_PORT); // ACK
    Write(80);
    MouseWait(0); IOPort::InByte(DATA_PORT); // ACK

    // // 4. 检查 ID，确认是否切换成功
    // Write(MOUSE_CMD_GET_ID);
    // MouseWait(0); IOPort::InByte(DATA_PORT); // ACK
    // MouseWait(0); 
    // unsigned char id = IOPort::InByte(DATA_PORT); // Mouse ID

    // Diagnose::Write("Mouse ID: %x\n", id); 

    // 设置采样率为 200(降低延迟)
    Write(MOUSE_CMD_SET_SAMPLE);
    MouseWait(0); IOPort::InByte(DATA_PORT); // ACK
    Write(200);
    MouseWait(0); IOPort::InByte(DATA_PORT); // ACK

    // 5. 启用数据包传输
    Write(MOUSE_CMD_ENABLE);
    MouseWait(0); IOPort::InByte(DATA_PORT); // ACK
}

void Mouse::MouseHandler(struct pt_regs* reg, struct pt_context* context)
{
    unsigned char scancode = IOPort::InByte(DATA_PORT);

    switch (m_ByteIndex)
    {
    case 0:
        // Byte 0: 状态字节
        // Bit 3 必须为 1。如果不是，说明我们可能读到了中间的数据，丢弃并重置
        if ((scancode & 0x08) == 0x08)
        {
            m_Buffer[0] = scancode;
            m_ByteIndex++;
        }
        else
        {
            // 错误：未对齐，重置状态机
            m_ByteIndex = 0;
        }
        break;
    
    case 1:
        // Byte 1: X Movement
        m_Buffer[1] = scancode;
        m_ByteIndex++;
        break;
    
    case 2:
        // Byte 2: Y Movement
        m_Buffer[2] = scancode;
        m_ByteIndex++;
        break;

    case 3:
        m_Buffer[3] = scancode;
        m_ByteIndex = 0;

        // 只有当 Z 轴有值时才滚动
        // 过滤掉普通的移动包 (Z=0)
        char z = (char)scancode;
        //Diagnose::Write("Z value: %d\n", z);
        
        if (z != 0) 
        {
            //RDTSC 加速算法
            
            // 1. 获取当前 CPU 周期数
            unsigned long long current_time = rdtsc();
            
            // 2. 静态变量记录上次时间
            static unsigned long long last_time = 0;
            
            // 3. 计算差值
            unsigned long long diff = current_time - last_time;
            
            // 更新上次时间
            last_time = current_time;

            // 4. 定义阈值
            // 这里的 10000000 大约对应现代 CPU 的 20ms - 50ms
            const unsigned long long FAST_SCROLL_THRESHOLD = 10000000; 

            int multiplier = 1;
            
            // 如果间隔非常短（说明在快速拨动），开启加速
            if (diff < FAST_SCROLL_THRESHOLD) {
                multiplier = 3; // 3倍速
            }


            // 计算实际滚动的行数 = 基础步长 * 加速倍率
            int scroll_lines = 1 * multiplier; 

            unsigned int oldViewStart = CRT::m_ViewStartRow;

            if (z < 0) // 向上滚
            {
                for(int i = 0; i < scroll_lines; i++) {
                    if (CRT::m_ViewStartRow > 0) 
                        CRT::m_ViewStartRow--;
                    else break;
                }
            }
            else if (z > 0) // 向下滚
            {
                for(int i = 0; i < scroll_lines; i++) {
                    if (CRT::m_ViewStartRow + CRT::ROWS <= CRT::m_BufferHead)
                        CRT::m_ViewStartRow++;
                    else break;
                }
            }

            if (CRT::m_ViewStartRow != oldViewStart) {
                CRT::RefreshScreen();
            }
        }
        break;
    }
}