<template>
  <div class="chat-page">
    <header class="chat-header">
      <button class="back-btn" type="button" @click="backToList" aria-label="返回">&lt;</button>
      <div class="merchant-info">
        <div class="merchant-name">{{ activeConversation?.merchantName ?? '消息详情' }}</div>
        <div v-if="activeConversation" class="merchant-status">
          {{ activeConversation.isActive ? '会话中' : '已停用' }}
        </div>
      </div>
      <button class="more-btn" type="button" aria-label="更多操作">...</button>
    </header>

    <main ref="chatBody" class="chat-body">
      <div v-if="loading" class="empty-state">会话加载中…</div>
      <div v-else-if="error" class="empty-state">{{ error }}</div>
      <div v-else-if="!activeConversation" class="empty-state">未找到该会话，返回列表重试。</div>

      <template v-else>
        <div
          v-for="message in thread"
          :key="message.id"
          class="chat-item"
          :class="message.sender === 'customer' ? 'is-self' : 'is-merchant'"
        >
          <img
            v-if="message.sender === 'merchant'"
            class="avatar"
            :src="activeConversation.avatar"
            :alt="`${activeConversation.merchantName} 头像`"
          />

          <div class="bubble-wrapper">
            <div class="bubble">
              <p v-if="message.type === 'text'" class="bubble-text">{{ message.content }}</p>

              <div v-else-if="message.type === 'system_coupon_recommendation'" class="coupon-recommendation-card">
                <p class="coupon-content">{{ message.content }}</p>
                <div v-if="!message.processed" class="coupon-actions">
                  <button
                    type="button"
                    class="btn btn-accept"
                    @click="acceptCoupon(message.couponId)"
                    :disabled="processingAction"
                  >
                    ✓ 接受优惠
                  </button>
                  <button
                    type="button"
                    class="btn btn-reject"
                    @click="rejectCoupon(message.couponId)"
                    :disabled="processingAction"
                  >
                    ✗ 暂不需要
                  </button>
                </div>
              </div>

              <div v-else-if="message.type === 'survey'" class="survey-card">
                <p class="survey-question">{{ message.content }}</p>
                <div class="survey-options">
                  <button type="button">😡 很不满</button>
                  <button type="button">🙁 不满</button>
                  <button type="button">😐 还可以</button>
                  <button type="button">🙂 满意</button>
                  <button type="button">😄 很满意</button>
                </div>
              </div>
            </div>
            <span class="message-time">{{ formatTime(message.timestamp) }}</span>
          </div>

          <img
            v-if="message.sender === 'customer'"
            class="avatar"
            :src="customerAvatar"
            alt="用户头像"
          />
        </div>
      </template>
    </main>

    <footer v-if="activeConversation && !error && !isSystemNotification" class="chat-input">
      <input
        v-model="draft"
        type="text"
        class="message-field"
        placeholder="请输入要发送的内容"
        @keyup.enter="sendMessage"
      />
      <button class="send-btn" type="button" @click="sendMessage">发送</button>
    </footer>
  </div>
</template>

