/*
#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
using namespace std;
*/

//给定一组非负整数 nums，重新排列每个数的顺序（每个数不可拆分）使之组成一个最大的整数。
//注意：输出结果可能非常大，所以你需要返回一个字符串而不是整数。

class Solution{
    private:
    //这是一个自定义的比较函数，用于确定两个数字字符串 `a` 和 `b` 的拼接顺序。
    static bool compare(const string& a, const string& b){return a+b>b+a;}
    //冒泡排序
    void BubbleSort(vector<string>& strs){
        int n=strs.size();
        for(int i=0;i<n-1;i++){
            for(int j=0;j<n-i-1;j++){
                if(!compare(strs[j],strs[j+1])){
                    swap(strs[j],strs[j+1]);
                }
            }
        }
    }
    public:
    string largestNumber(vector<int>& nums){
        vector<string> strs;
        for(int num:nums){
            strs.push_back(to_string(num));  //将整数转换为字符串并添加到字符串数组中
        }
        BubbleSort(strs); //对字符串数组进行排序
        if(strs[0]=="0") return "0";
        string res;
        for(string& str:strs){
            res+=str;
        }
        return res;
    }
};

// int main(){
//     Solution solution;
//     vector<int> nums={10,2};
//     cout<<solution.largestNumber(nums)<<endl;
//     return 0;
// }