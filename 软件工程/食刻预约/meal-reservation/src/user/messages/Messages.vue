<template>
  <div class="messages-page">
    <header class="page-header">
      <div class="title">消息</div>
      <button class="header-action" type="button" aria-label="更多">
        ⋯
      </button>
    </header>

    <section class="conversation-list">
      <div v-if="loading" class="hint">正在为您加载消息…</div>
      <div v-else-if="error" class="hint error">{{ error }}</div>

      <template v-else>
        <article
          v-for="conversation in conversations"
          :key="conversation.id"
          class="conversation-card"
          @click="openConversation(conversation)"
        >
          <img
            class="avatar"
            :src="conversation.avatar"
            :alt="`${conversation.merchantName} 头像`"
          />
          <div class="conversation-main">
            <div class="conversation-top">
              <h3 class="merchant-name">{{ conversation.merchantName }}</h3>
              <span class="timestamp">{{ conversation.lastTimestamp }}</span>
            </div>
            <div class="conversation-bottom">
              <p class="preview" :title="conversation.lastMessagePreview">
                {{ conversation.lastMessagePreview }}
              </p>
              <span
                v-if="conversation.unreadCount && notificationPreference === 'normal'"
                class="unread-badge"
              >
                {{ conversation.unreadCount }}
              </span>
              <span
                v-else-if="conversation.unreadCount && notificationPreference === 'dnd'"
                class="unread-dot"
                aria-label="有新消息"
              ></span>
            </div>
          </div>
        </article>

        <div v-if="!conversations.length" class="empty-state">
          暂无消息
        </div>
      </template>
    </section>

    <BottomNav />
  </div>
</template>

