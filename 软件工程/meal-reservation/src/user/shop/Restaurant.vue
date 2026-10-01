<template>
  <div class="restaurant-container">
    <!-- 顶部栏 -->
    <header class="header">
      <div class="back-btn" @click="goBack">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M19 12H5M12 19l-7-7 7-7"/>
        </svg>
      </div>

      <div class="header-icons">
        <button
          class="favorite-icon"
          :class="{ active: isFollowing }"
          type="button"
          :aria-label="isFollowing ? '取消关注商铺' : '关注商铺'"
          :title="isFollowing ? '取消关注' : '关注商铺'"
          @click="toggleFollow"
          :disabled="followLoading"
        >
          <svg width="24" height="24" viewBox="0 0 24 24" :fill="isFollowing ? '#ff4d4f' : 'none'" :stroke="isFollowing ? '#ff4d4f' : 'currentColor'" stroke-width="2">
            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
          </svg>
        </button>
      </div>
    </header>

    <!-- 商家信息部分 -->
    <div class="restaurant-info">
      <div class="restaurant-top">
        <img 
          :src="restaurant.image" 
          :alt="restaurant.name" 
          class="restaurant-image"
          @error="handleShopImageError"
        >
        <div class="restaurant-details">
          <h2 class="restaurant-name">{{ restaurant.name }}</h2>
          <div class="restaurant-stats">
            <div class="stat-item">
              <div class="stat-label">评分</div>
              <div class="stat-value">{{ restaurant.rating ? restaurant.rating : '暂无评分' }}</div>
            </div>
            <!-- 新增排队信息 -->
            <div class="stat-item" v-if="restaurant.idle_seats_count !== undefined">
              <div class="stat-label">空闲座位</div>
              <div class="stat-value green">{{ restaurant.idle_seats_count }}</div>
            </div>
            <div class="stat-item" v-if="restaurant.estimated_wait_time !== undefined">
              <div class="stat-label">预计等待</div>
              <div class="stat-value red">{{ restaurant.estimated_wait_time }}分</div>
            </div>
          </div>
        </div>
      </div>
      <div class="merchant-notice">
        <span class="notice-content">{{ restaurant.notice }} &nbsp;&nbsp;&nbsp; {{ restaurant.notice }}</span>
      </div>
    </div>


    <!-- 菜单主区域 -->
    <div class="menu-section">
      <!-- 顶部导航栏 -->
      <div class="menu-tabs">
        <div 
          class="menu-tab" 
          :class="{ 'active': activeTab === 'menu' }"
          @click="activeTab = 'menu'"
        >
          点菜
        </div>
        <div 
          class="menu-tab" 
          :class="{ 'active': activeTab === 'reviews' }"
          @click="activeTab = 'reviews'"
        >
          评价
        </div>
      </div>

      <!-- 内容区域 -->
      <div class="menu-content">
        <Menu
          v-if="activeTab === 'menu'"
          :categories="categories"
          :dishes="dishes"
          v-model:activeCategory="activeCategory"
          :selected-dishes="cartItems"
          @select-dish="selectDish"
          @decrease-quantity="decreaseQuantityFromMenu"
        />

        <div v-else class="reviews-content">
          <Reviews :restaurant-id="props.id" />
        </div>
      </div>
    </div>
    
    <!-- 购物车悬浮按钮 -->
    <div v-if="cartTotal > 0" class="cart-button" @click="toggleCart">
      <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <circle cx="9" cy="21" r="1"/>
        <circle cx="20" cy="21" r="1"/>
        <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
      </svg>
      <span class="cart-count">{{ cartTotal }}</span>
    </div>
    
    <!-- 购物车面板 -->
    <transition name="cart-slide">
      <div v-if="showCart" class="cart-panel">
        <div class="cart-header">
          <h3>已选菜品({{ cartTotal }})</h3>
          <span class="close-cart" @click="toggleCart">×</span>
        </div>
        <div class="cart-items">
          <div v-for="(item, index) in cartItems" :key="`${item.id}-${index}`" class="cart-item">
            <div class="item-info">
              <div class="item-name-wrapper">
                <span class="item-name">{{ item.name }}</span>
                <span v-if="item.optionsDescription" class="item-options">{{ item.optionsDescription }}</span>
              </div>
              <span class="item-price">¥{{ item.price }}</span>
            </div>
            <div class="item-quantity">
              <button class="quantity-btn minus" @click.stop="decreaseQuantity(index)">-</button>
              <span>{{ item.quantity }}</span>
              <button class="quantity-btn plus" @click.stop="selectDish(item)">+</button>
            </div>
          </div>
        </div>
        <div class="cart-footer">
          <div class="total-price">
            <span>合计:</span>
            <span>¥{{ cartTotalPrice.toFixed(2) }}</span>
          </div>
          <button class="submit-btn" @click="goToOrderForm">去结算</button>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, watch, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import Menu from './Menu.vue'
