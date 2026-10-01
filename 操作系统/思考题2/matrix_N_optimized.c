#include <stdio.h>
#include <stdlib.h>
#include <time.h>      // 用于计时
#include <unistd.h>    // 用于 fork() 和 exit()
#include <sys/wait.h>  // 用于 wait()
#include <sys/types.h> // 用于 pid_t

#define M 1024
#define NUM_PROCESSES 4
// --------------------

// 全局变量 (父子进程各有独立的副本)
int version = 1;
int matrixOriginal[M][M];
int matrixDes[M][M];

// 通用矩阵计算函数 (缓存优化版)
void calculate_chunk(int rank, int num_procs)
{
    // 循环变量提前声明，兼容 C89
    int i, j, k;

    // 每个进程计算的行数
    int rows_per_proc = M / num_procs;
    // 计算起始行和结束行 (不包含 to)
    int from = rank * rows_per_proc;
    int to = (rank == num_procs - 1) ? M : (rank + 1) * rows_per_proc;

    printf("[PID: %d | Rank: %d] Calculating rows %d to %d (Cache Optimized)...\n", getpid(), rank, from, to - 1);

    // ******************************************************
    // *** 核心优化部分：循环重排为 i-k-j 顺序 ***
    // ******************************************************

    // 1. i 循环 (进程分工的行块)
    for (i = from; i < to; i++)
    {
        // 2. k 循环 (乘法的中间项)
        for (k = 0; k < M; k++)
        {
            // 3. j 循环 (最内层循环，确保按行访问)
            for (j = 0; j < M; j++)
            {
                // 核心计算：matrixDes[i][j] += matrixOriginal[i][k] * matrixOriginal[k][j]
                // 确保 matrixOriginal[k][j] 和 matrixDes[i][j] 都是连续访问，提高缓存命中率
                matrixDes[i][j] += matrixOriginal[i][k] * matrixOriginal[k][j];
            }
        }
    }

    // ******************************************************

    // 输出该进程计算的第一个元素
    printf("[PID: %d | Rank: %d] Finished calculation. matrixDes[%d][0] = %d\n", getpid(), rank, from, matrixDes[from][0]);
}

int main()
{
    // 循环变量提前声明
    int i, j;

    // 用于计时
    clock_t start_time, end_time;
    double cpu_time_used;

    // 父进程的起始行，用于末尾的 printf 验证
    int parent_from_row;

    // 检查 M 是否能被进程数整除
    if (M % NUM_PROCESSES != 0)
    {
        fprintf(stderr, "Error: M (%d) must be divisible by NUM_PROCESSES (%d)\n", M, NUM_PROCESSES);
        return 1;
    }

    // 1. 初始化矩阵 (在 fork() 前进行)
    for (i = 0; i < M; i++)
    {
        for (j = 0; j < M; j++)
        {
            matrixOriginal[i][j] = 1;
            matrixDes[i][j] = 0;
        }
    }
    printf("Matrices initialized. Starting %d parallel calculations (M=%d)...\n", NUM_PROCESSES, M);

    // 多进程相关变量
    pid_t pids[NUM_PROCESSES - 1]; // 存储子进程ID
    int rank;

    // 2. 开始计时 (在创建第一个子进程前开始)
    start_time = clock();

    // 3. 创建 NUM_PROCESSES - 1 个子进程
    for (i = 0; i < NUM_PROCESSES - 1; i++)
    {
        pid_t child_pid = fork();

        if (child_pid < 0)
        {
            perror("fork failed");
            return 1;
        }

        if (child_pid == 0)
        {
            // 子进程逻辑：rank 从 0 开始
            rank = i;
            calculate_chunk(rank, NUM_PROCESSES);
            exit(0); // 子进程完成任务后必须退出
        }
        pids[i] = child_pid; // 父进程保存子进程ID
        // 父进程会继续循环创建下一个子进程
    }

    // 4. 父进程逻辑
    // 父进程计算最后一块数据，rank = NUM_PROCESSES - 1
    rank = NUM_PROCESSES - 1;
    // 在 main 中记录父进程的起始行
    parent_from_row = rank * (M / NUM_PROCESSES);

    calculate_chunk(rank, NUM_PROCESSES);

    // 5. 父进程等待所有子进程完成
    for (i = 0; i < NUM_PROCESSES - 1; i++)
    {
        waitpid(pids[i], NULL, 0);
    }
    printf("[Parent PID: %d] All child processes terminated. All calculation done.\n", getpid());

    // 6. 结束计时 (父进程在所有子进程 wait() 之后)
    end_time = clock();
    cpu_time_used = ((double)(end_time - start_time)) / CLOCKS_PER_SEC;

    // 7. 输出结果和时间
    printf("\nTotal calculation time (CACHE OPTIMIZED) with %d processes: %f seconds\n", NUM_PROCESSES, cpu_time_used);
    // 验证结果 (结果应为 M=1024)
    printf("Verification check: matrixDes[%d][0] (Parent's part) = %d\n", parent_from_row, matrixDes[parent_from_row][0]);

    return 0;
}