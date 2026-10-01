# Apifox 使用指南 - Meal Reservation 项目

## 概述

本指南将帮助您使用 Apifox 管理 Meal Reservation 项目的 API，包括 API 文档、调试、Mock 和自动化测试。

## 1. 项目初始化

### 1.1 创建新项目

1. 打开 Apifox
2. 点击「新建项目」
3. 选择「导入项目」
4. 选择「Markdown 导入」
5. 上传 `API-Docs.md` 文件

### 1.2 项目配置

**基本信息**
- 项目名称: `Meal Reservation API`
- 项目描述: `餐饮预订系统 API 文档`
- 基础URL: `http://localhost:5000`

**高级设置**
- API 路径前缀: `/api`
- 认证方式: `Bearer Token`
- 响应格式: `JSON`

## 2. 环境管理

### 2.1 环境配置

**开发环境**
```json
{
  "name": "开发环境",
  "baseUrl": "http://localhost:5000",
  "variables": {
    "token": "",
    "user_id": "1",
    "restaurant_id": "1"
  }
}
```

**测试环境**
```json
{
  "name": "测试环境",
  "baseUrl": "http://test.example.com:5000",
  "variables": {
    "token": "",
    "user_id": "1",
    "restaurant_id": "1"
  }
}
```

**生产环境**
```json
{
  "name": "生产环境",
  "baseUrl": "https://api.example.com",
  "variables": {
    "token": "",
    "user_id": "1",
    "restaurant_id": "1"
  }
}
```

### 2.2 环境变量

**全局变量**
```json
{
  "BASE_URL": "http://localhost:5000",
  "API_VERSION": "v1",
  "TOKEN": "",
  "USER_ID": "1"
}
```

## 3. 认证配置

### 3.1 JWT Token 配置

**全局认证设置**
1. 进入项目设置
2. 选择「认证设置」
3. 添加「Bearer Token」认证
4. Token 位置: `请求头`
5. Token 前缀: `Bearer `

**自动获取 Token**
在登录接口的「后置操作」中添加以下脚本：

```javascript
// 提取登录成功的 token
if (pm.response.json.success) {
    const token = pm.response.json.data.token;
    pm.environment.set("token", token);
    pm.environment.set("user_id", pm.response.json.data.user.id.toString());

    // 设置全局 token
    pm.globals.set("auth_token", token);

    console.log("Token 已设置: " + token);
}
```

### 3.2 认证使用

在需要认证的接口中，添加以下请求头：

```javascript
// 自动添加认证头
const token = pm.globals.get("auth_token");
if (token) {
    pm.request.headers.add({
        key: 'Authorization',
        value: 'Bearer ' + token
    });
}
```

## 4. 接口测试

### 4.1 用户认证测试

**注册流程测试**
```javascript
// 测试注册接口
pm.test("注册成功", function () {
    pm.expect(pm.response.json.success).to.be.true;
    pm.expect(pm.response.json.message).to.eql("注册成功");
});

// 测试手机号格式
pm.test("手机号格式正确", function () {
    const phone = pm.request.body.formdata.get("phone");
    const phoneRegex = /^1[3-9]\d{9}$/;
    pm.expect(phoneRegex.test(phone)).to.be.true;
});
```

**登录流程测试**
```javascript
// 测试登录成功
pm.test("登录成功", function () {
    pm.expect(pm.response.json.success).to.be.true;
    pm.expect(pm.response.json.data).to.have.property('token');
    pm.expect(pm.response.json.data).to.have.property('user');
});

// 测试 token 格式
pm.test("Token 格式正确", function () {
    const token = pm.response.json.data.token;
    pm.expect(token).to.be.a('string');
    pm.expect(token.length).to.be.gt(0);
});
```

### 4.2 餐厅管理测试

