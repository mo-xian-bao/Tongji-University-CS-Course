#include <iostream>
using namespace std;

//给定一个整数顺序表nums，将顺序表中的元素向右轮转 k 个位置，其中 k 是非负数。
//输入
//第一行两个整数n和k，分别表示nums的元素个数n，和向右轮转k个位置；
//第二行包括n个整数，为顺序表nums中的元素


int main() 
{
	int n, k;
	cin >> n >> k;
	int nums[100000];  //用整型数组表示顺序表
	for (int i = 0; i < n; i++) {
		cin >> nums[i];
	}
	int temp[100000];  //用数组存储轮转后的顺序表
	for (int i = 0; i < n; i++) {
		temp[(i + k) % n] = nums[i]; //直接计算出轮转后的位置，然后将元素向右轮转k个位置
	}
	for (int i = 0; i < n; i++) {
		nums[i] = temp[i];
	}
	for (int i = 0; i < n; i++) {
		cout << nums[i] << " ";
	}
	return 0;
}