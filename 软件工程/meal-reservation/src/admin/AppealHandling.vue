<template>
  <div class="appeal-handling">
    <div class="page-header">
      <h2>申诉处理</h2>
      <div class="actions">
        <select v-model="filterStatus" class="filter-select" @change="refreshData">
          <option value="">全部状态</option>
          <option value="pending">待处理</option>
          <option value="processing">处理中</option>
          <option value="approved">已通过</option>
          <option value="rejected">已拒绝</option>
        </select>
        <button class="btn" @click="refreshData">刷新</button>
      </div>
    </div>

    <!-- 统计卡片 -->
    <div class="stats-cards">
      <div class="card">
        <h3>待处理申诉</h3>
        <div class="stat-number pending">{{ stats.pendingAppeals }}</div>
      </div>
      <div class="card">
        <h3>今日处理</h3>
        <div class="stat-number">{{ stats.todayProcessed }}</div>
      </div>
      <div class="card">
        <h3>本月通过率</h3>
        <div class="stat-number">{{ stats.monthlyApprovalRate }}%</div>
      </div>
      <div class="card">
        <h3>平均处理时间</h3>
        <div class="stat-number">{{ stats.avgProcessTime }}h</div>
      </div>
    </div>

    <!-- 申诉列表 -->
    <div class="card">
      <h3>申诉列表</h3>
      <div v-if="loading" class="loading-container">
        <div class="loading-spinner"></div>
        <p>加载中...</p>
      </div>
      <div v-else class="table-container">
        <table class="table">
        <thead>
          <tr>
            <th>申诉ID</th>
            <th>用户名</th>
            <th>申诉类型</th>
            <th>封禁原因</th>
            <th>申诉时间</th>
            <th>状态</th>
            <th>处理人</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="appeal in appeals" :key="appeal.id">
            <td>{{ appeal.id }}</td>
            <td>{{ appeal.username }}</td>
            <td>
              <span class="appeal-type-badge">
                {{ appeal.appeal_type_text }}
              </span>
            </td>
            <td>{{ appeal.ban_reason_text }}</td>
            <td>{{ formatDate(appeal.created_at) }}</td>
            <td>
              <span :class="['status-badge', appeal.status]">
                {{ appeal.status_text }}
              </span>
            </td>
            <td>{{ appeal.admin_name || '-' }}</td>
            <td>
              <button
                v-if="appeal.status === 'pending' || appeal.status === 'processing'"
                class="btn btn-primary"
                @click="handleAppeal(appeal)"
              >
                处理
              </button>
              <button
                class="btn btn-outline"
                @click="viewAppealDetails(appeal)"
              >
                查看详情
              </button>
            </td>
          </tr>
        </tbody>
      </table>
      </div>

      <!-- 分页 -->
      <div v-if="pagination.total_pages > 1" class="pagination">
        <button
          class="page-btn"
          :disabled="!pagination.has_prev"
          @click="changePage(pagination.current_page - 1)"
        >
          上一页
        </button>
        <span class="page-info">
          第 {{ pagination.current_page }} 页，共 {{ pagination.total_pages }} 页
        </span>
        <button
          class="page-btn"
          :disabled="!pagination.has_next"
          @click="changePage(pagination.current_page + 1)"
        >
          下一页
        </button>
      </div>
    </div>

    <!-- 处理申诉弹窗 -->
    <div v-if="showProcessModal" class="modal-overlay" @click="closeProcessModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>处理申诉 - #{{ selectedAppeal?.id }}</h3>
          <button class="close-btn" @click="closeProcessModal">&times;</button>
        </div>
        <div class="modal-body">
          <div class="appeal-summary">
            <div class="summary-item">
              <label>申诉人:</label>
              <span>{{ selectedAppeal?.username }} ({{ selectedAppeal?.user_phone }})</span>
            </div>
            <div class="summary-item">
              <label>申诉类型:</label>
              <span>{{ selectedAppeal?.appeal_type_text }}</span>
            </div>
            <div class="summary-item">
              <label>封禁原因:</label>
              <span>{{ selectedAppeal?.ban_reason_text }}</span>
            </div>
            <div class="summary-item">
              <label>申诉理由:</label>
              <p class="appeal-reason">{{ selectedAppeal?.appeal_reason }}</p>
            </div>
            <div v-if="selectedAppeal?.additional_info" class="summary-item">
              <label>补充说明:</label>
              <p class="appeal-additional">{{ selectedAppeal?.additional_info }}</p>
            </div>
            <div v-if="selectedAppeal?.attachments && selectedAppeal.attachments.length > 0" class="summary-item">
              <label>申诉材料:</label>
              <div class="attachments-list">
                <div
                  v-for="attachment in selectedAppeal.attachments"
                  :key="attachment.id"
                  class="attachment-item"
                >
                  <span class="attachment-name">{{ attachment.file_name }}</span>
                  <button
                    class="download-btn"
                    @click="downloadAttachment(attachment)"
                  >
                    下载
                  </button>
                </div>
              </div>
            </div>
            <div class="summary-item">
              <label>提交时间:</label>
              <span>{{ formatDate(selectedAppeal?.created_at) }}</span>
            </div>
          </div>

          <div class="form-group">
            <label>处理结果:</label>
            <select v-model="processForm.action" class="form-control">
              <option value="">请选择处理结果</option>
              <option value="approve">通过申诉</option>
              <option value="reject">拒绝申诉</option>
            </select>
          </div>

          <div class="form-group">
            <label>处理说明:</label>
            <textarea
              v-model="processForm.admin_note"
              class="form-control"
              rows="5"
              placeholder="请详细说明处理理由和依据..."
            ></textarea>
          </div>
        </div>

        <div class="modal-footer">
          <button class="btn btn-outline" @click="closeProcessModal">取消</button>
          <button
            class="btn btn-primary"
            :disabled="submitting"
            @click="submitProcess"
          >
            {{ submitting ? '提交中...' : '提交' }}
          </button>
        </div>
      </div>
    </div>

    <!-- 查看详情弹窗 -->
    <div v-if="showDetailModal" class="modal-overlay" @click="closeDetailModal">
      <div class="modal-content large" @click.stop>
        <div class="modal-header">
          <h3>申诉详情 - #{{ selectedAppeal?.id }}</h3>
          <button class="close-btn" @click="closeDetailModal">&times;</button>
        </div>
        <div class="modal-body">
          <div class="detail-grid">
            <div class="detail-section">
              <h4>用户信息</h4>
              <div class="detail-item">
                <label>用户名:</label>
                <span>{{ selectedAppeal?.username }}</span>
              </div>
              <div class="detail-item">
                <label>手机号:</label>
                <span>{{ selectedAppeal?.user_phone }}</span>
              </div>
              <div v-if="selectedAppeal?.contact_info" class="detail-item">
                <label>联系方式:</label>
                <span>{{ selectedAppeal?.contact_info }}</span>
              </div>
            </div>

            <div class="detail-section">
              <h4>封禁信息</h4>
              <div class="detail-item">
                <label>封禁原因:</label>
                <span>{{ selectedAppeal?.ban_reason_text }}</span>
              </div>
              <div class="detail-item">
                <label>封禁类型:</label>
                <span>{{ selectedAppeal?.ban_type || '未知' }}</span>
              </div>
              <div v-if="selectedAppeal?.ban_until" class="detail-item">
                <label>封禁期限:</label>
                <span>{{ formatDate(selectedAppeal?.ban_until) }}</span>
              </div>
            </div>

            <div class="detail-section">
              <h4>申诉信息</h4>
              <div class="detail-item">
                <label>申诉类型:</label>
                <span>{{ selectedAppeal?.appeal_type_text }}</span>
              </div>
              <div class="detail-item full-width">
                <label>申诉理由:</label>
                <p class="content-text">{{ selectedAppeal?.appeal_reason }}</p>
              </div>
              <div v-if="selectedAppeal?.additional_info" class="detail-item full-width">
                <label>补充说明:</label>
                <p class="content-text">{{ selectedAppeal?.additional_info }}</p>
              </div>
              <div class="detail-item">
                <label>申诉时间:</label>
                <span>{{ formatDate(selectedAppeal?.created_at) }}</span>
              </div>
              <div class="detail-item">
                <label>申诉状态:</label>
                <span :class="['status-badge', selectedAppeal?.status]">
                  {{ selectedAppeal?.status_text }}
                </span>
              </div>
            </div>

            <div v-if="selectedAppeal?.attachments && selectedAppeal.attachments.length > 0" class="detail-section full-width">
              <h4>申诉材料</h4>
              <div class="attachments-grid">
                <div
                  v-for="attachment in selectedAppeal.attachments"
                  :key="attachment.id"
                  class="attachment-card"
                >
                  <div class="attachment-info">
                    <div class="attachment-name">{{ attachment.file_name }}</div>
                    <div class="attachment-size">{{ attachment.file_size_text }}</div>
                  </div>
                  <button
                    class="download-btn"
                    @click="downloadAttachment(attachment)"
                  >
                    下载
                  </button>
                </div>
              </div>
            </div>

            <div v-if="selectedAppeal?.processed_at" class="detail-section full-width">
              <h4>处理结果</h4>
              <div class="detail-item">
                <label>处理状态:</label>
                <span :class="['status-badge', selectedAppeal?.status]">
                  {{ selectedAppeal?.status_text }}
                </span>
              </div>
              <div class="detail-item">
                <label>处理人:</label>
                <span>{{ selectedAppeal?.admin_name }}</span>
              </div>
              <div class="detail-item">
                <label>处理时间:</label>
                <span>{{ formatDate(selectedAppeal?.processed_at) }}</span>
              </div>
              <div v-if="selectedAppeal?.admin_note" class="detail-item full-width">
                <label>处理说明:</label>
                <p class="content-text">{{ selectedAppeal?.admin_note }}</p>
              </div>
            </div>
          </div>
        </div>

        <div class="modal-footer">
          <button class="btn btn-outline" @click="closeDetailModal">关闭</button>
          <button
            v-if="selectedAppeal?.status === 'pending' || selectedAppeal?.status === 'processing'"
            class="btn btn-primary"
            @click="switchToProcess"
          >
            处理申诉
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

