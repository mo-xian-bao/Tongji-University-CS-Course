<template>
  <div class="table-management">
    <div class="page-header">
      <h2>桌位管理</h2>
      <button class="btn btn-primary" @click="showAddDialog">
        <i class="icon-plus">+</i> 添加桌位
      </button>
    </div>

    <!-- 统计卡片 -->
    <div class="stats-cards">
      <div class="stat-card">
        <div class="stat-label">总桌位数</div>
        <div class="stat-value">{{ statistics.total }}</div>
      </div>
      <div class="stat-card available">
        <div class="stat-label">可用桌位</div>
        <div class="stat-value">{{ statistics.available }}</div>
      </div>
      <div class="stat-card occupied">
        <div class="stat-label">使用中</div>
        <div class="stat-value">{{ statistics.occupied }}</div>
      </div>
      <div class="stat-card capacity">
        <div class="stat-label">总容纳人数</div>
        <div class="stat-value">{{ statistics.totalCapacity }}</div>
      </div>
    </div>

    <!-- 筛选器 -->
    <div class="filters">
      <div class="filter-group">
        <label>桌位状态:</label>
        <select v-model="filterStatus" @change="filterTables">
          <option value="">全部</option>
          <option value="available">可用</option>
          <option value="occupied">使用中</option>
          <option value="reserved">已预订</option>
          <option value="maintenance">维护中</option>
        </select>
      </div>
      <div class="filter-group">
        <label>桌位类型:</label>
        <select v-model="filterType" @change="filterTables">
          <option value="">全部</option>
          <option value="shared">可拼桌</option>
          <option value="private">独立桌</option>
        </select>
      </div>
      <div class="filter-group search">
        <input 
          v-model="searchKeyword" 
          @input="filterTables"
          placeholder="搜索桌号..."
          class="search-input"
        />
      </div>
    </div>

    <!-- 加载状态 -->
    <div v-if="loading" class="loading">
      <div class="spinner"></div>
      <p>加载中...</p>
    </div>

    <!-- 桌位列表 -->
    <div v-else-if="filteredTables.length > 0" class="table-list">
      <div class="table-grid">
        <div 
          v-for="table in filteredTables" 
          :key="table.id"
          class="table-card"
          :class="[
            `status-${table.status}`,
            table.current_occupancy > 0 ? 'has-customers' : ''
          ]"
        >
          <!-- 桌位头部 -->
          <div class="table-header">
            <div class="table-number">
              <span class="label">桌号</span>
              <span class="value">{{ table.table_number }}</span>
            </div>
            <div class="table-status">
              <span class="status-badge" :class="`status-${table.status}`">
                {{ getStatusText(table.status) }}
              </span>
            </div>
          </div>

          <!-- 桌位信息 -->
          <div class="table-body">
            <div class="info-row">
              <span class="label">容纳人数:</span>
              <span class="value">{{ table.capacity }}人</span>
            </div>
            <div class="info-row">
              <span class="label">桌位类型:</span>
              <span class="value">
                {{ table.table_type === 'shared' ? '可拼桌' : '独立桌' }}
              </span>
            </div>
            <div class="info-row">
              <span class="label">剩余可坐:</span>
              <span class="value" :class="{ 
                'seats-low': table.available_seats < 2 && table.available_seats > 0,
                'seats-full': table.available_seats === 0
              }">
                {{ table.available_seats }}人
              </span>
            </div>
            <div class="info-row" v-if="table.current_occupancy > 0">
              <span class="label">当前人数:</span>
              <span class="value highlight">
                {{ table.current_occupancy }}/{{ table.capacity }}人
              </span>
            </div>
            <!-- 今日预约数量 -->
            <div class="info-row" v-if="tableReservations[table.id] && tableReservations[table.id].length > 0">
              <span class="label">今日预约:</span>
              <span class="value reservation-count">
                {{ tableReservations[table.id].length }}单
              </span>
            </div>
            <div class="info-row" v-if="table.description">
              <span class="label">描述:</span>
              <span class="value description">{{ table.description }}</span>
            </div>
          </div>

          <!-- 操作按钮 -->
          <div class="table-actions">
            <button 
              class="btn btn-sm btn-info" 
              @click="viewTableDetails(table)"
              title="查看详情"
            >
              详情
            </button>
            <button 
              class="btn btn-sm btn-secondary" 
              @click="editTable(table)"
              title="编辑"
            >
              编辑
            </button>
            <button 
              class="btn btn-sm btn-danger" 
              @click="confirmDelete(table)"
              title="删除"
              :disabled="table.current_occupancy > 0"
            >
              删除
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- 空状态 -->
    <div v-else class="empty-state">
      <div class="empty-icon">🪑</div>
      <p>暂无桌位数据</p>
      <button class="btn btn-primary" @click="showAddDialog">
        添加第一个桌位
      </button>
    </div>

    <!-- 添加/编辑对话框 -->
    <div v-if="dialogVisible" class="dialog-overlay" @click.self="closeDialog">
      <div class="dialog">
        <div class="dialog-header">
          <h3>{{ isEditing ? '编辑桌位' : '添加桌位' }}</h3>
          <button class="close-btn" @click="closeDialog">×</button>
        </div>
        
        <div class="dialog-body">
          <div class="form-group">
            <label class="required">桌号</label>
            <input 
              v-model="formData.table_number" 
              placeholder="如: A1, 包厢1"
              class="form-control"
              maxlength="20"
            />
          </div>

          <div class="form-group">
            <label class="required">可容纳人数</label>
            <input 
              v-model.number="formData.capacity" 
              type="number"
              min="1"
              max="50"
              placeholder="如: 4"
              class="form-control"
            />
          </div>

          <div class="form-group">
            <label class="required">桌位类型</label>
            <div class="radio-group">
              <label class="radio-label">
                <input 
                  type="radio" 
                  v-model="formData.table_type" 
                  value="shared"
                />
                <span>可拼桌</span>
                <small>多组客人可共用</small>
              </label>
              <label class="radio-label">
                <input 
                  type="radio" 
                  v-model="formData.table_type" 
                  value="private"
                />
                <span>独立桌</span>
                <small>仅供一组客人使用</small>
              </label>
            </div>
          </div>

          <div class="form-group" v-if="isEditing">
            <label>桌位状态</label>
            <select v-model="formData.status" class="form-control">
              <option value="available">可用</option>
              <option value="occupied">使用中</option>
              <option value="reserved">已预订</option>
              <option value="maintenance">维护中</option>
            </select>
          </div>

          <div class="form-group">
            <label>桌位描述</label>
            <textarea 
              v-model="formData.description" 
              placeholder="如: 靠窗位置、包厢等"
              class="form-control"
              rows="3"
              maxlength="200"
            ></textarea>
            <small class="char-count">
              {{ formData.description?.length || 0 }}/200
            </small>
          </div>
        </div>

        <div class="dialog-footer">
          <button class="btn btn-secondary" @click="closeDialog">
            取消
          </button>
          <button 
            class="btn btn-primary" 
            @click="submitForm"
            :disabled="submitting"
          >
            {{ submitting ? '提交中...' : (isEditing ? '保存' : '添加') }}
          </button>
        </div>
      </div>
    </div>

    <!-- 详情对话框 -->
    <div v-if="detailDialogVisible" class="dialog-overlay" @click.self="closeDetailDialog">
      <div class="dialog dialog-large">
        <div class="dialog-header">
          <h3>桌位详情 - {{ currentTable?.table_number }}</h3>
          <button class="close-btn" @click="closeDetailDialog">×</button>
        </div>
        
        <div class="dialog-body" v-if="currentTable">
          <div class="detail-section">
            <h4>基本信息</h4>
            <div class="detail-grid">
              <div class="detail-item">
                <span class="label">桌号:</span>
                <span class="value">{{ currentTable.table_number }}</span>
              </div>
              <div class="detail-item">
                <span class="label">容纳人数:</span>
                <span class="value">{{ currentTable.capacity }}人</span>
              </div>
              <div class="detail-item">
                <span class="label">桌位类型:</span>
                <span class="value">
                  {{ currentTable.table_type === 'shared' ? '可拼桌' : '独立桌' }}
                </span>
              </div>
              <div class="detail-item">
                <span class="label">状态:</span>
                <span class="value">
                  <span class="status-badge" :class="`status-${currentTable.status}`">
                    {{ getStatusText(currentTable.status) }}
                  </span>
                </span>
              </div>
              <div class="detail-item" v-if="currentTable.description">
                <span class="label">描述:</span>
                <span class="value">{{ currentTable.description }}</span>
              </div>
              <div class="detail-item">
                <span class="label">当前使用:</span>
                <span class="value">
                  {{ currentTable.current_occupancy }}/{{ currentTable.capacity }}人
                </span>
              </div>
              <div class="detail-item">
                <span class="label">剩余可坐:</span>
                <span class="value" :class="{
                  'seats-low': currentTable.available_seats < 2 && currentTable.available_seats > 0,
                  'seats-full': currentTable.available_seats === 0
                }">
                  {{ currentTable.available_seats }}人
                </span>
              </div>
            </div>
          </div>

          <div class="detail-section" v-if="currentTable.active_orders && currentTable.active_orders.length > 0">
            <h4>当前订单</h4>
            <div class="orders-list">
              <div 
                v-for="order in currentTable.active_orders" 
                :key="order.id"
                class="order-item"
              >
                <div class="order-info">
                  <span class="order-number">{{ order.order_number }}</span>
                  <span class="order-time">{{ formatTime(order.order_time) }}</span>
                </div>
                <div class="order-details">
                  <span>{{ order.customer_count }}人</span>
                  <span class="order-status">{{ getOrderStatusText(order.status) }}</span>
                </div>
              </div>
            </div>
          </div>
          <div v-else class="detail-section">
            <p class="no-orders">当前无订单</p>
          </div>

          <!-- 预约时间表 -->
          <div class="detail-section">
            <div class="section-header">
              <h4>📅 预约时间表</h4>
              <div class="date-selector">
                <button class="date-nav-btn" @click="changeScheduleDate(-1)">◀</button>
                <span class="current-date">{{ formatScheduleDate(scheduleDate) }}</span>
                <button class="date-nav-btn" @click="changeScheduleDate(1)">▶</button>
              </div>
            </div>
            <div v-if="loadingSchedule" class="loading-schedule">
              加载中...
            </div>
            <div v-else-if="tableSchedule.length > 0" class="schedule-timeline">
              <div 
                v-for="(reservation, index) in tableSchedule" 
                :key="index"
                class="schedule-item"
                :class="'status-' + reservation.reservation_status"
              >
                <div class="schedule-time">
                  <span class="time-start">{{ formatTimeOnly(reservation.reserved_time) }}</span>
                  <span class="time-separator">-</span>
                  <span class="time-end">{{ formatTimeOnly(reservation.reserved_end_time) }}</span>
                </div>
                <div class="schedule-info">
                  <span class="order-num">订单号: {{ reservation.order_number }}</span>
                  <span class="customer-count">{{ reservation.customer_count }}人</span>
                  <span class="schedule-status" :class="'status-' + reservation.reservation_status">
                    {{ getReservationStatusText(reservation.reservation_status) }}
                  </span>
                </div>
              </div>
            </div>
            <div v-else class="no-schedule">
              <p>该日期暂无预约</p>
            </div>
          </div>
        </div>

        <div class="dialog-footer">
          <button class="btn btn-secondary" @click="closeDetailDialog">
            关闭
          </button>
        </div>
      </div>
    </div>

    <!-- 提示消息 -->
    <div v-if="message.show" class="toast" :class="message.type">
      {{ message.text }}
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'TableManagement',
  data() {
    return {
      API_BASE_URL: API_url,
      loading: false,
      tables: [],
      filteredTables: [],
      filterStatus: '',
      filterType: '',
      searchKeyword: '',
      
      dialogVisible: false,
      detailDialogVisible: false,
      isEditing: false,
      submitting: false,
      currentTable: null,
      
      // 预约相关
      tableReservations: {},  // 各桌位的今日预约
      tableSchedule: [],      // 当前查看桌位的预约时间表
      scheduleDate: new Date().toISOString().split('T')[0],  // 预约时间表日期
      loadingSchedule: false,
      
      formData: {
        table_number: '',
        capacity: 4,
        table_type: 'shared',
        status: 'available',
        description: ''
      },
      
      message: {
        show: false,
        type: 'success',
        text: ''
      }
    };
  },
  
  computed: {
    statistics() {
      const stats = {
        total: this.tables.length,
        available: 0,
        occupied: 0,
        totalCapacity: 0
      };
      
      this.tables.forEach(table => {
        if (table.status === 'available') stats.available++;
        if (table.status === 'occupied' || table.current_occupancy > 0) stats.occupied++;
        stats.totalCapacity += table.capacity;
      });
      
      return stats;
    }
  },
  
  mounted() {
    this.loadTables();
    this.loadAllTableReservations();
  },
  
  methods: {
    async loadTables() {
      this.loading = true;
      try {
        const token = localStorage.getItem('token');
        const response = await axios.get(`${this.API_BASE_URL}/api/tables`, {
          headers: { Authorization: `Bearer ${token}` }
        });
        
        // 修改响应数据的解析方式
        if (response.data.success !== false) {
          this.tables = response.data.tables || [];  
          this.filteredTables = [...this.tables];
        } else {
          this.showMessage('加载失败: ' + response.data.message, 'error');
        }
      } catch (error) {
        console.error('加载桌位列表失败:', error);
        this.showMessage(error.response?.data?.message || '加载失败,请稍后重试', 'error');
      } finally {
        this.loading = false;
      }
    },
    
    filterTables() {
      let filtered = [...this.tables];
      
      // 状态筛选
      if (this.filterStatus) {
        filtered = filtered.filter(t => t.status === this.filterStatus);
      }
      
      // 类型筛选
      if (this.filterType) {
        filtered = filtered.filter(t => t.table_type === this.filterType);
      }
      
      // 搜索
      if (this.searchKeyword) {
        const keyword = this.searchKeyword.toLowerCase();
        filtered = filtered.filter(t => 
          t.table_number.toLowerCase().includes(keyword)
        );
      }
      
      this.filteredTables = filtered;
    },
    
    showAddDialog() {
      this.isEditing = false;
      this.formData = {
        table_number: '',
        capacity: 4,
        table_type: 'shared',
        status: 'available',
        description: ''
      };
      this.dialogVisible = true;
    },
    
    editTable(table) {
      this.isEditing = true;
      this.currentTable = table;
      this.formData = {
        table_number: table.table_number,
        capacity: table.capacity,
        table_type: table.table_type,
        status: table.status,
        description: table.description || ''
      };
      this.dialogVisible = true;
    },
    
    async submitForm() {
      // 验证
      if (!this.formData.table_number || !this.formData.capacity) {
        this.showMessage('请填写完整信息', 'error');
        return;
      }
      
      if (this.formData.capacity < 1 || this.formData.capacity > 50) {
        this.showMessage('容纳人数必须在1-50之间', 'error');
        return;
      }
      
      this.submitting = true;
      try {
        const token = localStorage.getItem('token');
        const config = {
          headers: { Authorization: `Bearer ${token}` }
        };
        
        let response;
        if (this.isEditing) {
          response = await axios.put(
            `${this.API_BASE_URL}/api/tables/${this.currentTable.id}`,
            this.formData,
            config
          );
        } else {
          response = await axios.post(`${this.API_BASE_URL}/api/tables`, this.formData, config);
        }
        
        if (response.data.success) {
          this.showMessage(
            this.isEditing ? '桌位更新成功' : '桌位添加成功',
            'success'
          );
          this.closeDialog();
          this.loadTables();
        } else {
          this.showMessage(response.data.message, 'error');
        }
      } catch (error) {
        console.error('提交失败:', error);
        this.showMessage(error.response?.data?.message || '操作失败,请稍后重试', 'error');
      } finally {
        this.submitting = false;
      }
    },
    
    confirmDelete(table) {
      if (table.current_occupancy > 0) {
        this.showMessage('该桌位有客人使用中,无法删除', 'error');
        return;
      }
      
      if (confirm(`确定要删除桌位 ${table.table_number} 吗?`)) {
        this.deleteTable(table.id);
      }
    },
    
    async deleteTable(tableId) {
      try {
        const token = localStorage.getItem('token');
        const response = await axios.delete(`${this.API_BASE_URL}/api/tables/${tableId}`, {
          headers: { Authorization: `Bearer ${token}` }
        });
        
        if (response.data.success) {
          this.showMessage('桌位删除成功', 'success');
          this.loadTables();
        } else {
          this.showMessage(response.data.message, 'error');
        }
      } catch (error) {
        console.error('删除失败:', error);
        this.showMessage(error.response?.data?.message || '删除失败,请稍后重试', 'error');
      }
    },
    
    async viewTableDetails(table) {
      try {
        const token = localStorage.getItem('token');
        // ✅ 添加 token 和修改响应解析
        const response = await axios.get(`${this.API_BASE_URL}/api/tables/${table.id}`, {
          headers: { Authorization: `Bearer ${token}` }
        });
        
        if (response.data.success !== false) {
          this.currentTable = response.data.table || table;  // 直接取 table，不是 data.table
          this.detailDialogVisible = true;
          // 加载该桌位的预约时间表
          this.scheduleDate = new Date().toISOString().split('T')[0];
          this.loadTableSchedule(table.id);
        }
      } catch (error) {
        console.error('获取详情失败:', error);
        this.showMessage(error.response?.data?.message || '获取详情失败', 'error');
      }
    },
    
    closeDialog() {
      this.dialogVisible = false;
      this.currentTable = null;
    },
    
    closeDetailDialog() {
      this.detailDialogVisible = false;
      this.currentTable = null;
    },
    
    showMessage(text, type = 'success') {
      this.message = { show: true, text, type };
      setTimeout(() => {
        this.message.show = false;
      }, 3000);
    },
    
    getStatusText(status) {
      const statusMap = {
        available: '可用',
        occupied: '使用中',
        reserved: '已预订',
        maintenance: '维护中'
      };
      return statusMap[status] || status;
    },
    
    getOrderStatusText(status) {
      const statusMap = {
        pending: '待确认',
        confirmed: '已确认',
        dining: '用餐中',
        completed: '已完成',
        cancelled: '已取消'
      };
      return statusMap[status] || status;
    },
    
    formatTime(timeStr) {
      if (!timeStr) return '';
      const date = new Date(timeStr);
      return date.toLocaleString('zh-CN', {
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit'
      });
    },
    
    // 加载所有桌位的今日预约
    async loadAllTableReservations() {
      try {
        const token = localStorage.getItem('token');
        const today = new Date().toISOString().split('T')[0];
        const response = await axios.get(`${this.API_BASE_URL}/api/merchant/reservations`, {
          headers: { Authorization: `Bearer ${token}` },
          params: { date: today }
        });
        
        if (response.data.success) {
          // 按桌位分组
          const reservations = response.data.data?.reservations || response.data.data || [];
          const grouped = {};
          reservations.forEach(r => {
            if (r.table_id) {
              if (!grouped[r.table_id]) {
                grouped[r.table_id] = [];
              }
              grouped[r.table_id].push(r);
            }
          });
          this.tableReservations = grouped;
        }
      } catch (error) {
        console.error('加载预约数据失败:', error);
      }
    },
    
    // 加载指定桌位的预约时间表
    async loadTableSchedule(tableId) {
      this.loadingSchedule = true;
      this.tableSchedule = [];
      try {
        const token = localStorage.getItem('token');
        const response = await axios.get(
          `${this.API_BASE_URL}/api/merchant/tables/${tableId}/schedule`,
          {
            headers: { Authorization: `Bearer ${token}` },
            params: { date: this.scheduleDate }
          }
        );
        
        if (response.data.success) {
          this.tableSchedule = response.data.data?.schedule || response.data.data || [];
        }
      } catch (error) {
        console.error('加载预约时间表失败:', error);
      } finally {
        this.loadingSchedule = false;
      }
    },
    
    // 切换预约时间表日期
    changeScheduleDate(delta) {
      const date = new Date(this.scheduleDate);
      date.setDate(date.getDate() + delta);
      this.scheduleDate = date.toISOString().split('T')[0];
      if (this.currentTable) {
        this.loadTableSchedule(this.currentTable.id);
      }
    },
    
    // 格式化预约时间表日期显示
    formatScheduleDate(dateStr) {
      const date = new Date(dateStr);
      const today = new Date();
      const tomorrow = new Date(today);
      tomorrow.setDate(tomorrow.getDate() + 1);
      
      if (dateStr === today.toISOString().split('T')[0]) {
        return '今天';
      } else if (dateStr === tomorrow.toISOString().split('T')[0]) {
        return '明天';
      }
      
      return date.toLocaleDateString('zh-CN', {
        month: 'long',
        day: 'numeric',
        weekday: 'short'
      });
    },
    
    // 格式化时间（仅显示时分）
    formatTimeOnly(timeStr) {
      if (!timeStr) return '';
      const date = new Date(timeStr);
      return date.toLocaleTimeString('zh-CN', {
        hour: '2-digit',
        minute: '2-digit',
        hour12: false
      });
    },
    
    // 预约状态文本
    getReservationStatusText(status) {
      const statusMap = {
        'pending': '待确认',
        'confirmed': '已确认',
        'seated': '已入座',
        'completed': '已完成',
        'cancelled': '已取消',
        'no_show': '未到店'
      };
      return statusMap[status] || status;
    }
  }
};
</script>