import Reviews from './Reviews.vue'
import { getMenu, getRestaurant, getFollowStatus, followRestaurant, unfollowRestaurant } from '@/api/shops'

// 添加图片加载失败处理函数
const handleShopImageError = (e) => {
  e.target.src = `${typeof API_url !== 'undefined' ? API_url : ''}/static/default/restaurant.png`
}

// 购物车相关状态（按餐厅隔离存储）
const cartItems = ref([])
const showCart = ref(false)

const cartStorageKey = (restaurantId) => `cart_${restaurantId}`

const loadCartForRestaurant = (restaurantId) => {
  if (!restaurantId) {
    cartItems.value = []
    return
  }
  const saved = sessionStorage.getItem(cartStorageKey(restaurantId))
  if (saved) {
    try {
      cartItems.value = JSON.parse(saved)
    } catch (e) {
      console.error('解析购物车数据失败，已清空：', e)
      cartItems.value = []
    }
  } else {
    cartItems.value = []
  }
}

// 计算属性
const cartTotal = computed(() => {
  return cartItems.value.reduce((total, item) => total + item.quantity, 0)
})

const cartTotalPrice = computed(() => {
  return cartItems.value.reduce((total, item) => total + (parseFloat(item.price) * item.quantity), 0)
})

const isFollowing = ref(false)
const followLoading = ref(false)

// 从sessionStorage恢复购物车
onMounted(() => {
  // 初始加载时，尝试从当前 props.id 对应的餐厅读取购物车
  loadCartForRestaurant(props.id)
})

// // 硬编码的餐厅数据（后期将替换为API调用）
// const restaurant = ref({
//   name: '沙县小吃',
//   image: '沙县小吃图标.png',
//   rating: 4.7,
//   monthlySales: '2000',
//   notice: '一生平安！ 面食易坨不接受退差评或者退款，骑手是商家不可控的所以也不接受因为骑手迟到而差评'
// })

// 定义 props 来接收路由参数
const props = defineProps({
  id: {
    type: [String, Number],
    required: true
  }
})

const router = useRouter()

// 餐厅数据
const restaurant = ref({
  name: '加载中...',
  image: '',
  rating: 4.5,
  notice: '欢迎光临本店'
})

