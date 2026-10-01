#include "MouseInterrupt.h"
#include "Kernel.h"
#include "Regs.h"
#include "Mouse.h"      // 假设你会有这个类
#include "IOPort.h"
#include "Chip8259A.h"
#include "ProcessManager.h" // 用于 Swtch

void MouseInterrupt::MouseInterruptEntrance()
{
    SaveContext();          /* 保存中断现场 */

    SwitchToKernel();       /* 进入核心态 */

    /* 
     * 调用鼠标中断处理逻辑 
     * 假设 Mouse 类有一个静态方法 MouseHandler 来读取端口 0x60
     */
    CallHandler(Mouse, MouseHandler); 

    /* 
     * 关键不同点：发送 EOI 
     * 鼠标接在从片 (Slave PIC) 上，所以要给两个芯片都发 EOI
     */
    IOPort::OutByte(Chip8259A::SLAVE_IO_PORT_1, Chip8259A::EOI);  // 发给从片
    IOPort::OutByte(Chip8259A::MASTER_IO_PORT_1, Chip8259A::EOI); // 发给主片

    /* 
     * 进程调度检查 (与键盘中断逻辑一致)
     * 检查是否需要进行进程切换
     */
    struct pt_context *context;
    __asm__ __volatile__ ("	movl %%ebp, %0; addl $0x4, %0 " : "+m" (context) );

    if( context->xcs & USER_MODE ) /* 先前为用户态 */
    {
        while(true)
        {
            X86Assembly::CLI();
            
            if(Kernel::Instance().GetProcessManager().RunRun > 0)
            {
                X86Assembly::STI();
                Kernel::Instance().GetProcessManager().Swtch();
            }
            else
            {
                break;
            }
        }
    }
    
    RestoreContext();       /* 恢复现场 */

    Leave();                /* 手工销毁栈帧 */

    InterruptReturn();      /* 退出中断 */
}