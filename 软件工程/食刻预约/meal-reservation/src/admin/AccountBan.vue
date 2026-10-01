<template>
  <div class="account-ban">
    <div class="page-header">
      <h2>账号封禁管理</h2>
      <div class="actions">
        <input
          type="text"
          v-model="searchKeyword"
          placeholder="搜索用户名/手机号"
          class="search-input"
          :disabled="loading"
        >
        <select v-model="filterStatus" class="filter-select" :disabled="loading">
          <option value="all">全部状态</option>
          <option value="normal">正常</option>
          <option value="banned">已封禁</option>
          <option value="temporarily_banned">临时封禁</option>
        </select>
        <select v-model="filterType" class="filter-select" :disabled="loading">
          <option value="all">全部用户</option>
          <option value="customer">顾客</option>
          <option value="merchant">商家</option>
        </select>
        <button class="btn" @click="loadUsers" :disabled="loading">
          {{ loading ? '加载中...' : '搜索' }}
        </button>
      </div>
    </div>

    <!-- 加载状态指示器 -->
    <div v-if="loading" class="loading-overlay">
      <div class="loading-spinner">加载中...</div>
    </div>

    <!-- 统计卡片 -->
    <div class="stats-cards">
      <div class="card">
        <h3>总用户数</h3>
        <div class="stat-number">{{ stats.totalUsers }}</div>
      </div>
      <div class="card">
        <h3>已封禁</h3>
        <div class="stat-number banned">{{ stats.bannedUsers }}</div>
      </div>
      <div class="card">
        <h3>临时封禁</h3>
        <div class="stat-number warning">{{ stats.tempBannedUsers }}</div>
      </div>
      <div class="card">
        <h3>今日封禁</h3>
        <div class="stat-number">{{ stats.todayBanned }}</div>
      </div>
    </div>

    <!-- 用户列表 -->
    <div class="card">
      <h3>用户列表</h3>
      <div class="table-container">
        <table class="table">
        <thead>
          <tr>
            <th>用户ID</th>
            <th>用户名</th>
            <th>手机号</th>
            <th>用户类型</th>
            <th>注册时间</th>
            <th>状态</th>
            <th>封禁原因</th>
            <th>封禁期限</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in filteredUsers" :key="user.id">
            <td>{{ user.id }}</td>
            <td>{{ user.username }}</td>
            <td>{{ user.phone }}</td>
            <td>
              <span :class="['user-type-badge', user.type]">
                {{ getUserTypeText(user.usertype) }}
              </span>
            </td>
            <td>{{ formatDate(user.registerTime) }}</td>
            <td>
              <span :class="['status-badge', user.status]">
                {{ getStatusText(user.status) }}
              </span>
            </td>
            <td>{{ user.status != 'normal' ? user.banReason || '-':'-' }}</td>
            <td>{{ user.banUntil ? formatDate(user.banUntil) : '-' }}</td>
            <td>
              <button
                v-if="user.status === 'normal'"
                class="btn-danger"
                @click="banUser(user)"
              >
                封禁
              </button>
              <button
                v-if="user.status === 'banned' || user.status === 'temporarily_banned'"
                class="btn"
                @click="unbanUser(user)"
              >
                解封
              </button>
              <button
                class="btn-outline"
                @click="viewUserDetails(user)"
              >
                详情
              </button>
            </td>
          </tr>
        </tbody>
      </table>
      </div>
      <div v-if="!loading && !filteredUsers.length" class="empty-state">
        <p>暂无用户数据</p>
      </div>
    </div>

    <!-- 封禁弹窗 -->
    <div v-if="showBanModal" class="modal-overlay" @click="closeBanModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>封禁用户 - {{ selectedUser?.username }}</h3>
          <button class="close-btn" @click="closeBanModal">&times;</button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label>封禁类型:</label>
            <select v-model="banForm.type" class="form-control">
              <option value="permanently">永久封禁</option>
              <option value="temporarily">临时封禁</option>
            </select>
          </div>
          <div class="form-group" v-if="banForm.type === 'temporarily'">
            <label>封禁期限:</label>
            <select v-model="banForm.duration" class="form-control">
              <option value="1">1天</option>
              <option value="7">7天</option>
              <option value="30">30天</option>
              <option value="90">90天</option>
              <option value="365">1年</option>
            </select>
          </div>
          <div class="form-group">
            <label>封禁原因:</label>
            <select v-model="banForm.reason" class="form-control">
              <option value="">请选择封禁原因</option>
              <option value="spam">发布垃圾信息</option>
              <option value="fraud">欺诈行为</option>
              <option value="harassment">骚扰他人</option>
              <option value="violation">违反平台规定</option>
              <option value="illegal">违法内容</option>
              <option value="other">其他</option>
            </select>
          </div>
          <div class="form-group">
            <label>详细说明:</label>
            <textarea
              v-model="banForm.description"
              class="form-control"
              rows="4"
              placeholder="请详细说明封禁原因..."
            ></textarea>
          </div>
          <div class="form-group">
            <label class="checkbox-label">
              <input
                type="checkbox"
                v-model="banForm.notifyUser"
              >
              通知用户
            </label>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn-danger" @click="confirmBan">确认封禁</button>
          <button class="btn-secondary" @click="closeBanModal">取消</button>
        </div>
      </div>
    </div>

    <!-- 用户详情弹窗 -->
    <div v-if="showDetailsModal" class="modal-overlay" @click="closeDetailsModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>用户详情 - {{ selectedUser?.username }}</h3>
          <button class="close-btn" @click="closeDetailsModal">&times;</button>
        </div>
        <div class="modal-body">
          <div class="detail-grid">
            <div class="detail-item">
              <label>用户ID:</label>
              <span>{{ selectedUser?.id }}</span>
            </div>
            <div class="detail-item">
              <label>用户名:</label>
              <span>{{ selectedUser?.username }}</span>
            </div>
            <div class="detail-item">
              <label>手机号:</label>
              <span>{{ selectedUser?.phone }}</span>
            </div>
            <div class="detail-item">
              <label>邮箱:</label>
              <span>{{ selectedUser?.email || '未填写' }}</span>
            </div>
            <div class="detail-item">
              <label>用户类型:</label>
              <span>{{ getUserTypeText(selectedUser?.usertype) }}</span>
            </div>
            <div class="detail-item">
              <label>注册时间:</label>
              <span>{{ formatDate(selectedUser?.registerTime) }}</span>
            </div>
            <div class="detail-item">
              <label>最后登录:</label>
              <span>{{ formatDate(selectedUser?.last_login) }}</span>
            </div>
            <div class="detail-item">
              <label>账号状态:</label>
              <span :class="['status-badge', selectedUser?.status]">
                {{ getStatusText(selectedUser?.status) }}
              </span>
            </div>
            <div v-if="selectedUser?.banReason && selectedUser?.status != 'normal'" class="detail-item full-width">
              <label>封禁原因:</label>
              <span>{{ selectedUser.banReason }}</span>
            </div>
            <div v-if="selectedUser?.banUntil" class="detail-item">
              <label>封禁到期:</label>
              <span>{{ formatDate(selectedUser.banUntil) }}</span>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn-secondary" @click="closeDetailsModal">关闭</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { onMounted, ref } from 'vue';

