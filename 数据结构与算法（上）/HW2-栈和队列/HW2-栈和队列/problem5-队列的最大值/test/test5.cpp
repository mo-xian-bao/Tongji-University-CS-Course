#include <iostream>  
#include <vector>  
#include <string>  
#include <fstream>  
#include <random>  

class Queue {  
public:  
    Queue(int n) : n(n), error(false) {}  

    void enqueue(int value) {  
        if (queue.size() == n) {  
            error = true;  
            return;  
        }  
        queue.push_back(value);  
        while (!max_queue.empty() && max_queue.back() < value) {  
            max_queue.pop_back();  
        }  
        max_queue.push_back(value);  
        error = false;  
    }  

    int dequeue() {  
        if (queue.empty()) {  
            error = true;  
            return 0;  
        }  
        int value = queue.front();  
        queue.erase(queue.begin());  
        if (value == max_queue.front()) {  
            max_queue.erase(max_queue.begin());  
        }  
        error = false;  
        return value;  
    }  

    int max_elem() {  
        if (queue.empty()) {  
            error = true;  
            return 0;  
        }  
        error = false;  
        return max_queue.front();  
    }  

    bool full() {  
        return queue.size() == n;  
    }  

    double percentage() {  
        return static_cast<double>(queue.size()) / n;  
    }  

    bool has_error() {  
        return error;  
    }  


    int n;  
    std::vector<int> queue;  
    std::vector<int> max_queue;  
    bool error;  
};  

int main() {  
    std::random_device rd;  // Random number generator  
    std::mt19937 gen(rd());  
    std::uniform_int_distribution<> dist1(-1000000000, 1000000000);  
    std::uniform_int_distribution<> dist2(1, 10000);  
    
    int test_num = 10; // 测试点个数  
    for (int i = 1; i <= test_num; ++i) {  
        std::string input_file = "input" + std::to_string(i) + ".txt";  
        std::string output_file = "output" + std::to_string(i) + ".txt";  
        
        std::string test;  // 生成测试文本  
        std::string ans;   // 生成答案文本  
        
        int que_size, max_num;  
        if (i <= 2) {           // 20%数据  
            que_size = 100;  
            max_num = 10000;  
        } else if (i <= 4) {    // 40%数据  
            que_size = 6000;  
            max_num = 1000000;  
        } else {                // 100%数据  
            que_size = 10000;  
            max_num = 100000000;  
        }  
        
        int ope_num = static_cast<int>(que_size * (10 + static_cast<double>(gen()) / gen.max())); // 操作个数  
        int base_num = dist1(gen);  
        Queue que(que_size);  
        
        test += std::to_string(que_size) + '\n';  
        std::string last_ope = "dequeue"; // 上一个测试操作  
        
        for (int j = 0; j < ope_num; ++j) {  
            double ope = static_cast<double>(gen()) / gen.max();  
            double sel = static_cast<double>(gen()) / gen.max();  

            // 在前5%的操作中，试图清空队列，测试队列判空(至多50条指令)  
            if (j <= ope_num * 0.05 && j <= 50) {  
                if (ope < 0.5) { // 生成dequeue  
                    test += "dequeue\n";  
                    int value = que.dequeue();  
                    if (que.has_error()) {  
                        ans += "Queue is Empty\n";  
                    } else {  
                        ans += std::to_string(value) + '\n';  
                    }  
                } else if (ope < 0.9) { // 生成enqueue  
                    int num = base_num + dist2(gen);  
                    test += "enqueue " + std::to_string(num) + '\n';  
                    que.enqueue(num);  
                    if (que.has_error()) {  
                        ans += "Queue is Full\n";  
                    }  
                } else { // 生成max  
                    test += "max\n";  
                    int value = que.max_elem();  
                    if (que.has_error()) {  
                        ans += "Queue is Empty\n";  
                    } else {  
                        ans += std::to_string(value) + '\n';  
                    }  
                }  
                
            // 在前5%到前20%的操作中，试图填满队列，测试队列判满  
            } else if (j <= ope_num * 0.2) {  
                if (ope < 0.8 && (que.full() && sel < 0.3 || !que.full() && sel < 0.8)) {  
                    int num = base_num + dist2(gen);  
                    test += "enqueue " + std::to_string(num) + '\n';  
                    que.enqueue(num);  
                    if (que.has_error()) {  
                        ans += "Queue is Full\n";  
                    }  
                } else if (ope < 0.6) {  
                    test += "dequeue\n";  
                    int value = que.dequeue();  
                    if (que.has_error()) {  
                        ans += "Queue is Empty\n";  
                    } else {  
                        ans += std::to_string(value) + '\n';  
                    }  
                } else {  
                    test += "max\n";  
                    int value = que.max_elem();  
                    if (que.has_error()) {  
                        ans += "Queue is Empty\n";  
                    } else {  
                        ans += std::to_string(value) + '\n';  
                    }  
                }  
            } else {  
                if (que.percentage() >= 0.85 && ope <= 0.6 && ((last_ope == "max" && sel <= 0.1) || (last_ope != "max" && sel <= 0.8))) {  
                    test += "max\n";  
                    int value = que.max_elem();  
                    if (que.has_error()) {  
                        ans += "Queue is Empty\n";  
                    } else {  
                        ans += std::to_string(value) + '\n';  
                    }  
                    last_ope = "max";  
                 } else if (que.percentage() <= 0.85 || (ope <= 0.9 && ((que.full() && sel <= 0.2) || (!que.full() && sel <= 0.95)))) {  
                    int num;  
                    if (j % 2 == 0) { // 保证打表搜索时，至少有一半的数据搜索长度大于1e6  
                        num = base_num + dist2(gen);  
                    } else {  
                        num = base_num + dist2(gen) * -1;  // 随机负值  
                    }  
                    test += "enqueue " + std::to_string(num) + '\n';  
                    que.enqueue(num);  
                    if (que.has_error()) {  
                        ans += "Queue is Full\n";  
                    }  
                    last_ope = "enqueue";  
                } else {  
                    test += "dequeue\n";  
                    int value = que.dequeue();  
                    if (que.has_error()) {  
                        ans += "Queue is Empty\n";  
                    } else {  
                        ans += std::to_string(value) + '\n';  
                    }  
                    last_ope = "dequeue";  
                }  
            }  
        }  
        
        // 结束操作，输出队列当前状态  
        test += "quit\n";  
        for (size_t k = 0; k < que.queue.size(); ++k) {  
            if (k > 0) ans += ' ';  
            ans += std::to_string(que.queue[k]);  
        }  
        ans += '\n';  
        
        // 将测试和答案写入文件  
        std::ofstream fin(input_file);  
        fin << test;  
        fin.close();  
        
        std::ofstream fout(output_file);  
        fout << ans;  
        fout.close();  
    }  

    return 0;  
}
