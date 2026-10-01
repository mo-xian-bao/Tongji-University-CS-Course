/* 计拔 2351520 毛星博 */
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <string.h>

int usage(const char* const procname) {
    printf("Usage : %s --check 文件名 | --convert { wtol|ltow } 源文件名 目标文件名\n", procname);
    printf("        %s --check a.txt\n", procname);
    printf("        %s --convert wtol a.win.txt a.linux.txt\n", procname);
    printf("        %s --convert ltow a.linux.txt a.win.txt\n", procname);
    return 0;
}

int check_file(FILE* file)
{
    int W = 0, L = 0;
    unsigned char c;

    while ((c = fgetc(file)) != EOF && feof(file) == 0) {
        if (c == 0x0A) {
            fseek(file, -2, SEEK_CUR);
            c = fgetc(file);
            if (c == 0x0D) {
                W++;
            }
            else {
                L++;
            }
            fseek(file, 2, SEEK_CUR);
        }
    }

    if (W > 0 && L == 0) {
        return 1;
    }
    else if (W == 0 && L > 0) {
        return 2;
    }
    else {
        return 0;
    }
}

int main(int argc, char* argv[])
{
    if (argc == 3) {
        if (strcmp(argv[1], "--check") == 0) {
            FILE* file = fopen(argv[2], "rb");
            if (file == NULL) {
                printf("输入文件%s打开失败!\n", argv[2]);
                return -1;
            }

            int status = check_file(file);
            fclose(file);

            if (status == 1) {
                printf("Windows格式\n");
            }
            else if (status == 2) {
                printf("Linux格式\n");
            }
            else {
                printf("文件格式无法识别\n");
            }
        }
        else {
            return usage(argv[0]);
        }
    }

    else if (argc == 5) {
        if (strcmp(argv[1], "--convert") != 0) {
            return usage(argv[0]);
        }

        if (strcmp(argv[2], "wtol") == 0) {
            FILE* fp_in = fopen(argv[3], "rb");
            if (fp_in == NULL) {
                printf("输入文件%s打开失败!\n", argv[3]);
                return -1;
            }
            if (check_file(fp_in) != 1) {
                printf("文件格式无法识别\n");
                fclose(fp_in);
                return -1;
            }
            fseek(fp_in, 0, SEEK_SET);

            FILE* fp_out = fopen(argv[4], "wb");
            if (fp_out == NULL) {
                printf("输出文件%s打开失败!\n", argv[4]);
                fclose(fp_in);
                return -1;
            }

            unsigned char c;
            int count = 0;
            while((c = fgetc(fp_in)) != EOF && feof(fp_in) == 0){
                if (c == 0x0D) {
                    c = fgetc(fp_in);
                    if (c == 0x0A) {
                        count++;
                        fputc(0x0A, fp_out);
                    }
                    else {
                        fseek(fp_in, -1, SEEK_CUR);
                        fputc(0x0D, fp_out);
                    }
                }
                else {
                    fputc(c, fp_out);
                }
            }

            printf("转换完成，去除%d个0x0D\n", count);
            fclose(fp_in);
            fclose(fp_out);
        }

        else if (strcmp(argv[2], "ltow") == 0) {
            FILE* fp_in = fopen(argv[3], "rb");
            if (fp_in == NULL) {
                printf("输入文件%s打开失败!\n", argv[3]);
                return -1;
            }
            if (check_file(fp_in) != 2) {
                printf("文件格式无法识别\n");
                fclose(fp_in);
                return -1;
            }
            fseek(fp_in, 0, SEEK_SET);

            FILE* fp_out = fopen(argv[4], "wb");
            if (fp_out == NULL) {
                printf("输出文件%s打开失败!\n", argv[4]);
                fclose(fp_in);
                return -1;
            }

            unsigned char c;
            int count = 0;
            while((c = fgetc(fp_in)) != EOF && feof(fp_in) == 0){
                if (c == 0x0A) {
                    count++;
                    fputc(0x0D, fp_out);
                    fputc(0x0A, fp_out);
                }
                else {
                    fputc(c, fp_out);
                }
            }

            printf("转换完成，加入%d个0x0D\n", count);
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