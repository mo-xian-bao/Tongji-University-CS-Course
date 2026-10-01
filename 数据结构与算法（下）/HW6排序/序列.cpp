#include <iostream>
#include <queue>
#define MAXN 2025

using namespace std;

/*通过两层循环遍历 `sum` 数组和 `new_line` 数组的所有元素对的和。
利用 std::priority_queue<int>（大顶堆）来维护当前找到的 n 个最小的和。
对于每个新计算出的和 `new_sum`，如果堆的大小小于 n，直接将其推入堆；
如果堆已满，则仅当 `new_sum` 小于堆顶元素（当前最大的n个和中的最大值）时，才弹出堆顶元素并将 `new_sum` 推入。
最后，将堆中的 n 个元素（即新的前 n 小和）按降序（因为是大顶堆）取出并反向存入 `sum` 数组，使其保持升序。*/
void update_sum(int* sum, int* new_line, int n)
{
    priority_queue<int> q; // 大根堆

    for (int j = 0; j < n; ++j){
        for (int i = 0; i < n; ++i){
            
            int new_sum = sum[i] + new_line[j];

            if (q.size() < n) 
                q.push(new_sum);
            else if (new_sum < q.top()){
                q.pop();  // 替换最大元素
                q.push(new_sum); 
            }
            else  //因为两个序列均有序 若当前已经超过，则之后均不会再更新
                break;
        }
    }
    for (int i = n - 1; i >= 0; i--){
        sum[i] = q.top();
        q.pop();
    }
}

//快速排序,平均时间复杂度O(nlogn)
void quick_sort(int* arr, int left, int right)
{
    if (left >= right)
        return;

    int i = left, j = right, pivot = arr[left];  //选择最左元素为基准

    while (i < j){
        while (i < j && arr[j] >= pivot)
            j--;
        if (i < j)
            arr[i++] = arr[j];

        while (i < j && arr[i] < pivot)
            i++;
        if (i < j)
            arr[j--] = arr[i];
    }
    arr[i] = pivot;
    //递归
    quick_sort(arr, left, i - 1);
    quick_sort(arr, i + 1, right);
}

int main()
{
    //T组测试数据
    //m行n列
    int T, m, n;

    //sum通过不断更新累加保持个数为n个 即输入i行之后，前i行各出一个元素的前n小和数组
    //当输入完m行后，sum即为前m行各出一个元素的前n小和数组，即为最终答案
    //有点局部最优解的思想？
    int sum[MAXN];
    //new_line代表新输入的一行
    int new_line[MAXN];

    cin >> T;

    while (T>0){
        cin >> m >> n;

        for (int i = 0; i < n; i++)
            cin >> sum[i];

        //快排约O(nlogn)时间复杂度
        quick_sort(sum, 0, n - 1);  //对第一行进行排序

        for (int i = 1; i < m; i++){
            for (int j = 0; j < n; j++)
                cin >> new_line[j];
            quick_sort(new_line, 0, n - 1);  //对新输入的一行进行排序
            update_sum(sum, new_line, n);  //更新前i行各出一个元素的前n小和数组
        }

        //输出结果
        for (int i = 0; i < n; ++i)
            cout << sum[i] << " ";
        cout << endl;

        T--;
    }

    return 0;
}