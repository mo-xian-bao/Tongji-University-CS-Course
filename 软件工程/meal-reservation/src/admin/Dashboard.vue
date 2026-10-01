<template>
  <div class="admin-dashboard">
    <h2>管理员仪表盘</h2>

    <!-- 统计概览 -->
    <div class="stats-overview">
      <div class="stats-cards">
        <div class="card">
          <h3>待处理事项</h3>
          <div class="stat-number warning">{{ stats.pendingItems }}</div>
          <div class="stat-detail">
            <span>店铺申请: {{ stats.pendingApplications }}</span>
            <span>用户申诉: {{ stats.pendingAppeals }}</span>
            <span>待审核评论: {{ stats.pendingReviews }}</span>
          </div>
        </div>
        <div class="card">
          <h3>注册用户数</h3>
          <div class="stat-number">{{ stats.totalUsers.toLocaleString() }}</div>
          <div class="stat-detail">
            <span>总用户数</span>
          </div>
        </div>
        <div class="card">
          <h3>评论总数</h3>
          <div class="stat-number">{{ stats.totalReviews.toLocaleString() }}</div>
          <div class="stat-detail">
            <span>总评论数</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 快捷操作 -->
    <div class="quick-actions">
      <div class="card">
        <h3>快捷操作</h3>
        <div class="action-buttons">
          <router-link to="/admin/store-applications" class="action-btn">
            <div class="action-icon">📋</div>
            <span>处理店铺申请</span>
            <span class="badge" v-if="stats.pendingApplications > 0">{{ stats.pendingApplications }}</span>
          </router-link>
          <router-link to="/admin/appeal-handling" class="action-btn">
            <div class="action-icon">⚖️</div>
            <span>处理用户申诉</span>
            <span class="badge" v-if="stats.pendingAppeals > 0">{{ stats.pendingAppeals }}</span>
          </router-link>
          <router-link to="/admin/comment-management" class="action-btn">
            <div class="action-icon">💬</div>
            <span>管理评论</span>
            <span class="badge" v-if="stats.pendingReviews > 0">{{ stats.pendingReviews }}</span>
          </router-link>
          <router-link to="/admin/account-ban" class="action-btn">
            <div class="action-icon">🚫</div>
            <span>账号管理</span>
          </router-link>
        </div>
      </div>
    </div>

    </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'AdminDashboard',
  data() {
    return {
      stats: {
        pendingItems: 0,
        pendingApplications: 0,
        pendingAppeals: 0,
        pendingReviews: 0,
        pendingReports: 0,
        totalUsers: 0,
        totalMerchants: 0,
        weeklyNewMerchants: 0,
        todayActive: 0,
        onlineUsers: 0,
        totalOrders: 0,
        orderGrowth: 0,
        totalReviews: 0,
        reviewGrowth: 0,
        averageRating: 0,
        complaintRate: 0
      }
    }
  },
  mounted() {
    this.loadDashboardStats()
  },
  methods: {
    async loadDashboardStats() {
      try {
        const token = localStorage.getItem('token')

        // 并行加载所有统计数据
        const [appealsRes, reviewsRes, banStatsRes, applicationsRes] = await Promise.all([
          axios.get('/admin/appeals/stats', {
            headers: { 'Authorization': `Bearer ${token}` }
          }),
          axios.get('/admin/reviews/stats', {
            headers: { 'Authorization': `Bearer ${token}` }
          }),
          axios.get('/admin/users/ban/stats', {
            headers: { 'Authorization': `Bearer ${token}` }
          }),
          axios.get('/admin/merchant-applications', {
            headers: { 'Authorization': `Bearer ${token}` },
            params: { status: 'pending', page: 1, per_page: 1 }
          })
        ])

        // 更新申诉统计数据
        if (appealsRes.data.success) {
          const appealsData = appealsRes.data.data
          this.stats.pendingAppeals = appealsData.pendingAppeals
        }

        // 更新评论统计数据
        if (reviewsRes.data.success) {
          const reviewsData = reviewsRes.data.data
          this.stats.totalReviews = reviewsData.total_reviews
          this.stats.averageRating = reviewsData.average_rating
          this.stats.reviewGrowth = reviewsData.today_new
          this.stats.pendingReviews = reviewsData.pending_reviews || 0
        }

        // 更新用户封禁统计数据
        if (banStatsRes.data.success) {
          const banData = banStatsRes.data.data
          this.stats.totalUsers = banData.totalUsers
        }

        // 更新商户申请统计数据
        if (applicationsRes.data.success) {
          this.stats.pendingApplications = applicationsRes.data.data.pagination.total
        }

        // 计算待处理事项总数
        this.stats.pendingItems = this.stats.pendingApplications + this.stats.pendingAppeals + this.stats.pendingReviews

      } catch (error) {
        console.error('加载仪表盘数据失败:', error)
      }
    }
  }
}
</script>

<style scoped>
.admin-dashboard h2 {
  margin-bottom: 30px;
  color: var(--color-text-700);
  font-weight: 600;
}

.stats-overview {
  margin-bottom: 30px;
}

.stats-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
}

.stats-cards .card {
  text-align: center;
  padding: 25px;
}

.stat-number {
  font-size: 36px;
  font-weight: bold;
  color: var(--color-brand-500);
  margin: 15px 0;
}

.stat-number.warning {
  color: var(--color-warning-500);
}

.stat-detail {
  display: flex;
  flex-direction: column;
  gap: 5px;
  font-size: 14px;
  color: var(--color-text-600);
}

.quick-actions {
  margin-bottom: 30px;
}

.action-buttons {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 15px;
}

.action-btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
  background: var(--color-neutral-50);
  border-radius: 8px;
  text-decoration: none;
  color: var(--color-text-700);
  transition: all 0.3s;
  position: relative;
  border: 1px solid transparent;
}

.action-btn:hover {
  background: var(--color-neutral-200);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  border-color: var(--color-brand-500);
}

.action-icon {
  font-size: 32px;
  margin-bottom: 10px;
}

.action-btn span {
  font-size: 14px;
  font-weight: 500;
}

.badge {
  position: absolute;
  top: 10px;
  right: 10px;
  background: var(--color-danger-500);
  color: white;
  border-radius: 12px;
  padding: 2px 8px;
  font-size: 12px;
  font-weight: 600;
}

@media (max-width: 768px) {
  .action-buttons {
    grid-template-columns: repeat(2, 1fr);
  }

  .stats-cards {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 480px) {
  .action-buttons {
    grid-template-columns: 1fr;
  }

  .stats-cards {
    grid-template-columns: 1fr;
  }
}
</style>