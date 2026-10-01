# 直接交换接口文档

## 接口信息

**路径**: `POST /exchange/direct`

**功能**: 实现双方场地直接交换（用户A用自己的场地Y交换用户B的场地X，前提是B需要Y）

**认证**: 需要JWT Token

## 请求参数

```json
{
  "target_user": "string",      // 对方用户名（2-50字符）
  "my_court_id": "integer",     // 我的场地ID（0-1000）
  "their_court_id": "integer"   // 对方的场地ID（0-1000）
}
```

## 响应

### 成功响应 (200)
```json
{
  "message": "交换成功！您的场地123已与user2的场地456完成交换"
}
```

### 错误响应

**400 - 不能与自己交换**
```json
{
  "detail": "不能与自己交换场地"
}
```

**404 - 场地不存在**
```json
{
  "detail": "您没有此场地"
}
// 或
{
  "detail": "对方没有此场地"
}
```

**400 - 不满足交换条件**
```json
{
  "detail": "对方没有发布对您场地的需求"
}
```

## 交换逻辑

1. **验证我的场地存在**: 检查当前用户是否拥有 `my_court_id`
2. **验证对方场地存在**: 检查 `target_user` 是否拥有 `their_court_id`
3. **验证对方需求**: 检查 `target_user` 是否发布了对 `my_court_id`（相同时间段）的需求
4. **执行真实交换**: 
   - **修改场地所有权**：
     - 我的场地Y的 `username` 改为对方
     - 对方场地X的 `username` 改为我
   - **删除已满足的需求**：
     - 删除对方对我场地Y的需求记录（已被满足）
     - 如果我也发布了对对方场地X的需求，也删除
5. **记录交换历史**: 
   - 创建A→B的交换记录
   - 创建B→A的交换记录
   - 状态直接标记为 `completed`

## 数据库变化

### owned_courts 集合（场地所有权交换）

**交换前:**
```javascript
// A的场地
{ _id: ..., username: "userA", court_id: 123, start_at: ..., end_at: ... }
// B的场地
{ _id: ..., username: "userB", court_id: 456, start_at: ..., end_at: ... }
```

**交换后:**
```javascript
// 原A的场地现在属于B
{ _id: ..., username: "userB", court_id: 123, start_at: ..., end_at: ... }
// 原B的场地现在属于A
{ _id: ..., username: "userA", court_id: 456, start_at: ..., end_at: ... }
```

### wanted_courts 集合（删除已满足的需求）

**交换前:**
```javascript
// B的需求（需要A的场地123）
{ _id: ..., username: "userB", court_id: 123, start_at: ..., end_at: ... }
// 如果A也有需求（需要B的场地456）
{ _id: ..., username: "userA", court_id: 456, start_at: ..., end_at: ... }
```

**交换后:**
```javascript
// 以上需求记录全部被删除（已满足）
```

### exchange_requests 集合（交换历史记录）

**新增两条记录:**
```javascript
// 用户A给用户B的记录
{
  post_user_name: "userB",
  request_user_name: "userA",
  court_id: 123,              // A原来的场地
  target_court_id: 456,       // B原来的场地
  exchange_type: "direct",
  status: "completed",
  created_at: ISODate(...)
}

// 用户B给用户A的记录
{
  post_user_name: "userA",
  request_user_name: "userB",
  court_id: 456,              // B原来的场地
  target_court_id: 123,       // A原来的场地
  exchange_type: "direct",
  status: "completed",
  created_at: ISODate(...)
}
```

## 测试场景

### 场景1：成功交换
```bash
# 前置条件：
# - 用户A有场地101 (2025-11-20 14:00-16:00)
# - 用户B有场地202 (2025-11-20 10:00-12:00)
# - 用户B发布了对场地101 (2025-11-20 14:00-16:00) 的需求

curl -X POST http://127.0.0.1:8000/exchange/direct \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <userA_token>" \
  -d '{
    "target_user": "userB",
    "my_court_id": 101,
    "their_court_id": 202
  }'

# 预期结果：200 OK，交换成功
```

### 场景2：对方未发布需求
```bash
# 前置条件：用户B没有发布对场地101的需求

# 预期结果：400 Bad Request
# {"detail": "对方没有发布对您场地的需求"}
```

### 场景3：场地不存在
```bash
# 前置条件：用户A没有场地999

curl -X POST http://127.0.0.1:8000/exchange/direct \
  -H "Authorization: Bearer <userA_token>" \
  -d '{
    "target_user": "userB",
    "my_court_id": 999,
    "their_court_id": 202
  }'

# 预期结果：404 Not Found
# {"detail": "您没有此场地"}
```

## 前端调用示例

```javascript
// dashboard.html 和 search.html 中已实现
async function directExchange(targetUser, myCourtId, theirCourtId) {
  const response = await fetch(`${API_BASE}/exchange/direct`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${token}`
    },
    body: JSON.stringify({
      target_user: targetUser,
      my_court_id: parseInt(myCourtId),
      their_court_id: parseInt(theirCourtId)
    })
  });
  
  const result = await response.json();
  if (response.ok) {
    alert(result.message);
    // 刷新页面数据
  } else {
    alert(result.detail);
  }
}
```

## 注意事项

1. **时间匹配严格**: 场地的 `start_at` 和 `end_at` 必须完全一致才算匹配
2. **单向需求验证**: 只验证对方是否需要我的场地，不验证我是否需要对方的场地
3. **自动完成**: 交换记录状态直接设为 `completed`，无需审批流程
4. **双向记录**: 确保双方都能查询到交换历史
5. **幂等性**: 暂未实现防重复提交，后续可添加唯一约束

## 相关接口

- `POST /courts/owned/post` - 发布已有场地
- `POST /courts/wanted/post` - 发布需求场地
- `POST /exchange/request` - 普通交换申请（需要对方审批）
- `POST /exchange/fulfill` - 满足需求（待实现）
