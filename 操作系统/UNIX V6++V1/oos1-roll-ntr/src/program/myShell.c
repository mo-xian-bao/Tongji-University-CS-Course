#include <stdio.h>
#include <stdlib.h>
#include <string.h>  // 用于 strcmp
#include <sys.h>    
#include <file.h>

// 解析函数：将命令行字符串分割成参数数组
void parse(char *cmd, char *argv[]) {
    int argIdx = 0;
    int i = 0;

    while (cmd[i] != '\0' && argIdx < 19) {
        // 跳过空格、制表符和换行符
        while (cmd[i] == ' ' || cmd[i] == '\t' || cmd[i] == '\n') {
            cmd[i] = '\0'; // 将分隔符替换为 \0，确保前一个字符串正确结束
            i++;
        }

        // 如果到了字符串末尾，就结束循环
        if (cmd[i] == '\0') {
            break;
        }

        // 当前位置是非空格，这就是一个参数的开始
        argv[argIdx] = &cmd[i];
        argIdx++;

        // 继续向后扫描，直到遇到下一个分隔符或字符串结束
        while (cmd[i] != '\0' && cmd[i] != ' ' && cmd[i] != '\t' && cmd[i] != '\n') {
            i++;
        }
    }
    
    // 参数列表必须以 NULL 结尾
    argv[argIdx] = 0; 
}

int main1() {
    char command[100];
    char *argv[20]; 
    char curPath[50];
    int exitCode;
    int pid;

    while (1) {
        getPath(curPath);
        printf("{%s} # ", curPath); // 提示符

        // 读取整行输入
        // scanf("%s") 不行，因为它读到空格就停。
        gets(command);  

        // 如果输入为空，直接下一轮
        if (strlen(command) == 0) continue;

        // 解析命令
        parse(command, argv);

        // 如果没有解析出任何参数（比如用户只按了回车），跳过
        if (argv[0] == 0) continue;

        // 处理内部命令
        // C语言不能对字符串 switch，必须用 strcmp
        if (strcmp(argv[0], "cd") == 0) {
            if (argv[1] != 0) {
                // chdir 是系统调用，改变当前工作目录
                if (chdir(argv[1]) < 0) {
                    printf("cd: %s: No such directory\n", argv[1]);
                }
            } else {
                // 如果只输入 cd，不做操作，打印usage
                printf("Usage: cd <directory>\n");
            }
            continue; // 内部命令执行完后，直接进入下一次循环
        } 
        else if (strcmp(argv[0], "logout") == 0) {
            break; // 跳出 while 循环，shell程序结束
        }

        // 处理外部命令
        pid = fork();
        if (pid == 0) {
            execv(argv[0], argv);
            
            // 如果 execv 从这里返回，说明出错（比如命令没找到）
            printf("Command not found: %s\n", argv[0]);
            exit(1);
        } 
        else {
            // 父进程等待
            wait(&exitCode);
        }
    }

    printf("Bye.\n");
    return 0;
}