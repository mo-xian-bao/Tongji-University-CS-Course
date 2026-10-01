#include <iostream>
#include <vector>
#include <algorithm>
#include <ctime>
#include <iomanip>   
#include <chrono>    
using namespace std;

//1.基于堆的选择
int find_kth_smallest_by_heap(vector<int>& nums, int k)
{
    //不会修改原数组，不需要复制
    if(k < 1 || k > nums.size())
        throw invalid_argument("k is out of range");

    vector<int> heap; //大顶堆
    for(int i = 0; i < nums.size(); ++i)
    {
        if(heap.size() < k){
            heap.push_back(nums[i]);
            int j = heap.size() - 1;
            while(j > 0){
                int parent = (j - 1) / 2;
                if(heap[j] > heap[parent]){
                    swap(heap[j], heap[parent]);
                    j = parent;
                }
                else
                    break;
            }
        }
        else if(nums[i] < heap.front()){
            heap.front() = nums[i];
            int j = 0;
            while(j < heap.size()){
                int left = j * 2 + 1;
                int right = j * 2 + 2;
                int maxIndex = j;
                if(left < heap.size() && heap[left] > heap[maxIndex])
                    maxIndex = left;
                if(right < heap.size() && heap[right] > heap[maxIndex])
                    maxIndex = right;
                if(maxIndex == j)
                    break;
                swap(heap[j], heap[maxIndex]);
                j = maxIndex;
            }
        }
    }
    return heap[0]; //返回堆顶元素即为第k小元素
}

//2.随机划分线性选择 
// 分区函数
int partition(vector<int>& nums, int left, int right)
{
    int pivot_index = left + rand() % (right - left + 1);
    swap(nums[pivot_index],nums[left]);
    int pivot = nums[left];

    while(left < right)
    {
        while(left < right && nums[right] >= pivot)
            right--;
        nums[left] = nums[right];
        while(left < right && nums[left] <= pivot)
            left++;
        nums[right] = nums[left];
    }
    nums[left] = pivot;
    return left;
}
// 随机选择函数
int random_select(vector<int>& nums, int left, int right, int k)
{
    if(left == right)
        return nums[left];

    int pivot_index = partition(nums, left, right);
    int rank = pivot_index - left + 1; //当前基准元素的排名

    if(k == rank)
        return nums[pivot_index];
    else if(k < rank)
        return random_select(nums, left, pivot_index - 1, k);
    else
        return random_select(nums, pivot_index + 1, right, k - rank);
}
// 主函数
int find_kth_smallest_by_RandomizedSelect(vector<int>& nums, int k) {
    if(k < 1 || k > nums.size())
        throw invalid_argument("k is out of range");
    srand(time(nullptr));  // 设置随机数种子
    vector<int> nums_copy = nums; // 复制原数组以避免修改
    return random_select(nums_copy, 0, nums_copy.size() - 1, k);
}

