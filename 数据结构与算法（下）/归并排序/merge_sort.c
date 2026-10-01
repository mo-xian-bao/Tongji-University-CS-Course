#include <stdio.h>
#include <stdlib.h>

// 合并两个已排序的子数组
void merge(int arr[], int left, int mid, int right)
{
    int i, j, k;
    int n1 = mid - left + 1; // 左子数组的长度
    int n2 = right - mid;    // 右子数组的长度

    // 创建临时数组
    int *L = (int *)malloc(n1 * sizeof(int));
    int *R = (int *)malloc(n2 * sizeof(int));

    // 将数据复制到临时数组 L[] 和 R[]
    for (i = 0; i < n1; i++)
        L[i] = arr[left + i];
    for (j = 0; j < n2; j++)
        R[j] = arr[mid + 1 + j];

    // 合并临时数组回到 arr[left..right]
    i = 0;    // 左子数组的索引
    j = 0;    // 右子数组的索引
    k = left; // 合并后数组的索引

    while (i < n1 && j < n2)
    {
        if (L[i] <= R[j])
        {
            arr[k] = L[i];
            i++;
        }
        else
        {
            arr[k] = R[j];
            j++;
        }
        k++;
    }

    // 复制 L[] 中剩余的元素
    while (i < n1)
    {
        arr[k] = L[i];
        i++;
        k++;
    }

    // 复制 R[] 中剩余的元素
    while (j < n2)
    {
        arr[k] = R[j];
        j++;
        k++;
    }

    // 释放临时数组的内存
    free(L);
    free(R);
}

// 归并排序主函数
void mergeSort(int arr[], int left, int right)
{
    if (left < right)
    {
        // 避免溢出，等同于 (left+right)/2
        int mid = left + (right - left) / 2;

        // 递归地对两半进行排序
        mergeSort(arr, left, mid);
        mergeSort(arr, mid + 1, right);

        // 合并已排序的两半
        merge(arr, left, mid, right);
    }
}

// 测试归并排序算法
int main()
{
    int arr[] = {12, 11, 13, 5, 6, 7};
    int arr_size = sizeof(arr) / sizeof(arr[0]);

    printf("原始数组: ");
    for (int i = 0; i < arr_size; i++)
        printf("%d ", arr[i]);
    printf("\n");

    mergeSort(arr, 0, arr_size - 1);

    printf("排序后数组: ");
    for (int i = 0; i < arr_size; i++)
        printf("%d ", arr[i]);
    printf("\n");

    return 0;
}