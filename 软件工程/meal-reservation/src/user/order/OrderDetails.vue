<template>
  <div v-if="order" class="order-details-page">
    <header class="details-header">
      <span class="back-arrow" @click="goBack">&lt;</span>
      <h1>{{ getStatusText() }}</h1>
    </header>

    <!-- 取单号显示卡片 -->
    <div
      v-if="order && order.pickup_number && order.status !== 'confirmed'"
      class="pickup-number-card"
    >
      <div class="pickup-label">取单号</div>
      <div class="pickup-number-large">{{ order.pickup_number }}</div>
      <div class="pickup-hint">请凭此号码取餐</div>
    </div>
    <div
      v-else-if="order && order.status === 'confirmed'"
      class="pickup-number-card"
    >
      <div class="pickup-number-large">商家备餐中~</div>
      <div class="pickup-hint">稍后将生成取餐号</div>
    </div>

    <!-- 移除了 top-actions-card -->

    <main class="details-content">
      <div class="card">
        <div class="restaurant-header">
          <span class="store-icon">📄</span>
          <span>{{ order.restaurant }}</span>
        </div>
        <div v-for="(item, index) in order.items" :key="index" class="item-row">
          <!-- 修改 img 标签，添加 @error 处理 -->
          <img 
            :src="item.imageUrl" 
            :alt="item.name" 
            class="item-image" 
            @error="handleImageError"
          />
          <div class="item-info">
            <span class="item-name">{{ item.name }}</span>
            <span class="item-desc" v-if="item.desc">{{ item.desc }}</span>
          </div>
          <span class="item-quantity">x {{ item.quantity }}</span>
          <span class="item-price">¥{{ item.price }}</span>
        </div>
        
        <!-- 价格明细 -->
        <div class="price-detail">
          <div class="price-row">
            <span>商品总额</span>
            <span>¥{{ order.originalPrice || order.totalPrice }}</span>
          </div>
          <div v-if="order.coupon" class="price-row discount-row">
            <span>
              <span class="coupon-badge">券</span>
              {{ order.coupon.title }}
            </span>
            <span class="discount-amount">-¥{{ order.discountAmount }}</span>
          </div>
        </div>
        
        <div class="total-row">
          <!-- 移除了 致电商家 -->
          <span class="total-price">实付 <span class="price-value">¥{{ order.totalPrice }}</span></span>
        </div>
      </div>

      <div class="card info-list">
        <div class="info-row">
          <span class="label">订单编号</span>
          <span class="value">
            {{ order.id }}
            <button class="copy-button" @click="copyOrderId(order.id)">复制</button>
          </span>
        </div>
        <div class="info-row">
          <span class="label">下单时间</span>
          <span class="value">{{ order.orderTime }}</span>
        </div>
        <div class="info-row">
          <span class="label">支付时间</span>
          <span class="value">{{ order.paymentTime }}</span>
        </div>
        <div class="info-row">
          <span class="label">桌号</span>
          <span class="value">{{ order.tableNumber }}</span>
        </div>
        <!-- 显示拒绝理由 -->
        <div class="info-row" v-if="order.status === 'rejected' && order.reject_reason">
          <span class="label">拒绝理由</span>
          <span class="value reject-reason">{{ order.reject_reason }}</span>
        </div>
      </div>
    </main>
  </div>
  <div v-else class="loading-container">
    <p>加载订单详情中...</p>
  </div>
</template>

<script>
import { getOrder } from '@/api/orders'

export default {
  name: 'OrderDetails',
  data() {
    return {
      order: null,
      loading: false
    };
  },
  mounted() {
    const orderId = this.$route.params.id;
    if (orderId) {
      this.fetchOrderDetails(orderId);
    }
  },
  methods: {
    // 添加图片加载失败处理方法
    handleImageError(e) {
      e.target.src = `${API_url}/static/default/dish.png`;
    },
    // 从后端获取订单详细数据
    async fetchOrderDetails(id) {
      try {
        this.loading = true;

        const res = await getOrder(id)
        const result = res.data

        if (result.success) {
          const orderData = result.data;
          
          // 转换数据格式以适配模板
          this.order = {
            id: orderData.order_number,
            restaurant: orderData.restaurant_name,
            totalPrice: orderData.total_price,
            originalPrice: orderData.original_price || orderData.total_price,
            discountAmount: orderData.discount_amount || 0,
            coupon: orderData.coupon,
            orderTime: new Date(orderData.order_time).toLocaleTimeString(),
            paymentTime: orderData.confirmed_time ? new Date(orderData.confirmed_time).toLocaleTimeString() : '未支付',
            tableNumber: orderData.table_number || '打包取餐',
            pickup_number: orderData.pickup_number,  // 注意这里使用下划线
            status: orderData.status,
            reject_reason: orderData.reject_reason,
            items: orderData.items.map(item => ({
              name: item.dish_name,
              desc: this.getItemOptions(item),
              quantity: item.quantity,
              price: item.unit_price,
              // 修改此处：设置默认图片逻辑
              imageUrl: item.dish_image ? `${API_url}${item.dish_image}` : `${API_url}/static/default/dish.png`
            }))
          };
        } else {
          console.error('API返回失败:', result);
          alert(result.message || '获取订单详情失败');
          this.$router.push({ name: 'OrderManagement' });
        }

      } catch (error) {
        console.error("获取订单详情失败:", error);
        console.error("错误详情:", error.message, error.stack);
        alert("无法加载订单详情，请稍后重试。");
        // 不要自动跳转，让用户可以看到错误
        // this.$router.push({ name: 'OrderManagement' });
      } finally {
        this.loading = false;
      }
    },
    // 生成菜品选项描述
    getItemOptions(item) {
      const options = [];
      if (item.spiciness) options.push(item.spiciness);
      if (item.garnish) options.push(item.garnish);
      return options.join(',');
    },
    // 获取订单状态文本
    getStatusText() {
      if (!this.order) return '订单详情';
      
      const statusMap = {
        'pending': '等待商家确认',
        'confirmed': '商家已接单',
        'rejected': '商家拒绝接单',
        'dining': '用餐中',
        'completed': '订单已完成',
        'cancelled': '订单已取消'
      };
      
      return statusMap[this.order.status] || '订单详情';
    },
    goBack() {
      // 优先尝试返回上一页，如果历史记录为空，则跳转到订单列表
      if (window.history.length > 1) {
        this.$router.back();
      } else {
        this.$router.push({ name: 'OrderManagement' });
      }
    },
    copyOrderId(id) {
      navigator.clipboard.writeText(id).then(() => {
        alert('订单号已复制');
      }).catch(err => {
        console.error('复制失败: ', err);
      });
    }
  }
};
</script>

