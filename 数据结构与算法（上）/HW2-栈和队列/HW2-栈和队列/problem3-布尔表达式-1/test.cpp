//#include <fstream>
//#include <iostream>
//#include <random>
//#include <string>
//
//std::random_device rd;
//std::mt19937 gen(rd());
//
//double random_double() {
//    std::uniform_real_distribution<> dis(0.0, 1.0);
//    return dis(gen);
//}
//
//std::string gen_false_expression(bool f, bool b, int n, int l);
//std::string gen_true_expression(bool f, bool b, int n, int l) {
//    if (n >= 2 && random_double() <= 0.3) {  // 生成空格
//        return " " + gen_true_expression(f, b, n - 1, l);
//    }
//    if (n >= 3 && b && random_double() <= 0.2) {  // 生成括号
//        return "(" + gen_true_expression(f, b, n - 2, 0) + ")";
//    }
//    if (l == 0) {  // 或级，能生成或、与、非和单字母
//        if (n >= 2 && f && random_double() <= 0.1) {  // 生成非
//            return "!" + gen_false_expression(f, b, n - 1, 2);
//        }
//        if (n < 3 || (n <= 5 && random_double() <= 0.3)) {  // 生成单字母
//            return "V";
//        }
//        if (random_double() <= 0.25) {  // 生成与
//            return gen_true_expression(f, b, (n - 1) / 2, 1) + "&" +
//                   gen_true_expression(f, b, (n - 1) / 2, 1);
//        }
//        double c = random_double();
//        // 生成或
//        std::string s1, s2;
//        if (c <= 0.33) {
//            s1 = gen_true_expression(f, b, (n - 1) / 2, 0);
//            s2 = gen_false_expression(f, b, (n - 1) / 2, 0);
//        } else if (c <= 0.66) {
//            s1 = gen_false_expression(f, b, (n - 1) / 2, 0);
//            s2 = gen_true_expression(f, b, (n - 1) / 2, 0);
//        } else {
//            s1 = gen_true_expression(f, b, (n - 1) / 2, 0);
//            s2 = gen_true_expression(f, b, (n - 1) / 2, 0);
//        }
//        return s1 + "|" + s2;
//    }
//    if (l == 1) {  // 与级，能生成与、非和单字母
//        if (n >= 2 && f && random_double() <= 0.1) {  // 生成非
//            return "!" + gen_false_expression(f, b, n - 1, 2);
//        }
//        if (n < 3 || (n <= 5 && random_double() <= 0.3)) {  // 生成单字母
//            return "V";
//        }
//        // 生成与
//        return gen_true_expression(f, b, (n - 1) / 2, 1) + "&" +
//               gen_true_expression(f, b, (n - 1) / 2, 1);
//    }
//    if (l == 2) {  // 非级，能生成非和单字母
//        if (n >= 3 && b &&
//            random_double() <= std::min(n / 50.0, 0.8)) {  // 生成括号
//            return "(" + gen_true_expression(f, b, n - 2, 0) + ")";
//        }
//        if (n < 2 || random_double() <= 0.9) {  // 生成单字母
//            return "V";
//        }
//        return "!" + gen_false_expression(f, b, n - 1, 2);
//    }
//    return "V";
//}
//
//// 生成结果为false的表达式
//std::string gen_false_expression(bool f, bool b, int n, int l) {
//    if (n >= 2 && random_double() <= 0.3) {  // 生成空格
//        return " " + gen_false_expression(f, b, n - 1, l);
//    }
//    if (n >= 3 && b && random_double() <= 0.2) {  // 生成括号
//        return "(" + gen_false_expression(f, b, n - 2, 0) + ")";
//    }
//    if (l == 0) {  // 或级，能生成或、与、非和单字母
//        if (n >= 2 && f && random_double() <= 0.1) {  // 生成非
//            return "!" + gen_true_expression(f, b, n - 1, 2);
//        }
//        if (n < 3 || (n <= 5 && random_double() <= 0.1)) {  // 生成单字母
//            return "F";
//        }
//        if (random_double() <= 0.75) {  // 生成与
//            double c = random_double();
//            std::string s1, s2;
//            if (c <= 0.33) {
//                s1 = gen_true_expression(f, b, (n - 1) / 2, 1);
//                s2 = gen_false_expression(f, b, (n - 1) / 2, 1);
//            } else if (c <= 0.66) {
//                s1 = gen_false_expression(f, b, (n - 1) / 2, 1);
//                s2 = gen_true_expression(f, b, (n - 1) / 2, 1);
//            } else {
//                s1 = gen_false_expression(f, b, (n - 1) / 2, 1);
//                s2 = gen_false_expression(f, b, (n - 1) / 2, 1);
//            }
//            return s1 + "&" + s2;
//        }
//        // 生成或
//        return gen_false_expression(f, b, (n - 1) / 2, 0) + "|" +
//               gen_false_expression(f, b, (n - 1) / 2, 0);
//    }
//    if (l == 1) {  // 与级，能生成与、非和单字母
//        if (n >= 2 && f && random_double() <= 0.1) {  // 生成非
//            return "!" + gen_true_expression(f, b, n - 1, 2);
//        }
//        if (n < 3 || (n <= 5 && random_double() <= 0.3)) {  // 生成单字母
//            return "F";
//        }
//        double c = random_double();
//        std::string s1, s2;
//        if (c <= 0.33) {
//            s1 = gen_true_expression(f, b, (n - 1) / 2, 1);
//            s2 = gen_false_expression(f, b, (n - 1) / 2, 1);
//        } else if (c <= 0.66) {
//            s1 = gen_false_expression(f, b, (n - 1) / 2, 1);
//            s2 = gen_true_expression(f, b, (n - 1) / 2, 1);
//        } else {
//            s1 = gen_false_expression(f, b, (n - 1) / 2, 1);
//            s2 = gen_false_expression(f, b, (n - 1) / 2, 1);
//        }
//        return s1 + "&" + s2;
//    }
//    if (l == 2) {  // 非级，能生成非和单字母
//        if (n >= 3 && b &&
//            random_double() <= std::min(n / 50.0, 0.8)) {  // 生成括号
//            return "(" + gen_false_expression(f, b, n - 2, 0) + ")";
//        }
//        if (l < 2 || random_double() <= 0.9) {  // 生成单字母
//            return "F";
//        }
//        return "!" + gen_true_expression(f, b, n - 1, 2);
//    }
//    return "F";
//}
//
//int main() {
//    int n = 10;  // 测试数据个数
//    for (int i = 1; i <= n; ++i) {
//        std::string input_file = "input" + std::to_string(i) + ".txt";
//        std::string output_file = "output" + std::to_string(i) + ".txt";
//        std::string test_data;
//        std::string ans_data;
//        bool f = (i > n * 0.2);  // 允许出现!
//        bool b = (i > n * 0.4);  // 允许出现()
//
//        int test_num, str_len;
//        if (i <= n * 0.2) {
//            test_num = 5;
//            str_len = 20;
//        } else if (i <= n * 0.4) {
//            test_num = 10;
//            str_len = 50;
//        } else {
//            test_num = 20;
//            str_len = 100;
//        }
//
//        for (int j = 0; j < test_num; ++j) {
//            if (random_double() < 0.5) {  // True
//                test_data += gen_true_expression(f, b, str_len, 0) + "\n";
//                ans_data += "Expression " + std::to_string(j + 1) + ": V\n";
//            } else {  // False
//                test_data += gen_false_expression(f, b, str_len, 0) + "\n";
//                ans_data += "Expression " + std::to_string(j + 1) + ": F\n";
//            }
//        }
//
//        std::ofstream fin(input_file);
//        fin << test_data;
//        fin.close();
//
//        std::ofstream fout(output_file);
//        fout << ans_data;
//        fout.close();
//    }
//
//    // std::cout << gen_true_expression(true, true, 20, 0) << std::endl;
//
//    return 0;
//}