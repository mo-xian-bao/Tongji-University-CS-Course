#include <iostream>
#include <cstring>
#define MAX_DIGITS 500 // 假设足够存储最终结果

using namespace std;

class BigNum {
public:
    int digits[MAX_DIGITS];
    int length;

    BigNum() {
        memset(digits, 0, sizeof(digits)); //对digits数组清0，效率高
        length = 1;
        digits[0] = 0;
    }

    BigNum(int num) {
        memset(digits, 0, sizeof(digits));
        length = 0;
        while (num > 0) {
            digits[length++] = num % 10;
            num /= 10;
        }
        if (length == 0) {
            length = 1;
            digits[0] = 0;
        }
    }

    void multiply(int num) {
        int carry = 0;
        for (int i = 0; i < length; i++) {
            int product = digits[i] * num + carry;
            digits[i] = product % 10;
            carry = product / 10;
        }
        while (carry) {
            digits[length++] = carry % 10;
            carry /= 10;
        }
    }

    void add(BigNum& other) {
        int maxLength = max(length, other.length);
        int carry = 0;
        for (int i = 0; i < maxLength; i++) {
            int sum = (i < length ? digits[i] : 0) + (i < other.length ? other.digits[i] : 0) + carry;
            digits[i] = sum % 10;
            carry = sum / 10;
        }
        if (carry) {
            digits[maxLength++] = carry;
        }
        length = maxLength;
    }

    void print() {
        for (int i = length - 1; i >= 0; i--) {
            cout << digits[i];
        }
        cout << endl;
    }
};

int main() {
    int N, A;
    while (cin >> N >> A) {
        BigNum result(0);
        for (int i = 1; i <= N; i++) {
            BigNum term(1); // 初始化为1，因为我们要计算 i * A^i
            for (int j = 0; j < i; j++) {
                term.multiply(A); // 计算 A^i
            }
            term.multiply(i); // 计算 i * A^i
            result.add(term); // 累加到结果中
        }
        result.print();
    }
    return 0;
}

// Definition for a large number representation using an array of digits.  
class BigNum {
public:
    int digits[MAX_DIGITS]; // 存储大数的每一位，最大位数为 MAX_DIGITS  
    int length;             // 大数的有效位数  

    // 默认构造函数，初始化大数为0  
    BigNum() {
        memset(digits, 0, sizeof(digits)); // 将digits数组清零  
        length = 1;         // 设置有效位数为1  
        digits[0] = 0;     // 初始化为0  
    }

    // 构造函数，通过整数初始化大数  
    BigNum(int num) {
        memset(digits, 0, sizeof(digits)); // 将digits数组清零  
        length = 0;
        while (num > 0) {
            digits[length++] = num % 10; // 将num的每一位存储到digits数组中  
            num /= 10;                   // 除以10处理下一位  
        }
        // 处理num为0的情况  
        if (length == 0) {
            length = 1;
            digits[0] = 0; // 设置为0  
        }
    }
};

/**
 * @brief          乘法操作，将当前大数与一个整数相乘，并更新当前大数
 * @param num      要乘的整数
 */
void multiply(int num) {
    int carry = 0; // 进位初始化为0  
    for (int i = 0; i < length; i++) {
        int product = digits[i] * num + carry; // 计算当前位乘法结果加上进位  
        digits[i] = product % 10; // 保存当前位的结果  
        carry = product / 10;      // 更新进位  
    }
    // 处理最后的进位，可能会增加新的位数  
    while (carry) {
        digits[length++] = carry % 10; // 添加新的位数  
        carry /= 10;                   // 更新进位  
    }
}

/**
 * @brief          加法操作，将当前大数与另一个大数相加，并更新当前大数
 * @param other    另一个大数对象
 */
void add(BigNum& other) {
    int maxLength = max(length, other.length); // 计算最大有效位数  
    int carry = 0; // 进位初始化为0  
    // 位数从低到高逐位相加  
    for (int i = 0; i < maxLength; i++) {
        int sum = (i < length ? digits[i] : 0) + // 当前大数的当前位  
            (i < other.length ? other.digits[i] : 0) + carry; // 另一个大数的当前位  
        digits[i] = sum % 10; // 保存当前位的结果  
        carry = sum / 10;      // 更新进位  
    }
    // 如果还有进位，增加新的位数  
    if (carry) {
        digits[maxLength++] = carry;
    }
    length = maxLength; // 更新大数的有效位数  
}

/**
 * @brief          打印大数的值
 */
void print() {
    for (int i = length - 1; i >= 0; i--) { // 从最高位到最低位打印  
        cout << digits[i];
    }
    cout << endl; // 打印结束后换行  
}