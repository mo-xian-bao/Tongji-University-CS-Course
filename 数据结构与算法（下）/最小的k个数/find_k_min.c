#include <stdio.h>
#include <stdlib.h>

// 交换两个整数
void swap(int *a, int *b)
{
    int temp = *a;
    *a = *b;
    *b = temp;
}

// 分区函数，返回pivot元素的最终位置
int partition(int arr[], int left, int right)
{
    // 选择最右元素作为pivot
    int pivot = arr[right];
    int i = left - 1;

    for (int j = left; j < right; j++)
    {
        if (arr[j] <= pivot)
        {
            i++;
            swap(&arr[i], &arr[j]);
        }
    }

    swap(&arr[i + 1], &arr[right]);
    return i + 1;
}

// 随机选择一个元素作为pivot，以减少最坏情况的概率
int randomPartition(int arr[], int left, int right)
{
    int random = left + rand() % (right - left + 1);
    swap(&arr[random], &arr[right]);
    return partition(arr, left, right);
}

// 快速选择算法，找到数组中第k小的元素
int quickSelect(int arr[], int left, int right, int k)
{
    if (left == right)
    {
        return arr[left];
    }

    int pivotIndex = randomPartition(arr, left, right);
    int count = pivotIndex - left + 1; // pivot是第count小的元素

    if (count == k)
    {
        return arr[pivotIndex];
    }
    else if (count > k)
    {
        return quickSelect(arr, left, pivotIndex - 1, k);
    }
    else
    {
        return quickSelect(arr, pivotIndex + 1, right, k - count);
    }
}

// 找出数组中最小的k个数
void getLeastNumbers(int arr[], int n, int k, int result[])
{
    if (k <= 0 || n <= 0)
    {
        return;
    }

    if (k >= n)
    {
        for (int i = 0; i < n; i++)
        {
            result[i] = arr[i];
        }
        return;
    }

    // 找到第k小的元素
    int kthSmallest = quickSelect(arr, 0, n - 1, k);

    // 收集所有小于kthSmallest的元素
    int count = 0;
    for (int i = 0; i < n && count < k; i++)
    {
        if (arr[i] < kthSmallest)
        {
            result[count++] = arr[i];
        }
    }

    // 如果收集的元素不足k个，则添加等于kthSmallest的元素
    for (int i = 0; i < n && count < k; i++)
    {
        if (arr[i] == kthSmallest)
        {
            result[count++] = arr[i];
        }
    }
}

int main()
{
    int arr[] = {4, 5, 1, 6, 2, 7, 3, 8};
    int n = sizeof(arr) / sizeof(arr[0]);
    int k = 4;
    int result[k];

    getLeastNumbers(arr, n, k, result);

    printf("最小的%d个数是: ", k);
    for (int i = 0; i < k; i++)
    {
        printf("%d ", result[i]);
    }
    printf("\n");

    return 0;
}