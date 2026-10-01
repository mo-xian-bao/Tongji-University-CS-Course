/**
 * @file    p136_data.cpp
 * @name    p136随机测试数据生成程序
 * @date    2022-11-10
 */

#include <algorithm>
#include <climits>
#include <ctime>
#include <fstream>
#include <iostream>
#include <queue>
#include <vector>


class Graph {
   private:
    struct Subject {
        int time_consuming;
        int last_subjects, next_subjects;
        int min_start_time, max_start_time;
        std::vector<int> next;
        std::vector<int> last;
        Subject()
            : last_subjects(0),
              next_subjects(0),
              min_start_time(0),
              max_start_time(INT_MAX) {}
    };
    int size;
    std::vector<Subject> subjects;

   public:
    /**
     * @param   n 课程数
     * @param   max_time_consuming 课时最大值
     * @brief   随机生成课程间接续关系
     */
    Graph(int n, int max_time_consuming) : size(n), subjects(n) {
        std::vector<int> list;
        // 随机洗牌生成课程拓扑排序结果
        shuffle(list, size);
        for (int i = 0; i < size; i++) {
            int id = list[i];
            // 每门课有m门前序课程
            int m = rand() % (i + 1);
            subjects[id].time_consuming = rand() % max_time_consuming + 1;
            subjects[id].last_subjects = m;
            subjects[id].last.resize(m);

            std::vector<bool> chart(i + 1, false);
            while (--m >= 0) {
                int j = rand() % i;
                while (chart[j]) {
                    j = (j + 1) % i;
                }
                chart[j] = true;
                j = list[j];
                subjects[id].last[m] = j;
                subjects[j].next_subjects++;
                subjects[j].next.emplace_back(id);
            }
        }
    }

    /**
     * @param   out 输出流
     * @brief   打印课程信息
     */
    void printSubjects(std::ostream &out) {
        out << size << std::endl;
        for (int i = 0; i < size; i++) {
            out << subjects[i].time_consuming << ' '
                << subjects[i].last_subjects;
            std::sort(subjects[i].last.begin(), subjects[i].last.end());
            for (int j = 0; j < subjects[i].last_subjects; j++) {
                out << ' ' << subjects[i].last[j] + 1;
            }
            out << std::endl;
        }
    }

    /**
     * @brief   求关键路径
     */
    bool calculateKeyWay() {
        std::queue<int> que;
        int count = 0;
        // 正向求解课程最早开始时间
        for (int i = 0; i < size; i++) {
            if (subjects[i].last_subjects == 0) {
                que.push(i);
            }
        }
        int end_time = 0;
        while (count < size && !que.empty()) {
            int now = que.front();
            que.pop();
            count++;
            int now_end_time =
                subjects[now].min_start_time + subjects[now].time_consuming;
            end_time = std::max(end_time, now_end_time);
            for (auto next : subjects[now].next) {
                subjects[next].last_subjects--;
                subjects[next].min_start_time =
                    std::max(subjects[next].min_start_time, now_end_time);
                if (subjects[next].last_subjects == 0) {
                    que.push(next);
                }
            }
        }
        if (count != size || !que.empty()) {
            return false;
        }
        // 逆向求解课程最晚开始时间
        for (int i = 0; i < size; i++) {
            if (subjects[i].next_subjects == 0) {
                subjects[i].max_start_time =
                    end_time - subjects[i].time_consuming;
                que.push(i);
            }
        }
        while (count && !que.empty()) {
            int now = que.front();
            que.pop();
            count--;
            for (auto last : subjects[now].last) {
                subjects[last].next_subjects--;
                subjects[last].max_start_time =
                    std::min(subjects[last].max_start_time,
                             subjects[now].max_start_time -
                                 subjects[last].time_consuming);
                if (subjects[last].next_subjects == 0) {
                    que.push(last);
                }
            }
        }
        if (count != 0 || !que.empty()) return false;
        return true;
    }
    /**
     * @param   out 输出流
     * @brief   打印输出
     */
    void printAns(std::ostream &out) {
        for (int i = 0; i < size; i++) {
            out << subjects[i].min_start_time + subjects[i].time_consuming
                << ' ';
            if (subjects[i].min_start_time == subjects[i].max_start_time)
                out << 1 << std::endl;
            else
                out << 0 << std::endl;
        }
    }

   private:
    /**
     * @param   list  洗牌结果
     * @param   size_ 数量
     * @brief   随机洗牌
     */
    static void shuffle(std::vector<int> &list, int size_ = 0) {
        if (size_ <= 0)
            size_ = list.size();
        else
            list.resize(size_);

        for (int i = 0; i < size_; i++) list[i] = i;
        for (int i = size_ - 1; i > 0; i--) {
            int j = rand() % (i + 1);
            int t = list[i];
            list[i] = list[j];
            list[j] = t;
        }
    }
};

int main() {
    srand((unsigned)time(NULL));
    int test_num = 10;  // 测试点个数
    for (int index = 1; index <= test_num; index++) {
        std::string input_file = "input" + std::to_string(index) + ".txt";
        std::string output_file = "output" + std::to_string(index) + ".txt";
        std::ofstream fin(input_file.c_str());
        std::ofstream fout(output_file.c_str());

        int n, max_time_consuming;
        if (index <= test_num * 0.2) {
            n = rand() % 6 + 5;
            max_time_consuming = 10;
        } else if (index <= test_num * 0.4) {
            n = rand() % 6 + 45;
            max_time_consuming = 50;
        } else {
            n = rand() % 6 + 95;
            max_time_consuming = 100;
        }

        // 文件输出代码

        Graph g(n, max_time_consuming);
        g.printSubjects(fin);
        if (g.calculateKeyWay()) {
            g.printAns(fout);
        }
        fin.close();
        fout.close();
    }
}