#include <stdio.h>
#include <stdlib.h>
#include <sys.h>

int main1(int argc, char *argv[])
{
    // 调用getppid()获取父进程PID
    int ppid = getppid();

    // 显示父进程PID
    printf("Parent Process ID: %d\n", ppid);

    return 0;
}