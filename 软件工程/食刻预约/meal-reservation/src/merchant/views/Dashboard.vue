<template>
  <div class="dashboard-container">
    <div class="header-section">
      <h2>仪表盘</h2>
      <p class="subtitle">欢迎回来! 以下是今天的营业概况</p>
    </div>

    <!-- KPI Cards -->
    <div class="kpi-grid">
      <div class="kpi-card">
        <div class="kpi-icon icon-blue">
          🛒
        </div>
        <div class="kpi-content">
          <div class="kpi-label">今日订单</div>
          <div class="kpi-value">{{ todayStats.total_orders }}</div>
        </div>
        <div class="kpi-trend" :class="todayStats.orders_growth >= 0 ? 'trend-up' : 'trend-down'">
          <span v-if="todayStats.orders_growth > 0">↑</span>
          <span v-else>↓</span>
          {{ Math.abs(todayStats.orders_growth) }}%
        </div>
      </div>

      <div class="kpi-card">
        <div class="kpi-icon icon-green">
          💰
        </div>
        <div class="kpi-content">
          <div class="kpi-label">今日营业额</div>
          <div class="kpi-value">¥{{ todayStats.total_revenue }}</div>
        </div>
        <div class="kpi-trend" :class="todayStats.revenue_growth >= 0 ? 'trend-up' : 'trend-down'">
          <span v-if="todayStats.revenue_growth > 0">↑</span>
          <span v-else>↓</span>
          {{ Math.abs(todayStats.revenue_growth) }}%
        </div>
      </div>

      <div class="kpi-card">
        <div class="kpi-icon icon-orange">
          👥
        </div>
        <div class="kpi-content">
          <div class="kpi-label">活跃桌位</div>
          <div class="kpi-value">{{ activeTables }}/{{ totalTables }}</div>
        </div>
        <div class="kpi-trend trend-up">
          <span>↑</span> {{ tableUsageRate }}%
        </div>
      </div>

      <div class="kpi-card">
        <div class="kpi-icon icon-red">
          ⏰
        </div>
        <div class="kpi-content">
          <div class="kpi-label">待处理订单</div>
          <div class="kpi-value">{{ pendingCount }}</div>
        </div>
        <div class="kpi-trend trend-down">
          <span>-</span>
        </div>
      </div>
    </div>

    <!-- Order Status Stats -->
    <div class="status-bar card">
      <div class="status-title">订单状态统计</div>
      <div class="status-items">
        <div class="status-item">
          <div class="status-icon icon-check">✓</div>
          <div class="status-info">
            <div class="status-count">{{ statusCounts.completed }}</div>
            <div class="status-label">已完成订单</div>
          </div>
        </div>
        <div class="status-item">
          <div class="status-icon icon-clock">🕒</div>
          <div class="status-info">
            <div class="status-count">{{ statusCounts.processing }}</div>
            <div class="status-label">处理中订单</div>
          </div>
        </div>
        <div class="status-item">
          <div class="status-icon icon-warn">!</div>
          <div class="status-info">
            <div class="status-count">{{ statusCounts.cancelled }}</div>
            <div class="status-label">取消订单</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Charts Row -->
    <div class="charts-grid">
      <div class="chart-card card">
        <div class="card-header">
          <h3>订单趋势</h3>
          <span class="card-subtitle">今日每小时订单数量</span>
        </div>
        <div class="chart-container">
          <v-chart class="chart" :option="hourlyOrderOption" autoresize />
        </div>
      </div>
      <div class="chart-card card">
        <div class="card-header">
          <h3>营业额趋势</h3>
          <span class="card-subtitle">本周每日营业额 (元)</span>
        </div>
        <div class="chart-container">
          <v-chart class="chart" :option="weeklyRevenueOption" autoresize />
        </div>
      </div>
    </div>

    <!-- Bottom Row: Hot Dishes & Tables -->
    <div class="bottom-grid">
      <!-- Hot Dishes -->
      <div class="hot-dishes card">
        <div class="card-header">
          <h3>热门菜品</h3>
          <span class="card-subtitle">今日销量排行</span>
          <span class="fire-icon">🔥</span>
        </div>
        <div class="dish-list">
          <div v-for="(dish, index) in topDishes" :key="dish.dish_id" class="dish-item">
            <div class="dish-rank" :class="'rank-' + (index + 1)">{{ index + 1 }}</div>
            <div class="dish-info">
              <div class="dish-name">{{ dish.dish_name }}</div>
              <div class="dish-sales">销量: {{ dish.sales_count }}</div>
            </div>
            <div class="dish-trend trend-up">
              <span>↗</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Table Status -->
      <div class="table-status card">
        <div class="card-header">
          <h3>桌位状态</h3>
          <span class="card-subtitle">实时桌位使用情况</span>
          <span class="table-icon">🪑</span>
        </div>
        <div class="table-summary">
          <div class="summary-item"><span class="dot available"></span>可用 <span class="val">{{ availableTables }}</span></div>
          <div class="summary-item"><span class="dot occupied"></span>使用中 <span class="val">{{ activeTables }}</span></div>
          <div class="summary-item"><span class="dot total"></span>总计 <span class="val">{{ totalTables }}</span></div>
        </div>
        <div class="table-grid">
          <div v-for="table in tables" :key="table.id" class="table-box" :class="table.status">
            <div class="table-name">{{ table.table_number }}</div>
            <div class="table-cap">{{ table.status === 'occupied' ? '使用中' : '可用' }}</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Recent Orders -->
    <div class="recent-orders card">
      <div class="card-header">
        <h3>最近订单</h3>
        <span class="card-subtitle">最新的订单记录</span>
      </div>
      <div class="table-responsive">
        <table class="custom-table">
          <thead>
            <tr>
              <th>订单号</th>
              <th>顾客</th>
              <th>人数</th>
              <th>时间</th>
              <th>类型</th>
              <th>状态</th>
              <th>金额</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="order in recentOrders" :key="order.id">
              <td>{{ order.order_number || order.id }}</td>
              <td>{{ order.user_name || '顾客' }}</td>
              <td>{{ order.customer_count || 1 }}人</td>
              <td>{{ formatDate(order.order_time) }}</td>
              <td>
                <span class="badge type-badge">{{ order.order_type === 'dinein' ? '堂食' : '外带' }}</span>
              </td>
              <td>
                <span class="badge status-badge" :class="getStatusClass(order.status)">
                  {{ getStatusText(order.status) }}
                </span>
              </td>
              <td class="price">¥{{ order.total_price }}</td>
              <td>
                <button class="action-btn" @click="viewOrder(order.id)">
                  👁️
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
import { use } from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { LineChart, BarChart } from 'echarts/charts'
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
} from 'echarts/components'
import VChart from 'vue-echarts'