const appeals = ref([])
const loading = ref(false)
const submitting = ref(false)
const filterStatus = ref('')
const currentPage = ref(1)
const pagination = ref({
  current_page: 1,
  total_pages: 1,
  per_page: 20,
  total_items: 0,
  has_next: false,
  has_prev: false
})

// 统计数据
const stats = ref({
  pendingAppeals: 0,
  todayProcessed: 0,
  monthlyApprovalRate: 0,
  avgProcessTime: 0
})

// 处理弹窗相关
const showProcessModal = ref(false)
const showDetailModal = ref(false)
const selectedAppeal = ref(null)
const processForm = ref({
  action: '',
  admin_note: ''
})

onMounted(() => {
  loadAppeals()
  loadStats()
})

const loadAppeals = async () => {
  try {
    loading.value = true
    const token = localStorage.getItem('token')

    const params = {
      page: currentPage.value,
      per_page: pagination.value.per_page
    }

    if (filterStatus.value) {
      params.status = filterStatus.value
    }

    const response = await axios.get('/admin/appeals', {
      headers: {
        'Authorization': `Bearer ${token}`
      },
      params
    })

    if (response.data.success) {
      appeals.value = response.data.data.appeals
      pagination.value = response.data.data.pagination
    }
  } catch (error) {
    console.error('加载申诉列表失败:', error)
    alert(error.response?.data?.message || '加载申诉列表失败，请稍后重试')
  } finally {
    loading.value = false
  }
}

