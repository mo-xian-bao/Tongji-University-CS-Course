# MealReservation - 食刻预约平台

一个全栈的美食预订和外卖平台，支持用户点餐、商家管理、系统管理三大端，包含完整的订单系统、评价体系、用户申诉等功能。

## 🌟 功能特色

### 用户体验
- 📱 完整的移动端响应式设计
- 🛒 智能菜品推荐和搜索
- ⭐ 多维度评价系统（菜品、包装、服务）
- 💬 实时聊天功能
- 🔄 订单状态实时追踪
- 📋 个人订单管理
- 🎫 座位预定系统

### 商家管理
- 🍽️ 菜品管理和库存控制
- 📊 数据统计可视化仪表盘（新增）
- 📈 订单趋势和营收分析（新增）
- 🕐 热门时段和峰值分析（新增）
- 🏆 热门菜品排行榜（新增）
- 📥 Excel报表导出功能（新增）
- 💬 订单队列管理
- 📝 评价回复和管理
- 🔄 推送通知系统
- 🪑 桌位管理

### 系统管理
- 👥 用户管理（封禁/解封）
- 🏪 商家申请审核
- 📝 内容审核（评价/评论）
- ⚖️ 申诉处理系统
- 🔍 敏感词过滤
- 📊 平台数据统计

## 🏗️ 技术栈

### 前端
- **Vue 3** (Composition API) - 现代化的响应式框架
- **Vue Router 4** - 路由管理
- **Vite** - 快速的前端构建工具
- **Axios** - HTTP请求库
- **ECharts** - 数据可视化图表
- **Tailwind CSS** - 响应式样式框架

### 后端
- **Flask** - Python Web框架
- **SQLAlchemy** - ORM数据库操作
- **JWT** - 用户认证
- **Werkzeug** - 密码哈希和安全
- **PyMySQL** - MySQL数据库驱动
- **Flask-CORS** - 跨域支持
- **Pandas** - 数据分析和处理（新增）
- **OpenPyXL** - Excel文件生成（新增）

### 数据库
- **MySQL** - 主数据库（支持迁移）
- **SQLite** - 开发环境（可替换）

## 🚀 快速开始

### 环境要求
- Node.js 16+
- Python 3.8+
- MySQL 8.0+ (或 SQLite 开发环境)

### 安装步骤

#### 1. 克隆项目
```bash
git clone <repository-url>
cd FoodBook
```

#### 2. 后端设置
```bash
cd backend

# 安装依赖
pip install -r requirements.txt

# 配置环境变量（可选）
export SECRET_KEY=your-secret-key
export DATABASE_URL=mysql://user:password@localhost/foodbook

# 启动Flask服务器
python run.py
```

#### 3. 前端设置
```bash
cd ..

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

#### 4. 访问应用
- 前端：http://localhost:3000
- 后端API：http://localhost:5000

## 📁 项目结构

```
meal-reservation/
├── 📁 .claude/                    # Claude Code配置
├── 📁 .git/                       # Git版本控制
├── 📁 .gitlab/                    # GitLab CI/CD配置
├── 📄 API_DOCUMENTATION.md        # API文档（用于Apifox导入）
├── 📄 Apifox-使用指南.md           # Apifox使用指南
├── 📄 CLAUDE.md                   # Claude Code开发指南
├── 📄 DEVELOPMENT_GUIDE.md        # 开发指南
├── 📄 README.md                   # 项目说明文档
├── 📄 SMS_VERIFICATION_GUIDE.md  # 短信验证功能指南
├── 📄 index.html                  # HTML模板
├── 📄 package.json               # 前端项目配置
├── 📄 .gitignore                 # Git忽略规则
├── 📄 .gitlab-ci.yml             # CI/CD流水线配置
└── 📁 node_modules/               # 前端依赖包

🖥️ 后端结构 (Flask API - backend/)
├── 📄 app.py                      # 主Flask应用 (90KB)
├── 📄 Models.py                   # 数据库模型定义 (69KB)
├── 📄 db_exe.py                   # 数据库操作函数 (67KB)
├── 📄 run.py                      # 应用启动脚本
├── 📄 app_init.py                 # 应用初始化配置
├── 📄 requirements.txt            # Python依赖清单
├── 📄 init_db.py                  # 数据库初始化脚本
├── 📄 add_test_dishes.py          # 测试菜品生成器
├── 📄 generate_test_orders.py      # 测试订单生成器
├── 📄 auxiliary_function.py      # 辅助工具函数 (20KB)
├── 📄 sms_service.py              # 短信服务集成
├── 📄 alibabaSMSSender.py         # 阿里云短信发送器
├── 📄 ai_assistant_routes.py     # AI助手路由 (11KB)
├── 📄 coupon_recommendation.py   # 优惠券推荐系统 (14KB)
└── 📄 README.md                   # 后端文档

