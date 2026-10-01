#include <iostream>  
#include <string>  

using namespace std;

// 节点结构  
struct Node {
    string id;
    string name;
    Node* next;

    Node(string id, string name) : id(id), name(name), next(nullptr) {}
};

class StudentList {
private:
    Node* head;
    int total;

public:
    StudentList() : head(nullptr), total(0) {}

    void insert(int index, const string& id, const string& name,int mode) {
        if (index < 1 || index > total + 1) {
            cout << -1 << endl;
            return;
        }

        Node* newNode = new Node(id, name);
        if (index == 1) {
            newNode->next = head;
            head = newNode;
        }
        else {
            Node* current = head;
            for (int i = 1; i < index - 1; i++) {
                current = current->next;
            }
            newNode->next = current->next;
            current->next = newNode;
        }
        total++;
        if(mode==1)
            cout << 0 << endl;
    }

    void remove(int index) {
        if (index < 1 || index > total) {
            cout << -1 << endl;
            return;
        }

        Node* toDelete;
        if (index == 1) {
            toDelete = head;
            head = head->next;
        }
        else {
            Node* current = head;
            for (int i = 1; i < index - 1; i++) {
                current = current->next;
            }
            toDelete = current->next;
            current->next = toDelete->next;
        }
        delete toDelete;
        total--;
        cout << 0 << endl;
    }

    void check_by_id(const string& id) {
        Node* current = head;
        for (int i = 1; current != nullptr; i++, current = current->next) {
            if (current->id == id) {
                cout << i << " " << current->id << " " << current->name << endl;
                return;
            }
        }
        cout << -1 << endl;
    }

    void check_by_name(const string& name) {
        Node* current = head;
        for (int i = 1; current != nullptr; i++, current = current->next) {
            if (current->name == name) {
                cout << i << " " << current->id << " " << current->name << endl;
                return;
            }
        }
        cout << -1 << endl;
    }

    int size() {
        return total;
    }

    ~StudentList() {
        while (head != nullptr) {
            Node* temp = head;
            head = head->next;
            delete temp;
        }
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