#include <iostream>
#include <fstream>
#include <cstring>
#include <iomanip>
using namespace std;

int main()
{
    fstream file("test.txt", ios::in | ios::binary);
    if (!file)
    {
        cout << "File not found." << endl;
        return 1;
    }

    unsigned char c;
    while ((c = file.get()) != EOF /*&& file.eof() == false*/)
    {
        cout << setw(2) << setfill('0') << hex << (int)c << " ";
    }

    file.close();
    return 0;
}