**创建餐厅测试**
```javascript
// 测试餐厅创建成功
pm.test("餐厅创建成功", function () {
    pm.expect(pm.response.json.success).to.be.true;
    pm.expect(pm.response.json.data).to.have.property('id');
    pm.expect(pm.response.json.data.name).to.eql(pm.request.body.raw.name);
});

// 测试必填字段
pm.test("必填字段验证", function () {
    const body = JSON.parse(pm.request.body.raw);
    pm.expect(body).to.have.property('name');
    pm.expect(body).to.have.property('address');
    pm.expect(body).to.have.property('phone');
});
```

### 4.3 文件上传测试

**图片上传测试**
```javascript
// 测试上传成功
pm.test("文件上传成功", function () {
    pm.expect(pm.response.json.success).to.be.true;
    pm.expect(pm.response.json.data).to.have.property('url');
});

// 测试文件格式
pm.test("文件格式正确", function () {
    const contentType = pm.request.headers.get('Content-Type');
    pm.expect(contentType).to.include('multipart/form-data');
});
```

## 5. Mock 服务

### 5.1 Mock 数据配置

**用户信息 Mock**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "phone": "13800138000",
    "username": "测试用户",
    "avatar": "https://via.placeholder.com/150",
    "birthday": "1990-01-01",
    "signature": "这是个性签名",
    "created_at": "2023-01-01T00:00:00Z"
  }
}
```

**餐厅列表 Mock**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "测试餐厅",
      "address": "测试地址123号",
      "phone": "010-12345678",
      "opening_hours": "09:00-22:00",
      "status": "open",
      "created_at": "2023-01-01T00:00:00Z"
    },
    {
      "id": 2,
      "name": "另一家餐厅",
      "address": "测试地址456号",
      "phone": "010-87654321",
      "opening_hours": "10:00-23:00",
      "status": "closed",
      "created_at": "2023-01-01T00:00:00Z"
    }
  ]
}
```

**菜品列表 Mock**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "宫保鸡丁",
      "price": 38.00,
      "category": "主菜",
      "description": "经典川菜，鸡肉嫩滑，花生香脆",
      "image": "https://via.placeholder.com/300x200",
      "status": "available",
      "stock": 100,
      "restaurant_id": 1
    },
    {
      "id": 2,
      "name": "麻婆豆腐",
      "price": 28.00,
      "category": "主菜",
      "description": "传统川菜，麻辣鲜香",
      "image": "https://via.placeholder.com/300x200",
      "status": "available",
      "stock": 50,
      "restaurant_id": 1
    }
  ]
}
```

### 5.2 高级 Mock 规则

**根据参数返回不同数据**
```javascript
// 根据餐厅ID返回不同菜品
const restaurantId = pm.request.url.query.get('restaurant_id');
if (restaurantId === '1') {
    // 返回餐厅1的菜品
} else if (restaurantId === '2') {
    // 返回餐厅2的菜品
} else {
    // 返回默认菜品
}
```

**模拟错误情况**
```javascript
// 模拟认证失败
if (pm.request.headers.get('Authorization') === 'invalid') {
    return {
        success: false,
        message: "Token 无效",
        error_code: "1009"
    };
}
```

## 6. 自动化测试

### 6.1 测试套件设置

**用户认证测试套件**
1. 发送短信验证码
2. 用户注册
3. 用户登录
4. 获取用户信息
5. 更新用户信息

**餐厅管理测试套件**
1. 创建餐厅
2. 获取餐厅列表
3. 获取餐厅详情
4. 更新餐厅信息
5. 创建菜品
6. 获取菜品列表
7. 更新菜品信息
8. 删除菜品

**文件上传测试套件**
1. 上传用户头像
2. 上传菜品图片
3. 验证图片格式
4. 验证图片大小

### 6.2 测试脚本示例

**完整的用户注册到登录流程**
```javascript
// 测试套件：用户完整注册流程
describe('用户注册流程', function () {

    // 1. 发送验证码
    it('发送短信验证码', function () {
        pm.test('验证码发送成功', function () {
            pm.expect(pm.response.json.success).to.be.true;
        });
    });

    // 2. 用户注册
    it('用户注册', function () {
        pm.test('注册成功', function () {
            pm.expect(pm.response.json.success).to.be.true;
            pm.expect(pm.response.json.data).to.have.property('token');
        });
    });

    // 3. 自动登录
    it('自动登录', function () {
        const token = pm.response.json.data.token;
        pm.globals.set('auth_token', token);

        pm.test('Token 已保存', function () {
            pm.expect(token).to.be.a('string');
        });
    });

    // 4. 获取用户信息
    it('获取用户信息', function () {
        pm.test('用户信息获取成功', function () {
            pm.expect(pm.response.json.success).to.be.true;
            pm.expect(pm.response.json.data).to.have.property('id');
        });
    });
});
```

### 6.3 定时测试

**每日健康检查**
```bash
# 设置每天上午9点执行健康检查
0 9 * * * /api/health
```

**接口性能监控**
```javascript
// 监控接口响应时间
pm.test("响应时间小于500ms", function () {
    pm.expect(pm.response.responseTime).to.be.below(500);
});

