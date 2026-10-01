/**
 * @name    p141_data.cpp
 * @brief   p141随机测试数据生成程序
 * @date    2022-11-30
*/

#include <iostream>
#include <algorithm>
#include <fstream>
#include <ctime>
#include <vector>
#include <queue>
#include <cstdlib>
#include <string>
#include <sstream>

class Sequence {
private:
    int n, m;
    std::vector<std::vector<int>> nums;
    std::vector<int> ans;

public:
    Sequence(int m_, int n_, int max_num) : m(m_), n(n_), nums(m, std::vector<int>(n)), ans(n) {
        for (int i = 0; i < m; i ++) {
            for (int j = 0; j < n; j ++ ) {
                int t = rand() % max_num;
                nums[i][j] = rand() % (max_num - t + 1) + t;
            }
        }
        solve();
    }
    void printNums(std::ostream &out) {
        for (int i = 0; i < m; i ++) {
            for (int j = 0; j < n - 1; j ++) {
                out << nums[i][j] << ' ';
            }
            out << nums[i][n - 1] << std::endl;
        }
    }
    void printAns(std::ostream &out) {
        for (int i = 0; i < n - 1; i ++) {
            out << ans[i] << ' ';
        }
        out << ans[n - 1] << std::endl;
    }
private:
    void solve() {
        for (int i = 0; i < n; i ++) {
            ans[i] = nums[0][i];
        }
        std::sort(ans.begin(), ans.end());
        for (int i = 1; i < m; i ++) {
            // 堆
            std::priority_queue<int> pque;
            for (int j = 0; j < n; j++) {
                pque.push(nums[i][0] + ans[j]);
            }
            for (int z = 1; z < n; z ++) {
                for (int j = 0; j < n; j ++) {
                    if (ans[j] + nums[i][z] < pque.top()) {
                        pque.pop();
                        pque.push(ans[j] + nums[i][z]);
                    }
                    else {
                        break;
                    }
                }
            }
            for (int j = 1; j <= n; j ++) {
                ans[n - j] = pque.top();
                pque.pop();
            }
        }
    }
};

int main()
{
    srand((unsigned)time(NULL));
    int test_num = 10; // 测试点个数
    for( int index = 1; index <= test_num; index ++ ) {
        std::string input_file = "input" + std::to_string(index) + ".txt";
        std::string output_file = "output" + std::to_string(index) + ".txt";
        std::ofstream fin(input_file.c_str());
        std::ofstream fout(output_file.c_str());

        int T, m, n, max_num;
        if (index <= test_num * 0.2) {
            T = 1;
        }
        else if (index <= test_num * 0.4) {
            T = 2;
        }
        else {
            T = 3;
        }
        fin << T << std::endl;
        while (T --) {
            if( index <= test_num * 0.2 ) {
                n = rand() % 6 + 5;
                m = rand() % 3 + 3;
                max_num = 10;
            }
            else if( index <= test_num * 0.4 ) {
                n = rand() % 11 + 90;
                m = rand() % 11 + 40;
                max_num = 5000;
            }
            else {
                n = rand() % 51 + 1950;
                m = rand() % 11 + 90;
                max_num = 10000;
            }
            fin << m << ' ' << n << std::endl;
            Sequence seq(m, n, max_num);
            seq.printNums(fin);
            seq.printAns(fout);
        }

        // 文件输出代码

        fin.close();
        fout.close();
    }
}