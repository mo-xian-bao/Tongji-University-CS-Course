# FoodBook 短信验证码功能指南

## 功能概述

为FoodBook登录注册系统添加了完整的短信验证码功能，包括：
- 用户注册时的短信验证
- 用户登录时的短信验证（可选）
- 发送频率限制
- 验证码有效期管理
- 防重复发送机制

## 技术实现

### 后端架构

#### 1. 数据模型
- **SMSVerification**: 短信验证码数据表
  - `phone`: 手机号
  - `code`: 6位验证码
  - `purpose`: 用途（register/login）
  - `is_used`: 是否已使用
  - `created_at`: 创建时间
  - `expires_at`: 过期时间
  - `used_at`: 使用时间

#### 2. 核心服务
- **sms_service.py**: 短信服务核心逻辑
  - 验证码生成
  - 发送频率控制
  - 验证码验证
  - 过期清理

#### 3. API接口
- `POST /api/sms/send`: 发送短信验证码
- `POST /api/register`: 用户注册（需要短信验证）
- `POST /api/login`: 用户登录（支持密码/短信验证）

### 前端实现

#### 1. 注册页面 ([Register.vue](src/login_register/Register.vue))
- 添加短信验证码输入框
- 发送验证码按钮（带倒计时）
- 表单验证包含短信验证码

#### 2. 登录页面 ([Login.vue](src/login_register/Login.vue))
- 登录方式切换（密码/短信）
- 短信验证码输入和发送
- 响应式UI设计

## 功能特性

### ✅ 已实现功能

1. **短信验证码发送**
   - 6位随机数字验证码
   - 5分钟有效期
   - 1分钟发送频率限制
   - 开发模式下控制台显示验证码

2. **用户注册验证**
   - 必须输入正确的短信验证码
   - 验证码与手机号绑定
   - 一次性使用（使用后失效）

3. **用户登录验证**
   - 支持密码登录（原有功能）
   - 支持短信验证码登录（新增）
   - 登录方式可自由切换

4. **安全机制**
   - 验证码有效期控制
   - 发送频率限制
   - 防重复验证
   - 自动清理过期验证码

5. **用户体验**
   - 发送按钮倒计时显示
   - 实时表单验证
   - 错误提示信息
   - 响应式设计

## API文档

### 发送短信验证码

**接口**: `POST /api/sms/send`

**请求参数**:
```json
{
  "phone": "13800138000",
  "purpose": "register"  // 或 "login"
}
```

**响应示例**:
```json
{
  "success": true,
  "message": "验证码发送成功",
  "data": {
    "expires_in": 300,
    "phone": "8000****"
  }
}
```

### 用户注册

**接口**: `POST /api/register`

**请求参数**:
```json
{
  "phone": "13800138000",
  "username": "testuser",
  "password": "123456",
  "confirmPassword": "123456",
  "smsCode": "123456"
}
```

**响应示例**:
```json
{
  "success": true,
  "message": "注册成功",
  "data": {
    "user": {
      "id": 1,
      "phone": "13800138000",
      "username": "testuser",
      "created_at": "2025-10-29T06:29:05.811324",
      "updated_at": "2025-10-29T06:29:05.811324"
    }
  }
}
```

### 用户登录

**接口**: `POST /api/login`

**密码登录请求参数**:
```json
{
  "identifier": "admin",  // 手机号或用户名
  "password": "123456",
  "loginType": "password"
}
```

**短信登录请求参数**:
```json
{
  "identifier": "13800138000",  // 仅支持手机号
  "smsCode": "123456",
  "loginType": "sms"
}
```

**响应示例**:
```json
{
  "success": true,
  "message": "登录成功",
  "data": {
    "user": { ... },
    "token": "simple-token-1",
    "login_type": "sms"  // 或 "password"
  }
}
```

## 使用指南

### 开发环境测试

1. **启动后端服务**:
   ```bash
   cd backend
   python run.py
   ```

