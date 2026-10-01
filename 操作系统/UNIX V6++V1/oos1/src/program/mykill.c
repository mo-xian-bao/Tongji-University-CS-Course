/*
 * 实现类似 Unix kill 命令的程序
 * 用法: mykill -信号 PID
 * 例如: mykill -9 123   (向进程123发送SIGKILL)
 *       mykill 15 123   (向进程123发送SIGTERM)
 */
#include <stdio.h>
#include <stdlib.h>
#include <sys.h>

/* atoi 实现 */
int atoi(char *str)
{
    int result = 0;
    int sign = 1;

    /* 跳过前导空格 */
    while (*str == ' ')
        str++;

    /* 处理符号 */
    if (*str == '-')
    {
        sign = -1;
        str++;
    }
    else if (*str == '+')
    {
        str++;
    }

    /* 转换数字 */
    while (*str >= '0' && *str <= '9')
    {
        result = result * 10 + (*str - '0');
        str++;
    }

    return sign * result;
}

int main1(int argc, char *argv[])
{
    int sig;
    int pid;

    if (argc < 3)
    {
        printf("Usage: kill -signal pid\n");
        exit(1);
    }

    /* 解析信号参数 */
    sig = atoi(argv[1]);
    if (sig < 0)
        sig = -sig; /* 如果用户输入 -9，转成 9 */

    /* 解析 PID 参数 */
    pid = atoi(argv[2]);

    if (pid <= 0)
    {
        printf("Error: Invalid PID %d\n", pid);
        return 1;
    }

    if (sig < 1 || sig > 31)
    {
        printf("Error: Invalid signal %d (must be 1-31)\n", sig);
        return 1;
    }

    /* 调用 kill 系统调用 */
    int ret = kill(pid, sig);

    if (ret < 0)
    {
        printf("kill failed: no such process or permission denied\n");
        return 1;
    }

    printf("Sent signal %d to process %d\n", sig, pid);
    return 0;
}
