#include <iostream>
#include <stdexcept>
#include <map>
#include <string>
#include "Account.h"
#include "AccountService.h"
#include "AccountManagement.h"

// ==========================================
// 极简断言工具（无第三方库）
// ==========================================

static void expectTrue(bool cond, const std::string& message) {
    if (!cond) {
        throw std::runtime_error(message);
    }
}

template <typename T>
static void expectEq(const T& actual, const T& expected, const std::string& message) {
    if (!(actual == expected)) {
        throw std::runtime_error(message);
    }
}

template <typename Func>
static void expectThrowsInvalidArgument(Func&& func, const std::string& message) {
    bool thrown = false;
    try {
        func();
    } catch (const std::invalid_argument&) {
        thrown = true;
    }
    expectTrue(thrown, message);
}

template <typename Func>
static void expectThrowsRuntimeError(Func&& func, const std::string& message) {
    bool thrown = false;
    try {
        func();
    } catch (const std::runtime_error&) {
        thrown = true;
    }
    expectTrue(thrown, message);
}

// ==========================================
// 辅助工具
// ==========================================

// 简单的测试运行器，用于捕获异常并打印结果
void runTest(void (*testFunc)(), const std::string& testName) {
    try {
        testFunc();
        std::cout << "[PASS] " << testName << std::endl;
    } catch (const std::exception& e) {
        std::cout << "[FAIL] " << testName << " - Exception: " << e.what() << std::endl;
    } catch (...) {
        std::cout << "[FAIL] " << testName << " - Unknown Exception" << std::endl;
    }
}

// ==========================================
// Mock 对象定义
// ==========================================
// 手动实现 MockAccountManagement，替代 Google Mock
class MockAccountManagement : public AccountManagement {
public:
    // 模拟数据库存储
    std::map<std::string, Account> accounts;
    // 记录最近更新的账户，用于验证
    std::map<std::string, Account> lastUpdatedAccounts;
    int updateCallCount = 0;

    Account findAccount(std::string userID) override {
        if (accounts.find(userID) != accounts.end()) {
            return accounts[userID];
        }
        // 如果找不到，返回默认账户（实际测试中应确保数据已 setup）
        return Account(); 
    }

    void updateAccount(Account account) override {
        lastUpdatedAccounts[account.getCardNo()] = account;
        // 同时更新模拟数据库，以便后续查询能获取最新状态
        accounts[account.getCardNo()] = account;
        updateCallCount++;
    }

    // 辅助方法：设置测试数据
    void setupAccount(const Account& acc) {
        accounts[acc.getCardNo()] = acc;
    }
    
    // 辅助方法：清理状态
    void clear() {
        accounts.clear();
        lastUpdatedAccounts.clear();
        updateCallCount = 0;
    }
};

// ==========================================
// 1. Account 实体类单元测试
// ==========================================

void testConstructorAndGetters() {
    Account acc("12345", 1000);
    expectEq(acc.getCardNo(), std::string("12345"), "cardNo should be 12345");
    expectEq(acc.getBalance(), 1000L, "balance should be 1000");
}

void testDefaultConstructor() {
    Account acc;
    expectEq(acc.getCardNo(), std::string(""), "default cardNo should be empty");
    expectEq(acc.getBalance(), 0L, "default balance should be 0");
}

void testDebitSuccess() {
    Account acc("12345", 1000);
    acc.debit(200);
    expectEq(acc.getBalance(), 800L, "1000 - 200 should be 800");
}

void testDebitExactBalanceToZero() {
    Account acc("12345", 1000);
    acc.debit(1000);
    expectEq(acc.getBalance(), 0L, "debit exact balance should result in 0");
}

void testDebitZeroNoChange() {
    Account acc("12345", 1000);
    acc.debit(0);
    expectEq(acc.getBalance(), 1000L, "debit 0 should not change balance");
}

void testDebitNegativeAmount() {
    Account acc("12345", 1000);
    expectThrowsInvalidArgument([&]() { acc.debit(-1); }, "debit(-1) should throw invalid_argument");
}

void testDebitInsufficientFunds() {
    Account acc("12345", 100);
    expectThrowsRuntimeError([&]() { acc.debit(200); }, "debit beyond balance should throw runtime_error");
}

void testCreditSuccess() {
    Account acc("12345", 1000);
    acc.credit(200);
    expectEq(acc.getBalance(), 1200L, "1000 + 200 should be 1200");
}

void testCreditZeroNoChange() {
    Account acc("12345", 1000);
    acc.credit(0);
    expectEq(acc.getBalance(), 1000L, "credit 0 should not change balance");
}

