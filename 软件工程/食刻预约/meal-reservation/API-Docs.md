# Meal Reservation API 文档

## 概述

餐饮预订系统 API，基于 Flask 开发，提供完整的用户管理、餐厅管理、菜品管理、订单管理等功能。

**基础信息**
- 基础URL: `http://localhost:5000`
- API版本: v1
- 数据格式: JSON
- 认证方式: JWT Token

## 认证

### JWT认证
除了注册和登录接口外，所有API都需要在请求头中包含JWT Token：

```http
Authorization: Bearer <your_jwt_token>
```

### 错误响应格式
```json
{
  "success": false,
  "message": "错误信息",
  "error_code": "ERROR_CODE"
}
```

---

## 1. 用户认证模块

### 1.1 用户注册

**POST** `/api/register`

注册新用户账户

**请求参数**
```json
{
  "phone": "13800138000",
  "username": "用户名",
  "password": "密码",
  "confirmPassword": "确认密码",
  "smsCode": "123456"
}
```

**响应示例**
```json
{
  "success": true,
  "message": "注册成功",
  "data": {
    "id": 1,
    "phone": "13800138000",
    "username": "用户名",
    "token": "jwt_token_here"
  }
}
```

### 1.2 用户登录

**POST** `/api/login`

用户登录，支持密码登录和短信登录

**请求参数**
```json
{
  "identifier": "手机号/用户名",
  "password": "密码", // 密码登录时
  "smsCode": "123456", // 短信登录时
  "loginType": "password" // password 或 sms
}
```

**响应示例**
```json
{
  "success": true,
  "message": "登录成功",
  "data": {
    "user": {
      "id": 1,
      "phone": "13800138000",
      "username": "用户名",
      "avatar": "头像URL"
    },
    "token": "jwt_token_here"
  }
}
```

### 1.3 发送短信验证码

**POST** `/api/sms/send`

发送短信验证码

**请求参数**
```json
{
  "phone": "13800138000",
  "purpose": "register" // register/login/reset_password
}
```

**响应示例**
```json
{
  "success": true,
  "message": "验证码发送成功"
}
```

### 1.4 重置密码

**POST** `/api/reset-password`

重置用户密码

**请求参数**
```json
{
  "phone": "13800138000",
  "smsCode": "123456",
  "newPassword": "新密码"
}
```

**响应示例**
```json
{
  "success": true,
  "message": "密码重置成功"
}
```

---

## 2. 用户信息管理

### 2.1 获取用户信息

**GET** `/api/users/profile`

获取当前登录用户的详细信息

**认证**: 需JWT Token

**响应示例**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "phone": "13800138000",
    "username": "用户名",
    "avatar": "头像URL",
    "birthday": "1990-01-01",
    "signature": "个性签名",
    "created_at": "2023-01-01T00:00:00Z"
  }
}
```

### 2.2 更新用户信息

**POST** `/api/users/update-profile`

更新用户个人信息

**认证**: 需JWT Token

**请求参数** (multipart/form-data)
```
username: 用户名
avatar: (文件) 头像图片
birthday: 1990-01-01
signature: 个性签名
```

**响应示例**
```json
{
  "success": true,
  "message": "个人信息更新成功",
  "data": {
    "id": 1,
    "phone": "13800138000",
    "username": "新用户名",
    "avatar": "新头像URL",
    "birthday": "1990-01-01",
    "signature": "新个性签名"
  }
}
```

### 2.3 修改密码

**POST** `/api/users/change-password`

修改用户密码

**认证**: 需JWT Token

**请求参数**
```json
{
  "old_password": "旧密码",
  "new_password": "新密码"
}
```

**响应示例**
```json
{
  "success": true,
  "message": "密码修改成功"
}
```

### 2.4 修改手机号

**POST** `/api/users/change-phone`

修改用户手机号

**认证**: 需JWT Token

**请求参数**
```json
{
  "new_phone": "13900139000",
  "sms_code": "123456"
}
```

**响应示例**
```json
{
  "success": true,
  "message": "手机号修改成功"
}
```

---

## 3. 餐厅管理

### 3.1 创建餐厅

**POST** `/api/restaurant`

创建新餐厅

**认证**: 需JWT Token

**请求参数**
```json
{
  "name": "餐厅名称",
  "address": "餐厅地址",
  "description": "餐厅描述",
  "phone": "联系电话",
  "opening_hours": "营业时间",
  "status": "open" // open 或 closed
}
```

**响应示例**
```json
{
  "success": true,
  "message": "餐厅创建成功",
  "data": {
    "id": 1,
    "name": "餐厅名称",
    "address": "餐厅地址",
    "description": "餐厅描述",
    "phone": "联系电话",
    "opening_hours": "营业时间",
    "status": "open",
    "user_id": 1
  }
}
```

### 3.2 获取餐厅列表

**GET** `/api/restaurants`

获取所有餐厅列表

**响应示例**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "餐厅名称",
      "address": "餐厅地址",
      "phone": "联系电话",
      "opening_hours": "营业时间",
      "status": "open"
    }
  ]
}
```

