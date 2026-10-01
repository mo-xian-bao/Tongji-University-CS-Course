<template>
  <div class="order-form">
    <div class="header">
      <div class="back-button" @click="handleBack">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M19 12H5M12 19l-7-7 7-7"/>
        </svg>
      </div>
      <h2>确认订单</h2>
      <div class="placeholder"></div>
    </div>

    <div class="content">
      <!-- 餐厅信息 -->
      <div class="restaurant-info">
        <img :src="restaurantInfo.imageUrl || '/static/images/default-restaurant.png'" alt="餐厅图片" class="restaurant-image">
        <div class="restaurant-details">
          <h3>{{ restaurantInfo.name || '餐厅名称' }}</h3>
          <p class="restaurant-address">{{ restaurantInfo.address || '餐厅地址' }}</p>
          <p class="restaurant-hours">营业时间: {{ restaurantInfo.opening_hours || '未设置' }}</p>
        </div>
      </div>

      <!-- 订单类型选择 -->
      <div class="form-section">
        <h4>订单类型</h4>
        <div class="order-type-options">
          <div 
            class="order-type-option" 
            :class="{ active: orderData.order_type === 'takeout' }"
            @click="orderData.order_type = 'takeout'"
          >
            <i class="iconfont icon-takeout"></i>
            <span>打包取餐</span>
          </div>
          <div 
            class="order-type-option" 
            :class="{ active: orderData.order_type === 'dinein' }"
            @click="orderData.order_type = 'dinein'"
          >
            <i class="iconfont icon-dinein"></i>
            <span>堂食</span>
          </div>
        </div>
      </div>

      <!-- 到店方式选择 (仅堂食时显示) -->
      <div v-if="orderData.order_type === 'dinein'" class="form-section">
        <h4>到店方式</h4>
        <div class="arrival-options">
          <div 
            class="arrival-option" 
            :class="{ active: !isReservation }"
            @click="setArrivalMode(false)"
          >
            <span class="option-icon">🚶</span>
            <span>立即到店</span>
          </div>
          <div 
            class="arrival-option" 
            :class="{ active: isReservation }"
            @click="setArrivalMode(true)"
          >
            <span class="option-icon">📅</span>
            <span>预约时间</span>
          </div>
        </div>
      </div>

      <!-- 预约时间选择 (仅预约模式显示) -->
      <div v-if="orderData.order_type === 'dinein' && isReservation" class="form-section">
        <h4>预约信息</h4>
        <div class="reservation-form">
          <div class="form-row">
            <div class="form-group half">
              <label>预约日期</label>
              <select v-model="reservationDate" class="form-control" @change="onReservationDateChange">
                <option v-for="day in availableDays" :key="day.date" :value="day.date">
                  {{ day.date }} {{ day.day_of_week }}
                </option>
              </select>
            </div>
            <div class="form-group half">
              <label>预约时间</label>
              <select v-model="reservationTime" class="form-control" @change="onReservationTimeChange">
                <option value="">请选择时间</option>
                <option v-for="slot in currentDaySlots" :key="slot.time" :value="slot.datetime">
                  {{ slot.time }}
                </option>
              </select>
            </div>
          </div>
          <div class="form-row">
            <div class="form-group half">
              <label>预计用餐时长</label>
              <select v-model="reservationDuration" class="form-control" @change="onReservationTimeChange">
                <option :value="60">1小时</option>
                <option :value="90">1.5小时</option>
                <option :value="120">2小时</option>
                <option :value="150">2.5小时</option>
                <option :value="180">3小时</option>
              </select>
            </div>
          </div>
          <p class="reservation-hint">
            <span class="hint-icon">💡</span>
            预约需提前30分钟，最多可预约7天内
          </p>
        </div>
      </div>

      <!-- 桌号选择 (仅堂食时显示) -->
      <div v-if="orderData.order_type === 'dinein'" class="form-section">
        <h4>选择桌位</h4>
        <div v-if="loadingTables" class="loading-message">加载桌位信息中...</div>
        <div v-else-if="tables.length === 0" class="empty-message">暂无可用桌位</div>
        <div v-else class="table-options">
          <div 
            v-for="table in availableTables" 
            :key="table.id"
            class="table-option"
            :class="{ 
              active: orderData.table_id === table.id,
              disabled: !isTableAvailable(table)
            }"
            @click="selectTable(table)"
          >
            <div class="table-header">
              <span class="table-number">{{ table.table_number }}号桌</span>
              <span class="table-type-badge" :class="table.table_type">
                {{ table.table_type === 'private' ? '独立' : '拼桌' }}
              </span>
            </div>
            <div class="table-info">
              <span class="table-capacity">可坐 {{ table.capacity }}人</span>
              <span class="table-available-seats" :class="{ 'low-seats': table.available_seats < 2 }">
                剩余 {{ table.available_seats }}人
              </span>
              <span v-if="table.description" class="table-desc">{{ table.description }}</span>
            </div>
            <div v-if="!isTableAvailable(table)" class="table-unavailable">
              {{ isReservation ? '该时段已满' : '已占用' }}
            </div>
          </div>
        </div>
      </div>

      <!-- 用餐人数 -->
      <div class="form-section">
        <h4>用餐人数</h4>
        <div class="form-group">
          <input 
            type="number" 
            v-model.number="orderData.customer_count" 
            class="form-control"
            min="1"
            max="20"
            @change="onCustomerCountChange"
          />
          <p class="helper-text">请输入用餐人数，限1-20人</p>
        </div>
      </div>

      <!-- 备注信息 -->
      <div class="form-section">
        <h4>备注信息</h4>
        <div class="form-group">
          <textarea 
            v-model="orderData.note" 
            class="form-control textarea"
            rows="3"
            placeholder="如有特殊要求，请在此备注..."
          ></textarea>
        </div>
      </div>

      <!-- 优惠券选择 -->
      <div class="form-section">
        <div class="coupon-header">
          <h4>优惠券</h4>
          <button v-if="!showCouponList" class="select-coupon-btn" @click="loadCoupons">
            {{ selectedCoupon ? '已选择优惠券' : '选择优惠券' }}
          </button>
        </div>
        
        <!-- 已选择的优惠券 -->
        <div v-if="selectedCoupon && !showCouponList" class="selected-coupon">
          <div class="coupon-item selected">
            <div class="coupon-left">
              <div class="coupon-amount">
                <span v-if="selectedCoupon.discount_type === 'amount'">¥{{ selectedCoupon.amount }}</span>
                <span v-else-if="selectedCoupon.discount_type === 'percentage'">{{ selectedCoupon.amount }}折</span>
                <span v-else>赠品</span>
              </div>
              <div class="coupon-desc">
                <p class="coupon-title">{{ selectedCoupon.title }}</p>
                <p class="coupon-condition" v-if="selectedCoupon.min_spend">
                  满¥{{ selectedCoupon.min_spend }}可用
                </p>
              </div>
            </div>
            <button class="remove-coupon-btn" @click="removeCoupon">×</button>
          </div>
          <p class="discount-hint">已优惠 ¥{{ discountAmount.toFixed(2) }}</p>
        </div>

        <!-- 优惠券列表 -->
        <div v-if="showCouponList" class="coupon-list">
          <div v-if="loadingCoupons" class="loading-message">加载优惠券中...</div>
          <div v-else-if="availableCoupons.length === 0" class="empty-message">
            暂无可用优惠券
          </div>
          <div v-else class="coupon-items">
            <div 
              v-for="coupon in availableCoupons" 
              :key="coupon.id"
              class="coupon-item"
              :class="{ 
                disabled: !canUseCoupon(coupon),
                active: tempSelectedCoupon && tempSelectedCoupon.id === coupon.id 
              }"
              @click="selectCoupon(coupon)"
            >
              <div class="coupon-left">
                <div class="coupon-amount">
                  <span v-if="coupon.discount_type === 'amount'">¥{{ coupon.amount }}</span>
                  <span v-else-if="coupon.discount_type === 'percentage'">{{ coupon.amount }}折</span>
                  <span v-else>赠品</span>
                </div>
                <div class="coupon-desc">
                  <p class="coupon-title">{{ coupon.title }}</p>
                  <p class="coupon-condition">
                    <span v-if="coupon.min_spend">满¥{{ coupon.min_spend }}可用</span>
                    <span v-else>无门槛</span>
                  </p>
                  <p class="coupon-validity" v-if="coupon.valid_to">
                    {{ formatDate(coupon.valid_to) }} 截止
                  </p>
                </div>
              </div>
              <div class="coupon-right">
                <span v-if="!canUseCoupon(coupon)" class="unavailable-text">不可用</span>
                <span v-else-if="tempSelectedCoupon && tempSelectedCoupon.id === coupon.id" class="selected-icon">✓</span>
              </div>
            </div>
          </div>
          <div class="coupon-actions">
            <button class="btn-cancel" @click="cancelCouponSelection">取消</button>
            <button class="btn-confirm" @click="confirmCouponSelection">确定</button>
          </div>
        </div>
      </div>

      <!-- 订单明细 -->
      <div class="form-section">
        <h4>订单明细</h4>
        <div class="order-items">
          <div v-for="(item, index) in cartItems" :key="`${item.dish_id}-${index}`" class="order-item">
            <div class="item-info">
              <div class="item-name-wrapper">
                <span class="item-name">{{ item.name }}</span>
                <span v-if="item.optionsDescription" class="item-options">{{ item.optionsDescription }}</span>
              </div>
              <span class="item-price">¥{{ item.price }}</span>
            </div>
            <div class="item-quantity">x{{ item.quantity }}</div>
          </div>
        </div>
      </div>

      <!-- 订单总价 -->
      <div class="order-summary">
        <div class="summary-item">
          <span>商品总额</span>
          <span>¥{{ originalPrice.toFixed(2) }}</span>
        </div>
        <div v-if="discountAmount > 0" class="summary-item discount">
          <span>优惠券抵扣</span>
          <span>-¥{{ discountAmount.toFixed(2) }}</span>
        </div>
        <div class="summary-item total">
          <span>应付金额</span>
          <span>¥{{ totalPrice.toFixed(2) }}</span>
        </div>
      </div>
    </div>

    <!-- 底部提交按钮 -->
    <div class="footer">
      <div class="total-price">
        <span>合计:</span>
        <span class="price">¥{{ totalPrice.toFixed(2) }}</span>
      </div>
      <button class="submit-button" @click="handleSubmit" :disabled="isSubmitting || !canSubmit">
        {{ isSubmitting ? '提交中...' : '确认下单' }}
      </button>
    </div>
  </div>
