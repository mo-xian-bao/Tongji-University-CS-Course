#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <time.h>

int main(int argc, char *argv[])
{
    if (argc != 3)
        printf("Usage: copy oldfile newfile\n");
    int oldFile = open(argv[1], O_RDONLY); // 读打开已有文件 file1，oldFile 是用来读 file1 的文件描述符
    int newFile = open(argv[2], O_WRONLY | O_CREAT, S_IRUSR | S_IWUSR);
    // 创建一个新文件 file2， newFile 是用来写 file2 的文件描述符
    time_t start = time(NULL);
    char c;                           // 循环，直至file1读完，read函数返回0
    while (read(oldFile, &c, 1) == 1) // 从file1读一个字节，存入变量c
        write(newFile, &c, 1);        // 将其写入file2
    time_t end = time(NULL);
    double diff = difftime(end, start);
    printf("Copy Done in %.2f seconds\n", diff); // 人机交互。写屏幕告知程序运行结束。
    close(oldFile);                              // 文件，访问完及时关闭。这是一个好习惯。
    close(newFile);
}