void testCreditNegativeAmount() {
    Account acc("12345", 1000);
    expectThrowsInvalidArgument([&]() { acc.credit(-1); }, "credit(-1) should throw invalid_argument");
}

// ==========================================
// 2. AccountService 业务逻辑单元测试
// ==========================================

void testDeposit() {
    MockAccountManagement mock;
    AccountService service(&mock);
    
    Account acc("123", 1000);
    mock.setupAccount(acc);

    service.deposit("123", 200);

    // 验证 updateAccount 被调用
    expectEq(mock.updateCallCount, 1, "deposit should call updateAccount once");
    // 验证余额更新正确
    expectEq(mock.lastUpdatedAccounts.count("123"), static_cast<size_t>(1), "deposit should update account 123");
    expectEq(mock.lastUpdatedAccounts["123"].getBalance(), 1200L, "deposit should result in 1200 balance");
}

void testDepositZeroAmount() {
    MockAccountManagement mock;
    AccountService service(&mock);

    mock.setupAccount(Account("123", 1000));
    service.deposit("123", 0);

    expectEq(mock.updateCallCount, 1, "deposit(0) should still persist once");
    expectEq(mock.lastUpdatedAccounts["123"].getBalance(), 1000L, "deposit(0) should not change balance");
}

void testDepositNegativeAmountThrowsAndNoUpdate() {
    MockAccountManagement mock;
    AccountService service(&mock);

    mock.setupAccount(Account("123", 1000));

    auto action = [&]() { service.deposit("123", -1); };
    bool thrown = false;
    try {
        action();
    } catch (const std::invalid_argument&) {
        thrown = true;
    }
    expectTrue(thrown, "deposit(-1) should throw invalid_argument");
    expectEq(mock.updateCallCount, 0, "deposit(-1) should not call updateAccount");
}

void testWithdrawSuccess() {
    MockAccountManagement mock;
    AccountService service(&mock);
    
    Account acc("123", 1000);
    mock.setupAccount(acc);

    service.withdraw("123", 200);

    expectEq(mock.updateCallCount, 1, "withdraw should call updateAccount once");
    expectEq(mock.lastUpdatedAccounts["123"].getBalance(), 800L, "withdraw should result in 800 balance");
}

void testWithdrawZeroAmount() {
    MockAccountManagement mock;
    AccountService service(&mock);

    mock.setupAccount(Account("123", 1000));
    service.withdraw("123", 0);

    expectEq(mock.updateCallCount, 1, "withdraw(0) should still persist once");
    expectEq(mock.lastUpdatedAccounts["123"].getBalance(), 1000L, "withdraw(0) should not change balance");
}

void testWithdrawInsufficientFundsThrowsAndNoUpdate() {
    MockAccountManagement mock;
    AccountService service(&mock);

    mock.setupAccount(Account("123", 100));

    bool thrown = false;
    try {
        service.withdraw("123", 200);
    } catch (const std::runtime_error&) {
        thrown = true;
    }
    expectTrue(thrown, "withdraw with insufficient funds should throw runtime_error");
    expectEq(mock.updateCallCount, 0, "withdraw failure should not call updateAccount");
}

void testWithdrawNegativeAmountThrowsAndNoUpdate() {
    MockAccountManagement mock;
    AccountService service(&mock);

    mock.setupAccount(Account("123", 1000));

    bool thrown = false;
    try {
        service.withdraw("123", -1);
    } catch (const std::invalid_argument&) {
        thrown = true;
    }
    expectTrue(thrown, "withdraw(-1) should throw invalid_argument");
    expectEq(mock.updateCallCount, 0, "withdraw(-1) should not call updateAccount");
}

void testTransferSuccess() {
    MockAccountManagement mock;
    AccountService service(&mock);
    
    Account fromAcc("123", 1000);
    Account toAcc("456", 500);
    mock.setupAccount(fromAcc);
    mock.setupAccount(toAcc);

    service.transfer("123", "456", 200);

    // 验证两个账户都被更新
    expectEq(mock.updateCallCount, 2, "transfer should call updateAccount twice");
    expectEq(mock.lastUpdatedAccounts["123"].getBalance(), 800L, "from account should be 800");
    expectEq(mock.lastUpdatedAccounts["456"].getBalance(), 700L, "to account should be 700");
}

void testTransferBoundaryLimit3000() {
    MockAccountManagement mock;
    AccountService service(&mock);

    mock.setupAccount(Account("123", 5000));
    mock.setupAccount(Account("456", 100));

    service.transfer("123", "456", 3000);

    expectEq(mock.updateCallCount, 2, "transfer(3000) should update both accounts");
    expectEq(mock.lastUpdatedAccounts["123"].getBalance(), 2000L, "from balance should be 5000-3000=2000");
    expectEq(mock.lastUpdatedAccounts["456"].getBalance(), 3100L, "to balance should be 100+3000=3100");
}

