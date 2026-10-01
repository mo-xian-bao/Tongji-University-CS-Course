#ifndef ACCOUNT_H
#define ACCOUNT_H

#include <string>
#include <stdexcept>

/**
 * 账户实体类 (Account)
 * 
 * 职责：
 * 1. 存储账户的基本信息（卡号、余额）。
 * 2. 提供基本的资金操作（借记/取款、贷记/存款）。
 * 3. 包含基本的业务规则校验（如余额不足、金额为负）。
 */
class Account {
private:
    std::string cardNo; // 银行卡号
    long balance;       // 账户余额（单位：分，使用 long 避免浮点数精度问题）

public:
    // 默认构造函数：主要用于 Mock 框架或容器需要
    Account() : balance(0) {} 

    // 带参构造函数：初始化账户
    Account(std::string cardNo, long initBalance) : cardNo(cardNo), balance(initBalance) {}

    // 获取卡号
    std::string getCardNo() const {
        return cardNo;
    }

    // 获取当前余额
    long getBalance() const {
        return balance;
    }

    /**
     * 借记操作 (Debit) - 即取款或转出
     * @param amount 涉及金额
     * @throws std::invalid_argument 如果金额为负
     * @throws std::runtime_error 如果余额不足
     */
    void debit(long amount) {
        if (amount < 0) throw std::invalid_argument("Amount cannot be negative"); // 金额不能为负
        if (amount > balance) throw std::runtime_error("Insufficient balance");   // 余额不足
        balance -= amount;
    }

    /**
     * 贷记操作 (Credit) - 即存款或转入
     * @param amount 涉及金额
     * @throws std::invalid_argument 如果金额为负
     */
    void credit(long amount) {
        if (amount < 0) throw std::invalid_argument("Amount cannot be negative"); // 金额不能为负
        balance += amount;
    }
};

#endif // ACCOUNT_H
