#include <stdio.h>
#include <stdlib.h>
#include <sys.h>

int main1(int argc, char *argv[])
{
    struct proc_info info;

    // 调用getproc()获取进程详细信息
    int result = getproc(&info);

    if (result == 0)
    {
        // 显示获取到的进程信息
        printf("Process Information:\n");
        printf("  PID: %d\n", info.pid);
        printf("  PPID: %d\n", info.ppid);
        printf("  State: %d\n", info.state);
        printf("  Code Segment Start: 0x%lx\n", info.textStart);
        printf("  Code Segment Length: 0x%lx\n", info.textSize);
        printf("  Data Segment Start: 0x%lx\n", info.dataStart);
        printf("  Data Segment Length: 0x%lx\n", info.dataSize);
        printf("  Stack Size: 0x%lx\n", info.stackSize);
        printf("  Physical Code Start: 0x%lx\n", info.textPhyStart);
        printf("  Physical Swap Start: 0x%lx\n", info.swapStart);
    }
    else
    {
        printf("Error getting process information\n");
    }

    return 0;
}