<template>
  <div class="comment-management">
    <div class="page-header">
      <h2>评论管理</h2>
      <div class="actions">
        <input
          type="text"
          v-model="searchKeyword"
          placeholder="搜索用户/商家/评论内容"
          class="search-input"
        >
        <select v-model="filterRating" class="filter-select">
          <option value="all">全部评分</option>
          <option value="5">5星</option>
          <option value="4">4星</option>
          <option value="3">3星</option>
          <option value="2">2星</option>
          <option value="1">1星</option>
        </select>
        <select v-model="filterStatus" class="filter-select">
          <option value="all">全部状态</option>
          <option value="normal">正常</option>
          <option value="hidden">已隐藏</option>
          <option value="deleted">已删除</option>
        </select>
        <button class="btn" @click="loadComments">搜索</button>
      </div>
    </div>

    <!-- 统计卡片 -->
    <div class="stats-cards">
      <div class="card">
        <h3>总评论数</h3>
        <div class="stat-number">{{ stats.totalComments }}</div>
      </div>
      <div class="card">
        <h3>平均评分</h3>
        <div class="stat-number">{{ stats.averageRating }}/5</div>
      </div>
      <div class="card">
        <h3>今日新增</h3>
        <div class="stat-number">{{ stats.todayNew }}</div>
      </div>
    </div>

    <!-- 评论列表 -->
    <div class="card">
      <h3>评论列表</h3>
      <div class="table-container">
        <table class="table">
        <thead>
          <tr>
            <th>评论ID</th>
            <th>用户</th>
            <th>商家</th>
            <th>评分</th>
            <th>评论内容</th>
            <th>评论时间</th>
            <th>审核</th> <!-- 新：显示审核状态 -->
            <th>状态</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="comment in filteredComments" :key="comment.id">
            <td>{{ comment.id }}</td>
            <td>{{ comment.username }}</td>
            <td>{{ comment.merchantName }}</td>
            <td>
              <div class="rating-display">
                <span class="rating-stars">{{ getStarRating(comment.rating) }}</span>
                <span class="rating-number">({{ comment.rating }}/5)</span>
              </div>
            </td>
            <td>
              <div class="comment-content">
                <p class="content-text">{{ comment.content }}</p>
                <div v-if="comment.images && comment.images.length" class="comment-images">
                  <img
                    v-for="(img, index) in comment.images.slice(0, 3)"
                    :key="index"
                    :src="img"
                    alt="评论图片"
                    class="thumbnail"
                  >
                  <span v-if="comment.images.length > 3" class="more-images">
                    +{{ comment.images.length - 3 }}
                  </span>
                </div>
              </div>
            </td>
            <td>{{ formatDate(comment.createTime) }}</td>

            <!-- 审核状态列 -->
            <td>
              <span :class="['review-pill', comment.review_status]">
                {{ getReviewStatusText(comment.review_status) }}
              </span>
              <div v-if="comment.review_status !== 'pending' && comment.reviewerName" class="review-meta">
                <small class="muted">by {{ comment.reviewerName }} · {{ comment.reviewedAt ? formatDate(comment.reviewedAt) : '' }}</small>
              </div>
            </td>

            <td>
              <span :class="['status-badge', comment.status]">
                {{ getStatusText(comment.status) }}
              </span>
            </td>

            <td>
              <div class="action-buttons">
                <!-- 审核操作：pending 时显示通过/拒绝 -->
                <button
                  v-if="comment.review_status === 'pending'"
                  class="btn-approve"
                  @click="approveReview(comment)"
                >
                  通过
                </button>
                <button
                  v-if="comment.review_status === 'pending'"
                  class="btn-reject"
                  @click="openRejectDialog(comment)"
                >
                  拒绝
                </button>

                <!-- 隐藏/显示：只有审核通过的评论才可隐藏或恢复 -->
                <button
                  v-if="comment.status === 'normal' && comment.review_status === 'approved'"
                  class="btn-outline"
                  @click="hideComment(comment)"
                >
                  隐藏
                </button>
                <button
                  v-if="comment.status === 'hidden' && comment.review_status === 'approved'"
                  class="btn"
                  @click="showComment(comment)"
                >
                  显示
                </button>
                  <button
                  class="btn-outline"
                  @click="viewCommentDetails(comment)"
                >
                  详情
                </button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
      </div>
    </div>

  
    <!-- 评论详情弹窗 -->
    <div v-if="showDetailsModal" class="modal-overlay" @click="closeDetailsModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>评论详情 - {{ selectedComment?.id }}</h3>
          <button class="close-btn" @click="closeDetailsModal">&times;</button>
        </div>
        <div class="modal-body">
          <div class="detail-grid">
            <div class="detail-item">
              <label>评论ID:</label>
              <span>{{ selectedComment?.id }}</span>
            </div>
            <div class="detail-item">
              <label>用户:</label>
              <span>{{ selectedComment?.username }}</span>
            </div>
            <div class="detail-item">
              <label>商家:</label>
              <span>{{ selectedComment?.merchantName }}</span>
            </div>
            <div class="detail-item">
              <label>评分:</label>
              <span>{{ getStarRating(selectedComment?.rating) }}</span>
            </div>
            <div class="detail-item">
              <label>评论时间:</label>
              <span>{{ formatDate(selectedComment?.createTime) }}</span>
            </div>
            <div class="detail-item">
              <label>状态:</label>
              <span :class="['status-badge', selectedComment?.status]">
                {{ getStatusText(selectedComment?.status) }}
              </span>
            </div>
            <div class="detail-item full-width">
              <label>评论内容:</label>
              <p class="comment-text">{{ selectedComment?.content }}</p>
            </div>
            <div v-if="selectedComment?.images?.length" class="detail-item full-width">
              <label>评论图片:</label>
              <div class="image-gallery">
                <img
                  v-for="(img, index) in selectedComment.images"
                  :key="index"
                  :src="img"
                  alt="评论图片"
                  class="gallery-image"
                >
              </div>
            </div>
            <div v-if="selectedComment?.replies?.length" class="detail-item full-width">
              <label>商家回复:</label>
              <div class="replies">
                <div v-for="(reply, index) in selectedComment.replies" :key="index" class="reply-item">
                  <div class="reply-time">{{ formatDate(reply.time) }}</div>
                  <div class="reply-content">{{ reply.content }}</div>
                </div>
              </div>
            </div>

            <!-- 新增：显示驳回理由 -->
            <div v-if="selectedComment?.review_status === 'rejected'" class="detail-item full-width">
              <label>驳回理由:</label>
              <p>{{ selectedComment?.review_reject_reason || '无' }}</p>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn-secondary" @click="closeDetailsModal">关闭</button>
        </div>
      </div>
    </div>

    <!-- 驳回理由弹窗 -->
    <div v-if="showRejectModal" class="modal-overlay" @click="closeRejectDialog">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>拒绝评论 - {{ selectedComment?.id }}</h3>
          <button class="close-btn" @click="closeRejectDialog">&times;</button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label>请输入驳回理由（必填）</label>
            <textarea v-model="rejectReason" class="form-control" rows="4" placeholder="说明驳回原因，用户可见"></textarea>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn-secondary" @click="closeRejectDialog">取消</button>
          <button class="btn-reject" @click="confirmRejectReview">确认驳回</button>
        </div>
      </div>
    </div>

    <!-- 自动审核关键词 -->
    <div class="card">
      <h3>自动审核关键词</h3>
      <div class="keyword-controls">
        <input v-model="newKeyword" class="search-input" placeholder="输入关键词, 回车或点击添加" @keyup.enter="addKeyword" />
        <button class="btn" @click="addKeyword">添加</button>
      </div>
      <div class="keywords-list">
        <span class="keyword-pill" v-for="kw in keywords" :key="kw.id">
          {{ kw.keyword }}
          <button class="del-btn" @click="removeKeyword(kw)">删除</button>
        </span>
      </div>
      <p class="hint">添加后，顾客提交包含该关键词的评价将被自动拒绝。</p>
    </div>
  </div>
