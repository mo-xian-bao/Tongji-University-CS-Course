/**
 * @file    template.cpp
 * @name    p57模板程序
 * @date    2022-11-22
*/

#include <iostream>
#include <algorithm>
#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <cmath>
#include <string>
#include <vector>
#include <queue>
#include <stack>
#include <map>
#include <set>
#include <functional> // 用于 std::function
#include <chrono>     // 用于计时
#include <iomanip>    // 用于 std::setw
#include <random>     // 用于生成数据

using namespace std;

/********************************/
/*     以下是你需要提交的代码     */
/********************************/
class Solution {

private:
    // --- 快速排序 --- 
    int partition(std::vector<int> &nums, int l, int r) {
        int pivot = nums[l];
        int i = l, j = r;
        while (i < j) {
            while (i < j && nums[j] >= pivot) j --; // 从右向左找第一个小于pivot的数
            if (i < j) nums[i ++] = nums[j];      // 放入左边
            while (i < j && nums[i] <= pivot) i ++; // 从左向右找第一个大于pivot的数
            if (i < j) nums[j --] = nums[i];      // 放入右边
        }
        nums[i] = pivot; // 基准元素归位
        return i;        // 返回基准元素最终位置
    }
    void quickSortRecursive(std::vector<int> &nums, int l, int r) {
        if (l >= r) return; // 递归终止条件
        int pivot = partition(nums, l, r); // 划分
        quickSortRecursive(nums, l, pivot - 1); // 递归排序左半部分
        quickSortRecursive(nums, pivot + 1, r); // 递归排序右半部分
    }

    // --- 改进的快速排序 --- 
    int partition_plus(std::vector<int> &nums, int l, int r) {
        // 随机选择基准元素
        int random_idx = l + rand() % (r - l + 1);
        std::swap(nums[l], nums[random_idx]);
        int pivot = nums[l];
        int i = l, j = r;
        while (i < j) {
            while (i < j && nums[j] >= pivot) j --;
            if (i < j) nums[i ++] = nums[j];
            while (i < j && nums[i] <= pivot) i ++;
            if (i < j) nums[j --] = nums[i];
        }
        nums[i] = pivot;
        return i;
    }
    void quickSort_plus(std::vector<int> &nums, int l, int r) {
        if (l >= r) return;
        // 小数组使用插入排序优化
        if (r - l <= 16) {
            for (int i = l + 1; i <= r; i++) {
                int key = nums[i];
                int j = i - 1;
                while (j >= l && nums[j] > key) {
                    nums[j + 1] = nums[j];
                    j--;
                }
                nums[j + 1] = key;
            }
            return;
        }
        int pivot = partition_plus(nums, l, r); // 使用带随机化的划分
        quickSortRecursive(nums, l, pivot - 1);
        quickSortRecursive(nums, pivot + 1, r);
    }
    
    // --- 归并排序 --- 
    void mergeSortRecursive(std::vector<int> &nums, int l, int r) {
        if (l >= r) return; // 递归终止条件
        int mid = l + (r - l) / 2; // 防止溢出
        mergeSortRecursive(nums, l, mid);       // 递归排序左半部分
        mergeSortRecursive(nums, mid + 1, r); // 递归排序右半部分
        
        // 合并两个有序子数组
        int i = l, j = mid + 1, k = 0;
        std::vector<int> tmp(r - l + 1); // 临时数组
        while (i <= mid && j <= r) {
            if (nums[i] <= nums[j]) tmp[k ++] = nums[i ++];
            else tmp[k ++] = nums[j ++];
        }
        // 处理剩余元素
        while (i <= mid) tmp[k ++] = nums[i ++];
        while (j <= r) tmp[k ++] = nums[j ++];
        // 将临时数组复制回原数组
        for (int idx = 0; idx < tmp.size(); ++idx) nums[l + idx] = tmp[idx];
    }
    
    // --- 堆排序 --- 
    // 调整堆，使其满足最大堆性质
    void heapify(std::vector<int>& nums, int n, int i) {
        int largest = i;    // 初始化最大值为根节点
        int l = 2 * i + 1;  // 左子节点
        int r = 2 * i + 2;  // 右子节点

        // 如果左子节点大于根节点
        if (l < n && nums[l] > nums[largest])
            largest = l;
        // 如果右子节点大于当前最大值
        if (r < n && nums[r] > nums[largest])
            largest = r;

        // 如果最大值不是根节点
        if (largest != i) {
            std::swap(nums[i], nums[largest]); // 交换
            heapify(nums, n, largest);          // 递归调整受影响的子树
        }
    }
    void heapSort(std::vector<int>& nums) {
        int n = nums.size();
        // 构建最大堆 (从最后一个非叶子节点开始调整)
        for (int i = n / 2 - 1; i >= 0; i--)
            heapify(nums, n, i);
        // 逐个提取元素
        for (int i = n - 1; i > 0; i--) {
            std::swap(nums[0], nums[i]); // 将当前最大元素（堆顶）移到末尾
            heapify(nums, i, 0);         // 重新调整剩余元素的堆结构
        }
    }

