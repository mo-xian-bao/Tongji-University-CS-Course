<template>
  <div class="stock-statistics">
    <!-- 顶部筛选控制栏 -->
    <div class="filter-bar">
      <div class="filter-left">
        <h1 class="page-title">📦 库存数据分析</h1>
      </div>
      
      <div class="filter-controls">
        <!-- 筛选组合 -->
        <div class="filter-group">
          <!-- 分类选择 -->
          <div class="filter-item">
            <label>🏷️ 类别：</label>
            <select v-model="filters.categoryId" @change="loadAllData" class="select-input">
              <option value="">全部分类</option>
              <option v-for="cat in options.categories" :key="cat.id" :value="cat.id">
                {{ cat.name }}
              </option>
            </select>
          </div>

          <!-- 时间范围 -->
          <div class="filter-item">
            <label>📅 时间：</label>
            <div class="custom-date">
              <input type="date" v-model="filters.startDate" @change="loadAllData" />
              <span>至</span>
              <input type="date" v-model="filters.endDate" @change="loadAllData" />
            </div>
          </div>
        </div>
        
        <!-- 操作按钮 -->
        <div class="filter-actions">
          <button class="btn-primary" @click="loadAllData">
            <span>🔍</span> 查询
          </button>
          <button class="btn-secondary" @click="exportStockReport">
            <span>📥</span> 导出报表
          </button>
        </div>
      </div>
    </div>

    <!-- 核心指标卡片 -->
    <div class="metrics-cards">
      <div class="metric-card">
        <div class="metric-icon stock-total">📊</div>
        <div class="metric-content">
          <div class="metric-label">当前库存总量</div>
          <div class="metric-value">{{ overview.total_quantity }}</div>
          <div class="metric-subtitle">单位：件/kg</div>
        </div>
      </div>

      <div class="metric-card">
        <div class="metric-icon stock-cost">💰</div>
        <div class="metric-content">
          <div class="metric-label">库存总成本</div>
          <div class="metric-value">¥{{ overview.total_cost?.toFixed(2) }}</div>
          <div class="metric-subtitle">当前库存货值</div>
        </div>
      </div>

      <div class="metric-card">
        <div class="metric-icon stock-in">📥</div>
        <div class="metric-content">
          <div class="metric-label">期间补货量</div>
          <div class="metric-value">{{ overview.total_in }}</div>
          <div class="metric-trend trend-up">
            <span>↑</span> 支出 ¥{{ overview.cost_in?.toFixed(0) }}
          </div>
        </div>
      </div>

      <div class="metric-card">
        <div class="metric-icon stock-out">📤</div>
        <div class="metric-content">
          <div class="metric-label">期间消耗量</div>
          <div class="metric-value">{{ overview.total_out }}</div>
          <div class="metric-subtitle">包含销售与损耗</div>
        </div>
      </div>

    </div>

    <!-- 图表区域 -->
    <div class="charts-grid">
      <!-- 库存变动趋势 -->
      <div class="chart-card full-width">
        <div class="chart-header">
          <h3>📉 库存变动趋势 & 补货记录</h3>
        </div>
        <v-chart class="chart" :option="trendChartOption" autoresize />
      </div>

      <!-- 出入库对比 -->
      <div class="chart-card half-width">
        <div class="chart-header">
          <h3>⚖️ 销售 vs 补货 (数量对比)</h3>
        </div>
        <v-chart class="chart" :option="inOutChartOption" autoresize />
      </div>

      <!-- 库存构成 -->
      <div class="chart-card half-width">
        <div class="chart-header">
          <h3>🥧 各分类库存成本占比</h3>
        </div>
        <v-chart class="chart" :option="categoryCostChartOption" autoresize />
      </div>
    </div>

    <!-- 库存流水报表表格 -->
    <div class="table-card">
      <div class="card-header">
        <h3>📝 库存流水明细报表</h3>
      </div>
      <div class="table-container">
        <table class="data-table">
          <thead>
            <tr>
              <th>时间</th>
              <th>流水号</th>
              <th>菜品名称</th>
              <th>类型</th>
              <th>变动数量</th>
              <th>变动后库存</th>
              <th>操作人id</th>
              <th>备注</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(log, index) in stockLogs" :key="index">
              <td>{{ formatTime(log.created_at) }}</td>
              <td>{{ getBatchNo(log) }}</td>
              <td>{{ log.dish_name }}</td>
              <td>
                <span :class="['tag', getChangeTypeClass(log.change_type)]">
                  {{ getChangeTypeName(log.change_type) }}
                </span>
              </td>
              <td :class="log.quantity_change > 0 ? 'text-green' : 'text-red'">
                {{ log.quantity_change > 0 ? '+' : '' }}{{ log.quantity_change }}
              </td>
              <td>{{ log.stock_after }}</td>
              <td>{{ log.operator_id }}</td>
              <td class="text-truncate" :title="log.note || '-'">{{ log.note || '-' }}</td>
            </tr>
            <tr v-if="stockLogs.length === 0">
              <td colspan="9" class="empty-text">暂无库存变动记录</td>
            </tr>
          </tbody>
        </table>
      </div>
      <!-- 分页控件可在此处添加 -->
    </div>

    <!-- 加载中遮罩 -->
    <div v-if="loading" class="loading-overlay">
      <div class="loading-spinner"></div>
      <p>正在计算库存数据...</p>
    </div>
  </div>
