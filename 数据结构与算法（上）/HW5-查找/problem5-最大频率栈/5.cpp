#include <unordered_map>

class FreqStack {
   private:
    map<int, vector<int>> stack;        // 存放频率和栈的映射
    unordered_map<int, int> freqCount;  // 存放频率和频率的映射
   public:
    FreqStack() {}

    void push(int val) {
        freqCount[val]++;  //压入的元素对应的频率+1
        stack[freqCount[val]].push_back(val);  //将元素压入对应频率的栈中
    }

    int pop() {
        int ans = (--stack.end())->second.back();  //取出最大频率的栈顶元素
        stack[freqCount[ans]].pop_back();  //弹出栈顶元素
        if (stack[freqCount[ans]].empty()) {  //如果栈为空，则删除该频率的栈
            stack.erase(freqCount[ans]);
        }
        freqCount[ans]--;  //弹出的元素对应的频率-1
        return ans;
    }
};