<style scoped>
.table-management {
  max-width: 1400px;
  margin: 0 auto;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.page-header h2 {
  margin: 0;
  font-size: 24px;
  color: #333;
}

/* 统计卡片 */
.stats-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 16px;
  margin-bottom: 24px;
}

.stat-card {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  border-left: 4px solid #3498db;
}

.stat-card.available {
  border-left-color: #2ecc71;
}

.stat-card.occupied {
  border-left-color: #e74c3c;
}

.stat-card.capacity {
  border-left-color: #9b59b6;
}

.stat-label {
  font-size: 14px;
  color: #666;
  margin-bottom: 8px;
}

.stat-value {
  font-size: 32px;
  font-weight: bold;
  color: #333;
}

/* 筛选器 */
.filters {
  display: flex;
  gap: 16px;
  margin-bottom: 24px;
  flex-wrap: wrap;
}

.filter-group {
  display: flex;
  align-items: center;
  gap: 8px;
}

.filter-group label {
  font-size: 14px;
  color: #666;
}

.filter-group select,
.search-input {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.filter-group.search {
  flex: 1;
  min-width: 200px;
}

.search-input {
  width: 100%;
}

/* 桌位卡片网格 */
.table-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 16px;
}

.table-card {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  overflow: hidden;
  transition: transform 0.2s, box-shadow 0.2s;
  border-left: 4px solid #3498db;
}

