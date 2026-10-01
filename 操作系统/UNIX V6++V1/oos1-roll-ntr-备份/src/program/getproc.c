#include "sys.h"
#include "stdio.h"

int main1(void)
{
    struct proc_info info;
    if (getproc(&info) < 0)
    {
        printf("getproc failed\n");
        return -1;
    }
    printf("pid=%d ppid=%d uid=%d state=%d pri=%d\n",
           info.pid, info.ppid, info.uid, info.state, info.pri);
    printf("code vaddr=0x%lx size=%u data vaddr=0x%lx size=%u stack=%u\n",
           info.code_vaddr, info.code_size,
           info.data_vaddr, info.data_size,
           info.stack_size);
    printf("code paddr=0x%lx swap paddr=0x%lx\n",
           info.code_paddr, info.swap_paddr);
    return 0;
}