🔐 认证相关路由
├── 📄 auth_routes.py              # 身份认证路由 (10KB)
└── 📄 users_routes.py              # 用户管理路由 (10KB)

🍽️ 业务逻辑路由
├── 📄 dishes_routes.py            # 菜品管理路由 (23KB)
├── 📄 orders_routes.py             # 订单管理路由 (35KB)
├── 📄 restaurant_routes.py        # 餐厅管理路由 (20KB)
├── 📄 merchant_routes.py          # 商家管理路由 (90KB)
├── 📄 tables_routes.py             # 桌位管理路由 (6KB)
├── 📄 coupon_routes.py             # 优惠券系统路由 (15KB)
├── 📄 appeal_routes.py             # 申诉处理路由 (10KB)
└── 📄 support_routes.py            # 客服支持路由 (14KB)

👤 管理员路由
└── 📄 admin_routes.py              # 管理员功能路由 (34KB)

📁 脚本和工具
├── 📁 scripts/                    # 数据库迁移脚本
│   └── 📄 add_usertype_column.py  # 用户类型字段添加
└── 📁 tests/                      # 测试文件
    ├── 📄 conftest.py             # 测试配置
    ├── 📄 test_api_surface.py     # API接口测试
    ├── 📄 test_integration.py     # 集成测试
    ├── 📄 test_sms_api.py         # 短信API测试
    └── 📄 test_coupon_api.py      # 优惠券API测试

📁 静态文件存储
├── 📁 static/
│   ├── 📁 default/                # 默认图片
│   │   ├── 🖼️ avatar.png
│   │   ├── 🖼️ dish.png
│   │   └── 🖼️ restaurant.png
│   └── 📁 uploads/                # 用户上传文件
│       ├── 📁 appeals/           # 申诉附件
│       ├── 📁 avatar/            # 用户头像
│       ├── 📁 dishes/            # 菜品图片
│       ├── 📁 merchant/          # 商家文件
│       └── 📁 support/           # 支持文件
└── 📁 instance/                   # 实例特定文件

🎨 前端结构 (Vue3 - src/)
├── 📄 main.js                     # 应用入口文件
├── 📄 App.vue                     # 根组件
├──
├── 📁 router/                     # Vue路由配置
│   └── 📄 index.js               # 路由定义
├──
├── 📁 components/                 # 共享组件
│   └── 📄 AIAssistantFloating.vue # AI助手悬浮组件
├──
├── 🔐 认证模块
│   └── 📁 login_register/
│       ├── 📄 Login.vue          # 登录表单
│       ├── 📄 Register.vue       # 注册表单
│       └── 📄 ResetPassword.vue  # 密码重置
├──
├── 👤 用户端
│   └── 📁 user/
│       ├── 📁 components/
│       │   └── 📄 BottomNav.vue  # 底部导航
│       ├── 📁 messages/          # 消息中心
│       ├── 📁 order/             # 订单管理
│       ├── 📁 profile/           # 个人中心
│       └── 📁 shop/              # 商店浏览
│           └── 📁 components/    # 商店组件
├──
├── 🏪 商家端
│   └── 📁 merchant/
│       ├── 📄 MerchantLayout.vue  # 商家布局
│       ├── 📄 MerchantApplication.vue
│       ├── 📄 MerchantApplicationDetail.vue
│       └── 📁 views/            # 商家功能页面
│           ├── 📄 Dashboard.vue           # 商家仪表盘
│           ├── 📄 MenuList.vue            # 菜单管理
│           ├── 📄 OrderQueue.vue          # 订单队列
│           ├── 📄 PushNotification.vue    # 推送通知
│           ├── 📄 ReviewManagement.vue    # 评价管理
│           ├── 📄 Statistics.vue          # 数据统计
│           ├── 📄 StockStatistics.vue    # 库存统计
│           ├── 📄 StoreInfo.vue          # 店铺信息
│           └── 📄 TableManagement.vue    # 桌位管理
├──
├── 👤 管理员端
│   └── 📁 admin/
│       ├── 📄 AdminLayout.vue    # 管理员布局
│       ├── 📄 AccountBan.vue     # 账号封禁
│       ├── 📄 AppealHandling.vue # 申诉处理
│       ├── 📄 CommentManagement.vue # 评论管理
│       ├── 📄 Dashboard.vue      # 管理员仪表盘
│       └── 📄 StoreApplications.vue # 店铺申请
├──
└── 💬 客服端
    └── 📁 support/
        ├── 📄 SupportLayout.vue  # 客服布局
        ├── 📄 SupportChat.vue    # 聊天界面
        ├── 📄 SupportDashboard.vue # 客服仪表盘
        ├── 📄 SupportDesk.vue    # 客服工单
        └── 📄 SupportProcessing.vue # 工单处理