// 直接通过API获取餐厅信息和菜品数据
const loadRestaurantAndMenu = async () => {
  if (!props.id) return

  try {
    // 直接获取指定餐厅信息
    const res = await getRestaurant(props.id)
    const restaurantResult = res.data
    if (restaurantResult.success && restaurantResult.data) {
      restaurant.value = {
        id: restaurantResult.data.id,
        name: restaurantResult.data.name,
        image: restaurantResult.data.avatar_url ? (restaurantResult.data.avatar_url) : `${API_url}/static/default/restaurant.png`,
        rating: restaurantResult.data.rating ? restaurantResult.data.rating : null,

        notice: restaurantResult.data.notice || '欢迎光临本店',
        address: restaurantResult.data.address || '',
        opening_hours: restaurantResult.data.opening_hours || '',
        idle_seats_count: restaurantResult.data.idle_seats_count,
        estimated_wait_time: restaurantResult.data.estimated_wait_time
      }
    }

    // 加载菜单数据
    await loadRestaurantMenu(props.id)
  } catch (error) {
    console.error('获取餐厅信息失败:', error)
    // 出错时使用默认数据
    restaurant.value = {
      id: props.id,
      name: '湘味人家',
      image: `${typeof API_url !== 'undefined' ? API_url : ''}/static/default/restaurant.png`,
      rating: 4.7,
      notice: '鲁菜经典，力求大厨原味不掺假。精选食材配方口味地道，装修考究干净，服务热情周到。',
      opening_hours: '09:00-21:00',
      address: ''
    }

    // 加载菜单数据
    await loadRestaurantMenu(props.id)
  }

  if (restaurant.value?.id) {
    await fetchFollowStatus(restaurant.value.id)
  } else {
    isFollowing.value = false
  }
  // 加载与该餐厅对应的购物车
  if (restaurant.value?.id) {
    loadCartForRestaurant(restaurant.value.id)
  }
}

// 组件挂载时直接加载餐厅信息和菜品数据
onMounted(async () => {
  await loadRestaurantAndMenu()
})

// 监听 id 变化并重新加载数据
watch(
  () => props.id,
  (newId) => {
    if (newId) {
      loadRestaurantAndMenu()
    }
  }
)

// 加载状态
const loading = ref(false)
const error = ref(null)

// 菜品数据和分类
const categories = ref([])
const dishes = ref([])
const rawDishesData = ref([])

// 从后端获取菜单数据
const loadRestaurantMenu = async (restaurantId) => {
  if (!restaurantId) return

  loading.value = true
  error.value = null

  try {
    const res = await getMenu(restaurantId)
    const response = res.data

    if (response.success && response.data) {
      // 处理分类数据
      const categoriesFromApi = response.data.categories.map((category, index) => ({
        id: index + 1,
        name: category
      }))
      categories.value = categoriesFromApi

      // 处理菜品数据
      rawDishesData.value = response.data.menu || {}
      dishes.value = []

      // 将分类结构的菜品转换为平铺结构
      Object.entries(rawDishesData.value).forEach(([categoryName, categoryDishes]) => {
        categoryDishes.forEach((dish, index) => {
          dishes.value.push({
            id: dish.dish_id,
            categoryId: categoriesFromApi.find(cat => cat.name === categoryName)?.id || categoriesFromApi.length + 1,
            name: dish.name,
            price: dish.price,
            image: dish.image_url ? (API_url + dish.image_url) : `${API_url}/static/default/dish.png`,
            monthlySales: dish.monthly_sales || Math.floor(Math.random() * 1000) + 100,
            description: dish.description,
            status: dish.status,
            is_spicy_selectable: dish.is_spicy_selectable || false,
            is_garnish_selectable: dish.is_garnish_selectable || false,
            multi_spec_enabled: dish.multi_spec_enabled || false,
            specifications: dish.specifications || []
          })
        })
      })
    }
  } catch (err) {
    console.error('获取菜单数据失败:', err)
    error.value = '加载菜单失败，请稍后重试'

    // 加载失败时使用默认数据
    categories.value = [
      { id: 1, name: '特价' },
      { id: 2, name: '折扣商品' },
      { id: 3, name: '热销菜品' },
      { id: 4, name: '主食' },
      { id: 5, name: '饮品' }
    ]

    dishes.value = [
      {
        id: 1,
        categoryId: 1,
        name: '麻婆豆腐',
        price: 28,
        monthlySales: '500',
        image: 'https://picsum.photos/seed/1/90/90'
      },
      {
        id: 2,
        categoryId: 2,
        name: '宫保鸡丁',
        price: 35,
        monthlySales: '300',
        image: 'https://picsum.photos/seed/2/90/90'
      },
      {
        id: 3,
        categoryId: 1,
        name: '回锅肉',
        price: 32,
        monthlySales: '400',
        image: 'https://picsum.photos/seed/3/90/90'
      },
      {
        id: 4,
        categoryId: 3,
        name: '水煮鱼',
        price: 58,
        monthlySales: '600',
        image: 'https://picsum.photos/seed/4/90/90'
      },
      {
        id: 5,
        categoryId: 4,
        name: '蛋炒饭',
        price: 18,
        monthlySales: '200',
        image: 'https://picsum.photos/seed/5/90/90'
      },
      {
        id: 6,
        categoryId: 5,
        name: '酸梅汤',
        price: 8,
        monthlySales: '150',
        image: 'https://picsum.photos/seed/6/90/90'
      }
    ]
  } finally {
    loading.value = false
  }
}

