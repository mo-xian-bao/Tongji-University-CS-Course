<template>
  <div class="write-review-container">
    <!-- 头部 -->
    <header class="review-header">
      <button class="back-btn" @click="goBack">
        <i class="fas fa-arrow-left"></i>
      </button>
      <h1>{{ viewOnly ? '评价详情' : '写评价' }}</h1>
      <div class="header-spacer"></div>
    </header>

    <!-- 主要内容 -->
    <main class="review-main" v-if="order">
      <!-- 提示文字 -->
      <div class="tip-text">
        您的评价有助于商家做的更好
      </div>

      <!-- 商家信息 -->
      <div class="merchant-info">
        <!-- 修改图片 src 逻辑，添加 @error 处理 -->
        <img 
          :src="getDishImage(order.items[0])" 
          alt="商家logo"
          class="merchant-logo"
          @error="handleImageError"
        />
        <span class="merchant-name">{{ order.restaurant_name }}</span>
      </div>

      <!-- 商品评分 -->
      <div class="rating-block" v-if="!viewOnly">
        <div class="rating-header">
          <span>商品</span>
          <span class="rating-text" :class="`rating-${foodRating}`">{{ getRatingText(foodRating) }}</span>
        </div>
        <div class="stars-container">
          <div class="stars">
            <span 
              v-for="i in 5" 
              :key="`food-${i}`"
              class="star"
              :class="{ filled: i <= foodRating }"
              @click="!viewOnly && (foodRating = i)"
            >★</span>
          </div>
        </div>
      </div>
      
      <!-- 包装/服务评分 -->
      <div class="rating-block" v-if="!viewOnly">
        <div class="rating-header">
          <span>{{ isTakeout ? '包装' : '服务' }}</span>
          <span class="rating-text" :class="`rating-${isTakeout ? packagingRating : serviceRating}`">
            {{ getRatingText(isTakeout ? packagingRating : serviceRating) }}
          </span>
        </div>
        <div class="stars-container">
          <div class="stars">
            <span 
              v-for="i in 5" 
              :key="`service-${i}`"
              class="star"
              :class="{ filled: i <= (isTakeout ? packagingRating : serviceRating) }"
              @click="!viewOnly && (isTakeout ? (packagingRating = i) : (serviceRating = i))"
            >★</span>
          </div>
        </div>
      </div>
      
      <!-- 评论输入框 -->
      <div class="comment-section" v-if="!viewOnly">
        <div class="textarea-wrapper">
          <textarea 
            v-model="content"
            placeholder="说说味道怎么样，给大家参考"
            rows="4"
            class="comment-textarea"
            maxlength="200"
            :disabled="viewOnly"
          ></textarea>
          <div class="char-count">{{ content.length }}/200字</div>
        </div>
      </div>
      
      <!-- 媒体上传 -->
      <div class="media-upload" v-if="!viewOnly">
        <button class="upload-btn" @click="openImageUpload" :disabled="viewOnly">
          <div class="camera-icon">📷</div>
          <span>添加图片</span>
        </button>
        <input 
          ref="imageInput"
          type="file"
          multiple
          accept="image/*"
          style="display: none"
          @change="handleImageSelect"
        />
      </div>
      
      <!-- 已上传的图片预览 -->
      <div v-if="!viewOnly && uploadedImages.length > 0" class="image-preview">
        <div v-for="(img, idx) in uploadedImages" :key="idx" class="preview-item">
          <img :src="img" :alt="`图片${idx + 1}`" />
          <button
            class="delete-btn"
            @click="!viewOnly && deleteImage(idx)"
            :disabled="viewOnly"
            title="仅在可编辑时可删除"
          >×</button>
        </div>
      </div>
      
      <!-- 已有评价内容 -->
      <div v-if="viewOnly && existingReview" class="existing-review">
        <!-- 审核状态 pill -->
        <div class="review-status-row">
          <span :class="['review-pill', existingReview.review_status || 'pending']">
            {{ getReviewStatusLabel(existingReview.review_status) }}
          </span>
        </div>

        <div class="review-content">
          <div class="review-rating">
            <span>商品:</span>
            <div class="stars">
              <span 
                v-for="i in 5" 
                :key="`existing-food-${i}`"
                class="star"
                :class="{ filled: i <= existingReview.food_rating }"
              >★</span>
            </div>
          </div>
          <div class="review-rating">
            <span>{{ isTakeout ? '包装' : '服务' }}:</span>
            <div class="stars">
              <span 
                v-for="i in 5" 
                :key="`existing-service-${i}`"
                class="star"
                :class="{ filled: i <= (isTakeout ? existingReview.packaging_rating : existingReview.service_rating) }"
              >★</span>
            </div>
          </div>
          <div class="review-text">
            {{ existingReview.content }}
          </div>

          <!-- 若被拒绝，显示驳回理由 -->
          <div v-if="existingReview.review_status === 'rejected'" class="reject-reason">
            <h4>驳回理由</h4>
            <p>{{ existingReview.review_reject_reason || '未填写理由' }}</p>
          </div>

          <!-- 若审核中，显示提示 -->
          <div v-else-if="existingReview.review_status === 'pending'" class="reviewing-hint">
            <small>您的评论正在审核中，审核通过后将显示在店铺页面。</small>
          </div>
        </div>
      </div>
    </main>

    <div v-else class="empty">加载中...</div>

    <!-- 底部按钮 -->
    <footer class="review-footer" v-if="!viewOnly">
      <button 
        class="submit-btn"
        :class="{ disabled: !order || submitLoading }"
        :disabled="!order || submitLoading || viewOnly"
        @click="submitReview"
      >
        {{ submitLoading ? '提交中…' : '提交评价' }}
      </button>
    </footer>
    <!-- viewOnly 模式只显示返回按钮 -->
    <footer class="review-footer" v-else>
      <button class="submit-btn" @click="goBack">返回</button>
    </footer>
  </div>
