#include "sys.h"
#include "stdio.h"

int main1(void)
{
    int ppid = -1;
    int pid = getpids(&ppid);
    if (pid < 0)
    {
        printf("getpids failed\n");
        return -1;
    }
    printf("pid = %d, ppid = %d\n", pid, ppid);
    return 0;
}