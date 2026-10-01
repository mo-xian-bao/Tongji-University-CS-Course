#include <stdio.h>
#include <sys.h>

/* 简单的 atoi 实现 */
static int my_atoi(char *str)
{
	int result = 0;
	int sign = 1;
	int i = 0;

	/* 跳过空白字符 */
	while (str[i] == ' ' || str[i] == '\t' || str[i] == '\n')
		i++;

	/* 处理符号 */
	if (str[i] == '-')
	{
		sign = -1;
		i++;
	}
	else if (str[i] == '+')
	{
		i++;
	}

	/* 转换数字 */
	while (str[i] >= '0' && str[i] <= '9')
	{
		result = result * 10 + (str[i] - '0');
		i++;
	}

	return sign * result;
}

static jmp_buf fpe_env;

/* 强制偶数地址对齐 */
__asm__(".align 2");

static void sig_dyzero(int signo)
{
	printf("Divide by zero!\n");
	/* 重新注册信号处理函数（UnixV6++ 在每次信号处理后会重置） */
	signal(SIGFPE, sig_dyzero);
	longjmp(fpe_env, 1);
}

int main1(void)
{
	int a, b;
	int c;
	char input[100];

	if (signal(SIGFPE, sig_dyzero) == -1)
		printf("can't catch divide by zero error!\n");

	for ( ; ; )
	{
		if (setjmp(fpe_env) == 0)
		{
			/* 正常执行路径 */
			printf("Input dividend:\n");
			gets(input);
			a = my_atoi(input);

			printf("Input divisor:\n");
			gets(input);
			b = my_atoi(input);

			c = a / b;
			printf("%d / %d = %d\n", a, b, c);
		}
		else
		{
			/* 从信号处理函数跳转回此处 */
			printf("Recovered from divide by zero, continuing...\n");
		}
	}

	return 0;
}

