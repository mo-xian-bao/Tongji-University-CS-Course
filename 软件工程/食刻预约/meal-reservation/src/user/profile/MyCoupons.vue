<template>
  <div class="coupons-page">
    <header class="page-header">
      <button class="back-btn" type="button" @click="goBack" aria-label="返回">
        <span>←</span>
      </button>
      <h1 class="page-title">我的优惠券</h1>
      <button class="refresh-btn" type="button" @click="loadCoupons" :disabled="loading">
        {{ loading ? '刷新中…' : '刷新' }}
      </button>
    </header>

    <main class="content">
      <div v-if="loading" class="hint">正在加载我的优惠券…</div>
      <div v-else-if="error" class="hint error">{{ error }}</div>
      <div v-else-if="!coupons.length" class="empty">暂无可用优惠券，去逛逛喜欢的店铺吧。</div>

      <ul v-else class="coupon-list">
        <li v-for="coupon in coupons" :key="coupon.id" class="coupon-card">
          <div class="coupon-main">
            <div class="title-row">
              <h2 class="coupon-title">{{ coupon.title || '优惠券' }}</h2>
              <span class="status-chip" :class="coupon.is_active ? 'active' : 'inactive'">
                {{ coupon.is_active ? '生效中' : '已停用' }}
              </span>
            </div>
            <p class="coupon-merchant">{{ coupon.restaurant_name || '关注的商铺' }}</p>
            <p class="coupon-benefit">{{ describeCoupon(coupon) }}</p>
            <p v-if="coupon.description" class="coupon-desc" :title="coupon.description">{{ coupon.description }}</p>
            <p class="coupon-meta">
              <span>有效期：{{ formatValidity(coupon) }}</span>
              <span v-if="coupon.total_quantity">数量：{{ coupon.total_quantity }}</span>
            </p>
          </div>
          <div class="coupon-actions">
            <button class="open-btn" type="button" @click="openDetail(coupon)">
              查看详情
            </button>
          </div>
        </li>
      </ul>
    </main>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const loading = ref(false)
const error = ref('')
const coupons = ref([])

const ensureAuthToken = () => {
  const token = localStorage.getItem('token')
  if (!token) {
    router.push('/login')
    throw new Error('未登录')
  }
  return token
}

const describeCoupon = (coupon) => {
  if (!coupon) return ''
  const parts = []
  const type = (coupon.discount_type || '').toLowerCase()
  const amountNumber = Number(coupon.amount)
  const minSpendNumber = Number(coupon.min_spend)

  if (type === 'amount' && Number.isFinite(amountNumber)) {
    parts.push(`立减 ¥${amountNumber.toFixed(2)}`)
  } else if (type === 'percentage' && Number.isFinite(amountNumber)) {
    parts.push(`折扣 ${amountNumber.toFixed(0)}%`)
  } else if (type === 'gift') {
    const gift = coupon.extra_data?.gift_value || coupon.amount || '赠品优惠'
    parts.push(String(gift))
  }

  if (Number.isFinite(minSpendNumber) && minSpendNumber > 0) {
    parts.push(`满 ¥${minSpendNumber.toFixed(2)} 可用`)
  }

  return parts.join('｜') || '关注店铺专属福利'
}

const formatValidity = (coupon) => {
  if (coupon.valid_from && coupon.valid_to) {
    return `${formatDate(coupon.valid_from)} - ${formatDate(coupon.valid_to)}`
  }
  if (coupon.valid_to) {
    return `${formatDate(coupon.valid_to)} 截止`
  }
  return '长期有效'
}

const formatDate = (iso) => {
  if (!iso) return ''
  const date = new Date(iso)
  if (Number.isNaN(date.getTime())) return ''
  return date.toLocaleDateString('zh-CN', {
    month: 'short',
    day: 'numeric'
  })
}

const loadCoupons = async () => {
  loading.value = true
  error.value = ''
  try {
    const token = ensureAuthToken()
    const params = new URLSearchParams({
      include_inactive: 'true',
      per_page: '100'
    })
    const res = await fetch(`/api/coupon-notifications?${params.toString()}`, {
      headers: {
        Authorization: `Bearer ${token}`
      }
    })
    const body = await res.json().catch(() => ({}))
    if (!res.ok || body?.success === false) {
      throw new Error(body?.message || '加载优惠券失败')
    }
    coupons.value = body?.data?.records || []
  } catch (err) {
    if (err.message === '未登录') return
    console.error('加载优惠券失败:', err)
    error.value = err?.message || '加载优惠券失败'
  } finally {
    loading.value = false
  }
}

const openDetail = (coupon) => {
  if (!coupon?.id) return
  router.push({
    name: 'MessageDetail',
    params: { id: `coupon-${coupon.id}` },
    query: { type: 'coupon' },
    state: { couponNotification: coupon }
  })
}

const goBack = () => {
  router.back()
}

onMounted(loadCoupons)
</script>

<style scoped>
.coupons-page {
  min-height: 100vh;
  background: #f7f8fb;
  display: flex;
  flex-direction: column;
}

.page-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 16px;
  background: #ffffff;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.back-btn,
.refresh-btn {
  border: none;
  background: #edf1ff;
  color: #3a3f5c;
  border-radius: 16px;
  padding: 6px 12px;
  font-size: 14px;
  cursor: pointer;
  transition: background 0.2s ease;
}

.back-btn:hover,
.refresh-btn:hover:enabled {
  background: #d8e0ff;
}

.refresh-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.page-title {
  flex: 1;
  text-align: center;
  font-size: 18px;
  font-weight: 600;
  margin: 0;
}

.content {
  flex: 1;
  padding: 16px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.hint {
  padding: 24px 0;
  text-align: center;
  color: #6b7280;
}

.hint.error {
  color: #dc2626;
}

.empty {
  padding: 24px 0;
  text-align: center;
  color: #9ca3af;
}

.coupon-list {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  gap: 16px;
}

.coupon-card {
  display: flex;
  justify-content: space-between;
  gap: 16px;
  background: #ffffff;
  border-radius: 16px;
  padding: 18px;
  box-shadow: 0 10px 20px rgba(18, 37, 63, 0.06);
}

.coupon-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.title-row {
  display: flex;
  align-items: center;
  gap: 12px;
}

.coupon-title {
  margin: 0;
  font-size: 18px;
  font-weight: 700;
  color: #1f2532;
}

.status-chip {
  padding: 2px 10px;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 600;
}

.status-chip.active {
  background: #dcfce7;
  color: #15803d;
}

.status-chip.inactive {
  background: #f3f4f6;
  color: #6b7280;
}

.coupon-merchant {
  margin: 0;
  color: #4b5563;
  font-size: 14px;
}

.coupon-benefit {
  margin: 0;
  color: #2563eb;
  font-weight: 600;
}

.coupon-desc {
  margin: 0;
  color: #6b7280;
  font-size: 13px;
}

.coupon-meta {
  margin: 0;
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  color: #6b7280;
  font-size: 12px;
}

.coupon-actions {
  display: flex;
  align-items: center;
}

.open-btn {
  border: none;
  background: #eef2ff;
  color: #3b49df;
  border-radius: 12px;
  padding: 8px 16px;
  cursor: pointer;
  font-size: 14px;
  transition: background 0.2s ease;
}

.open-btn:hover {
  background: #d8e0ff;
}
</style>
