<!-- 暂时删去了删选标签的组件 -->
<template>
  <div class="reviews-container">

    <!-- 评分卡片 - 横向布局 -->
    <div class="rating-cards">
      <div class="rating-card">
        <div class="card-title">综合评分</div>
        <div class="card-score">{{ avgRating.toFixed(1) }}</div>
        <div class="card-subtitle">{{ ratingDescription }}</div>
      </div>
      <div class="rating-card">
        <div class="card-title">商品质量</div>
        <div class="card-score">{{ avgFoodRating.toFixed(1) }}</div>
      </div>
      <div class="rating-card">
        <div class="card-title">服务体验</div>
        <div class="card-score">{{ avgServiceRating.toFixed(1) }}</div>
      </div>
    </div>

    <!-- 评价列表 -->
    <div class="reviews-list">
      <div
        v-for="review in filteredReviews"
        :key="review.id"
        class="review-item"
      >
        <!-- 用户信息 -->
        <div class="user-info">
          <img :src="review.avatar" :alt="review.username" class="user-avatar">
          <div class="user-details">
            <div class="username">{{ review.username }}</div>
            <div class="review-time">{{ formatTime(review.created_at || review.time) }}</div>
          </div>
          <div class="review-rating">
            <span
              v-for="i in 5"
              :key="i"
              class="review-star"
              :class="{ 'filled': i <= review.rating }"
            >
              {{ i <= review.rating ? '★' : '☆' }}
            </span>
          </div>
        </div>

        <!-- 评价内容 -->
        <div class="review-content">
          <p class="review-text">{{ review.content }}</p>
          <div class="review-images" v-if="review.images && review.images.length > 0">
            <img
              v-for="(image, index) in review.images"
              :key="index"
              :src="image"
              :alt="`评价图片${index + 1}`"
              class="review-image"
              @click="previewImage(image)"
            >
          </div>
          <div class="review-tags" v-if="review.tags && review.tags.length > 0">
            <span
              v-for="tag in review.tags"
              :key="tag"
              class="review-tag"
            >
              {{ tag }}
            </span>
          </div>
        </div>

        <!-- 评价互动 -->
          <div class="review-actions">
            <button class="action-btn" @click="toggleLike(review)">
              <span class="like-icon" :class="{ 'liked': review.isLiked }">
                {{ review.isLiked ? '❤️' : '🤍' }}
              </span>
              <span class="like-count">{{ review.likeCount || 0 }}</span>
            </button>
          </div>
        
          <!-- 商家回复 -->
          <div v-if="review.merchant_reply" class="merchant-reply">
            <div class="reply-header">商家回复：</div>
            <p class="reply-text">{{ review.merchant_reply }}</p>
            <div class="reply-time">{{ formatTime(review.merchant_reply_time) }}</div>
          </div>
      </div>
    </div>

    <!-- 图片预览模态框 -->
    <div
      v-if="showImageModal"
      class="image-modal"
      @click="closeImageModal"
    >
      <div class="modal-content">
        <img :src="previewImageUrl" alt="预览图片" class="preview-image">
        <button class="close-modal" @click="closeImageModal">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <line x1="18" y1="6" x2="6" y2="18"/>
            <line x1="6" y1="6" x2="18" y2="18"/>
          </svg>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'

// 比喻：这个组件就像一个评论管理员，负责展示和评价用户反馈
// 使用组合式API，就像一个评论工厂，可以生成各种评价报告

const router = useRouter()

// 餐厅信息（后端获取）
const props = defineProps({
  restaurantId: {
    type: [String, Number],
    required: false
  }
})

const restaurant = ref({
  name: '加载中',
  rating: 0,
  totalReviews: 0
})

// 商品质量评分
const qualityRating = ref({
  dish: 4.8,
  service: 4.5,
  environment: 4.6
})



// 选中的标签（保留占位，但不影响默认展示）
const selectedTags = ref([1])

// 评价列表（默认空，若传入 restaurantId 则从后端获取）
const reviews = ref([])

// 计算平均综合评分
const avgRating = computed(() => {
  if (!reviews.value || reviews.value.length === 0) return 0
  const sum = reviews.value.reduce((acc, r) => acc + (r.rating || 0), 0)
  return sum / reviews.value.length
})

// 评分描述
const ratingDescription = computed(() => {
  const score = avgRating.value
  if (score >= 4.5) return '好评如潮'
  if (score >= 4.0) return '广受好评'
  if (score >= 3.5) return '评价不错'
  if (score >= 3.0) return '表现平平'
  if (score > 0) return '差评较多'
  return '暂无评分'
})

