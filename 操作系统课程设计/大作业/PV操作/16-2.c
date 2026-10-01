semaphore bridge = 1; // 独木桥的互斥信号量,初值为 1 表示桥当前没有被占用

/*
 * 一次只能允许一只小羊通过独木桥。
 * 无论是小黑羊还是小白羊,过桥前都必须先申请 bridge。
 * bridge 同一时刻只能被一只小羊占用,因此可以保证桥上不会出现两只羊。
 */

/* 小黑羊：从河东到河西 */
Process BlackSheep()
{
    P(bridge); // 申请独木桥,如果桥上已有小羊则等待

    cross_bridge(); // 黑羊从东向西过桥

    V(bridge); // 离开独木桥,允许其他小羊过桥
}

/* 小白羊：从河西到河东 */
Process WhiteSheep()
{
    P(bridge); // 申请独木桥,如果桥上已有小羊则等待

    cross_bridge(); // 白羊从西向东过桥

    V(bridge); // 离开独木桥,允许其他小羊过桥
}