const fetchFollowStatus = async (restaurantId) => {
  if (!restaurantId) {
    isFollowing.value = false
    return
  }

  try {
    const res = await getFollowStatus(restaurantId)
    const body = res.data
    if (body?.success) {
      isFollowing.value = Boolean(body?.data?.is_following)
    }
  } catch (err) {
    if (err.response?.status === 401) {
      isFollowing.value = false
      return
    }
    console.error('获取关注状态失败:', err)
  }
}

const toggleFollow = async () => {
  if (!restaurant.value?.id || followLoading.value) {
    return
  }

  followLoading.value = true
  try {
    const res = isFollowing.value
      ? await unfollowRestaurant(restaurant.value.id)
      : await followRestaurant(restaurant.value.id)
    const body = res.data

    if (typeof body?.data?.is_following === 'boolean') {
      isFollowing.value = body.data.is_following
    } else {
      isFollowing.value = !isFollowing.value
    }
  } catch (err) {
    if (err.response?.status === 401) {
      alert('请先登录后再关注商铺')
      router.push('/login')
      return
    }
    console.error('更新关注状态失败:', err)
    alert(err.response?.data?.message || err.message || '操作失败，请稍后重试')
  } finally {
    followLoading.value = false
  }
}
// 选中的分类（类比Python中的变量，使用ref实现响应式）
const activeCategory = ref(1)

// 当前激活的标签页（点菜/评价）
const activeTab = ref('menu')

// 生成菜品选项描述
const getDishOptionsDescription = (dish) => {
  const parts = []
  
  // 处理旧的辣度和葱花香菜选项
  if (dish.is_spicy_selectable && dish.spiciness) {
    parts.push(dish.spiciness)
  }
  
  if (dish.is_garnish_selectable && dish.garnish) {
    parts.push(dish.garnish)
  }
  
  // 处理新的规格选项
  if (dish.selectedSpecs && Array.isArray(dish.selectedSpecs)) {
    dish.selectedSpecs.forEach(spec => {
      if (spec.selectedOption) {
        parts.push(`${spec.name}: ${spec.selectedOption.name}`)
      }
    })
  }
  
  return parts.length > 0 ? `(${parts.join('，')})` : ''
}