// 平均商品评分（food_rating）
const avgFoodRating = computed(() => {
  if (!reviews.value || reviews.value.length === 0) return 0
  const vals = reviews.value.map(r => r.food_rating).filter(v => typeof v === 'number')
  if (vals.length === 0) return 0
  const sum = vals.reduce((a, b) => a + b, 0)
  return sum / vals.length
})

// 平均服务体验（service_rating 或 packaging_rating）
const avgServiceRating = computed(() => {
  if (!reviews.value || reviews.value.length === 0) return 0
  const vals = reviews.value.map(r => (typeof r.service_rating === 'number' ? r.service_rating : (typeof r.packaging_rating === 'number' ? r.packaging_rating : null))).filter(v => typeof v === 'number')
  if (vals.length === 0) return 0
  const sum = vals.reduce((a, b) => a + b, 0)
  return sum / vals.length
})

// 图片预览相关
const showImageModal = ref(false)
const previewImageUrl = ref('')

// 如果传入了 restaurantId，从后端加载真实数据
onMounted(async () => {
  if (props.restaurantId) {
    try {
  const token = localStorage.getItem('token')
  const headers = token ? { 'Authorization': `Bearer ${token}` } : {}
  const res = await fetch(`/api/restaurant/${props.restaurantId}/reviews`, { headers })
      const j = await res.json()
      if (j.success) {
        reviews.value = j.data.reviews.map(r => {
          return Object.assign({}, r, {
            avatar: r.user_id ? `https://picsum.photos/seed/${r.user_id}/40/40` : 'https://via.placeholder.com/40',
            isLiked: !!r.is_liked,
            likeCount: (r.likes || 0) // 如果后端有 likes 字段优先使用
          })
        })
      }
    } catch (e) {
      console.error('加载评价失败', e)
    }
  }
})

// 根据选中的标签过滤评价（当前不做筛选，直接返回评论）
const filteredReviews = computed(() => {
  return reviews.value
})

// 获取评级等级
const getRatingLevel = (rating) => {
  if (rating >= 4.5) return '极好'
  if (rating >= 4.0) return '很好'
  if (rating >= 3.5) return '好'
  if (rating >= 3.0) return '一般'
  return '较差'
}

// 获取星级评分百分比
const getRatingPercentage = (stars) => {
  const distribution = [10, 20, 30, 25, 15] // 示例数据
  return distribution[stars - 1] || 0
}

// 获取星级评分百分比数
const getRatingPercent = (stars) => {
  return getRatingPercentage(stars)
}

// 格式化时间，支持 ISO 字符串或时间戳
const formatTime = (time) => {
  if (!time) return ''
  try {
    const now = new Date()
    const date = new Date(time)
    if (isNaN(date.getTime())) return ''
    const diff = now - date
    const days = Math.floor(diff / (1000 * 60 * 60 * 24))

    if (days === 0) return '今天'
    if (days === 1) return '昨天'
    if (days < 7) return `${days}天前`
    if (days < 30) return `${Math.floor(days / 7)}周前`
    return `${Math.floor(days / 30)}个月前`
  } catch (e) {
    return ''
  }
}

// 切换标签选择
const toggleTag = (tagId) => {
  const index = selectedTags.value.indexOf(tagId)
  if (index > -1) {
    selectedTags.value.splice(index, 1)
  } else {
    selectedTags.value.push(tagId)
  }
}

// 点赞/取消点赞：先乐观更新，然后同步到后端；失败则回滚
const toggleLike = async (review) => {
  const token = localStorage.getItem('token')
  if (!token) {
    alert('请先登录以点赞')
    return
  }

  if (review._liking) return
  review._liking = true

  const willLike = !review.isLiked
  const prev = { isLiked: review.isLiked, likeCount: review.likeCount || 0 }

  // 乐观更新 UI
  review.isLiked = willLike
  review.likeCount = prev.likeCount + (willLike ? 1 : -1)

  try {
    const resp = await fetch(`/api/reviews/${review.id}/like`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      },
      body: JSON.stringify({ action: willLike ? 'like' : 'unlike' })
    })
    const j = await resp.json()
    if (resp.ok && j.success) {
      // 使用服务器返回的 likes 与 is_liked 保持一致
      if (j.data) {
        if (typeof j.data.likes === 'number') review.likeCount = j.data.likes
        if (typeof j.data.is_liked !== 'undefined') review.isLiked = !!j.data.is_liked
      }
    } else {
      // 回滚
      review.isLiked = prev.isLiked
      review.likeCount = prev.likeCount
      console.error('点赞失败', j)
      alert(j.message || '点赞失败')
    }
  } catch (e) {
    // 网络或其他错误，回滚
    review.isLiked = prev.isLiked
    review.likeCount = prev.likeCount
    console.error('点赞出错', e)
    alert('网络错误，点赞失败')
  }
  review._liking = false
}

