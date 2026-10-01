/*
 * 演示：父进程 fork 子进程，然后用 kill 系统调用发送 SIGKILL 杀死子进程
 */
#include <stdio.h>
#include <stdlib.h>
#include <sys.h>

int main1(int argc, char *argv[])
{
    int pid = fork();

    if (pid == 0)
    {
        /* 子进程：打印信息后进入无限循环 */
        printf("Child (PID %d) is running...\n", getpid());
        while (1)
        {
            sleep(1);
        }
    }
    else if (pid > 0)
    {
        /* 父进程 */
        printf("Parent (PID %d): going to kill child (PID %d) in 1 second.\n", getpid(), pid);
        sleep(1); /* 等待1秒*/

        /* 发送 SIGKILL (9号信号)，该信号不能被捕获或忽略 */
        kill(pid, SIGKILL); /* 等价于 kill(pid, 9) */

        int status;
        wait(&status); /* 回收子进程，防止变成僵尸进程 */
        printf("Parent: Child killed. Exit status: %d\n", status);
    }
    else
    {
        /* fork 失败 */
        printf("fork() failed!\n");
    }

    return 0;
}
