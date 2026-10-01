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

/* 标志位，指示是否发生除零错误 */
static volatile int div_error = 0;

/* 强制偶数地址对齐 */
__asm__(".align 2");

static void sig_dyzero(int signo)
{
	printf("Divide by zero!\n");
	signal(SIGFPE, sig_dyzero); /* 重新注册信号，否则下次会直接退出 */
	div_error = 1;
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
		printf("Input dividend:\n");
		gets(input);
		a = my_atoi(input);

		printf("Input divisor:\n");
		gets(input);
		b = my_atoi(input);

		div_error = 0;
		c = a / b;
		if (!div_error)
			printf("%d / %d = %d\n", a, b, c);
	}

	return 0;
}
