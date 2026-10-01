#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys.h>

#define MAX_CMD_LEN 128
#define MAX_ARGS 20

int main1()
{
    char cmdLine[MAX_CMD_LEN];
    char *argv[MAX_ARGS];
    int argc;
    int pid, exitCode;
    int i;

    while (1)
    {
        printf("$ ");  // 提示符
        gets(cmdLine); // 读取一行输入

        // 解析命令行
        argc = 0;
        int len = strlen(cmdLine);
        if (len == 0)
            continue;

        // 简单的空格分割
        int in_word = 0;
        for (i = 0; i < len; i++)
        {
            if (cmdLine[i] == ' ' || cmdLine[i] == '\t' || cmdLine[i] == '\n')
            {
                cmdLine[i] = '\0';
                in_word = 0;
            }
            else
            {
                if (in_word == 0)
                {
                    argv[argc++] = &cmdLine[i];
                    in_word = 1;
                }
            }
            if (argc >= MAX_ARGS - 1)
                break;
        }
        argv[argc] = 0; // NULL 结尾

        if (argc == 0)
            continue;

        // 内部命令: logout
        if (strcmp(argv[0], "logout") == 0)
        {
            break;
        }
        // 内部命令: cd
        else if (strcmp(argv[0], "cd") == 0)
        {
            if (argc > 1)
            {
                if (chdir(argv[1]) < 0)
                {
                    printf("cd: %s: No such file or directory\n", argv[1]);
                }
            }
            continue;
        }

        // 外部命令
        pid = fork();
        if (pid < 0)
        {
            printf("fork failed\n");
        }
        else if (pid == 0)
        {
            // 子进程
            // 1. 尝试直接执行 (支持绝对路径或相对路径)
            execv(argv[0], argv);

            // 2. 如果失败，尝试在 /bin 下查找 (模拟 PATH)
            char path[128];
            strcpy(path, "/bin/");
            strcat(path, argv[0]);

            execv(path, argv);

            // 如果都失败了
            printf("Command not found: %s\n", argv[0]);
            exit(1);
        }
        else
        {
            // 父进程等待子进程结束
            wait(&exitCode);
        }
    }
    return 0;
}
