#include <stdio.h>
#include <stdlib.h>
#include <setjmp.h>
#include <sys.h>

/* 简单的字符串转整数实现 */
int atoi(const char *str)
{
    int res = 0;
    int sign = 1;
    int i = 0;

    //跳过空白字符
    while (str[i] == ' ' || str[i] == '\t' || str[i] == '\n') {
        i++;
    }

    // 处理正负号
    if (str[i] == '-') {
        sign = -1;
        i++;
    } else if (str[i] == '+') {
        i++;
    }

    // 转换数字
    while (str[i] >= '0' && str[i] <= '9') {
        res = res * 10 + (str[i] - '0');
        i++;
    }

    return sign * res;
}


static jmp_buf fpe_env;

__asm__(".align 2");

static void sig_dyzero(int signo)
{
    printf("Divide by zero!\n");

    // 重新注册信号处理函数，因为每次异常都会重置
    if(signal(SIGFPE, sig_dyzero) == -1)    //unix中的signal钩子函数失败返回似乎是-1
        printf("can't catch divide by zero error");


    // 跳转回 fpe_env 保存的位置
    longjmp(fpe_env, 1);
}

int main1()
{
    int a, b;
    int c;
    char buf[100];

    // 注册信号处理函数
    if(signal(SIGFPE, sig_dyzero) == -1)    //unix中的signal钩子函数失败返回似乎是-1
        printf("can't catch divide by zero error");

    for(;;)
    {
        // 设置跳转点（保存点）
        setjmp(fpe_env);

        printf("input the dividend:\n");
        gets(buf);
        a = atoi(buf);
        
        printf("input the divisor:\n");
        gets(buf);
        b = atoi(buf);

        c = a / b; 
        
        printf("%d / %d = %d\n", a, b, c);
    }
    
    return 0;
}