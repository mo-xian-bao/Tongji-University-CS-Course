/**
 * @name    p142_data.cpp
 * @brief   p142随机测试数据生成程序
 * @date    2022-12-02
 */

#include <ctime>
#include <fstream>
#include <iostream>
#include <map>
#include <queue>
#include <string>
#include <vector>


class FreqStack {
   private:
    struct item {
        int val, index, nums;
        item(int v = 0, int i = 0, int n = 0) : val(v), index(i), nums(n) {}
    };
    struct COMP {
        bool operator()(const item &i1, const item &i2) {
            if (i1.nums != i2.nums) {
                return i2.nums > i1.nums;
            }
            return i2.index > i1.index;
        }
    };

    std::priority_queue<item, std::vector<item>, COMP> pque;
    std::map<int, int> chart;
    int index, size_;

   public:
    FreqStack() : index(0), size_(0) {}

    void push(int val) {
        size_++;
        pque.push(item(val, index++, chart[val]++));
    }

    int pop() {
        size_--;
        item i = pque.top();
        pque.pop();
        chart[i.val]--;
        return i.val;
    }

    int size() { return size_; }
};

int main() {
    srand((unsigned)time(NULL));
    int test_num = 10;  // 测试点个数
    for (int index = 1; index <= test_num; index++) {
        std::string input_file = "input" + std::to_string(index) + ".txt";
        std::string output_file = "output" + std::to_string(index) + ".txt";
        std::ofstream fin(input_file.c_str());
        std::ofstream fout(output_file.c_str());

        int n, max_num;
        if (index <= test_num * 0.2) {
            n = rand() % 11 + 10;
            max_num = 20;
        } else if (index <= test_num * 0.4) {
            n = rand() % 51 + 950;
            max_num = 10000;
        } else {
            n = rand() % 101 + 199900;
            max_num = 1000000000;
        }

        int m = std::max(4, std::min(n / 5 + 1, 10000));
        std::vector<int> rand_nums(m);
        for (int i = 0; i < m; i++) {
            rand_nums[i] = rand() % max_num;
        }

        FreqStack fs;
        fin << n << std::endl;
        for (int i = 0; i < n; i++) {
            // 随着操作进行，pop操作概率逐渐从0.1增长至0.9
            if (fs.size() > 0 && rand() % 100 < 10 + 80 * i / (n - 1)) {
                fin << "pop" << std::endl;
                fout << fs.pop() << std::endl;
            } else {
                int n_i = rand() % m;
                fin << "push " << rand_nums[n_i] << std::endl;
                fs.push(rand_nums[n_i]);
            }
        }

        fin.close();
        fout.close();
    }
    return 0;
}