const loadStats = async () => {
  try {
    const token = localStorage.getItem('token')
    const response = await axios.get('/admin/appeals/stats', {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    })

    if (response.data.success) {
      stats.value = response.data.data
    }
  } catch (error) {
    console.error('加载统计数据失败:', error)
    // 如果统计数据加载失败，使用基础统计数据
    stats.value = {
      pendingAppeals: appeals.value.filter(a => a.status === 'pending').length,
      todayProcessed: 0,
      monthlyApprovalRate: 0,
      avgProcessTime: 0
    }
  }
}

const changePage = (page) => {
  currentPage.value = page
  loadAppeals()
}

const refreshData = () => {
  currentPage.value = 1
  loadAppeals()
  loadStats()
}

const handleAppeal = (appeal) => {
  selectedAppeal.value = appeal
  processForm.value = {
    action: '',
    admin_note: ''
  }
  showProcessModal.value = true
}

const viewAppealDetails = (appeal) => {
  selectedAppeal.value = appeal
  showDetailModal.value = true
}

const closeProcessModal = () => {
  showProcessModal.value = false
  selectedAppeal.value = null
  processForm.value = {
    action: '',
    admin_note: ''
  }
}

const closeDetailModal = () => {
  showDetailModal.value = false
  selectedAppeal.value = null
}