// 回复评价
const replyToReview = (review) => {
  console.log('回复评价:', review.username)
  // 这里可以打开回复对话框或跳转到回复页面
}

// 预览图片
const previewImage = (imageUrl) => {
  previewImageUrl.value = imageUrl
  showImageModal.value = true
}

// 关闭图片预览
const closeImageModal = () => {
  showImageModal.value = false
  previewImageUrl.value = ''
}

// 返回
const goBack = () => {
  router.back()
}
</script>

<style scoped>


.reviews-container {
  min-height: 100vh;
  background-color: #f5f5f5;
}

.rating-cards {
  display: flex;
  gap: 12px;
  padding: 16px;
  background-color: white;
  margin-bottom: 8px;
}

.rating-card {
  flex: 1;
  text-align: center;
  padding: 16px 8px;
  background-color: #f8f8f8;
  border-radius: 8px;
}

.card-title {
  font-size: 12px;
  color: #999;
  margin-bottom: 8px;
}

.card-score {
  font-size: 24px;
  font-weight: bold;
  color: #FF6B35;
  margin-bottom: 4px;
}

.card-subtitle {
  font-size: 11px;
  color: #666;
}

.reviews-list {
  padding: 0 16px 20px;
}

.review-item {
  background-color: white;
  border-radius: 12px;
  padding: 16px;
  margin-bottom: 12px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

.user-info {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 12px;
}

.user-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  object-fit: cover;
}

.user-details {
  flex: 1;
}

.username {
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin-bottom: 4px;
}

.review-time {
  font-size: 12px;
  color: #999;
}

.review-rating {
  display: flex;
  gap: 2px;
}

.review-star {
  font-size: 16px;
  color: #ddd;
}

.review-star.filled {
  color: #FFD700;
}

.review-content {
  margin-bottom: 12px;
}

.review-text {
  font-size: 14px;
  color: #666;
  line-height: 1.6;
  margin-bottom: 8px;
}

.review-images {
  display: flex;
  gap: 8px;
  margin-bottom: 8px;
}

.review-image {
  width: 60px;
  height: 60px;
  border-radius: 8px;
  object-fit: cover;
  cursor: pointer;
}

.review-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}

.review-tag {
  padding: 4px 8px;
  background-color: #f5f5f5;
  border-radius: 4px;
  font-size: 12px;
  color: #666;
}

.review-actions {
  display: flex;
  gap: 16px;
  padding-top: 8px;
  border-top: 1px solid #eee;
}

.action-btn {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 4px 8px;
  background: none;
  border: none;
  font-size: 14px;
  color: #666;
  cursor: pointer;
  transition: color 0.2s;
}

.action-btn:hover {
  color: #FF6B35;
}

.like-icon {
  font-size: 16px;
}

.like-icon.liked {
  color: #FF6B35;
}

.like-count {
  font-size: 14px;
}

/* 商家回复样式 */
.merchant-reply {
  margin-top: 12px;
  padding: 12px;
  background-color: #f9fafb;
  border-radius: 8px;
  border-left: 3px solid #FF6B35;
}

.reply-header {
  font-size: 12px;
  font-weight: 600;
  color: #FF6B35;
  margin-bottom: 6px;
}

.reply-text {
  font-size: 13px;
  color: #666;
  line-height: 1.5;
  margin: 0 0 6px 0;
}

.reply-time {
  font-size: 11px;
  color: #999;
}

.image-modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0,0,0,0.8);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2000;
}

.modal-content {
  position: relative;
  max-width: 90%;
  max-height: 90%;
}

.preview-image {
  max-width: 100%;
  max-height: 100%;
  border-radius: 8px;
}

.close-modal {
  position: absolute;
  top: -40px;
  right: -40px;
  width: 32px;
  height: 32px;
  background-color: white;
  border: none;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  box-shadow: 0 2px 8px rgba(0,0,0,0.2);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .rating-cards {
    gap: 8px;
    padding: 12px;
  }

  .rating-card {
    padding: 12px 6px;
  }

  .card-score {
    font-size: 20px;
  }

  .review-images {
    gap: 6px;
  }

  .review-image {
    width: 50px;
    height: 50px;
  }
}
</style>