#include <stdio.h>
#include <stdlib.h>
#include <sys.h>

int main1(int argc, char *argv[])
{
    int pids[2]; // 数组用于存储当前进程和父进程PID

    // 调用getpids()获取PID数组
    int result = getpids(pids);

    if (result == 2)
    {
        // 显示获取到的PID信息
        printf("Current Process ID: %d\n", pids[0]);
        printf("Parent Process ID: %d\n", pids[1]);
    }
    else
    {
        printf("Error getting process IDs\n");
    }

    return 0;
}