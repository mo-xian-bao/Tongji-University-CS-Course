// 定义一个函数，接收一个字符串表达式，将其转换为逆波兰表达式
string Inserve_Polish(string exp) {  
    stack<char> st;  // 初始化一个字符栈，用于存储操作符
    string res;  // 初始化一个字符串，用于存储逆波兰表达式的结果
    for (int i = 0; i < exp.length(); i++) {  // 遍历输入表达式的每一个字符
        if (exp[i] == '(') {                  // 如果当前字符是左括号
            st.push(exp[i]);                  // 将左括号压入栈
        } else if (exp[i] == ')') {           // 如果当前字符是右括号
            while (st.top() != '(') {  // 弹出栈顶元素直到遇到左括号
                res += st.top();  // 将栈顶操作符加入结果字符串
                st.pop();         // 弹出栈顶操作符
            }
            st.pop();                       // 弹出左括号
        } else if (priority(exp[i]) > 0) {  // 如果当前字符是操作符
            while (
                !st.empty() &&
                priority(exp[i]) <=
                    priority(
                        st.top())) {  // 当栈不为空且当前操作符优先级小于或等于栈顶操作符优先级时
                res += st.top();      // 将栈顶操作符加入结果字符串
                st.pop();             // 弹出栈顶操作符
            }
            st.push(exp[i]);  // 将当前操作符压入栈
        } else {              // 如果当前字符是操作数
            res += exp[i];    // 直接将操作数加入结果字符串
        }
    }
    while (!st.empty()) {  // 将栈中剩余的操作符弹出
        res += st.top();   // 将栈顶操作符加入结果字符串
        st.pop();          // 弹出栈顶操作符
    }
    return res;  // 返回转换后的逆波兰表达式
}

// 定义一个函数，接收一个字符串表达式，构建表达式树
TreeNode* BuildTree(string exp) 
{  
    stack<TreeNode*> operands;  // 初始化一个栈，用于存储操作数（节点）
    stack<char> operators;  // 初始化一个栈，用于存储操作符
    for (int i = 0; i < exp.length(); i++) {  // 遍历表达式中的每一个字符
        if (exp[i] == '(') {  // 如果当前字符是左括号，直接将左括号压入操作符栈
            operators.push(exp[i]);
        } else if (exp[i] >= 'a' && exp[i] <= 'z') {  // 如果当前字符是操作数
            operands.push(new TreeNode(exp[i]));  // 创建一个新节点并压入操作数栈
        } else if (exp[i] == ')') {     // 如果当前字符是右括号
            while (operators.top() != '(') {  // 处理直到遇到左括号
                TreeNode* right = operands.top();  // 获取右操作数
                operands.pop();                    // 弹出右操作数
                TreeNode* left = operands.top();   // 获取左操作数
                operands.pop();                    // 弹出左操作数
                char op = operators.top();         // 获取操作符
                operators.pop();                   // 弹出操作符
                TreeNode* node = new TreeNode(op);  // 创建一个新的操作符节点
                node->left = left;                  // 设置左子树
                node->right = right;                // 设置右子树
                operands.push(node);  // 将新的子树压入操作数栈
            }
            operators.pop();                // 弹出左括号
        } else if (priority(exp[i]) > 0) {  // 如果当前字符是操作符
            while (!operators.empty() && operators.top() != '(' &&
                   priority(exp[i]) <=
                       priority(operators.top())) {  // 优先级处理
                TreeNode* right = operands.top();    // 获取右操作数
                operands.pop();                      // 弹出右操作数
                TreeNode* left = operands.top();     // 获取左操作数
                operands.pop();                      // 弹出左操作数
                char op = operators.top();           // 获取操作符
                operators.pop();                     // 弹出操作符
                TreeNode* node = new TreeNode(op);  // 创建新的操作符节点
                node->left = left;                  // 设置左子树
                node->right = right;                // 设置右子树
                operands.push(node);  // 将新的子树压入操作数栈
            }
            operators.push(exp[i]);  // 将当前操作符压入操作符栈
        }
    }
    while (!operators.empty()) {            // 处理剩余的操作符
        //和上面一样，弹出操作数，创建操作符节点，设置子树，压入操作数栈
    }
    return operands.top();  // 返回表达式树的根节点
}
