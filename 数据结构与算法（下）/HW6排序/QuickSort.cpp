#include <iostream>
#include <vector>
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

int main(){
    vector<int> nums={3,2,1,5,6,4};
    QuickSort(nums,0,nums.size()-1);
    for(int num:nums){
        cout<<num<<" ";
    }
    return 0;
}