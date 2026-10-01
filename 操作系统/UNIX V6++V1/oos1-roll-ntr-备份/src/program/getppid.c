#include "sys.h"
#include "stdio.h"

int main1(void)
{
    int ppid = getppid();
    if (ppid < 0)
    {
        printf("getppid failed\n");
        return -1;
    }
    printf("parent pid = %d\n", ppid);
    return 0;
}