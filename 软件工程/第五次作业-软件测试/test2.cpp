#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <stdexcept>
#include <cassert>
#include <cstdlib> // for NULL

using namespace std;

// ==========================================
// 1. Domain Entity: Account
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

    void credit(long amount) {
        if (amount <= 0) throw invalid_argument("存款金额必须大于0");
        balance += amount;
    }

    void debit(long amount) {
        if (amount <= 0) throw invalid_argument("取款金额必须大于0");
        if (balance < amount) throw runtime_error("余额不足");
        balance -= amount;
    }
};

// ==========================================
// 2. Interface: AccountManagement
// ==========================================
class AccountManagement {
public:
    virtual Account* findAccount(string userID) = 0;
    virtual void updateAccount(Account* account) = 0;
    virtual ~AccountManagement() {}
};

// ==========================================
// 3. Infrastructure: Mock Database
// ==========================================
class MockAccountDatabase : public AccountManagement {
private:
    map<string, Account*> db;

public:
    void insertAccount(Account* account) {
        // C++98 style: check existence
        if (db.find(account->getCardNo()) != db.end()) {
             delete db[account->getCardNo()]; 
        }
        db[account->getCardNo()] = account;
    }

    Account* findAccount(string cardNo) {
        if (db.find(cardNo) != db.end()) {
            return db[cardNo];
        }
        return NULL; // C++98 use NULL
    }

    void updateAccount(Account* account) {
        if (account && db.find(account->getCardNo()) != db.end()) {
            db[account->getCardNo()] = account; 
        }
    }
    
    void clear() {
        for (map<string, Account*>::iterator it = db.begin(); it != db.end(); ++it) {
            delete it->second;
        }
        db.clear();
    }

    ~MockAccountDatabase() { clear(); }
};

// ==========================================
// 4. Service Layer: AccountService
// ==========================================
class AccountService {
private:
    AccountManagement* accountManager;
    long TRANSFER_LIMIT; 

public:
    AccountService(AccountManagement* am) : accountManager(am), TRANSFER_LIMIT(3000) {}

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
        
        if (amount > TRANSFER_LIMIT) {
            throw runtime_error("转账金额超过单笔限额 (Max: 3000)");
        }

        Account* src = accountManager->findAccount(fromCardNo);
        Account* dest = accountManager->findAccount(toCardNo);

        if (!src) throw runtime_error("转出账户不存在");
        if (!dest) throw runtime_error("转入账户不存在");

        src->debit(amount); 
        dest->credit(amount);

        accountManager->updateAccount(src);
        accountManager->updateAccount(dest);
    }
};

// ==========================================
// 5. Test Suite (C++98 Compatible)
// ==========================================

// 使用宏来简化异常测试 (替代 C++11 Lambda)
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
            cout << "[FAIL] " << testName << " (异常消息: " << msg << ")" << endl; \
            assert(false); \
        } \
    } catch (...) { \
        cout << "[FAIL] " << testName << " (错误异常类型)" << endl; \
        assert(false); \
    }

// 辅助函数：重置数据
void resetData(MockAccountDatabase* db) {
    db->clear();
    db->insertAccount(new Account("A1", 1000));
    db->insertAccount(new Account("A2", 500));
    db->insertAccount(new Account("RICH", 10000)); 
}

void runTests() {
    cout << "========= 单元测试 (C++98 兼容版) =========" << endl;

    MockAccountDatabase* db = new MockAccountDatabase();
    AccountService service(db);

    // --- 基础功能测试 ---
    resetData(db);
    service.deposit("A1", 100);
    assert(service.inquiry("A1") == 1100);
    
    service.withdraw("A1", 100);
    assert(service.inquiry("A1") == 1000);
    
    service.transfer("A1", "A2", 200);
    assert(service.inquiry("A1") == 800);
    assert(service.inquiry("A2") == 700);
    cout << "[PASS] 基础功能回归测试通过" << endl;

    // --- 限额测试 ---
    cout << "\n--- Group: 转账限额测试 ---" << endl;
    
    resetData(db);

    // Case 1: 3000 (成功)
    try {
        service.transfer("RICH", "A1", 3000);
        assert(service.inquiry("RICH") == 7000);
        cout << "[PASS] 限额边界测试 (转账 3000 成功)" << endl;
    } catch (...) {
        assert(false);
    }

    // Case 2: 3001 (失败)
    TEST_EXCEPTION(service.transfer("RICH", "A1", 3001), runtime_error, "超过单笔限额", "限额拦截测试 (3001)");

    // Case 3: 余额不足优先于限额
    TEST_EXCEPTION(service.transfer("A2", "A1", 600), runtime_error, "余额不足", "余额不足检查");

    delete db;
    cout << "\n========= 所有测试通过 =========" << endl;
}

int main() {
    runTests();
    return 0;
}