export default {
  name: 'AccountBan',
  data() {
    return {
      searchKeyword: '',
      filterStatus: 'all',
      filterType: 'all',
      showBanModal: false,
      showDetailsModal: false,
      selectedUser: null,
      banForm: {
        type: 'permanently',
        duration: '7',
        reason: '',
        description: '',
        notifyUser: true
      },
      users: [],
      stats: {
        totalUsers: 0,
        bannedUsers: 0,
        tempBannedUsers: 0,
        todayBanned: 0
      },
      loading: false,
    }
  },
  computed: {
    filteredUsers() {
      return this.users.filter(user => {
        let matchesSearch = true
        let matchesStatus = true
        let matchesType = true

        if (this.searchKeyword) {
          matchesSearch = user.username.includes(this.searchKeyword) ||
                         user.phone.includes(this.searchKeyword)
        }

        if (this.filterStatus !== 'all') {
          matchesStatus = user.status === this.filterStatus
        }

        if (this.filterType !== 'all') {
          const typeMap = {
            'merchant':1,
            'customer':2
          }
          matchesType = user.usertype === typeMap[this.filterType]
        }

        return matchesSearch && matchesStatus && matchesType
      })
    }
  },
  mounted() {
    this.loadData()
  },
  methods: {
    // 页面初始化加载数据
    async loadData() {
      await Promise.all([
        this.loadStats(),
        this.loadUsers()
      ])
    },

    // 加载统计数据
    async loadStats() {
      try {
        this.loading = true
        const response = await fetch(`/api/admin/users/ban/stats`, {
          headers: {
            'Authorization': `Bearer ${localStorage.getItem('token')}`
          }
        })

        if (response.ok) {
          const result = await response.json()
          this.stats = result.data
        } else {
          console.error('获取统计信息失败')
        }
      } catch (error) {
        console.error('加载统计数据失败:', error)
      } finally {
        this.loading = false
      }
    },

    // 加载用户列表
    async loadUsers() {
      try {
        this.loading = true
        const params = new URLSearchParams({
          search: this.searchKeyword,
          status: this.filterStatus,
          type: this.filterType == 'all' ? "no admin":this.filterType,
          page: 1,
          per_page: 100
        })

        const response = await fetch(`/api/admin/users/ban/list?${params.toString()}`, {
          headers: {
            'Authorization': `Bearer ${localStorage.getItem('token')}`
          }
        })

        if (response.ok) {
          const result = await response.json()
          this.users = result.data.users
        } else {
          console.error('获取用户列表失败')
        }
      } catch (error) {
        console.error('加载用户列表失败:', error)
      } finally {
        this.loading = false
      }
    },

    // 加载统计信息
    async loadStats() {
      try {
        const response = await fetch(`/api/admin/users/ban/stats`, {
          headers: {
            'Authorization': `Bearer ${localStorage.getItem('token')}`
          }
        })

        if (response.ok) {
          const result = await response.json()
          this.stats = result.data
        } else {
          console.error('获取统计信息失败')
        }
      } catch (error) {
        console.error('加载统计数据失败:', error)
      }
    },

    // 封禁用户
    banUser(user) {
      this.selectedUser = user
      this.banForm = {
        type: 'permanently',
        duration: '7',
        reason: '',
        description: '',
        notifyUser: true
      }
      this.showBanModal = true
    },

    // 解封用户
    async unbanUser(user) {
      if (!confirm(`确定要解封用户 ${user.username} 吗？`)) {
        return
      }

      try {
        const response = await fetch(`/api/admin/users/${user.id}/unban`, {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${localStorage.getItem('token')}`,
            'Content-Type': 'application/json'
          }
        })

        if (response.ok) {
          const result = await response.json()
          alert(result.message)
          this.loadUsers() // 重新加载用户列表
          this.loadStats() // 重新加载统计数据
        } else {
          const error = await response.json()
          alert(error.message || '解封失败')
        }
      } catch (error) {
        console.error('解封用户失败:', error)
        alert('解封失败，请稍后重试')
      }
    },

    // 查看用户详情
    viewUserDetails(user) {
      this.selectedUser = user
      this.showDetailsModal = true
    },

    // 关闭封禁弹窗
    closeBanModal() {
      this.showBanModal = false
      this.selectedUser = null
    },

    // 关闭详情弹窗
    closeDetailsModal() {
      this.showDetailsModal = false
      this.selectedUser = null
    },

    // 确认封禁用户
    async confirmBan() {
      if (!this.banForm.reason) {
        alert('请选择封禁原因')
        return
      }

      try {
        const response = await fetch(`/api/admin/users/${this.selectedUser.id}/ban`, {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${localStorage.getItem('token')}`,
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            type: this.banForm.type,
            reason: this.banForm.reason,
            description: this.banForm.description,
            duration: parseInt(this.banForm.duration),
            notify_user: this.banForm.notifyUser
          })
        })

        if (response.ok) {
          const result = await response.json()
          alert(result.message)
          this.closeBanModal()
          this.loadUsers() // 重新加载用户列表
          this.loadStats() // 重新加载统计数据
        } else {
          const error = await response.json()
          alert(error.message || '封禁失败')
        }
      } catch (error) {
        console.error('封禁用户失败:', error)
        alert('封禁失败，请稍后重试')
      }
    },

    // 获取封禁原因文本
    getReasonText(reason) {
      const reasonMap = {
        spam: '发布垃圾信息',
        fraud: '欺诈行为',
        harassment: '骚扰他人',
        violation: '违反平台规定',
        illegal: '违法内容',
        other: '其他'
      }
      return reasonMap[reason] || reason
    },

    // 获取用户类型文本
    getUserTypeText(type) {
      const typeMap = {
        0: '管理员',
        1: '商家',
        2: '顾客'
      }
      return typeMap[type] || type
    },

    // 获取状态文本
    getStatusText(status) {
      const statusMap = {
        normal: '正常',
        banned: '已封禁',
        temporarily_banned: '临时封禁'
      }
      return statusMap[status] || status
    },

    // 格式化日期
    formatDate(dateString) {
      if (!dateString) return '-'
      return new Date(dateString)
    }
  }
}
</script>