use([
  CanvasRenderer,
  LineChart,
  BarChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
])

export default {
  name: 'Dashboard',
  components: {
    VChart
  },
  data() {
    return {
      todayStats: {
        total_orders: 0,
        total_revenue: 0,
        orders_growth: 0,
        revenue_growth: 0
      },
      pendingCount: 0,
      statusCounts: {
        completed: 0,
        processing: 0,
        cancelled: 0
      },
      tables: [],
      topDishes: [],
      recentOrders: [],
      hourlyOrderOption: {},
      weeklyRevenueOption: {},
      timer: null
    }
  },
  computed: {
    totalTables() {
      return this.tables.length
    },
    activeTables() {
      return this.tables.filter(t => t.status === 'occupied').length
    },
    availableTables() {
      return this.tables.filter(t => t.status === 'available').length
    },
    tableUsageRate() {
      if (this.totalTables === 0) return 0
      return Math.round((this.activeTables / this.totalTables) * 100)
    }
  },
  mounted() {
    this.fetchAllData()
    // Refresh every 30 seconds
    this.timer = setInterval(this.fetchAllData, 30000)
  },
  beforeUnmount() {
    if (this.timer) clearInterval(this.timer)
  },
  methods: {
    async fetchWithAuth(url, params = {}) {
      const token = localStorage.getItem('token')
      const headers = {
        'Content-Type': 'application/json'
      }
      if (token) {
        headers['Authorization'] = `Bearer ${token}`
      }

      const queryString = new URLSearchParams(params).toString()
      const fullUrl = queryString ? `${url}?${queryString}` : url

      const res = await fetch(fullUrl, {
        method: 'GET',
        headers
      })

      if (!res.ok) {
        throw new Error(`HTTP error! status: ${res.status}`)
      }
      return await res.json()
    },

    async fetchAllData() {
      try {
        const tz = Intl.DateTimeFormat().resolvedOptions().timeZone
        const now = new Date()
        const offset = now.getTimezoneOffset() * 60000
        
        const toLocalISO = (date) => new Date(date.getTime() - offset).toISOString().slice(0, 19)

        const startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 0, 0, 0)
        const startOf5Days = new Date(now.getFullYear(), now.getMonth(), now.getDate() - 4, 0, 0, 0)

        const todayStart = toLocalISO(startOfDay)
        const todayEnd = toLocalISO(now)
        const trendStart = toLocalISO(startOf5Days)
        const todayDateStr = toLocalISO(now).split('T')[0] // YYYY-MM-DD for filtering

        // 1. Fetch Overview (Today)
        const overviewData = await this.fetchWithAuth('/api/merchant/statistics/overview', {
          start_date: todayStart, 
          end_date: todayEnd, 
          timezone: tz 
        })
        if (overviewData.success) {
          this.todayStats = overviewData.data
        }

        // 2. Fetch Tables
        const tablesData = await this.fetchWithAuth('/api/tables')
        if (tablesData) {
          // tablesData might be the array directly or { success: true, data: ... } depending on API
          // Based on previous axios usage: if (tablesRes.data) this.tables = tablesRes.data
          // If API returns list directly: tablesData is the list.
          this.tables = Array.isArray(tablesData) ? tablesData : (tablesData.tables || [])
          console.log('Fetched tables:', this.tables)
        }

        // 3. Fetch Recent Orders (for list and status counts)
        const ordersData = await this.fetchWithAuth('/api/merchant/orders')
        if (ordersData.success) {
          const allOrders = ordersData.data // API returns list directly in data
          this.recentOrders = allOrders.slice(0, 5) // Top 5 for list
          
          // Calculate pending count (all time or recent)
          this.pendingCount = allOrders.filter(o => ['pending', 'confirmed'].includes(o.status)).length

          // Filter for today's orders for status counts
          const todayOrders = allOrders.filter(o => o.order_time && o.order_time.startsWith(todayDateStr))
          
          this.statusCounts = {
            completed: todayOrders.filter(o => o.status === 'completed').length,
            processing: todayOrders.filter(o => ['processing', 'confirmed', 'cooking'].includes(o.status)).length,
            cancelled: todayOrders.filter(o => ['cancelled', 'rejected'].includes(o.status)).length
          }
        }

        // 4. Fetch Hourly Orders (Today)
        const hourlyData = await this.fetchWithAuth('/api/merchant/statistics/peak-hours', {
          start_date: todayStart, 
          end_date: todayEnd, 
          timezone: tz 
        })
        if (hourlyData.success) {
          this.updateHourlyChart(hourlyData.data.peak_hours)
        }

        // 5. Fetch Weekly Revenue (Trend)
        const trendData = await this.fetchWithAuth('/api/merchant/statistics/trend', {
          start_date: trendStart, 
          end_date: todayEnd, 
          timezone: tz 
        })
        if (trendData.success) {
          this.updateWeeklyChart(trendData.data.trend)
        }

        // 6. Fetch Top Dishes (Today)
        const dishesData = await this.fetchWithAuth('/api/merchant/statistics/top-dishes', {
          start_date: todayStart, 
          end_date: todayEnd, 
          limit: 5, 
          timezone: tz 
        })
        if (dishesData.success) {
          this.topDishes = dishesData.data.top_dishes
        }

      } catch (error) {
        console.error('Failed to fetch dashboard data:', error)
      }
    },
    updateHourlyChart(data) {
      const hours = data.map(item => item.hour)
      const counts = data.map(item => item.order_count)

      // 打印映射结果，便于调试（仅开发环境）
      // try {
      //   if (typeof import.meta !== 'undefined' && import.meta.env && import.meta.env.DEV) {
      //     console.log('[Dashboard] peak-hours raw:', data)
      //     console.log('[Dashboard] peak-hours mapped hours:', hours)
      //     console.log('[Dashboard] peak-hours mapped counts:', counts)
      //     if (Array.isArray(data)) {
      //       console.table(data.map((item, idx) => ({ idx, hour: item.hour, order_count: item.order_count })))
      //     }
      //   }
      // } catch (e) {}
      
      this.hourlyOrderOption = {
        tooltip: { trigger: 'axis' },
        grid: { top: '10%', left: '3%', right: '4%', bottom: '3%', containLabel: true },
        xAxis: { type: 'category', boundaryGap: false, data: hours },
        yAxis: { type: 'value' },
        series: [{
          name: '订单量',
          type: 'line',
          smooth: true,
          data: counts,
          areaStyle: { color: 'rgba(255, 136, 0, 0.2)' },
          itemStyle: { color: '#ff8800' },
          lineStyle: { color: '#ff8800' }
        }]
      }
    },
    updateWeeklyChart(data) {
      const now = new Date()
      const offset = now.getTimezoneOffset() * 60000
      const todayStr = new Date(now.getTime() - offset).toISOString().slice(5, 10) // MM-DD
      
      const dates = data.map(item => {
        const dateStr = item.date.slice(5)
        if (dateStr === todayStr) {
          return {
            value: dateStr,
            textStyle: {
              fontWeight: 'bold',
              color: '#1890ff',
              fontSize: 14
            }
          }
        }
        return dateStr
      })
      const revenues = data.map(item => item.revenue)

      this.weeklyRevenueOption = {
        tooltip: { trigger: 'axis' },
        grid: { top: '10%', left: '3%', right: '4%', bottom: '3%', containLabel: true },
        xAxis: { type: 'category', data: dates },
        yAxis: { type: 'value' },
        series: [{
          name: '营业额',
          type: 'bar',
          data: revenues,
          itemStyle: { color: '#10b981', borderRadius: [4, 4, 0, 0] },
          barWidth: '40%'
        }]
      }
    },
    formatDate(dateStr) {
      if (!dateStr) return ''
      return new Date(dateStr).toLocaleString('zh-CN', { month: 'numeric', day: 'numeric', hour: '2-digit', minute: '2-digit' })
    },
    getStatusClass(status) {
      const map = {
        'pending': 'status-pending',
        'confirmed': 'status-processing',
        'processing': 'status-processing',
        'cooking': 'status-processing',
        'completed': 'status-completed',
        'cancelled': 'status-cancelled',
        'rejected': 'status-cancelled'
      }
      return map[status] || ''
    },
    getStatusText(status) {
      const map = {
        'pending': '待接单',
        'confirmed': '已接单',
        'processing': '处理中',
        'cooking': '制作中',
        'completed': '已完成',
        'cancelled': '已取消',
        'rejected': '已拒绝'
      }
      return map[status] || status
    },
    viewOrder(id) {
      this.$router.push(`/merchant/orders`)
    }
  }
}
</script>

