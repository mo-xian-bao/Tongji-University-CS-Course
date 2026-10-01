#ifndef ACCOUNT_SERVICE_H
#define ACCOUNT_SERVICE_H

#include "AccountManagement.h"
#include "Account.h"
#include <string>

/**
 * 账户服务类 (AccountService)
 * 
 * 职责：
 * 实现核心业务逻辑（取款、存款、转账、查询）。
 * 它不直接操作数据库，而是通过 AccountManagement 接口进行数据存取。
 */
class AccountService {
private:
    AccountManagement* accountManager; // 依赖倒置：依赖接口而非具体实现

public:
    // 构造函数注入 AccountManagement 依赖
    AccountService(AccountManagement* manager) : accountManager(manager) {}

    // 取款业务
    void withdraw(std::string cardNo, long amount);

    // 存款业务
    void deposit(std::string cardNo, long amount);

    // 转账业务
    void transfer(std::string fromCardNo, std::string toCardNo, long amount);

    // 余额查询
    long inquiry(std::string cardNo);
};

#endif // ACCOUNT_SERVICE_H