.table-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}

.table-card.status-available {
  border-left-color: #2ecc71;
}

.table-card.status-occupied {
  border-left-color: #e74c3c;
}

.table-card.status-reserved {
  border-left-color: #f39c12;
}

.table-card.status-maintenance {
  border-left-color: #95a5a6;
}

.table-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
  background: #f8f9fa;
  border-bottom: 1px solid #e9ecef;
}

.table-number .label {
  font-size: 12px;
  color: #666;
  display: block;
}

.table-number .value {
  font-size: 20px;
  font-weight: bold;
  color: #333;
}

.status-badge {
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}

.status-badge.status-available {
  background: #d4edda;
  color: #155724;
}

.status-badge.status-occupied {
  background: #f8d7da;
  color: #721c24;
}

.status-badge.status-reserved {
  background: #fff3cd;
  color: #856404;
}

.status-badge.status-maintenance {
  background: #d6d8db;
  color: #383d41;
}

.table-body {
  padding: 16px;
}

.info-row {
  display: flex;
  justify-content: space-between;
  padding: 8px 0;
  border-bottom: 1px solid #f0f0f0;
}

.info-row:last-child {
  border-bottom: none;
}

.info-row .label {
  font-size: 14px;
  color: #666;
}

.info-row .value {
  font-size: 14px;
  color: #333;
  font-weight: 500;
}

