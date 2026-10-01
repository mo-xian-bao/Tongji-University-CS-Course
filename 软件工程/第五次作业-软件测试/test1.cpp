#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <stdexcept>
#include <cassert>
#include <cstdlib> 

using namespace std;

// ==========================================
// 1. 领域实体: Account
// ==========================================
class Account {
private:
    string cardNo;
    long balance;

public:
    Account(string cardNo, long initBalance) : cardNo(cardNo), balance(initBalance) {
        if (initBalance < 0) throw invalid_argument("初始化余额不能为负");
    }

    string getCardNo() const { return cardNo; }
    
    long getBalance() const { return balance; }

    // 存款
    void credit(long amount) {
        if (amount <= 0) throw invalid_argument("存款金额必须大于0");
        balance += amount;
    }

    // 取款
    void debit(long amount) {
        if (amount <= 0) throw invalid_argument("取款金额必须大于0");
        if (balance < amount) throw runtime_error("余额不足");
        balance -= amount;
    }
};

// ==========================================
// 2. 接口: AccountManagement
// ==========================================
class AccountManagement {
public:
    virtual Account* findAccount(string userID) = 0;
    virtual void updateAccount(Account* account) = 0;
    virtual ~AccountManagement() {}
};

// ==========================================
// 3. 基础设施: 模拟数据库 (Mock Database)
// ==========================================
class MockAccountDatabase : public AccountManagement {
private:
    map<string, Account*> db;

public:
    void insertAccount(Account* account) {
        // C++98 写法：手动检查是否存在
        if (db.find(account->getCardNo()) != db.end()) {
             delete db[account->getCardNo()]; 
        }
        db[account->getCardNo()] = account;
    }

    // 去掉 override 关键字 (C++98 不支持)
    Account* findAccount(string cardNo) {
        if (db.find(cardNo) != db.end()) {
            return db[cardNo];
        }
        return NULL; // 使用 NULL 替代 nullptr
    }

    void updateAccount(Account* account) {
        if (account && db.find(account->getCardNo()) != db.end()) {
            db[account->getCardNo()] = account; 
        }
    }
    
    // 清空内存
    void clear() {
        // C++98 写法：使用迭代器遍历
        for (map<string, Account*>::iterator it = db.begin(); it != db.end(); ++it) {
            delete it->second;
        }
        db.clear();
    }

    ~MockAccountDatabase() {
        clear();
    }
};

// ==========================================
// 4. 服务层: AccountService
// ==========================================
class AccountService {
private:
    AccountManagement* accountManager;

public:
    AccountService(AccountManagement* am) : accountManager(am) {}

    void deposit(string cardNo, long amount) {
        Account* acc = accountManager->findAccount(cardNo);
        if (!acc) throw runtime_error("账户不存在: " + cardNo);
        
        acc->credit(amount);
        accountManager->updateAccount(acc);
    }

    void withdraw(string cardNo, long amount) {
        Account* acc = accountManager->findAccount(cardNo);
        if (!acc) throw runtime_error("账户不存在: " + cardNo);

        acc->debit(amount);
        accountManager->updateAccount(acc);
    }

    long inquiry(string cardNo) {
        Account* acc = accountManager->findAccount(cardNo);
        if (!acc) throw runtime_error("账户不存在: " + cardNo);
        
        return acc->getBalance();
    }

    void transfer(string fromCardNo, string toCardNo, long amount) {
        if (fromCardNo == toCardNo) throw invalid_argument("不能向自己转账");

        Account* src = accountManager->findAccount(fromCardNo);
        Account* dest = accountManager->findAccount(toCardNo);

        if (!src) throw runtime_error("转出账户不存在");
        if (!dest) throw runtime_error("转入账户不存在");

        // 事务模拟
        src->debit(amount); 
        dest->credit(amount);

        accountManager->updateAccount(src);
        accountManager->updateAccount(dest);
    }
};

// ==========================================
// 5. 测试套件
// ==========================================

#define TEST_EXCEPTION(statement, exceptionType, expectedMsg, testName) \
    try { \
        statement; \
        cout << "[FAIL] " << testName << " (未抛出预期异常)" << endl; \
        assert(false); \
    } catch (const exceptionType& e) { \
        string msg = e.what(); \
        if (msg.find(expectedMsg) != string::npos) { \
            cout << "[PASS] " << testName << endl; \
        } else { \
            cout << "[FAIL] " << testName << " (异常消息不匹配: " << msg << ")" << endl; \
            assert(false); \
        } \
    } catch (...) { \
        cout << "[FAIL] " << testName << " (抛出了错误的异常类型)" << endl; \
        assert(false); \
    }