    // --- 选择排序 --- 
    void selectionSort(std::vector<int>& nums) {
        int n = nums.size();
        for (int i = 0; i < n - 1; i++) {
            int min_idx = i; // 记录最小元素的索引
            // 在未排序部分找到最小元素
            for (int j = i + 1; j < n; j++)
                if (nums[j] < nums[min_idx])
                    min_idx = j;
            // 如果最小元素不是当前位置元素，则交换
            if (min_idx != i)
                 std::swap(nums[i], nums[min_idx]);
        }
    }

    // --- 冒泡排序 --- 
    void bubbleSort(std::vector<int>& nums) {
        int n = nums.size();
        bool swapped; // 优化：标记是否发生交换
        for (int i = 0; i < n - 1; i++) {
            swapped = false;
            // 比较相邻元素
            for (int j = 0; j < n - i - 1; j++) {
                if (nums[j] > nums[j + 1]) {
                    std::swap(nums[j], nums[j + 1]);
                    swapped = true;
                }
            }
            // 如果一轮比较中没有发生交换，说明数组已经有序
            if (!swapped) break; 
        }
    }
    
    // --- 插入排序 --- 
    void insertionSort(std::vector<int>& nums) {
        int n = nums.size();
        for (int i = 1; i < n; i++) {
            int key = nums[i]; // 当前待插入元素
            int j = i - 1;
            // 将大于 key 的元素向后移动
            while (j >= 0 && nums[j] > key) {
                nums[j + 1] = nums[j];
                j = j - 1;
            }
            nums[j + 1] = key; // 插入 key 到正确位置
        }
    }

    // --- 希尔排序 --- 
    void shellSort(std::vector<int>& nums) {
        int n = nums.size();
        // 使用 Knuth 增量序列: ..., 121, 40, 13, 4, 1
        int gap = 1;
        while (gap < n / 3) {
            gap = 3 * gap + 1; 
        }

        // 逐步减小增量
        for (; gap > 0; gap /= 3) {
            // 对每个间隔为 gap 的子序列进行插入排序
            for (int i = gap; i < n; i += 1) {
                int temp = nums[i];
                int j;
                for (j = i; j >= gap && nums[j - gap] > temp; j -= gap)
                    nums[j] = nums[j - gap];
                nums[j] = temp;
            }
        }
    }


public:
    // 提供统一接口调用各种排序方法
    std::vector<int> runQuickSort(std::vector<int>& nums) {
        quickSortRecursive(nums, 0, nums.size() - 1);
        return nums;
    }
    std::vector<int> runMergeSort(std::vector<int>& nums) {
        mergeSortRecursive(nums, 0, nums.size() - 1);
        return nums;
    }
    std::vector<int> runHeapSort(std::vector<int>& nums) {
        heapSort(nums);
        return nums;
    }
     std::vector<int> runSelectionSort(std::vector<int>& nums) {
        selectionSort(nums);
        return nums;
    }
    std::vector<int> runBubbleSort(std::vector<int>& nums) {
        bubbleSort(nums);
        return nums;
    }
    std::vector<int> runInsertionSort(std::vector<int>& nums) {
        insertionSort(nums);
        return nums;
    }
     std::vector<int> runShellSort(std::vector<int>& nums) {
        shellSort(nums);
        return nums;
    }

    // 原始 main 函数使用的入口 - 可以保留或移除
    std::vector<int> mySort(std::vector<int> &nums) {
        // 默认为归并排序或快速排序用于演示
        return runMergeSort(nums); 
    }
}; 
/********************************/
/*     以上是你需要提交的代码     */
/********************************/

// --- 数据生成函数 --- 
std::vector<int> generateRandomData(int size) {
    std::vector<int> data(size);
    std::random_device rd; // 随机设备，用于生成种子
    std::mt19937 gen(rd()); // Mersenne Twister 引擎
    std::uniform_int_distribution<> distrib(0, size * 10); // 均匀分布范围，可按需调整
    for (int i = 0; i < size; ++i) {
        data[i] = distrib(gen);
    }
    return data;
}

std::vector<int> generateSortedData(int size) {
    std::vector<int> data(size);
    for (int i = 0; i < size; ++i) {
        data[i] = i;
    }
    return data;
}

