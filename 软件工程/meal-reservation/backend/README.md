# Meal Reservation 后端API

使用Flask框架构建的Meal Reservation美食应用后端服务，提供用户注册、登录等功能。

## 技术栈

- Flask 2.3.3 - Web框架
- Flask-SQLAlchemy - ORM数据库操作
- Flask-CORS - 跨域资源共享支持
- Werkzeug - 安全密码哈希
- SQLite - 数据库（开发环境）

## 功能特性

- ✅ 用户注册（手机号验证）
- ✅ 用户登录（支持手机号/用户名）
- ✅ 密码安全存储（哈希加密）
- ✅ 数据验证和错误处理
- ✅ RESTful API设计
- ✅ CORS跨域支持
- ✅ 数据库自动建表

## 快速开始

### 1. 安装依赖

```bash
pip install -r requirements.txt
```

### 2. 初始化数据库

```bash
python init_db.py
```

这会创建数据库表和一个测试用户：
- 手机号: 13800138000
- 用户名: admin
- 密码: 123456

### 3. 启动服务

```bash
python run.py
```

服务将在 http://localhost:5000 启动

### 4. 测试API

```bash
python test_api.py
```

## API接口文档

### 健康检查

```
GET /api/health
```

响应示例：
```json
{
  "status": "healthy",
  "message": "FoodBook API is running"
}
```

### 用户注册

```
POST /api/register
Content-Type: application/json
```

请求体：
```json
{
  "phone": "13800138001",
  "username": "testuser",
  "password": "123456",
  "confirmPassword": "123456"
}
```

成功响应 (201)：
```json
{
  "success": true,
  "message": "注册成功",
  "data": {
    "user": {
      "id": 1,
      "phone": "13800138001",
      "username": "testuser",
      "created_at": "2023-12-01T10:00:00.000000",
      "updated_at": "2023-12-01T10:00:00.000000"
    }
  }
}
```

错误响应：
- 400: 请求数据无效
- 409: 用户已存在
- 500: 服务器错误

### 用户登录

```
POST /api/login
Content-Type: application/json
```

请求体：
```json
{
  "identifier": "13800138000",  // 手机号或用户名
  "password": "123456"
}
```

成功响应 (200)：
```json
{
  "success": true,
  "message": "登录成功",
  "data": {
    "user": {
      "id": 1,
      "phone": "13800138000",
      "username": "admin",
      "created_at": "2023-12-01T10:00:00.000000",
      "updated_at": "2023-12-01T10:00:00.000000"
    },
    "token": "simple-token-1"
  }
}
```

错误响应：
- 400: 请求数据无效
- 401: 用户不存在或密码错误
- 500: 服务器错误

## 数据验证

### 手机号验证
- 正则表达式：`^1[3-9]\d{9}$`
- 必须是中国大陆手机号格式

### 用户名验证
- 长度：2-50个字符
- 唯一性检查

### 密码验证
- 最少6个字符
- 使用Werkzeug进行安全哈希存储

## 环境配置

通过`.env`文件配置环境变量：

```env
SECRET_KEY=your-secret-key-change-this-in-production
FLASK_ENV=development
FLASK_DEBUG=1
DATABASE_URL=sqlite:///foodbook.db
PORT=5000
```

## 项目结构

```
backend/
├── app.py              # 主应用文件
├── init_db.py          # 数据库初始化脚本
├── run.py              # 启动脚本
├── test_api.py         # API测试脚本
├── requirements.txt    # Python依赖
├── .env               # 环境变量配置
└── README.md          # 项目说明
```

## 数据库设计

### User表结构

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| id | Integer | PRIMARY KEY | 用户ID |
| phone | String(11) | UNIQUE, NOT NULL | 手机号 |
| username | String(50) | UNIQUE, NOT NULL | 用户名 |
| password_hash | String(128) | NOT NULL | 密码哈希 |
| created_at | DateTime | | 创建时间 |
| updated_at | DateTime | | 更新时间 |

## 安全考虑

1. **密码安全**：使用Werkzeug的`generate_password_hash`进行密码哈希
2. **数据验证**：前后端双重验证，防止恶意数据
3. **CORS配置**：支持跨域请求，方便前后端分离
4. **错误处理**：统一的错误响应格式，不泄露敏感信息

## 开发建议

1. **生产环境**：
   - 使用更安全的密钥
   - 使用PostgreSQL或MySQL等生产级数据库
   - 添加日志记录
   - 实现JWT token认证
   - 添加API限流

2. **功能扩展**：
   - 用户信息修改
   - 密码重置功能
   - 邮箱验证
   - 第三方登录集成

## 常见问题

### Q: 如何更换数据库？
A: 修改`.env`文件中的`DATABASE_URL`，例如：
- PostgreSQL: `postgresql://user:password@localhost/dbname`
- MySQL: `mysql://user:password@localhost/dbname`

### Q: 如何添加新的API接口？
A: 在`app.py`中添加新的路由函数，参考现有的注册/登录接口实现。

### Q: 如何部署到生产环境？
A: 建议使用Gunicorn + Nginx部署，设置环境变量为生产模式。