// 监控接口状态码
pm.test("状态码为200", function () {
    pm.expect(pm.response.code).to.eql(200);
});
```

## 7. 团队协作

### 7.1 权限管理

**角色设置**
- **管理员**: 完全权限
- **开发者**: API 开发和测试权限
- **测试人员**: 仅测试权限
- **观察者**: 只读权限

### 7.2 工作流程

1. **API 设计**: 使用 Apifox 设计 API
2. **前端开发**: 使用 Mock 服务开发
3. **后端开发**: 实现 API 功能
4. **接口测试**: 自动化测试
5. **文档维护**: 实时更新文档

### 7.3 版本管理

**API 版本控制**
- v1.0.0: 当前版本
- v1.1.0: 开发中版本
- v2.0.0: 规划中版本

## 8. 最佳实践

### 8.1 接口命名规范

- 使用复数名词: `/users`、`/restaurants`
- 使用标准HTTP方法: GET、POST、PUT、DELETE
- 层级结构清晰: `/restaurants/{id}/dishes`

### 8.2 响应格式规范

```json
{
  "success": true,
  "message": "操作成功",
  "data": {},
  "error_code": null,
  "timestamp": "2023-01-01T00:00:00Z"
}
```

### 8.3 测试数据管理

- 使用环境变量管理测试数据
- 定期清理测试数据
- 保持数据一致性

### 8.4 性能优化

- 使用接口批量操作
- 合理设置缓存策略
- 监控接口性能指标

## 9. 常见问题

### 9.1 Token 相关问题

**问题**: Token 过期
**解决**: 在登录接口的后置操作中自动刷新 Token

**问题**: Token 格式错误
**解决**: 确保 Token 前缀为 `Bearer `

### 9.2 文件上传问题

**问题**: 文件格式不支持
**解决**: 检查文件扩展名和 Content-Type

**问题**: 文件大小超限
**解决**: 压缩文件或调整服务器配置

### 9.3 Mock 数据问题

**问题**: Mock 数据不准确
**解决**: 根据实际业务逻辑更新 Mock 数据

**问题**: Mock 服务不可用
**解决**: 检查网络连接和 Apifox 服务状态

## 10. 进阶功能

### 10.1 接口导出

**支持的格式**
- Markdown
- Postman Collection
- OpenAPI 3.0
- Swagger

### 10.2 接口监控

**监控指标**
- 响应时间
- 成功率
- 错误率
- 并发数

### 10.3 自动化报告

**报告内容**
- 测试执行结果
- 性能指标
- 错误分析
- 改进建议

---

通过本指南，您可以充分利用 Apifox 的功能来管理 Meal Reservation 项目的 API，提高开发效率和接口质量。