</template>

<script>
import { getAdminReviews, getAdminReviewStats, getReviewKeywords, addReviewKeyword, deleteReviewKeyword, updateReview } from '@/api/admin'

export default {
  name: 'CommentManagement',
  data() {
    return {
      searchKeyword: '',
      filterRating: 'all',
      filterStatus: 'all',
      showDetailsModal: false,
      showRejectModal: false,
      rejectReason: '',

      // 必填初始值：防止模板或 computed 报错导致空白
      comments: [],               // 评论列表
      stats: {                    // 统计卡片
        totalComments: 0,
        averageRating: 0,
        todayNew: 0
      },
      selectedComment: null,      // 当前选中评论（查看/驳回）
      keywords: [],
      newKeyword: ''
    }
  },
  mounted(){
    this.loadComments()
    this.fetchStats()
    this.fetchKeywords()
  },
  computed: {
    filteredComments() {
      return this.comments.filter(comment => {
        let matchesSearch = true
        let matchesRating = true
        let matchesStatus = true

        if (this.searchKeyword) {
          matchesSearch = comment.username.includes(this.searchKeyword) ||
                         comment.merchantName.includes(this.searchKeyword) ||
                         comment.content.includes(this.searchKeyword)
        }

        if (this.filterRating !== 'all') {
          matchesRating = comment.rating === parseInt(this.filterRating)
        }

        if (this.filterStatus !== 'all') {
          matchesStatus = comment.status === this.filterStatus
        }

        return matchesSearch && matchesRating && matchesStatus
      })
    }
  },
  methods: {
    loadComments() {
      // 从后端加载评论（管理员）
      this.fetchComments()
    },

    async fetchComments(){
      try{
        const resp = await getAdminReviews()
        if (resp.data.success && resp.data.data && resp.data.data.reviews) {
          // 包含 review_status/reviewer_name/reviewed_at
          this.comments = resp.data.data.reviews.map(r => ({
            id: r.id,
            username: r.username || `用户${r.user_id}`,
            merchantName: '',
            rating: r.rating,
            content: r.content,
            images: r.images || [],
            createTime: r.created_at,
            status: r.status,
            replies: r.merchant_reply ? [{ time: r.merchant_reply_time, content: r.merchant_reply }] : [],
            // 审核字段
            review_status: r.review_status || 'pending',
            reviewerName: r.reviewer_name || '',
            reviewedAt: r.reviewed_at || null
          }))
        }
      }catch(e){console.error('加载管理员评论失败', e)}
    },

    async fetchStats() {
      try {
        const resp = await getAdminReviewStats()
        if (resp.data.success && resp.data.data) {
          this.stats.totalComments = resp.data.data.total_reviews || 0
          this.stats.averageRating = resp.data.data.average_rating || 0
          this.stats.todayNew = resp.data.data.today_new || 0
        }
      } catch (e) {
        console.error('加载评论统计失败', e)
      }
    },

    async fetchKeywords(){
      try {
        const resp = await getReviewKeywords()
        if (resp.data.success && resp.data.data) {
          this.keywords = resp.data.data.keywords || []
        }
      } catch (e) {
        console.error('加载关键词失败', e)
      }
    },

    async addKeyword() {
      const kw = (this.newKeyword || '').trim()
      if (!kw) return alert('请输入关键词')
      try {
        const resp = await addReviewKeyword(kw)
        if (!resp.data.success) throw new Error(resp.data.message || '添加失败')
        this.keywords.unshift(resp.data.data)
        this.newKeyword = ''
        alert('添加成功')
      } catch (err) {
        console.error('添加关键词失败', err)
        alert(err.response?.data?.message || err.message || '添加失败')
      }
    },

    async removeKeyword(kw) {
      if (!confirm(`确认删除关键词 "${kw.keyword}" ?`)) return
      try {
        const resp = await deleteReviewKeyword(kw.id)
        if (!resp.data.success) throw new Error(resp.data.message || '删除失败')
        this.keywords = this.keywords.filter(k => k.id !== kw.id)
        alert('删除成功')
      } catch (err) {
        console.error('删除关键词失败', err)
        alert(err.response?.data?.message || err.message || '删除失败')
      }
    },

    // 管理端审批：通过
    async approveReview(comment) {
      if (!confirm('确认通过该评论，让其在店铺/商家端显示？')) return
      try {
        const resp = await updateReview(comment.id, { review_status: 'approved' })
        if (!resp.data.success) throw new Error(resp.data.message || '审核失败')
        comment.review_status = resp.data.data.review_status
        comment.reviewerName = resp.data.data.reviewer_name
        comment.reviewedAt = resp.data.data.reviewed_at
        alert('已通过该评论')
      } catch (err) {
        console.error('通过评论失败', err)
        alert(err.response?.data?.message || err.message || '操作失败')
      }
    },

    // 管理端审批：拒绝
    openRejectDialog(comment) {
      this.selectedComment = comment
      this.rejectReason = comment.review_reject_reason || ''
      this.showRejectModal = true
    },

    closeRejectDialog() {
      this.showRejectModal = false
      this.rejectReason = ''
      this.selectedComment = null
    },

    async confirmRejectReview() {
      if (!this.rejectReason.trim()) {
        alert('请填写驳回理由')
        return
      }
      if (!this.selectedComment) return

      if (!confirm('确认要驳回此评论吗？')) return
      try {
        const resp = await updateReview(this.selectedComment.id, {
          review_status: 'rejected',
          review_reject_reason: this.rejectReason.trim()
        })
        if (!resp.data.success) throw new Error(resp.data.message || '驳回失败')
        // 更新本地数据源
        this.selectedComment.review_status = resp.data.data.review_status
        this.selectedComment.reviewerName = resp.data.data.reviewer_name
        this.selectedComment.reviewedAt = resp.data.data.reviewed_at
        this.selectedComment.review_reject_reason = resp.data.data.review_reject_reason
        alert('已拒绝该评论')
      } catch (err) {
        console.error('驳回评论失败', err)
        alert(err.response?.data?.message || err.message || '操作失败')
      } finally {
        this.closeRejectDialog()
      }
    },

    async hideComment(comment) {
      if (comment.review_status !== 'approved') {
        alert('仅可对已通过审核的评论进行隐藏')
        return
      }
      if (!confirm(`确定要隐藏评论 ${comment.id} 吗？`)) return
      try {
        const resp = await updateReview(comment.id, { status: 'hidden' })
        if (!resp.data.success) throw new Error(resp.data.message || '操作失败')
        comment.status = 'hidden'
        alert('评论已隐藏')
      } catch (err) {
        console.error('隐藏评论失败', err)
        alert(err.response?.data?.message || err.message || '隐藏失败')
      }
    },

    async showComment(comment) {
      if (comment.review_status !== 'approved') {
        alert('仅可对已通过审核的评论进行恢复显示')
        return
      }
      try {
        const resp = await updateReview(comment.id, { status: 'normal' })
        if (!resp.data.success) throw new Error(resp.data.message || '操作失败')
        comment.status = 'normal'
        alert('评论已恢复显示')
      } catch (err) {
        console.error('恢复评论失败', err)
        alert(err.response?.data?.message || err.message || '恢复失败')
      }
    },
    viewCommentDetails(comment) {
      this.selectedComment = comment
      this.showDetailsModal = true
    },
        closeDetailsModal() {
      this.showDetailsModal = false
      this.selectedComment = null
    },
    closeRejectDialog() {
      this.showRejectModal = false
      this.selectedComment = null
      this.rejectReason = ''
    },
        confirmRejectReview() {
      if (!this.rejectReason) {
        return alert('请填写驳回理由')
      }
      // 提交驳回理由并执行驳回操作
      this.rejectReview(this.selectedComment, this.rejectReason)
    },
    async rejectReview(comment, reason) {
      try {
        const resp = await updateReview(comment.id, { review_status: 'rejected', review_reject_reason: reason })
        if (!resp.data.success) throw new Error(resp.data.message || '驳回失败')
        comment.review_status = 'rejected'
        comment.reviewerName = resp.data.data.reviewer_name || comment.reviewerName
        comment.reviewedAt = resp.data.data.reviewed_at || comment.reviewedAt
        comment.review_reject_reason = resp.data.data.review_reject_reason || reason
        alert('评论已被驳回')
        this.closeRejectDialog()
      } catch (err) {
        console.error('驳回评论失败', err)
        alert(err.response?.data?.message || err.message || '操作失败')
      }
    },
    getStarRating(rating) {
      return '⭐'.repeat(rating)
    },
    getStatusText(status) {
      const statusMap = {
        normal: '正常',
        hidden: '已隐藏',
        deleted: '已删除'
      }
      return statusMap[status] || status
    },

    // 新：把 review_status 转成友好文案
    getReviewStatusText(rs) {
      const map = {
        pending: '待审核',
        approved: '已通过',
        rejected: '已拒绝'
      }
      return map[rs] || (rs ? rs : '未知')
    },

        formatDate(dateString) {
      return new Date(dateString).toLocaleString('zh-CN')
    }
  }
}
</script>

