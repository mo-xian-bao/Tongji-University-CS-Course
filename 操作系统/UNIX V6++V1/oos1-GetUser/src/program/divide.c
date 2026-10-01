#include <stdio.h>
#include <sys.h>

/* Simple atoi implementation */
static int my_atoi(char *str)
{
int result = 0;
int sign = 1;
int i = 0;

/* Skip whitespace */
while (str[i] == ' ' || str[i] == '\t' || str[i] == '\n')
i++;

/* Handle sign */
if (str[i] == '-')
{
sign = -1;
i++;
}
else if (str[i] == '+')
{
i++;
}

/* Convert digits */
while (str[i] >= '0' && str[i] <= '9')
{
result = result * 10 + (str[i] - '0');
i++;
}

return sign * result;
}

/* Flag to indicate divide by zero occurred */
static volatile int div_error = 0;

/* Force even address alignment with asm nop */
__asm__(".align 2");

static void sig_dyzero(int signo)
{
printf("Divide by zero!\n");
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