const switchToProcess = () => {
  // 先保存当前选中的申诉到局部变量，避免 closeDetailModal() 清空 selectedAppeal
  const appeal = selectedAppeal.value
  closeDetailModal()
  handleAppeal(appeal)
}

const submitProcess = async () => {
  try {
    if (!processForm.value.action) {
      alert('请选择处理结果')
      return
    }

    submitting.value = true
    const token = localStorage.getItem('token')

    const response = await axios.post(`/admin/appeal/${selectedAppeal.value.id}/process`, {
      action: processForm.value.action,
      admin_note: processForm.value.admin_note
    }, {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      }
    })

    if (response.data.success) {
      alert(`申诉${processForm.value.action === 'approve' ? '通过' : '拒绝'}成功`)
      closeProcessModal()
      loadAppeals()
      loadStats() // 处理完成后重新加载统计数据
    } else {
      alert(response.data.message || '处理失败')
    }
  } catch (error) {
    console.error('处理申诉失败:', error)
    alert(error.response?.data?.message || '处理申诉失败，请稍后重试')
  } finally {
    submitting.value = false
  }
}

const downloadAttachment = async (attachment) => {
  try {
    const token = localStorage.getItem('token')

    // 创建下载链接
    const response = await axios.get(`/appeal/${attachment.id}/download`, {
      headers: {
        'Authorization': `Bearer ${token}`
      },
      responseType: 'blob'
    })

    // 创建下载链接
    const url = window.URL.createObjectURL(new Blob([response.data]))
    const link = document.createElement('a')
    link.href = url
    link.setAttribute('download', attachment.file_name)
    document.body.appendChild(link)
    link.click()
    link.remove()
    window.URL.revokeObjectURL(url)
  } catch (error) {
    console.error('下载附件失败:', error)
    alert(error.response?.data?.message || '下载附件失败，请稍后重试')
  }
}

const formatDate = (dateStr) => {
  if (!dateStr) return '-'
  return new Date(dateStr).toLocaleString('zh-CN')
}
</script>

<style scoped>
/* 响应式字体和根容器 */
.appeal-handling {
  font-size: clamp(12px, 1.2vw, 16px);
  line-height: 1.5;
  padding: clamp(10px, 1.5vw, 20px);
  max-width: 1400px;
  margin: 0 auto;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: clamp(18px, 2.5vw, 24px);
  flex-wrap: wrap;
  gap: clamp(10px, 1.5vw, 15px);
}

.page-header h2 {
  margin: 0;
  color: var(--color-text-700);
  font-size: clamp(20px, 2.5vw, 24px);
}

.actions {
  display: flex;
  gap: clamp(8px, 1.2vw, 12px);
  align-items: center;
  flex-wrap: wrap;
}

.filter-select {
  padding: clamp(6px, 0.8vw, 8px) clamp(10px, 1.2vw, 12px);
  border: 1px solid var(--color-border-200);
  border-radius: 4px;
  background-color: var(--color-surface);
  font-size: clamp(12px, 1.2vw, 14px);
  min-width: 120px;
}

.stats-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
  gap: clamp(15px, 2vw, 20px);
  margin-bottom: clamp(18px, 2.5vw, 24px);
}