<script setup>
import { computed, onMounted, onUnmounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import BottomNav from '../components/BottomNav.vue'

const router = useRouter()
const API_BASE = API_url

const loading = ref(false)
const error = ref('')
const NOTIFICATION_PREF_KEY = 'notificationPreference'
const DEFAULT_NOTIFICATION_MODE = 'normal'
const notificationPreference = ref(getNotificationPreference())
const broadcasts = ref([])
const dishNotifications = ref([])
const couponNotifications = ref([])
const systemRecommendedCoupons = ref([])
const pickupNotifications = ref([])
const applications = ref([])
const supportTickets = ref([])
const systemNotifications = ref([])

function normalizePreference(value) {
  return value === 'dnd' ? 'dnd' : DEFAULT_NOTIFICATION_MODE
}

function getNotificationPreference() {
  try {
    const stored = localStorage.getItem(NOTIFICATION_PREF_KEY)
    return normalizePreference(stored)
  } catch (err) {
    console.warn('读取通知偏好失败', err)
    return DEFAULT_NOTIFICATION_MODE
  }
}

function handlePreferenceEvent(event) {
  const detail = event?.detail
  notificationPreference.value = normalizePreference(typeof detail === 'string' ? detail : detail?.value)
}

function handleStorageChange(event) {
  if (event.key !== NOTIFICATION_PREF_KEY) {
    return
  }
  notificationPreference.value = normalizePreference(event.newValue)
}

const currentUser = (() => {
  try {
    return JSON.parse(localStorage.getItem('user') || 'null')
  } catch (err) {
    console.warn('无法解析本地用户信息', err)
    return null
  }
})()

const conversations = computed(() => {
  const broadcastItems = broadcasts.value
    .filter((item) => shouldDisplayToUser(item))
    .map((item) => mapBroadcastToConversation(item))

  const dishItems = dishNotifications.value
    .filter((item) => shouldDisplayDishNotification(item))
    .map((item) => mapDishNotificationToConversation(item))

  const couponItems = couponNotifications.value
    .filter((item) => shouldDisplayCouponNotification(item))
    .map((item) => mapCouponNotificationToConversation(item))

  const systemCouponItems = systemRecommendedCoupons.value
    .map((item) => mapSystemRecommendedCouponToConversation(item))

  const pickupItems = pickupNotifications.value
    .map((item) => mapPickupNotificationToConversation(item))
    .filter(Boolean)

  const applicationItems = applications.value
    .map((item) => mapApplicationToConversation(item))

  const ticketItems = supportTickets.value
    .map((t) => mapTicketToConversation(t))

  const adminSystemNotifications = systemNotifications.value
    .map((item) => mapSystemNotificationToConversation(item))

  return [...broadcastItems, ...dishItems, ...couponItems, ...systemCouponItems, ...pickupItems, ...applicationItems, ...ticketItems, ...adminSystemNotifications].sort((a, b) => (b.createdAt || 0) - (a.createdAt || 0))
})

onMounted(() => {
  notificationPreference.value = getNotificationPreference()
  window.addEventListener('notification-preference-changed', handlePreferenceEvent)
  window.addEventListener('storage', handleStorageChange)
  loadMessages()
})

onUnmounted(() => {
  window.removeEventListener('notification-preference-changed', handlePreferenceEvent)
  window.removeEventListener('storage', handleStorageChange)
})

async function loadMessages() {
  loading.value = true
  error.value = ''
  try {
    const token = localStorage.getItem('token') || ''
    const authHeaders = token
      ? {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      : null

    // 加载广播消息
    const broadcastParams = new URLSearchParams({
      include_inactive: 'false',
      per_page: '100'
    })

    const dishParams = new URLSearchParams({
      include_inactive: 'false',
      per_page: '100'
    })

    const couponParams = new URLSearchParams({
      include_inactive: 'false',
      per_page: '100'
    })

    const couponPromise = authHeaders
      ? fetch(`${API_BASE}/api/coupon-notifications?${couponParams.toString()}`, {
          headers: authHeaders
        }).then(async (res) => {
          if (!res.ok) {
            const body = await res.json().catch(() => ({}))
            throw new Error(body?.message || '优惠券通知获取失败')
          }
          const body = await res.json()
          return body?.data?.records ?? []
        })
      : Promise.resolve([])

    const [broadcastResult, dishResult, couponResult] = await Promise.allSettled([
      fetch(`${API_BASE}/api/restaurant/broadcasts?${broadcastParams.toString()}`)
        .then(async (res) => {
          if (!res.ok) throw new Error('广播列表获取失败')
          const body = await res.json()
          return body?.data?.records ?? []
        }),
      fetch(`${API_BASE}/api/dish-notifications?${dishParams.toString()}`)
        .then(async (res) => {
          if (!res.ok) throw new Error('菜品上新通知获取失败')
          const body = await res.json()
          return body?.data?.records ?? []
        }),
      couponPromise
    ])

    let successCount = 0
    const partialErrors = []

    if (broadcastResult.status === 'fulfilled') {
      broadcasts.value = broadcastResult.value
      successCount += 1
    } else {
      partialErrors.push(broadcastResult.reason?.message || '广播加载失败')
    }

    if (dishResult.status === 'fulfilled') {
      dishNotifications.value = dishResult.value
      successCount += 1
    } else {
      partialErrors.push(dishResult.reason?.message || '菜品上新通知加载失败')
    }

    if (couponResult.status === 'fulfilled') {
      couponNotifications.value = couponResult.value
      if (authHeaders) {
        successCount += 1
      }
    } else if (authHeaders) {
      partialErrors.push(couponResult.reason?.message || '优惠券通知加载失败')
    }

    // 加载商户申请消息
    if (authHeaders) {
      const headers = {
        ...authHeaders
      }
      try {
        const applicationResponse = await fetch(`${API_BASE}/api/merchant-application`, { headers })
        if (applicationResponse.ok) {
          const applicationBody = await applicationResponse.json()
          applications.value = applicationBody?.data?.applications ?? []
          successCount += 1
        } else if (applicationResponse.status !== 401) {
          // 忽略未授权错误（未登录用户）
          partialErrors.push('商户申请消息获取失败')
        }
      } catch (err) {
        partialErrors.push('商户申请消息获取失败')
      }

      try {
        const pickupResponse = await fetch(`${API_BASE}/api/orders/pickup-notifications`, { headers })
        if (pickupResponse.ok) {
          const pickupBody = await pickupResponse.json()
          pickupNotifications.value = pickupBody?.data ?? []
        } else if (pickupResponse.status !== 401) {
          partialErrors.push('取餐通知获取失败')
        }
      } catch (err) {
        partialErrors.push('取餐通知获取失败')
      }
    }

    if (!successCount) {
      throw new Error(partialErrors.join('；') || '消息列表加载失败')
    }

    if (successCount && partialErrors.length) {
      error.value = partialErrors.join('；')
    }

    // 加载用户的支持工单作为会话项
    if (authHeaders) {
      try {
        const resp = await fetch(`${API_BASE}/api/support/tickets`, { headers: authHeaders })
        if (resp.ok) {
          const body = await resp.json()

          supportTickets.value = body?.data
          console.log(supportTickets.value)
        }
      } catch (e) {
        // 忽略，不阻塞主流程
        console.warn('加载工单失败', e)
      }

      // 加载系统推荐的优惠券
      try {
        const couponResp = await fetch(`${API_BASE}/api/coupons/recommendations?limit=5`, { headers: authHeaders })

        if (couponResp.ok) {
          const couponBody = await couponResp.json()
          if (couponBody.success && couponBody.data?.recommendations) {
            systemRecommendedCoupons.value = couponBody.data.recommendations
            console.log('系统推荐优惠券:', systemRecommendedCoupons.value)
          } else {
            console.warn('推荐API返回格式异常:', couponBody)
          }
        } else {
          const errorText = await couponResp.text()
          console.error('推荐API调用失败:', couponResp.status, errorText)
        }
      } catch (e) {
        // 忽略，不阻塞主流程
        console.warn('加载推荐优惠券失败', e)
      }

      // 加载系统通知（管理员发布的公告）
      try {
        const notifResp = await fetch(`${API_BASE}/api/users/system-notifications`, { headers: authHeaders })
        if (notifResp.ok) {
          const notifBody = await notifResp.json()
          if (notifBody.success && Array.isArray(notifBody.data)) {
            systemNotifications.value = notifBody.data
            console.log('系统通知:', systemNotifications.value)
          }
        }
      } catch (e) {
        // 忽略，不阻塞主流程
        console.warn('加载系统通知失败', e)
      }
    }
  } catch (err) {
    console.error(err)
    error.value = err.message || '加载消息列表失败'
  } finally {
    loading.value = false
  }
}

function mapTicketToConversation(ticket) {
  const latest = (ticket.replies && ticket.replies.length) ? ticket.replies[ticket.replies.length - 1] : null
  const preview = latest ? truncatePreview(latest.content || ticket.content) : truncatePreview(ticket.subject || ticket.content)
  const createdIso = ticket.updated_at || ticket.created_at || new Date().toISOString()
  const createdAt = createdIso ? new Date(createdIso).getTime() : Date.now()

  return {
    id: `ticket-${ticket.id}`,
    type: 'ticket',
    ticketId: ticket.id,
    merchantName: `客服工单 #${ticket.ticket_number || ticket.id}`,
    avatar: 'https://picsum.photos/seed/support/120/120',
    lastMessagePreview: preview || ticket.subject || '工单',
    lastTimestamp: formatTimestamp(createdIso),
    unreadCount: 0,
    createdAt,
    raw: ticket
  }
}

function shouldDisplayToUser(broadcast) {
  const target = parseTarget(broadcast.content)
  if (!target) return true

  switch (target.audience) {
    case 'all':
      return true
    case 'followers':
    case 'vip':
      return true
    case 'custom':
      if (!currentUser) return false
      const identifiers = [
        currentUser?.phone,
        currentUser?.username,
        currentUser?.id ? String(currentUser.id) : null
      ].filter(Boolean)
      return identifiers.some((value) => target.customId?.includes(value))
    default:
      return true
  }
}

function shouldDisplayDishNotification(notification) {
  if (!notification || notification.is_active === false) {
    return false
  }
  if (notification.broadcast) {
    return shouldDisplayToUser(notification.broadcast)
  }
  return true
}

function shouldDisplayCouponNotification(notification) {
  if (!notification || notification.is_active === false) {
    return false
  }
  if (notification.broadcast) {
    return shouldDisplayToUser(notification.broadcast)
  }
  return true
}

function mapDishNotificationToConversation(item) {
  const relatedBroadcast = item.broadcast || null
  const createdIso = item.created_at || relatedBroadcast?.created_at || new Date().toISOString()
  const createdAt = createdIso ? new Date(createdIso).getTime() : Date.now()
  const preview = truncatePreview(item.message || extractMessage(relatedBroadcast?.content))
  const merchantName = item.restaurant_name || relatedBroadcast?.restaurant_name || '上新通知'

  return {
    id: `dish-launch-${item.id}`,
    type: 'dish_launch',
    notificationId: item.id,
    merchantName,
    avatar: buildAvatar({ merchant_id: item.restaurant_id, id: relatedBroadcast?.id ?? item.id }),
    lastMessagePreview: preview || merchantName,
    lastTimestamp: formatTimestamp(createdIso),
    unreadCount: 0,
    createdAt,
    raw: item
  }
}
    function mapPickupNotificationToConversation(item) {
      if (!item) return null
      const createdIso = item.created_at || new Date().toISOString()
      const createdAt = createdIso ? new Date(createdIso).getTime() : Date.now()
      const merchantName = item.restaurant_name || '取餐提醒'
      const preview = truncatePreview(item.text || `${merchantName}提醒您前往取餐`, 20)

      return {
        id: `order-pickup-${item.id}`,
        type: 'order_pickup',
        notificationId: item.id,
        merchantName,
        avatar: `https://picsum.photos/seed/order-pickup-${item.order_id || item.id}/120/120`,
        lastMessagePreview: preview,
        lastTimestamp: formatTimestamp(createdIso),
        unreadCount: 1,
        createdAt,
        raw: item
      }
  }
function parseTarget(content) {
  if (!content) return null
  const match = content.match(/^【发送对象：([^】]+)】/)
  if (!match) return null

  const raw = match[1]
  if (raw.startsWith('所有用户')) {
    return { audience: 'all' }
  }
  if (raw.startsWith('关注店铺的用户')) {
    return { audience: 'followers' }
  }
  if (raw.startsWith('VIP 用户')) {
    return { audience: 'vip' }
  }
  if (raw.startsWith('指定用户')) {
    const idMatch = raw.match(/（(.+)）/)
    return { audience: 'custom', customId: idMatch ? idMatch[1] : '' }
  }
  return { audience: 'all' }
}

function mapBroadcastToConversation(item) {
  const message = truncatePreview(extractMessage(item.content))
  const createdAt = item.created_at ? new Date(item.created_at).getTime() : Date.now()
  return {
    id: `broadcast-${item.id}`,
    type: 'broadcast',
    broadcastId: item.id,
    merchantName: item.merchant_name || '商家广播',
    avatar: buildAvatar(item),
    lastMessagePreview: message || truncatePreview(item.title),
    lastTimestamp: formatTimestamp(item.created_at),
    unreadCount: 0,
    createdAt,
    raw: item
  }
}

function extractMessage(content) {
  if (!content) return ''
  const parts = content.split('\n')
  if (parts.length <= 1) return parts[0]
  return parts.slice(1).join('\n').trim()
}

function truncatePreview(text, limit = 10) {
  if (!text) return ''
  const normalized = String(text).trim()
  if (normalized.length <= limit) {
    return normalized
  }
  return `${normalized.slice(0, limit)}…`
}

function buildAvatar(item) {
  const seed = item?.merchant_id || item?.id || Math.random()
  return `https://picsum.photos/seed/broadcast-${seed}/120/120`
}

function formatTimestamp(isoString) {
  if (!isoString) return ''
  const date = new Date(isoString)
  if (Number.isNaN(date.getTime())) return ''

  const now = Date.now()
  const diff = now - date.getTime()
  const oneDay = 24 * 60 * 60 * 1000
  if (diff < oneDay) {
    return date.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
  }
  if (diff < oneDay * 2) {
    return '昨天'
  }
  return date.toLocaleDateString()
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

function mapApplicationToConversation(item) {
  const createdAt = item.created_at ? new Date(item.created_at).getTime() : Date.now()
  const statusText = getApplicationStatusText(item.status)
  const reviewStatusText = getApplicationReviewStatusText(item.review_status)

  let messagePreview
  if (item.review_status && item.review_status !== 'pending') {
    messagePreview = reviewStatusText
  } else {
    messagePreview = `您已提交了店铺"${item.shop_name}"的申请`
  }

  return {
    id: `application-${item.id}`,
    type: 'application',
    applicationId: item.id,
    merchantName: '商户申请中心',
    avatar: 'https://picsum.photos/seed/application/120/120',
    lastMessagePreview: truncatePreview(messagePreview),
    lastTimestamp: formatTimestamp(item.created_at),
    unreadCount: 0,
    createdAt,
    raw: item
  }
}

function mapCouponNotificationToConversation(item) {
  const relatedBroadcast = item.broadcast || null
  const createdIso = item.created_at || relatedBroadcast?.created_at || new Date().toISOString()
  const createdAt = createdIso ? new Date(createdIso).getTime() : Date.now()
  const preview = truncatePreview(buildCouponPreview(item))
  const merchantName = item.restaurant_name || relatedBroadcast?.restaurant_name || '优惠券通知'

  return {
    id: `coupon-${item.id}`,
    type: 'coupon',
    couponId: item.id,
    merchantName,
    avatar: buildAvatar({ merchant_id: item.restaurant_id, id: relatedBroadcast?.id ?? item.id }),
    lastMessagePreview: preview || truncatePreview(item.title),
    lastTimestamp: formatTimestamp(createdIso),
    unreadCount: 0,
    createdAt,
    raw: item,
    isActive: item.is_active !== false
  }

function mapPickupNotificationToConversation(item) {
  if (!item) return null
  const createdIso = item.created_at || new Date().toISOString()
  const createdAt = createdIso ? new Date(createdIso).getTime() : Date.now()
  const merchantName = item.restaurant_name || '取餐提醒'
  const preview = truncatePreview(item.text || `${merchantName}提醒您前往取餐`, 20)

  return {
    id: `order-pickup-${item.id}`,
    type: 'order_pickup',
    notificationId: item.id,
    merchantName,
    avatar: `https://picsum.photos/seed/order-pickup-${item.order_id || item.id}/120/120`,
    lastMessagePreview: preview,
    lastTimestamp: formatTimestamp(createdIso),
    unreadCount: 1,
    createdAt,
    raw: item
  }
}
}

function getApplicationStatusText(status) {
  switch (status) {
    case 'draft':
      return '草稿状态'
    case 'submitted':
      return '已提交申请'
    default:
      return status
  }
}

function getApplicationReviewStatusText(reviewStatus) {
  switch (reviewStatus) {
    case 'pending':
      return '等待审核'
    case 'approved':
      return '申请已通过'
    case 'rejected':
      return '申请被拒绝'
    default:
      return reviewStatus
  }
}

function mapSystemNotificationToConversation(notification) {
  const { admin_id, target_audience, messages } = notification
  const latestMessage = messages && messages.length > 0 ? messages[messages.length - 1] : null
  const createdIso = latestMessage?.timestamp || new Date().toISOString()
  const createdAt = createdIso ? new Date(createdIso).getTime() : Date.now()
  const preview = latestMessage ? truncatePreview(latestMessage.content) : '系统公告'

  const audienceLabel = {
    all: '所有用户',
    merchants: '商户',
    users: '用户'
  }[target_audience] || target_audience

  return {
    id: `system_${admin_id}_${target_audience}`,
    type: 'system_notification',
    merchantName: `系统公告（发送给${audienceLabel}）`,
    avatar: '🔔',
    lastMessagePreview: preview,
    lastTimestamp: formatTimestamp(createdIso),
    unreadCount: 0,
    createdAt,
    raw: notification,
    messages: messages || [],
    target_audience: target_audience,
    admin_id: admin_id
  }
}

function mapSystemRecommendedCouponToConversation(item) {
  const coupon = item.coupon
  const recommendationScore = item.recommendation_score || 0
  const confidenceLevel = item.confidence_level || '试试看'

  const createdIso = coupon?.created_at || new Date().toISOString()
  const createdAt = createdIso ? new Date(createdIso).getTime() : Date.now()

  // 构建包含推荐理由的预览信息
  let preview = buildCouponPreview(coupon)
  if (item.recommendation_reasons && item.recommendation_reasons.length > 0) {
    preview = `${confidenceLevel}｜${preview}`
  }

  return {
    id: `system-recommend-${coupon?.id || Date.now()}`,
    type: 'system_recommend_coupon',
    couponId: coupon?.id,
    recommendationData: item, // 保存完整的推荐数据
    merchantName: coupon?.restaurant_name || '系统推荐',
    avatar: 'https://picsum.photos/seed/system-recommend/120/120',
    lastMessagePreview: preview || '系统为您推荐优惠券',
    lastTimestamp: formatTimestamp(createdIso),
    unreadCount: 1, // 系统推荐默认显示未读标记
    createdAt,
    raw: coupon,
    isActive: true,
    isSystemRecommended: true
  }
}

function buildCouponPreview(item) {
  if (!item) return ''
  const parts = []
  const type = (item.discount_type || '').toLowerCase()
  const amountNumber = Number(item.amount)
  const minSpendNumber = Number(item.min_spend)

  if (type === 'amount' && Number.isFinite(amountNumber)) {
    parts.push(`立减 ¥${amountNumber.toFixed(2)}`)
  } else if (type === 'percentage' && Number.isFinite(amountNumber)) {
    parts.push(`折扣 ${amountNumber.toFixed(0)}%`)
  } else if (type === 'gift') {
    const giftText = item.extra_data?.gift_value || item.amount || '赠品优惠'
    parts.push(String(giftText))
  }

  if (Number.isFinite(minSpendNumber) && minSpendNumber > 0) {
    parts.push(`满 ¥${minSpendNumber.toFixed(2)} 可用`)
  }

  if (item.valid_to) {
    parts.push(`截至 ${formatSimpleDate(item.valid_to)}`)
  }

  if (item.description) {
    parts.push(item.description)
  }

  return parts.filter(Boolean).join('；') || item.title || '优惠券通知'
}

function openConversation(conversation) {
  const state = {}
  if (conversation.type === 'broadcast') {
    state.broadcast = conversation.raw
    router.push({
      name: 'MessageDetail',
      params: { id: conversation.id },
      query: { type: conversation.type },
      state
    })
  } else if (conversation.type === 'dish_launch') {
    state.dishNotification = conversation.raw
    router.push({
      name: 'MessageDetail',
      params: { id: conversation.id },
      query: { type: conversation.type },
      state
    })
  } else if (conversation.type === 'coupon') {
    state.couponNotification = conversation.raw
    router.push({
      name: 'MessageDetail',
      params: { id: conversation.id },
      query: { type: conversation.type },
      state
    })
  } else if (conversation.type === 'system_recommend_coupon') {
    state.couponNotification = conversation.raw
    state.recommendationData = conversation.recommendationData
    router.push({
      name: 'MessageDetail',
      params: { id: conversation.id },
      query: { type: 'system_recommend_coupon' },
      state
    })
  } else if (conversation.type === 'order_pickup') {
    state.pickupNotification = conversation.raw
    router.push({
      name: 'MessageDetail',
      params: { id: conversation.id },
      query: { type: conversation.type },
      state
    })
  } else if (conversation.type === 'ticket') {
    state.ticket = conversation.raw
    router.push({
      name: 'MessageDetail',
      params: { id: conversation.id },
      query: { type: conversation.type },
      state
    })
  } else if (conversation.type === 'system_notification') {
    state.systemNotification = conversation.raw
    router.push({
      name: 'MessageDetail',
      params: { id: conversation.id },
      query: { type: conversation.type },
      state
    })
  } else if (conversation.type === 'application') {
    // 跳转到商户申请详情页面
    router.push({
      name: 'MerchantApplicationDetail',
      params: { id: conversation.id },
      query: { type: conversation.type },
      state: { application: conversation.raw }
    })
  }
}
</script>

<style scoped>
.messages-page {
  min-height: 100vh;
  padding-bottom: 72px;
  background: #f7f8fb;
  display: flex;
  flex-direction: column;
}

.page-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px 12px;
  background: #ffffff;
  border-bottom: 1px solid #eef0f4;
}

.title {
  font-size: 20px;
  font-weight: 700;
  color: #1c1f27;
}

.header-action {
  width: 32px;
  height: 32px;
  border-radius: 16px;
  border: none;
  background: #f0f3f8;
  color: #5d6470;
  font-size: 18px;
  line-height: 1;
}

.conversation-list {
  flex: 1;
  overflow-y: auto;
  padding: 12px 16px;
}

.hint {
  padding: 32px 12px;
  text-align: center;
  color: #6b7280;
  font-size: 14px;
}

.hint.error {
  color: #dc2626;
}

.conversation-card {
  display: flex;
  gap: 12px;
  padding: 14px 16px;
  background: #ffffff;
  border-radius: 16px;
  box-shadow: 0 8px 20px rgba(28, 31, 39, 0.04);
  margin-bottom: 12px;
  cursor: pointer;
  transition: transform 0.15s ease, box-shadow 0.15s ease;
}

.conversation-card:active {
  transform: scale(0.98);
  box-shadow: 0 4px 12px rgba(28, 31, 39, 0.08);
}

.avatar {
  width: 52px;
  height: 52px;
  border-radius: 26px;
  object-fit: cover;
}

.conversation-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  min-width: 0;
}

.conversation-top {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  margin-bottom: 6px;
  gap: 10px;
}

.merchant-name {
  flex: 1;
  min-width: 0;
  font-size: 16px;
  font-weight: 600;
  color: #171a22;
  margin: 0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.timestamp {
  flex-shrink: 0;
  font-size: 12px;
  color: #9499a5;
}

.conversation-bottom {
  display: flex;
  align-items: center;
  gap: 8px;
}

.preview {
  flex: 1;
  min-width: 0;
  font-size: 14px;
  color: #5b606b;
  margin: 0;
  overflow: hidden;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  line-clamp: 2;
}

.unread-badge {
  min-width: 20px;
  padding: 0 6px;
  height: 20px;
  border-radius: 10px;
  background: #ff4d4f;
  color: #ffffff;
  font-size: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.unread-dot {
  width: 10px;
  height: 10px;
  border-radius: 5px;
  background: #ff4d4f;
  display: inline-block;
}

.empty-state {
  padding: 48px 12px;
  text-align: center;
  color: #a0a6b3;
}
</style>
