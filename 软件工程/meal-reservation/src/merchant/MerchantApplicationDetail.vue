<template>
  <div class="merchant-application-detail-container">
    <div class="application-box">
      <div class="application-header">
        <h2 class="application-title">商户申请详情</h2>
        <div class="status-badge" :class="statusClass">
          {{ statusText }}
        </div>
      </div>

      <div class="application-content">
        <!-- 基本信息 -->
        <div class="info-section">
          <h3 class="section-title">🏪 基本信息</h3>
          <div class="info-grid">
            <div class="info-item">
              <label>店铺名称</label>
              <span>{{ application.shop_name }}</span>
            </div>
            <div class="info-item">
              <label>店铺类型</label>
              <span>{{ getShopTypeName(application.shop_type) }}</span>
            </div>
            <div class="info-item">
              <label>联系电话</label>
              <span>{{ application.phone }}</span>
            </div>
            <div class="info-item">
              <label>营业时间</label>
              <span>{{ application.business_hours }}</span>
            </div>
            <div class="info-item full-width">
              <label>店铺地址</label>
              <span>{{ application.address }}</span>
            </div>
            <div class="info-item full-width">
              <label>店铺简介</label>
              <span>{{ application.description || '暂无简介' }}</span>
            </div>
          </div>
        </div>

        <!-- 审核信息 -->
        <div class="review-section" v-if="application.review_status && application.review_status !== 'pending'">
          <h3 class="section-title">📋 审核信息</h3>
          <div class="review-info">
            <div class="review-item">
              <label>审核状态</label>
              <span :class="reviewStatusClass">{{ reviewStatusText }}</span>
            </div>
            <div class="review-item">
              <label>审核时间</label>
              <span>{{ formatTime(application.reviewed_at) }}</span>
            </div>
            <div class="review-item" v-if="application.reviewer_name">
              <label>审核人</label>
              <span>{{ application.reviewer_name }}</span>
            </div>
            <div class="review-item full-width">
              <label>审核备注</label>
              <span>{{ application.review_note || '无' }}</span>
            </div>
          </div>
        </div>

        <!-- 证明文件 -->
        <div class="files-section">
          <h3 class="section-title">📄 证明文件</h3>
          <div class="file-list">
            <!-- 营业执照 -->
            <div class="file-item" v-if="application.license_file_url">
              <div class="file-info">
                <div class="file-icon">📄</div>
                <div class="file-details">
                  <div class="file-name">营业执照</div>
                  <div class="file-size">{{ getFileSize(application.license_file_url) }}</div>
                </div>
              </div>
              <div class="file-actions">
                <button class="preview-btn" @click="previewFile(application.license_file_url, '营业执照')">
                  预览
                </button>
                <button class="view-file-btn" @click="viewFile(application.license_file_url)">
                  查看文件
                </button>
              </div>
            </div>

            <!-- 身份证照片 -->
            <div class="file-item" v-if="application.id_file_url">
              <div class="file-info">
                <div class="file-icon">🆔</div>
                <div class="file-details">
                  <div class="file-name">身份证照片</div>
                  <div class="file-size">{{ getFileSize(application.id_file_url) }}</div>
                </div>
              </div>
              <div class="file-actions">
                <button class="preview-btn" @click="previewFile(application.id_file_url, '身份证照片')">
                  预览
                </button>
                <button class="view-file-btn" @click="viewFile(application.id_file_url)">
                  查看文件
                </button>
              </div>
            </div>

            <!-- 图片预览模态框 -->
            <div v-if="showPreview" class="preview-modal" @click="closePreview">
              <div class="preview-content" @click.stop>
                <div class="preview-header">
                  <h3>{{ previewTitle }}</h3>
                  <button class="close-btn" @click="closePreview">×</button>
                </div>
                <div class="preview-image-container">
                  <img :src="previewUrl" :alt="previewTitle" class="preview-image" />
                </div>
                <div class="preview-actions">
                  <button class="download-btn" @click="downloadFile">
                    下载图片
                  </button>
                  <button class="view-file-btn" @click="viewFile(previewUrl)">
                    查看原图
                  </button>
                </div>
              </div>
            </div>

            <div v-if="!application.license_file_url && !application.id_file_url" class="no-files">
              暂无上传文件
            </div>
          </div>
        </div>

        <!-- 操作按钮 -->
        <div class="action-buttons">
          <button class="edit-btn" @click="goToEdit" v-if="application.status === 'draft'">
            继续编辑
          </button>
          <button class="back-btn" @click="goBack">
            返回
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { getMerchantApplicationDetail } from '@/api/user'

