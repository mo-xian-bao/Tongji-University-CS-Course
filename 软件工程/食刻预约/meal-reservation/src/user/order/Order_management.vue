<template>
  <div class="order-management">
    <header class="header">
      <h1>我的订单</h1>
    </header>

    <main class="order-list">
      <div v-if="loading" class="empty-state">
        <p>加载中...</p>
      </div>

      <div v-else-if="orders.length === 0" class="empty-state">
        <p>暂无订单</p>
        <p class="empty-hint">快去下单吧~</p>
      </div>

      <div v-else>
        <div
          v-for="order in orders"
          :key="order.orderId"
          class="order-card"
          @click="viewOrderDetails(order)"
        >
          <span :class="['status-badge', `status-badge--${order.status}`]">
            {{ getStatusLabel(order.status) }}
          </span>

          <!-- 修改 img 标签，添加 @error 处理 -->
          <img 
            :src="order.imageUrl" 
            :alt="order.restaurant" 
            class="food-image" 
            @error="handleImageError"
          />
          <div class="order-details">
            <div class="order-header">
              <h2 class="restaurant-name">{{ order.restaurant }}</h2>
            </div>

            <div class="order-info">
              <span class="order-number">{{ order.id }}</span>
              <span class="order-date">{{ order.date }}</span>
            </div>

            <div class="order-footer">
              <p class="order-price">{{ order.price }}元</p>

              <div class="order-actions">
                <!-- 新：统一联系商家按钮（所有状态可见） -->
                <button class="btn btn--primary btn--small" @click.stop.prevent="contactMerchant(order)" @touchend.stop.prevent="contactMerchant(order)">
                  联系商家
                </button>
                
                <!-- 新：评价相关按钮（仅已完成订单） -->
                <template v-if="order.status === 'completed'">
                  <button v-if="!order.has_review" class="btn btn--primary btn--small" @click.stop.prevent="goToWriteReview(order.orderId, false)" @touchend.stop.prevent="goToWriteReview(order.orderId, false)">
                    评价
                  </button>
                  <button v-else class="btn btn--outline btn--small" @click.stop="goToWriteReview(order.orderId, true)">
                    查看评价
                  </button>
                </template>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>

    <BottomNav />
  </div>
</template>

<script>
import BottomNav from '../components/BottomNav.vue'

export default {
  name: 'OrderManagement',
  components: { BottomNav },
  data() {
    return {
      orders: [],
      loading: false
    }
  },
  mounted() {
    this.fetchOrders()
  },
  methods: {
    // 添加图片加载失败处理方法
    handleImageError(e) {
      e.target.src = `${API_url}/static/default/dish.png`;
    },
    async fetchOrders() {
      try {
        this.loading = true
        const token = localStorage.getItem('token')
        if (!token) {
          this.$router.push('/login')
          return
        }
        const resp = await fetch('/api/orders', {
          headers: { Authorization: `Bearer ${token}` }
        })
        const result = await resp.json()
        if (result.success) {
          this.orders = result.data.map(o => {
            const firstItem = o.items && o.items.length ? o.items[0] : null
            // 构造图片URL，如果后端没返回则使用默认图
            let imageUrl = `${API_url}/static/default/dish.png`;
            if (firstItem && firstItem.dish_image) {
              imageUrl = `${API_url}${firstItem.dish_image}`;
            }

            return {
              id: o.order_number,
              orderId: o.id,
              restaurant: o.restaurant_name,
              date: new Date(o.order_time).toLocaleString('zh-CN'),
              price: Number(o.total_price).toFixed(0),
              imageUrl: imageUrl,
              status: (o.status || '').trim().toLowerCase(),
              has_review: o.has_review || false, // 新增：是否已评价
              raw: o
            }
          })
        } else {
          console.error('获取订单失败', result)
        }
      } catch (err) {
        console.error('fetchOrders error', err)
      } finally {
        this.loading = false
      }
    },

    viewOrderDetails(order) {
      // 跳转到订单详情页（保留原逻辑）
      this.$router.push({ name: 'OrderDetails', params: { id: order.orderId } })
    },

    contactMerchant(order) {
      // 进入商家聊天界面并携带必要参数
      const restaurantId = order.raw.restaurant_id || order.raw.restaurantId || null
      this.$router.push({
        name: 'MerchantChat',
        params: { restaurantId },
        query: { orderId: order.orderId }
      })
    },

    getStatusLabel(status) {
      const normalized = (status || '').trim().toLowerCase()
      const map = {
        pending: '等待接单',
        confirmed: '出餐中',
        dining: '用餐中',
        completed: '已完成',
        cancelled: '已取消',
        rejected: '商家拒单'
      }
      return map[normalized] || '未知状态'
    },

    goToWriteReview(orderId, hasReview) {
      if (hasReview) {
        // 如果已有评价跳转详情页或带 mode=detail 到 WriteReview
        this.$router.push({ name: 'WriteReview', params: { orderId }, query: { mode: 'detail' } })
      } else {
        this.$router.push({ name: 'WriteReview', params: { orderId } })
      }
    },
  }
}
</script>

