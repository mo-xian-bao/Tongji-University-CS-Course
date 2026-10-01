#include <cstring>
#include <iostream>

using namespace std;

struct queue {  // 广搜队列
    int front, rear, size;
    int* arr;  // 队列数组

    queue(int n) {  // 构造函数
        arr = new int[n];
        front = 0;
        rear = -1;
        size = n;
    }

    ~queue() {  // 析构函数
        delete[] arr;
    }

    bool isEmpty() { return front > rear; }  // 判断队列是否为空

    void enqueue(int item) {  // 入队操作
        if (rear == size - 1) {
            int* new_arr = new int[size * 2];  // 扩大队列容量
            for (int i = 0; i < size; i++) {
                new_arr[i] = arr[i];
            }
            delete[] arr;
            arr = new_arr;
            size *= 2;
        }
        rear++;
        arr[rear] = item;  // 将元素添加到队列
    }

    int dequeue() {  // 出队操作
        if (isEmpty()) {
            cout << "Queue is empty!" << endl;
            return -1;
        }
        int item = arr[front];
        front++;      // 移动队头指针
        return item;  // 返回出队的元素
    }
};

class Solution {  // 解决方案类
   public:
    Solution() {}  // 默认构造函数

   private:
    void bfs(queue& q, bool* map, int row, int col,
             int loc) {  // 广度优先搜索方法
        q.enqueue(loc);
        map[loc] = false;

        while (!q.isEmpty()) {  // 广搜队列非空时循环
            int current = q.dequeue();
            int current_x = current / col,
                current_y = current % col;              // 计算坐标
            if (current_x > 0 && map[current - col]) {  // 上
                q.enqueue(current - col);
                map[current - col] = false;
            }
            if (current_x < row - 1 && map[current + col]) {  // 下
                q.enqueue(current + col);
                map[current + col] = false;
            }
            if (current_y > 0 && map[current - 1]) {  // 左
                q.enqueue(current - 1);
                map[current - 1] = false;
            }
            if (current_y < col - 1 && map[current + 1]) {  // 右
                q.enqueue(current + 1);
                map[current + 1] = false;
            }
        }
    }

   public:
    int solution(bool* map, int row, int col) {  // 计算解决方案的主方法
        int res = 0;
        queue q(10);  // 广搜队列
        for (int i = 0; i < row * col; i++) {
            if (i / col == 0 || i / col == row - 1 || i % col == 0 ||
                i % col == col - 1) {  // 边界不搜索
                continue;
            } else {
                if (map[i]) {
                    bfs(q, map, row, col, i);
                    res++;
                }
            }
        }
        return res;  // 返回结果
    }
};

int main() {
    int row, col;
    cin >> row >> col;

    bool* map = new bool[row * col];
    Solution s;

    for (int i = 0; i < row * col; i++) cin >> map[i];

    cout << s.solution(map, row, col) << endl;

    delete[] map;
    return 0;
}