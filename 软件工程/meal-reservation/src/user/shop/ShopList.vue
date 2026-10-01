<template>
  <div class="shop-page">
    <!-- 顶部区域 -->
    <div class="header-area">
      <!-- 切换 Tab -->
      <div class="tabs-container">
        <div 
          class="tab-btn" 
          :class="{ active: activeTab === 'nearby' }"
          @click="activeTab = 'nearby'"
        >
          商家
        </div>
        <div 
          class="tab-btn" 
          :class="{ active: activeTab === 'recommendation' }"
          @click="activeTab = 'recommendation'"
        >
          推荐
        </div>
      </div>

      <!-- 搜索框 -->
      <div class="search-container">
        <input 
          v-if="activeTab === 'nearby'"
          v-model="shopSearchQuery" 
          type="text" 
          placeholder="搜索商家..." 
          class="search-input" 
        />
        <input 
          v-else
          v-model="recSearchQuery" 
          type="text" 
          placeholder="搜索推荐菜品..." 
          class="search-input" 
        />
        <button class="search-btn">搜索</button>
      </div>
    </div>

    <!-- 内容区域 -->
    <div class="content-area">
      
      <!-- 推荐界面 (Grid Layout) -->
      <div v-if="activeTab === 'recommendation'" class="recommendation-grid">
        <div v-if="recommendations.length === 0" class="loading-text">加载推荐中...</div>
        
        <div 
          v-for="(item, index) in filteredRecommendations" 
          :key="index" 
          class="rec-card"
          @click="goToDishDetail(item)"
        >
          <div class="rec-img-wrapper">
            <!-- 添加 @error 处理 -->
            <img 
              :src="item.image_url" 
              class="rec-img" 
              alt="food" 
              @error="handleDishImageError"
            />
          </div>
          <div class="rec-info">
            <h3 class="rec-title">{{ item.name }}</h3>
            <p class="rec-shop">{{ item.restaurant_name || '未知商家' }}</p>
            <div class="rec-bottom">
              <div class="price-box">
                <span class="currency">¥</span>
                <span class="price-num">{{ item.price }}</span>
              </div>
              <span class="rec-reason" v-if="item.recommendation_reason">{{ item.recommendation_reason }}</span>
            </div>
          </div>
        </div>
      </div>

      <!--商家界面 (List Layout) -->
      <div v-else class="nearby-list">
        <div v-if="shops.length === 0" class="loading-text">加载商家中...</div>

        <div 
          v-for="shop in filteredShops" 
          :key="shop.id" 
          class="shop-card"
          :class="{ 'shop-card-closed': shop.is_open === false }"
          @click="handleShopCardClick(shop)"
        >
          <div class="shop-img-box">
            <!-- 修改 img 标签，添加 @error 处理 -->
            <img 
              :src="shop.avatar_url" 
              class="shop-img" 
              alt="shop" 
              @error="handleShopImageError"
            />
            <div v-if="shop.is_open === false" class="shop-closed-badge">已打烊</div>
          </div>
          <div class="shop-details">
            <div class="shop-header">
              <div class="shop-title">
                <h3 class="shop-name">{{ shop.name }}</h3>
                <div class="shop-location" :title="shop.address || '暂无地址'">
                  {{ shop.address || '暂无地址' }}
                </div>
              </div>
              <div class="shop-rating">
                <template v-if="shop.rating && shop.rating > 0">
                  <span class="star">★</span>
                  <span>{{ shop.rating }}</span>
                </template>
                <span v-else class="no-rating">暂无评分</span>
              </div>
            </div>
            <div class="shop-tags-row">
              <span class="tag-blue">特色</span>
              <span class="tag-blue">推荐</span>
            </div>
            
            <!-- 排队信息展示 -->
            <div class="shop-queue-row">
              <div class="queue-item">
                <span class="queue-label">空闲座位</span>
                <span class="queue-val green">{{ shop.idle_seats_count || 0 }}</span>
              </div>
              <div class="queue-divider">|</div>
              <div class="queue-item">
                <span class="queue-label">排队</span>
                <span class="queue-val orange">{{ shop.queue_orders_count || 0 }}</span>
              </div>
              <div class="queue-divider">|</div>
              <div class="queue-item">
                <span class="queue-label">预计</span>
                <span class="queue-val red">{{ shop.estimated_wait_time || 0 }}分</span>
              </div>
            </div>

            <p class="shop-notice">{{ shop.notice || '欢迎光临，请提前10分钟下单' }}</p>
            <div class="shop-footer">
              <button v-if="shop.is_open !== false" class="book-btn" @click.stop="goToShop(shop)">立即预订</button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <BottomNav />
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, nextTick } from 'vue'
import { useRouter, onBeforeRouteLeave } from 'vue-router'
import BottomNav from '../components/BottomNav.vue'
import { getRecommendations, getRestaurants } from '@/api/shops'

