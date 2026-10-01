#include <stdio.h>
#include <stdlib.h>
#include <sys.h>

int main1()
{
    char *argv[] = {"trivialProg", "arg1", "arg2", "arg3"};
    int exitCode;
    int pid;

    // 打印变量地址以验证栈布局
    printf("Verifying Stack Layout:\n");
    printf("Address of argv:     %x\n", &argv);
    printf("Address of pid:      %x\n", &pid);
    printf("Address of exitCode: %x\n", &exitCode);
    printf("-----------------------\n");

    pid = fork();
    if (pid == 0) // 子进程
    {
        // 使用绝对路径
        execv("/bin/trivialProg", argv);
        printf("Done!\n");
    }
    else // 父进程
    {
        wait(&exitCode);
        printf("The end of tryExec.\n");
    }
}
