semaphore mutex = 1;

int freeSeat = 5;
bool copierBusy = false;

queue<semaphore> waitQueue;

void customer()
{
    semaphore self = 0; // 当前顾客自己的私有信号量

    P(mutex);

    if (copierBusy == false)
    {
        // 复印机空闲，顾客直接使用复印机
        copierBusy = true;
        V(mutex);

        copy(); // 使用复印机

        P(mutex);
        if (!waitQueue.empty())
        {
            semaphore next = waitQueue.front();
            waitQueue.pop();

            // 唤醒队首顾客，复印机使用权交给他
            V(next);
        }
        else
        {
            copierBusy = false;
        }
        V(mutex);
    }

    else
    {
        // 复印机正在被使用
        if (freeSeat > 0)
        {
            // 有空椅子，顾客坐下等待
            freeSeat--;
            waitQueue.push(self);
            V(mutex);

            P(self); // 等待被前一个顾客唤醒

            // 被唤醒后，说明轮到自己使用复印机
            P(mutex);
            freeSeat++; // 离开等待椅
            V(mutex);

            copy(); // 使用复印机

            P(mutex);
            if (!waitQueue.empty())
            {
                semaphore next = waitQueue.front();
                waitQueue.pop();

                // 唤醒下一个等待顾客
                V(next);
            }
            else
            {
                copierBusy = false;
            }
            V(mutex);
        }

        else
        {
            // 没有空椅子，顾客离开
            V(mutex);
            leave();
        }
    }
}