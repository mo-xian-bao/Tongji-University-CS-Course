#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <string.h>

int main()
{
    FILE* fp;
    char buf[80] = "abc\n123\nxyz\n";

    fp = fopen("out.txt", "wb");
    int ret = fwrite(buf, 1, strlen(buf), fp);
    printf("ret=%d\n", ret);
    fclose(fp);

    return 0;
}
