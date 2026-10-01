#include <iostream>  
#include <string>  

using namespace std;

// 学生结构体  
struct Student {
    string id;
    string name;
};

class StudentList {
private:
    Student* students; // 动态数组  
    int capacity;      // 当前容量  
    int total;        // 当前学生数量  

    void resize() {
        // 扩容  
        capacity *= 2; // 每次扩容双倍  
        Student* newStudents = new Student[capacity];
        for (int i = 0; i < total; ++i) {
            newStudents[i] = students[i];
        }
        delete[] students; // 释放旧数组  
        students = newStudents;
    }

public:
    StudentList() : capacity(10), total(0) {
        students = new Student[capacity]; // 初始化容量为10  
    }

    ~StudentList() {
        delete[] students; // 释放动态数组内存  
    }

    void insert(int index, const string& id, const string& name,int flag) {
        if (index < 1 || index > total + 1) {
            cout << -1 << endl;
            return;
        }
        if (total >= capacity) {
            resize(); // 当学生数量达到容量上限时，进行扩容  
        }

        for (int i = total; i >= index; --i) {
            students[i] = students[i - 1]; // 后移元素  
        }

        students[index - 1] = { id, name }; // 插入新学生  
        total++;
        if(flag==1)
            cout << 0 << endl; // 插入成功  
    }

    void remove(int index) {
        if (index < 1 || index > total) {
            cout << -1 << endl;
            return;
        }

        for (int i = index - 1; i < total - 1; ++i) {
            students[i] = students[i + 1]; // 前移元素  
        }

        total--;
        cout << 0 << endl; // 删除成功  
    }

    void check_by_id(const string& id) {
        for (int i = 0; i < total; i++) {
            if (students[i].id == id) {
                cout << i + 1 << " " << students[i].id << " " << students[i].name << endl;
                return;
            }
        }
        cout << -1 << endl; // 未找到  
    }

    void check_by_name(const string& name) {
        for (int i = 0; i < total; i++) {
            if (students[i].name == name) {
                cout << i + 1 << " " << students[i].id << " " << students[i].name << endl;
                return;
            }
        }
        cout << -1 << endl; // 未找到  
    }

    int size() {
        return total;
    }
};

int main() {
    int n;
    cin >> n;

    StudentList studentList;

    for (int i = 0; i < n; i++) {
        string id, name;
        cin >> id >> name;
        studentList.insert(i + 1, id, name,0); // insert into the list  
    }

    string cmd;
    while (true) {
        cin >> cmd;
        if (cmd == "end") {
            cout << studentList.size() << endl;
            break;
        }
        else if (cmd == "insert") {
            int index;
            string id, name;
            cin >> index >> id >> name;
            studentList.insert(index, id, name,1);
        }
        else if (cmd == "remove") {
            int index;
            cin >> index;
            studentList.remove(index);
        }
        else if (cmd == "check") {
            string subCmd;
            cin >> subCmd;
            if (subCmd == "no") {
                string id;
                cin >> id;
                studentList.check_by_id(id);
            }
            else if (subCmd == "name") {
                string name;
                cin >> name;
                studentList.check_by_name(name);
            }
        }
    }

    return 0;
}


// 学生结构体  
struct Student {
    string id;    // 学生 ID  
    string name;  // 学生姓名  
};

// 学生列表类,用顺序表实现
class StudentList {
private:
    Student* students; // 动态数组，用于存储学生信息  
    int capacity;      // 当前数组容量  
    int total;        // 当前学生数量  

    /**
     * @brief 扩容函数
     *        当学生数量达到容量上限时，进行数组扩容。
     */
    void resize() {
        capacity *= 2; // 每次扩容双倍
        // 申请新的数组空间,并将旧数组中的元素复制到新数组中
    }

public:
    // 构造函数  
    StudentList() : capacity(10), total(0) {
        students = new Student[capacity]; // 初始化容量为10  
    }
    // 析构函数  
    ~StudentList() {
        delete[] students; // 释放动态数组内存  
    }
};

/**
 * @brief 插入学生
 * @param index  插入位置（1-based）
 * @param id     学生 ID
 * @param name   学生姓名
 * @param flag   插入成功标志（1 表示成功）
 */
void insert(int index, const string& id, const string& name, int flag) {
    if (index < 1 || index > total + 1) {
        cout << -1 << endl; // 索引无效  
        return;
    }
    if (total >= capacity) {
        resize(); // 达到容量上限时，进行扩容  
    }

    // 后移元素以腾出插入位置  
    // 插入新学生
}

/**
 * @brief 删除学生
 * @param index  删除位置（1-based）
 */
void remove(int index) {
    if (index < 1 || index > total) {
        cout << -1 << endl; // 索引无效  
        return;
    }

    // 前移元素以填补被删除位置

    total--; // 更新学生数量  
    cout << 0 << endl; // 删除成功  
}

/**
 * @brief 根据 ID 检查学生
 * @param id 学生 ID
 */
void check_by_id(const string& id) {
    for (int i = 0; i < total; i++) {
        if (students[i].id == id) {  // 找到学生
            // 输出找到的学生信息 
        }
    }
    cout << -1 << endl; // 未找到  
}

/**
 * @brief 根据姓名检查学生
 * @param name 学生姓名
 */
void check_by_name(const string& name) {
    for (int i = 0; i < total; i++) {
        if (students[i].name == name) {  // 找到学生
            //输出找到的学生信息
        }
    }
    cout << -1 << endl; // 未找到  
}

/**
 * @brief 获取当前学生数量
 * @return 当前学生数量
 */
int size() {
    return total; // 返回总学生数量  
}