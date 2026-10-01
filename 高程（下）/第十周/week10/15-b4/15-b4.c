/* 计拔 2351520 毛星博 */
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <string.h>

int usage(const char* const procname) 
{
    printf("Usage : %s --infile 原始文件 [ --outfile hex格式文件 ]\n", procname);
    printf("        %s --infile a.docx\n", procname);
    printf("        %s --infile a.docx --outfile a.hex\n", procname);
    return 0;
}

void infile_to_outfile(FILE* fp_in, FILE* fp_out)
{
    unsigned char c;
    char ch[17] = { 0 };
    int i = 0;

    while ((c = fgetc(fp_in))!= EOF && feof(fp_in) == 0){
        if (i % 16 == 0) {
            fprintf(fp_out, "%08lx  ", ftell(fp_in) - 1L);
        }
        if (i % 16 == 8) {
            fprintf(fp_out, "- ");
        }

        fprintf(fp_out, "%02x ", c);
        ch[i % 16] = (c >= 33 && c <= 126)? c : '.';

        if (i % 16 == 15) {
            fprintf(fp_out, "    %s\n", ch);
            for (int j = 0; j < 16; j++) {
                ch[j] = 0;
            }
        }
        i++;
    }
    //输出最后一行不满16个字符的部分
    if (i % 16 != 0) {
        for (int j = i % 16; j < 16; j++) {
            fprintf(fp_out, "   ");
            if (j == 8) {
                fprintf(fp_out, "  ");
            }
        }
        fprintf(fp_out, "    %s\n", ch);
        for (int j = 0; j < 16; j++) {
            ch[j] = 0;
        }
    }
}

int main(int argc, char* argv[]) 
{
    unsigned char c;
    char ch[17] = { 0 };
    int i = 0;

    if (argc == 3) {
        if (strcmp(argv[1], "--infile") == 0) {
            FILE *fp = fopen(argv[2], "rb");
            if (fp == NULL) {
                printf("输入文件%s打开失败!\n", argv[2]);
                return -1;
            }

            while ((c = fgetc(fp))!= EOF && feof(fp) == 0){
                if (i % 16 == 0) {
                    printf("%08lx  ", ftell(fp) - 1L);
                }
                if (i % 16 == 8) {
                    printf("- ");
                }

                printf("%02x ", c);
                ch[i % 16] = (c >= 33 && c <= 126)? c : '.';

                if (i % 16 == 15) {
                    printf("    %s\n", ch);
                    for (int j = 0; j < 16; j++) {
                        ch[j] = 0;
                    }
                }
                i++;
            }
            //输出最后一行不满16个字符的部分
            if (i % 16 != 0) {
                for (int j = i % 16; j < 16; j++) {
                    printf("   ");
                    if(j == 8){
                        printf("  ");
                    }
                }
                printf("    %s\n", ch);
                for (int j = 0; j < 16; j++) {
                    ch[j] = 0;
                }
            }
            fclose(fp);
        }
        else {
            return usage(argv[0]);
        }
    }

    else if (argc == 5) {
        if (strcmp(argv[1], "--infile") == 0 && strcmp(argv[3], "--outfile") == 0) {
            FILE *fp_in = fopen(argv[2], "rb");
            if (fp_in == NULL) {
                printf("输入文件%s打开失败!\n", argv[2]);
                return -1;
            }
            FILE *fp_out = fopen(argv[4], "w");
            if (fp_out == NULL) {
                printf("输出文件%s打开失败!\n", argv[4]);
                fclose(fp_in);
                return -1;
            }

            infile_to_outfile(fp_in, fp_out);
            fclose(fp_in);
            fclose(fp_out);
        }
        else if (strcmp(argv[3], "--infile") == 0 && strcmp(argv[1], "--outfile") == 0) {
            FILE *fp_in = fopen(argv[4], "rb");
            if (fp_in == NULL) {
                printf("输入文件%s打开失败!\n", argv[4]);
                return -1;
            }
            FILE *fp_out = fopen(argv[2], "w");
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
    }
    else {
        return usage(argv[0]);
    }

    return 0;
}