2. **发送验证码测试**:
   ```bash
   curl -X POST http://localhost:5000/api/sms/send \
     -H "Content-Type: application/json" \
     -d '{"phone": "13800138000", "purpose": "register"}'
   ```

3. **查看验证码**:
   验证码会显示在后端控制台：
   ```
   ==================================================
   【短信验证码】
   手机号: 13800138000
   用途: register
   验证码: 123456
   有效期: 5分钟
   ==================================================
   ```

4. **运行完整测试**:
   ```bash
   cd backend
   python test_sms_api.py
   ```

### 前端使用

1. **注册流程**:
   - 填写手机号、用户名、密码
   - 点击"发送验证码"
   - 输入收到的验证码
   - 完成注册

2. **登录流程**:
   - 选择登录方式（密码/短信）
   - 密码登录：输入账号密码
   - 短信登录：输入手机号，发送验证码，输入验证码
   - 完成登录

## 安全考虑

### 当前实现
- ✅ 验证码有效期限制（5分钟）
- ✅ 发送频率限制（1分钟）
- ✅ 一次性使用验证码
- ✅ 验证码与手机号绑定
- ✅ 自动清理过期验证码

### 生产环境建议
- 🔲 集成真实短信服务商（阿里云、腾讯云等）
- 🔲 添加IP限制
- 🔲 实现设备指纹识别
- 🔲 添加验证码复杂度选项
- 🔲 实现验证码重试次数限制
- 🔲 添加日志记录和监控

## 配置说明

### 环境变量
在 `backend/.env` 中配置：
```env
SECRET_KEY=your-secret-key-here
FLASK_ENV=development
FLASK_DEBUG=1
DATABASE_URL=sqlite:///foodbook.db
PORT=5000
```

### 短信服务商配置
在 `backend/sms_service.py` 中配置真实的短信服务商：
```python
class SMSService:
    def __init__(self):
        self.sms_provider = "aliyun"  # 或 "tencent", "huawei"
        self.debug_mode = False  # 生产环境设为False
```

## 测试数据

### 预置测试账号
- 手机号: 13800138000
- 用户名: admin
- 密码: 123456

### 测试流程
1. 使用新手机号注册（需要短信验证）
2. 使用短信验证码登录
3. 测试错误验证码处理
4. 测试发送频率限制

## 故障排除

### 常见问题

1. **验证码发送失败**
   - 检查手机号格式是否正确
   - 检查是否在发送冷却期内
   - 查看后端日志错误信息

2. **验证码验证失败**
   - 确认验证码是否正确
   - 检查验证码是否过期
   - 确认验证码是否已被使用

3. **前端显示问题**
   - 检查API调用是否正确
   - 确认后端服务是否运行
   - 查看浏览器控制台错误

### 调试技巧

1. **查看后端日志**:
   ```bash
   tail -f /path/to/logfile
   ```

2. **检查数据库**:
   ```bash
   sqlite3 backend/foodbook.db
   SELECT * FROM sms_verifications;
   ```

3. **测试API接口**:
   ```bash
   python test_sms_api.py
   ```

## 未来扩展

### 短期计划
- [ ] 添加邮箱验证码支持
- [ ] 实现验证码语音播报
- [ ] 添加图形验证码防机器人
- [ ] 实现批量发送管理

### 长期计划
- [ ] 多渠道验证（短信、邮箱、推送）
- [ ] 智能风控系统
- [ ] 国际短信支持
- [ ] 验证码模板管理

## 总结

短信验证码功能已完整实现并测试通过，包括：
- ✅ 完整的后端API实现
- ✅ 前端UI交互
- ✅ 安全机制和错误处理
- ✅ 测试用例和文档

系统现在支持：
1. 短信验证码注册（必需）
2. 密码登录（原有功能）
3. 短信验证码登录（新增可选）

在开发模式下，验证码会显示在控制台中，便于测试。生产环境需要配置真实的短信服务商。