const router = useRouter()
const application = ref({})

// 从路由参数获取申请ID
const route = useRoute()
const applicationId = computed(() => {
  return route.params.id.split("-")[1]
})

// 计算属性
const statusText = computed(() => {
  switch (application.value.status) {
    case 'draft':
      return '草稿状态'
    case 'submitted':
      return '已提交'
    default:
      return application.value.status
  }
})

const statusClass = computed(() => {
  switch (application.value.status) {
    case 'draft':
      return 'draft'
    case 'submitted':
      return 'submitted'
    default:
      return 'unknown'
  }
})

const reviewStatusText = computed(() => {
  switch (application.value.review_status) {
    case 'pending':
      return '等待审核'
    case 'approved':
      return '已通过'
    case 'rejected':
      return '已拒绝'
    default:
      return application.value.review_status || '未知'
  }
})

const reviewStatusClass = computed(() => {
  switch (application.value.review_status) {
    case 'pending':
      return 'pending'
    case 'approved':
      return 'approved'
    case 'rejected':
      return 'rejected'
    default:
      return 'unknown'
  }
})

// 从路由状态获取申请信息
onMounted(() => {
  const state = history.state
  if (state && state.application) {
    application.value = state.application
  } else {
    // 如果没有从路由状态获取到，则从API获取
    loadApplication()
  }
})

async function loadApplication() {
  try {
    const token = localStorage.getItem('token')
    if (!token) {
      router.push('/login')
      return
    }

    const response = await getMerchantApplicationDetail(applicationId.value)
    if (response.data) {
      application.value = response.data.data
    } else {
      console.error('获取申请详情失败')
      router.push('/messages')
    }
  } catch (error) {
    console.error('加载申请详情失败:', error)
    router.push('/messages')
  }
}

function getShopTypeName(type) {
  const typeMap = {
    'restaurant': '餐厅',
    'fast_food': '快餐店',
    'cafe': '咖啡厅',
    'dessert': '甜品店',
    'drink': '饮品店',
    'other': '其他'
  }
  return typeMap[type] || type
}

function formatTime(time) {
  if (!time) return ''
  return new Date(time).toLocaleString('zh-CN')
}

const showPreview = ref(false)
const previewUrl = ref('')
const previewTitle = ref('')

function viewFile(fileUrl) {
  // 在新窗口中查看文件
  window.open(`${API_url}${fileUrl}`, '_blank')
}

function previewFile(fileUrl, title) {
  previewUrl.value = `${API_url}${fileUrl}`;
  previewTitle.value = title
  showPreview.value = true
}

function closePreview() {
  showPreview.value = false
  previewUrl.value = ''
  previewTitle.value = ''
}

function downloadFile() {
  const link = document.createElement('a')
  link.href = previewUrl.value
  link.download = `${previewTitle.value}_${new Date().getTime()}.jpg`
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}

function getFileSize(fileUrl) {
  // 这里可以根据实际情况返回文件大小
  // 由于前端无法直接获取文件大小，这里返回固定文本
  return '点击查看'
}

function goToEdit() {
  router.push({
    name: 'MerchantApplication',
    query: {
      id: application.value.id,
      edit: true
    }
  })
}

function goBack() {
  router.push('/messages')
}
</script>

<style scoped>
.merchant-application-detail-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px;
}

.application-box {
  background: white;
  padding: 40px;
  border-radius: 16px;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 800px;
}