// 选择菜品函数
const selectDish = (dish) => {
  // 计算包含规格选项的最终价格
  let finalPrice = parseFloat(dish.price) || 0
  
  // 加上规格选项的额外价格
  if (dish.selectedSpecs && Array.isArray(dish.selectedSpecs)) {
    dish.selectedSpecs.forEach(spec => {
      if (spec.selectedOption && spec.selectedOption.price) {
        finalPrice += parseFloat(spec.selectedOption.price) || 0
      }
    })
  }
  
  // 生成规格标识用于比较
  const getSpecsSignature = (item) => {
    const parts = []
    if (item.spiciness) parts.push(`spicy:${item.spiciness}`)
    if (item.garnish) parts.push(`garnish:${item.garnish}`)
    if (item.selectedSpecs) {
      item.selectedSpecs.forEach(spec => {
        if (spec.selectedOption) {
          parts.push(`${spec.id}:${spec.selectedOption.id || spec.selectedOption.name}`)
        }
      })
    }
    return parts.join('|')
  }
  
  const newSignature = getSpecsSignature(dish)
  
  // 查找是否已有相同配置的菜品
  const existingItem = cartItems.value.find(item => {
    return item.id === dish.id && getSpecsSignature(item) === newSignature
  })
  
  if (existingItem) {
    existingItem.quantity += 1
  } else {
    // 生成选项描述
    const optionsDesc = getDishOptionsDescription(dish)
    
    cartItems.value.push({
      id: dish.id,
      dish_id: dish.id,
      name: dish.name,
      price: finalPrice,  // 使用计算后的最终价格
      basePrice: dish.price,  // 保存基础价格
      image: dish.image,
      quantity: 1,
      spiciness: dish.spiciness || null,
      garnish: dish.garnish || null,
      is_spicy_selectable: dish.is_spicy_selectable || false,
      is_garnish_selectable: dish.is_garnish_selectable || false,
      multi_spec_enabled: dish.multi_spec_enabled || false,
      selectedSpecs: dish.selectedSpecs || [],
      optionsDescription: optionsDesc
    })
  }
  
  // 保存到sessionStorage（按餐厅隔离）
  saveCart()
}

// 检查同一菜品是否有不同选项配置
const hasDifferentOptions = (dishId) => {
  const sameIdItems = cartItems.value.filter(item => item.id === dishId)
  
  if (sameIdItems.length <= 1) {
    return false
  }
  
  // 生成规格标识用于比较
  const getSpecsSignature = (item) => {
    const parts = []
    if (item.spiciness) parts.push(`spicy:${item.spiciness}`)
    if (item.garnish) parts.push(`garnish:${item.garnish}`)
    if (item.selectedSpecs) {
      item.selectedSpecs.forEach(spec => {
        if (spec.selectedOption) {
          parts.push(`${spec.id}:${spec.selectedOption.id || spec.selectedOption.name}`)
        }
      })
    }
    return parts.join('|')
  }
  
  // 检查是否所有配置都相同
  const firstSignature = getSpecsSignature(sameIdItems[0])
  return sameIdItems.some(item => getSpecsSignature(item) !== firstSignature)
}

// 从菜单页面减少菜品数量（传入dishId）
const decreaseQuantityFromMenu = (dishId) => {
  const sameIdItems = cartItems.value.filter(item => item.id === dishId)
  const totalQuantity = sameIdItems.reduce((sum, item) => sum + item.quantity, 0)
  
  // 如果总数量为1，或者数量大于1但所有选项都相同
  if (totalQuantity === 1 || !hasDifferentOptions(dishId)) {
    // 直接减少第一个匹配项的数量
    const item = sameIdItems[0]
    if (item) {
      if (item.quantity > 1) {
        item.quantity -= 1
      } else {
        const index = cartItems.value.indexOf(item)
        cartItems.value.splice(index, 1)
      }
      saveCart()
    }
  } else {
    // 数量大于1且有不同选项，打开购物车并提示
    showCart.value = true
    alert('该菜品有多个不同配置，请在购物车内修改数量')
  }
}

// 从购物车内减少菜品数量（传入index）
const decreaseQuantity = (index) => {
  const item = cartItems.value[index]
  
  if (item) {
    if (item.quantity > 1) {
      item.quantity -= 1
    } else {
      cartItems.value.splice(index, 1)
    }
    
    saveCart()
  }
}

