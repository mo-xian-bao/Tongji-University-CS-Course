<template>
  <div class="system-notification">
    <h2>系统公告管理</h2>
    
    <div class="notification-container">
      <!-- 发布新公告 -->
      <div class="card publish-card">
        <h3>发布新公告</h3>
        <div class="form-group">
          <label for="target-audience">发送对象</label>
          <select v-model="newNotification.targetAudience" id="target-audience" class="form-control">
            <option value="all">所有用户</option>
            <option value="merchants">商家用户</option>
            <option value="users">普通用户</option>
          </select>
        </div>
        
        <div class="form-group">
          <label for="notification-content">公告内容</label>
          <textarea 
            v-model="newNotification.content" 
            id="notification-content"
            class="form-control" 
            placeholder="输入公告内容..."
            rows="6"
          ></textarea>
        </div>
        
        <div class="form-actions">
          <button class="btn btn-secondary" @click="resetForm">清空</button>
          <button class="btn btn-primary" @click="publishNotification" :disabled="!newNotification.content.trim()">
            发布公告
          </button>
        </div>
      </div>

      <!-- 历史公告列表 -->
      <div class="card history-card">
        <h3>公告历史</h3>
        
        <div class="tabs">
          <button 
            v-for="audience in audienceTypes" 
            :key="audience.value"
            class="tab-btn"
            :class="{ active: selectedAudience === audience.value }"
            @click="selectedAudience = audience.value"
          >
            {{ audience.label }}
          </button>
        </div>

        <div v-if="filteredNotifications.length === 0" class="empty-state">
          暂无公告
        </div>

        <div v-else class="notification-list">
          <div v-for="notification in filteredNotifications" :key="`${notification.admin_id}-${notification.target_audience}`" class="notification-item">
            <div class="notification-header">
              <div class="notification-meta">
                <span class="admin-name">{{ notification.admin_name }}</span>
                <span class="audience-badge" :class="`badge-${notification.target_audience}`">
                  {{ getAudienceLabel(notification.target_audience) }}
                </span>
                <span class="update-time">{{ formatDate(notification.updated_at) }}</span>
              </div>
            </div>
            
            <div class="messages-container">
              <div 
                v-for="(message, idx) in notification.messages" 
                :key="idx"
                class="message-item"
              >
                <div class="message-header-row">
                  <div class="message-time">{{ formatDate(message.timestamp) }}</div>
                  <button 
                    class="btn btn-tiny btn-delete" 
                    @click="deleteMessage(notification.admin_id, notification.target_audience, message.timestamp)"
                    title="删除此消息"
                  >
                    ✕
                  </button>
                </div>
                <div class="message-content">{{ message.content }}</div>
              </div>
            </div>

            <div class="notification-actions">
              <button class="btn btn-small btn-danger" @click="deleteAllNotifications(notification.admin_id, notification.target_audience)">
                删除全部
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'SystemNotification',
  data() {
    return {
      newNotification: {
        targetAudience: 'all',
        content: ''
      },
      notifications: [],
      selectedAudience: 'all',
      audienceTypes: [
        { value: 'all', label: '所有用户' },
        { value: 'merchants', label: '商家用户' },
        { value: 'users', label: '普通用户' }
      ],
      loading: false
    }
  },
  computed: {
    filteredNotifications() {
      return this.notifications.filter(n => n.target_audience === this.selectedAudience)
    }
  },
  mounted() {
    this.loadNotifications()
  },
  methods: {
    async loadNotifications() {
      this.loading = true
      try {
        const token = localStorage.getItem('token')
        const res = await axios.get('/admin/system-notifications', {
          headers: { Authorization: `Bearer ${token}` }
        })
        this.notifications = res.data.data || []
      } catch (error) {
        console.error('加载公告失败:', error)
        this.$message && this.$message.error && this.$message.error('加载公告失败')
      } finally {
        this.loading = false
      }
    },
    async publishNotification() {
      if (!this.newNotification.content.trim()) {
        this.$message && this.$message.warning && this.$message.warning('请输入公告内容')
        return
      }

      this.loading = true
      try {
        const token = localStorage.getItem('token')
        const payload = {
          target_audience: this.newNotification.targetAudience,
          content: this.newNotification.content.trim()
        }
        
        await axios.post('/admin/system-notifications', payload, {
          headers: { Authorization: `Bearer ${token}` }
        })
        
        this.$message && this.$message.success && this.$message.success('公告发布成功')
        this.resetForm()
        await this.loadNotifications()
      } catch (error) {
        console.error('发布公告失败:', error)
        this.$message && this.$message.error && this.$message.error('发布公告失败：' + (error.response?.data?.message || error.message))
      } finally {
        this.loading = false
      }
    },
    async deleteMessage(adminId, targetAudience, timestamp) {
      if (!confirm('确定要删除这条消息吗？')) {
        return
      }

      this.loading = true
      try {
        const token = localStorage.getItem('token')
        await axios.delete(`/admin/system-notifications/${adminId}/${targetAudience}/${timestamp}`, {
          headers: { Authorization: `Bearer ${token}` }
        })
        
        this.$message && this.$message.success && this.$message.success('消息已删除')
        await this.loadNotifications()
      } catch (error) {
        console.error('删除消息失败:', error)
        this.$message && this.$message.error && this.$message.error('删除消息失败：' + (error.response?.data?.message || error.message))
      } finally {
        this.loading = false
      }
    },
    async deleteAllNotifications(adminId, targetAudience) {
      if (!confirm('确定要删除这条公告的所有消息吗？')) {
        return
      }

      this.loading = true
      try {
        const token = localStorage.getItem('token')
        await axios.delete(`/admin/system-notifications/${adminId}/${targetAudience}`, {
          headers: { Authorization: `Bearer ${token}` }
        })
        
        this.$message && this.$message.success && this.$message.success('公告已删除')
        await this.loadNotifications()
      } catch (error) {
        console.error('删除公告失败:', error)
        this.$message && this.$message.error && this.$message.error('删除公告失败：' + (error.response?.data?.message || error.message))
      } finally {
        this.loading = false
      }
    },
    resetForm() {
      this.newNotification = {
        targetAudience: 'all',
        content: ''
      }
    },
    formatDate(dateStr) {
      if (!dateStr) return ''
      const date = new Date(dateStr)
      return date.toLocaleString('zh-CN')
    },
    getAudienceLabel(audience) {
      const type = this.audienceTypes.find(t => t.value === audience)
      return type ? type.label : audience
    }
  }
}
</script>

