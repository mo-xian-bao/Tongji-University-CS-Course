#include <stdio.h>
#include <stdlib.h>
#include <sys.h>

void SIGINT_Handler()
{
    printf("You cannot kill me with Ctrl+C! (pid=%d)\n", getpid());
}

int main1(int argc, char *argv[])
{
    /* 注册对 SIGINT(2) 的自定义处理 */
    signal(SIGINT, SIGINT_Handler);

    printf("cantkill running (pid=%d). Try pressing Ctrl+C...\n", getpid());

    printf("Getting into sleep.\n");
    sleep(50);
    printf("Wakeup.\n");
    return 1;
}