// 辅助函数：重置数据
void resetData(MockAccountDatabase* db) {
    db->clear();
    db->insertAccount(new Account("A1", 1000));
    db->insertAccount(new Account("A2", 500));
    db->insertAccount(new Account("ZERO", 0));
}

void runTests() {
    cout << "========= 单元测试 =========" << endl;

    MockAccountDatabase* db = new MockAccountDatabase();
    AccountService service(db);

    // --- 组1: 正常业务流程 ---
    resetData(db);
    cout << "\n--- Group 1: 正常业务流程 ---" << endl;
    
    // Case 1: 正常存款
    service.deposit("A1", 100);
    assert(service.inquiry("A1") == 1100);
    cout << "[PASS] 正常存款" << endl;

    // Case 2: 正常取款
    service.withdraw("A1", 100);
    assert(service.inquiry("A1") == 1000);
    cout << "[PASS] 正常取款" << endl;

    // Case 3: 正常转账
    service.transfer("A1", "A2", 200);
    assert(service.inquiry("A1") == 800);
    assert(service.inquiry("A2") == 700);
    cout << "[PASS] 正常转账" << endl;

    // --- 组2: 边界条件测试 ---
    resetData(db);
    cout << "\n--- Group 2: 边界条件测试 ---" << endl;

    // Case 4: 取光余额
    service.withdraw("A2", 500);
    assert(service.inquiry("A2") == 0);
    cout << "[PASS] 边界取款 (取光)" << endl;

    // Case 5: 零余额账户操作
    service.deposit("ZERO", 50);
    assert(service.inquiry("ZERO") == 50);
    cout << "[PASS] 零余额账户操作" << endl;

    // --- 组3: 输入合法性测试 (Negative/Zero) ---
    resetData(db);
    cout << "\n--- Group 3: 输入合法性测试 ---" << endl;

    // Case 6: 存款负数
    TEST_EXCEPTION(service.deposit("A1", -100), invalid_argument, "存款金额必须大于0", "存款负数拦截");

    // Case 7: 存款0元
    TEST_EXCEPTION(service.deposit("A1", 0), invalid_argument, "存款金额必须大于0", "存款0元拦截");

    // Case 8: 取款负数
    TEST_EXCEPTION(service.withdraw("A1", -50), invalid_argument, "取款金额必须大于0", "取款负数拦截");

    // Case 9: 初始化余额为负 (构造函数)
    // 注意：在宏中使用对象声明需要小心，这里为了简单单独写 try-catch 或者利用临时对象
    try {
        Account bad("BAD", -100);
        assert(false);
    } catch (const invalid_argument& e) {
        cout << "[PASS] 账户初始化负余额拦截" << endl;
    }

    // --- 组4: 业务逻辑异常测试 ---
    resetData(db);
    cout << "\n--- Group 4: 业务逻辑异常测试 ---" << endl;

    // Case 10: 余额不足取款
    TEST_EXCEPTION(service.withdraw("A2", 501), runtime_error, "余额不足", "余额不足取款");

    // Case 11: 余额不足转账
    TEST_EXCEPTION(service.transfer("A2", "A1", 600), runtime_error, "余额不足", "余额不足转账");
    
    // 验证原子性
    assert(service.inquiry("A2") == 500); 
    assert(service.inquiry("A1") == 1000);
    cout << "[PASS] 转账事务原子性验证" << endl;

    // --- 组5: 账户存在性与关联测试 ---
    resetData(db);
    cout << "\n--- Group 5: 账户存在性与关联测试 ---" << endl;

    // Case 12: 查询不存在的账户
    TEST_EXCEPTION(service.inquiry("GHOST"), runtime_error, "账户不存在", "查询不存在账户");

    // Case 13: 转出账户不存在
    TEST_EXCEPTION(service.transfer("GHOST", "A1", 100), runtime_error, "转出账户不存在", "转出账户不存在");

    // Case 14: 转入账户不存在
    TEST_EXCEPTION(service.transfer("A1", "GHOST", 100), runtime_error, "转入账户不存在", "转入账户不存在");

    // Case 15: 自我转账
    TEST_EXCEPTION(service.transfer("A1", "A1", 100), invalid_argument, "不能向自己转账", "自我转账拦截");

    // Case 16: 复杂操作链
    service.deposit("A1", 100); // 1100
    service.withdraw("A1", 50); // 1050
    service.transfer("A1", "A2", 50); // A1: 1000, A2: 550
    assert(service.inquiry("A1") == 1000);
    cout << "[PASS] 复杂操作链后状态一致性" << endl;

    delete db;
    cout << "\n========= 所有 16 个测试用例通过 =========" << endl;
}

int main() {
    runTests();
    return 0;
}