</template>

<script>
import { getOrder, getOrderReview, submitReview } from '@/api/orders'

export default {
  props: ['orderId'],
  data() {
    return {
      order: null,
      foodRating: 5,
      packagingRating: 5,
      serviceRating: 5,
      content: '',
      uploadedImages: [],
      // defaultImage, // 移除 data 中的 defaultImage
      submitLoading: false,
      viewOnly: false,
      existingReview: null
    }
  },
  computed: {
    isTakeout() {
      if (!this.order) return false
      const t = (this.order.order_type || '').toLowerCase()
      return t.includes('take') || t.includes('out') || t.includes('takeout')
    },
    rating() {
      if (this.isTakeout) {
        return Math.round(((this.foodRating || 0) + (this.packagingRating || 0)) / 2)
      }
      return Math.round(((this.foodRating || 0) + (this.serviceRating || 0)) / 2)
    }
  },
  async mounted() {
    await this.fetchOrder()
    const mode = this.$route.query.mode
    // 如果路由 mode=detail 或后端返回该订单已经有评价，则进入只读详情模式
    if (mode === 'detail' || (this.order && this.order.has_review)) {
      this.viewOnly = true
      await this.loadExistingReview()
    } else {
      this.viewOnly = false
    }
  },
  methods: {
    // 添加获取图片URL的方法
    getDishImage(item) {
      if (item && item.dish_image) {
        return `${API_url}${item.dish_image}`;
      }
      return `${API_url}/static/default/dish.png`;
    },
    // 添加图片加载失败处理方法
    handleImageError(e) {
      e.target.src = `${API_url}/static/default/dish.png`;
    },
    goBack() {
      this.$router.back()
    },
    getRatingText(rating) {
      const texts = {
        5: '超赞!',
        4: '满意',
        3: '一般',
        2: '不太满意',
        1: '不满意'
      }
      return texts[rating] || ''
    },
    formatTime(t) {
      try {
        return new Date(t).toLocaleString('zh-CN')
      } catch (e) {
        return t
      }
    },
    async fetchOrder() {
      try {
        const res = await getOrder(this.orderId)
        const j = res.data
        if (j.success) {
          this.order = j.data
        } else {
          alert(j.message || '读取订单失败')
        }
      } catch (e) {
        console.error(e)
        alert(e.response?.data?.message || '读取订单失败')
      }
    },
    openImageUpload() {
      this.$refs.imageInput.click()
    },
    handleImageSelect(event) {
      const files = event.target.files
      if (!files) return
      
      Array.from(files).forEach(file => {
        const reader = new FileReader()
        reader.onload = (e) => {
          this.uploadedImages.push(e.target.result)
        }
        reader.readAsDataURL(file)
      })
    },
    deleteImage(index) {
      this.uploadedImages.splice(index, 1)
    },
    async loadExistingReview() {
      const orderId = this.orderId || this.$route.params.orderId || (this.order && this.order.id)
      if (!orderId) {
        console.warn('loadExistingReview: 没有 orderId')
        return
      }
      try {
        const res = await getOrderReview(orderId)
        const j = res.data
        if (j.success && j.data && j.data.review) {
          this.existingReview = j.data.review
        } else {
          // 若没有 review，仍显示空
          this.existingReview = null
        }
      } catch (e) {
        console.error('载入已有评价失败', e)
        this.existingReview = null
      }
    },
    getReviewStatusLabel(status) {
      const map = {
        pending: '审核中',
        approved: '已通过',
        rejected: '已拒绝'
      }
      return map[(status || '').toString().toLowerCase()] || '未知'
    },
    async submitReview() {
      if (!this.content.trim()) {
        alert('请输入评价内容')
        return
      }

      this.submitLoading = true
      try {
        const payload = {
          order_id: this.order.id,
          rating: this.rating,
          content: this.content,
          images: this.uploadedImages,
          food_rating: this.foodRating,
          packaging_rating: this.isTakeout ? this.packagingRating : null,
          service_rating: this.isTakeout ? null : this.serviceRating
        }

        const res = await submitReview(payload)
        const j = res.data
        if (j.success) {
          // 使用后端返回的 message（通常为“评论提交成功，等待管理员审核”）
          alert(j.message || '评论提交成功，等待管理员审核')
          this.$router.push({ name: 'OrderManagement' })
        } else {
          alert(j.message || '提交失败')
        }
      } catch (e) {
        console.error(e)
        alert(e.response?.data?.message || '提交失败')
      } finally {
        this.submitLoading = false
      }
    }
  }
}
</script>