.info-row .value.highlight {
  color: #e74c3c;
  font-weight: bold;
}

.info-row .value.seats-low {
  color: #f39c12;
  font-weight: bold;
}

.info-row .value.seats-full {
  color: #e74c3c;
  font-weight: bold;
}

.info-row .value.description {
  font-weight: normal;
  font-style: italic;
}

.table-actions {
  display: flex;
  gap: 8px;
  padding: 12px 16px;
  background: #f8f9fa;
  border-top: 1px solid #e9ecef;
}

/* 按钮样式 */
.btn {
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-primary {
  background: #3498db;
  color: white;
}

.btn-primary:hover {
  background: #2980b9;
}

.btn-secondary {
  background: #95a5a6;
  color: white;
}

.btn-secondary:hover {
  background: #7f8c8d;
}

.btn-danger {
  background: #e74c3c;
  color: white;
}

.btn-danger:hover {
  background: #c0392b;
}

.btn-danger:disabled {
  background: #ccc;
  cursor: not-allowed;
}

.btn-info {
  background: #3498db;
  color: white;
}

.btn-sm {
  padding: 6px 12px;
  font-size: 13px;
  flex: 1;
}

/* 对话框 */
.dialog-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0,0,0,0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.dialog {
  background: white;
  border-radius: 8px;
  width: 90%;
  max-width: 500px;
  max-height: 90vh;
  overflow: auto;
  box-shadow: 0 4px 20px rgba(0,0,0,0.3);
}

.dialog-large {
  max-width: 700px;
}

.dialog-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #e9ecef;
}