<script setup>
import { computed, nextTick, ref, watch, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const API_BASE = API_url

const route = useRoute()
const router = useRouter()

const chatBody = ref(null)
const activeConversation = ref(null)
const thread = ref([])
const draft = ref('')
const loading = ref(false)
const error = ref('')
const processingAction = ref(false)

const currentUser = (() => {
  try {
    return JSON.parse(localStorage.getItem('user') || 'null')
  } catch (err) {
    console.warn('无法解析本地用户信息', err)
    return null
  }
})()

const customerAvatar = computed(() => {
  if (currentUser?.avatar) return currentUser.avatar
  const seed = currentUser?.id || currentUser?.username || 'user'
  return `https://picsum.photos/seed/user-${seed}/120/120`
})

const isBroadcast = computed(() => {
  const type = route.query.type
  const idParam = String(route.params.id || '')
  return type === 'broadcast' || idParam.startsWith('broadcast-')
})

const isDishLaunch = computed(() => {
  const type = route.query.type
  const idParam = String(route.params.id || '')
  return type === 'dish_launch' || idParam.startsWith('dish-launch-')
})

const isCoupon = computed(() => {
  const type = route.query.type
  const idParam = String(route.params.id || '')
  return type === 'coupon' || idParam.startsWith('coupon-')
})

const isSystemRecommendCoupon = computed(() => {
  const type = route.query.type
  return type === 'system_recommend_coupon'
})

const isOrderPickup = computed(() => {
  const type = route.query.type
  const idParam = String(route.params.id || '')
  return type === 'order_pickup' || idParam.startsWith('order-pickup-')
})

const isTicket = computed(() => {
  const type = route.query.type
  const idParam = String(route.params.id || '')
  return type === 'ticket' || idParam.startsWith('ticket-')
})

const isSystemNotification = computed(() => {
  const type = route.query.type
  const idParam = String(route.params.id || '')
  return type === 'system_notification' || idParam.startsWith('system_')
})

onMounted(loadConversation)

watch(
  () => route.fullPath,
  () => {
    loadConversation()
  }
)

watch(
  thread,
  () => {
    scrollToBottom()
  },
  { deep: true }
)

async function loadConversation() {
  loading.value = true
  error.value = ''
  activeConversation.value = null
  thread.value = []
  try {
    if (isBroadcast.value) {
      await loadBroadcastConversation()
    } else if (isDishLaunch.value) {
      await loadDishLaunchConversation()
    } else if (isCoupon.value) {
      await loadCouponConversation()
    } else if (isSystemRecommendCoupon.value) {
      await loadSystemRecommendCouponConversation()
    } else if (isOrderPickup.value) {
      await loadOrderPickupConversation()
    } else if (isTicket.value) {
      await loadTicketConversation()
    } else if (isSystemNotification.value) {
      await loadSystemNotificationConversation()
    } else {
      error.value = '暂不支持该类型会话'
    }
  } catch (err) {
    console.error(err)
    error.value = err.message || '会话加载失败'
  } finally {
    loading.value = false
    scrollToBottom()
  }
}

async function loadOrderPickupConversation() {
  const idParam = String(route.params.id || '')
  const numericId = Number(idParam.replace('order-pickup-', ''))
  if (!numericId) {
    throw new Error('未识别的取餐通知编号')
  }

  let notification = typeof history !== 'undefined' ? history.state?.pickupNotification : null
  if (!notification || Number(notification.id) !== numericId) {
    const token = localStorage.getItem('token') || ''
    if (!token) {
      throw new Error('用户未登录')
    }

    const headers = {
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json'
    }

    const response = await fetch(`${API_BASE}/api/orders/pickup-notifications/${numericId}`, { headers })
    const body = await response.json().catch(() => ({}))
    if (!response.ok) {
      throw new Error(body?.message || '获取取餐通知失败')
    }
    notification = body?.data
  }

  if (!notification) {
    throw new Error('未找到取餐通知')
  }

  activeConversation.value = mapPickupNotificationToConversation(notification)
  thread.value = buildPickupThread(notification)
}

async function loadTicketConversation() {
  const idParam = String(route.params.id || '')
  const numericId = Number(idParam.replace('ticket-', ''))
  if (!numericId) {
    throw new Error('未识别的工单编号')
  }

  const token = localStorage.getItem('token') || ''
  const headers = token
    ? { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' }
    : {}

  let ticket = typeof history !== 'undefined' ? history.state?.ticket : null
  if (!ticket || ticket.id !== numericId) {
    const response = await fetch(`${API_BASE}/api/support/tickets/${numericId}`, { headers })
    const body = await response.json().catch(() => ({}))
    if (!response.ok) {
      throw new Error(body?.message || '获取工单详情失败')
    }
    ticket = body?.data
    console.log(ticket)
  }

  if (!ticket) {
    throw new Error('未找到该工单')
  }

  activeConversation.value = mapTicketToConversation(ticket)
  thread.value = buildTicketThread(ticket)
}

function mapTicketToConversation(ticket) {
  return {
    id: `ticket-${ticket.id}`,
    merchantName: `客服工单 #${ticket.ticket_number || ticket.id}`,
    avatar: 'https://picsum.photos/seed/support/120/120',
    title: ticket.subject,
    createdAt: ticket.created_at,
    isActive: true
  }
}

function buildTicketThread(ticket) {
  const items = []
  // 首条为用户提交的工单内容
  items.push({
    id: `ticket-${ticket.id}-create`,
    sender: 'customer',
    type: 'text',
    content: `${ticket.subject || ''}\n\n${ticket.content || ''}`.trim(),
    timestamp: ticket.created_at || new Date().toISOString()
  })

  const replies = ticket.replies || []
  replies.forEach((r, idx) => {
    const sender = r.author_id && currentUser && Number(r.author_id) === Number(currentUser.id) ? 'customer' : 'merchant'
    items.push({
      id: `ticket-${ticket.id}-reply-${idx}`,
      sender,
      type: 'text',
      content: r.text || '',
      timestamp: r.created_at || r.timestamp || new Date().toISOString()
    })
  })
  items.sort((a, b) => new Date(a.timestamp) - new Date(b.timestamp));
  return items
}

async function loadSystemNotificationConversation() {
  const idParam = String(route.params.id || '')
  const match = idParam.match(/^system_(\d+)_(.+)$/)
  if (!match) {
    throw new Error('未识别的系统通知编号')
  }

  const admin_id = Number(match[1])
  const target_audience = match[2]

  // 从后端获取当前用户的系统通知
  const token = localStorage.getItem('token') || ''
  if (!token) {
    throw new Error('用户未登录')
  }

  try {
    const response = await fetch(`${API_BASE}/api/users/system-notifications`, {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      }
    })

    const body = await response.json().catch(() => ({}))
    if (!response.ok) {
      throw new Error(body?.message || '获取系统通知失败')
    }

    // 从返回的通知列表中找到匹配的通知
    const notifications = body?.data || []
    const notification = notifications.find(
      n => n.admin_id === admin_id && n.target_audience === target_audience
    )

    if (!notification) {
      throw new Error('未找到该系统通知')
    }

    activeConversation.value = mapSystemNotificationToConversation(notification)
    thread.value = buildSystemNotificationThread(notification)
  } catch (err) {
    throw err
  }
}

function mapSystemNotificationToConversation(notification) {
  const { admin_id, target_audience, messages, admin_name } = notification
  const latestMessage = messages && messages.length > 0 ? messages[messages.length - 1] : null
  const createdIso = latestMessage?.timestamp || new Date().toISOString()

  const audienceLabel = {
    all: '所有用户',
    merchants: '商户',
    users: '用户'
  }[target_audience] || target_audience

  const adminDisplayName = admin_name || `管理员${admin_id}`

  return {
    id: `system_${admin_id}_${target_audience}`,
    merchantName: `系统公告-${adminDisplayName}-${audienceLabel}`,
    avatar: '🔔',
    title: `系统公告`,
    createdAt: createdIso,
    isActive: true
  }
}

function buildSystemNotificationThread(notification) {
  const { messages } = notification
  if (!Array.isArray(messages)) {
    return []
  }

  return messages.map((msg, idx) => ({
    id: `system-notif-${notification.admin_id}-${notification.target_audience}-${idx}`,
    sender: 'merchant',
    type: 'text',
    content: msg.content,
    timestamp: msg.timestamp || new Date().toISOString()
  }))
}

function mapPickupNotificationToConversation(notification) {
  const createdIso = notification?.created_at || new Date().toISOString()
  return {
    id: `order-pickup-${notification?.id}`,
    merchantName: notification?.restaurant_name || '取餐提醒',
    avatar: `https://picsum.photos/seed/order-pickup-${notification?.order_id || notification?.id}/120/120`,
    title: notification?.text || '订单取餐提醒',
    createdAt: createdIso,
    isActive: true,
    pickupNumber: notification?.pickup_number,
    orderNumber: notification?.order_number,
    raw: notification
  }
}

function buildPickupThread(notification) {
  if (!notification) return []

  const timestamp = notification.created_at || new Date().toISOString()
  const messages = []

  messages.push({
    id: `pickup-${notification.id}-main`,
    sender: 'merchant',
    type: 'text',
    content: notification.text || '您的订单已完成，可以前往取餐。',
    timestamp
  })

  const infoParts = []
  if (notification.pickup_number) {
    infoParts.push(`取餐号：${notification.pickup_number}`)
  }
  if (notification.order_number) {
    infoParts.push(`订单编号：${notification.order_number}`)
  }

  const totalPrice = Number(notification.total_price)
  if (Number.isFinite(totalPrice)) {
    infoParts.push(`订单金额：¥${totalPrice.toFixed(2)}`)
  }

  if (Array.isArray(notification.items) && notification.items.length) {
    const itemsPreview = notification.items
      .map((item) => {
        const baseName = item?.dish_name || item?.dish?.name || '菜品'
        const qty = item?.quantity
        return qty ? `${baseName} x${qty}` : baseName
      })
      .filter(Boolean)
      .join('，')
    if (itemsPreview) {
      infoParts.push(`菜品：${itemsPreview}`)
    }
  }

  if (infoParts.length) {
    messages.push({
      id: `pickup-${notification.id}-info`,
      sender: 'merchant',
      type: 'text',
      content: infoParts.join('；'),
      timestamp
    })
  }

  return messages
}

async function loadBroadcastConversation() {
  const idParam = String(route.params.id || '')
  const numericId = Number(idParam.replace('broadcast-', ''))
  if (!numericId) {
    throw new Error('未识别的广播编号')
  }

  let broadcast = typeof history !== 'undefined' ? history.state?.broadcast : null
  if (!broadcast || broadcast.id !== numericId) {
    const response = await fetch(`${API_BASE}/api/restaurant/broadcasts/${numericId}`)
    const body = await response.json().catch(() => ({}))
    if (!response.ok) {
      throw new Error(body?.message || '获取广播详情失败')
    }
    broadcast = body?.data
  }

  if (!broadcast) {
    throw new Error('未找到该广播')
  }

  activeConversation.value = mapBroadcastToConversation(broadcast)
  thread.value = buildBroadcastThread(broadcast)
}

async function loadDishLaunchConversation() {
  const idParam = String(route.params.id || '')
  const numericId = Number(idParam.replace('dish-launch-', ''))
  if (!numericId) {
    throw new Error('未识别的上新通知编号')
  }

  let notification = typeof history !== 'undefined' ? history.state?.dishNotification : null
  if (!notification || notification.id !== numericId) {
    const response = await fetch(`${API_BASE}/api/dish-notifications/${numericId}`)
    const body = await response.json().catch(() => ({}))
    if (!response.ok) {
      throw new Error(body?.message || '获取上新通知详情失败')
    }
    notification = body?.data
  }

  if (!notification) {
    throw new Error('未找到该上新通知')
  }

  activeConversation.value = mapDishNotificationToConversation(notification)
  thread.value = buildDishNotificationThread(notification)
}

async function loadCouponConversation() {
  const idParam = String(route.params.id || '')
  const numericId = Number(idParam.replace('coupon-', ''))
  if (!numericId) {
    throw new Error('未识别的优惠券通知编号')
  }

  let notification = typeof history !== 'undefined' ? history.state?.couponNotification : null
  if (!notification || notification.id !== numericId) {
    const response = await fetch(`${API_BASE}/api/coupon-notifications/${numericId}`)
    const body = await response.json().catch(() => ({}))
    if (!response.ok) {
      throw new Error(body?.message || '获取优惠券通知详情失败')
    }
    notification = body?.data
  }

  if (!notification) {
    throw new Error('未找到该优惠券通知')
  }

  activeConversation.value = mapCouponNotificationToConversation(notification)
  thread.value = buildCouponThread(notification)
}

async function loadSystemRecommendCouponConversation() {
  // 从路由状态中获取推荐数据
  let recommendationData = typeof history !== 'undefined' ? history.state?.recommendationData : null

  // 如果路由状态中没有推荐数据，从API重新获取
  if (!recommendationData) {
    const idParam = String(route.params.id || '')
    const numericId = Number(idParam.replace('system-recommend-', ''))
    if (!numericId) {
      error.value = '推荐数据不存在，请返回消息列表重新进入'
      return
    }

    try {
      const token = localStorage.getItem('token') || ''
      if (!token) {
        throw new Error('用户未登录')
      }

      const response = await fetch(`${API_BASE}/api/coupons/recommendations/${numericId}`, {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      })

      const result = await response.json()
      if (!response.ok) {
        throw new Error(result.message || '获取推荐数据失败')
      }

      recommendationData = result.data
      console.log('从API重新获取推荐数据:', recommendationData)

    } catch (err) {
      console.error('获取推荐数据失败:', err)
      error.value = '推荐数据不存在，请返回消息列表重新进入'
      return
    }
  }

  activeConversation.value = mapSystemRecommendCouponToConversation(recommendationData)
  thread.value = buildSystemRecommendCouponThread(recommendationData)
}

function mapBroadcastToConversation(broadcast) {
  return {
    id: `broadcast-${broadcast.id}`,
    merchantName: broadcast.restaurant_name || '商家广播',
    avatar: `https://picsum.photos/seed/broadcast-${broadcast.restaurant_id || broadcast.id}/120/120`,
    title: broadcast.title,
    createdAt: broadcast.created_at,
    isActive: Boolean(broadcast.is_active)
  }
}

function buildBroadcastThread(broadcast) {
  const formatted = formatBroadcastBody(broadcast.content)
  const time = broadcast.created_at || new Date().toISOString()
  return [
    {
      id: `broadcast-${broadcast.id}-system`,
      sender: 'merchant',
      type: 'text',
      content: [broadcast.title, formatted].filter(Boolean).join('\n\n').trim(),
      timestamp: time
    }
  ]
}

function mapDishNotificationToConversation(notification) {
  const relatedBroadcast = notification.broadcast || null
  return {
    id: `dish-launch-${notification.id}`,
    merchantName: notification.restaurant_name || relatedBroadcast?.restaurant_name || '上新通知',
    avatar: `https://picsum.photos/seed/broadcast-${notification.restaurant_id || relatedBroadcast?.restaurant_id || notification.id}/120/120`,
    title: notification.title,
    createdAt: notification.created_at || relatedBroadcast?.created_at,
    isActive: notification.is_active !== false
  }
}

function mapCouponNotificationToConversation(notification) {
  const relatedBroadcast = notification.broadcast || null
  return {
    id: `coupon-${notification.id}`,
    merchantName: notification.restaurant_name || relatedBroadcast?.restaurant_name || '优惠券通知',
    avatar: `https://picsum.photos/seed/broadcast-${notification.restaurant_id || relatedBroadcast?.restaurant_id || notification.id}/120/120`,
    title: notification.title,
    createdAt: notification.created_at || relatedBroadcast?.created_at,
    isActive: notification.is_active !== false
  }
}

function buildDishNotificationThread(notification) {
  const relatedBroadcast = notification.broadcast || null
  const timestamp = notification.created_at || relatedBroadcast?.created_at || new Date().toISOString()
  const lines = []

  if (notification.message) {
    lines.push(notification.message)
  } else if (relatedBroadcast?.content) {
    lines.push(formatBroadcastBody(relatedBroadcast.content))
  }

  const snapshot = notification.dish_snapshot || {}
  const detailParts = []
  if (snapshot.name) {
    detailParts.push(`菜品：${snapshot.name}`)
  }
  if (snapshot.price !== undefined && snapshot.price !== null) {
    const priceNumber = Number(snapshot.price)
    if (Number.isFinite(priceNumber)) {
      detailParts.push(`价格：¥${priceNumber.toFixed(2)}`)
    }
  }
  if (snapshot.category) {
    detailParts.push(`分类：${snapshot.category}`)
  }
  if (snapshot.stock_quantity !== undefined && snapshot.stock_quantity !== null) {
    detailParts.push(`上新数量：${snapshot.stock_quantity}`)
  }

  if (detailParts.length) {
    lines.push(detailParts.join('｜'))
  }

  return [
    {
      id: `dish-launch-${notification.id}-system`,
      sender: 'merchant',
      type: 'text',
      content: [notification.title, ...lines].filter(Boolean).join('\n\n').trim(),
      timestamp
    }
  ]
}

function buildCouponThread(notification) {
  const relatedBroadcast = notification.broadcast || null
  const timestamp = notification.created_at || relatedBroadcast?.created_at || new Date().toISOString()
  const lines = []

  if (notification.title) {
    lines.push(notification.title)
  }

  const detailParts = []
  const type = (notification.discount_type || '').toLowerCase()
  const amountNumber = Number(notification.amount)
  const minSpendNumber = Number(notification.min_spend)

  if (type === 'amount' && Number.isFinite(amountNumber)) {
    detailParts.push(`优惠金额：¥${amountNumber.toFixed(2)}`)
  } else if (type === 'percentage' && Number.isFinite(amountNumber)) {
    detailParts.push(`折扣力度：${amountNumber.toFixed(0)}%`)
  } else if (type === 'gift') {
    const gift = notification.extra_data?.gift_value || notification.amount || '赠品优惠'
    detailParts.push(`优惠内容：${gift}`)
  }

  if (Number.isFinite(minSpendNumber) && minSpendNumber > 0) {
    detailParts.push(`使用门槛：满 ¥${minSpendNumber.toFixed(2)} 可用`)
  }

  if (notification.valid_from && notification.valid_to) {
    detailParts.push(`有效期：${formatDateRange(notification.valid_from, notification.valid_to)}`)
  } else if (notification.valid_to) {
    detailParts.push(`有效期至：${formatSimpleDate(notification.valid_to)}`)
  }

  if (detailParts.length) {
    lines.push(detailParts.join('｜'))
  }

  if (notification.description) {
    lines.push(notification.description)
  }

  if (relatedBroadcast?.content) {
    lines.push(formatBroadcastBody(relatedBroadcast.content))
  }

  return [
    {
      id: `coupon-${notification.id}-system`,
      sender: 'merchant',
      type: 'text',
      content: lines.filter(Boolean).join('\n\n').trim(),
      timestamp
    }
  ]
}

function mapSystemRecommendCouponToConversation(recommendationData) {
  const coupon = recommendationData.coupon
  const confidenceLevel = recommendationData.confidence_level || '试试看'

  return {
    id: `system-recommend-${coupon?.id}`,
    merchantName: '智能推荐',
    avatar: 'https://picsum.photos/seed/system-recommend/120/120',
    title: `系统推荐优惠券 ${confidenceLevel}`,
    createdAt: coupon?.created_at || new Date().toISOString(),
    isActive: true,
    isSystemRecommended: true
  }
}

function buildSystemRecommendCouponThread(recommendationData) {
  const coupon = recommendationData.coupon
  const confidenceLevel = recommendationData.confidence_level || '试试看'
  const recommendationReasons = recommendationData.recommendation_reasons || []
  const timestamp = coupon?.created_at || new Date().toISOString()

  const lines = []
  lines.push(`🎁 ${confidenceLevel}优惠券推荐`)

  // 添加推荐理由
  if (recommendationReasons.length > 0) {
    lines.push(`推荐理由：${recommendationReasons.join('、')}`)
  }

  // 添加优惠券详情
  const detailParts = []
  const type = (coupon.discount_type || '').toLowerCase()
  const amountNumber = Number(coupon.amount)
  const minSpendNumber = Number(coupon.min_spend)

  if (type === 'amount' && Number.isFinite(amountNumber)) {
    detailParts.push(`立减 ¥${amountNumber.toFixed(2)}`)
  } else if (type === 'percentage' && Number.isFinite(amountNumber)) {
    detailParts.push(`${amountNumber.toFixed(0)}折优惠`)
  }

  if (Number.isFinite(minSpendNumber) && minSpendNumber > 0) {
    detailParts.push(`满 ¥${minSpendNumber.toFixed(2)} 可用`)
  }

  if (coupon.valid_to) {
    detailParts.push(`有效期至：${formatSimpleDate(coupon.valid_to)}`)
  }

  if (detailParts.length) {
    lines.push(`优惠详情：${detailParts.join('｜')}`)
  }

  if (coupon.description) {
    lines.push(coupon.description)
  }

  lines.push(`适用餐厅：${coupon.restaurant_name || '未知餐厅'}`)
  lines.push('温馨提示：确认接受后将自动关注该餐厅，您将收到该餐厅的最新动态。')

  return [
    {
      id: `system-recommend-${coupon.id}-system`,
      sender: 'merchant',
      type: 'system_coupon_recommendation',
      content: lines.filter(Boolean).join('\n\n').trim(),
      timestamp,
      couponId: coupon.id,
      confidenceLevel,
      recommendationReasons
    }
  ]
}

function formatBroadcastBody(content) {
  if (!content) return ''
  const parts = content.split('\n')
  if (!parts.length) return ''
  const [firstLine, ...rest] = parts
  const payload = []
  if (firstLine?.startsWith('【发送对象')) {
    payload.push(firstLine)
  } else if (firstLine) {
    payload.push(firstLine)
  }
  const restContent = rest.join('\n').trim()
  if (restContent) payload.push(restContent)
  return payload.join('\n\n')
}
 
  function formatSimpleDate(isoString) {
    if (!isoString) return ''
    const date = new Date(isoString)
    if (Number.isNaN(date.getTime())) return ''
    return date.toLocaleDateString('zh-CN', {
      month: 'short',
      day: 'numeric'
    })
  }

function formatDateRange(start, end) {
  const startText = formatSimpleDate(start)
  const endText = formatSimpleDate(end)
  if (startText && endText) {
    return `${startText} - ${endText}`
  }
  return endText || startText || ''
}

function backToList() {
  if (typeof window !== 'undefined' && window.history.length > 1) {
    router.back()
  } else {
    router.push('/messages')
  }
}

function sendMessage() {
  if (loading.value || error.value) return
  const content = draft.value.trim()
  if (!content) return

  if (isTicket.value && activeConversation.value && route.params.id) {
    // 发送到工单回复接口
    const idParam = String(route.params.id || '')
    const numericId = Number(idParam.replace('ticket-', ''))
    const token = localStorage.getItem('token') || ''
    const headers = token
      ? { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' }
      : { 'Content-Type': 'application/json' }

    // Optimistic local push
    const localMsg = {
      id: `local-${Date.now()}`,
      sender: 'customer',
      type: 'text',
      content,
      timestamp: new Date().toISOString()
    }
    thread.value.push(localMsg)
    draft.value = ''

    fetch(`${API_BASE}/api/support/tickets/${numericId}/reply`, {
      method: 'POST',
      headers,
      body: JSON.stringify({
        text :  content,
        from :  '用户',
        created_at: new Date().toISOString() 
      })
    })
      .then(async (res) => {
        const body = await res.json().catch(() => ({}))
        if (!res.ok) {
          throw new Error(body?.message || '发送回复失败')
        }
        const created = body?.data
        if (created) {
          // replace the optimistic item with server item
          const idx = thread.value.findIndex((m) => m.id === localMsg.id)
          const msg = {
            id: `ticket-reply-${created.created_at || Date.now()}`,
            sender: currentUser && Number(created.author_id) === Number(currentUser.id) ? 'customer' : 'merchant',
            type: 'text',
            content: created.content || content,
            timestamp: created.created_at || new Date().toISOString()
          }
          if (idx >= 0) thread.value.splice(idx, 1, msg)
          else thread.value.push(msg)
        }
      })
      .catch((err) => {
        console.error(err)
      })
  } else {
    thread.value.push({
      id: `local-${Date.now()}`,
      sender: 'customer',
      type: 'text',
      content,
      timestamp: new Date().toISOString()
    })
    draft.value = ''
  }
}

function formatTime(timestamp) {
  if (!timestamp) return ''
  const date = new Date(timestamp)
  if (Number.isNaN(date.getTime())) return timestamp
  return date.toLocaleTimeString( {
    hour: '2-digit',
    minute: '2-digit'
  })
}

function scrollToBottom() {
  nextTick(() => {
    if (chatBody.value) {
      chatBody.value.scrollTop = chatBody.value.scrollHeight
    }
  })
}

async function acceptCoupon(couponId) {
  if (processingAction.value) return

  processingAction.value = true
  try {
    const token = localStorage.getItem('token') || ''
    if (!token) {
      throw new Error('用户未登录')
    }

    const response = await fetch(`${API_BASE}/api/coupons/${couponId}/accept`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      }
    })

    const result = await response.json()

    if (!response.ok) {
      throw new Error(result.message || '操作失败')
    }

    // 添加成功消息
    const successMessage = {
      id: `accept-${Date.now()}`,
      sender: 'customer',
      type: 'text',
      content: result.message || '已接受优惠券推荐！',
      timestamp: new Date().toISOString()
    }
    thread.value.push(successMessage)

    // 更新原有的推荐消息为已处理状态
    const recommendMessage = thread.value.find(msg => msg.couponId === couponId)
    if (recommendMessage) {
      recommendMessage.processed = true
    }

  } catch (err) {
    console.error('接受优惠券失败:', err)
    // 添加错误消息
    const errorMessage = {
      id: `error-${Date.now()}`,
      sender: 'customer',
      type: 'text',
      content: `操作失败：${err.message}`,
      timestamp: new Date().toISOString()
    }
    thread.value.push(errorMessage)
  } finally {
    processingAction.value = false
    scrollToBottom()
  }
}

