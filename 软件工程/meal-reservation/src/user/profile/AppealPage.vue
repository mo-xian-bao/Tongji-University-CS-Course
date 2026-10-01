<template>
  <div class="appeal-page">
    <div class="page-header">
      <button class="back-btn" @click="goBack">
        ← 返回
      </button>
      <h1 class="page-title">账号申诉</h1>
    </div>

    <div class="page-content">
      <AppealForm
        v-if="banInfo"
        :ban-info="banInfo"
        @cancel="goBack"
        @success="onAppealSuccess"
      />

      <div v-else-if="loading" class="loading-container">
        <div class="loading-spinner"></div>
        <p>加载中...</p>
      </div>

      <div v-else-if="error" class="error-container">
        <p>{{ error }}</p>
        <button class="retry-btn" @click="loadBanInfo">重试</button>
      </div>

      <div v-else class="no-ban-info">
        <p>未找到封禁信息</p>
        <button class="back-home-btn" @click="goHome">返回首页</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import AppealForm from './AppealForm.vue'

const router = useRouter()
const route = useRoute()

const banInfo = ref(null)
const loading = ref(true)
const error = ref('')

onMounted(() => {
  loadBanInfo()
})

const loadBanInfo = () => {
  loading.value = true
  error.value = ''

  try {
    // 从路由查询参数中获取封禁信息
    const banId = route.query.banId
    const banReason = route.query.banReason

    if (banId && banReason) {
      banInfo.value = {
        id: parseInt(banId),
        ban_reason_text: banReason,
        ban_type: 'permanently', // 默认值
        banned_at: new Date().toISOString(),
        ban_until: null
      }
    } else {
      // 如果没有查询参数，尝试从登录时存储的信息获取
      const storedBanInfo = localStorage.getItem('banInfo')
      if (storedBanInfo) {
        banInfo.value = JSON.parse(storedBanInfo)
        localStorage.removeItem('banInfo') // 清除临时存储
      }
    }
  } catch (err) {
    console.error('加载封禁信息失败:', err)
    error.value = '加载封禁信息失败，请稍后重试'
  } finally {
    loading.value = false
  }
}

const goBack = () => {
  router.back()
}

const goHome = () => {
  router.push('/')
}

const onAppealSuccess = (appealData) => {
  // 申诉成功后的处理
  alert('申诉提交成功！我们会尽快处理您的申诉。')
  router.push('/')
}
</script>

<style scoped>
.appeal-page {
  min-height: 100vh;
  background-color: #f5f7fa;
  padding: 20px;
}

.page-header {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 30px;
  padding: 0 10px;
}

.back-btn {
  background: none;
  border: none;
  color: #007bff;
  font-size: 18px;
  cursor: pointer;
  padding: 8px 12px;
  border-radius: 4px;
  transition: background-color 0.2s;
}

.back-btn:hover {
  background-color: rgba(0, 123, 255, 0.1);
}

.page-title {
  margin: 0;
  color: #333;
  font-size: 28px;
  font-weight: 600;
}

.page-content {
  max-width: 1200px;
  margin: 0 auto;
}

.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  color: #666;
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #007bff;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 16px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.error-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  color: #dc3545;
  text-align: center;
}

.error-container p {
  margin-bottom: 20px;
  font-size: 18px;
}

.retry-btn {
  background-color: #007bff;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 16px;
}

.retry-btn:hover {
  background-color: #0056b3;
}

.no-ban-info {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  color: #666;
  text-align: center;
}

.no-ban-info p {
  margin-bottom: 20px;
  font-size: 18px;
}

.back-home-btn {
  background-color: #6c757d;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 16px;
}

.back-home-btn:hover {
  background-color: #5a6268;
}

@media (max-width: 768px) {
  .appeal-page {
    padding: 10px;
  }

  .page-header {
    padding: 0 5px;
  }

  .page-title {
    font-size: 24px;
  }
}
</style>