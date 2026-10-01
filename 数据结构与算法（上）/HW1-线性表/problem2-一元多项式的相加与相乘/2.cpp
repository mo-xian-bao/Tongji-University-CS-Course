#include <iostream>  
#include <cstdlib>  

struct Term { //用结构体表示多项式的项（从低到高的次幂）
    int coeff; // 系数  
    int exp;   // 指数  
    Term* next;
};

// 创建一个新项，并将其插入到链表中，按指数递增排序
Term* createTerm(int coeff, int exp) {
    Term* newTerm = new Term;  // 创建新项
    newTerm->coeff = coeff;  // 系数
    newTerm->exp = exp;  // 指数
    newTerm->next = nullptr;  // 新项的下一项指针置为空
    return newTerm;  // 返回新项的指针
}

// 将项插入到链表中，按指数递增排序  
void insertTerm(Term*& poly, int coeff, int exp) {
    Term* newTerm = createTerm(coeff, exp);
    if (!poly || poly->exp > exp) {  // 如果链表为空或指数小于等于链表中最高指数，则直接插入
        newTerm->next = poly;
        poly = newTerm;
    }
    else {
        Term* curr = poly;
        while (curr->next && curr->next->exp < exp) {
            curr = curr->next;
        }
        if (curr->next && curr->next->exp == exp) {
            // 合并相同指数的项  
            curr->next->coeff += coeff;
            if (curr->next->coeff == 0) {
                // 如果系数为0，移除该项  
                Term* temp = curr->next;
                curr->next = temp->next;
                delete temp;
            }
            delete newTerm;
        }
        else {
            newTerm->next = curr->next;
            curr->next = newTerm;
        }
    }
}

// 打印多项式  
void printPolynomial(Term* poly) {
    Term* curr = poly;
    bool first = true;
    while (curr) {
        if (!first && curr->coeff > 0) {
            std::cout << " ";
        }
        std::cout << curr->coeff;
            
        std::cout << " " << curr->exp;
        
        first = false;
        curr = curr->next;
    }
    std::cout << std::endl;
}

// 加法运算  
Term* addPolynomials(Term* poly1, Term* poly2) {
    Term* result = nullptr;
    Term* curr1 = poly1;
    Term* curr2 = poly2;
    while (curr1 && curr2) {
        if (curr1->exp < curr2->exp) {
            insertTerm(result, curr1->coeff, curr1->exp);
            curr1 = curr1->next;
        }
        else if (curr1->exp > curr2->exp) {
            insertTerm(result, curr2->coeff, curr2->exp);
            curr2 = curr2->next;
        }
        else {
            insertTerm(result, curr1->coeff + curr2->coeff, curr1->exp);
            curr1 = curr1->next;
            curr2 = curr2->next;
        }
    }
    while (curr1) {
        insertTerm(result, curr1->coeff, curr1->exp);
        curr1 = curr1->next;
    }
    while (curr2) {
        insertTerm(result, curr2->coeff, curr2->exp);
        curr2 = curr2->next;
    }
    return result;
}

// 乘法运算  
Term* multiplyPolynomials(Term* poly1, Term* poly2) {
    Term* result = nullptr;
    Term* curr1 = poly1;
    while (curr1) {
        Term* curr2 = poly2;
        while (curr2) {
            insertTerm(result, curr1->coeff * curr2->coeff, curr1->exp + curr2->exp);
            curr2 = curr2->next;
        }
        curr1 = curr1->next;
    }
    return result;
}

// 清理链表  
void clearPolynomial(Term*& poly) {
    while (poly) {
        Term* temp = poly;
        poly = poly->next;
        delete temp;
    }
}

int main() {
    int m, n, op;
    std::cin >> m;
    Term* poly1 = nullptr;
    for (int i = 0; i < m; ++i) {
        int coeff, exp;
        std::cin >> coeff >> exp;
        insertTerm(poly1, coeff, exp);
    }

    std::cin >> n;
    Term* poly2 = nullptr;
    for (int i = 0; i < n; ++i) {
        int coeff, exp;
        std::cin >> coeff >> exp;
        insertTerm(poly2, coeff, exp);
    }

    std::cin >> op;

    if (op == 0 || op == 2) {
        Term* sum = addPolynomials(poly1, poly2);
        printPolynomial(sum);
        if (op == 2) {
            std::cout << std::endl;
        }
        clearPolynomial(sum);
    }

    if (op == 1 || op == 2) {
        Term* product = multiplyPolynomials(poly1, poly2);
        printPolynomial(product);
        clearPolynomial(product);
    }

    clearPolynomial(poly1);
    clearPolynomial(poly2);

    return 0;
}

// 加法运算,将两个多项式相加，返回结果多项式的头指针  
Term* addPolynomials(Term* poly1, Term* poly2) {  //两个多项式的头指针poly1和poly2
    Term* result = nullptr;
    Term* curr1 = poly1;
    Term* curr2 = poly2;
    while (两个多项式都不为空) {
        if (curr1的指数小于curr2的指数) {
            将curr1的项插入到结果链表中
        }
        else if (curr1的指数大于curr2的指数) {
            将curr2的项插入到结果链表中
        }
        else {  //如果curr1的指数等于curr2的指数
            将curr1和curr2的项相加，并插入到结果链表中
        }
    }
    while (curr1) {  // 如果poly1还有项未处理
        将curr1的项插入到结果链表中
    }
    while (curr2) {  // 如果poly2还有项未处理
        将curr2的项插入到结果链表中
    }
    return result;
}

// 乘法运算，将两个多项式相乘，返回结果多项式的头指针
Term* multiplyPolynomials(Term* poly1, Term* poly2) {  //两个多项式的头指针poly1和poly2
    Term* result = nullptr;
    Term* curr1 = poly1;
    while (curr1) {  // 遍历poly1
        Term* curr2 = poly2;
        while (curr2) {  // 遍历poly2
            计算curr1和curr2的乘积，并插入到结果链表中
        }
        curr1 = curr1->next;
    }
    return result;
}