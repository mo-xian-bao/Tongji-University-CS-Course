semaphore mutex = 1;
semaphore barrier = 0;

int count = 0;
const int N = 4;

/*
 * P1、P2、P3、P4 都必须先完成第一阶段任务。
 * 只有当四个进程全部到达同步点后，才允许它们一起进入第二阶段。
 *
 * mutex 用来互斥访问 count，防止多个进程同时修改 count。
 * barrier 初值为 0，用来阻塞先到达同步点的进程。
 * count 记录已经完成第一阶段并到达栅栏的进程数量。
 */
Process Pi()
{
    // 第 i 个进程执行自己的第一阶段计算任务
    first_stage_task(i);

    // 修改共享变量 count 前必须先进入临界区
    P(mutex);

    // 当前进程已经完成第一阶段，到达栅栏
    count++;

    // 如果当前进程是最后一个到达栅栏的进程，
    // 则释放 N 次 barrier，让四个进程都能通过栅栏
    if (count == N)
    {
        for (int k = 0; k < N; k++)
        {
            V(barrier);
        }
    }

    // count 修改结束，退出临界区
    V(mutex);

    // 所有不是最后到达的进程都会在这里阻塞
    // 只有最后一个进程到达并执行 N 次 V(barrier) 后，大家才能继续
    P(barrier);

    // 四个进程都通过栅栏后，进入第二阶段计算任务
    second_stage_task(i);
}
