#ifndef ACCOUNT_MANAGEMENT_H
#define ACCOUNT_MANAGEMENT_H

#include "Account.h"
#include <string>

/**
 * 账户管理接口 (AccountManagement)
 * 
 * 职责：
 * 定义与数据存储层（如数据库）交互的契约。
 * 在单元测试中，我们将 Mock 这个接口，而不是连接真实的数据库。
 */
class AccountManagement {
public:
    virtual ~AccountManagement() {}

    // 根据用户ID（卡号）查找账户信息
    virtual Account findAccount(std::string userID) = 0;

    // 更新账户信息到数据库
    virtual void updateAccount(Account account) = 0;
};

#endif // ACCOUNT_MANAGEMENT_H