<style scoped>
.system-notification h2 {
  margin-bottom: 24px;
  color: var(--color-text-700);
  font-weight: 600;
}

.notification-container {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 24px;
}

.card {
  background: var(--color-surface);
  padding: 24px;
  border-radius: 8px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.04);
}

.card h3 {
  margin: 0 0 20px 0;
  color: #164e63;
  font-weight: 600;
  font-size: 16px;
}

.form-group {
  margin-bottom: 16px;
}

.form-group label {
  display: block;
  margin-bottom: 6px;
  color: var(--color-text-700);
  font-weight: 500;
  font-size: 14px;
}

.form-control {
  width: 100%;
  padding: 10px 12px;
  border: 1px solid var(--color-accent-teal-50);
  border-radius: 6px;
  font-size: 14px;
  transition: border-color 0.3s;
}

.form-control:focus {
  outline: none;
  border-color: var(--color-accent-teal-500);
  box-shadow: 0 0 0 3px rgba(15, 118, 110, 0.1);
}

textarea.form-control {
  font-family: inherit;
  resize: vertical;
}

.form-actions {
  display: flex;
  gap: 10px;
  justify-content: flex-end;
  margin-top: 20px;
}

.btn {
  padding: 10px 20px;
  border-radius: 6px;
  border: none;
  font-size: 14px;
  cursor: pointer;
  font-weight: 500;
  transition: all 0.3s;
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn-primary {
  background: var(--color-brand-600);
  color: white;
}

.btn-primary:hover:not(:disabled) {
  background: var(--color-brand-700);
  box-shadow: 0 4px 12px rgba(90, 111, 216, 0.2);
}

.btn-secondary {
  background: var(--color-neutral-50);
  color: var(--color-text-700);
  border: 1px solid var(--color-border-200);
}

.btn-secondary:hover:not(:disabled) {
  background: var(--color-neutral-200);
}

.btn-small {
  padding: 6px 12px;
  font-size: 12px;
}

.btn-tiny {
  padding: 2px 6px;
  font-size: 11px;
  line-height: 1;
  min-width: auto;
}

.btn-delete {
  background: var(--color-danger-50);
  color: var(--color-danger-700);
  border: none;
  padding: 4px 8px;
}

.btn-delete:hover:not(:disabled) {
  background: var(--color-danger-500);
  color: white;
}

.btn-danger {
  background: var(--color-danger-500);
  color: white;
}

.btn-danger:hover:not(:disabled) {
  background: var(--color-danger-700);
}

.tabs {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
  border-bottom: 1px solid var(--color-accent-teal-50);
}

.tab-btn {
  padding: 10px 16px;
  background: none;
  border: none;
  color: var(--color-text-500);
  font-weight: 500;
  cursor: pointer;
  border-bottom: 2px solid transparent;
  margin-bottom: -1px;
  transition: all 0.3s;
}

.tab-btn.active {
  color: var(--color-accent-teal-500);
  border-bottom-color: var(--color-accent-teal-500);
}

.empty-state {
  padding: 40px 20px;
  text-align: center;
  color: var(--color-text-500);
  font-size: 14px;
}

.notification-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.notification-item {
  border: 1px solid var(--color-accent-teal-50);
  border-radius: 6px;
  padding: 16px;
  background: var(--color-accent-teal-100);
}

.notification-header {
  margin-bottom: 12px;
}

.notification-meta {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-wrap: wrap;
}

.admin-name {
  font-weight: 600;
  color: var(--color-text-900);
  font-size: 14px;
}

.audience-badge {
  display: inline-block;
  padding: 4px 10px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
  color: white;
}

.badge-all {
  background: var(--color-info-500);
}

.badge-merchants {
  background: var(--color-warning-500);
}

.badge-users {
  background: var(--color-success-500);
}

.update-time {
  font-size: 12px;
  color: var(--color-text-500);
  margin-left: auto;
}

.messages-container {
  display: flex;
  flex-direction: column;
  gap: 10px;
  margin: 12px 0;
  max-height: 200px;
  overflow-y: auto;
  padding: 10px;
  background: var(--color-surface);
  border-radius: 4px;
}

.message-item {
  padding: 8px;
  border-left: 3px solid var(--color-accent-teal-500);
  background: var(--color-accent-teal-100);
  border-radius: 4px;
}

.message-header-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 4px;
}

.message-time {
  font-size: 12px;
  color: var(--color-text-500);
}

.message-content {
  font-size: 13px;
  color: #0f172a;
  line-height: 1.5;
  word-break: break-word;
}

.notification-actions {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
  margin-top: 12px;
}

@media (max-width: 1200px) {
  .notification-container {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .card {
    padding: 16px;
  }

  .notification-meta {
    flex-direction: column;
    align-items: flex-start;
  }

  .update-time {
    margin-left: 0;
  }
}
</style>