### 3.3 获取餐厅详情

**GET** `/api/restaurants/{id}`

获取指定餐厅的详细信息

**路径参数**
- `id`: 餐厅ID

**响应示例**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "餐厅名称",
    "address": "餐厅地址",
    "description": "餐厅描述",
    "phone": "联系电话",
    "opening_hours": "营业时间",
    "status": "open",
    "created_at": "2023-01-01T00:00:00Z",
    "dishes_count": 10,
    "tables_count": 5
  }
}
```

### 3.4 更新餐厅信息

**PUT** `/api/restaurant/{id}`

更新餐厅信息

**认证**: 需JWT Token，需要餐厅管理员权限

**路径参数**
- `id`: 餐厅ID

**请求参数**
```json
{
  "name": "新餐厅名称",
  "address": "新地址",
  "description": "新描述",
  "phone": "新电话",
  "opening_hours": "新营业时间",
  "status": "closed"
}
```

**响应示例**
```json
{
  "success": true,
  "message": "餐厅信息更新成功",
  "data": {
    "id": 1,
    "name": "新餐厅名称",
    "address": "新地址",
    "description": "新描述",
    "phone": "新电话",
    "opening_hours": "新营业时间",
    "status": "closed"
  }
}
```

---

## 4. 菜品管理

### 4.1 获取菜品列表

**GET** `/api/dishes`

获取菜品列表，可按餐厅筛选

**查询参数**
- `restaurant_id`: 餐厅ID (可选)

**响应示例**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "菜品名称",
      "price": 38.00,
      "category": "主菜",
      "description": "菜品描述",
      "image": "图片URL",
      "status": "available",
      "stock": 100,
      "restaurant_id": 1
    }
  ]
}
```

### 4.2 创建菜品

**POST** `/api/dishes`

创建新菜品

**认证**: 需JWT Token，需要餐厅管理员权限

**请求参数** (multipart/form-data)
```
name: 菜品名称
price: 38.00
category: 主菜
description: 菜品描述
image: (文件) 菜品图片
status: available
stock: 100
restaurant_id: 1
```

**响应示例**
```json
{
  "success": true,
  "message": "菜品创建成功",
  "data": {
    "id": 1,
    "name": "菜品名称",
    "price": 38.00,
    "category": "主菜",
    "description": "菜品描述",
    "image": "图片URL",
    "status": "available",
    "stock": 100,
    "restaurant_id": 1
  }
}
```

### 4.3 获取菜品详情

**GET** `/api/dishes/{id}`

获取指定菜品的详细信息

**路径参数**
- `id`: 菜品ID

**响应示例**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "菜品名称",
    "price": 38.00,
    "category": "主菜",
    "description": "菜品描述",
    "image": "图片URL",
    "status": "available",
    "stock": 100,
    "restaurant_id": 1,
    "created_at": "2023-01-01T00:00:00Z"
  }
}
```

### 4.4 更新菜品

**PUT** `/api/dishes/{id}`

更新菜品信息

**认证**: 需JWT Token，需要餐厅管理员权限

**路径参数**
- `id`: 菜品ID

**请求参数** (multipart/form-data)
```
name: 新菜品名称
price: 48.00
category: 新分类
description: 新描述
image: (文件) 新图片
status: unavailable
stock: 50
```

**响应示例**
```json
{
  "success": true,
  "message": "菜品信息更新成功",
  "data": {
    "id": 1,
    "name": "新菜品名称",
    "price": 48.00,
    "category": "新分类",
    "description": "新描述",
    "image": "新图片URL",
    "status": "unavailable",
    "stock": 50,
    "restaurant_id": 1
  }
}
```

### 4.5 删除菜品

**DELETE** `/api/dishes/{id}`

删除菜品

**认证**: 需JWT Token，需要餐厅管理员权限

**路径参数**
- `id`: 菜品ID

**响应示例**
```json
{
  "success": true,
  "message": "菜品删除成功"
}
```

### 4.6 获取餐厅菜单

**GET** `/api/dishes/menu/{restaurant_id}`

获取指定餐厅的菜单，按分类分组

**路径参数**
- `restaurant_id`: 餐厅ID

**响应示例**
```json
{
  "success": true,
  "data": {
    "restaurant_id": 1,
    "restaurant_name": "餐厅名称",
    "categories": [
      {
        "category": "主菜",
        "dishes": [
          {
            "id": 1,
            "name": "菜品名称",
            "price": 38.00,
            "description": "菜品描述",
            "image": "图片URL",
            "status": "available",
            "stock": 100
          }
        ]
      }
    ]
  }
}
```

---

## 5. 桌位管理

### 5.1 获取桌位列表

**GET** `/api/tables`

获取所有桌位列表

**认证**: 需JWT Token

**响应示例**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "table_number": "T001",
      "capacity": 4,
      "status": "available",
      "restaurant_id": 1
    }
  ]
}
```

