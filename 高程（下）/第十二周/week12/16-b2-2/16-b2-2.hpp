/* 2351520 毛星博 计拔 */
#include <cstring>
#include <iostream>
#include <string>

using namespace std;

template <typename T, int R, int C>
class matrix {
private:
    T* value;

public:
    matrix();
    ~matrix();
    matrix(matrix<T, R, C>& m);  //拷贝构造函数，确保深拷贝
    matrix operator+(const matrix& m);
    matrix& operator=(const matrix& m);
    friend ostream& operator<<(ostream& out, const matrix<T, R, C>& m)
    {
        for (int i = 0; i < R; i++) {
            for (int j = 0; j < C; j++) {
                out << m.value[i * C + j] << " ";
            }
            out << endl;
        }
        return out;
    }
    friend istream& operator>>(istream& in, matrix<T, R, C>& m)
    {
        for (int i = 0; i < R; i++) {
            for (int j = 0; j < C; j++) {
                in >> m.value[i * C + j];
            }
        }
        return in;
    }
};

template <typename T, int R, int C>
matrix<T, R, C>::matrix()
{
    value = new(nothrow) T[R * C];
    if (value == nullptr) {
        throw bad_alloc();
    }
}

template <typename T, int R, int C>
matrix<T, R, C>::~matrix()
{
    delete[] value;
}

template <typename T, int R, int C>
matrix<T, R, C>::matrix(matrix<T, R, C>& m)
{
    value = new T[R * C];
    for (int i = 0; i < R * C; ++i) {
        value[i] = m.value[i];  
    }
}

template <typename T, int R, int C>
matrix<T, R, C> matrix<T, R, C>::operator+(const matrix<T, R, C>& m)
{
    matrix<T, R, C> result;
    for (int i = 0; i < R; i++) {
        for (int j = 0; j < C; j++) {
            result.value[i * C + j] = value[i * C + j] + m.value[i * C + j];
        }
    }
    return result;
}

template <typename T, int R, int C>
matrix<T, R, C>& matrix<T, R, C>::operator=(const matrix& m)
{
    if (this == &m) {
        return *this;
    }
    T* new_value = new (nothrow) T[R * C];
    if (new_value == nullptr) {
        throw bad_alloc();
    }
    for (int i = 0; i < R * C; ++i) {
        new_value[i] = m.value[i];  
    }
    delete[] value;
    value = new_value;
    return *this;
}