<style scoped>
.dashboard-container {
  min-height: 100vh;
}

.header-section {
  margin-bottom: 24px;
}

.header-section h2 {
  font-size: 24px;
  font-weight: bold;
  color: #333;
  margin-bottom: 8px;
}

.subtitle {
  color: #666;
  font-size: 14px;
}

/* Cards Common */
.card {
  background: white;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.02);
  border: 1px solid #f0f0f0;
}

.card-header {
  display: flex;
  align-items: center;
  margin-bottom: 16px;
  position: relative;
}

.card-header h3 {
  font-size: 16px;
  font-weight: 600;
  margin: 0;
  margin-right: 12px;
}

.card-subtitle {
  font-size: 12px;
  color: #999;
}

/* KPI Grid */
.kpi-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 20px;
  margin-bottom: 24px;
}

.kpi-card {
  background: white;
  border-radius: 12px;
  padding: 20px;
  display: flex;
  align-items: center;
  box-shadow: 0 2px 8px rgba(0,0,0,0.03);
  position: relative;
}

.kpi-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  margin-right: 16px;
}

.icon-blue { background: #e6f7ff; color: #1890ff; }
.icon-green { background: #f6ffed; color: #52c41a; }
.icon-orange { background: #fff7e6; color: #fa8c16; }
.icon-red { background: #fff1f0; color: #f5222d; }

.kpi-content {
  flex: 1;
}

.kpi-label {
  font-size: 12px;
  color: #888;
  margin-bottom: 4px;
}

.kpi-value {
  font-size: 24px;
  font-weight: 700;
  color: #333;
}

.kpi-trend {
  font-size: 12px;
  font-weight: 500;
  display: flex;
  align-items: center;
}

.trend-up { color: #52c41a; }
.trend-down { color: #f5222d; }

/* Status Bar */
.status-bar {
  margin-bottom: 24px;
  display: flex;
  flex-direction: column;
}

.status-title {
  font-size: 14px;
  font-weight: 600;
  margin-bottom: 16px;
  color: #333;
}

.status-items {
  display: flex;
  justify-content: space-around;
}

.status-item {
  display: flex;
  align-items: center;
  gap: 12px;
}

.status-icon {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
}

.icon-check { background: #f6ffed; color: #52c41a; }
.icon-clock { background: #fff7e6; color: #fa8c16; }
.icon-warn { background: #fff1f0; color: #f5222d; }

.status-count {
  font-size: 20px;
  font-weight: 700;
  color: #333;
}

.status-label {
  font-size: 12px;
  color: #888;
}

/* Charts Grid */
.charts-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
  gap: 20px;
  margin-bottom: 24px;
}

.chart-container {
  height: 300px;
  width: 100%;
}

.chart {
  height: 100%;
  width: 100%;
}

/* Bottom Grid */
.bottom-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  margin-bottom: 24px;
}

@media (max-width: 900px) {
  .bottom-grid {
    grid-template-columns: 1fr;
  }
}

/* Hot Dishes */
.fire-icon {
  color: #ff4d4f;
  margin-left: auto;
}

.dish-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.dish-item {
  display: flex;
  align-items: center;
  padding-bottom: 12px;
  border-bottom: 1px solid #f5f5f5;
}

.dish-item:last-child {
  border-bottom: none;
}

.dish-rank {
  width: 24px;
  height: 24px;
  border-radius: 4px;
  background: #f0f0f0;
  color: #666;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  font-size: 12px;
  margin-right: 12px;
}

.rank-1 { background: #ff4d4f; color: white; }
.rank-2 { background: #ff7a45; color: white; }
.rank-3 { background: #ffa940; color: white; }

.dish-info {
  flex: 1;
}

.dish-name {
  font-size: 14px;
  font-weight: 500;
  color: #333;
}

.dish-sales {
  font-size: 12px;
  color: #999;
}

/* Table Status */
.table-icon {
  color: #722ed1;
  margin-left: auto;
}

.table-summary {
  display: flex;
  gap: 16px;
  margin-bottom: 16px;
  font-size: 12px;
  color: #666;
}

.summary-item {
  display: flex;
  align-items: center;
  gap: 6px;
}

.dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
}

.dot.available { background: #52c41a; }
.dot.occupied { background: #ff4d4f; }
.dot.total { background: #1890ff; }

.val { font-weight: bold; color: #333; }

.table-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(80px, 1fr));
  gap: 12px;
}

.table-box {
  border: 1px solid #e8e8e8;
  border-radius: 8px;
  padding: 12px 8px;
  text-align: center;
  background: #fafafa;
}

.table-box.available {
  border-color: #b7eb8f;
  background: #f6ffed;
  color: #389e0d;
}

.table-box.occupied {
  border-color: #ffa39e;
  background: #fff1f0;
  color: #cf1322;
}

.table-name {
  font-weight: bold;
  font-size: 14px;
  margin-bottom: 4px;
}

.table-cap {
  font-size: 10px;
}

/* Recent Orders Table */
.table-responsive {
  overflow-x: auto;
}

.custom-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
}

.custom-table th {
  text-align: left;
  padding: 12px;
  color: #888;
  font-weight: 500;
  border-bottom: 1px solid #f0f0f0;
}

.custom-table td {
  padding: 12px;
  border-bottom: 1px solid #f0f0f0;
  color: #333;
}

.badge {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

.type-badge {
  background: #e6f7ff;
  color: #1890ff;
}

.status-badge.status-pending { background: #fff7e6; color: #fa8c16; }
.status-badge.status-processing { background: #e6f7ff; color: #1890ff; }
.status-badge.status-completed { background: #f6ffed; color: #52c41a; }
.status-badge.status-cancelled { background: #fff1f0; color: #f5222d; }

.price {
  font-weight: 600;
}

.action-btn {
  border: none;
  background: none;
  color: #1890ff;
  cursor: pointer;
  padding: 4px;
}

.action-btn:hover {
  color: #40a9ff;
}
</style>