<style scoped>
/* 响应式字体和根容器 */
.comment-management {
  font-size: clamp(12px, 1.2vw, 16px);
  line-height: 1.5;
  padding: clamp(10px, 1.5vw, 20px);
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: clamp(15px, 2vw, 20px);
  flex-wrap: wrap;
  gap: clamp(10px, 1.5vw, 15px);
}

.page-header h2 {
  font-size: clamp(20px, 2.5vw, 24px);
  margin: 0;
}

.actions {
  display: flex;
  gap: clamp(8px, 1vw, 10px);
  align-items: center;
  flex-wrap: wrap;
}

.search-input {
  padding: clamp(6px, 0.8vw, 8px) clamp(10px, 1.2vw, 12px);
  border: 1px solid var(--color-border-200);
  border-radius: 4px;
  width: clamp(200px, 30vw, 250px);
  font-size: clamp(12px, 1.2vw, 14px);
}

.filter-select {
  padding: clamp(6px, 0.8vw, 8px) clamp(10px, 1.2vw, 12px);
  border: 1px solid var(--color-border-200);
  border-radius: 4px;
  background: var(--color-surface);
  font-size: clamp(12px, 1.2vw, 14px);
  min-width: 100px;
}

.stats-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
  gap: clamp(15px, 2vw, 20px);
  margin-bottom: clamp(15px, 2vw, 20px);
}

