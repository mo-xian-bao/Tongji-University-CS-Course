<template>
  <div class="statistics-container">
    <!-- 页面切换按钮 -->
    <div class="tab-buttons">
      <button 
        :class="['tab-btn', { active: currentTab === 'orders' }]" 
        @click="currentTab = 'orders'"
      >
        📊 订单统计
      </button>
      <button 
        :class="['tab-btn', { active: currentTab === 'inventory' }]" 
        @click="currentTab = 'inventory'"
      >
        📦 库存统计
      </button>
    </div>

    <!-- 订单统计内容 -->
    <div v-if="currentTab === 'orders'">
      <!-- 顶部筛选控制栏 -->
      <div class="filter-bar">
        <div class="filter-left">
          <h1 class="page-title">📊 运营数据中心</h1>
        </div>
        
        <div class="filter-controls">
          <!-- 时间范围选择 -->
          <div class="filter-item">
            <label>📅 时间范围：</label>
            <div class="date-buttons">
              <button 
                v-for="preset in datePresets" 
                :key="preset.key"
                :class="['date-btn', { active: selectedPreset === preset.key }]"
                @click="selectDatePreset(preset.key)"
              >
                {{ preset.label }}
              </button>
            </div>
            <div class="custom-date">
              <input type="date" v-model="filters.startDate" @change="onDateChange" />
              <span>至</span>
              <input type="date" v-model="filters.endDate" @change="onDateChange" />
            </div>
          </div>
          
          <!-- 操作按钮 -->
          <div class="filter-actions">
            <button class="btn-primary" @click="loadAllData">
              <span>🔍</span> 查询
            </button>
            <button class="btn-secondary" @click="exportReport">
              <span>📥</span> 导出报表
            </button>
          </div>
        </div>
      </div>

      <!-- 核心指标卡片 -->
      <div class="metrics-cards">
        <div class="metric-card">
          <div class="metric-icon orders">📦</div>
          <div class="metric-content">
            <div class="metric-label">总订单量</div>
            <div class="metric-value">{{ overview.total_orders }}</div>
            <div class="metric-trend" :class="getTrendClass(overview.orders_growth)">
              <span>{{ getTrendIcon(overview.orders_growth) }}</span>
              {{ Math.abs(overview.orders_growth).toFixed(1) }}%
            </div>
          </div>
          <div class="sparkline-container">
            <v-chart :option="createSparkline(trendData.map(d => d.order_count))" style="height: 40px;" />
          </div>
        </div>

        <div class="metric-card">
          <div class="metric-icon revenue">💰</div>
          <div class="metric-content">
            <div class="metric-label">总营业额</div>
            <div class="metric-value">¥{{ overview.total_revenue?.toFixed(2) }}</div>
            <div class="metric-trend" :class="getTrendClass(overview.revenue_growth)">
              <span>{{ getTrendIcon(overview.revenue_growth) }}</span>
              {{ Math.abs(overview.revenue_growth).toFixed(1) }}%
            </div>
          </div>
          <div class="sparkline-container">
            <v-chart :option="createSparkline(trendData.map(d => d.revenue), true)" style="height: 40px;" />
          </div>
        </div>

        <div class="metric-card">
          <div class="metric-icon avg-order">🧾</div>
          <div class="metric-content">
            <div class="metric-label">客单价</div>
            <div class="metric-value">¥{{ overview.avg_order_value?.toFixed(2) }}</div>
            <div class="metric-subtitle">人均消费金额</div>
          </div>
        </div>

        <div class="metric-card">
          <div class="metric-icon cancel-rate">🚫</div>
          <div class="metric-content">
            <div class="metric-label">订单取消率</div>
            <div class="metric-value" :class="{ 'warning': overview.cancellation_rate > 10 }">
              {{ overview.cancellation_rate?.toFixed(1) }}%
            </div>
            <div class="metric-subtitle" :class="{ 'warning': overview.cancellation_rate > 10 }">
              {{ overview.cancellation_rate > 10 ? '⚠️ 需关注' : '✅ 正常' }}
            </div>
          </div>
        </div>

        <div class="metric-card">
          <div class="metric-icon dishes">🍽️</div>
          <div class="metric-content">
            <div class="metric-label">在售菜品数</div>
            <div class="metric-value">{{ overview.active_dishes }}</div>
            <div class="metric-subtitle">当前上架菜品</div>
          </div>
        </div>
      </div>

      <!-- 图表区域 -->
      <div class="charts-grid">
        <!-- 第一行：核心趋势 -->
        <div class="chart-card full-width">
          <div class="chart-header">
            <h3>📈 订单与营收趋势</h3>
            <div class="chart-legend">
              <span class="legend-item"><i class="dot blue"></i>订单量</span>
              <span class="legend-item"><i class="dot orange"></i>营业额</span>
            </div>
          </div>
          <v-chart class="chart" :option="trendChartOption" autoresize />
        </div>

        <!-- 第二行：时段与效率 -->
        <div class="chart-card half-width">
          <div class="chart-header">
            <h3>🕐 热门时段分布</h3>
          </div>
          <v-chart class="chart" :option="peakHoursChartOption" autoresize />
        </div>

        <div class="chart-card half-width">
          <div class="chart-header">
            <h3>🔄 订单状态分布</h3>
          </div>
          <v-chart class="chart" :option="orderStatusChartOption" autoresize />
        </div>

        <!-- 第三行：商品分析 -->
        <div class="chart-card half-width">
          <div class="chart-header">
            <h3>🏆 热门菜品排行榜</h3>
          </div>
          <v-chart class="chart" :option="topDishesChartOption" autoresize />
        </div>

        <div class="chart-card half-width">
          <div class="chart-header">
            <h3>🥧 菜品分类占比</h3>
          </div>
          <v-chart class="chart" :option="categoryShareChartOption" autoresize />
        </div>

        <!-- 第四行：评论词云 -->
        <div class="chart-card full-width">
          <div class="chart-header">
            <h3>☁️ 评论词云</h3>
          </div>
          <v-chart class="chart" :option="wordCloudChartOption" autoresize />
        </div>
      </div>

      <!-- 加载中遮罩 -->
      <div v-if="loading" class="loading-overlay">
        <div class="loading-spinner"></div>
        <p>正在加载数据...</p>
      </div>
    </div>

    <!-- 库存统计内容 -->
    <StockStatistics v-if="currentTab === 'inventory'" />
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
import 'echarts-wordcloud'
import axios from 'axios'
import StockStatistics from './StockStatistics.vue' // 新增：导入库存统计组件

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
  name: 'Statistics',
  components: {
    VChart,
    StockStatistics // 新增：注册库存统计组件
  },
  data() {
    return {
      loading: false,
      selectedPreset: 'last7days',
      currentTab: 'orders', // 新增：当前页面标签
      
      // 日期预设
      datePresets: [
        { key: 'today', label: '今日' },
        { key: 'yesterday', label: '昨日' },
        { key: 'last7days', label: '近7天' },
        { key: 'last30days', label: '近30天' }
      ],
      
      // 筛选条件
      filters: {
        startDate: '',
        endDate: '',
      },
      
      // 核心指标数据
      overview: {
        total_orders: 0,
        total_revenue: 0,
        avg_order_value: 0,
        cancellation_rate: 0,
        active_dishes: 0,
        orders_growth: 0,
        revenue_growth: 0
      },
      
      // 趋势数据
      trendData: [],
      
      // 热门时段数据
      peakHoursData: [],
      
      // 热门菜品数据
      topDishesData: [],
      
      // 订单状态数据
      orderStatusData: [],
      
      // 分类占比数据
      categoryShareData: [],

      // 评论词云数据
      wordCloudData: []
    }
  },
  computed: {
    // 趋势图表配置
    trendChartOption() {
      const dates = this.trendData.map(d => d.date.substring(5)) // 只显示月-日
      const orderCounts = this.trendData.map(d => d.order_count)
      const revenues = this.trendData.map(d => d.revenue)
      
      return {
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'cross',
            crossStyle: {
              color: '#999'
            }
          },
          backgroundColor: 'rgba(255, 255, 255, 0.95)',
          borderColor: '#ddd',
          borderWidth: 1,
          textStyle: {
            color: '#333'
          }
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          top: '10%',
          containLabel: true
        },
        xAxis: {
          type: 'category',
          data: dates,
          axisLine: {
            lineStyle: {
              color: '#ddd'
            }
          },
          axisLabel: {
            color: '#666'
          }
        },
        yAxis: [
          {
            type: 'value',
            name: '订单量',
            position: 'left',
            axisLine: {
              lineStyle: {
                color: '#3B82F6'
              }
            },
            axisLabel: {
              color: '#666'
            }
          },
          {
            type: 'value',
            name: '营业额（¥）',
            position: 'right',
            axisLine: {
              lineStyle: {
                color: '#F59E0B'
              }
            },
            axisLabel: {
              color: '#666',
              formatter: '¥{value}'
            }
          }
        ],
        series: [
          {
            name: '订单量',
            type: 'bar',
            data: orderCounts,
            itemStyle: {
              color: '#3B82F6'
            },
            barWidth: '40%'
          },
          {
            name: '营业额',
            type: 'line',
            yAxisIndex: 1,
            data: revenues,
            smooth: true,
            lineStyle: {
              width: 3,
              color: '#F59E0B'
            },
            itemStyle: {
              color: '#F59E0B'
            },
            areaStyle: {
              color: {
                type: 'linear',
                x: 0,
                y: 0,
                x2: 0,
                y2: 1,
                colorStops: [
                  { offset: 0, color: 'rgba(245, 158, 11, 0.3)' },
                  { offset: 1, color: 'rgba(245, 158, 11, 0.05)' }
                ]
              }
            }
          }
        ]
      }
    },
    
    // 热门时段图表配置
    peakHoursChartOption() {
      const hours = this.peakHoursData.map(d => d.hour)
      const counts = this.peakHoursData.map(d => d.order_count)
      
      return {
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          },
          backgroundColor: 'rgba(255, 255, 255, 0.95)',
          borderColor: '#ddd',
          borderWidth: 1
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          top: '5%',
          containLabel: true
        },
        xAxis: {
          type: 'category',
          data: hours,
          axisLabel: {
            rotate: 45,
            color: '#666'
          }
        },
        yAxis: {
          type: 'value',
          axisLabel: {
            color: '#666'
          }
        },
        series: [
          {
            name: '订单数',
            type: 'bar',
            data: counts,
            itemStyle: {
              color: {
                type: 'linear',
                x: 0,
                y: 0,
                x2: 0,
                y2: 1,
                colorStops: [
                  { offset: 0, color: '#667eea' },
                  { offset: 1, color: '#764ba2' }
                ]
              }
            },
            emphasis: {
              itemStyle: {
                color: '#667eea'
              }
            }
          }
        ]
      }
    },
    
    // 订单状态图表配置
    orderStatusChartOption() {
      const statusColors = {
        'completed': '#10B981',
        'confirmed': '#3B82F6',
        'dining': '#F59E0B',
        'pending': '#8B5CF6',
        'cancelled': '#EF4444',
        'rejected': '#6B7280'
      }
      
      const data = this.orderStatusData.map(item => ({
        value: item.count,
        name: item.status_name,
        itemStyle: {
          color: statusColors[item.status] || '#999'
        }
      }))
      
      const total = data.reduce((sum, item) => sum + item.value, 0)
      
      return {
        tooltip: {
          trigger: 'item',
          formatter: '{b}: {c} ({d}%)',
          backgroundColor: 'rgba(255, 255, 255, 0.95)',
          borderColor: '#ddd',
          borderWidth: 1
        },
        legend: {
          orient: 'vertical',
          right: '10%',
          top: 'center',
          textStyle: {
            color: '#666'
          }
        },
        series: [
          {
            name: '订单状态',
            type: 'pie',
            radius: ['45%', '70%'],
            center: ['35%', '50%'],
            avoidLabelOverlap: false,
            label: {
              show: false
            },
            emphasis: {
              label: {
                show: true,
                fontSize: 16,
                fontWeight: 'bold'
              }
            },
            labelLine: {
              show: false
            },
            data: data,
            graphic: [
              {
                type: 'text',
                left: 'center',
                top: 'center',
                style: {
                  text: `总计\n${total}`,
                  textAlign: 'center',
                  fill: '#666',
                  fontSize: 18,
                  fontWeight: 'bold'
                }
              }
            ]
          }
        ]
      }
    },
    
    // 热门菜品图表配置
    topDishesChartOption() {
      const dishNames = this.topDishesData.map(d => d.dish_name)
      const salesCounts = this.topDishesData.map(d => d.sales_count)
      
      return {
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          },
          backgroundColor: 'rgba(255, 255, 255, 0.95)',
          borderColor: '#ddd',
          borderWidth: 1
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          top: '3%',
          containLabel: true
        },
        xAxis: {
          type: 'value',
          axisLabel: {
            color: '#666'
          }
        },
        yAxis: {
          type: 'category',
          data: dishNames,
          axisLabel: {
            color: '#666'
          }
        },
        series: [
          {
            name: '销量',
            type: 'bar',
            data: salesCounts,
            itemStyle: {
              color: {
                type: 'linear',
                x: 0,
                y: 0,
                x2: 1,
                y2: 0,
                colorStops: [
                  { offset: 0, color: '#F59E0B' },
                  { offset: 1, color: '#EF4444' }
                ]
              },
              borderRadius: [0, 8, 8, 0]
            },
            label: {
              show: true,
              position: 'right',
              color: '#666',
              formatter: '{c}'
            }
          }
        ]
      }
    },
    
    // 分类占比图表配置
    categoryShareChartOption() {
      const colors = ['#667eea', '#f093fb', '#4facfe', '#43e97b', '#fa709a', '#fee140']
      
      const data = this.categoryShareData.map((item, index) => ({
        value: item.sales_count,
        name: item.category,
        itemStyle: {
          color: colors[index % colors.length]
        }
      }))
      
      return {
        tooltip: {
          trigger: 'item',
          formatter: '{b}: {c} ({d}%)',
          backgroundColor: 'rgba(255, 255, 255, 0.95)',
          borderColor: '#ddd',
          borderWidth: 1
        },
        legend: {
          orient: 'vertical',
          right: '5%',
          top: 'center',
          textStyle: {
            color: '#666'
          }
        },
        series: [
          {
            name: '分类销量',
            type: 'pie',
            radius: [30, 110],
            center: ['40%', '50%'],
            roseType: 'area',
            itemStyle: {
              borderRadius: 8
            },
            label: {
              show: true,
              formatter: '{b}\n{d}%'
            },
            data: data
          }
        ]
      }
    },

    // 评论词云图表配置
    wordCloudChartOption() {
      return {
        tooltip: {
          show: true
        },
        series: [{
          type: 'wordCloud',
          shape: 'circle',
          left: 'center',
          top: 'center',
          width: '100%',
          height: '100%',
          right: null,
          bottom: null,
          sizeRange: [12, 60],
          rotationRange: [-90, 90],
          rotationStep: 45,
          gridSize: 8,
          drawOutOfBound: false,
          layoutAnimation: true,
          textStyle: {
            fontFamily: 'sans-serif',
            fontWeight: 'bold',
            color: function () {
              return 'rgb(' + [
                Math.round(Math.random() * 160),
                Math.round(Math.random() * 160),
                Math.round(Math.random() * 160)
              ].join(',') + ')';
            }
          },
          emphasis: {
            focus: 'self',
            textStyle: {
              shadowBlur: 10,
              shadowColor: '#333'
            }
          },
          data: this.wordCloudData
        }]
      }
    }
  },
  mounted() {
    // 初始化日期为近7天
    this.selectDatePreset('last7days')
  },
  methods: {
    // 选择日期预设
    selectDatePreset(key) {
      this.selectedPreset = key
      const now = new Date()
      const today = new Date(now.getFullYear(), now.getMonth(), now.getDate())
      
      switch (key) {
        case 'today':
          this.filters.startDate = this.formatDate(today)
          this.filters.endDate = this.formatDate(today)
          break
        case 'yesterday':
          const yesterday = new Date(today)
          yesterday.setDate(yesterday.getDate() - 1)
          this.filters.startDate = this.formatDate(yesterday)
          this.filters.endDate = this.formatDate(yesterday)
          break
        case 'last7days':
          const last7days = new Date(today)
          last7days.setDate(last7days.getDate() - 6)
          this.filters.startDate = this.formatDate(last7days)
          this.filters.endDate = this.formatDate(today)
          break
        case 'last30days':
          const last30days = new Date(today)
          last30days.setDate(last30days.getDate() - 29)
          this.filters.startDate = this.formatDate(last30days)
          this.filters.endDate = this.formatDate(today)
          break
      }
      
      this.loadAllData()
    },
    
    // 日期变化
    onDateChange() {
      this.selectedPreset = null
      this.loadAllData()
    },
    
    // 格式化日期
    formatDate(date) {
      const year = date.getFullYear()
      const month = String(date.getMonth() + 1).padStart(2, '0')
      const day = String(date.getDate()).padStart(2, '0')
      return `${year}-${month}-${day}`
    },
    
    // 加载所有数据
    async loadAllData() {
      this.loading = true
      try {
        const params = {
          start_date: this.filters.startDate,
          end_date: this.filters.endDate,
          timezone: Intl.DateTimeFormat().resolvedOptions().timeZone
        }
        
        // 并行请求所有数据
        const [
          overviewRes,
          trendRes,
          peakHoursRes,
          topDishesRes,
          orderStatusRes,
          categoryShareRes,
          wordCloudRes
        ] = await Promise.all([
          axios.get('/merchant/statistics/overview', { params }),
          axios.get('/merchant/statistics/trend', { params }),
          axios.get('/merchant/statistics/peak-hours', { params }),
          axios.get('/merchant/statistics/top-dishes', { params }),
          axios.get('/merchant/statistics/order-status', { params }),
          axios.get('/merchant/statistics/category-share', { params }),
          axios.get('/merchant/statistics/review-wordcloud', { params })
        ])
        
        // 更新数据
        if (overviewRes.data.success) {
          this.overview = overviewRes.data.data
        }
        
        if (trendRes.data.success) {
          this.trendData = trendRes.data.data.trend
        }
        
        if (peakHoursRes.data.success) {
          this.peakHoursData = peakHoursRes.data.data.peak_hours
        }
        
        if (topDishesRes.data.success) {
          this.topDishesData = topDishesRes.data.data.top_dishes
        }
        
        if (orderStatusRes.data.success) {
          this.orderStatusData = orderStatusRes.data.data.status_distribution
        }
        
        if (categoryShareRes.data.success) {
          this.categoryShareData = categoryShareRes.data.data.category_share
        }

        if (wordCloudRes.data.success) {
          this.wordCloudData = wordCloudRes.data.data.wordcloud
        }
        
      } catch (error) {
        console.error('加载数据失败:', error)
        alert('加载数据失败: ' + (error.response?.data?.message || error.message))
      } finally {
        this.loading = false
      }
    },
    
    // 导出报表
    async exportReport() {
      try {
        const params = {
          start_date: this.filters.startDate,
          end_date: this.filters.endDate,
          timezone: Intl.DateTimeFormat().resolvedOptions().timeZone
        }
        
        const response = await axios.get('/merchant/statistics/export', {
          params,
          responseType: 'blob'
        })
        
        // 创建下载链接
        const url = window.URL.createObjectURL(new Blob([response.data]))
        const link = document.createElement('a')
        link.href = url
        
        // 从响应头获取文件名
        const contentDisposition = response.headers['content-disposition']
        let filename = '统计报表.xlsx'
        if (contentDisposition) {
          const filenameMatch = contentDisposition.match(/filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/)
          if (filenameMatch && filenameMatch[1]) {
            filename = decodeURIComponent(filenameMatch[1].replace(/['"]/g, ''))
          }
        }
        
        link.setAttribute('download', filename)
        document.body.appendChild(link)
        link.click()
        document.body.removeChild(link)
        
        alert('报表导出成功！')
      } catch (error) {
        console.error('导出报表失败:', error)
        alert('导出报表失败: ' + (error.response?.data?.message || error.message))
      }
    },
    
    // 创建迷你趋势图
    createSparkline(data, isRevenue = false) {
      return {
        grid: {
          left: 0,
          right: 0,
          top: 0,
          bottom: 0
        },
        xAxis: {
          type: 'category',
          show: false,
          data: data.map((_, i) => i)
        },
        yAxis: {
          type: 'value',
          show: false
        },
        series: [
          {
            type: 'line',
            data: data,
            smooth: true,
            showSymbol: false,
            lineStyle: {
              width: 2,
              color: isRevenue ? '#F59E0B' : '#3B82F6'
            },
            areaStyle: {
              color: {
                type: 'linear',
                x: 0,
                y: 0,
                x2: 0,
                y2: 1,
                colorStops: [
                  { offset: 0, color: isRevenue ? 'rgba(245, 158, 11, 0.3)' : 'rgba(59, 130, 246, 0.3)' },
                  { offset: 1, color: isRevenue ? 'rgba(245, 158, 11, 0.05)' : 'rgba(59, 130, 246, 0.05)' }
                ]
              }
            }
          }
        ]
      }
    },
    
    // 获取趋势样式类
    getTrendClass(value) {
      if (value > 0) return 'trend-up'
      if (value < 0) return 'trend-down'
      return 'trend-neutral'
    },
    
    // 获取趋势图标
    getTrendIcon(value) {
      if (value > 0) return '↑'
      if (value < 0) return '↓'
      return '→'
    }
  }
}
</script>

<style scoped>
.statistics-container {
  padding: 20px;
  min-height: 100vh;
}

/* 页面切换按钮 */
.tab-buttons {
  display: flex;
  gap: 8px;
  margin-bottom: 20px;
}

.tab-btn {
  padding: 12px 24px;
  border: 2px solid #E5E7EB;
  border-radius: 12px;
  background: white;
  color: #6B7280;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  gap: 8px;
}

.tab-btn:hover {
  border-color: #667eea;
  color: #667eea;
}

.tab-btn.active {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-color: #667eea;
  color: white;
}

/* 筛选控制栏 */
.filter-bar {
  background: white;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
}

.filter-left {
  margin-bottom: 20px;
}

.page-title {
  font-size: 28px;
  font-weight: 700;
  color: #1F2937;
  margin: 0;
}

.filter-controls {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 20px;
}

.filter-item {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-wrap: wrap;
}

.filter-item label {
  font-weight: 600;
  color: #4B5563;
  white-space: nowrap;
}

.date-buttons {
  display: flex;
  gap: 8px;
}

.date-btn {
  padding: 8px 16px;
  border: 1px solid #E5E7EB;
  border-radius: 8px;
  background: white;
  color: #6B7280;
  cursor: pointer;
  transition: all 0.2s;
  font-size: 14px;
}

.date-btn:hover {
  border-color: #667eea;
  color: #667eea;
}

.date-btn.active {
  background: #667eea;
  border-color: #667eea;
  color: white;
}

.custom-date {
  display: flex;
  align-items: center;
  gap: 8px;
}

.custom-date input {
  padding: 8px 12px;
  border: 1px solid #E5E7EB;
  border-radius: 8px;
  font-size: 14px;
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

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
}

.btn-secondary {
  background: white;
  border: 1px solid #E5E7EB;
  color: #6B7280;
}

.btn-secondary:hover {
  border-color: #667eea;
  color: #667eea;
}

/* 核心指标卡片 */
.metrics-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
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
  transition: all 0.3s;
  position: relative;
  overflow: hidden;
}

.metric-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.metric-icon {
  width: 50px;
  height: 50px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  flex-shrink: 0;
}

.metric-icon.orders {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.metric-icon.revenue {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

.metric-icon.avg-order {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
}

.metric-icon.cancel-rate {
  background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
}

.metric-icon.dishes {
  background: linear-gradient(135deg, #30cfd0 0%, #330867 100%);
}

.metric-content {
  flex: 1;
}

.metric-label {
  font-size: 13px;
  color: #6B7280;
  margin-bottom: 8px;
}

.metric-value {
  font-size: 28px;
  font-weight: 700;
  color: #1F2937;
  margin-bottom: 4px;
}

.metric-value.warning {
  color: #EF4444;
}

.metric-trend {
  font-size: 13px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 4px;
}

.metric-trend.trend-up {
  color: #10B981;
}

.metric-trend.trend-down {
  color: #EF4444;
}

.metric-trend.trend-neutral {
  color: #6B7280;
}

.metric-subtitle {
  font-size: 12px;
  color: #9CA3AF;
}

.metric-subtitle.warning {
  color: #EF4444;
  font-weight: 600;
}

.sparkline-container {
  position: absolute;
  bottom: 0;
  right: 0;
  width: 100px;
  opacity: 0.3;
}

/* 图表网格 */
.charts-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
}

.chart-card {
  background: white;
  padding: 24px;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.chart-card.full-width {
  grid-column: 1 / -1;
}

.chart-card.half-width {
  grid-column: span 1;
}

.chart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.chart-header h3 {
  font-size: 18px;
  font-weight: 700;
  color: #1F2937;
  margin: 0;
}

.chart-legend {
  display: flex;
  gap: 20px;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 13px;
  color: #6B7280;
}

.legend-item .dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  display: inline-block;
}

.legend-item .dot.blue {
  background: #3B82F6;
}

.legend-item .dot.orange {
  background: #F59E0B;
}

.chart {
  width: 100%;
  height: 400px;
}

/* 加载遮罩 */
.loading-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  z-index: 9999;
}

.loading-spinner {
  width: 50px;
  height: 50px;
  border: 4px solid rgba(255, 255, 255, 0.3);
  border-top-color: white;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.loading-overlay p {
  color: white;
  margin-top: 16px;
  font-size: 16px;
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .charts-grid {
    grid-template-columns: 1fr;
  }
  
  .chart-card.half-width {
    grid-column: span 1;
  }
}

@media (max-width: 768px) {
  .statistics-container {
    padding: 12px;
  }
  
  .filter-controls {
    flex-direction: column;
    align-items: stretch;
  }
  
  .filter-item {
    flex-direction: column;
    align-items: stretch;
  }
  
  .date-buttons {
    flex-wrap: wrap;
  }
  
  .metrics-cards {
    grid-template-columns: 1fr;
  }
}
</style>
