#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{
    int a[10] = { 0,1,2,3,4,5,6,7,8,9 };

    /*①*/  a[10] = 10;    //此句越界
    a[14] = 14;    //此句越界
    a[15] = 15;    //此句越界
    /*②*/  a[10] = 0xcccccccc; //此句越界
    printf("addr:%p\n", a);
    for (int i = -4; i < 16; i++) //注意，只有0-9是合理范围，其余都是越界读
        printf("%p:%02x\n", (a + i), a[i]);

    return 0;
}
