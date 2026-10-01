import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import './merchant/styles.css'
import axios from 'axios'

// 导入 ECharts 和 vue-echarts
import ECharts from 'vue-echarts'
import { use } from 'echarts/core'

// 手动引入 ECharts 各模块来减小打包体积
import {
    CanvasRenderer
} from 'echarts/renderers'
import {
    LineChart,
    PieChart
} from 'echarts/charts'
import {
    GridComponent,
    TooltipComponent,
    LegendComponent,
    TitleComponent
} from 'echarts/components'

// 注册必须的组件
use([
    CanvasRenderer,
    LineChart,
    PieChart,
    GridComponent,
    TooltipComponent,
    LegendComponent,
    TitleComponent
])

// fetch封装，实现全局检查用户是否被封禁
export function fetch_request(input, init) {
    return fetch(input, init).then(response => {
        const url =
            typeof input === 'string'
                ? input
                : input instanceof Request
                ? input.url
                : ''

        const isAppealRequest = url.includes('/appeal')
        const isAuthRequest = url.includes('/login') || 
                              url.includes('/register') || 
                              url.includes('/reset-password') ||
                              url.includes('/sms')

        if (response.status === 401 && !isAppealRequest && !isAuthRequest) {
            // token 失效，但排除申诉及公开认证接口
            localStorage.removeItem('token')
            localStorage.removeItem('user')
            window.location.href = '/login'
        }

        // ⚠️ 不吞掉 response，保持 fetch 原始行为
        return response
    })
}

// 配置 axios
axios.defaults.baseURL = '/api'
axios.defaults.timeout = 10000

// 请求拦截器 - 添加 token
axios.interceptors.request.use(
    config => {
        const token = localStorage.getItem('token')
        if (token) {
            config.headers.Authorization = `Bearer ${token}`
        }
        return config
    },
    error => {
        return Promise.reject(error)
    }
)

// 响应拦截器 - 处理错误
axios.interceptors.response.use(
    response => {
        return response
    },
    error => {
        // 检查是否是申诉相关的API请求
        const isAppealRequest = error.config?.url?.includes('/appeal')
        // 检查是否是登录、注册、重置密码、发送短信等公开认证API请求
        const isAuthRequest = error.config?.url?.includes('/login') || 
                              error.config?.url?.includes('/register') || 
                              error.config?.url?.includes('/reset-password') ||
                              error.config?.url?.includes('/sms')

        if (error.response?.status === 401 && !isAppealRequest && !isAuthRequest) {
            // token 过期或无效，但排除申诉及公开认证相关请求（被封禁用户需要申诉功能）
            localStorage.removeItem('token')
            localStorage.removeItem('user')
            window.location.href = '/login'
        }
        return Promise.reject(error)
    }
)

const app = createApp(App)

// 全局注册 v-chart 组件
app.component('v-chart', ECharts)

// 将 axios 挂载到全局属性
app.config.globalProperties.$axios = axios

app.use(router)
app.mount('#app')