# FoodBook 开发指南

完整的前后端分离开发环境搭建和运行指南。

## 项目结构

```
FoodBook/
├── frontend/                 # Vue3前端
│   ├── src/
│   │   ├── components/
│   │   │   ├── Login.vue     # 登录组件
│   │   │   └── Register.vue  # 注册组件
│   │   ├── router/
│   │   │   └── index.js      # 路由配置
│   │   ├── App.vue           # 主应用组件
│   │   └── main.js           # 入口文件
│   ├── index.html            # HTML模板
│   ├── package.json          # 前端依赖
│   └── vite.config.js        # Vite配置
├── backend/                  # Flask后端
│   ├── app.py                # Flask主应用
│   ├── init_db.py            # 数据库初始化
│   ├── run.py                # 启动脚本
│   ├── test_api.py           # API测试
│   ├── requirements.txt      # 后端依赖
│   └── .env                  # 环境配置
└── README.md                 # 项目说明
```

## 环境要求

- Node.js 16+
- Python 3.8+
- npm 或 yarn
- pip

## 快速启动

### 1. 启动后端服务

```bash
# 进入后端目录
cd backend

# 安装Python依赖
pip install -r requirements.txt

# 初始化数据库
python init_db.py

# 启动后端服务
python run.py
```

后端服务将在 http://localhost:5000 启动

### 2. 启动前端服务

```bash
# 新开终端，进入前端目录
cd frontend

# 安装Node.js依赖
npm install

# 启动前端开发服务器
npm run dev
```

前端应用将在 http://localhost:3000 启动

### 3. 测试完整流程

1. 打开浏览器访问 http://localhost:3000
2. 点击"立即注册"
3. 填写注册信息：
   - 手机号：13800138001
   - 用户名：testuser
   - 密码：123456
   - 确认密码：123456
4. 注册成功后跳转到登录页
5. 使用注册的账号登录测试

## API接口测试

### 使用提供的测试脚本

```bash
cd backend
python test_api.py
```

### 使用Postman或curl测试

#### 注册接口
```bash
curl -X POST http://localhost:5000/api/register \
  -H "Content-Type: application/json" \
  -d '{
    "phone": "13800138002",
    "username": "newuser",
    "password": "123456",
    "confirmPassword": "123456"
  }'
```

#### 登录接口
```bash
curl -X POST http://localhost:5000/api/login \
  -H "Content-Type: application/json" \
  -d '{
    "identifier": "newuser",
    "password": "123456"
  }'
```

## 测试账号

系统预置了一个测试账号：
- 手机号：13800138000
- 用户名：admin
- 密码：123456

## 开发调试

### 后端调试

1. **查看日志**：控制台会显示请求日志
2. **数据库查看**：使用SQLite工具查看`foodbook.db`文件
3. **API测试**：运行`test_api.py`进行接口测试

### 前端调试

1. **浏览器开发者工具**：F12查看网络请求和控制台
2. **API请求**：在网络面板中查看对后端的API调用
3. **响应数据**：查看API返回的JSON数据

## 常见问题解决

### 1. 后端启动失败
- 检查Python版本：`python --version`
- 检查依赖安装：`pip list`
- 检查端口占用：`lsof -i :5000` (macOS/Linux) 或 `netstat -ano | findstr :5000` (Windows)

### 2. 前端启动失败
- 检查Node.js版本：`node --version`
- 删除node_modules重新安装：`rm -rf node_modules && npm install`
- 检查端口占用：`lsof -i :3000`

### 3. 跨域问题
- 确保后端已启用CORS
- 检查API请求地址是否正确：`http://localhost:5000/api/...`

### 4. 数据库问题
- 删除`foodbook.db`文件重新运行`python init_db.py`
- 检查数据库文件权限

## 生产部署建议

### 后端部署

1. 使用Gunicorn作为WSGI服务器
2. 配置Nginx反向代理
3. 使用PostgreSQL或MySQL数据库
4. 配置环境变量和密钥

### 前端部署

1. 构建生产版本：`npm run build`
2. 部署到CDN或静态文件服务器
3. 配置正确的API地址

## 扩展功能建议

### 短期目标
- [ ] 添加JWT token认证
- [ ] 实现记住登录状态
- [ ] 添加表单验证优化
- [ ] 添加加载动画

### 中期目标
- [ ] 用户资料管理
- [ ] 密码重置功能
- [ ] 邮箱验证
- [ ] 手机短信验证

### 长期目标
- [ ] 第三方登录（微信、QQ等）
- [ ] 多角色权限管理
- [ ] 审计日志
- [ ] 性能监控

## 开发规范

### 代码风格
- Python：遵循PEP8规范
- JavaScript：使用ESLint和Prettier
- Vue3：使用Composition API

### Git提交规范
- feat：新功能
- fix：修复bug
- docs：文档更新
- style：代码格式调整
- refactor：代码重构
- test：测试相关
- chore：构建工具或辅助工具的变动

### 分支管理
- main：生产环境分支
- develop：开发环境分支
- feature/*：功能开发分支
- hotfix/*：紧急修复分支