// 保存购物车数据（按餐厅隔离）
const saveCart = () => {
  const rid = restaurant.value?.id || props.id
  if (!rid) return
  try {
    sessionStorage.setItem(cartStorageKey(rid), JSON.stringify(cartItems.value))
    // 存储当前活跃餐厅的完整信息，供下单页直接展示
    const r = restaurant.value || {}
    const payload = {
      id: r.id || rid,
      restaurant_id: r.restaurant_id || r.id || rid,
      name: r.name || '',
      address: r.address || '',
      opening_hours: r.opening_hours || '',
      notice: r.notice || '',
      rating: r.rating ?? null,
      // OrderForm.vue 使用 imageUrl 渲染；同时保留 image/avatar_url 兼容其他页面
      imageUrl: r.imageUrl || r.image || r.avatar_url || '',
      image: r.image || r.avatar_url || '',
      avatar_url: r.avatar_url || r.image || ''
    }
    sessionStorage.setItem('currentRestaurant', JSON.stringify(payload))
  } catch (e) {
    console.error('保存购物车失败:', e)
  }
}

// 切换购物车显示
const toggleCart = () => {
  showCart.value = !showCart.value
}

// 清空购物车（仅清空当前餐厅的购物车）
const clearCart = () => {
  const rid = restaurant.value?.id || props.id
  cartItems.value = []
  if (rid) {
    try {
      sessionStorage.removeItem(cartStorageKey(rid))
    } catch (e) {
      console.error('移除购物车缓存失败:', e)
    }
  }
  saveCart()
}

// 前往订单确认页
const goToOrderForm = () => {
  if (cartItems.value.length === 0) {
    return
  }
  
  router.push('/user/shop/order-form')
}

// 返回函数（类比Python中的方法）
const goBack = () => {
  router.back()
}
</script>

<style scoped>

.restaurant-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding-top: 60px;
}

.header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: 60px;
  background-color: white;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 16px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  z-index: 1000;
}

.back-btn {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 20px;
  background-color: #f0f0f0;
}

.header-title {
  font-size: 18px;
  font-weight: 600;
}

.header-icons {
  display: flex;
  gap: 16px;
}