### 5.2 创建桌位

**POST** `/api/tables`

创建新桌位

**认证**: 需JWT Token，需要餐厅管理员权限

**请求参数**
```json
{
  "table_number": "T002",
  "capacity": 6,
  "status": "available",
  "restaurant_id": 1
}
```

**响应示例**
```json
{
  "success": true,
  "message": "桌位创建成功",
  "data": {
    "id": 2,
    "table_number": "T002",
    "capacity": 6,
    "status": "available",
    "restaurant_id": 1
  }
}
```

### 5.3 获取桌位详情

**GET** `/api/tables/{id}`

获取指定桌位的详细信息

**路径参数**
- `id`: 桌位ID

**响应示例**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "table_number": "T001",
    "capacity": 4,
    "status": "available",
    "restaurant_id": 1,
    "created_at": "2023-01-01T00:00:00Z"
  }
}
```

### 5.4 更新桌位

**PUT** `/api/tables/{id}`

更新桌位信息

**认证**: 需JWT Token，需要餐厅管理员权限

**路径参数**
- `id`: 桌位ID

**请求参数**
```json
{
  "table_number": "T001-UPDATED",
  "capacity": 8,
  "status": "occupied"
}
```

**响应示例**
```json
{
  "success": true,
  "message": "桌位信息更新成功",
  "data": {
    "id": 1,
    "table_number": "T001-UPDATED",
    "capacity": 8,
    "status": "occupied",
    "restaurant_id": 1
  }
}
```

### 5.5 删除桌位

**DELETE** `/api/tables/{id}`

删除桌位

**认证**: 需JWT Token，需要餐厅管理员权限

**路径参数**
- `id`: 桌位ID

**响应示例**
```json
{
  "success": true,
  "message": "桌位删除成功"
}
```

---

## 6. 商家广播管理

### 6.1 创建广播

**POST** `/api/restaurant/{id}/broadcasts`

创建商家广播

**认证**: 需JWT Token，需要餐厅管理员权限

**路径参数**
- `id`: 餐厅ID

**请求参数**
```json
{
  "title": "广播标题",
  "content": "广播内容",
  "type": "promotion", // promotion/announcement/system
  "priority": "high", // low/medium/high
  "is_active": true,
  "expire_at": "2023-12-31T23:59:59Z"
}
```

**响应示例**
```json
{
  "success": true,
  "message": "广播创建成功",
  "data": {
    "id": 1,
    "title": "广播标题",
    "content": "广播内容",
    "type": "promotion",
    "priority": "high",
    "is_active": true,
    "restaurant_id": 1,
    "created_at": "2023-01-01T00:00:00Z",
    "expire_at": "2023-12-31T23:59:59Z"
  }
}
```

### 6.2 获取广播列表

**GET** `/api/restaurant/broadcasts`

获取广播列表

**查询参数**
- `restaurant_id`: 餐厅ID (可选)
- `include_inactive`: 是否包含失效广播 (默认false)
- `page`: 页码 (默认1)
- `per_page`: 每页数量 (默认20)

**响应示例**
```json
{
  "success": true,
  "data": {
    "broadcasts": [
      {
        "id": 1,
        "title": "广播标题",
        "content": "广播内容",
        "type": "promotion",
        "priority": "high",
        "is_active": true,
        "restaurant_id": 1,
        "created_at": "2023-01-01T00:00:00Z",
        "expire_at": "2023-12-31T23:59:59Z"
      }
    ],
    "pagination": {
      "page": 1,
      "per_page": 20,
      "total": 1,
      "pages": 1
    }
  }
}
```

### 6.3 获取广播详情

**GET** `/api/restaurant/broadcasts/{id}`

获取指定广播的详细信息

**路径参数**
- `id`: 广播ID

**响应示例**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "广播标题",
    "content": "广播内容",
    "type": "promotion",
    "priority": "high",
    "is_active": true,
    "restaurant_id": 1,
    "created_at": "2023-01-01T00:00:00Z",
    "expire_at": "2023-12-31T23:59:59Z",
    "updated_at": "2023-01-01T00:00:00Z"
  }
}
```

### 6.4 更新广播

**PUT** `/api/restaurant/{restaurant_id}/broadcasts/{id}`

更新广播信息

**认证**: 需JWT Token，需要餐厅管理员权限

**路径参数**
- `restaurant_id`: 餐厅ID
- `id`: 广播ID

