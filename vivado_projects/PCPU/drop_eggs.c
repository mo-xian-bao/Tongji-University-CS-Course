#include <stdio.h>

#define TOTAL_FLOORS 100
#define SECRET_THRESHOLD 37

int main()
{
    int low = 0, high = TOTAL_FLOORS;
    int current_floor = 0;
    int m_up = 0, n_down = 0, h_broken = 0, drops = 0;
    int last_drop_broken = -1;

    printf("开始测试：比萨塔层数：%d, 目标耐摔值: %d\n\n", TOTAL_FLOORS, SECRET_THRESHOLD);

    while (low <= high)
    {
        if (low == 0 && high == 0)
            break;
        int mid = (low + high + 1) / 2;
        drops++;

        // 计算移动成本
        if (mid > current_floor)
            m_up += (mid - current_floor);
        else
            n_down += (current_floor - mid);
        current_floor = mid;

        // --- 测试并记录最后状态 ---
        if (current_floor > SECRET_THRESHOLD)
        {
            h_broken++;
            high = mid - 1;
            last_drop_broken = 1; // 记录：这次破了
            printf("第 %d 次摔鸡蛋: 摔在第 %d 层 -> 【破了】\n", drops, current_floor);
        }
        else
        {
            low = mid + 1;
            last_drop_broken = 0; // 记录：这次没破
            printf("第 %d 次摔鸡蛋: 摔在第 %d 层 -> 【没破】\n", drops, current_floor);
        }
    }

    printf("测试结束。测得耐摔值: %d\n", high);

    // 输出最后一次的状态
    if (last_drop_broken == 1)
    {
        printf("最后一次摔的鸡蛋：【破了】\n");
    }
    else
    {
        printf("最后一次摔的鸡蛋：【没破】\n");
    }

    printf("统计 -> 上楼: %d, 下楼: %d, 破蛋总数: %d\n\n", m_up, n_down, h_broken);

    int f1 = m_up * 2 + n_down * 1 + h_broken * 4;
    int f2 = m_up * 4 + n_down * 1 + h_broken * 2;
    printf("资源匮乏时期总成本    : %d\n", f1);
    printf("人力资源增长时期总成本: %d\n", f2);

    return 0;
}