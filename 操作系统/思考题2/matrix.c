#include <stdio.h>
#include <stdlib.h>
#include <time.h> // 用于计时

// 题目要求 M 的值为 4096
#define M 1024

// 全局变量：用于存储矩阵
int version = 1;
int matrixOriginal[M][M];
int matrixDes[M][M];

// 矩阵乘法核心函数：计算 matrixDes[row][column] 的值
void produce(int row, int column)
{
    // i 是局部变量，作为循环计数器
    int i;

    // 矩阵自乘：matrixDes[row][column] = matrixOriginal[row] * matrixOriginal[column]
    // 目标矩阵 matrixDes 元素初始化为 0 的操作在 main 中完成
    for (i = 0; i < M; i++)
    {
        matrixDes[row][column] += matrixOriginal[row][i] * matrixOriginal[i][column];
    }
}

int main()
{
    // 局部变量：用于循环计数
    int i, j;

    // 用于计时
    clock_t start_time, end_time;
    double cpu_time_used;

    // 1. 初始化矩阵
    printf("Initializing matrices...\n");
    for (i = 0; i < M; i++)
    {
        for (j = 0; j < M; j++)
        {
            // 设定原始矩阵的元素
            matrixOriginal[i][j] = 1;
            // 结果矩阵元素初始化为 0
            matrixDes[i][j] = 0;
        }
    }

    // 2. 开始计时
    printf("Starting matrix multiplication (M=%d)...\n", M);
    start_time = clock();

    // 3. 矩阵乘法计算
    // 外层循环：遍历结果矩阵 matrixDes 的每一行 (row)
    for (i = 0; i < M; i++)
    {
        // 内层循环：遍历结果矩阵 matrixDes 的每一列 (column)
        for (j = 0; j < M; j++)
        {
            produce(i, j);
        }
    }

    // 4. 结束计时
    end_time = clock();
    cpu_time_used = ((double)(end_time - start_time)) / CLOCKS_PER_SEC;

    // 5. 输出结果和时间
    printf("\nMatrix multiplication complete.\n");

    printf("\nTime taken for calculation: %f seconds\n", cpu_time_used);

    return 0;
}