```

## 🗄️ 数据库模型

### 核心表结构
- **users** - 用户信息（管理员/商家/顾客）
- **user_info** - 用户扩展信息
- **restaurants** - 餐厅信息
- **dishes** - 菜品信息
- **orders** - 订单数据
- **order_items** - 订单项
- **tables** - 餐桌管理
- **reviews** - 用户评价
- **reviews_likes** - 评价点赞
- **merchant_applications** - 商家申请
- **user_bans** - 用户封禁
- **user_appeals** - 用户申诉

### 关键功能
- 完整的用户角色系统（0-管理员，1-商家，2-顾客, 100-客服）
- 智能订单状态管理
- 多层评价审核机制
- 灵活的封禁和解封系统
- 文件上传和附件管理

## 🎯 用户角色

### 管理员 (usertype = 0)
- 审核商家申请
- 用户管理和封禁
- 内容审核和删除
- 数据统计和分析
- 处理用户申诉

### 商家 (usertype = 1)
- 餐厅信息管理
- 菜品上架和管理
- 订单处理和确认
- 评价回复和管理
- 库存和桌位管理

### 顾客 (usertype = 2)
- 浏览和搜索餐厅
- 在线点餐和预订
- 订单追踪和管理
- 写评价和点赞
- 个人中心设置

### 客服 (usertype = 100)
- 查看所属和开放工单
- 与顾客沟通
- 写内部标注
- 处理工单

## 🔧 API 文档

### 认证相关
- `POST /api/register` - 用户注册
- `POST /api/login` - 用户登录
- `POST /api/logout` - 用户登出
- `GET /api/user/profile` - 获取用户信息

### 用户端API
- `GET /api/restaurants` - 获取餐厅列表
- `GET /api/restaurants/:id` - 获取餐厅详情
- `POST /api/orders` - 创建订单
- `GET /api/orders/user` - 获取用户订单
- `POST /api/reviews` - 提交评价

### 商家端API
- `GET /api/merchant/orders` - 获取订单队列
- `PUT /api/merchant/orders/:id` - 更新订单状态
- `POST /api/merchant/dishes` - 添加菜品
- `PUT /api/merchant/dishes/:id` - 更新菜品
- `GET /api/merchant/statistics/overview` - 获取运营数据概览（新增）
- `GET /api/merchant/statistics/trend` - 获取订单趋势数据（新增）
- `GET /api/merchant/statistics/peak-hours` - 获取热门时段分布（新增）
- `GET /api/merchant/statistics/top-dishes` - 获取热门菜品排行（新增）
- `GET /api/merchant/statistics/order-status` - 获取订单状态分布（新增）
- `GET /api/merchant/statistics/category-share` - 获取菜品分类占比（新增）
- `GET /api/merchant/statistics/export` - 导出统计报表（新增）

### 管理员端API
- `GET /api/admin/applications` - 获取商家申请
- `PUT /api/admin/applications/:id` - 审核申请
- `GET /api/admin/users` - 获取用户列表
- `POST /api/admin/bans` - 封禁用户
- `GET /api/admin/appeals` - 获取申诉列表

### 客服端API
- `GET /api/support/tickets/:id` - 获取单个工单详情
- `PUT /api/support/tickets/:id` - 更新单个工单
- `GET /api/support/tickets` - 用户获取工单列表
- `POST /api/support/upload` - 用户上传附件
- `GET /api/support/get_tickets` - 客服获取仪表盘数据
- `GET /api/support/get_alltickets` - 客服获取工单列表使用的数据

## 📊 开发工具

### APIfox集成
项目支持使用APIfox进行API测试和文档管理：
1. 导入 `API_DOCUMENTATION.md` 到APIfox
2. 配置环境变量：
   - `BASE_URL`: http://localhost:5000
   - `Authorization`: Bearer {token}
3. 使用APIfox进行API测试和文档维护

### 调试和测试
```bash
# 后端API测试
cd backend
python test_api.py

