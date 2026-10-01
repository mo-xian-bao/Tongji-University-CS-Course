# Meal Reservation - API 文档（基于 backend/app.py，适合导入 Apifox）

说明：后端返回统一格式为 { success: boolean, message: string, data: ... }。鉴权使用 JWT，Header: Authorization: Bearer {token}。

---

概览
- Base URL (开发)：http://localhost:5000
- 默认 Content-Type: application/json（部分接口为 multipart/form-data）
- 鉴权：需要时在请求头加 Authorization: Bearer {JWT}

快速示例成功响应：
{
  "success": true,
  "message": "操作成功",
  "data": { ... }
}

快速示例失败响应：
{
  "success": false,
  "message": "错误信息",
  "error": "内部错误可选字段"
}

---

## 1) 健康检查
- 方法：GET
- 路径：/api/health
- Auth: 不需要
- Response: { success: true, message: "FoodBook API is running", status: "healthy" }

## 2) 注册
- 方法：POST
- 路径：/api/register
- Auth: 不需要
- Body (json):
  {
    "phone": "13800138000",
    "username": "testuser",
    "password": "123456",
    "confirmPassword": "123456",
    "smsCode": "123456"
  }
- Success (201):
  { "success": true, "message": "注册成功", "data": { "user": { "id": 1, "phone": "...", "username": "..." } } }

## 3) 登录（两种方式）
- 方法：POST
- 路径：/api/login
- Auth: 不需要
- Body (json) - 密码登录：
  { "identifier": "13800138000", "password": "123456", "loginType": "password" }
- Body (json) - 短信登录：
  { "identifier": "13800138000", "smsCode": "123456", "loginType": "sms" }
- Success: 返回 data.user 与 data.token（已在后端生成 JWT）
  { "success": true, "data": { "user": {...}, "token": "eyJ..." } }

## 4) 获取用户信息
- 方法：GET
- 路径：/api/users/profile
- Auth: 必需
- Response:
  { "success": true, "data": { "user": { "id": 1, "phone": "...", "username": "..." } } }

## 5) 发送短信验证码
- 方法：POST
- 路径：/api/sms/send
- Auth: 不需要
- Body:
  { "phone": "13800138000", "purpose": "register" } // purpose 可为 register/login/reset_password
- Response: { success: true, message: "验证码已发送" }

## 6) 密码重置（发送验证码）
- 方法：POST
- 路径：/api/reset-password/send-code
- Body: { "phone": "13800138000" }

## 7) 密码重置（执行）
- 方法：POST
- 路径：/api/reset-password
- Body 示例：
  {
    "phone": "13800138000",
    "smsCode": "123456",
    "newPassword": "newpass123",
    "confirmPassword": "newpass123"
  }

## 8) 登录后修改密码
- 方法：POST
- 路径：/api/users/change-password
- Auth: 必需
- Body:
  { "old_password": "old", "new_password": "new123" }

## 9) 修改手机号
- 方法：POST
- 路径：/api/users/change-phone
- Auth: 必需
- Body:
  { "new_phone": "13800xxxxxx", "sms_code": "123456" }

## 10) 更新用户资料（含头像上传）
- 方法：POST
- 路径：/api/users/update-profile
- Auth: 必需
- Content-Type: multipart/form-data
- Fields: username, bio, birthday (YYYY-MM-DD), avatar (file)
- Response: 返回更新后的 user

## 11) 文件上传（头像等）
- 方法：POST
- 路径：/api/upload
- Auth: 必需
- Content-Type: multipart/form-data, field name: file
- Success 返回：{ success: true, url: "http://.../static/uploads/avatar/xxx.jpg" }

## 12) 餐厅相关
- 方法：POST
- 路径：/api/restaurant
  - Auth: 必需
  - Body: { name, address, phone, opening_hours, notice, avatar_url }
  - 创建餐厅并返回 restaurant 对象

- 方法：PUT
- 路径：/api/restaurant/<restaurant_id>
  - Auth: 必需（需为餐厅所属用户）
  - Body: 任意要更新的字段

- 方法：GET
- 路径：/api/restaurant/user/<user_id>
  - Auth: 不需要
  - 返回该用户下的餐厅信息（data.restaurant）

- 方法：GET
- 路径：/api/restaurants
  - Auth: 不需要
  - 返回所有餐厅列表: { success: true, data: { restaurants: [...] } }

- 方法：GET
- 路径：/api/restaurants/<restaurant_id>
  - Auth: 不需要
  - 返回单个餐厅详情

## 13) 商家结算（示例）
- 方法：GET
- 路径：/api/merchant/settlements?from=2025-01-01&to=2025-01-31
  - Returns sample settlements list
- 方法：POST
- 路径：/api/merchant/settlements
  - Body: { order_id: "ORD1001" } // 标记为已结算（示例）

## 14) 广播（公告）
- 方法：POST
- 路径：/api/restaurant/<restaurant_id>/broadcasts
  - Body: { title, content, start_time, end_time, is_active }
