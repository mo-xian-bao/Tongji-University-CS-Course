#include <iostream>
#include <cstring>

using namespace std;

struct instruct {
    int action;
    int index = 0;
    char number[100] = { 0 };
    char name[100] = { 0 };
    instruct* next;
    instruct(int x) : action(x), next(nullptr) {}  // 构造函数
};


class SeqList {
private:
    struct student {
        char number[100] = { 0 };
        char name[100] = { 0 };
    };
    student* data;          // 数据存储区  
    int size;         // 当前表中元素的数量  
    int capacity;     // 顺序表的容量  

    void resize(int new_capacity) { // 改变顺序表的容量  
        student* new_data = new student[new_capacity];
        for (int i = 0; i < size; i++) {
            new_data[i] = data[i];
        }
        delete[] data;
        data = new_data;
        capacity = new_capacity;
    }

public:
    SeqList(int initial_capacity = 10010) : size(0), capacity(initial_capacity) {
        data = new student[capacity];
    }

    ~SeqList() {
        delete[] data;
    }

    void insert(int index, const char number[], const char name[], int note = 1) {
        struct student value;
        strcpy(value.number, number);
        strcpy(value.name, name);
        if (note == 1) {
            if (index < 0 || index > size)
            {
                cout << "-1" << endl;
                return;
            }
            else
                cout << "0" << endl;
        }
        if (size == capacity) {
            resize(capacity * 2); // 容量不足，扩展容量  
        }
        for (int i = size; i > index; i--) {
            data[i] = data[i - 1]; // 移动元素  
        }
        data[index] = value; // 插入新元素  
        size++;
    }

    void create_list(int n) {
        for (int i = 0; i < n; i++) {
            struct student a;
            cin >> a.number >> a.name;
            insert(size, a.number, a.name, 0);
        }
    }

    void remove(int index) {
        if (index < 0 || index >= size)
        {
            cout << "-1" << endl;
            return;
        }
        else
            cout << "0" << endl;
        for (int i = index; i < size - 1; i++) {
            data[i] = data[i + 1]; // 移动元素  
        }
        size--;
        /*如有节省空间需要可加*/
        //if (size < capacity / 4) {
        //    resize(capacity / 2);
        //}
    }

    void check_name(char* name) {
        int have_found = 0;
        for (int i = 0; i < size; i++) {
            if (strcmp(data[i].name, name) == 0) {
                have_found = 1;
                cout << i + 1 << ' ' << data[i].number << ' ' << data[i].name << endl;
                break;
            }
        }
        if (!have_found)
            cout << -1 << endl;
    }

    void check_number(char* number) {
        int have_found = 0;
        for (int i = 0; i < size; i++) {
            if (strcmp(data[i].number, number) == 0) {
                have_found = 1;
                cout << i + 1 << ' ' << data[i].number << ' ' << data[i].name << endl;
                break;
            }
        }
        if (!have_found)
            cout << -1 << endl;
    }

    int getSize() const {
        return size;
    }

};

int main() {
    SeqList stu_list;
    int n;
    cin >> n;
    stu_list.create_list(n);
    instruct* ans = new instruct(0);
    instruct* p = ans;
    while (1) {
        char ins[10] = { 0 };
        cin >> ins;
        if (ins[0] == 'i') {
            struct instruct* q = new instruct(1);
            cin >> q->index >> q->number >> q->name;
            p->next = q;
            p = p->next;
        }
        else if (ins[0] == 'r') {
            struct instruct* q = new instruct(2);
            cin >> q->index;
            p->next = q;
            p = p->next;
        }
        else if (ins[0] == 'e')
            break;
        else {
            char ins_sub[10] = { 0 };
            cin >> ins_sub;
            if (ins_sub[1] == 'a') {
                struct instruct* q = new instruct(3);
                cin >> q->name;
                p->next = q;
                p = p->next;
            }
            else {
                struct instruct* q = new instruct(4);
                cin >> q->number;
                p->next = q;
                p = p->next;
            }
        }
    }

    p = ans->next;
    while (p != nullptr) {
        if (p->action == 1)
            stu_list.insert(p->index - 1, p->number, p->name);
        else if (p->action == 2)
            stu_list.remove(p->index - 1);
        else if (p->action == 3)
            stu_list.check_name(p->name);
        else
            stu_list.check_number(p->number);
        p = p->next;
    }

    cout << stu_list.getSize() << endl;
    return 0;
}