# 数据库初始化
cd backend
python app_init.py
```

## 🎨 开发说明

### 前端开发
- 使用Vue3 Composition API进行组件开发
- 路由使用hash模式兼容性更好
- Axios拦截器处理认证和错误
- ECharts进行数据可视化
- 响应式设计支持移动端

### 后端开发
- Flask应用遵循MVC模式
- SQLAlchemy ORM进行数据库操作
- JWT进行用户认证
- 文件上传使用安全验证
- 支持CORS跨域请求

### 数据库设计
- 遵循第三范式
- 支持软删除机制
- 使用索引优化查询性能
- 支持事务处理

## 🔒 安全特性

- JWT用户认证
- 密码哈希存储
- 文件上传安全验证
- SQL注入防护
- XSS攻击防护
- 用户输入验证和过滤

## 🚀 部署说明

### 开发环境
- 前端：Vite开发服务器
- 后端：Flask开发服务器
- 数据库：SQLite（开发环境）

### 生产环境
- 前端：Nginx + 静态文件
- 后端：Gunicorn + Flask
- 数据库：MySQL集群
- 文件存储：云存储服务

## 📈 性能优化

- 前端代码分割和懒加载
- 数据库查询优化
- 缓存机制实现
- 图片压缩和CDN
- API响应优化

## 🤝 贡献指南

1. Fork项目
2. 创建功能分支
3. 提交代码更改
4. 创建Pull Request
5. 等待代码审查

## 📄 许可证

MIT License

## 📊 数据统计可视化功能（新增）

### 功能特性

商家端新增了完整的数据统计可视化功能，帮助商家更好地了解经营状况：

#### 核心指标卡片
- 📦 **总订单量** - 显示订单总数及环比增长率，带迷你趋势图
- 💰 **总营业额** - 展示实际收入及增长情况
- 🧾 **客单价** - 人均消费金额分析
- 🚫 **订单取消率** - 实时监控服务质量（>10%预警）
- 🍽️ **在售菜品数** - 菜单丰富度统计

#### 可视化图表
- 📈 **订单与营收趋势** - 双轴混合图展示订单量和营业额走势
- 🕐 **热门时段分布** - 识别高峰期和低谷期，优化排班
- 🔄 **订单状态分布** - 环形图展示不同状态订单占比
- 🏆 **热门菜品排行榜** - 横向条形图展示Top 10菜品销量
- 🥧 **菜品分类占比** - 南丁格尔玫瑰图展示产品结构

#### 筛选与导出
- 📅 **灵活的时间筛选** - 支持今日、昨日、近7天、近30天及自定义范围
- 📥 **Excel报表导出** - 一键导出包含订单明细、菜品统计、每日汇总的完整报表

### 使用文档

详细的使用说明和API文档：
- 📖 [统计功能使用指南](./STATISTICS_GUIDE.md) - 界面说明、使用场景、数据分析技巧
- 🔧 [统计API文档](./STATISTICS_API.md) - 完整的接口说明和示例代码
- 🚀 [部署指南](./DEPLOYMENT_GUIDE.md) - 安装步骤、配置说明、故障排查

### 技术实现

- **前端**: Vue 3 + ECharts 实现交互式数据可视化
- **后端**: Flask + Pandas 进行数据聚合和分析
- **导出**: OpenPyXL + XlsxWriter 生成专业Excel报表
- **性能**: 数据库索引优化 + 并行请求 + 响应缓存

## 📞 技术支持

如有问题，请提交Issue或联系开发团队。

详细文档：
- [API文档](./API_DOCUMENTATION.md)
- [开发指南](./DEVELOPMENT_GUIDE.md)
- [统计功能使用指南](./STATISTICS_GUIDE.md)

---

*本项目基于Vue3 + Flask + MySQL构建，是一个完整的O2O美食预订解决方案。*