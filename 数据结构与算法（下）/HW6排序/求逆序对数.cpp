#include <iostream>
#include <vector>
using namespace std;

// 归并过程中统计逆序对
//该函数是归并排序的核心合并步骤。它负责将两个已经排序好的子序列（`arr[left...mid]` 和 `arr[mid+1...right]`）合并成一个有序序列，并存放在临时数组 `temp` 中。
//在合并过程中，当发现左子序列的元素 `arr[i]` 大于右子序列的元素 `arr[j]` 时（即 `arr[i] > arr[j]`），表明找到了逆序对。由于左子序列 `arr[left...mid]` 自身已经有序，此时 `arr[i]` 到 `arr[mid]` 之间的所有元素都比 `arr[j]` 大，因此可以一次性计算出 `mid - i + 1` 个逆序对，并将这个数量累加到逆序对总数 `inversions` 中。这是本算法高效计算逆序对的关键。
//返回值: 本次合并过程中发现的跨越两个子序列的逆序对数量。
long long merge(vector<int>& arr, vector<int>& temp, int left, int mid, int right) {
    int i = left;    // 左半部分起始位置
    int j = mid + 1; // 右半部分起始位置
    int k = left;    // 临时数组起始位置
    long long inversions = 0; // 逆序对计数
    
    while (i <= mid && j <= right) {
        if (arr[i] <= arr[j]) {
            // 没有逆序对
            temp[k++] = arr[i++];
        } else {
            // 形成逆序对，左边元素大于右边元素
            // 因为左半部分已排序，所以从i到mid的所有元素都会与arr[j]形成逆序对
            inversions += (mid - i + 1);
            temp[k++] = arr[j++];
        }
    }
    
    // 处理剩余元素
    while (i <= mid) {
        temp[k++] = arr[i++];
    }
    
    while (j <= right) {
        temp[k++] = arr[j++];
    }
    
    // 将临时数组中已排序的部分复制回原数组
    for (i = left; i <= right; i++) {
        arr[i] = temp[i];
    }
    
    return inversions;
}

// 归并排序统计逆序对
//返回值指定范围[left, right]内的总逆序对数量。
long long mergeSort(vector<int>& arr, vector<int>& temp, int left, int right) {
    long long inversions = 0;
    if (left < right) {
        int mid = left + (right - left) / 2;
        
        // 计算左半部分的逆序对
        inversions += mergeSort(arr, temp, left, mid);
        // 计算右半部分的逆序对
        inversions += mergeSort(arr, temp, mid + 1, right);
        // 计算跨越左右两部分的逆序对
        inversions += merge(arr, temp, left, mid, right);
    }
    return inversions;
}

// 计算逆序对的入口函数
long long countInversions(vector<int>& arr) {
    int n = arr.size();
    //合并子序列时临时存放排好序的元素，以避免在原数组上直接操作造成的干扰
    vector<int> temp(n);
    return mergeSort(arr, temp, 0, n - 1);
}

int main() {
    int n;
    // 处理多组测试数据
    while (cin >> n) {
        // n为0时结束程序
        if (n == 0) {
            break;
        }
        //存储输入的整数序列
        vector<int> arr(n);
        for (int i = 0; i < n; i++) {
            cin >> arr[i];
        }
        
        long long inversions = countInversions(arr);
        
        cout << inversions << endl;
    }
    
    return 0;
}
