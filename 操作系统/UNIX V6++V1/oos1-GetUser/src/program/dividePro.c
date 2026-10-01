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

static jmp_buf fpe_env;

/* Force even address alignment */
__asm__(".align 2");

static void sig_dyzero(int signo)
{
printf("Divide by zero!\n");
/* Re-register signal handler (UnixV6++ resets it after each signal) */
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
/* Normal execution path */
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
/* Jumped here from signal handler */
printf("Recovered from divide by zero, continuing...\n");
}
}

return 0;
}
