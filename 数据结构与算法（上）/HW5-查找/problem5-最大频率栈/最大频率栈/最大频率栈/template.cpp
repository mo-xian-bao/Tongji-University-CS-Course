/**
 * @name    template.cpp
 * @brief   p142模板程序
 * @date    2022-12-02
 */

#include <algorithm>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <iostream>
#include <map>
#include <queue>
#include <set>
#include <stack>
#include <string>
#include <unordered_map>
#include <vector>

using namespace std;

/********************************/
/*     以下是你需要提交的代码     */
/********************************/
class FreqStack {
   private:
    map<int, vector<int>> stack;        // 存放频率和栈的映射
    unordered_map<int, int> freqCount;  // 存放频率和频率的映射
   public:
    FreqStack() {}

    void push(int val) {
        freqCount[val]++;
        stack[freqCount[val]].push_back(val);
    }

    int pop() {
        int ans = (--stack.end())->second.back();
        stack[freqCount[ans]].pop_back();
        if (stack[freqCount[ans]].empty()) {
            stack.erase(freqCount[ans]);
        }
        freqCount[ans]--;
        return ans;
    }
};
/********************************/
/*     以上是你需要提交的代码     */
/********************************/

int main() {
    int n;
    std::cin >> n;
    FreqStack fs;
    while (n--) {
        std::string order;
        std::cin >> order;
        if (order == "push") {
            int val;
            std::cin >> val;
            fs.push(val);
        } else if (order == "pop") {
            std::cout << fs.pop() << std::endl;
        }
    }
    return 0;
}
