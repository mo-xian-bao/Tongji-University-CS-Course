/* 计拔 2351520 毛星博 */
/* 2354366 徐华炫 2352841 刘佳鑫 2353599 冯灏然 2350997 王一希 2351274 王亦玮 */
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <string.h>

int usage(const char* const procname) {
    printf("Usage : %s --infile hex格式文件 --outfile bin格式文件\n", procname);
    printf("        %s --infile a.hex --outfile a.bin\n", procname);
    return 0;
}

int hex2int(char* c)
{
    int i = 0;
    for (int j = 0; j < 2; j++) {
        i <<= 4;
        if (c[j] >= '0' && c[j] <= '9') {
            i += c[j] - '0';
        }
        else if (c[j] >= 'a' && c[j] <= 'f') {
            i += c[j] - 'a' + 10;
        }
        else if (c[j] >= 'A' && c[j] <= 'F') {
            i += c[j] - 'A' + 10;
        }
        else {
            return -1;
        }
    }
    return i;
}

void infile_to_outfile(FILE* fp_in, FILE* fp_out) 
{
    char str[30] = {0};
    char line[100] = {0};
    int n = 0;

    while (fgets(line, 100, fp_in)) {
        n = 0;
        for (unsigned int i = 0; i < strlen(line); i++) {
            if (line[i] != ' ') {
                str[n] = line[i];
                n++;
            }
            else {
                while (line[i + 1] == ' ')
                    i++;
                str[n] = '\0';
                if (strlen(str) == 2)
                    fprintf(fp_out, "%c", hex2int(str));
                n = 0;
            }
        }
    }
}

int main(int argc, char* argv[])
{
    if (argc!= 5) {
        return usage(argv[0]);
    }
    
    if (strcmp(argv[1], "--infile") == 0 && strcmp(argv[3], "--outfile") == 0) {
        FILE* fp_in = fopen(argv[2], "rb");
        if (fp_in == NULL) {
            printf("输入文件%s打开失败!\n", argv[2]);
            return -1;
        }
        FILE* fp_out = fopen(argv[4], "wb");
        if (fp_out == NULL) {
            printf("输出文件%s打开失败!\n", argv[4]);
            fclose(fp_in);
            return -1;
        }
        infile_to_outfile(fp_in, fp_out);
        fclose(fp_in);
        fclose(fp_out);
    }
    else if(strcmp(argv[3], "--infile")==0&&strcmp(argv[1], "--outfile")==0) {
        FILE* fp_in = fopen(argv[4], "rb");
        if (fp_in == NULL) {
            printf("输入文件%s打开失败!\n", argv[4]);
            return -1;
        }
        FILE* fp_out = fopen(argv[2], "wb");
        if (fp_out == NULL) {
            printf("输出文件%s打开失败!\n", argv[2]);
            fclose(fp_in);
            return -1;
        }
        infile_to_outfile(fp_in, fp_out);
        fclose(fp_in);
        fclose(fp_out);
    }
    else {
        return usage(argv[0]);
    }
    return 0;
}