<style scoped>
/* 响应式字体和根容器 */
.account-ban {
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
  border: 1px solid #ddd;
  border-radius: 4px;
  width: clamp(200px, 30vw, 250px);
  font-size: clamp(12px, 1.2vw, 14px);
}

.filter-select {
  padding: clamp(6px, 0.8vw, 8px) clamp(10px, 1.2vw, 12px);
  border: 1px solid #ddd;
  border-radius: 4px;
  background: white;
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
  border-radius: 8px;
  background: #fff;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.stats-cards .card h3 {
  font-size: clamp(14px, 1.5vw, 16px);
  margin: 0 0 10px 0;
  color: #666;
}

.stat-number {
  font-size: clamp(24px, 3vw, 32px);
  font-weight: bold;
  color: #667eea;
  margin-top: 10px;
}

.stat-number.banned {
  color: #e74c3c;
}

.stat-number.warning {
  color: #f39c12;
}

.user-type-badge {
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 600;
}

.user-type-badge.customer {
  background-color: #e3f2fd;
  color: #1976d2;
}

.user-type-badge.merchant {
  background-color: #f3e5f5;
  color: #7b1fa2;
}

.status-badge {
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 600;
}

.status-badge.normal {
  background-color: #d4edda;
  color: #155724;
}

.status-badge.banned {
  background-color: #f8d7da;
  color: #721c24;
}

