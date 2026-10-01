#include <iostream>
#include <queue>
#define MAXN 2025

using namespace std;

void update_sum(int* ans, int* new_arr, int n)
{
    priority_queue<int> q; // 大根堆

    for (int j = 0; j < n; ++j){
        for (int i = 0; i < n; ++i){
            
            int sum = ans[i] + new_arr[j];

            if (q.size() < n) 
                q.push(sum);
            else if (sum < q.top()){
                q.pop();  // 替换最大元素
                q.push(sum); 
            }
            else  //因为两个序列均有序 若当前已经超过，则之后均不会再更新
                break;
        }
    }
    for (int i = n - 1; i >= 0; i--){
        ans[i] = q.top();
        q.pop();
    }
}

//快速排序
void quick_sort(int* arr, int left, int right)
{
    if (left >= right)
        return;

    int i = left, j = right, pivot = arr[left];

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
    quick_sort(arr, left, i - 1);
    quick_sort(arr, i + 1, right);
}

int main()
{
    int T, m, n;
    //T组测试数据
    //m行n列

    //ans通过不断更新累加保持个数为n个 即输入i行之后，前i行各出一个元素的前n小和数组
    //有点局部最优解的思想？
    int ans[MAXN];
    //new_arr代表新输入的一行
    int new_arr[MAXN];

    cin >> T;

    while (T>0){
        cin >> m >> n;

        for (int i = 0; i < n; i++)
            cin >> ans[i];

        //快排约O(nlogn)时间复杂度
        quick_sort(ans, 0, n - 1);  //对第一行进行排序

        for (int i = 1; i < m; i++){
            for (int j = 0; j < n; j++)
                cin >> new_arr[j];
            quick_sort(new_arr, 0, n - 1);  //对新输入的一行进行排序
            update_sum(ans, new_arr, n);  //更新前i行各出一个元素的前n小和数组
        }

        //输出结果
        for (int i = 0; i < n; ++i)
            cout << ans[i] << " ";
        cout << endl;

        T--;
    }

    return 0;
}