.dialog-header h3 {
  margin: 0;
  font-size: 18px;
}

.close-btn {
  background: none;
  border: none;
  font-size: 28px;
  cursor: pointer;
  color: #999;
  line-height: 1;
  padding: 0;
  width: 30px;
  height: 30px;
}

.close-btn:hover {
  color: #333;
}

.dialog-body {
  padding: 20px;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  font-size: 14px;
  font-weight: 500;
  color: #333;
}

.form-group label.required::after {
  content: ' *';
  color: #e74c3c;
}

.form-control {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  box-sizing: border-box;
}

.form-control:focus {
  outline: none;
  border-color: #3498db;
}

.radio-group {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.radio-label {
  display: flex;
  align-items: flex-start;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.2s;
}

.radio-label:hover {
  border-color: #3498db;
  background: #f8f9fa;
}

.radio-label input[type="radio"] {
  margin-right: 12px;
  margin-top: 2px;
}

.radio-label span {
  font-size: 14px;
  font-weight: 500;
}

.radio-label small {
  display: block;
  font-size: 12px;
  color: #666;
  margin-top: 4px;
}

.char-count {
  display: block;
  text-align: right;
  font-size: 12px;
  color: #999;
  margin-top: 4px;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  padding: 20px;
  border-top: 1px solid #e9ecef;
}

/* 详情页面 */
.detail-section {
  margin-bottom: 24px;
}

.detail-section h4 {
  margin: 0 0 16px 0;
  font-size: 16px;
  color: #333;
}

.detail-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 16px;
}