**请求参数**
```json
{
  "title": "新广播标题",
  "content": "新广播内容",
  "priority": "medium",
  "is_active": false,
  "expire_at": "2023-12-31T23:59:59Z"
}
```

**响应示例**
```json
{
  "success": true,
  "message": "广播信息更新成功",
  "data": {
    "id": 1,
    "title": "新广播标题",
    "content": "新广播内容",
    "type": "promotion",
    "priority": "medium",
    "is_active": false,
    "restaurant_id": 1,
    "updated_at": "2023-01-01T00:00:00Z"
  }
}
```

### 6.5 删除广播

**DELETE** `/api/restaurant/{restaurant_id}/broadcasts/{id}`

删除广播

**认证**: 需JWT Token，需要餐厅管理员权限

**路径参数**
- `restaurant_id`: 餐厅ID
- `id`: 广播ID

**响应示例**
```json
{
  "success": true,
  "message": "广播删除成功"
}
```

---

## 7. 文件上传

### 7.1 上传图片

**POST** `/api/upload`

上传图片文件

**认证**: 需JWT Token

**请求参数** (multipart/form-data)
```
file: (文件) 图片文件
```

**支持的文件格式**: png, jpg, jpeg, gif

**响应示例**
```json
{
  "success": true,
  "message": "文件上传成功",
  "data": {
    "url": "/uploads/images/2023/01/01/image.jpg",
    "filename": "image.jpg",
    "size": 102400,
    "mime_type": "image/jpeg"
  }
}
```

---

## 8. 系统接口

### 8.1 健康检查

**GET** `/api/health`

系统健康检查接口

**响应示例**
```json
{
  "success": true,
  "message": "API服务正常运行",
  "data": {
    "status": "healthy",
    "timestamp": "2023-01-01T00:00:00Z",
    "version": "1.0.0"
  }
}
```

---

## 数据模型

### User
```json
{
  "id": "integer",
  "phone": "string",
  "username": "string",
  "password_hash": "string",
  "created_at": "datetime",
  "updated_at": "datetime"
}
```

### UserInfo
```json
{
  "id": "integer",
  "user_id": "integer",
  "avatar": "string",
  "birthday": "date",
  "signature": "string",
  "created_at": "datetime",
  "updated_at": "datetime"
}
```

### Restaurant
```json
{
  "id": "integer",
  "name": "string",
  "address": "string",
  "description": "string",
  "phone": "string",
  "opening_hours": "string",
  "status": "string",
  "user_id": "integer",
  "created_at": "datetime",
  "updated_at": "datetime"
}
```

### Dish
```json
{
  "id": "integer",
  "name": "string",
  "price": "decimal",
  "category": "string",
  "description": "string",
  "image": "string",
  "status": "string",
  "stock": "integer",
  "restaurant_id": "integer",
  "created_at": "datetime",
  "updated_at": "datetime"
}
```

### Table
```json
{
  "id": "integer",
  "table_number": "string",
  "capacity": "integer",
  "status": "string",
  "restaurant_id": "integer",
  "created_at": "datetime",
  "updated_at": "datetime"
}
```

### MerchantBroadcast
```json
{
  "id": "integer",
  "title": "string",
  "content": "string",
  "type": "string",
  "priority": "string",
  "is_active": "boolean",
  "restaurant_id": "integer",
  "expire_at": "datetime",
  "created_at": "datetime",
  "updated_at": "datetime"
}
```

---

## 错误代码

| 错误代码 | 说明 |
|---------|------|
| 1001 | 参数验证失败 |
| 1002 | 手机号码格式错误 |
| 1003 | 密码格式错误 |
| 1004 | 短信验证码错误 |
| 1005 | 短信验证码过期 |
| 1006 | 用户已存在 |
| 1007 | 用户不存在 |
| 1008 | 密码错误 |
| 1009 | JWT Token 无效 |
| 1010 | 权限不足 |
| 2001 | 餐厅不存在 |
| 2002 | 菜品不存在 |
| 2003 | 桌位不存在 |
| 2004 | 广播不存在 |
| 3001 | 文件上传失败 |
| 3002 | 文件格式不支持 |
| 3003 | 文件大小超限 |
| 5000 | 服务器内部错误 |

---

## 测试数据

### 测试用户
```json
{
  "phone": "13800138000",
  "username": "admin",
  "password": "123456"
}
```

### 测试餐厅
```json
{
  "name": "测试餐厅",
  "address": "测试地址",
  "phone": "010-12345678",
  "opening_hours": "09:00-22:00",
  "status": "open"
}
```

### 测试菜品
```json
{
  "name": "测试菜品",
  "price": 38.00,
  "category": "主菜",
  "description": "这是一个测试菜品",
  "status": "available",
  "stock": 100
}
```