.status-badge.temporarily_banned {
  background-color: #fff3cd;
  color: #856404;
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

/* 表格容器 */
.table-container {
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
  scrollbar-width: thin;
  scrollbar-color: #ddd transparent;
  margin: -20px;
  padding: 20px;
}

.table-container::-webkit-scrollbar {
  height: 8px;
}

.table-container::-webkit-scrollbar-track {
  background: #f1f1f1;
}

.table-container::-webkit-scrollbar-thumb {
  background: #ddd;
  border-radius: 4px;
}

.table {
  width: 100%;
  min-width: 1200px;
  border-collapse: collapse;
}

.table th,
.table td {
  padding: clamp(8px, 1vw, 12px);
  text-align: left;
  border-bottom: 1px solid #eee;
  font-size: clamp(11px, 1.2vw, 14px);
  white-space: nowrap;
}

.table th {
  background-color: #f8f9fa;
  font-weight: 600;
  color: #333;
  position: sticky;
  top: 0;
  z-index: 10;
}

.table tbody tr:hover {
  background-color: #f8f9fa;
}

/* 按钮样式 */
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
  margin-right: clamp(4px, 0.6vw, 8px);
}

.btn-primary {
  background-color: #667eea;
  color: white;
}

.btn-primary:hover {
  background-color: #5a6fd8;
}

