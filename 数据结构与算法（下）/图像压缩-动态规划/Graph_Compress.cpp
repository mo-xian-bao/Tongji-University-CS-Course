#include <iostream>
#include <vector>
#define MAX_LEN 256 //每段最大长度

using namespace std;

int length(int a) //像素点a的存储bit数
{
    if(a<2) return 1;
    else if (a<4) return 2;
    else if (a<8) return 3;
    else if (a<16) return 4;
    else if (a<32) return 5;
    else if (a<64) return 6;
    else if (a<128) return 7;
    else return 8;
}

void compress(int n,vector<int>& nums,vector<int>& b,vector<int>& dp,vector<int>& l,vector<int>& s){
    //b[i]表示第i个像素点的存储bit数
    //dp[i]表示前i个像素最优分段后所需的最小储存位数
    //l[i]表示前i个像素最优分段后最后一段的像素点个数
    //s[i]表示前i个像素最优分段后最后一段每个像素点的存储bit数

    dp[0] = 0; //0个像素点需要的最小储存位数为0
    for(int i=0;i<n;i++){
        b[i+1] = length(nums[i]); //计算每个像素点的存储bit数
    }

    for(int i=1;i<=n;i++){
        int bmax; //记录前i个像素点中最大的存储bit数
        //初始认为最后一段只包含第i个像素点
        bmax = b[i];
        dp[i] = dp[i-1]+bmax*1+11;
        l[i] = 1;
        s[i] = bmax;

        for(int k=2;k<=i && k<=MAX_LEN;k++){
            //从后往前遍历，找到最优的分段方式，k表示最后一段的像素点个数
            bmax = max(bmax,b[i-k+1]);
            if(dp[i]>dp[i-k]+bmax*k+11){
                dp[i] = dp[i-k]+bmax*k+11;
                l[i] = k;
                s[i] = bmax;
            }
        }
    }
}

void traceback(int n,int& cnt,vector<int>& l,vector<int>& s)  //回溯构造最优解
{
    if(n==0) return;
    traceback(n-l[n],cnt,l,s);
    cnt++; 
    cout<<"第"<<cnt<<"段："<<endl;
    cout<<"长度为"<<l[n]<<",每个像素点存储bit数为"<<s[n]<<endl;
}


int main(){
    int n;
    cin>>n; //像素个数
    vector<int> nums(n); //像素值
    for(int i=0;i<n;i++){
        cin>>nums[i];
    }
    vector<int> b(n+1); //每个像素点的存储bit数
    vector<int> dp(n+1); //前i个像素点最优分段后所需的最小储存位数
    vector<int> l(n+1); //前i个像素点最优分段后最后一段的像素点个数
    vector<int> s(n+1); //前i个像素点最优分段后最后一段每个像素点的存储bit数

    compress(n,nums,b,dp,l,s);

    cout<<"压缩后所需的最小储存位数为："<<dp[n]<<endl;
    cout<<"最优分段方式为："<<endl;
    int cnt = 0; //分的段数
    traceback(n,cnt,l,s);

    return 0;
}