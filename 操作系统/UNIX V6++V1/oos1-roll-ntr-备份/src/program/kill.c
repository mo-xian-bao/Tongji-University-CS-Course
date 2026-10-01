#include <stdio.h>
#include <sys.h>

int str_to_int(char* str)
{
    int res=0;
    int i;

    for(i=0;str[i]!='\0';i++)
    {
        res=res*10+(str[i]-'0');
    }
    return res;
}


int main1(int argc, char **argv)
{
    if(argc!=3 || argv[1][0]!='-')
    {
       printf("Usage: kill -<signal> <pid>\n");
       return -1;
    }

    int res=kill(str_to_int(argv[2]),str_to_int(&argv[1][1]));

    if(res==-1)
    {
        printf("kill failed!\n");
        return -1;
    }
    else
    {
        printf("kill success!\n");
    }


    return 0;
}