</template>

<script>
import { getAvailableSlots, getAvailableTables, getRestaurantTables, getCouponNotifications } from '@/api/shops'
import { createOrder } from '@/api/orders'

export default {
  name: 'OrderForm',
  data() {
    return {
      orderData: {
        restaurant_id: null,
        items: [],
        order_type: 'dinein', // 默认堂食
        customer_count: 1,
        table_id: null,
        note: '',
        coupon_id: null
      },
      restaurantInfo: {},
      cartItems: [],
      tables: [],
      loadingTables: false,
      isSubmitting: false,
      // 优惠券相关
      availableCoupons: [],
      selectedCoupon: null,
      tempSelectedCoupon: null,
      showCouponList: false,
      loadingCoupons: false,
      // 预约相关
      isReservation: false,
      reservationDate: '',
      reservationTime: '',
      reservationDuration: 120,
      availableDays: [],
      loadingSlots: false
    }
  },
  computed: {
    originalPrice() {
      return this.cartItems.reduce((total, item) => {
        return total + (parseFloat(item.price) * item.quantity)
      }, 0)
    },
    discountAmount() {
      if (!this.selectedCoupon) return 0
      
      const coupon = this.selectedCoupon
      let discount = 0
      
      if (coupon.discount_type === 'amount') {
        // 满减优惠
        discount = parseFloat(coupon.amount) || 0
      } else if (coupon.discount_type === 'percentage') {
        // 折扣优惠
        const percentage = parseFloat(coupon.amount) || 0
        discount = this.originalPrice * (percentage / 100)
      }
      
      // 确保折扣不超过原价
      return Math.min(discount, this.originalPrice)
    },
    totalPrice() {
      return Math.max(0, this.originalPrice - this.discountAmount)
    },
    // 获取当前选择日期的时间段
    currentDaySlots() {
      const day = this.availableDays.find(d => d.date === this.reservationDate)
      return day ? day.slots : []
    },
    // 过滤可用的桌位
    availableTables() {
      return this.tables.filter(table => {
        // 显示所有桌位，包括已占用的（但会标记为不可选）
        return true
      })
    },
    canSubmit() {
      // 堂食必须选择桌位
      if (this.orderData.order_type === 'dinein' && !this.orderData.table_id) {
        return false
      }
      // 预约模式必须选择预约时间
      if (this.orderData.order_type === 'dinein' && this.isReservation && !this.reservationTime) {
        return false
      }
      return this.cartItems.length > 0 && this.orderData.customer_count > 0
    }
  },
  created() {
    this.initializeForm()
  },
  mounted() {
    // 加载桌位信息
    if (this.orderData.restaurant_id) {
      this.loadTables()
    }
  },
  watch: {
    'orderData.order_type'(newType) {
      // 切换到堂食时加载桌位，切换到打包时清空桌位选择
      if (newType === 'dinein') {
        this.loadTables()
      } else {
        this.orderData.table_id = null
      }
    }
  },
  methods: {
    initializeForm() {
      // 从sessionStorage获取按餐厅隔离的购物车数据
      const restaurantData = sessionStorage.getItem('currentRestaurant')
      if (!restaurantData) {
        // 如果没有当前餐厅信息，返回上一页
        this.$router.go(-1)
        return
      }

      let restaurant = null
      try {
        restaurant = JSON.parse(restaurantData)
      } catch (e) {
        console.error('解析当前餐厅信息失败：', e)
        this.$router.go(-1)
        return
      }
      const rid = restaurant && (restaurant.id || restaurant.restaurant_id)
      if (!rid) {
        this.$router.go(-1)
        return
      }

      const cartKey = `cart_${rid}`
      const cartData = sessionStorage.getItem(cartKey)

      if (cartData) {
        try {
          const cart = JSON.parse(cartData)
          this.cartItems = cart
        } catch (e) {
          console.error('解析购物车数据失败，已清空：', e)
          this.cartItems = []
        }

        this.restaurantInfo = restaurant
        this.orderData.restaurant_id = rid

        // 格式化订单项数据
        this.orderData.items = this.cartItems.map(item => ({
          dish_id: item.dish_id,
          quantity: item.quantity,
          spiciness: item.spiciness,
          garnish: item.garnish
        }))
      } else {
        // 如果没有购物车数据，返回上一页
        this.$router.go(-1)
      }
    },
    handleBack() {
      this.$router.go(-1)
    },
    // 设置到店方式
    setArrivalMode(isReservation) {
      this.isReservation = isReservation
      if (isReservation) {
        // 加载可预约时段
        this.loadAvailableSlots()
      } else {
        // 立即到店模式，清除预约信息
        this.reservationDate = ''
        this.reservationTime = ''
        // 重新加载当前可用桌位
        this.loadTables()
      }
    },
    // 加载可预约时段
    async loadAvailableSlots() {
      if (!this.orderData.restaurant_id) return

      this.loadingSlots = true
      try {
        const params = {
            days: 7,
            timezone: Intl.DateTimeFormat().resolvedOptions().timeZone
        }
        const res = await getAvailableSlots(this.orderData.restaurant_id, params)
        const data = res.data

        if (data.success && data.data) {
          // 过滤有可用时段的日期
          this.availableDays = data.data.available_days.filter(day => day.slots.length > 0)

          // 默认选择第一个有时段的日期
          if (this.availableDays.length > 0) {
            this.reservationDate = this.availableDays[0].date
          } else {
            console.warn('没有可用的预约时段')
            alert('当前时间内暂无可预约时段，请稍后再试')
          }
        } else {
          console.error('获取可预约时段失败:', data.message)
          alert(data.message || '获取可预约时段失败')
        }
      } catch (error) {
        console.error('加载可预约时段失败:', error)
        alert(error.response?.data?.message || '加载可预约时段失败，请检查网络')
      } finally {
        this.loadingSlots = false
      }
    },
    // 预约日期变化
    onReservationDateChange() {
      this.reservationTime = ''
      this.orderData.table_id = null
    },
    // 预约时间变化，重新加载该时段可用桌位
    async onReservationTimeChange() {
      if (!this.reservationTime) {
        this.orderData.table_id = null
        return
      }
      await this.loadTablesForReservation()
    },
    // 用餐人数变化
    async onCustomerCountChange() {
      if (this.isReservation && this.reservationTime) {
        await this.loadTablesForReservation()
      }
    },
    // 加载指定预约时段的可用桌位
    async loadTablesForReservation() {
      if (!this.orderData.restaurant_id || !this.reservationTime) return

      this.loadingTables = true
      this.orderData.table_id = null

      try {
        const params = {
          reserved_time: this.reservationTime,
          customer_count: this.orderData.customer_count,
          duration: this.reservationDuration,
          timezone: Intl.DateTimeFormat().resolvedOptions().timeZone
        }

        const res = await getAvailableTables(this.orderData.restaurant_id, params)
        const data = res.data
        if (data.success && data.data && data.data.tables) {
          this.tables = data.data.tables
        }
      } catch (error) {
        console.error('加载预约时段桌位失败:', error)
      } finally {
        this.loadingTables = false
      }
    },
    // 加载餐厅桌位信息
    async loadTables() {
      if (!this.orderData.restaurant_id) return

      this.loadingTables = true
      try {
        const res = await getRestaurantTables(this.orderData.restaurant_id)
        const data = res.data
        if (data.success && data.tables) {
          this.tables = data.tables
        } else {
          console.error('获取桌位失败:', data.message)
        }
      } catch (error) {
        console.error('加载桌位信息失败:', error)
      } finally {
        this.loadingTables = false
      }
    },
    // 检查桌位是否可用
    isTableAvailable(table) {
      if (this.isReservation) {
        // 预约模式：检查 can_accommodate 和 available_seats
        return table.can_accommodate && table.available_seats >= this.orderData.customer_count
      }
      // 立即到店模式：检查剩余可用人数是否足够
      return table.available_seats > 0 && table.available_seats >= this.orderData.customer_count
    },
    // 选择桌位
    selectTable(table) {
      if (!this.isTableAvailable(table)) {
        alert('该桌位已无剩余座位，请选择其他桌位')
        return
      }
      
      // 检查剩余座位是否足够
      if (this.orderData.customer_count > table.available_seats) {
        alert(`该桌位剩余${table.available_seats}个座位，无法容纳${this.orderData.customer_count}人，请选择其他桌位或减少用餐人数`)
        return
      }
      
      this.orderData.table_id = table.id
    },
    // 加载可用优惠券
    async loadCoupons() {
      if (!this.orderData.restaurant_id) return

      this.loadingCoupons = true
      this.showCouponList = true

      try {
        const res = await getCouponNotifications({
          restaurant_id: this.orderData.restaurant_id,
          include_inactive: false
        })
        const result = res.data
        if (result.success && result.data && result.data.records) {
          this.availableCoupons = result.data.records
        } else {
          console.error('获取优惠券失败:', result.message)
        }
      } catch (error) {
        console.error('加载优惠券失败:', error)
      } finally {
        this.loadingCoupons = false
      }
    },
    // 检查优惠券是否可用
    canUseCoupon(coupon) {
      // 检查最低消费
      if (coupon.min_spend && this.originalPrice < coupon.min_spend) {
        return false
      }
      
      // 检查有效期
      const now = new Date()
      if (coupon.valid_from && new Date(coupon.valid_from) > now) {
        return false
      }
      if (coupon.valid_to && new Date(coupon.valid_to) < now) {
        return false
      }
      
      return true
    },
    // 选择优惠券
    selectCoupon(coupon) {
      if (!this.canUseCoupon(coupon)) {
        alert('此优惠券不可用')
        return
      }
      this.tempSelectedCoupon = coupon
    },
    // 确认优惠券选择
    confirmCouponSelection() {
      this.selectedCoupon = this.tempSelectedCoupon
      this.orderData.coupon_id = this.selectedCoupon ? this.selectedCoupon.id : null
      this.showCouponList = false
    },
    // 取消优惠券选择
    cancelCouponSelection() {
      this.tempSelectedCoupon = this.selectedCoupon
      this.showCouponList = false
    },
    // 移除优惠券
    removeCoupon() {
      this.selectedCoupon = null
      this.tempSelectedCoupon = null
      this.orderData.coupon_id = null
    },
    // 格式化日期
    formatDate(dateString) {
      if (!dateString) return ''
      const date = new Date(dateString)
      return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
    },
    async handleSubmit() {
      if (!this.canSubmit || this.isSubmitting) return

      this.isSubmitting = true

      try {
        // 构建订单数据
        const submitData = { ...this.orderData }

        // 如果是预约模式，添加预约信息
        if (this.isReservation && this.reservationTime) {
          submitData.reserved_time = this.reservationTime
          submitData.duration = this.reservationDuration
        }

        submitData.timezone = Intl.DateTimeFormat().resolvedOptions().timeZone

        const res = await createOrder(submitData)
        const result = res.data

        if (result.success) {
          // 清空按餐厅隔离的购物车
          try {
            const rid = this.orderData.restaurant_id || (this.restaurantInfo && (this.restaurantInfo.id || this.restaurantInfo.restaurant_id))
            if (rid) {
              sessionStorage.removeItem(`cart_${rid}`)
            }
            // 可选：清除当前活跃餐厅指针
            sessionStorage.removeItem('currentRestaurant')
          } catch (e) {
            console.error('清空购物车缓存失败：', e)
          }

          // 根据是否为预约订单显示不同提示
          if (this.isReservation) {
            alert('预约订单提交成功，等待商家确认')
          } else {
            alert('下单成功，等待商家接单')
          }

          // 跳转到订单详情页,使用订单ID
          this.$router.push({ name: 'OrderDetails', params: { id: result.data.order_id } })
        } else {
          alert(result.message || '订单创建失败')
        }
      } catch (error) {
        console.error('提交订单失败:', error)
        if (error.response?.status === 401) {
          alert('请先登录')
          this.$router.push('/login')
        } else {
          alert(error.response?.data?.message || '网络错误，请重试')
        }
      } finally {
        this.isSubmitting = false
      }
    }
  }
}
</script>