async function rejectCoupon(couponId) {
  if (processingAction.value) return

  processingAction.value = true
  try {
    const token = localStorage.getItem('token') || ''
    if (!token) {
      throw new Error('用户未登录')
    }

    const response = await fetch(`${API_BASE}/api/coupons/${couponId}/reject`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      }
    })

    const result = await response.json()

    if (!response.ok) {
      throw new Error(result.message || '操作失败')
    }

    // 添加确认消息
    const confirmMessage = {
      id: `reject-${Date.now()}`,
      sender: 'customer',
      type: 'text',
      content: result.message || '已记录您的选择，我们将优化后续推荐',
      timestamp: new Date().toISOString()
    }
    thread.value.push(confirmMessage)

    // 更新原有的推荐消息为已处理状态
    const recommendMessage = thread.value.find(msg => msg.couponId === couponId)
    if (recommendMessage) {
      recommendMessage.processed = true
    }

  } catch (err) {
    console.error('拒绝优惠券失败:', err)
    // 添加错误消息
    const errorMessage = {
      id: `error-${Date.now()}`,
      sender: 'customer',
      type: 'text',
      content: `操作失败：${err.message}`,
      timestamp: new Date().toISOString()
    }
    thread.value.push(errorMessage)
  } finally {
    processingAction.value = false
    scrollToBottom()
  }
}
</script>