.card {
  background: var(--color-surface);
  border-radius: 8px;
  padding: clamp(15px, 2vw, 20px);
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.card h3 {
  margin: 0 0 clamp(8px, 1.2vw, 12px) 0;
  font-size: clamp(14px, 1.5vw, 16px);
  color: var(--color-text-600);
}

.stat-number {
  font-size: clamp(22px, 3vw, 28px);
  font-weight: bold;
  color: var(--color-text-700);
}

.stat-number.pending {
  color: var(--color-danger-500);
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
  margin-top: clamp(12px, 1.5vw, 16px);
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
  color: var(--color-text-700);
  position: sticky;
  top: 0;
  z-index: 10;
}

/* 状态标签和标记 */
.appeal-type-badge, .status-badge {
  padding: clamp(2px, 0.3vw, 4px) clamp(6px, 0.8vw, 10px);
  border-radius: 12px;
  font-size: clamp(9px, 1.1vw, 12px);
  font-weight: 500;
  display: inline-block;
  white-space: nowrap;
}

.appeal-type-badge {
  background-color: var(--color-neutral-200);
  color: #495057;
}

.status-badge.pending {
  background-color: var(--color-warning-50);
  color: var(--color-warning-700);
}

.status-badge.processing {
  background-color: var(--color-info-50);
  color: var(--color-info-700);
}

.status-badge.approved {
  background-color: var(--color-success-50);
  color: var(--color-success-700);
}

.status-badge.rejected {
  background-color: var(--color-danger-50);
  color: var(--color-danger-700);
}

/* 按钮样式 */
.btn {
  padding: clamp(4px, 0.6vw, 6px) clamp(8px, 1vw, 12px);
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: clamp(10px, 1.2vw, 12px);
  margin-right: clamp(4px, 0.8vw, 12px);
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

.btn-outline {
  background-color: transparent;
  color: var(--color-brand-500);
  border: 1px solid var(--color-brand-500);
}

.btn-outline:hover {
  background-color: var(--color-brand-500);
  color: white;
}

.btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
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

.page-btn {
  padding: clamp(6px, 0.8vw, 10px) clamp(12px, 1.5vw, 20px);
  border: 1px solid var(--color-border-200);
  background-color: var(--color-surface);
  border-radius: 4px;
  cursor: pointer;
  font-size: clamp(11px, 1.2vw, 14px);
  transition: all 0.2s;
}

.page-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.page-btn:hover:not(:disabled) {
  background-color: var(--color-neutral-50);
}

.page-info {
  color: var(--color-text-600);
  font-size: clamp(11px, 1.2vw, 14px);
}

/* 模态框响应式 */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  padding: clamp(10px, 2vw, 20px);
}

.modal-content {
  background: var(--color-surface);
  border-radius: 8px;
  width: 90%;
  max-width: min(600px, 95vw);
  max-height: min(80vh, 800px);
  overflow-y: auto;
}

.modal-content.large {
  max-width: min(800px, 95vw);
}

.modal-header {
  padding: clamp(15px, 2vw, 20px);
  border-bottom: 1px solid var(--color-border-200);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.modal-header h3 {
  margin: 0;
  color: var(--color-text-700);
  font-size: clamp(16px, 2vw, 20px);
}

.close-btn {
  background: none;
  border: none;
  font-size: clamp(20px, 2.5vw, 24px);
  cursor: pointer;
  color: var(--color-text-500);
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.close-btn:hover {
  color: var(--color-text-700);
}

.modal-body {
  padding: clamp(15px, 2vw, 20px);
}

.modal-footer {
  padding: clamp(15px, 2vw, 20px);
  border-top: 1px solid var(--color-border-200);
  display: flex;
  justify-content: flex-end;
  gap: clamp(8px, 1.2vw, 12px);
}

.appeal-summary {
  margin-bottom: clamp(18px, 2.5vw, 30px);
}

.summary-item {
  margin-bottom: clamp(12px, 1.5vw, 20px);
}

.summary-item label {
  font-weight: 600;
  color: var(--color-text-700);
  margin-right: clamp(6px, 1vw, 10px);
  font-size: clamp(12px, 1.2vw, 14px);
}

.appeal-reason,
.appeal-additional {
  margin: 8px 0 0 0;
  padding: 12px;
  background-color: var(--color-neutral-50);
  border-radius: 4px;
  color: var(--color-text-600);
}

.attachments-list {
  margin-top: 8px;
}

.attachment-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px;
  background-color: var(--color-neutral-50);
  border-radius: 4px;
  margin-bottom: 8px;
}

.attachment-name {
  font-weight: 500;
  color: var(--color-text-700);
}

.download-btn {
  padding: 4px 8px;
  background-color: var(--color-brand-500);
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12px;
}

.download-btn:hover {
  background-color: var(--color-brand-600);
}

.form-group {
  margin-bottom: clamp(15px, 2vw, 20px);
}

.form-group label {
  display: block;
  font-weight: 600;
  color: var(--color-text-700);
  margin-bottom: clamp(5px, 0.8vw, 8px);
  font-size: clamp(12px, 1.2vw, 14px);
}

.form-control {
  width: 100%;
  padding: clamp(8px, 1vw, 12px);
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

/* 详情弹窗样式 */
.detail-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: clamp(15px, 2vw, 20px);
}

.detail-section {
  background-color: var(--color-neutral-50);
  padding: clamp(12px, 1.5vw, 18px);
  border-radius: 8px;
}

.detail-section.full-width {
  grid-column: 1 / -1;
}

.detail-section h4 {
  margin: 0 0 clamp(12px, 1.5vw, 20px) 0;
  color: var(--color-text-700);
  font-size: clamp(16px, 2vw, 20px);
  font-weight: 600;
}

.detail-item {
  display: flex;
  margin-bottom: clamp(8px, 1vw, 12px);
  font-size: clamp(12px, 1.2vw, 14px);
}

.detail-item.full-width {
  flex-direction: column;
}

.detail-item label {
  font-weight: 600;
  color: var(--color-text-700);
  min-width: clamp(80px, 10vw, 120px);
}

.detail-item.full-width label {
  margin-bottom: clamp(5px, 0.8vw, 8px);
}

.content-text {
  margin: 0;
  padding: clamp(8px, 1vw, 12px);
  background-color: var(--color-surface);
  border-radius: 4px;
  color: var(--color-text-600);
  line-height: 1.5;
  font-size: clamp(12px, 1.2vw, 14px);
}

.attachments-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: clamp(12px, 1.5vw, 18px);
}

.attachment-card {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: clamp(12px, 1.5vw, 18px);
  background-color: var(--color-surface);
  border-radius: 8px;
  border: 1px solid var(--color-border-200);
}

.attachment-info {
  flex: 1;
}

.attachment-name {
  font-weight: 600;
  color: var(--color-text-700);
  margin-bottom: 4px;
  font-size: clamp(11px, 1.2vw, 13px);
}

.attachment-size {
  font-size: clamp(10px, 1.1vw, 12px);
  color: var(--color-text-600);
}

.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: clamp(30px, 4vw, 50px);
  color: var(--color-text-600);
  font-size: clamp(12px, 1.2vw, 14px);
}

.loading-spinner {
  width: clamp(32px, 4vw, 48px);
  height: clamp(32px, 4vw, 48px);
  border: clamp(3px, 0.5vw, 4px) solid #f3f3f3;
  border-top: clamp(3px, 0.5vw, 4px) solid var(--color-brand-500);
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: clamp(12px, 1.5vw, 20px);
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* 媒体查询 */
@media (max-width: 768px) {
  .page-header {
    flex-direction: column;
    align-items: stretch;
  }

  .actions {
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

  .detail-item {
    flex-direction: column;
  }

  .detail-item label {
    margin-bottom: clamp(5px, 0.8vw, 8px);
    min-width: auto;
  }

  .attachments-grid {
    grid-template-columns: 1fr;
  }

  .attachment-card {
    flex-direction: column;
    align-items: stretch;
    gap: clamp(8px, 1vw, 12px);
  }
}

@media (max-width: 480px) {
  .appeal-handling {
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

  .pagination {
    flex-direction: column;
    gap: clamp(8px, 1vw, 12px);
  }
}
</style>