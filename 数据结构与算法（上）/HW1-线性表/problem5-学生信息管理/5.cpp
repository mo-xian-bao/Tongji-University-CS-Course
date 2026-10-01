#include <iostream>  
#include <cstring>  
using namespace std;

const int MAX_STUDENTS = 20000;
string name_table[MAX_STUDENTS];
string id_table[MAX_STUDENTS];
int total = 0;

void insert(int index, const string& id, const string& name)
{
    if (index < 1 || index > total + 1)
    {
        cout << -1 << endl;
        return;
    }

    // 移动元素  
    for (int i = total-1; i >= index - 1; i--)
    {
        name_table[i + 1] = name_table[i];
        id_table[i + 1] = id_table[i];
    }

    name_table[index - 1] = name;
    id_table[index - 1] = id;
    total++;
    cout << 0 << endl;
    return;
}

void remove(int index)
{
    if (index < 1 || index > total)
    {
        cout << -1 << endl;
        return;
    }

    // 移动元素  
    for (int i = index - 1; i < total - 1; i++)
    {
        name_table[i] = name_table[i + 1];
        id_table[i] = id_table[i + 1];
    }
    total--;
    cout << 0 << endl;
    return;
}

void check_by_id(const string& id)
{
    for (int i = 0; i < total; i++) {
        if (id_table[i] == id) {
            cout << i + 1 << " " << id_table[i] << " " << name_table[i] << endl;
            return;
        }
    }
    cout << -1 << endl;
    return;
}

void check_by_name(const string& name)
{
    for (int i = 0; i < total; i++) {
        if (name_table[i] == name) {
            cout << i + 1 << " " << id_table[i] << " " << name_table[i] << endl;
            return;
        }
    }
    cout << -1 << endl;
    return;
}

int main()
{
    int n;
    cin >> n;

    string id, name;
    for (int i = 0; i < n; i++) {
        cin >> id >> name;
        name_table[i] = name;
        id_table[i] = id;
        total++;
    }

    int index;
    while (true) {
        string cmd;
        cin >> cmd;
        if (cmd == "end") {
            cout << total << endl;
            break;
        }
        else if (cmd == "insert") {
            cin >> index >> id >> name;
            insert(index, id, name);
        }
        else if (cmd == "remove") {
            cin >> index;
            remove(index);
        }
        else if (cmd == "check") {
            string cmd2;
            cin >> cmd2;
            if (cmd2 == "no") {
                cin >> id;
                check_by_id(id);
            }
            else if (cmd2 == "name") {
                cin >> name;
                check_by_name(name);
            }
        }
    }

    return 0;
}