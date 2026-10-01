<template>
  <div class="store-applications">
    <div class="page-header">
      <h2>店铺申请管理</h2>
      <div class="filters">
        <select v-model="filterStatus" class="filter-select" @change="loadApplications">
          <option value="">全部状态</option>
          <option value="pending">待审核</option>
          <option value="approved">已通过</option>
          <option value="rejected">已拒绝</option>
        </select>
        <button class="btn" @click="loadApplications">刷新</button>
      </div>
    </div>

    <!-- 统计卡片 -->
    <div class="stats-cards">
      <div class="card">
        <h3>待审核申请</h3>
        <div class="stat-number">{{ stats.pending }}</div>
      </div>
      <div class="card">
        <h3>今日处理</h3>
        <div class="stat-number">{{ stats.todayProcessed }}</div>
      </div>
      <div class="card">
        <h3>本月通过</h3>
        <div class="stat-number">{{ stats.monthlyApproved }}</div>
      </div>
      <div class="card">
        <h3>本月拒绝</h3>
        <div class="stat-number">{{ stats.monthlyRejected }}</div>
      </div>
    </div>

    <!-- 申请列表 -->
    <div class="card">
      <h3>申请列表</h3>
      <div v-if="loading" class="loading">加载中...</div>
      <div v-else class="table-container">
        <table class="table">
        <thead>
          <tr>
            <th>申请ID</th>
            <th>店铺名称</th>
            <th>申请人</th>
            <th>联系电话</th>
            <th>店铺类型</th>
            <th>申请时间</th>
            <th>状态</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="application in applications" :key="application.id">
            <td>{{ application.id }}</td>
            <td>{{ application.shop_name }}</td>
            <td>{{ application.user_info?.username }}</td>
            <td>{{ application.phone }}</td>
            <td>{{ application.shop_type }}</td>
            <td>{{ formatDate(application.created_at) }}</td>
            <td>
              <span :class="['status-badge', application.review_status]">
                {{ getStatusText(application.review_status) }}
              </span>
            </td>
            <td>
              <button class="btn" @click="viewApplication(application)">
                查看详情
              </button>
            </td>
          </tr>
        </tbody>
      </table>
      </div>

      <!-- 分页 -->
      <div v-if="pagination.pages > 1" class="pagination">
        <button
          :disabled="pagination.page <= 1"
          @click="changePage(pagination.page - 1)"
          class="btn-outline"
        >
          上一页
        </button>
        <span class="page-info">
          第 {{ pagination.page }} 页，共 {{ pagination.pages }} 页
        </span>
        <button
          :disabled="pagination.page >= pagination.pages"
          @click="changePage(pagination.page + 1)"
          class="btn-outline"
        >
          下一页
        </button>
      </div>
    </div>

    <!-- 申请详情弹窗 -->
    <div v-if="selectedApplication" class="modal-overlay" @click="closeModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>申请详情</h3>
          <button class="close-btn" @click="closeModal">&times;</button>
        </div>
        <div class="modal-body">
          <div class="detail-grid">
            <div class="detail-item">
              <label>申请ID:</label>
              <span>{{ selectedApplication.id }}</span>
            </div>
            <div class="detail-item">
              <label>申请人:</label>
              <span>{{ selectedApplication.user_info?.username }}</span>
            </div>
            <div class="detail-item">
              <label>联系电话:</label>
              <span>{{ selectedApplication.user_info?.phone }}</span>
            </div>
            <div class="detail-item">
              <label>店铺名称:</label>
              <span>{{ selectedApplication.shop_name }}</span>
            </div>
            <div class="detail-item">
              <label>店铺类型:</label>
              <span>{{ selectedApplication.shop_type }}</span>
            </div>
            <div class="detail-item">
              <label>营业执照号:</label>
              <span>{{ selectedApplication.business_license }}</span>
            </div>
            <div class="detail-item full-width">
              <label>店铺地址:</label>
              <span>{{ selectedApplication.address }}</span>
            </div>
            <div class="detail-item full-width">
              <label>营业时间:</label>
              <span>{{ selectedApplication.business_hours }}</span>
            </div>
            <div class="detail-item full-width">
              <label>店铺描述:</label>
              <span>{{ selectedApplication.description || '暂无描述' }}</span>
            </div>

            <!-- 文件预览 -->
            <div class="detail-item full-width" v-if="selectedApplication.license_file_url">
              <label>营业执照文件:</label>
              <div class="file-preview">
                <!-- 显示缩略图，同时链接到后台完整地址 -->
                <a :href="fullFileUrl(selectedApplication.license_file_url)" target="_blank" class="file-link">
                  <img :src="fullFileUrl(selectedApplication.license_file_url)" alt="营业执照" class="preview-thumb" />
                </a>
              </div>
            </div>

            <div class="detail-item full-width" v-if="selectedApplication.id_file_url">
              <label>身份证文件:</label>
              <div class="file-preview">
                <a :href="fullFileUrl(selectedApplication.id_file_url)" target="_blank" class="file-link">
                  <img :src="fullFileUrl(selectedApplication.id_file_url)" alt="身份证" class="preview-thumb" />
                </a>
              </div>
            </div>

            <div class="detail-item">
              <label>申请时间:</label>
              <span>{{ formatDate(selectedApplication.created_at) }}</span>
            </div>

            <!-- 审核信息 -->
            <div class="detail-item" v-if="selectedApplication.reviewed_at">
              <label>审核时间:</label>
              <span>{{ formatDate(selectedApplication.reviewed_at) }}</span>
            </div>
            <div class="detail-item" v-if="selectedApplication.reviewer_name">
              <label>审核人:</label>
              <span>{{ selectedApplication.reviewer_name }}</span>
            </div>
            <div class="detail-item full-width" v-if="selectedApplication.review_note">
              <label>审核备注:</label>
              <span class="review-note">{{ selectedApplication.review_note }}</span>
            </div>
          </div>
        </div>
        <div class="modal-footer" v-if="selectedApplication.review_status === 'pending'">
          <button class="btn" @click="approveApplication" :disabled="processing">
            {{ processing ? '处理中...' : '通过申请' }}
          </button>
          <button class="btn-danger" @click="showRejectDialog" :disabled="processing">
            {{ processing ? '处理中...' : '拒绝申请' }}
          </button>
          <button class="btn-secondary" @click="closeModal">取消</button>
        </div>
        <div class="modal-footer" v-else>
          <button
            class="btn-danger"
            @click="cleanupApplication"
            v-if="selectedApplication.review_status !== 'pending'"
            :disabled="processing"
          >
            {{ processing ? '处理中...' : '清理记录' }}
          </button>
          <button class="btn-secondary" @click="closeModal">关闭</button>
        </div>
      </div>
    </div>

    <!-- 拒绝理由弹窗 -->
    <div v-if="showRejectModal" class="modal-overlay" @click="closeRejectDialog">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>拒绝申请</h3>
          <button class="close-btn" @click="closeRejectDialog">&times;</button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label>拒绝理由:</label>
            <textarea
              v-model="rejectReason"
              rows="4"
              placeholder="请填写拒绝理由..."
              class="form-control"
            ></textarea>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn-danger" @click="confirmReject" :disabled="!rejectReason.trim() || processing">
            {{ processing ? '处理中...' : '确认拒绝' }}
          </button>
          <button class="btn-secondary" @click="closeRejectDialog">取消</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'StoreApplications',
  data() {
    return {
      filterStatus: '',
      selectedApplication: null,
      showRejectModal: false,
      rejectReason: '',
      applications: [],
      loading: false,
      processing: false,
      pagination: {
        page: 1,
        per_page: 20,
        total: 0,
        pages: 1
      },
      stats: {
        pending: 0,
        todayProcessed: 0,
        monthlyApproved: 0,
        monthlyRejected: 0
      }
    }
  },
  computed: {
    token() {
      return localStorage.getItem('token')
    }
  },
  created() {
    // 设置axios实例
    this.axios = this.$axios
  },
  mounted() {
    this.loadApplications()
    this.loadStats()
  },
  methods: {
    async loadApplications() {
      this.loading = true
      try {
        const params = {
          page: this.pagination.page,
          per_page: this.pagination.per_page
        }

        if (this.filterStatus) {
          params.status = this.filterStatus
        }

        const response = await this.axios.get('/admin/merchant-applications', {
          params
        })

        if (response.data.success) {
          this.applications = response.data.data.applications
          this.pagination = response.data.data.pagination
        } else {
          alert(response.data.message || '获取申请列表失败')
        }
      } catch (error) {
        console.error('获取申请列表失败:', error)
        alert(error.response?.data?.message || '获取申请列表失败')
      } finally {
        this.loading = false
      }
    },

    async loadStats() {
      try {
        // 获取统计数据
        const response = await this.axios.get('/admin/merchant-applications/stats')

        if (response.data.success) {
          const data = response.data.data
          this.stats.pending = data.pending
          this.stats.todayProcessed = data.todayProcessed
          this.stats.monthlyApproved = data.monthlyApproved
          this.stats.monthlyRejected = data.monthlyRejected
        }
      } catch (error) {
        console.error('获取统计数据失败:', error)
      }
    },

    async viewApplication(application) {
      try {
        const response = await this.axios.get(`/admin/merchant-applications/${application.id}`)

        if (response.data.success) {
          this.selectedApplication = response.data.data
        } else {
          alert(response.data.message || '获取申请详情失败')
        }
      } catch (error) {
        console.error('获取申请详情失败:', error)
        alert(error.response?.data?.message || '获取申请详情失败')
      }
    },

    async approveApplication() {
      if (!this.selectedApplication) return

      this.processing = true
      try {
        const response = await this.axios.post(`/admin/merchant-applications/${this.selectedApplication.id}/approve`, {})

        if (response.data.success) {
          alert(response.data.message || '申请已批准')
          this.closeModal()
          this.loadApplications()
          this.loadStats()
        } else {
          alert(response.data.message || '批准申请失败')
        }
      } catch (error) {
        console.error('批准申请失败:', error)
        alert(error.response?.data?.message || '批准申请失败')
      } finally {
        this.processing = false
      }
    },

    showRejectDialog() {
      this.showRejectModal = true
      this.rejectReason = ''
    },

    closeRejectDialog() {
      this.showRejectModal = false
      this.rejectReason = ''
    },

    async confirmReject() {
      if (!this.selectedApplication || !this.rejectReason.trim()) return

      this.processing = true
      try {
        const response = await this.axios.post(`/admin/merchant-applications/${this.selectedApplication.id}/reject`, {
          reason: this.rejectReason.trim()
        })

        if (response.data.success) {
          alert(response.data.message || '申请已拒绝')
          this.closeRejectDialog()
          this.closeModal()
          this.loadApplications()
          this.loadStats()
        } else {
          alert(response.data.message || '拒绝申请失败')
        }
      } catch (error) {
        console.error('拒绝申请失败:', error)
        alert(error.response?.data?.message || '拒绝申请失败')
      } finally {
        this.processing = false
      }
    },

    async cleanupApplication() {
      if (!this.selectedApplication) return

      if (!confirm('确定要清理该用户的所有申请记录吗？此操作不可恢复。')) {
        return
      }

      this.processing = true
      try {
        const response = await this.axios.delete(`/admin/merchant-applications/${this.selectedApplication.id}/cleanup`)

        if (response.data.success) {
          alert(response.data.message || '记录已清理')
          this.closeModal()
          this.loadApplications()
          this.loadStats()
        } else {
          alert(response.data.message || '清理记录失败')
        }
      } catch (error) {
        console.error('清理记录失败:', error)
        alert(error.response?.data?.message || '清理记录失败')
      } finally {
        this.processing = false
      }
    },

    closeModal() {
      this.selectedApplication = null
    },

    changePage(page) {
      this.pagination.page = page
      this.loadApplications()
    },

    formatDate(dateString) {
      if (!dateString) return '-'
      return new Date(dateString).toLocaleString('zh-CN')
    },

    getStatusText(status) {
      const statusMap = {
        pending: '待审核',
        approved: '已通过',
        rejected: '已拒绝'
      }
      return statusMap[status] || status
    },

    // 将后端返回的相对路径转换为完整可访问 URL
    fullFileUrl(path) {
      if (!path) return ''
      // 如果已经包含协议，则直接返回
      if (/^https?:\/\//i.test(path)) return path
      // 否则使用后端地址前缀（注意：这里写死为 http://localhost:5000/）
      const backendHost = API_url
      // 确保拼接不会产生双斜杠
      return backendHost.replace(/\/$/, '') + '/' + path.replace(/^\//, '')
    }
  }
}
</script>

<style scoped>
/* 响应式字体和根容器 */
.store-applications {
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

.filters {
  display: flex;
  gap: clamp(8px, 1vw, 10px);
  align-items: center;
  flex-wrap: wrap;
}

.filter-select {
  padding: clamp(6px, 0.8vw, 8px) clamp(10px, 1.2vw, 12px);
  border: 1px solid var(--color-border-200);
  border-radius: 4px;
  background: var(--color-surface);
  font-size: clamp(12px, 1.2vw, 14px);
  min-width: 120px;
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
  background: var(--color-surface);
  border: 1px solid var(--color-border-200);
  border-radius: 8px;
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

/* 加载状态 */
.loading {
  text-align: center;
  padding: clamp(15px, 2vw, 25px);
  color: var(--color-text-600);
  font-size: clamp(12px, 1.2vw, 14px);
}

/* 分页样式 */
.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: clamp(12px, 1.5vw, 20px);
  margin-top: clamp(15px, 2vw, 20px);
  padding-top: clamp(15px, 2vw, 20px);
  border-top: 1px solid var(--color-border-200);
}

.page-info {
  color: var(--color-text-600);
  font-size: clamp(11px, 1.2vw, 14px);
}

/* 状态标签 */
.status-badge {
  padding: clamp(2px, 0.3vw, 4px) clamp(6px, 0.8vw, 10px);
  border-radius: 12px;
  font-size: clamp(9px, 1.1vw, 12px);
  font-weight: 600;
  display: inline-block;
  white-space: nowrap;
}

.status-badge.pending {
  background-color: var(--color-warning-50);
  color: var(--color-warning-700);
}

.status-badge.approved {
  background-color: var(--color-success-50);
  color: var(--color-success-700);
}

.status-badge.rejected {
  background-color: var(--color-danger-50);
  color: var(--color-danger-700);
}

/* 表格容器 */
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
  min-width: 1200px;
  border-collapse: collapse;
  margin-top: clamp(8px, 1vw, 12px);
}

.table th,
.table td {
  padding: clamp(8px, 1vw, 12px);
  text-align: left;
  border-bottom: 1px solid var(--color-border-200);
  font-size: clamp(11px, 1.2vw, 14px);
  white-space: nowrap;
}

.table th {
  background-color: var(--color-neutral-50);
  font-weight: 600;
  color: var(--color-text-600);
  position: sticky;
  top: 0;
  z-index: 10;
}

.table tbody tr:hover {
  background-color: var(--color-neutral-50);
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
  color: var(--color-text-700);
}

.close-btn {
  background: none;
  border: none;
  font-size: clamp(20px, 2.5vw, 24px);
  cursor: pointer;
  color: var(--color-text-600);
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

.review-note {
  background-color: var(--color-neutral-50);
  padding: clamp(8px, 1vw, 12px);
  border-radius: 4px;
  border-left: 4px solid var(--color-brand-500);
  font-size: clamp(12px, 1.2vw, 14px);
}

.file-preview {
  margin-top: clamp(5px, 0.8vw, 8px);
}

.preview-thumb {
  max-width: clamp(180px, 25vw, 220px);
  max-height: clamp(120px, 18vw, 160px);
  display: block;
  object-fit: contain;
  border: 1px solid var(--color-border-200);
  border-radius: 4px;
}

.file-link {
  color: var(--color-brand-500);
  text-decoration: none;
  padding: clamp(6px, 0.8vw, 10px) clamp(10px, 1.2vw, 14px);
  border: 1px solid var(--color-brand-500);
  border-radius: 4px;
  display: inline-block;
  font-size: clamp(11px, 1.2vw, 13px);
  transition: all 0.2s;
}

.file-link:hover {
  background-color: var(--color-brand-500);
  color: white;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 20px;
  border-top: 1px solid var(--color-border-200);
}

.form-group {
  margin-bottom: clamp(12px, 1.5vw, 18px);
}

.form-group label {
  display: block;
  margin-bottom: clamp(5px, 0.8vw, 8px);
  font-weight: 600;
  color: var(--color-text-600);
  font-size: clamp(12px, 1.2vw, 14px);
}

.form-control {
  width: 100%;
  padding: clamp(6px, 0.8vw, 8px) clamp(10px, 1.2vw, 12px);
  border: 1px solid var(--color-border-200);
  border-radius: 4px;
  font-size: clamp(12px, 1.2vw, 14px);
}

.form-control:focus {
  outline: none;
  border-color: var(--color-brand-500);
  box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.25);
}

textarea.form-control {
  resize: vertical;
  min-height: clamp(80px, 10vw, 120px);
}

/* 按钮样式 */
.btn {
  background-color: var(--color-brand-500);
  color: white;
  border: none;
  padding: clamp(4px, 0.6vw, 6px) clamp(8px, 1vw, 12px);
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

.btn:hover {
  background-color: var(--color-brand-600);
}

.btn:disabled {
  background-color: var(--color-text-500);
  cursor: not-allowed;
}

.btn-outline {
  background-color: transparent;
  color: var(--color-brand-500);
  border: 1px solid var(--color-brand-500);
  padding: clamp(4px, 0.6vw, 6px) clamp(8px, 1vw, 12px);
  border-radius: 4px;
  cursor: pointer;
  font-size: clamp(10px, 1.2vw, 12px);
  transition: all 0.2s;
}

.btn-outline:hover {
  background-color: var(--color-brand-500);
  color: white;
}

.btn-outline:disabled {
  background-color: transparent;
  color: var(--color-text-500);
  border-color: var(--color-text-500);
  cursor: not-allowed;
}

.btn-danger {
  background-color: var(--color-danger-500);
  color: white;
  border: none;
  padding: clamp(4px, 0.6vw, 6px) clamp(8px, 1vw, 12px);
  border-radius: 4px;
  cursor: pointer;
  font-size: clamp(10px, 1.2vw, 12px);
  transition: all 0.2s;
}

.btn-danger:hover {
  background-color: var(--color-danger-700);
}

.btn-danger:disabled {
  background-color: var(--color-text-500);
  cursor: not-allowed;
}

.btn-secondary {
  background-color: var(--color-text-500);
  color: white;
  border: none;
  padding: clamp(4px, 0.6vw, 6px) clamp(8px, 1vw, 12px);
  border-radius: 4px;
  cursor: pointer;
  font-size: clamp(10px, 1.2vw, 12px);
  transition: all 0.2s;
}

.btn-secondary:hover {
  background-color: var(--color-text-600);
}

/* 卡片样式 */
.card {
  background: var(--color-surface);
  border: 1px solid var(--color-border-200);
  border-radius: 8px;
  padding: clamp(15px, 2vw, 20px);
  margin-bottom: clamp(15px, 2vw, 20px);
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.card h3 {
  margin-top: 0;
  margin-bottom: clamp(12px, 1.5vw, 18px);
  color: var(--color-text-700);
  font-size: clamp(16px, 2vw, 18px);
}

/* 媒体查询 */
@media (max-width: 768px) {
  .page-header {
    flex-direction: column;
    align-items: stretch;
  }

  .filters {
    justify-content: center;
  }

  .stats-cards {
    grid-template-columns: 1fr;
  }

  .table-container {
    margin: -10px;
    padding: 10px;
  }

  .detail-grid {
    grid-template-columns: 1fr;
  }

  .pagination {
    flex-direction: column;
    gap: clamp(8px, 1vw, 12px);
  }
}

@media (max-width: 480px) {
  .store-applications {
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

  .preview-thumb {
    max-width: 100%;
    height: auto;
  }
}
</style>