.stats-cards .card {
  text-align: center;
  padding: clamp(15px, 2vw, 20px);
  border-radius: 8px;
  background: var(--color-surface);
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.stats-cards .card h3 {
  font-size: clamp(14px, 1.5vw, 16px);
  margin: 0 0 10px 0;
  color: var(--color-text-600);
}

.stat-number {
  font-size: clamp(24px, 3vw, 32px);
  font-weight: bold;
  color: var(--color-brand-500);
  margin-top: 10px;
}

.stat-number.warning {
  color: var(--color-warning-500);
}

/* 评分显示响应式 */
.rating-display {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 2px;
}

.rating-stars {
  font-size: clamp(14px, 1.8vw, 18px);
  line-height: 1.2;
}

.rating-number {
  font-size: clamp(10px, 1.2vw, 12px);
  color: var(--color-text-600);
}

.comment-content {
  max-width: clamp(200px, 30vw, 300px);
  min-width: 150px;
}

.content-text {
  margin: 0 0 8px 0;
  line-height: 1.4;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.comment-images {
  display: flex;
  gap: 4px;
  align-items: center;
}

.thumbnail {
  width: 40px;
  height: 40px;
  object-fit: cover;
  border-radius: 4px;
}

.more-images {
  font-size: 12px;
  color: var(--color-text-600);
  margin-left: 4px;
}

.status-badge {
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 600;
}

.status-badge.normal {
  background-color: var(--color-success-50);
  color: var(--color-success-700);
}

.status-badge.hidden {
  background-color: var(--color-warning-50);
  color: var(--color-warning-700);
}

.status-badge.reported {
  background-color: var(--color-danger-50);
  color: var(--color-danger-700);
}

.status-badge.deleted {
  background-color: var(--color-neutral-200);
  color: var(--color-text-600);
}




.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background: var(--color-surface);
  border-radius: 8px;
  max-width: 800px;
  width: 90%;
  max-height: 80vh;
  overflow-y: auto;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid var(--color-border-200);
}

.close-btn {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  color: var(--color-text-600);
}

.modal-body {
  padding: 20px;
}


.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  font-weight: 600;
  color: var(--color-text-700);
}

