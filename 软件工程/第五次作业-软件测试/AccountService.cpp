#include "AccountService.h"

/**
 * 取款业务实现
 * 流程：查找账户 -> 扣款(内存中) -> 更新账户(持久化)
 */
void AccountService::withdraw(std::string cardNo, long amount) {
    Account account = accountManager->findAccount(cardNo); // 1. 从数据库获取账户
    account.debit(amount);                                 // 2. 执行扣款（包含余额检查）
    accountManager->updateAccount(account);                // 3. 保存更新后的状态
}

/**
 * 存款业务实现
 * 流程：查找账户 -> 存款(内存中) -> 更新账户(持久化)
 */
void AccountService::deposit(std::string cardNo, long amount) {
    Account account = accountManager->findAccount(cardNo); // 1. 从数据库获取账户
    account.credit(amount);                                // 2. 执行存款
    accountManager->updateAccount(account);                // 3. 保存更新后的状态
}

/**
 * 查询余额实现
 */
long AccountService::inquiry(std::string cardNo) {
    Account account = accountManager->findAccount(cardNo);
    return account.getBalance();
}

/**
 * 转账业务实现
 * 流程：检查限额 -> 获取双方账户 -> 扣款/存款 -> 保存双方状态
 */
void AccountService::transfer(std::string fromCardNo, std::string toCardNo, long amount) {
    // 需求(2)：一次转账金额限定为 3000 元
    if (amount > 3000) {
        throw std::runtime_error("Transfer amount exceeds limit of 3000");
    }

    Account fromAcc = accountManager->findAccount(fromCardNo); // 获取转出账户
    Account toAcc = accountManager->findAccount(toCardNo);     // 获取转入账户

    fromAcc.debit(amount); // 转出账户扣款
    toAcc.credit(amount);  // 转入账户加款

    accountManager->updateAccount(fromAcc); // 更新转出账户
    accountManager->updateAccount(toAcc);   // 更新转入账户
}