const router = useRouter()
const activeTab = ref('nearby')
const shopSearchQuery = ref('')
const recSearchQuery = ref('')

const recommendations = ref([])
const baseRecommendations = ref([])
const shops = ref([])

// 获取推荐数据
const fetchRecommendations = async () => {
  try {
    const res = await getRecommendations()
    const data = res.data
    if (data.success) {
      // 注意后端返回结构是 data.data.dishes
      const items = (data.data.dishes || []).map(dish => ({
        ...dish,
        image_url: (dish.image_url && !dish.image_url.startsWith('http') 
          ? (typeof API_url !== 'undefined' ? API_url : '') + dish.image_url 
          : dish.image_url) || `${typeof API_url !== 'undefined' ? API_url : ''}/static/default/dish.png`
      }))
      recommendations.value = items
      baseRecommendations.value = items
    } else {
      // Fallback mock data if API fails or returns empty
      const items = getMockRecommendations()
      recommendations.value = items
      baseRecommendations.value = items
    }
  } catch (e) {
    console.error('Fetch recommendations failed', e)
    const items = getMockRecommendations()
    recommendations.value = items
    baseRecommendations.value = items
  }
}

// 获取商家列表
const fetchShops = async () => {
  try {
    const res = await getRestaurants()
    const data = res.data
    if (data.success) {
      shops.value = data.data.restaurants.map((shop, index) => ({
        ...shop,
        __originIndex: index,
        // 预处理图片URL，如果为空则使用默认图
        avatar_url: shop.avatar_url || `${typeof API_url !== 'undefined' ? API_url : ''}/static/default/restaurant.png`
      }))
    } else {
      shops.value = getMockShops().map((shop, index) => ({ ...shop, __originIndex: index }))
    }
  } catch (e) {
    console.error('Fetch shops failed', e)
    shops.value = getMockShops().map((shop, index) => ({ ...shop, __originIndex: index }))
  }
}

// 添加图片加载失败处理函数
const handleShopImageError = (e) => {
  e.target.src = `${typeof API_url !== 'undefined' ? API_url : ''}/static/default/restaurant.png`
}

// 添加菜品图片加载失败处理函数
const handleDishImageError = (e) => {
  e.target.src = `${typeof API_url !== 'undefined' ? API_url : ''}/static/default/dish.png`
}

onMounted(async () => {
  let savedState = null
  try {
    const savedStateStr = sessionStorage.getItem('shopListState')
    if (savedStateStr) {
      savedState = JSON.parse(savedStateStr)
      if (savedState.activeTab) {
        activeTab.value = savedState.activeTab
      }
    }
  } catch (e) {
    console.error('State restore failed', e)
  }

  await Promise.all([fetchRecommendations(), fetchShops()])

  window.addEventListener('scroll', handleScroll)

  if (savedState && savedState.scrollTop) {
    nextTick(() => {
      window.scrollTo(0, savedState.scrollTop)
    })
  }
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})

const handleScroll = () => {
  if (activeTab.value !== 'recommendation') return
  
  const scrollTop = window.scrollY || document.documentElement.scrollTop
  const windowHeight = window.innerHeight
  const documentHeight = document.documentElement.scrollHeight
  
  if (scrollTop + windowHeight >= documentHeight - 50) {
    loadMoreRecommendations()
  }
}

const loadMoreRecommendations = () => {
  if (baseRecommendations.value.length === 0) return
  recommendations.value = [...recommendations.value, ...baseRecommendations.value]
}

onBeforeRouteLeave((to, from, next) => {
  const state = {
    activeTab: activeTab.value,
    scrollTop: window.scrollY || document.documentElement.scrollTop || document.body.scrollTop
  }
  sessionStorage.setItem('shopListState', JSON.stringify(state))
  next()
})

