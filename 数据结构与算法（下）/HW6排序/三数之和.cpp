#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int Partition(vector<int>& nums,int l,int r){
    int pivot = nums[l];
    while(l<r){
        while(l<r && nums[r]>=pivot) r--;
        nums[l]=nums[r];
        while(l<r && nums[l]<=pivot) l++;
        nums[r]=nums[l];
    }
    nums[l]=pivot;
    return l;
}

void QuickSort(vector<int>& nums,int left,int right){
    if(left>=right) return;
    int pivot=Partition(nums,left,right);
    QuickSort(nums,left,pivot-1);
    QuickSort(nums,pivot+1,right);
}

vector<vector<int>> threeSum(vector<int>& nums)
{
    vector<vector<int>> res;
    QuickSort(nums,0,nums.size()-1); // 对数组进行排序
    for(int i=0;i<nums.size()-2;i++){ 
        if(nums[i]>0) break; // 如果当前数字大于0，则三数之和一定大于0
        if(i>0 && nums[i]==nums[i-1]) continue; // 跳过重复的元素
        int left=i+1,right=nums.size()-1; // 双指针
        while(left<right){
            int sum=nums[i]+nums[left]+nums[right]; // 计算三数之和
            if(sum==0){
                res.push_back({nums[i],nums[left],nums[right]});
                while(left<right && nums[left]==nums[left+1]) left++; // 跳过重复的元素
                while(left<right && nums[right]==nums[right-1]) right--; 
                left++;
                right--;
            }
            else if(sum<0) left++; // 如果和小于0，左指针右移
            else right--; // 如果和大于0，右指针左移
        }
    }
    return res;
}

int main(){
    int n; // 输入数组长度
    cin>>n;
    vector<int> nums(n);
    for(int i=0;i<n;i++){
        cin>>nums[i];
    }
    vector<vector<int>> res=threeSum(nums);
    for(int i=0;i<res.size();i++){
        for(int j=0;j<res[i].size();j++){
            cout<<res[i][j]<<" ";
        }
        cout<<endl;
    }
    
    return 0;
}