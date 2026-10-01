// 互斥信号量，用于保护 A、B、C、D 四个状态变量
semaphore mutex = 1;

// 等待队列信号量，车辆条件不满足时在这里阻塞
semaphore wait = 0;

// 当前等待车辆数量
int waiting = 0;

// A、B、C、D 表示四个路口区域是否空闲
// 1 表示空闲，0 表示被占用
int A = 1;
int B = 1;
int C = 1;
int D = 1;

// 申请两个路口区域
Apply(ref x, ref y)
{
    while (true)
    {
        P(mutex);

        // 如果两个需要的区域都空闲，则一次性占用它们
        if (x == 1 && y == 1)
        {
            x = 0;
            y = 0;

            V(mutex);
            return;
        }

        // 如果条件不满足，记录当前车辆需要等待
        waiting = waiting + 1;

        V(mutex);

        // 当前车辆阻塞，等待其他车辆释放路口区域后被唤醒
        P(wait);

        // 被唤醒后不能直接进入路口
        // 因为可能有多个车辆同时被唤醒，所以必须重新检查条件
    }
}

// 释放两个路口区域
Release(ref x, ref y)
{
    P(mutex);

    // 当前车辆已经通过路口，释放占用的两个区域
    x = 1;
    y = 1;

    // 唤醒所有等待车辆，让它们重新竞争并检查条件
    // 采用广播式唤醒，简单且不会漏掉可能满足条件的车辆
    while (waiting > 0)
    {
        waiting = waiting - 1;
        V(wait);
    }

    V(mutex);
}

// 北向南车辆：靠右行驶，占用 A、C
Process NS()
{
    Apply(A, C);
    cross();
    Release(A, C);
}

// 南向北车辆：靠右行驶，占用 B、D
Process SN()
{
    Apply(B, D);
    cross();
    Release(B, D);
}

// 西向东车辆：靠右行驶，占用 C、D
Process WE()
{
    Apply(C, D);
    cross();
    Release(C, D);
}

// 东向西车辆：靠右行驶，占用 A、B
Process EW()
{
    Apply(A, B);
    cross();
    Release(A, B);
}