<style scoped>
* {
  box-sizing: border-box;
}

.write-review-container {
  background-color: #f3f7ff;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  padding-bottom: 80px;
  width: 100%;
}

/* 头部 */
.review-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 16px;
  border-bottom: 1px solid #e5e7eb;
  background: white;
}

.review-header h1 {
  margin: 0;
  font-size: 18px;
  font-weight: 500;
  flex: 1;
  text-align: center;
}

.back-btn {
  background: none;
  border: none;
  font-size: 18px;
  color: #999;
  cursor: pointer;
  padding: 0;
  width: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.back-btn:hover {
  color: #666;
}

.header-spacer {
  width: 40px;
}

/* 主要内容 */
.review-main {
  flex: 1;
  padding: 16px;
  overflow-y: auto;
}

/* 提示文字 */
.tip-text {
  text-align: center;
  color: #999;
  font-size: 14px;
  margin-bottom: 16px;
}

/* 商家信息 */
.merchant-info {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px;
  background-color: #f9fafb;
  border-radius: 8px;
  margin-bottom: 16px;
}

.merchant-logo {
  width: 40px;
  height: 40px;
  border-radius: 6px;
  object-fit: cover;
  flex-shrink: 0;
}

.merchant-name {
  font-weight: 500;
  font-size: 14px;
  color: #374151;
}

/* 评分块 */
.rating-block {
  background-color: white;
  padding: 12px;
  margin-bottom: 12px;
  border-radius: 8px;
}

.rating-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 12px;
}

.rating-header span:first-child {
  color: #374151;
  font-size: 14px;
  font-weight: 500;
}

.rating-text {
  font-size: 14px;
  font-weight: 500;
}

.rating-text.rating-5 {
  color: #fbbf24;
}

.rating-text.rating-4 {
  color: #60a5fa;
}

.rating-text.rating-3 {
  color: #999;
}