.btn-danger {
  background-color: #dc3545;
  color: white;
}

.btn-danger:hover {
  background-color: #c82333;
}

.btn-outline {
  background-color: transparent;
  border: 1px solid #667eea;
  color: #667eea;
}

.btn-outline:hover {
  background-color: #667eea;
  color: white;
}

.btn-secondary {
  background-color: #6c757d;
  color: white;
}

.btn-secondary:hover {
  background-color: #545b62;
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
  background: white;
  border-radius: 8px;
  max-width: min(600px, 95vw);
  width: 100%;
  max-height: min(80vh, 800px);
  overflow-y: auto;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: clamp(15px, 2vw, 20px);
  border-bottom: 1px solid #eee;
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
  color: #666;
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
  border-top: 1px solid #eee;
}

.form-group {
  margin-bottom: clamp(15px, 2vw, 20px);
}

.form-group label {
  display: block;
  margin-bottom: clamp(5px, 0.8vw, 8px);
  font-weight: 600;
  color: #333;
  font-size: clamp(12px, 1.2vw, 14px);
}

.form-control {
  width: 100%;
  padding: clamp(6px, 0.8vw, 8px) clamp(10px, 1.2vw, 12px);
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: clamp(12px, 1.2vw, 14px);
}

.form-control:focus {
  outline: none;
  border-color: #667eea;
  box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
}

.checkbox-label {
  display: flex;
  align-items: center;
  cursor: pointer;
}

.checkbox-label input[type="checkbox"] {
  margin-right: 8px;
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
  color: #555;
  margin-bottom: 5px;
  font-size: clamp(12px, 1.2vw, 14px);
}

.detail-item span {
  color: #333;
  font-size: clamp(12px, 1.2vw, 14px);
}

/* 状态标签响应式 */
.status-badge, .user-type-badge {
  padding: clamp(2px, 0.3vw, 4px) clamp(6px, 0.8vw, 10px);
  border-radius: 12px;
  font-size: clamp(9px, 1.1vw, 12px);
  font-weight: 600;
  display: inline-block;
  white-space: nowrap;
}

/* 加载状态 */
.loading-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.1);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1001;
}

.loading-spinner {
  background: white;
  padding: clamp(15px, 2vw, 20px);
  border-radius: 8px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  text-align: center;
  font-weight: 600;
  font-size: clamp(12px, 1.2vw, 14px);
}

/* 空状态 */
.empty-state {
  text-align: center;
  padding: clamp(30px, 4vw, 40px);
  color: #666;
  font-size: clamp(12px, 1.2vw, 14px);
}

/* 禁用状态样式 */
.search-input:disabled,
.filter-select:disabled,
.btn:disabled {
  background-color: #e9ecef;
  cursor: not-allowed;
  opacity: 0.6;
}

/* 卡片样式 */
.card {
  background: white;
  border-radius: 8px;
  padding: clamp(15px, 2vw, 20px);
  margin-bottom: clamp(15px, 2vw, 20px);
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.card h3 {
  margin-top: 0;
  margin-bottom: clamp(15px, 2vw, 20px);
  color: #333;
  font-size: clamp(16px, 2vw, 18px);
}

/* 复选框样式 */
.checkbox-label {
  display: flex;
  align-items: center;
  cursor: pointer;
  font-size: clamp(12px, 1.2vw, 14px);
}

.checkbox-label input[type="checkbox"] {
  margin-right: clamp(6px, 0.8vw, 10px);
  transform: scale(1.2);
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

  .table-container {
    margin: -10px;
    padding: 10px;
  }

  .detail-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 480px) {
  .account-ban {
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