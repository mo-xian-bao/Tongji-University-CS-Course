semaphore A = 1;
semaphore B = 1;
semaphore C = 1;
semaphore D = 1;

/*
 * A、B、C、D 分别表示十字路口中的四个互斥区域。
 * 每个区域同一时刻最多只能有一辆车占用，因此每个区域设置一个二元信号量。
 *
 * 为避免死锁，所有车辆申请资源时都必须遵守统一顺序：
 * A < B < C < D
 */

/* 北 -> 南：需要 A、C，按 A < C 申请 */
Process NS()
{
    P(A);
    P(C);

    cross();

    V(C);
    V(A);
}

/* 南 -> 北：需要 B、D，按 B < D 申请 */
Process SN()
{
    P(B);
    P(D);

    cross();

    V(D);
    V(B);
}

/* 西 -> 东：需要 C、D，按 C < D 申请 */
Process WE()
{
    P(C);
    P(D);

    cross();

    V(D);
    V(C);
}

/* 东 -> 西：需要 A、B，按 A < B 申请 */
Process EW()
{
    P(A);
    P(B);

    cross();

    V(B);
    V(A);
}