<style scoped>
.order-management {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  background-color: #f5f5f5;
  min-height: 100vh;
  padding-bottom: 60px; /* Space for footer */
}

.header {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 10px 15px;
  background-color: #fff;
  border-bottom: 1px solid #eee;
}

.header h1 {
  font-size: 18px;
  font-weight: 600;
  margin: 0;
}

.order-list {
  padding: 10px;
}

.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: #999;
}

.empty-state p {
  margin: 10px 0;
  font-size: 16px;
}

.empty-hint {
  font-size: 14px;
  color: #ccc;
}

.order-card {
  cursor: pointer;
  display: flex;
  align-items: center;
  background-color: #fff;
  border-radius: 8px;
  padding: 8px; /* 修改：从 10px 减小到 8px */
  margin-bottom: 8px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  position: relative;
}

.status-badge {
  position: absolute;
  top: 8px; /* 修改：从 10px 减小到 8px，与 padding 保持一致 */
  right: 8px; /* 修改：从 10px 减小到 8px */
  font-size: 11px;
  padding: 3px 8px;
  border-radius: 999px;
  background: #f0f0f0;
  color: #666;
}
.status-badge--pending { background: #ffe9c7; color: #d9822b; }
.status-badge--confirmed { background: #cce5ff; color: #1b6ec2; }
.status-badge--dining { background: #e0f7e9; color: #1d9a5f; }
.status-badge--completed { background: #e4e4e4; color: #666; }
.status-badge--cancelled,
.status-badge--rejected { background: #ffe0e0; color: #c0392b; }

.food-image {
  width: 84px; /* 修改：从 56px 减小到 48px */
  height: 84px; /* 修改：从 56px 减小到 48px */
  border-radius: 4px;
  margin-right: 10px;
  object-fit: cover;
  flex-shrink: 0;
}

.order-details {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.order-header h2.restaurant-name {
  font-size: 15px;
  margin: 0; /* 新增：确保移除 h2 默认的上下边距 */
}

.order-info {
    display: flex;
    flex-direction: column;
    gap: 0; /* 修改：从 1px 减小到 0 */
    margin-bottom: auto;
}

.order-number, .order-date {
  font-size: 11px; /* 减小字体 */
  color: #aaa;
}

.copy-button {
  padding: 1px 6px; /* 减小按钮内边距 */
  font-size: 9px; /* 减小字体 */
  margin-left: 4px;
}

.order-price {
  font-size: 15px; /* 减小价格字体 */
  font-weight: bold;
  color: #333;
  margin: 0;
}

.order-footer {
  margin-top: 4px; /* 修改：从 6px 减小到 4px */
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  gap: 8px;
}

.review-button, .action-btn {
  padding: 4px 10px; /* 减小按钮内边距 */
  border-radius: 5px;
  font-size: 11px; /* 减小字体 */
}

.order-actions {
  display: flex;
  gap: 6px; /* 减小按钮间距 */
  margin-left: auto;
}

/* 移除不再需要的样式 */
/* .order-card .order-actions + .review-button { ... } */

.footer-nav {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  justify-content: space-around;
  background-color: #fff;
  border-top: 1px solid #eee;
  padding: 5px 0;
}

.nav-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  font-size: 10px;
  color: #999;
  text-decoration: none;
}

.nav-item.active {
    color: #333;
}

.nav-icon {
    font-size: 20px;
    margin-bottom: 2px;
}

.modal-mask {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.45);
  display: flex;
  justify-content: center;
  align-items: flex-end;
  padding: 20px;
  z-index: 2000;
}

.modal-panel {
  width: 100%;
  max-width: 480px;
  background: #fff;
  border-radius: 16px 16px 0 0;
  padding: 20px;
}

.modal-panel--large {
  max-height: 90vh;
  overflow: auto;
}

.modal-panel h3 {
  margin-top: 0;
  font-size: 18px;
  text-align: center;
}

.modal-loading {
  text-align: center;
  padding: 20px 0;
  color: #999;
}

.modal-textarea {
  width: 100%;
  border: 1px solid #eee;
  border-radius: 8px;
  padding: 10px;
  font-size: 14px;
  resize: none;
}

.modal-actions {
  margin-top: 16px;
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

.edit-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 0;
  border-bottom: 1px solid #f2f2f2;
}

.edit-item-info {
  display: flex;
  flex-direction: column;
}

.edit-item-name {
  font-size: 14px;
  margin: 0;
}

.edit-item-price {
  font-size: 12px;
  color: #999;
  margin-top: 4px;
}

.edit-item-actions {
  display: flex;
  align-items: center;
  gap: 8px;
}

.qty-btn {
  width: 28px;
  height: 28px;
  border: none;
  border-radius: 4px;
  background: #f0f0f0;
  cursor: pointer;
}

.qty-value {
  min-width: 24px;
  text-align: center;
}

.remove-btn {
  border: none;
  background: transparent;
  color: #ff6b6b;
  cursor: pointer;
}

.form-row {
  margin-top: 12px;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.form-row-group {
  margin-top: 16px;
  padding-top: 12px;
  border-top: 1px solid #f5f5f5;
}

.form-row input,
.form-row textarea,
.form-row select {
  border: 1px solid #eee;
  border-radius: 6px;
  padding: 8px;
  font-size: 14px;
}

.edit-summary {
  margin-top: 16px;
  font-size: 16px;
  text-align: right;
}

.request-status-prompt {
  font-size: 11px; /* 减小字体 */
  color: #e67e22;
  display: flex;
  align-items: center;
  gap: 4px;
  flex-grow: 1;
  justify-content: flex-start;
  padding-left: 4px;
}

.btn-link {
  padding: 0;
  font-size: 11px; /* 减小字体 */
}

/* 新增：申请结果弹窗中的对比视图样式 */
/* 对比视图改为单列展示 */
.comparison-grid {
  margin-top: 15px;
  display: grid;
  grid-template-columns: 1fr; /* 单列显示 */
  gap: 12px;
  border-top: 1px solid #f0f0f0;
  padding-top: 12px;
  justify-items: start;
}
.comparison-grid.single-col .comparison-col {
  max-width: 520px;
  margin: 0 auto; /* 居中显示申请内容 */
}
.comparison-col h5 {
  margin-top: 0;
  margin-bottom: 8px;
  font-size: 14px;
}
.comparison-col ul {
  padding-left: 18px;
  margin: 5px 0;
  font-size: 13px;
  color: #555;
}
.comparison-col p {
  font-size: 13px;
  color: #555;
}

/* 新增：申请状态 pill */
.request-pill {
  display: inline-block;
  padding: 4px 10px;
  border-radius: 999px;
  font-size: 12px;
  color: #fff;
  font-weight: 600;
  min-width: 90px;
  text-align: center;
}

/* 颜色定义 */
.request-pill--pending { background-color: #f0ad4e; }    /* 橙色 - 审核中 */
.request-pill--approved { background-color: #2ecc71; }   /* 绿色 - 同意 */
.request-pill--rejected { background-color: #e74c3c; }   /* 红色 - 拒绝 */
.request-pill--withdrawn { background-color: #95a5a6; }  /* 灰色 - 已撤回 */

/* 兼容：在 request-status-prompt 中保留文案样式 */
.request-status-prompt .btn-link { margin-left: 8px; font-size: 12px; color: #2c7be5; }

/* 新增：统一按钮样式 */
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  border-radius: 10px;
  padding: 6px 12px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: transform .08s ease, box-shadow .12s ease, opacity .12s ease;
  border: none;
  min-height: 34px;
  box-shadow: 0 1px 4px rgba(12, 40, 77, 0.06);
}

/* 主按钮：蓝色渐变 */
.btn--primary {
  background: linear-gradient(180deg,#2c7be5,#1a6ed6);
  color: #fff;
  border: 1px solid rgba(0,0,0,0.06);
}
.btn--primary:hover { transform: translateY(-1px); box-shadow: 0 6px 18px rgba(44,123,229,0.12); }
.btn--primary:active { transform: translateY(0); box-shadow: 0 3px 8px rgba(44,123,229,0.08); }

/* 危险操作：红色 */
.btn--danger {
  background: linear-gradient(180deg,#ff7b7b,#ff5b5b);
  color: #fff;
  border: 1px solid rgba(0,0,0,0.06);
}
.btn--danger:hover { transform: translateY(-1px); box-shadow: 0 6px 18px rgba(255,91,91,0.12); }

/* 轮廓按钮：空心，用于二级操作 */
.btn--outline {
  background: #fff;
  color: #2c7be5;
  border: 1px solid #dbe9ff;
  box-shadow: none;
}
.btn--outline:hover { background: #fbfdff; transform: translateY(-1px); }

/* 禁用状态 */
.btn[disabled], .btn:disabled {
  opacity: .55;
  cursor: not-allowed;
  transform: none;
  box-shadow: none;
}

/* 小尺寸按钮（可复用） */
.btn--small { padding: 4px 8px; font-size: 12px; min-height: 28px; }

/* 保留 .action-btn 兼容（渐进替换）*/
.action-btn { /* 旧类短暂留空或略微调整，避免样式冲突 */ }
.action-btn.danger { /* 保留但不必要 */ }
</style>