</template>

<script>
import { use } from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { LineChart, BarChart, PieChart } from 'echarts/charts'
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
} from 'echarts/components'
import VChart from 'vue-echarts'
import axios from 'axios'

use([
  CanvasRenderer,
  LineChart,
  BarChart,
  PieChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
])

export default {
  name: 'StockStatistics',
  components: {
    VChart
  },
  data() {
    return {
      loading: false,
      
      // 筛选条件
      filters: {
        // stallId: '', // 去除档口筛选
        categoryId: '',
        startDate: '',
        endDate: '',
        timezone: ''
      },
      
      // 下拉选项数据
      options: {
        // stalls: [], // 去除档口选项
        categories: []
      },

      // 概览数据
      overview: {
        total_quantity: 0,
        total_cost: 0,
        total_in: 0,
        cost_in: 0,
        total_out: 0,
        warning_count: 0
      },

      // 图表数据源
      chartData: {
        trend: [], // 日期, 库存总量, 补货量
        inOut: [], // 分类, 入库量, 出库量
        categoryCost: [] // 分类, 成本占比
      },

      // 表格数据
      stockLogs: []
    }
  },
  computed: {
    // 趋势图配置
    trendChartOption() {
      const dates = this.chartData.trend.map(d => d.date)
      const stockLevel = this.chartData.trend.map(d => d.total_stock)
      const restockAmount = this.chartData.trend.map(d => d.restock_amount)

      return {
        tooltip: {
          trigger: 'axis',
          axisPointer: { type: 'cross' }
        },
        legend: {
          data: ['库存总量', '当日补货'],
          top: '5%'  // 【新增】向下调一点
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: {
          type: 'category',
          boundaryGap: false,
          data: dates,
          axisLine: { lineStyle: { color: '#ddd' } },
          axisLabel: { color: '#666' }
        },
        yAxis: [
          {
            type: 'value',
            name: '库存总量',
            position: 'left',
            axisLine: { show: true, lineStyle: { color: '#3B82F6' } }
          },
          {
            type: 'value',
            name: '补货量',
            position: 'right',
            splitLine: { show: false },
            axisLine: { show: true, lineStyle: { color: '#10B981' } }
          }
        ],
        series: [
          {
            name: '库存总量',
            type: 'line',
            data: stockLevel,
            smooth: true,
            areaStyle: {
              color: {
                type: 'linear',
                x: 0, y: 0, x2: 0, y2: 1,
                colorStops: [
                  { offset: 0, color: 'rgba(59, 130, 246, 0.3)' },
                  { offset: 1, color: 'rgba(59, 130, 246, 0.05)' }
                ]
              }
            },
            itemStyle: { color: '#3B82F6' }
          },
          {
            name: '当日补货',
            type: 'bar',
            yAxisIndex: 1,
            data: restockAmount,
            itemStyle: { color: '#10B981', borderRadius: [4, 4, 0, 0] },
            barMaxWidth: 30
          }
        ]
      }
    },

    // 出入库对比配置
    inOutChartOption() {
      const categories = this.chartData.inOut.map(d => d.category_name)
      const inData = this.chartData.inOut.map(d => d.in_qty)
      const outData = this.chartData.inOut.map(d => d.out_qty)

      return {
        tooltip: {
          trigger: 'axis',
          axisPointer: { type: 'shadow' }
        },
        legend: { 
          data: ['入库(补货)', '出库(销售/损耗)'],
          top: '10%'  // 【修改】从 '5%' 增加到 '10%'，向下调一点
        },
        grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
        xAxis: {
          type: 'category',
          data: categories,
          axisLabel: { interval: 0, rotate: 30, color: '#666' }
        },
        yAxis: { type: 'value' },
        series: [
          {
            name: '入库(补货)',
            type: 'bar',
            data: inData,
            itemStyle: { color: '#10B981' }
          },
          {
            name: '出库(销售/损耗)',
            type: 'bar',
            data: outData,
            itemStyle: { color: '#EF4444' }
          }
        ]
      }
    },

    // 成本占比饼图
    categoryCostChartOption() {
      const data = this.chartData.categoryCost.map(d => ({
        value: d.cost,
        name: d.category_name
      }))

      return {
        tooltip: {
          trigger: 'item',
          formatter: '{b}: ¥{c} ({d}%)'
        },
        legend: { top: '5%', left: 'center' },
        series: [
          {
            name: '库存成本',
            type: 'pie',
            radius: ['40%', '70%'],
            avoidLabelOverlap: false,
            itemStyle: {
              borderRadius: 10,
              borderColor: '#fff',
              borderWidth: 2
            },
            label: { show: false, position: 'center' },
            emphasis: {
              label: { show: true, fontSize: '18', fontWeight: 'bold' }
            },
            data: data
          }
        ]
      }
    }
  },
  mounted() {
    this.initDateRange()
    this.fetchOptions()
    this.loadAllData()
  },
  methods: {
    // 初始化默认时间范围（本月）
    initDateRange() {
      const now = new Date()
      const start = new Date(now.getFullYear(), now.getMonth(), 1)
      this.filters.startDate = this.formatDate(start)
      this.filters.endDate = this.formatDate(now)
      this.filters.timezone = Intl.DateTimeFormat().resolvedOptions().timeZone
    },

    formatDate(date) {
      const year = date.getFullYear()
      const month = String(date.getMonth() + 1).padStart(2, '0')
      const day = String(date.getDate()).padStart(2, '0')
      return `${year}-${month}-${day}`
    },

    // 获取筛选项
    async fetchOptions() {
      try {
        const res = await axios.get('/merchant/stock/options')
        // this.options.stalls = res.data.data.stalls // 去除档口选项
        this.options.categories = res.data.data.categories
      } catch (error) {
        console.error('获取选项失败', error)
      }
    },

    // 加载所有统计数据
    async loadAllData() {
      this.loading = true
      try {
        const params = {
          start_date: this.filters.startDate,  // 改为 start_date
          end_date: this.filters.endDate,      // 改为 end_date
          timezone: this.filters.timezone, // 时区名称
          category: this.filters.categoryId || undefined  // 传递分类名称字符串
        }
        
        // 并行请求：概览、趋势、出入库、分类成本、日志表格
        const [overviewRes, trendRes, inOutRes, costRes, logsRes] = await Promise.all([
          axios.get('/merchant/stock/statistics/overview', { params }),
          axios.get('/merchant/stock/statistics/trend', { params }),
          axios.get('/merchant/stock/statistics/in-out', { params }),
          axios.get('/merchant/stock/statistics/cost-distribution', { params }),
          axios.get('/merchant/stock/statistics/logs', { params })
        ])

        if (overviewRes.data.success) this.overview = overviewRes.data.data
        if (trendRes.data.success) this.chartData.trend = trendRes.data.data
        if (inOutRes.data.success) this.chartData.inOut = inOutRes.data.data
        if (costRes.data.success) this.chartData.categoryCost = costRes.data.data
        if (logsRes.data.success) this.stockLogs = logsRes.data.data

      } catch (error) {
        console.error('加载库存统计失败:', error)
      } finally {
        this.loading = false
      }
    },

    // 导出报表
    async exportStockReport() {
      try {
        const response = await axios.get('/merchant/stock/statistics/export', {
          params: this.filters,
          responseType: 'blob'
        })
        
        const url = window.URL.createObjectURL(new Blob([response.data]))
        const link = document.createElement('a')
        link.href = url
        link.setAttribute('download', `库存报表_${this.filters.startDate}_${this.filters.endDate}.xlsx`)
        document.body.appendChild(link)
        link.click()
        document.body.removeChild(link)
        
        alert('库存报表已导出！')
      } catch (error) {
        console.error('导出失败:', error)
        alert(error.response?.data?.message || error.message || '导出失败，请重试')
      }
    },

    // 辅助函数：变动类型显示
    getChangeTypeName(type) {
      const map = {
        'restock': '补货入库',
        'sales': '销售扣减',
        'loss': '损耗扣减',
        'return': '退货入库',
        'check': '盘点调整',
        'update': '订单修改'
      }
      return map[type] || type
    },

    getChangeTypeClass(type) {
      if (['restock', 'return'].includes(type)) return 'tag-in'
      if (['sales', 'update'].includes(type)) return 'tag-out'
      if (['loss'].includes(type)) return 'tag-loss'
      return 'tag-neutral'
    },

    // 格式化时间：ISO -> YYYY-MM-DD HH:MM
    formatTime(isoString) {
      if (!isoString) return '-'
      const date = new Date(isoString)
      const year = date.getFullYear()
      const month = String(date.getMonth() + 1).padStart(2, '0')
      const day = String(date.getDate()).padStart(2, '0')
      const hours = String(date.getHours()).padStart(2, '0')
      const minutes = String(date.getMinutes()).padStart(2, '0')
      return `${year}-${month}-${day} ${hours}:${minutes}`
    },

    // 获取单号：销售时提取订单号，其他显示 ID
    getBatchNo(log) {
      if (log.change_type === 'sales' && log.note && log.note.includes('订单')) {
        const match = log.note.match(/订单 (\d+)/)
        return match ? match[1] : log.id
      }
      return log.id
    },

    // 开发用 Mock 数据 (可选)
    mockData() {
      this.overview = {
        total_quantity: 1250,
        total_cost: 45800.50,
        total_in: 300,
        cost_in: 5200,
        total_out: 210,
        warning_count: 3
      }
      this.chartData.trend = [
        { date: '11-20', total_stock: 1000, restock_amount: 200 },
        { date: '11-21', total_stock: 950, restock_amount: 0 },
        { date: '11-22', total_stock: 1100, restock_amount: 300 },
        { date: '11-23', total_stock: 1050, restock_amount: 50 },
        { date: '11-24', total_stock: 1250, restock_amount: 400 }
      ]
      this.chartData.inOut = [
        { category_name: '肉类', in_qty: 150, out_qty: 120 },
        { category_name: '蔬菜', in_qty: 200, out_qty: 180 },
        { category_name: '酒水', in_qty: 50, out_qty: 10 }
      ]
      this.chartData.categoryCost = [
        { category_name: '肉类', cost: 30000 },
        { category_name: '蔬菜', cost: 5000 },
        { category_name: '酒水', cost: 10800 }
      ]
      this.stockLogs = [
        { time: '2023-11-24 10:00', batch_no: 'IN2023112401', stall_name: '烧烤档', dish_name: '羊肉串', type: 'restock', quantity: 200, stock_after: 500, operator: '张三', note: '早市补货' },
        { time: '2023-11-24 12:30', batch_no: 'OUT2023112402', stall_name: '烧烤档', dish_name: '羊肉串', type: 'sales', quantity: -50, stock_after: 450, operator: '系统', note: '午市销售' }
      ]
    }
  }
}
</script>

<style scoped>
/* 复用 Statistics.vue 的基础样式 */
.filter-bar {
  background: white;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
}

.page-title {
  font-size: 28px;
  font-weight: 700;
  color: #1F2937;
  margin: 0 0 20px 0;
}

.filter-controls {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 20px;
}

.filter-group {
  display: flex;
  gap: 20px;
  flex-wrap: wrap;
}

.filter-item {
  display: flex;
  align-items: center;
  gap: 8px;
}

.filter-item label {
  font-weight: 600;
  color: #4B5563;
}

.select-input, .custom-date input {
  padding: 8px 12px;
  border: 1px solid #E5E7EB;
  border-radius: 8px;
  font-size: 14px;
  background: white;
}

.custom-date {
  display: flex;
  align-items: center;
  gap: 8px;
}

.filter-actions {
  display: flex;
  gap: 12px;
}

.btn-primary, .btn-secondary {
  padding: 10px 20px;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  gap: 6px;
}

.btn-primary {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.btn-secondary {
  background: white;
  border: 1px solid #E5E7EB;
  color: #6B7280;
}

/* 核心指标卡片样式 */
.metrics-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 20px;
  margin-bottom: 20px;
}

.metric-card {
  background: white;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  display: flex;
  align-items: flex-start;
  gap: 16px;
  transition: transform 0.2s;
}

.metric-card:hover {
  transform: translateY(-2px);
}

.metric-icon {
  width: 48px;
  height: 48px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
}

.stock-total { background: #DBEAFE; color: #1E40AF; }
.stock-cost { background: #FEF3C7; color: #92400E; }
.stock-in { background: #D1FAE5; color: #065F46; }
.stock-out { background: #FEE2E2; color: #991B1B; }
.stock-alert { background: #FEE2E2; color: #DC2626; }

.metric-content { flex: 1; }
.metric-label { color: #6B7280; font-size: 13px; margin-bottom: 4px; }
.metric-value { color: #1F2937; font-size: 24px; font-weight: 700; margin-bottom: 2px; }
.metric-value.warning { color: #DC2626; }
.metric-subtitle { color: #9CA3AF; font-size: 12px; }
.metric-subtitle.warning { color: #DC2626; font-weight: bold; }
.metric-trend.trend-up { color: #059669; font-size: 12px; font-weight: 600; }

/* 图表网格 */
.charts-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
  margin-bottom: 20px;
}

.chart-card {
  background: white;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.chart-card.full-width { grid-column: 1 / -1; }
.chart-card.half-width { grid-column: span 1; }

.chart-header h3 {
  margin: 0 0 15px 0;
  font-size: 16px;
  color: #374151;
}

.chart {
  width: 100%;
  height: 350px;
}

/* 表格样式 */
.table-card {
  background: white;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.card-header h3 { margin: 0 0 15px 0; color: #374151; font-size: 18px; }

.table-container {
  overflow-x: auto;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
}

.data-table th {
  background: #F9FAFB;
  padding: 12px 16px;
  text-align: left;
  font-weight: 600;
  color: #4B5563;
  border-bottom: 1px solid #E5E7EB;
}

.data-table td {
  padding: 12px 16px;
  border-bottom: 1px solid #F3F4F6;
  color: #1F2937;
}

.data-table tbody tr:hover {
  background: #F9FAFB;
}

.tag {
  padding: 2px 8px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}

.tag-in { background: #D1FAE5; color: #065F46; }
.tag-out { background: #DBEAFE; color: #1E40AF; }
.tag-loss { background: #FEE2E2; color: #991B1B; }
.tag-neutral { background: #F3F4F6; color: #4B5563; }

.text-green { color: #059669; font-weight: 600; }
.text-red { color: #DC2626; font-weight: 600; }
.text-truncate {
  max-width: 150px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.empty-text { text-align: center; color: #9CA3AF; padding: 20px; }

/* 加载遮罩 */
.loading-overlay {
  position: absolute;
  top: 0; left: 0; right: 0; bottom: 0;
  background: rgba(255, 255, 255, 0.8);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  z-index: 50;
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 3px solid #E5E7EB;
  border-top-color: #667eea;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin { to { transform: rotate(360deg); } }

/* 响应式 */
@media (max-width: 1024px) {
  .chart-card.half-width { grid-column: 1 / -1; }
}

@media (max-width: 768px) {
  .filter-controls { flex-direction: column; align-items: stretch; }
  .filter-group { flex-direction: column; }
  .filter-actions { justify-content: stretch; }
  .filter-actions button { flex: 1; justify-content: center; }
}
</style>