.rating-text.rating-2 {
  color: #f97316;
}

.rating-text.rating-1 {
  color: #ef4444;
}

.stars-container {
  display: flex;
}

.stars {
  display: flex;
  gap: 8px;
}

.star {
  font-size: 28px;
  cursor: pointer;
  color: #ddd;
  transition: all 0.2s ease;
  user-select: none;
  display: inline-block;
  line-height: 1;
}

.star:hover {
  color: #fbbf24;
  transform: scale(1.15);
}

.star.filled {
  color: #fbbf24;
  text-shadow: 0 0 3px rgba(251, 191, 36, 0.5);
}

/* 评论输入框 */
.comment-section {
  background-color: white;
  padding: 12px;
  margin-bottom: 12px;
  border-radius: 8px;
}

.textarea-wrapper {
  position: relative;
}

.comment-textarea {
  width: 100%;
  padding: 12px 12px 32px 12px;
  border: 1px solid #e5e7eb;
  border-radius: 6px;
  font-size: 14px;
  font-family: inherit;
  resize: none;
  line-height: 1.5;
}

.comment-textarea:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.char-count {
  position: absolute;
  bottom: 8px;
  right: 12px;
  font-size: 12px;
  color: #999;
}

/* 媒体上传 */
.media-upload {
  display: flex;
  gap: 16px;
  margin-bottom: 12px;
}

.upload-btn {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 32px 16px;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  background-color: white;
  cursor: pointer;
  font-size: 14px;
  color: #666;
  transition: all 0.2s;
}

.upload-btn:hover {
  border-color: #3b82f6;
  color: #3b82f6;
  background-color: #f0f9ff;
}

.camera-icon {
  font-size: 32px;
  margin-bottom: 8px;
}

/* 图片预览 */
.image-preview {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 12px;
}

.preview-item {
  position: relative;
  width: 80px;
  height: 80px;
  border-radius: 6px;
  overflow: hidden;
  background: white;
}

.preview-item img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.delete-btn {
  position: absolute;
  top: 2px;
  right: 2px;
  width: 20px;
  height: 20px;
  background-color: rgba(0, 0, 0, 0.5);
  color: white;
  border: none;
  border-radius: 50%;
  font-size: 16px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0;
  transition: background-color 0.2s;
}

.delete-btn:hover {
  background-color: rgba(0, 0, 0, 0.7);
}

/* 加载状态 */
.empty {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 200px;
  color: #999;
}

/* 底部按钮 */
.review-footer {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 12px 16px;
  background-color: white;
  border-top: 1px solid #e5e7eb;
  width: 100%;
}

.submit-btn {
  width: 100%;
  padding: 12px;
  background-color: #d1d5db;
  color: #666;
  border: none;
  border-radius: 6px;
  font-size: 16px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.submit-btn:not(.disabled):hover {
  background-color: #3b82f6;
  color: white;
}

.submit-btn.disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* 已有评价内容 */
.existing-review {
  background-color: #f9fafb;
  padding: 12px;
  border-radius: 8px;
  margin-top: 16px;
}

.review-content {
  margin-bottom: 8px;
}

.review-rating {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
}

.review-rating span {
  color: #374151;
  font-size: 14px;
  font-weight: 500;
  white-space: nowrap;
}

.review-text {
  color: #333;
  font-size: 14px;
  line-height: 1.5;
}

/* 审核状态 pill */
.review-status-row {
  margin-bottom: 8px;
}

.review-pill {
  display: inline-block;
  padding: 4px 10px;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 600;
  color: #fff;
}

.review-pill.pending { background-color: #f0ad4e; }    /* 审核中 - 橙 */
.review-pill.approved { background-color: #2ecc71; }   /* 通过 - 绿 */
.review-pill.rejected { background-color: #e74c3c; }   /* 拒绝 - 红 */

.reject-reason {
  margin-top: 12px;
  background: #fff5f5;
  border-radius: 6px;
  padding: 10px;
  color: #8b1c1c;
  border: 1px solid #f4c7c7;
}

.reviewing-hint {
  margin-top: 8px;
  color: #777;
  font-size: 13px;
}
</style>
