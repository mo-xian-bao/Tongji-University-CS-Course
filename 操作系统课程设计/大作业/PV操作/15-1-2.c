// 互斥信号量，用于保护 A、B、C、D 四个状态变量以及取号变量
semaphore mutex = 1;

// 等待队列信号量，车辆条件不满足时在这里阻塞
semaphore wait = 0;

// 当前等待车辆数量
int waiting = 0;

// nextTicket 表示下一辆到达车辆应取得的号码
// serving 表示当前允许检查并申请资源的号码
int nextTicket = 0;
int serving = 0;

// A、B、C、D 表示四个路口区域是否空闲
// 1 表示空闲，0 表示被占用
int A = 1;
int B = 1;
int C = 1;
int D = 1;

// 唤醒所有等待车辆，让它们重新检查票号和资源条件
WakeAll()
{
    while (waiting > 0)
    {
        waiting = waiting - 1;
        V(wait);
    }
}

// 申请两个路口区域
Apply(ref x, ref y)
{
    P(mutex);

    // 当前车辆到达后先取号
    // 只有号码等于 serving 的车辆才有资格申请资源
    int myTicket = nextTicket;
    nextTicket = nextTicket + 1;

    while (true)
    {
        // 只有轮到当前车辆,并且两个需要的区域都空闲时,才允许一次性占用它们
        if (myTicket == serving && x == 1 && y == 1)
        {
            x = 0;
            y = 0;

            // 当前号码已经获得通行机会,允许下一张号码继续检查
            serving = serving + 1;

            // 可能有后续车辆与当前车辆不冲突,因此唤醒它们重新检查
            WakeAll();

            V(mutex);
            return;
        }

        // 条件不满足时,当前车辆进入等待队列
        waiting = waiting + 1;

        V(mutex);

        // 当前车辆阻塞,等待资源释放或前面的号码获得通行机会后被唤醒
        P(wait);

        // 被唤醒后必须重新进入临界区检查条件
        P(mutex);
    }
}

// 释放两个路口区域
Release(ref x, ref y)
{
    P(mutex);

    // 当前车辆已经通过路口,释放占用的两个区域
    x = 1;
    y = 1;

    // 资源状态发生变化后,唤醒等待车辆重新检查
    WakeAll();

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