<style scoped>
.order-form {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background-color: #f5f5f5;
}

.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 15px;
  background-color: #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 10;
}

.header h2 {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
}

.back-button, .placeholder {
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.back-button {
  cursor: pointer;
}

.iconfont {
  font-size: 20px;
  color: #333;
}

.content {
  flex: 1;
  overflow-y: auto;
  padding: 0 15px 100px;
}

.restaurant-info {
  display: flex;
  padding: 15px;
  margin: 15px 0;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.restaurant-image {
  width: 80px;
  height: 80px;
  border-radius: 8px;
  object-fit: cover;
}

.restaurant-details {
  flex: 1;
  margin-left: 15px;
}

.restaurant-details h3 {
  margin: 0 0 5px;
  font-size: 16px;
  font-weight: 600;
}

.restaurant-address, .restaurant-hours {
  margin: 5px 0;
  font-size: 12px;
  color: #666;
}

.form-section {
  background-color: #fff;
  margin: 15px 0;
  padding: 15px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.form-section h4 {
  margin: 0 0 15px;
  font-size: 14px;
  font-weight: 600;
  color: #333;
}

.order-type-options {
  display: flex;
  gap: 15px;
}

.order-type-option {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 15px;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s;
}

.order-type-option.active {
  border-color: #ff4d4f;
  color: #ff4d4f;
  background-color: #fff2f0;
}

.order-type-option i {
  font-size: 24px;
  margin-bottom: 8px;
}

.form-group {
  margin-bottom: 10px;
}

.form-control {
  width: 100%;
  padding: 10px;
  border: 1px solid #e0e0e0;
  border-radius: 6px;
  font-size: 14px;
  transition: border-color 0.3s;
}

.form-control:focus {
  outline: none;
  border-color: #ff4d4f;
}

.textarea {
  resize: none;
}

.helper-text {
  margin: 5px 0 0;
  font-size: 12px;
  color: #999;
}

.order-items {
  margin-top: 10px;
}

.order-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #f0f0f0;
}

.order-item:last-child {
  border-bottom: none;
}

.item-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.item-name-wrapper {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.item-name {
  font-size: 14px;
  color: #333;
  font-weight: 500;
}

.item-options {
  font-size: 12px;
  color: #999;
  line-height: 1.2;
}

.item-specs {
  font-size: 12px;
  color: #999;
  margin-top: 4px;
}

.item-specs span {
  margin-right: 8px;
}

.item-price {
  font-size: 14px;
  color: #ff4d4f;
  font-weight: 500;
}

.item-quantity {
  font-size: 14px;
  color: #666;
  margin-left: 10px;
}

.order-summary {
  background-color: #fff;
  margin: 15px 0;
  padding: 15px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.summary-item {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
  font-size: 14px;
}

.summary-item.discount {
  color: #ff4d4f;
}

.summary-item.discount span:last-child {
  font-weight: 500;
}

.summary-item.total {
  font-weight: 600;
  font-size: 16px;
  margin-top: 15px;
  padding-top: 15px;
  border-top: 1px solid #f0f0f0;
}

.summary-item.total span:last-child {
  color: #ff4d4f;
}

.footer {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 15px;
  background-color: #fff;
  box-shadow: 0 -2px 8px rgba(0, 0, 0, 0.1);
}

.total-price {
  display: flex;
  align-items: baseline;
}

.total-price span:first-child {
  font-size: 14px;
  color: #666;
  margin-right: 5px;
}

.price {
  font-size: 20px;
  font-weight: 600;
  color: #ff4d4f;
}

.submit-button {
  padding: 10px 30px;
  background-color: #ff4d4f;
  color: #fff;
  border: none;
  border-radius: 6px;
  font-size: 16px;
  font-weight: 500;
  cursor: pointer;
  transition: background-color 0.3s;
}

.submit-button:hover:not(:disabled) {
  background-color: #ff7875;
}

.submit-button:disabled {
  background-color: #d9d9d9;
  cursor: not-allowed;
}

/* 桌位选择样式 */
.loading-message, .empty-message {
  padding: 20px;
  text-align: center;
  color: #999;
  font-size: 14px;
}

.table-options {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 10px;
}

.table-option {
  position: relative;
  padding: 12px;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s;
  background-color: #fff;
}

.table-option:hover:not(.disabled) {
  border-color: #ff4d4f;
  box-shadow: 0 2px 8px rgba(255, 77, 79, 0.2);
}

.table-option.active {
  border-color: #ff4d4f;
  background-color: #fff2f0;
}

.table-option.disabled {
  opacity: 0.5;
  cursor: not-allowed;
  background-color: #f5f5f5;
}

.table-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.table-number {
  font-size: 16px;
  font-weight: 600;
  color: #333;
}

.table-type-badge {
  padding: 2px 8px;
  font-size: 11px;
  border-radius: 10px;
  background-color: #f0f0f0;
  color: #666;
}

.table-type-badge.private {
  background-color: #e6f7ff;
  color: #1890ff;
}

.table-type-badge.shared {
  background-color: #f6ffed;
  color: #52c41a;
}

.table-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.table-capacity {
  font-size: 13px;
  color: #666;
}

.table-available-seats {
  font-size: 13px;
  color: #52c41a;
  font-weight: 500;
  margin-left: 8px;
}

.table-available-seats.low-seats {
  color: #ff4d4f;
}

.table-desc {
  font-size: 12px;
  color: #999;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.table-unavailable {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  background-color: rgba(0, 0, 0, 0.7);
  color: #fff;
  padding: 4px 12px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 500;
}

@media (max-width: 480px) {
  .table-options {
    grid-template-columns: 1fr;
  }
}

/* 优惠券样式 */
.coupon-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.select-coupon-btn {
  padding: 6px 12px;
  background-color: #fff;
  border: 1px solid #ff4d4f;
  color: #ff4d4f;
  border-radius: 4px;
  font-size: 13px;
  cursor: pointer;
  transition: all 0.3s;
}

.select-coupon-btn:hover {
  background-color: #fff2f0;
}

.selected-coupon {
  margin-top: 10px;
}

.discount-hint {
  margin-top: 8px;
  font-size: 13px;
  color: #ff4d4f;
  font-weight: 500;
}

.coupon-list {
  margin-top: 10px;
}

.coupon-items {
  max-height: 300px;
  overflow-y: auto;
  margin-bottom: 10px;
}

.coupon-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px;
  margin-bottom: 10px;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s;
  background-color: #fff;
}

.coupon-item:hover:not(.disabled) {
  border-color: #ff4d4f;
  box-shadow: 0 2px 8px rgba(255, 77, 79, 0.2);
}

.coupon-item.active {
  border-color: #ff4d4f;
  background-color: #fff2f0;
}

.coupon-item.selected {
  border-color: #ff4d4f;
  background-color: #fff2f0;
}

.coupon-item.disabled {
  opacity: 0.5;
  cursor: not-allowed;
  background-color: #f5f5f5;
}

.coupon-left {
  display: flex;
  align-items: center;
  gap: 12px;
  flex: 1;
}

.coupon-amount {
  min-width: 60px;
  text-align: center;
}

.coupon-amount span {
  font-size: 20px;
  font-weight: 600;
  color: #ff4d4f;
}

.coupon-desc {
  flex: 1;
}

.coupon-title {
  margin: 0 0 4px;
  font-size: 14px;
  font-weight: 500;
  color: #333;
}

.coupon-condition {
  margin: 0 0 2px;
  font-size: 12px;
  color: #666;
}

.coupon-validity {
  margin: 0;
  font-size: 11px;
  color: #999;
}

.coupon-right {
  display: flex;
  align-items: center;
}

.unavailable-text {
  font-size: 12px;
  color: #999;
}

.selected-icon {
  font-size: 20px;
  color: #ff4d4f;
  font-weight: bold;
}

.remove-coupon-btn {
  width: 24px;
  height: 24px;
  border: none;
  background-color: #ff4d4f;
  color: #fff;
  border-radius: 50%;
  font-size: 18px;
  line-height: 1;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s;
}

.remove-coupon-btn:hover {
  background-color: #ff7875;
}

.coupon-actions {
  display: flex;
  gap: 10px;
  margin-top: 10px;
}

.btn-cancel, .btn-confirm {
  flex: 1;
  padding: 10px;
  border: none;
  border-radius: 6px;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s;
}

.btn-cancel {
  background-color: #f0f0f0;
  color: #666;
}

.btn-cancel:hover {
  background-color: #e0e0e0;
}

.btn-confirm {
  background-color: #ff4d4f;
  color: #fff;
}

.btn-confirm:hover {
  background-color: #ff7875;
}

/* 到店方式选择 */
.arrival-options {
  display: flex;
  gap: 12px;
}

.arrival-option {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 16px;
  border: 2px solid #e0e0e0;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s;
  background: #fff;
}

.arrival-option:hover {
  border-color: #ff4d4f;
}

.arrival-option.active {
  border-color: #ff4d4f;
  background: linear-gradient(135deg, #fff5f5 0%, #fff 100%);
}

.arrival-option .option-icon {
  font-size: 24px;
  margin-bottom: 8px;
}

.arrival-option span:last-child {
  font-size: 14px;
  color: #333;
  font-weight: 500;
}

.arrival-option.active span:last-child {
  color: #ff4d4f;
}

/* 预约表单 */
.reservation-form {
  background: #fafafa;
  border-radius: 12px;
  padding: 16px;
}

.form-row {
  display: flex;
  gap: 12px;
  margin-bottom: 12px;
}

.form-row:last-child {
  margin-bottom: 0;
}

.form-group.half {
  flex: 1;
}

.form-group.half label {
  display: block;
  font-size: 13px;
  color: #666;
  margin-bottom: 6px;
}

.reservation-hint {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  color: #999;
  margin-top: 8px;
  padding: 8px 12px;
  background: #fff;
  border-radius: 8px;
}

.hint-icon {
  font-size: 14px;
}
</style>