//3.利用中位数的线性时间选择
// 找出5个数的小数组的中位数
int median_of_five(vector<int>& nums, int left, int right)
{
    sort(nums.begin() + left, nums.begin() + right + 1);
    return nums[left + (right - left) / 2];
}
// 找出中位数的中位数
int median_of_midian(vector<int>& nums, int left, int right)
{
    //如果本身的长度小于5，则直接返回中位数
    if(right - left + 1 <= 5)
        return median_of_five(nums, left, right);

    //将每5个数分为一组，并找出每组的中位数
    vector<int> medians;
    for(int i = left; i <= right; i += 5)
    {
        int group_right = min(i + 4, right);
        medians.push_back(median_of_five(nums, i, group_right));
    }

    //递归找出中位数的中位数
    return median_of_midian(medians, 0, medians.size() - 1);
}
// 分区函数
int partition_median(vector<int>& nums, int left, int right, int pivot)
{
    //将pivot放到数组的最左边
    for(int i = left; i <= right; ++i)
    {
        if(nums[i] == pivot)
        {
            swap(nums[i], nums[left]);
            break;
        }
    }
    while(left < right)
    {
        while(left < right && nums[right] >= pivot)
            right--;
        nums[left] = nums[right];
        while(left < right && nums[left] <= pivot)
            left++;
        nums[right] = nums[left];
    }
    nums[left] = pivot;
    return left;
}
// 选择函数
int select_median(vector<int>& nums, int left, int right, int k)
{
    if(left == right)
        return nums[left];

    //找出中位数的中位数
    int pivot = median_of_midian(nums, left, right);
    //分区
    int pivot_index = partition_median(nums, left, right, pivot);
    int rank = pivot_index - left + 1; //当前基准元素的排名

    if(k == rank)
        return nums[pivot_index];
    else if(k < rank)
        return select_median(nums, left, pivot_index - 1, k);
    else
        return select_median(nums, pivot_index + 1, right, k - rank);
}
// 主函数
int find_kth_smallest_by_median(vector<int>& nums, int k) {
    if(k < 1 || k > nums.size())
        throw invalid_argument("k is out of range");
    vector<int> nums_copy = nums; // 复制原数组以避免修改
    return select_median(nums_copy, 0, nums_copy.size() - 1, k);
}

// --- 测试代码 ---
// 生成随机数组
vector<int> generate_random_vector(int size, int min_val = 1, int max_val = 10000000) {
    vector<int> vec(size);
    srand(time(nullptr)); // 确保每次生成的随机数不同
    for (int i = 0; i < size; ++i) {
        vec[i] = min_val + rand() % (max_val - min_val + 1);
    }
    return vec;
}

// 运行并计时单个算法
template<typename Func>
void run_and_time_algorithm(const string& algo_name, Func algo_func, vector<int>& data, int k, int n_val) {
    vector<int> data_copy = data; // 每次测试都用原始数据的副本
    
    auto start_time = chrono::high_resolution_clock::now();
    int result = algo_func(data_copy, k);
    auto end_time = chrono::high_resolution_clock::now();
    
    auto duration = chrono::duration_cast<chrono::microseconds>(end_time - start_time);
    
    cout << "算法: " << algo_name 
         << ", n = " << n_val 
         << ", k = " << k 
         << ", 第 " << k << " 小的元素: " << result 
         << ", 运行时间: " << fixed << setprecision(3) << duration.count() / 1000.0 << " ms" << endl;
}


int main()
{
    vector<int> n_values = {100, 1000, 10000, 50000, 100000, 1000000, 10000000}; // 不同的n值

    for (int n : n_values) {
        cout << "\n--- 测试数据规模 n = " << n << " ---" << endl;
        vector<int> test_data = generate_random_vector(n);

        // 测试不同的k值
        vector<int> k_values;
        if (n > 0) {
            k_values.push_back(1); // 最小值
            if (n / 2 > 1) k_values.push_back(n / 2); // 中间值附近
            k_values.push_back(n);   // 最大值
            if (n > 10) k_values.push_back(n / 4); // 其他一些k值
            if (n > 10) k_values.push_back(3 * n / 4);
        } else {
            cout << "数据规模n为0，跳过测试。" << endl;
            continue;
        }
        // 去重并排序k值，确保k在有效范围内
        sort(k_values.begin(), k_values.end());
        k_values.erase(unique(k_values.begin(), k_values.end()), k_values.end());


        for (int k : k_values) {
            if (k < 1 || k > n) continue; // 确保k有效

            cout << "-- k = " << k << " --" << endl;
            
            // 1. 基于堆的选择
            run_and_time_algorithm("基于堆的选择", find_kth_smallest_by_heap, test_data, k, n);
            
            // 2. 随机划分线性选择
            run_and_time_algorithm("随机划分线性选择", find_kth_smallest_by_RandomizedSelect, test_data, k, n);
            
            // 3. 利用中位数的线性时间选择
            run_and_time_algorithm("利用中位数的线性时间选择", find_kth_smallest_by_median, test_data, k, n);
        }
    }

    return 0;
}