<style scoped>
.order-details-page {
  /* 将背景渐变应用到整个页面 */
  background: linear-gradient(to bottom, #ff7800 0%, #f7e7e7 200px);
  min-height: 100vh;
}

.details-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px;
  color: white;
  /* 使头部背景透明，以显示页面的渐变背景 */
  background: transparent;
  position: relative;
  padding-top: 50px; /* Space for status bar */
  height: 130px; /* 固定头部高度以容纳渐变 */
}
.details-header h1 {
  font-size: 22px;
  font-weight: bold;
  position: absolute;
  left: 15px;
  bottom: 40px; /* 从 20px 增加到 30px，使其上移 */
}
.back-arrow {
  position: absolute;
  top: 20px; /* 从 50px 修改为 40px，使其上移 */
  left: 15px;
  font-size: 24px;
  cursor: pointer;
}

/* 取单号卡片样式 */
.pickup-number-card {
  background: linear-gradient(135deg, #ff8c00 0%, #ff6600 100%);
  border-radius: 16px;
  padding: 20px;
  margin: -30px 15px 15px 15px;
  position: relative;
  z-index: 3;
  box-shadow: 0 8px 16px rgba(255, 140, 0, 0.3);
  text-align: center;
  color: white;
}

.pickup-label {
  font-size: 14px;
  opacity: 0.9;
  margin-bottom: 8px;
  letter-spacing: 1px;
}

.pickup-number-large {
  font-size: 56px;
  font-weight: bold;
  letter-spacing: 8px;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  margin: 10px 0;
  font-family: 'Arial Black', sans-serif;
}

.pickup-hint {
  font-size: 13px;
  opacity: 0.85;
  margin-top: 8px;
}

.details-content {
  padding: 0 15px;
}
.card {
  background-color: #fff;
  border-radius: 12px;
  padding: 15px;
  margin-bottom: 10px;
}

.restaurant-header {
  display: flex;
  align-items: center;
  gap: 8px;
  padding-bottom: 15px;
  border-bottom: 1px solid #f5f5f5;
  font-weight: bold;
}
.store-icon {
  font-size: 20px;
}

.item-row {
  display: flex;
  align-items: center;
  padding: 15px 0;
}
.item-image {
  width: 50px;
  height: 50px;
  border-radius: 8px;
  margin-right: 10px;
}
.item-info {
  flex-grow: 1;
}
.item-name {
  font-weight: bold;
}
.item-desc {
  font-size: 12px;
  color: #999;
}
.item-quantity {
  font-size: 12px;
  color: #999;
  margin: 0 15px;
}
.item-price {
  font-weight: bold;
}

/* 价格明细样式 */
.price-detail {
  padding: 15px 0;
  border-bottom: 1px solid #f5f5f5;
}

.price-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 0;
  font-size: 14px;
  color: #666;
}

.price-row.discount-row {
  color: #ff4d4f;
}

.coupon-badge {
  display: inline-block;
  background-color: #ff4d4f;
  color: white;
  padding: 2px 6px;
  border-radius: 4px;
  font-size: 11px;
  margin-right: 6px;
  font-weight: 500;
}

.discount-amount {
  color: #ff4d4f;
  font-weight: 500;
}

.total-row {
  display: flex;
  justify-content: flex-end; /* 修改为靠右对齐 */
  align-items: center;
  padding-top: 15px;
  border-top: 1px solid #f5f5f5;
  font-size: 14px;
}
.total-price .price-value {
  font-size: 20px;
  font-weight: bold;
}

.info-list .info-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
  font-size: 14px;
}
.info-list .label {
  color: #666;
}
.info-list .value {
  color: #333;
}
.copy-button {
  background-color: #f0f0f0;
  border: none;
  border-radius: 10px;
  padding: 2px 8px;
  font-size: 10px;
  margin-left: 5px;
  cursor: pointer;
}

/* 拒绝理由样式 */
.reject-reason {
  color: #e74c3c;
  font-weight: 500;
}

/* 加载容器 */
.loading-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  font-size: 16px;
  color: #666;
}
</style>