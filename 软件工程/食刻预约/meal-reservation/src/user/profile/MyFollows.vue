<template>
  <div class="follows-page">
    <header class="page-header">
      <button class="back-btn" type="button" @click="goBack" aria-label="返回">
        <span>←</span>
      </button>
      <h1 class="page-title">我的关注</h1>
      <button class="refresh-btn" type="button" @click="loadFollows" :disabled="loading">
        {{ loading ? '刷新中…' : '刷新' }}
      </button>
    </header>

    <main class="content">
      <div v-if="loading" class="hint">正在加载关注的商铺…</div>
      <div v-else-if="error" class="hint error">{{ error }}</div>
      <div v-else-if="!follows.length" class="empty">暂时还没有关注任何商铺，去逛逛吧！</div>

      <ul v-else class="follow-list">
        <li v-for="item in follows" :key="item.id" class="follow-card">
          <img
            class="restaurant-avatar"
            :src="resolveAvatar(item.restaurant?.avatar_url, item.restaurant_id)"
            :alt="`${item.restaurant?.name || '商铺'} 头像`"
          />
          <div class="follow-main">
            <div class="title-row">
              <h2 class="restaurant-name">{{ item.restaurant?.name || '商铺' }}</h2>
              <span class="follow-time">{{ formatTime(item.created_at) }}</span>
            </div>
            <p v-if="item.restaurant?.notice" class="restaurant-notice" :title="item.restaurant.notice">
              {{ item.restaurant.notice }}
            </p>
            <p class="restaurant-meta">
              <span>{{ item.restaurant?.address || '地址待完善' }}</span>
            </p>
            <div class="actions">
              <button class="open-btn" type="button" @click="openRestaurant(item.restaurant_id)">
                进入店铺
              </button>
              <button
                class="unfollow-btn"
                type="button"
                @click="unfollow(item.restaurant_id)"
                :disabled="removingId === item.restaurant_id"
              >
                {{ removingId === item.restaurant_id ? '取消中…' : '取消关注' }}
              </button>
            </div>
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
const follows = ref([])
const removingId = ref(null)

const resolveAvatar = (url, restaurantId) => {
  if (url && url.startsWith('http')) {
    return url
  }
  if (url) {
    return `${API_url}${url}`
  }
  return `https://picsum.photos/seed/restaurant-${restaurantId || Math.random()}/120/120`
}

const formatTime = (isoString) => {
  if (!isoString) return ''
  const date = new Date(isoString)
  if (Number.isNaN(date.getTime())) return ''
  return date.toLocaleDateString('zh-CN', {
    month: 'short',
    day: 'numeric'
  })
}

const ensureAuthToken = () => {
  const token = localStorage.getItem('token')
  if (!token) {
    router.push('/login')
    throw new Error('未登录')
  }
  return token
}

const loadFollows = async () => {
  loading.value = true
  error.value = ''
  try {
    const token = ensureAuthToken()
    const res = await fetch('/api/users/followed-restaurants', {
      headers: {
        Authorization: `Bearer ${token}`
      }
    })
    const body = await res.json().catch(() => ({}))
    if (!res.ok || body?.success === false) {
      throw new Error(body?.message || '加载关注列表失败')
    }
    follows.value = body?.data?.records || []
  } catch (err) {
    if (err.message === '未登录') return
    console.error('加载关注列表失败:', err)
    error.value = err?.message || '加载关注列表失败'
  } finally {
    loading.value = false
  }
}

const unfollow = async (restaurantId) => {
  if (!restaurantId || removingId.value === restaurantId) return
  if (!confirm('确认取消关注该商铺吗？')) return

  try {
    const token = ensureAuthToken()
    removingId.value = restaurantId
    const res = await fetch(`/api/restaurants/${restaurantId}/follow`, {
      method: 'DELETE',
      headers: {
        Authorization: `Bearer ${token}`
      }
    })
    const body = await res.json().catch(() => ({}))
    if (!res.ok || body?.success === false) {
      throw new Error(body?.message || '取消关注失败')
    }
    follows.value = follows.value.filter((item) => item.restaurant_id !== restaurantId)
  } catch (err) {
    if (err.message === '未登录') return
    console.error('取消关注失败:', err)
    alert(err?.message || '取消关注失败，请稍后重试')
  } finally {
    removingId.value = null
  }
}

const openRestaurant = (restaurantId) => {
  if (!restaurantId) return
  router.push({ name: 'Restaurant', query: { id: restaurantId } })
}

const goBack = () => {
  router.back()
}

onMounted(loadFollows)
</script>

<style scoped>
.follows-page {
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
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  color: #1c1f27;
}

.content {
  flex: 1;
  padding: 16px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.hint {
  padding: 40px 12px;
  text-align: center;
  color: #6b7280;
  font-size: 14px;
}

.hint.error {
  color: #dc2626;
}

.empty {
  padding: 40px 12px;
  text-align: center;
  color: #9ca3af;
  font-size: 14px;
}

.follow-list {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.follow-card {
  display: flex;
  gap: 16px;
  padding: 16px;
  background: #ffffff;
  border-radius: 18px;
  box-shadow: 0 10px 24px rgba(28, 31, 39, 0.08);
}

.restaurant-avatar {
  width: 72px;
  height: 72px;
  border-radius: 16px;
  object-fit: cover;
  flex-shrink: 0;
}

.follow-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.title-row {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  gap: 12px;
}

.restaurant-name {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  color: #1c1f27;
}

.follow-time {
  font-size: 12px;
  color: #9ca3af;
}

.restaurant-notice {
  margin: 0;
  color: #4b5563;
  font-size: 13px;
  line-height: 1.4;
  max-height: 3.6em;
  overflow: hidden;
}

.restaurant-meta {
  margin: 0;
  font-size: 12px;
  color: #6b7280;
}

.actions {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
  margin-top: 8px;
}

.open-btn,
.unfollow-btn {
  border: none;
  border-radius: 16px;
  padding: 8px 16px;
  font-size: 14px;
  cursor: pointer;
}

.open-btn {
  background: #2563eb;
  color: #ffffff;
}

.unfollow-btn {
  background: #f3f4f6;
  color: #1f2937;
}

.unfollow-btn:hover:not(:disabled) {
  background: #e5e7eb;
}

.unfollow-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

@media (max-width: 600px) {
  .follow-card {
    flex-direction: column;
    align-items: center;
    text-align: center;
  }

  .follow-main {
    align-items: center;
  }

  .title-row {
    flex-direction: column;
    align-items: center;
  }

  .actions {
    justify-content: center;
  }
}
</style>