.form-control {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid var(--color-border-200);
  border-radius: 4px;
  font-size: 14px;
}

.form-control:focus {
  outline: none;
  border-color: var(--color-brand-500);
  box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
}

.detail-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}

.detail-item {
  display: flex;
  flex-direction: column;
}

.detail-item.full-width {
  grid-column: 1 / -1;
}

.detail-item label {
  font-weight: 600;
  color: var(--color-text-600);
  margin-bottom: 5px;
}

.detail-item span {
  color: var(--color-text-700);
}

.comment-text {
  background: var(--color-neutral-50);
  padding: 15px;
  border-radius: 6px;
  line-height: 1.6;
  margin: 0;
}

.image-gallery {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.gallery-image {
  width: 120px;
  height: 120px;
  object-fit: cover;
  border-radius: 8px;
  cursor: pointer;
  transition: transform 0.2s;
}

.gallery-image:hover {
  transform: scale(1.05);
}

.replies {
  border-left: 3px solid var(--color-brand-500);
  padding-left: 15px;
}

.reply-item {
  margin-bottom: 15px;
}

.reply-time {
  font-size: 13px;
  color: var(--color-text-600);
  margin-bottom: 5px;
}

.reply-content {
  color: var(--color-text-700);
  line-height: 1.5;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 20px;
  border-top: 1px solid var(--color-border-200);
}



/* 审核状态颜色 */
.review-pill.pending { background: #f0ad4e; }
.review-pill.pending { background: var(--color-warning-500); }
.review-pill.approved { background: var(--color-success-500); }
.review-pill.rejected { background: var(--color-danger-500); }

.review-meta {
  margin-top: clamp(4px, 0.6vw, 6px);
  font-size: clamp(10px, 1.1vw, 12px);
  color: var(--color-text-600);
}

.keyword-controls {
  display: flex;
  gap: clamp(8px, 1vw, 10px);
  align-items: center;
  margin-bottom: clamp(8px, 1vw, 10px);
}
.keywords-list {
  margin-top: clamp(6px, 0.8vw, 8px);
  display: flex;
  gap: clamp(6px, 0.8vw, 8px);
  flex-wrap: wrap;
}
.keyword-pill {
  background: #f3f4f6;
  padding: clamp(4px, 0.6vw, 6px) clamp(8px, 1vw, 10px);
  border-radius: 16px;
  display: flex;
  gap: clamp(6px, 0.8vw, 8px);
  align-items: center;
  font-size: clamp(12px, 1.2vw, 14px);
}
.keyword-pill .del-btn {
  background: transparent;
  border: none;
  color: #c0392b;
  cursor: pointer;
  padding: 0 6px;
  font-size: clamp(11px, 1.2vw, 13px);
}
.hint {
  margin-top: clamp(6px, 0.8vw, 8px);
  color: var(--color-text-600);
  font-size: clamp(11px, 1.2vw, 13px);
}

/* 添加表格容器的样式 */
.table-container {
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
  scrollbar-width: thin;
  scrollbar-color: var(--color-border-200) transparent;
  margin: -20px;
  padding: 20px;
}

.table-container::-webkit-scrollbar {
  height: 8px;
}

.table-container::-webkit-scrollbar-track {
  background: var(--color-neutral-100);
}

.table-container::-webkit-scrollbar-thumb {
  background: var(--color-border-200);
  border-radius: 4px;
}

.table {
  width: 100%;
  min-width: 1200px; /* 设置最小宽度确保内容不会过度压缩 */
  border-collapse: collapse;
}

.table th,
.table td {
  padding: clamp(8px, 1vw, 12px);
  text-align: left;
  border-bottom: 1px solid var(--color-border-200);
  font-size: clamp(11px, 1.2vw, 14px);
  white-space: nowrap; /* 防止文字换行 */
}

.table th {
  background-color: var(--color-neutral-50);
  font-weight: 600;
  color: var(--color-text-700);
  position: sticky;
  top: 0;
  z-index: 10;
}

.table tbody tr:hover {
  background-color: var(--color-neutral-50);
}

/* 操作按钮容器 */
.action-buttons {
  display: flex;
  gap: clamp(4px, 0.6vw, 6px);
  flex-wrap: wrap;
  align-items: center;
  min-width: 200px;
}

/* 按钮基础样式 */
.btn {
  padding: clamp(4px, 0.6vw, 6px) clamp(8px, 1vw, 12px);
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: clamp(10px, 1.2vw, 12px);
  transition: all 0.2s;
  white-space: nowrap;
  display: inline-block;
  text-decoration: none;
  text-align: center;
  line-height: 1.4;
}

.btn-primary {
  background-color: var(--color-brand-500);
  color: white;
}

.btn-primary:hover {
  background-color: var(--color-brand-600);
}

.btn-secondary {
  background-color: var(--color-text-500);
  color: white;
}

.btn-secondary:hover {
  background-color: var(--color-text-600);
}

.btn-outline {
  background-color: transparent;
  border: 1px solid var(--color-brand-500);
  color: var(--color-brand-500);
}

.btn-outline:hover {
  background-color: var(--color-brand-500);
  color: white;
}

/* 小型通过拒绝按钮 */
.btn-approve, .btn-reject {
  padding: clamp(3px, 0.5vw, 5px) clamp(6px, 0.8vw, 10px);
  font-size: clamp(9px, 1.1vw, 11px);
  border-radius: 4px;
  border: none;
  cursor: pointer;
  white-space: nowrap;
  flex-shrink: 0;
}

.btn-approve {
  background: var(--color-success-500);
  color: #fff;
}

.btn-reject {
  background: var(--color-danger-500);
  color: #fff;
}

.btn-approve:hover,
.btn-reject:hover {
  opacity: 0.9;
}

/* 卡片样式 */
.card {
  background: var(--color-surface);
  border-radius: 8px;
  padding: clamp(15px, 2vw, 20px);
  margin-bottom: clamp(15px, 2vw, 20px);
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.card h3 {
  margin-top: 0;
  margin-bottom: clamp(15px, 2vw, 20px);
  color: var(--color-text-700);
  font-size: clamp(16px, 2vw, 18px);
}

/* 状态标签响应式 */
.status-badge, .review-pill {
  padding: clamp(2px, 0.3vw, 4px) clamp(6px, 0.8vw, 10px);
  border-radius: 12px;
  font-size: clamp(9px, 1.1vw, 12px);
  font-weight: 600;
  display: inline-block;
  white-space: nowrap;
}

.review-pill {
  min-width: clamp(60px, 8vw, 70px);
  text-align: center;
}


/* 模态框响应式 */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: clamp(10px, 2vw, 20px);
}

.modal-content {
  background: var(--color-surface);
  border-radius: 8px;
  max-width: min(800px, 95vw);
  width: 100%;
  max-height: min(80vh, 800px);
  overflow-y: auto;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: clamp(15px, 2vw, 20px);
  border-bottom: 1px solid var(--color-border-200);
}

.modal-header h3 {
  margin: 0;
  font-size: clamp(16px, 2vw, 20px);
}

.close-btn {
  background: none;
  border: none;
  font-size: clamp(20px, 2.5vw, 24px);
  cursor: pointer;
  color: var(--color-text-600);
  padding: 0;
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal-body {
  padding: clamp(15px, 2vw, 20px);
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: clamp(8px, 1vw, 10px);
  padding: clamp(15px, 2vw, 20px);
  border-top: 1px solid var(--color-border-200);
}

/* 表单控件响应式 */
.form-control {
  width: 100%;
  padding: clamp(6px, 0.8vw, 8px) clamp(10px, 1.2vw, 12px);
  border: 1px solid var(--color-border-200);
  border-radius: 4px;
  font-size: clamp(12px, 1.2vw, 14px);
}

.form-group {
  margin-bottom: clamp(15px, 2vw, 20px);
}

.form-group label {
  display: block;
  margin-bottom: clamp(5px, 0.8vw, 8px);
  font-weight: 600;
  color: var(--color-text-700);
  font-size: clamp(12px, 1.2vw, 14px);
}

/* 详情网格响应式 */
.detail-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: clamp(15px, 2vw, 20px);
}

.detail-item {
  display: flex;
  flex-direction: column;
}

.detail-item.full-width {
  grid-column: 1 / -1;
}

.detail-item label {
  font-weight: 600;
  color: var(--color-text-600);
  margin-bottom: 5px;
  font-size: clamp(12px, 1.2vw, 14px);
}

.detail-item span {
  color: var(--color-text-700);
  font-size: clamp(12px, 1.2vw, 14px);
}

/* 媒体查询：小屏幕额外优化 */
@media (max-width: 768px) {
  .page-header {
    flex-direction: column;
    align-items: stretch;
  }

  .actions {
    justify-content: center;
  }

  .search-input {
    width: 100%;
    max-width: 300px;
  }

  .stats-cards {
    grid-template-columns: 1fr;
  }

  .action-buttons {
    flex-direction: column;
    align-items: stretch;
    min-width: auto;
  }

  .action-buttons .btn {
    width: 100%;
    text-align: center;
  }

  .btn-approve, .btn-reject {
    display: inline-block;
    width: auto;
  }

  .table-container {
    margin: -10px;
    padding: 10px;
  }
}

@media (max-width: 480px) {
  .comment-management {
    padding: 10px;
  }

  .modal-content {
    max-width: 100%;
    max-height: 100vh;
    border-radius: 0;
  }

  .modal-overlay {
    padding: 0;
  }
}
</style>