std::vector<int> generateReverseSortedData(int size) {
    std::vector<int> data(size);
    for (int i = 0; i < size; ++i) {
        data[i] = size - 1 - i;
    }
    return data;
}

// --- 测试框架 --- 
int main() {
    Solution s;
    srand(time(0)); // 为旧版 quicksort_plus 中的 rand() 设置种子 (如果使用的话)

    // 定义待测试算法
    std::map<std::string, std::function<std::vector<int>(Solution&, std::vector<int>&)>> algorithms;
    algorithms["快速排序"] = &Solution::runQuickSort;
    algorithms["归并排序"] = &Solution::runMergeSort;
    algorithms["堆排序"]   = &Solution::runHeapSort;
    algorithms["希尔排序"] = &Solution::runShellSort;
    algorithms["插入排序"] = &Solution::runInsertionSort; // O(n^2)
    algorithms["选择排序"] = &Solution::runSelectionSort; // O(n^2)
    algorithms["冒泡排序"] = &Solution::runBubbleSort;       // O(n^2)

    // 定义数据规模
    std::vector<int> sizes = {10, 100, 1000, 10000, 100000, 1000000};
    int specificSize = 10000; // 特定测试规模（用于有序和逆序数据）
    int skipThreshold = 100000; // O(n^2) 算法跳过测试的阈值

    // 输出表头
    std::cout << std::left << std::setw(15) << "算法名称"
              << std::setw(12) << "数据规模"
              << std::setw(15) << "数据类型"
              << std::setw(15) << "运行时间 (ms)" << std::endl;
    std::cout << std::string(60, '-') << std::endl;

    // 遍历每种算法
    for (const auto& pair : algorithms) {
        const std::string& name = pair.first;
        auto sortFunc = pair.second;
        bool isN2 = (name == "插入排序" || name == "选择排序" || name == "冒泡排序");

        // 测试不同规模的随机数据
        for (int size : sizes) {
            // 如果是 O(n^2) 算法且数据规模过大，则跳过
            if (isN2 && size >= skipThreshold) {
                 std::cout << std::left << std::setw(15) << name
                           << std::setw(12) << size
                           << std::setw(15) << "随机"
                           << std::setw(15) << "跳过 (O(N^2))" << std::endl;
                 continue;
            }
            std::vector<int> data = generateRandomData(size);
            std::vector<int> data_copy = data; // 对副本进行排序，保留原始数据

            // 计时开始
            auto start = std::chrono::high_resolution_clock::now();
            sortFunc(s, data_copy); // 执行排序
            auto end = std::chrono::high_resolution_clock::now();
            // 计算耗时
            std::chrono::duration<double, std::milli> duration = end - start;

            // 输出结果
            std::cout << std::left << std::setw(15) << name
                      << std::setw(12) << size
                      << std::setw(15) << "随机"
                      << std::fixed << std::setprecision(3) << std::setw(15) << duration.count() << std::endl;
        }

        // 测试 10K 有序数据
        {
            int size = specificSize;
            std::vector<int> data = generateSortedData(size);
            std::vector<int> data_copy = data;

            auto start = std::chrono::high_resolution_clock::now();
            sortFunc(s, data_copy);
            auto end = std::chrono::high_resolution_clock::now();
            std::chrono::duration<double, std::milli> duration = end - start;

             std::cout << std::left << std::setw(15) << name
                       << std::setw(12) << size
                       << std::setw(15) << "有序"
                       << std::fixed << std::setprecision(3) << std::setw(15) << duration.count() << std::endl;
        }

        // 测试 10K 逆序数据
        {
            int size = specificSize;
            std::vector<int> data = generateReverseSortedData(size);
            std::vector<int> data_copy = data;

            auto start = std::chrono::high_resolution_clock::now();
            sortFunc(s, data_copy);
            auto end = std::chrono::high_resolution_clock::now();
            std::chrono::duration<double, std::milli> duration = end - start;

            std::cout << std::left << std::setw(15) << name
                      << std::setw(12) << size
                      << std::setw(15) << "逆序"
                      << std::fixed << std::setprecision(3) << std::setw(15) << duration.count() << std::endl;
        }
         std::cout << std::string(60, '-') << std::endl; // 分隔线
    }

    // 保留原始 main 函数的功能（如果需要用于单个测试提交）
    /*
    int n;
    std::cin >> n;
    std::vector<int> nums(n);
    for (int i = 0; i < n; i ++) {
        std::cin >> nums[i];
    }
    Solution s;
    std::vector<int> after_sort = s.mySort(nums); // 使用默认排序
    std::cout << after_sort[0];
    for (int i = 1; i < n; i ++) {
        std::cout << ' ' << after_sort[i];
    }
    std::cout << std::endl;
    */

    return 0;
}