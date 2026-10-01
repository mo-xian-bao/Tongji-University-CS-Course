semaphore bridge = 1; // 独木桥的互斥信号量，控制桥的通行方向,初值为 1 表示桥当前没有被占用
semaphore mutexB = 1; // 保护 black 变量的互斥信号量,防止多个黑羊进程同时修改 black
semaphore mutexW = 1; // 保护 white 变量的互斥信号量,防止多个白羊进程同时修改 white

int black = 0;
int white = 0;

/* 小黑羊：从河东到河西 */
Process BlackSheep()
{
    P(mutexB); // 进入黑羊计数临界区，准备修改 black

    black++; // 当前黑羊加入过桥队伍

    if (black == 1)
    {
        // 第一只黑羊负责申请独木桥
        // 如果桥上已有白羊，则在这里等待
        P(bridge);
    }

    V(mutexB); // 离开黑羊计数临界区，允许其他黑羊修改 black

    cross_bridge(); // 黑羊从东向西过桥；多个黑羊可以同方向同时过桥

    P(mutexB); // 重新进入黑羊计数临界区，准备修改 black

    black--; // 当前黑羊已经离开独木桥

    if (black == 0)
    {
        // 最后一只黑羊离开后释放独木桥
        // 这样白羊才可以申请 bridge 并从反方向过桥
        V(bridge);
    }

    V(mutexB); // 离开黑羊计数临界区
}

/* 小白羊：从河西到河东 */
Process WhiteSheep()
{
    P(mutexW); // 进入白羊计数临界区，准备修改 white

    white++; // 当前白羊加入过桥队伍

    if (white == 1)
    {
        // 第一只白羊负责申请独木桥
        // 如果桥上已有黑羊，则在这里等待
        P(bridge);
    }

    V(mutexW); // 离开白羊计数临界区，允许其他白羊修改 white

    cross_bridge(); // 白羊从西向东过桥；多个白羊可以同方向同时过桥

    P(mutexW); // 重新进入白羊计数临界区，准备修改 white

    white--; // 当前白羊已经离开独木桥

    if (white == 0)
    {
        // 最后一只白羊离开后释放独木桥
        // 这样黑羊才可以申请 bridge 并从反方向过桥
        V(bridge);
    }

    V(mutexW); // 离开白羊计数临界区
}