void testTransferInsufficientFundsThrowsAndNoUpdate() {
    MockAccountManagement mock;
    AccountService service(&mock);

    mock.setupAccount(Account("123", 100));
    mock.setupAccount(Account("456", 500));

    bool thrown = false;
    try {
        service.transfer("123", "456", 200);
    } catch (const std::runtime_error&) {
        thrown = true;
    }
    expectTrue(thrown, "transfer insufficient funds should throw runtime_error");
    expectEq(mock.updateCallCount, 0, "transfer failure should not call updateAccount");
}

void testTransferNegativeAmountThrowsAndNoUpdate() {
    MockAccountManagement mock;
    AccountService service(&mock);

    mock.setupAccount(Account("123", 1000));
    mock.setupAccount(Account("456", 500));

    bool thrown = false;
    try {
        service.transfer("123", "456", -1);
    } catch (const std::invalid_argument&) {
        thrown = true;
    }
    expectTrue(thrown, "transfer(-1) should throw invalid_argument");
    expectEq(mock.updateCallCount, 0, "transfer(-1) should not call updateAccount");
}

void testTransferLimitExceeded() {
    MockAccountManagement mock;
    AccountService service(&mock);
    
    // 需求：转账金额不能超过 3000
    bool exceptionThrown = false;
    try {
        service.transfer("123", "456", 3001);
    } catch (const std::runtime_error&) {
        exceptionThrown = true;
    }
    expectTrue(exceptionThrown, "transfer(3001) should throw runtime_error");
    expectEq(mock.updateCallCount, 0, "transfer over limit should not call updateAccount");
}

void testInquiry() {
    MockAccountManagement mock;
    AccountService service(&mock);

    mock.setupAccount(Account("123", 4321));
    long balance = service.inquiry("123");
    expectEq(balance, 4321L, "inquiry should return current balance");
    expectEq(mock.updateCallCount, 0, "inquiry should not call updateAccount");
}

int main() {
    std::cout << "Running tests..." << std::endl;

    runTest(testConstructorAndGetters, "AccountTest.ConstructorAndGetters");
    runTest(testDefaultConstructor, "AccountTest.DefaultConstructor");
    runTest(testDebitSuccess, "AccountTest.DebitSuccess");
    runTest(testDebitExactBalanceToZero, "AccountTest.DebitExactBalanceToZero");
    runTest(testDebitZeroNoChange, "AccountTest.DebitZeroNoChange");
    runTest(testDebitInsufficientFunds, "AccountTest.DebitInsufficientFunds");
    runTest(testCreditSuccess, "AccountTest.CreditSuccess");
    runTest(testCreditZeroNoChange, "AccountTest.CreditZeroNoChange");
    
    runTest(testDeposit, "AccountServiceTest.Deposit");
    runTest(testDepositZeroAmount, "AccountServiceTest.DepositZeroAmount");
    runTest(testDepositNegativeAmountThrowsAndNoUpdate, "AccountServiceTest.DepositNegativeAmountThrowsAndNoUpdate");
    runTest(testWithdrawSuccess, "AccountServiceTest.WithdrawSuccess");
    runTest(testWithdrawZeroAmount, "AccountServiceTest.WithdrawZeroAmount");
    runTest(testWithdrawInsufficientFundsThrowsAndNoUpdate, "AccountServiceTest.WithdrawInsufficientFundsThrowsAndNoUpdate");
    runTest(testWithdrawNegativeAmountThrowsAndNoUpdate, "AccountServiceTest.WithdrawNegativeAmountThrowsAndNoUpdate");
    runTest(testTransferSuccess, "AccountServiceTest.TransferSuccess");
    runTest(testTransferBoundaryLimit3000, "AccountServiceTest.TransferBoundaryLimit3000");
    runTest(testTransferInsufficientFundsThrowsAndNoUpdate, "AccountServiceTest.TransferInsufficientFundsThrowsAndNoUpdate");
    runTest(testTransferNegativeAmountThrowsAndNoUpdate, "AccountServiceTest.TransferNegativeAmountThrowsAndNoUpdate");
    runTest(testTransferLimitExceeded, "AccountServiceTest.TransferLimitExceeded");
    runTest(testInquiry, "AccountServiceTest.Inquiry");

    std::cout << "All tests completed." << std::endl;
    return 0;
}
