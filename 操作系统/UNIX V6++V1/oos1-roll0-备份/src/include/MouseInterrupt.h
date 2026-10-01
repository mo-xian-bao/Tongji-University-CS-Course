#ifndef MOUSEINTERRUPT_H
#define MOUSEINTERRUPT_H


class MouseInterrupt 
{
public:
    // 鼠标中断入口函数，需要在 IDT 中注册
    static void MouseInterruptEntrance();
};

#endif