const filteredShops = computed(() => {
  const q = shopSearchQuery.value.trim().toLowerCase()
  const list = !q ? shops.value : shops.value.filter(s => s.name.toLowerCase().includes(q))

  // 排序规则：
  // 1) 已打烊(is_open===false) 永远在最下方
  // 2) 其余按评分降序；无评分的保持默认顺序
  // 3) 兜底用 __originIndex 保持稳定
  return [...list].sort((a, b) => {
    const aClosed = a?.is_open === false
    const bClosed = b?.is_open === false
    if (aClosed !== bClosed) return aClosed ? 1 : -1

    const aRating = typeof a?.rating === 'number' ? a.rating : Number(a?.rating)
    const bRating = typeof b?.rating === 'number' ? b.rating : Number(b?.rating)
    const aHasRating = Number.isFinite(aRating) && aRating > 0
    const bHasRating = Number.isFinite(bRating) && bRating > 0

    if (aHasRating !== bHasRating) return (bHasRating ? 1 : 0) - (aHasRating ? 1 : 0)
    if (aHasRating && bHasRating && aRating !== bRating) return bRating - aRating

    const aIdx = Number.isFinite(a?.__originIndex) ? a.__originIndex : 0
    const bIdx = Number.isFinite(b?.__originIndex) ? b.__originIndex : 0
    return aIdx - bIdx
  })
})

const filteredRecommendations = computed(() => {
  const q = recSearchQuery.value.trim().toLowerCase()
  if (!q) return recommendations.value
  return recommendations.value.filter(item => item.name.toLowerCase().includes(q))
})

function goToShop(shop) {
  router.push({
    name: 'Restaurant',
    query: { id: shop.id }
  })
}

function handleShopCardClick(shop) {
  if (shop?.is_open === false) return
  goToShop(shop)
}

function goToDishDetail(dish) {
  // 如果是推荐菜品，点击跳转到对应餐厅
  if (dish.restaurant_id) {
    router.push({
      name: 'Restaurant',
      query: { id: dish.restaurant_id }
    })
  } else {
    console.warn('菜品数据缺少 restaurant_id', dish)
  }
}

// Mock Data Helpers
function getMockRecommendations() {
  return [
    { id: 1, restaurant_id: 1, name: '沙县小吃(黄渡店)', restaurant_name: '沙县小吃', price: 18, image_url: 'https://picsum.photos/seed/food1/300/200', recommendation_reason: '近期热销' },
    { id: 2, restaurant_id: 2, name: '刘大姐擂椒拌饭', restaurant_name: '刘大姐', price: 25, image_url: 'https://picsum.photos/seed/food2/300/200', recommendation_reason: '口味匹配' },
    { id: 3, restaurant_id: 1, name: '乐惠(同济店)', restaurant_name: '乐惠', price: 32, image_url: 'https://picsum.photos/seed/food3/300/200', recommendation_reason: '好评如潮' },
    { id: 4, restaurant_id: 2, name: '极味肥牛饭', restaurant_name: '极味', price: 28, image_url: 'https://picsum.photos/seed/food4/300/200', recommendation_reason: '超值优惠' }
  ]
}

function getMockShops() {
  return [
    { 
      id: 1, 
      name: '默认餐厅', 
      notice: '欢迎光临', 
      avatar_url: 'https://picsum.photos/seed/shop1/200/200',
      idle_seats_count: 20,
      queue_orders_count: 2,
      estimated_wait_time: 10
    },
    { 
      id: 2, 
      name: '川香小厨', 
      notice: '地道川味', 
      avatar_url: 'https://picsum.photos/seed/shop2/200/200',
      idle_seats_count: 0,
      queue_orders_count: 8,
      estimated_wait_time: 45
    }
  ]
}
</script>

<style scoped>
.shop-page {
  min-height: 100vh;
  background-color: #f7f8fb;
  padding-bottom: 70px;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
}

/* Header Area */
.header-area {
  padding: 16px 16px 10px;
  background: #ffffff;
  border-bottom: 1px solid #eef0f4;
  margin-bottom: 12px;
  position: sticky;
  top: 0;
  z-index: 50;
}

/* Tabs */
.tabs-container {
  display: flex;
  background: #f5f5f5;
  border-radius: 30px;
  padding: 4px;
  margin-bottom: 16px;
}

.tab-btn {
  flex: 1;
  text-align: center;
  padding: 8px 0;
  font-size: 16px;
  font-weight: 500;
  color: #4B5563;
  cursor: pointer;
  border-radius: 26px;
  transition: all 0.3s ease;
}

.tab-btn.active {
  background: #fff;
  color: #000;
  font-weight: 600;
  box-shadow: 0 2px 4px rgba(0,0,0,0.05);
}

/* Search Bar */
.search-container {
  display: flex;
  gap: 10px;
}

