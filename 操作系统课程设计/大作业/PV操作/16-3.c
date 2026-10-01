semaphore mutex = 1; // 保护 occupied、waitingBlack、waitingWhite 和 turn 的互斥信号量
semaphore blackQueue = 0; // 黑羊等待队列,条件不满足时黑羊在这里阻塞
semaphore whiteQueue = 0; // 白羊等待队列,条件不满足时白羊在这里阻塞

int occupied = 0; // 独木桥是否被占用,0 表示空闲,1 表示占用
int waitingBlack = 0; // 正在等待过桥的黑羊数量
int waitingWhite = 0; // 正在等待过桥的白羊数量
int turn = 0; // 公平控制变量,0 表示黑羊优先,1 表示白羊优先

/*
 * 一次只能允许一只小羊通过独木桥,并且要避免某一侧的小羊长期等待。
 *
 * 基本思想：
 * 1. occupied 保证桥上同一时刻最多只有一只小羊。
 * 2. waitingBlack 和 waitingWhite 记录两侧等待数量。
 * 3. turn 表示下一次在双方都有人等待时,应该优先放行哪一侧。
 * 4. 每只小羊离开后,如果对侧有小羊等待,就把 turn 交给对侧并唤醒一只对侧小羊。
 */

/* 小黑羊：从河东到河西 */
Process BlackSheep()
{
    P(mutex); // 进入临界区,准备检查和修改共享状态

    waitingBlack++; // 当前黑羊加入等待队列

    while (occupied == 1 || (turn == 1 && waitingWhite > 0))
    {
        // 如果桥被占用,或者当前应当让白羊优先,则黑羊等待
        V(mutex);
        P(blackQueue);
        P(mutex);
    }

    waitingBlack--; // 当前黑羊获得过桥机会,离开等待队列
    occupied = 1; // 占用独木桥

    V(mutex); // 离开临界区

    cross_bridge(); // 黑羊从东向西过桥

    P(mutex); // 重新进入临界区,准备释放独木桥

    occupied = 0; // 当前黑羊已经离开独木桥

    if (waitingWhite > 0)
    {
        // 如果有白羊等待,则下一次优先放行白羊,避免白羊饿死
        turn = 1;
        V(whiteQueue);
    }
    else if (waitingBlack > 0)
    {
        // 如果没有白羊等待,但还有黑羊等待,则继续放行黑羊
        turn = 0;
        V(blackQueue);
    }

    V(mutex); // 离开临界区
}

/* 小白羊：从河西到河东 */
Process WhiteSheep()
{
    P(mutex); // 进入临界区,准备检查和修改共享状态

    waitingWhite++; // 当前白羊加入等待队列

    while (occupied == 1 || (turn == 0 && waitingBlack > 0))
    {
        // 如果桥被占用,或者当前应当让黑羊优先,则白羊等待
        V(mutex);
        P(whiteQueue);
        P(mutex);
    }

    waitingWhite--; // 当前白羊获得过桥机会,离开等待队列
    occupied = 1; // 占用独木桥

    V(mutex); // 离开临界区

    cross_bridge(); // 白羊从西向东过桥

    P(mutex); // 重新进入临界区,准备释放独木桥

    occupied = 0; // 当前白羊已经离开独木桥

    if (waitingBlack > 0)
    {
        // 如果有黑羊等待,则下一次优先放行黑羊,避免黑羊饿死
        turn = 0;
        V(blackQueue);
    }
    else if (waitingWhite > 0)
    {
        // 如果没有黑羊等待,但还有白羊等待,则继续放行白羊
        turn = 1;
        V(whiteQueue);
    }

    V(mutex); // 离开临界区
}