<style scoped>
.chat-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: linear-gradient(180deg, #f6f8fd 0%, #ffffff 20%);
}

.chat-header {
  display: flex;
  align-items: center;
  padding: 16px 20px 12px;
  background: #ffffff;
  border-bottom: 1px solid #eef0f4;
  gap: 12px;
}

.back-btn,
.more-btn {
  width: 36px;
  height: 36px;
  border-radius: 18px;
  border: none;
  background: #f0f3f8;
  color: #333b4b;
  font-size: 18px;
  line-height: 1;
}

.merchant-info {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.merchant-name {
  font-size: 18px;
  font-weight: 600;
  color: #191d26;
}

.merchant-status {
  font-size: 12px;
  color: #60c27d;
  margin-top: 2px;
}

.chat-body {
  flex: 1;
  overflow-y: auto;
  padding: 16px 16px 12px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.empty-state {
  margin-top: 120px;
  text-align: center;
  color: #a0a6b3;
}

.chat-item {
  display: flex;
  align-items: flex-end;
  gap: 10px;
}

.chat-item.is-self {
  flex-direction: row-reverse;
}

.chat-item.is-self .bubble-wrapper {
  align-items: flex-end;
}

.chat-item.is-self .bubble {
  background: #1677ff;
  color: #ffffff;
  border-top-right-radius: 4px;
  border-top-left-radius: 16px;
  border-bottom-left-radius: 16px;
  border-bottom-right-radius: 16px;
}

.avatar {
  width: 36px;
  height: 36px;
  border-radius: 18px;
  object-fit: cover;
}

.bubble-wrapper {
  display: flex;
  flex-direction: column;
  gap: 6px;
  align-items: flex-start;
}

.bubble {
  max-width: min(75vw, 320px);
  padding: 12px 14px;
  background: #ffffff;
  border-radius: 16px;
  border-top-left-radius: 4px;
  box-shadow: 0 6px 16px rgba(20, 24, 35, 0.08);
  position: relative;
}

.bubble-text {
  margin: 0;
  font-size: 15px;
  line-height: 1.5;
  color: inherit;
}

.survey-card {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.survey-question {
  margin: 0;
  font-size: 14px;
  color: inherit;
  font-weight: 600;
}

.survey-options {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(92px, 1fr));
  gap: 8px;
}

.survey-options button {
  padding: 6px 8px;
  border-radius: 12px;
  border: 1px solid #dbe1ec;
  background: #f7f9ff;
  font-size: 12px;
  color: #444b57;
}

.message-time {
  font-size: 11px;
  color: #9ba2af;
  padding-bottom: 2px;
}

.chat-input {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 16px 24px;
  background: #ffffff;
  border-top: 1px solid #dfe3eb;
}

.message-field {
  flex: 1;
  height: 42px;
  border-radius: 22px;
  border: 1px solid #d7dce5;
  padding: 0 16px;
  font-size: 14px;
  background: #f7f8fb;
}

.message-field:focus {
  outline: none;
  border-color: #1677ff;
  background: #ffffff;
}

.send-btn {
  padding: 0 18px;
  height: 42px;
  border-radius: 22px;
  border: none;
  background: linear-gradient(120deg, #1677ff 0%, #5a9bff 100%);
  color: #ffffff;
  font-weight: 600;
}

.coupon-recommendation-card {
  display: flex;
  flex-direction: column;
  gap: 16px;
  padding: 4px;
}

.coupon-content {
  margin: 0;
  font-size: 14px;
  color: inherit;
  line-height: 1.6;
  white-space: pre-line;
}

.coupon-actions {
  display: flex;
  gap: 12px;
  padding-top: 8px;
  border-top: 1px solid #f0f0f0;
}

.coupon-actions .btn {
  flex: 1;
  padding: 8px 16px;
  border-radius: 20px;
  border: 1px solid;
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
}

.coupon-actions .btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.coupon-actions .btn-accept {
  background: linear-gradient(120deg, #52c41a 0%, #73d13d 100%);
  border-color: #52c41a;
  color: #ffffff;
}

.coupon-actions .btn-accept:hover:not(:disabled) {
  background: linear-gradient(120deg, #389e0d 0%, #52c41a 100%);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(82, 196, 26, 0.3);
}

.coupon-actions .btn-reject {
  background: #ffffff;
  border-color: #d9d9d9;
  color: #666666;
}

.coupon-actions .btn-reject:hover:not(:disabled) {
  border-color: #ff4d4f;
  color: #ff4d4f;
  background: #fff2f0;
}
</style>
