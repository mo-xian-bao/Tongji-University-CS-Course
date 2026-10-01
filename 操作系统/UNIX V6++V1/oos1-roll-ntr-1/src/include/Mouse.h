#ifndef MOUSE_H
#define MOUSE_H

#include "Regs.h"

class Mouse
{
public:
    /* 端口定义 */
    static const unsigned short DATA_PORT = 0x60;
    static const unsigned short CMD_PORT  = 0x64;

    /* 鼠标命令 */
    static const unsigned char CMD_ENABLE_MOUSE_PORT = 0xA8;
    static const unsigned char CMD_WRITE_TO_MOUSE    = 0xD4;
    static const unsigned char MOUSE_CMD_ENABLE      = 0xF4;
    static const unsigned char MOUSE_CMD_SET_SAMPLE  = 0xF3;
    static const unsigned char MOUSE_CMD_GET_ID      = 0xF2;

    /* 成员函数 */
public:
    static void Init(); // 初始化鼠标并开启滚轮模式
    static void MouseHandler(struct pt_regs* reg, struct pt_context* context);

private:
    static void MouseWait(unsigned char type); // 等待端口可读/可写
    static void Write(unsigned char data);     // 向鼠标发送命令

    /* 状态机变量 */
    static unsigned char m_Buffer[4]; // 存储4字节数据包
    static unsigned int  m_ByteIndex; // 当前接收到的字节索引
};

#endif