.search-icon, .favorite-icon {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.favorite-icon {
  border: none;
  background: transparent;
  padding: 0;
  cursor: pointer;
  transition: transform 0.2s ease;
}

.favorite-icon:hover:not(:disabled) {
  transform: scale(1.05);
}

.favorite-icon:disabled {
  cursor: not-allowed;
  opacity: 0.6;
}

.favorite-icon.active svg path {
  fill: #ff4d4f;
  stroke: #ff4d4f;
}

.restaurant-info {
  background-color: white;
  padding: 15px;
  margin-bottom: 16px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.restaurant-top {
  display: flex;
  align-items: center;
  gap: 16px;
}

.restaurant-image {
  width: 100px;
  height: 100px;
  object-fit: cover;
  border-radius: 12px;
  flex-shrink: 0;
}

.restaurant-details {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.restaurant-name {
  font-size: 24px;
  font-weight: bold;
  margin-bottom: 0;
}

.restaurant-stats {
  display: flex;
  gap: 24px;
  align-items: center;
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
}

.stat-label {
  font-size: 14px;
  color: #999;
  margin-bottom: 4px;
}

.stat-value {
  font-size: 16px;
  font-weight: bold;
  color: #333;
}

.stat-value.green {
  color: #10b981;
}

.stat-value.red {
  color: #ef4444;
}

.stat-value.orange {
  color: #f59e0b;
}

.merchant-notice {
  font-size: 10px;
  color: #b3aeae;
  line-height: 1.6;
  border-radius: 8px;
  width: 100%;
  white-space: nowrap;
  overflow: hidden;
  padding: 4px 0;
  position: relative;
}

.notice-content {
  display: inline-block;
  animation: scroll-text 20s linear infinite;
}

@keyframes scroll-text {
  0% {
    transform: translateX(0);
  }
  100% {
    transform: translateX(-50%);
  }
}

.merchant-notice:hover .notice-content {
  animation-play-state: paused;
}

.menu-section {
  display: flex;
  flex-direction: column;
  background-color: white;
}

.menu-tabs {
  display: flex;
  border-bottom: 1px solid #f0f0f0;
  background-color: white;
  position: sticky;
  top: 60px;
  z-index: 100;
}

.menu-tab {
  flex: 1;
  padding: 16px;
  text-align: center;
  font-size: 15px;
  color: #666;
  cursor: pointer;
  position: relative;
  transition: color 0.3s;
}

.menu-tab.active {
  color: #FF6B35;
  font-weight: 600;
}

.menu-tab.active::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 40px;
  height: 3px;
  background-color: #FF6B35;
  border-radius: 2px;
}


.menu-content {
  min-height: calc(100vh - 350px);
  background-color: white;
}

.reviews-content {
  background-color: white;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .menu-content {
    min-height: auto;
  }
}

/* 购物车相关样式 */
.cart-button {
  position: fixed;
  bottom: 80px;
  right: 20px;
  width: 50px;
  height: 50px;
  background-color: #FF6B35;
  color: #fff;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 12px rgba(255, 107, 53, 0.3);
  cursor: pointer;
  z-index: 20;
  transition: all 0.3s;
}

.cart-button:hover {
  transform: scale(1.1);
  box-shadow: 0 6px 16px rgba(255, 107, 53, 0.4);
}

.cart-count {
  position: absolute;
  top: -5px;
  right: -5px;
  min-width: 20px;
  height: 20px;
  background-color: #fff;
  color: #FF6B35;
  border-radius: 10px;
  font-size: 12px;
  font-weight: bold;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 6px;
}

.cart-panel {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  background-color: #fff;
  border-radius: 20px 20px 0 0;
  box-shadow: 0 -4px 16px rgba(0, 0, 0, 0.1);
  z-index: 30;
  max-height: 70vh;
  display: flex;
  flex-direction: column;
}

.cart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #f0f0f0;
}

.cart-header h3 {
  margin: 0;
  font-size: 16px;
  font-weight: 600;
}

.close-cart {
  font-size: 24px;
  cursor: pointer;
  color: #999;
}

.cart-items {
  flex: 1;
  overflow-y: auto;
  padding: 0 20px;
}

.cart-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 0;
  border-bottom: 1px solid #f5f5f5;
}

.cart-item:last-child {
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

.item-price {
  font-size: 14px;
  color: #FF6B35;
  font-weight: 500;
}

.item-quantity {
  display: flex;
  align-items: center;
}

.quantity-btn {
  width: 28px;
  height: 28px;
  border: 1px solid #e0e0e0;
  background-color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  cursor: pointer;
  transition: all 0.3s;
}

.quantity-btn.plus {
  border-radius: 0 4px 4px 0;
  border-left: none;
}

.quantity-btn.minus {
  border-radius: 4px 0 0 4px;
  border-right: none;
}

.quantity-btn:hover {
  background-color: #f5f5f5;
}

.item-quantity span {
  min-width: 30px;
  height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  font-size: 14px;
  padding: 0 4px;
  border-top: 1px solid #e0e0e0;
  border-bottom: 1px solid #e0e0e0;
}

.cart-footer {
  padding: 15px 20px;
  border-top: 1px solid #f0f0f0;
}

.total-price {
  display: flex;
  justify-content: space-between;
  margin-bottom: 15px;
  font-size: 16px;
}

.total-price span:last-child {
  font-weight: 600;
  color: #FF6B35;
}

.submit-btn {
  width: 100%;
  padding: 12px;
  background-color: #FF6B35;
  color: #fff;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 500;
  cursor: pointer;
  transition: background-color 0.3s;
}

.submit-btn:hover {
  background-color: #ff855a;
}

/* 购物车动画 */
.cart-slide-enter-active,
.cart-slide-leave-active {
  transition: transform 0.3s ease;
}

.cart-slide-enter-from,
.cart-slide-leave-to {
  transform: translateY(100%);
}
</style>