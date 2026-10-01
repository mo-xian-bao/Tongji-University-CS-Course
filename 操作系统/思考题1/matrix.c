#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define M 2048

int version = 1;
int matrixOriginal[M][M];
int matrixDes[M][M];

void produce(int row, int column)
{
    int i;
    for (i = 0; i < M; i++)
    {
        matrixDes[row][column] += matrixOriginal[row][i] * matrixOriginal[i][column];
    }
}

int main()
{
    int i, j;

    // 初始化矩阵
    for (i = 0; i < M; i++)
    {
        for (j = 0; j < M; j++)
        {
            matrixOriginal[i][j] = 1;
            matrixDes[i][j] = 0;
        }
    }

    // 计算矩阵自乘
    time_t start = time(NULL);
    for (i = 0; i < M; i++)
    {
        for (j = 0; j < M; j++)
        {
            produce(i, j);
        }
    }
    time_t end = time(NULL);
    double diff = difftime(end, start);

    // 打印运行时间
    printf("Time taken: %.2f seconds\n", diff);

    return 0;
}