.application-header {
  text-align: center;
  margin-bottom: 40px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.application-title {
  font-size: 32px;
  color: #333;
  margin: 0;
  font-weight: 600;
}

.status-badge {
  padding: 8px 16px;
  border-radius: 20px;
  font-size: 14px;
  font-weight: 600;
  color: white;
}

.status-badge.draft {
  background: #f59e0b;
}

.status-badge.submitted {
  background: #3b82f6;
}

.status-badge.unknown {
  background: #6b7280;
}

.application-content {
  display: flex;
  flex-direction: column;
  gap: 32px;
}

.section-title {
  font-size: 20px;
  color: #333;
  margin-bottom: 20px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 8px;
}

.info-section,
.review-section,
.files-section {
  border-bottom: 1px solid #e2e8f0;
  padding-bottom: 24px;
}

.info-section:last-child,
.review-section:last-child,
.files-section:last-child {
  border-bottom: none;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 16px;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.info-item.full-width {
  grid-column: 1 / -1;
}

.info-item label {
  font-size: 14px;
  color: #666;
  font-weight: 500;
}

.info-item span {
  font-size: 16px;
  color: #333;
  background: #f8fafc;
  padding: 8px 12px;
  border-radius: 6px;
  word-break: break-word;
}

.review-info {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.review-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.review-item.full-width {
  grid-column: 1 / -1;
}

.review-item label {
  font-size: 14px;
  color: #666;
  font-weight: 500;
}

.review-item span {
  font-size: 16px;
  color: #333;
  background: #f8fafc;
  padding: 8px 12px;
  border-radius: 6px;
  word-break: break-word;
}

.review-item span.pending {
  background: #fef3c7;
  color: #92400e;
}

.review-item span.approved {
  background: #d1fae5;
  color: #065f46;
}

.review-item span.rejected {
  background: #fee2e2;
  color: #991b1b;
}

.file-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.file-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  background: #f9fafb;
}

.file-actions {
  display: flex;
  gap: 8px;
}

.preview-btn {
  padding: 6px 12px;
  background: #10b981;
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 12px;
  transition: background 0.3s ease;
}

.preview-btn:hover {
  background: #059669;
}

.preview-modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.8);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.preview-content {
  background: white;
  border-radius: 12px;
  max-width: 90%;
  max-height: 90%;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.25);
}

.preview-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  border-bottom: 1px solid #e5e7eb;
  background: #f9fafb;
}

.preview-header h3 {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  color: #1f2937;
}

.close-btn {
  width: 32px;
  height: 32px;
  border: none;
  border-radius: 50%;
  background: #ef4444;
  color: white;
  font-size: 18px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background 0.3s ease;
}

.close-btn:hover {
  background: #dc2626;
}

.preview-image-container {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
  background: #f3f4f6;
}

.preview-image {
  max-width: 100%;
  max-height: 70vh;
  object-fit: contain;
  border-radius: 8px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.preview-actions {
  display: flex;
  gap: 12px;
  padding: 16px 20px;
  border-top: 1px solid #e5e7eb;
  justify-content: center;
}

.download-btn {
  padding: 8px 16px;
  background: #8b5cf6;
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
  transition: background 0.3s ease;
}

.download-btn:hover {
  background: #7c3aed;
}

.file-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.file-icon {
  font-size: 24px;
}

.file-details {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.file-name {
  font-size: 16px;
  font-weight: 500;
  color: #333;
}

.file-size {
  font-size: 14px;
  color: #666;
}

.view-file-btn {
  padding: 8px 16px;
  background: #3b82f6;
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
  transition: background 0.3s ease;
}

.view-file-btn:hover {
  background: #2563eb;
}

.no-files {
  padding: 32px;
  text-align: center;
  color: #9ca3af;
  font-size: 14px;
}

.action-buttons {
  display: flex;
  gap: 12px;
  justify-content: center;
  margin-top: 32px;
}

.edit-btn,
.back-btn {
  padding: 12px 24px;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  min-width: 120px;
}

.edit-btn {
  background: #3b82f6;
  color: white;
  border: none;
}

.edit-btn:hover {
  background: #2563eb;
}

.back-btn {
  background: white;
  color: #374151;
  border: 2px solid #d1d5db;
}

.back-btn:hover {
  background: #f9fafb;
  border-color: #9ca3af;
}

@media (max-width: 768px) {
  .application-box {
    padding: 24px;
    margin: 10px;
  }

  .application-header {
    flex-direction: column;
    gap: 16px;
  }

  .application-title {
    font-size: 24px;
  }

  .info-grid {
    grid-template-columns: 1fr;
  }

  .action-buttons {
    flex-direction: column;
  }

  .edit-btn,
  .back-btn {
    width: 100%;
  }
}
</style>