.search-input {
  flex: 1;
  padding: 10px 16px;
  border-radius: 8px;
  border: none;
  outline: none;
  background: #f5f5f5;
  font-size: 14px;
}

.search-btn {
  background: #FFD101; /* Same as bg but with border/shadow usually, here using darker yellow or outline */
  background: #F5C500;
  border: 1px solid #333;
  color: #333;
  padding: 0 20px;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
}

/* Content Area */
.content-area {
  padding: 0 16px;
}

.loading-text {
  text-align: center;
  padding: 20px;
  color: #666;
}

/* Recommendation Grid */
.recommendation-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
}

@media (max-width: 420px) {
  .recommendation-grid {
    grid-template-columns: 1fr;
  }
}

.rec-card {
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
  display: flex;
  flex-direction: column;
}

.rec-img-wrapper {
  position: relative;
  aspect-ratio: 4 / 2;
  height: auto;
  background: #eee;
}

.rec-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.badge-delivery {
  position: absolute;
  top: 8px;
  left: 8px;
  background: #FF6B00; /* Orange */
  color: #fff;
  font-size: 10px;
  padding: 2px 6px;
  border-radius: 4px;
}

.badge-time {
  position: absolute;
  top: 8px;
  right: 8px;
  background: #FFD101;
  color: #333;
  font-size: 10px;
  padding: 2px 6px;
  border-radius: 4px;
  font-weight: 600;
}

.rec-info {
  padding: 10px;
  flex: 1;
  display: flex;
  flex-direction: column;
}

.rec-title {
  font-size: 15px;
  font-weight: 600;
  margin: 0 0 4px 0;
  color: #333;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.rec-shop {
  font-size: 12px;
  color: #666;
  margin-bottom: 6px;
}

.rec-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  margin-bottom: 8px;
}

.tag-red {
  font-size: 10px;
  color: #FF4D4F;
  border: 1px solid #FF4D4F;
  padding: 0 4px;
  border-radius: 4px;
}

.rec-bottom {
  margin-top: auto;
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
}

.price-box {
  color: #FF4D4F;
  font-weight: bold;
}

.currency {
  font-size: 12px;
}

.price-num {
  font-size: 16px;
}

.rec-reason {
  font-size: 10px;
  color: #FF9C00;
  background: #FFF7E6;
  padding: 2px 4px;
  border-radius: 4px;
}

/* Nearby List */
.nearby-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.shop-card {
  background: #fff;
  border-radius: 12px;
  padding: 12px;
  display: flex;
  gap: 12px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

.shop-card-closed {
  cursor: not-allowed;
  opacity: 0.78;
}

.shop-img-box {
  width: 90px;
  height: 90px;
  border-radius: 8px;
  overflow: hidden;
  flex-shrink: 0;
  position: relative;
}

.shop-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.shop-closed-badge {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  padding: 4px 0;
  text-align: center;
  font-size: 12px;
  font-weight: 600;
  color: #ffffff;
  background: rgba(107, 114, 128, 0.85);
}

.shop-details {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.shop-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.shop-title {
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.shop-name {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin: 0;
}

.shop-location {
  font-size: 12px;
  color: #999;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.shop-rating {
  color: #FFB800;
  font-size: 12px;
  font-weight: 600;
}

.shop-tags-row {
  display: flex;
  gap: 6px;
  margin: 4px 0;
}

.shop-queue-row {
  display: flex;
  align-items: center;
  margin: 6px 0;
  background: #f9fafb;
  padding: 6px 8px;
  border-radius: 6px;
  font-size: 11px;
}

.queue-item {
  display: flex;
  align-items: center;
  gap: 4px;
}

.queue-label {
  color: #6b7280;
}

.queue-val {
  font-weight: 600;
}

.queue-val.green { color: #10b981; }
.queue-val.orange { color: #f59e0b; }
.queue-val.red { color: #ef4444; }

.queue-divider {
  color: #e5e7eb;
  margin: 0 8px;
}

.tag-blue {
  background: #E6F7FF;
  color: #1890FF;
  font-size: 10px;
  padding: 2px 6px;
  border-radius: 4px;
}

.shop-notice {
  font-size: 12px;
  color: #999;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  margin: 0 0 8px 0;
}

.shop-footer {
  display: flex;
  justify-content: flex-end;
  align-items: center;
}

.book-btn {
  background: #FF4D4F;
  color: #fff;
  border: none;
  padding: 6px 12px;
  border-radius: 16px;
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
  margin-top: -30px;
}
</style>