.detail-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.detail-item .label {
  font-size: 12px;
  color: #666;
}

.detail-item .value {
  font-size: 14px;
  color: #333;
  font-weight: 500;
}

.detail-item .value.seats-low {
  color: #f39c12;
  font-weight: bold;
}

.detail-item .value.seats-full {
  color: #e74c3c;
  font-weight: bold;
}

.orders-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.order-item {
  padding: 12px;
  background: #f8f9fa;
  border-radius: 4px;
  border-left: 3px solid #3498db;
}

.order-info {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
}

.order-number {
  font-weight: bold;
  color: #333;
}

.order-time {
  font-size: 12px;
  color: #666;
}

.order-details {
  display: flex;
  justify-content: space-between;
  font-size: 14px;
}

.order-status {
  color: #3498db;
  font-weight: 500;
}

.no-orders {
  text-align: center;
  color: #999;
  padding: 20px;
}

/* 空状态 */
.empty-state {
  text-align: center;
  padding: 60px 20px;
}

.empty-icon {
  font-size: 64px;
  margin-bottom: 16px;
}

/* 加载状态 */
.loading {
  text-align: center;
  padding: 60px 20px;
}

.spinner {
  width: 40px;
  height: 40px;
  margin: 0 auto 16px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #3498db;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* 提示消息 */
.toast {
  position: fixed;
  top: 20px;
  right: 20px;
  padding: 16px 24px;
  border-radius: 4px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  z-index: 2000;
  animation: slideIn 0.3s ease;
}

.toast.success {
  background: #2ecc71;
  color: white;
}

.toast.error {
  background: #e74c3c;
  color: white;
}

@keyframes slideIn {
  from {
    transform: translateX(100%);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}

@media (max-width: 768px) {
  .table-grid {
    grid-template-columns: 1fr;
  }
  
  .stats-cards {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .filters {
    flex-direction: column;
  }
}

/* 预约数量标识 */
.reservation-count {
  color: #e67e22;
  font-weight: 600;
}

/* 预约时间表样式 */
.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.section-header h4 {
  margin: 0;
}

.date-selector {
  display: flex;
  align-items: center;
  gap: 8px;
}

.date-nav-btn {
  background: #f0f0f0;
  border: none;
  padding: 4px 10px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12px;
}

.date-nav-btn:hover {
  background: #e0e0e0;
}

.current-date {
  font-weight: 500;
  min-width: 80px;
  text-align: center;
}

.loading-schedule {
  text-align: center;
  color: #999;
  padding: 20px;
}

.schedule-timeline {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.schedule-item {
  display: flex;
  align-items: center;
  padding: 10px 12px;
  background: #f8f9fa;
  border-radius: 6px;
  border-left: 3px solid #3498db;
}

.schedule-item.status-pending {
  border-left-color: #f39c12;
  background: #fff8e6;
}

.schedule-item.status-confirmed {
  border-left-color: #2ecc71;
  background: #e8f8ef;
}

.schedule-item.status-seated {
  border-left-color: #9b59b6;
  background: #f5eef8;
}

.schedule-item.status-completed {
  border-left-color: #95a5a6;
  background: #f0f0f0;
}

.schedule-item.status-cancelled,
.schedule-item.status-no_show {
  border-left-color: #e74c3c;
  background: #fdf2f2;
  opacity: 0.7;
}

.schedule-time {
  display: flex;
  align-items: center;
  gap: 4px;
  font-weight: 600;
  color: #333;
  min-width: 100px;
}

.time-separator {
  color: #999;
}

.schedule-info {
  display: flex;
  align-items: center;
  gap: 12px;
  flex: 1;
  margin-left: 16px;
}

.order-num {
  color: #666;
  font-size: 13px;
}

.customer-count {
  background: #e0e0e0;
  padding: 2px 8px;
  border-radius: 10px;
  font-size: 12px;
}

.schedule-status {
  font-size: 12px;
  padding: 2px 8px;
  border-radius: 10px;
}

.schedule-status.status-pending {
  background: #f39c12;
  color: white;
}

.schedule-status.status-confirmed {
  background: #2ecc71;
  color: white;
}

.schedule-status.status-seated {
  background: #9b59b6;
  color: white;
}

.schedule-status.status-completed {
  background: #95a5a6;
  color: white;
}

.schedule-status.status-cancelled,
.schedule-status.status-no_show {
  background: #e74c3c;
  color: white;
}

.no-schedule {
  text-align: center;
  color: #999;
  padding: 20px;
  background: #f8f9fa;
  border-radius: 6px;
}

.no-schedule p {
  margin: 0;
}
</style>