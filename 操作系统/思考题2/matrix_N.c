#include <stdio.h>
#include <stdlib.h>
#include <time.h>      // 用于计时
#include <unistd.h>    // 用于 fork() 和 exit()
#include <sys/wait.h>  // 用于 wait()
#include <sys/types.h> // 用于 pid_t

#define M 1024
#define NUM_PROCESSES 1024
// --------------------

// 全局变量 (父子进程各有独立的副本)
int version = 1;
int matrixOriginal[M][M];
int matrixDes[M][M];

// 矩阵乘法核心函数
void produce(int row, int column)
{
    int i;
    for (i = 0; i < M; i++)
    {
        matrixDes[row][column] += matrixOriginal[row][i] * matrixOriginal[i][column];
    }
}

// 通用矩阵计算函数
void calculate_chunk(int rank, int num_procs)
{
    int i, j;
    // 每个进程计算的行数
    int rows_per_proc = M / num_procs;
    // 计算起始行和结束行 (不包含 to)
    int from = rank * rows_per_proc;
    int to = (rank == num_procs - 1) ? M : (rank + 1) * rows_per_proc;

    printf("[PID: %d | Rank: %d] Calculating rows %d to %d...\n", getpid(), rank, from, to - 1);

    for (i = from; i < to; i++)
    {
        for (j = 0; j < M; j++)
        {
            produce(i, j);
        }
    }

    // 输出该进程计算的第一个元素
    printf("[PID: %d | Rank: %d] Finished calculation. matrixDes[%d][0] = %d\n", getpid(), rank, from, matrixDes[from][0]);
}

int main()
{
    int i, j;
    int parent_from_row;

    // 用于计时
    clock_t start_time, end_time;
    double cpu_time_used;

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
        pids[i] = fork();

        if (pids[i] < 0)
        {
            perror("fork failed");
            return 1;
        }

        if (pids[i] == 0)
        {
            // 子进程逻辑：rank 从 0 开始
            rank = i;
            calculate_chunk(rank, NUM_PROCESSES);
            exit(0); // 子进程完成任务后必须退出
        }
        // 父进程会继续循环创建下一个子进程
    }

    // 4. 父进程逻辑
    // 父进程计算最后一块数据，rank = NUM_PROCESSES - 1
    rank = NUM_PROCESSES - 1;
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
    printf("\nTotal calculation time with %d processes: %f seconds\n", NUM_PROCESSES, cpu_time_used);
    // 输出父进程计算的第一行元素，以确认计算正确性 (结果应为 M=1024)
    printf("Verification check: matrixDes[%d][0] (Parent's part) = %d\n", parent_from_row, matrixDes[parent_from_row][0]);

    return 0;
}