- 方法：GET
- 路径：/api/restaurant/broadcasts?restaurant_id=1&include_inactive=false&page=1&per_page=20
- 方法：PATCH/PUT
- 路径：/api/restaurant/<restaurant_id>/broadcasts/<broadcast_id>
- 方法：DELETE
- 路径：/api/restaurant/<restaurant_id>/broadcasts/<broadcast_id>
- 方法：GET
- 路径：/api/restaurant/broadcasts/<broadcast_id>

## 15) 桌位管理（商家端）
- 方法：GET
- 路径：/api/tables
  - Auth: 必需
  - 返回当前用户餐厅的桌位：{ "tables": [...], "success": true }

- 方法：POST
- 路径：/api/tables
  - Auth: 必需
  - Body: { table_number, capacity, table_type, description }
  - Response: { table: {...}, success: true }

- 方法：GET
- 路径：/api/tables/<table_id>
  - Auth: 必需
  - 返回单桌详情并包含 active_orders 列表

- 方法：PUT
- 路径：/api/tables/<table_id>
  - Auth: 必需
  - Body: 支持 table_number, capacity, table_type, status, description

- 方法：DELETE
- 路径：/api/tables/<table_id>
  - Auth: 必需

## 16) 菜品（Dishes / Menu）
- 方法：GET
- 路径：/api/dishes?restaurant_id=1
  - 返回 { success: true, data: { dishes: [...], total: N } }

- 方法：POST
- 路径：/api/dishes
  - Body: { restaurant_id, name, price, category?, status?, stock_quantity?, unit?, description?, sort_order? }
  - Response: created dish

- 方法：GET
- 路径：/api/dishes/<dish_id>?restaurant_id=1
- 方法：PUT
- 路径：/api/dishes/<dish_id> (body 包含 restaurant_id)
- 方法：DELETE
- 路径：/api/dishes/<dish_id>?restaurant_id=1

- 方法：GET
- 路径：/api/dishes/menu/<restaurant_id>
  - 返回按分类分组的公开菜单（用于前端展示）

---

## Apifox 导入与 Mock 建议（实操）
1. 在 Apifox 新建项目并设置环境变量：
   - baseUrl = http://localhost:5000
   - token = （登录后提取）
2. 导入接口：可直接复制本文件内容逐条建接口，或在 Apifox 中新建请求并粘贴示例 Body/Response。
3. Mock 建议（示例 /api/tables 响应）：
{
  "success": true,
  "tables": [
    { "id": 1, "table_number": "A1", "capacity": 4, "table_type": "shared", "status": "available", "current_occupancy": 0 },
    { "id": 2, "table_number": "B1", "capacity": 6, "table_type": "private", "status": "occupied", "current_occupancy": 4 }
  ]
}
4. 对动态字段使用 Apifox 的 mock 脚本或占位符（例如 id、时间、token）。
5. 对需文件上传的接口（/api/upload, /api/users/update-profile）在 Apifox 中选择 form-data 并上传示例文件以测试。

---

## 自动化测试用例示例（可导入为测试集合）
- 套件：Auth 流程
  1. POST /api/sms/send -> 提示成功（mock）
  2. POST /api/register -> 断言 success==true
  3. POST /api/login -> 提取 token 环境变量

- 套件：桌位 CRUD
  1. GET /api/tables (使用 token) -> 断言 success==true
  2. POST /api/tables -> 断言 status 201 或 success==true, 提取 table.id
  3. GET /api/tables/{id} -> 断言 table_number 匹配
  4. PUT /api/tables/{id} -> 修改后 GET 验证
  5. DELETE /api/tables/{id} -> GET 返回 404 或 success==false

- 套件：菜品 CRUD
  1. GET /api/dishes?restaurant_id={id} -> 断言数据结构
  2. POST /api/dishes -> 创建并提取 dish.id
  3. PUT /api/dishes/{id} -> 断言字段更新
  4. DELETE /api/dishes/{id} -> 验证删除

测试断言关键点：HTTP 状态码、response.success、message 文案、data 中对象字段存在性与值。

---

## 常见问题与注意点
- 后端很多接口在没有餐厅数据时会返回 success=false 且 message 提示 “请先创建餐厅信息”，前端/测试用例需先创建餐厅或 mock 返回。
- 上传接口返回的 avatar_url 为完整可访问 URL，可用于前端预览。
- 所有需要鉴权的请求，需要先 POST /api/login 取到 token 并在后续请求加 Authorization 头。
- POST/PUT 的参数命名有时使用 snake_case（如 new_password）或 camelCase，按后端实现传参为准（文档中的示例采用后端实际命名）。

---

## 附录：快速在 Apifox 中创建测试环境的步骤
1. 新建环境，设置 baseUrl 与 token 变量。
2. 新建 Collection：Auth、Tables、Dishes、Restaurant、Files。
3. 为登录请求添加一个提取 token 的脚本并保存到环境变量。
4. 使用 Mock Server 模拟后端响应，加速前端开发。

（结束）
