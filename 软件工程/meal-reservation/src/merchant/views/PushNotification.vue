<template>
  <div class="push-page">
    <header class="page-header">
      <h2>商家广播中心</h2>
      <p class="page-desc">在这里创建店铺广播或推送优惠券，及时触达关注者与潜在顾客。</p>
    </header>

    <section class="composer card">
      <div class="section-header">
        <h3>{{ isEditing ? '编辑广播' : '新建广播' }}</h3>
        <span v-if="isEditing" class="editing-hint">正在修改 #{{ form.broadcastId }}，保存后生效</span>
      </div>

      <div class="form-grid">
        <label class="form-block">
          <span class="form-label">广播标题</span>
          <input
            v-model.trim="form.title"
            type="text"
            maxlength="100"
            placeholder="例如：周末卡路里轻食套餐 8 折开抢"
          />
        </label>

        <label class="form-block">
          <span class="form-label">发送对象</span>
          <select v-model="form.target" class="form-select">
            <option value="all">所有用户</option>
            <option value="followers">关注店铺的用户</option>
            <option value="vip">VIP 用户</option>
            <option value="custom">指定用户</option>
          </select>
        </label>

        <label v-if="form.target === 'custom'" class="form-block">
          <span class="form-label">指定用户 ID</span>
          <input
            v-model.trim="form.customUserId"
            type="text"
            placeholder="请输入手机号、学号等唯一标识"
          />
        </label>
      </div>

      <label class="form-block">
        <span class="form-label">广播正文</span>
        <textarea
          v-model.trim="form.message"
          rows="5"
          placeholder="输入要通知的内容，例如优惠信息、营业时间调整、活动公告等"
        ></textarea>
      </label>

      <div class="time-row">
        <label class="form-block">
          <span class="form-label">开始时间</span>
          <input v-model="form.startTime" type="datetime-local" />
        </label>
        <label class="form-block">
          <span class="form-label">结束时间</span>
          <input v-model="form.endTime" type="datetime-local" />
        </label>
        <label class="form-switch">
          <input type="checkbox" v-model="form.isActive" />
          <span>广播生效中</span>
        </label>
      </div>

      <div class="action-row">
        <button class="btn primary" :disabled="saving" @click="submitBroadcast">
          {{ saving ? '提交中…' : isEditing ? '保存修改' : '立即广播' }}
        </button>
        <button v-if="isEditing" class="btn ghost" :disabled="saving" @click="resetForm">
          取消编辑
        </button>
      </div>

      <p v-if="feedback.message" :class="['feedback', feedback.type]">{{ feedback.message }}</p>
    </section>

    <section class="coupon card">
      <div class="section-header">
        <h3>推送优惠券</h3>
      </div>
      <p class="section-sub">优惠券将发送给所有关注店铺的用户，并同步生成消息提醒。</p>

      <div class="form-grid coupon-grid">
        <label class="form-block">
          <span class="form-label">优惠券标题</span>
          <input
            v-model.trim="couponForm.title"
            type="text"
            maxlength="100"
            placeholder="例如：关注粉丝专享满减券"
          />
        </label>

        <label class="form-block">
          <span class="form-label">优惠类型</span>
          <select v-model="couponForm.discountType" class="form-select">
            <option value="amount">满减优惠</option>
            <option value="percentage">折扣优惠</option>
            <option value="gift">赠品/其他</option>
          </select>
        </label>

        <label v-if="couponForm.discountType !== 'gift'" class="form-block">
          <span class="form-label">{{ couponAmountLabel }}</span>
          <input
            v-model.trim="couponForm.amount"
            type="number"
            :min="couponForm.discountType === 'percentage' ? 1 : 0"
            :step="couponForm.discountType === 'percentage' ? 1 : 0.01"
            :placeholder="couponAmountPlaceholder"
          />
        </label>
        <label v-else class="form-block">
          <span class="form-label">{{ couponAmountLabel }}</span>
          <input
            v-model.trim="couponForm.amount"
            type="text"
            :placeholder="couponAmountPlaceholder"
          />
        </label>

        <label class="form-block">
          <span class="form-label">最低消费（选填）</span>
          <input
            v-model.trim="couponForm.minSpend"
            type="number"
            min="0"
            step="0.01"
            placeholder="无门槛可留空"
          />
        </label>
      </div>

      <div class="time-row coupon-time-row">
        <label class="form-block">
          <span class="form-label">开始时间（选填）</span>
          <input v-model="couponForm.validFrom" type="datetime-local" />
        </label>
        <label class="form-block">
          <span class="form-label">结束时间（选填）</span>
          <input v-model="couponForm.validTo" type="datetime-local" />
        </label>
        <label class="form-block">
          <span class="form-label">发放数量（选填）</span>
          <input
            v-model.trim="couponForm.totalQuantity"
            type="number"
            min="0"
            step="1"
            placeholder="默认不限量"
          />
        </label>
      </div>

      <label class="form-block">
        <span class="form-label">优惠券描述（选填）</span>
        <textarea
          v-model.trim="couponForm.description"
          rows="4"
          placeholder="补充使用规则、适用菜品或核销说明"
        ></textarea>
        <span class="form-hint">描述将显示在用户优惠券详情中，便于快速了解活动规则。</span>
      </label>

      <div class="action-row">
        <button class="btn primary" :disabled="couponSaving || !restaurantId || !token" @click="submitCoupon">
          {{ couponSaving ? '推送中…' : '推送优惠券' }}
        </button>
        <button class="btn ghost" :disabled="couponSaving" @click="resetCouponForm">重置表单</button>
      </div>

      <p v-if="couponFeedback.message" :class="['feedback', couponFeedback.type]">{{ couponFeedback.message }}</p>
    </section>

    <section class="card list-card">
      <div class="list-header">
        <h3>历史广播</h3>
        <button class="btn ghost" :disabled="loading" @click="loadBroadcasts">{{ loading ? '刷新中…' : '刷新' }}</button>
      </div>

      <div v-if="loading" class="loading">正在加载广播记录…</div>
      <div v-else-if="!broadcasts.length" class="empty">暂无广播记录，快去创建一条吧。</div>
      <div v-else class="broadcast-list">
        <article v-for="item in broadcasts" :key="item.id" class="broadcast-card">
          <header class="broadcast-head">
            <div>
              <h4 class="broadcast-title">{{ item.title }}</h4>
              <span class="status-chip" :class="item.is_active ? 'active' : 'inactive'">
                {{ item.is_active ? '进行中' : '已停用' }}
              </span>
            </div>
            <span class="broadcast-time">发布于 {{ formatDate(item.created_at) }}</span>
          </header>

          <p class="broadcast-target">发送对象：{{ describeTarget(item) }}</p>
          <p class="broadcast-content">{{ extractMessage(item.content) }}</p>

          <footer class="broadcast-meta">
            <div class="time-window" v-if="item.start_time || item.end_time">
              <span v-if="item.start_time">开始：{{ formatDate(item.start_time) }}</span>
              <span v-if="item.end_time">结束：{{ formatDate(item.end_time) }}</span>
            </div>

            <div class="card-actions">
              <button class="btn ghost" @click="editBroadcast(item)">编辑</button>
              <button class="btn ghost" @click="toggleStatus(item)">
                {{ item.is_active ? '暂停' : '恢复' }}
              </button>
              <button class="btn danger" @click="removeBroadcast(item)">删除</button>
            </div>
          </footer>
        </article>
      </div>
    </section>

    <section class="card list-card">
      <div class="list-header">
        <h3>优惠券推送记录</h3>
        <button class="btn ghost" :disabled="couponLoading" @click="loadCouponNotifications">
          {{ couponLoading ? '刷新中…' : '刷新' }}
        </button>
      </div>

      <div v-if="couponLoading" class="loading">正在加载优惠券推送记录…</div>
      <div v-else-if="!couponNotifications.length" class="empty">还没有推送过优惠券。</div>
      <div v-else class="broadcast-list coupon-list">
        <article v-for="coupon in couponNotifications" :key="coupon.id" class="broadcast-card coupon-card">
          <header class="broadcast-head">
            <div>
              <h4 class="broadcast-title">{{ coupon.title }}</h4>
              <span class="status-chip" :class="coupon.is_active ? 'active' : 'inactive'">
                {{ coupon.is_active ? '进行中' : '已停用' }}
              </span>
            </div>
            <span class="broadcast-time">创建于 {{ formatDate(coupon.created_at) }}</span>
          </header>

          <div class="coupon-meta">
            <div class="coupon-meta-item">
              <span class="meta-label">优惠内容</span>
              <span class="meta-value">{{ describeDiscount(coupon) }}</span>
            </div>
            <div class="coupon-meta-item">
              <span class="meta-label">使用门槛</span>
              <span class="meta-value">{{ describeThreshold(coupon) }}</span>
            </div>
            <div class="coupon-meta-item">
              <span class="meta-label">有效期</span>
              <span class="meta-value">{{ formatCouponRange(coupon) }}</span>
            </div>
            <div class="coupon-meta-item" v-if="coupon.total_quantity !== null && coupon.total_quantity !== undefined">
              <span class="meta-label">发放数量</span>
              <span class="meta-value">{{ coupon.total_quantity }}</span>
            </div>
          </div>

          <p v-if="coupon.description" class="broadcast-content">{{ coupon.description }}</p>

          <footer class="broadcast-meta">
            <div class="time-window">
              <span>通知对象：关注店铺的用户</span>
              <span v-if="coupon.broadcast_id">关联广播 ID：{{ coupon.broadcast_id }}</span>
            </div>
          </footer>
        </article>
      </div>
    </section>
  </div>
</template>

<script>
import { getRestaurantByUser } from '@/api/shops'
import { createBroadcast, updateBroadcast, deleteBroadcast, createCoupon } from '@/api/merchant'
import { getBroadcasts, getCouponNotifications } from '@/api/shops'

const TARGET_LABELS = {
  all: '所有用户',
  followers: '关注店铺的用户',
  vip: 'VIP 用户',
  custom: '指定用户'
}

export default {
  name: 'PushNotification',
  data() {
    return {
      restaurantId: null,
      token: '',
      userId: null,
      broadcasts: [],
      loading: false,
      saving: false,
      feedback: {
        type: '',
        message: ''
      },
      form: {
        broadcastId: null,
        title: '',
        target: 'all',
        customUserId: '',
        message: '',
        startTime: '',
        endTime: '',
        isActive: true
      },
      couponNotifications: [],
      couponLoading: false,
      couponSaving: false,
      couponFeedback: {
        type: '',
        message: ''
      },
      couponForm: {
        title: '',
        discountType: 'amount',
        amount: '',
        minSpend: '',
        validFrom: '',
        validTo: '',
        totalQuantity: '',
        description: ''
      }
    }
  },
  computed: {
    isEditing() {
      return Boolean(this.form.broadcastId)
    },
    couponAmountLabel() {
      const type = this.couponForm.discountType
      if (type === 'percentage') return '折扣百分比'
      if (type === 'gift') return '优惠内容'
      return '优惠金额'
    },
    couponAmountPlaceholder() {
      const type = this.couponForm.discountType
      if (type === 'percentage') return '例如：80 表示打八折'
      if (type === 'gift') return '例如：赠送饮品或其他福利描述'
      return '例如：50 表示立减 50 元'
    }
  },
  watch: {
    'couponForm.discountType'(next, prev) {
      if (next !== prev) {
        this.couponForm.amount = ''
      }
    }
  },
  mounted() {
    this.bootstrap()
  },
  methods: {
    async bootstrap() {
      this.feedback = { type: '', message: '' }
      this.couponFeedback = { type: '', message: '' }
      this.loadUserContext()
      if (!this.userId) {
        const message = '请先登录商家账号后再使用广播与优惠券功能'
        this.setFeedback('error', message)
        this.setCouponFeedback('error', message)
        return
      }

      const hasRestaurant = await this.fetchRestaurant()
      if (!hasRestaurant) {
        return
      }

      await Promise.all([this.loadBroadcasts(), this.loadCouponNotifications()])
    },
    loadUserContext() {
      const storedUser = localStorage.getItem('user')
      this.token = localStorage.getItem('token') || ''
      if (!storedUser) {
        this.userId = null
        return
      }
      try {
        const parsed = JSON.parse(storedUser)
        this.userId = parsed?.id ?? parsed?.user_id ?? null
      } catch (error) {
        console.error('解析用户信息失败:', error)
        this.userId = null
      }
    },
    async fetchRestaurant() {
      try {
        const res = await getRestaurantByUser(this.userId)
        const body = res.data
        if (body?.data?.restaurant) {
          this.restaurantId = body.data.restaurant.id
          return true
        }
        const message = body?.message || '尚未创建店铺信息，请先完善店铺资料'
        this.restaurantId = null
        this.setFeedback('error', message)
        this.setCouponFeedback('error', message)
        return false
      } catch (error) {
        console.error('获取餐厅信息失败:', error)
        const message = '获取餐厅信息失败，请稍后再试'
        this.setFeedback('error', message)
        this.setCouponFeedback('error', message)
        return false
      }
    },
    buildAuthHeaders(extra = {}) {
      const headers = { ...extra }
      if (this.token) {
        headers.Authorization = `Bearer ${this.token}`
      }
      return headers
    },
    async loadBroadcasts() {
      if (!this.restaurantId) {
        this.broadcasts = []
        return
      }
      this.loading = true
      try {
        const res = await getBroadcasts({
          restaurant_id: this.restaurantId,
          include_inactive: 'true'
        })
        this.broadcasts = res.data?.data?.records ?? []
      } catch (error) {
        console.error(error)
        this.setFeedback('error', error.response?.data?.message || error.message || '广播列表加载失败')
      } finally {
        this.loading = false
      }
    },
    async submitBroadcast() {
      if (!this.restaurantId) {
        this.setFeedback('error', '尚未关联店铺，无法发送广播')
        return
      }
      this.setFeedback('', '')
      if (!this.form.title.trim()) {
        this.setFeedback('error', '请输入广播标题')
        return
      }
      if (!this.form.message.trim()) {
        this.setFeedback('error', '广播正文不能为空')
        return
      }
      if (this.form.target === 'custom' && !this.form.customUserId.trim()) {
        this.setFeedback('error', '请填写指定用户的唯一标识')
        return
      }

      const payload = {
        title: this.form.title.trim(),
        content: this.buildContent(),
        start_time: this.form.startTime ? new Date(this.form.startTime).toISOString() : null,
        end_time: this.form.endTime ? new Date(this.form.endTime).toISOString() : null,
        is_active: this.form.isActive
      }

      const isEdit = this.isEditing

      this.saving = true
      try {
        if (isEdit) {
          await updateBroadcast(this.restaurantId, this.form.broadcastId, payload)
        } else {
          await createBroadcast(this.restaurantId, payload)
        }
        this.setFeedback('success', isEdit ? '广播更新成功' : '广播发送成功')
        this.resetForm()
        await this.loadBroadcasts()
      } catch (error) {
        console.error(error)
        this.setFeedback('error', error.response?.data?.message || error.message || '广播提交失败')
      } finally {
        this.saving = false
      }
    },
    editBroadcast(item) {
      this.form.broadcastId = item.id
      this.form.title = item.title
      this.restoreContent(item.content)
      this.form.startTime = this.toInputValue(item.start_time)
      this.form.endTime = this.toInputValue(item.end_time)
      this.form.isActive = Boolean(item.is_active)
      this.scrollToComposer()
    },
    async toggleStatus(item) {
      if (!this.restaurantId) return
      try {
        await updateBroadcast(this.restaurantId, item.id, { is_active: !item.is_active })
        this.setFeedback('success', `${item.is_active ? '已暂停' : '已恢复'}广播 #${item.id}`)
        await this.loadBroadcasts()
      } catch (error) {
        console.error(error)
        this.setFeedback('error', error.response?.data?.message || error.message || '更新广播状态失败')
      }
    },
    async removeBroadcast(item) {
      if (!this.restaurantId) return
      if (!confirm(`确定删除广播《${item.title}》吗？`)) return
      try {
        await deleteBroadcast(this.restaurantId, item.id)
        this.setFeedback('success', `广播《${item.title}》已删除`)
        await this.loadBroadcasts()
      } catch (error) {
        console.error(error)
        this.setFeedback('error', error.response?.data?.message || error.message || '删除广播失败')
      }
    },
    resetForm() {
      this.form = {
        broadcastId: null,
        title: '',
        target: 'all',
        customUserId: '',
        message: '',
        startTime: '',
        endTime: '',
        isActive: true
      }
      this.feedback = { type: '', message: '' }
    },
    buildContent() {
      const targetLabel = TARGET_LABELS[this.form.target] || '所有用户'
      const targetSuffix = this.form.target === 'custom' && this.form.customUserId
        ? `（${this.form.customUserId}）`
        : ''
      return `【发送对象：${targetLabel}${targetSuffix}】\n${this.form.message}`
    },
    restoreContent(content) {
      if (!content) {
        this.form.target = 'all'
        this.form.customUserId = ''
        this.form.message = ''
        return
      }
      const match = content.match(/^【发送对象：([^】]+)】\s*\n?([\s\S]*)$/)
      if (match) {
        const label = match[1]
        this.form.message = match[2].trim()
        const targetKey = Object.keys(TARGET_LABELS).find((key) => label.startsWith(TARGET_LABELS[key]))
        this.form.target = targetKey || 'all'
        if (this.form.target === 'custom') {
          const idMatch = label.match(/（(.+)）/)
          this.form.customUserId = idMatch ? idMatch[1] : ''
        } else {
          this.form.customUserId = ''
        }
      } else {
        this.form.target = 'all'
        this.form.customUserId = ''
        this.form.message = content
      }
    },
    extractMessage(content) {
      if (!content) return ''
      const parts = content.split('\n')
      return parts.slice(1).join('\n').trim() || parts[0]
    },
    describeTarget(item) {
      if (!item?.content) return '所有用户'
      const match = item.content.match(/^【发送对象：([^】]+)】/)
      return match ? match[1] : '所有用户'
    },
    toInputValue(isoString) {
      if (!isoString) return ''
      const date = new Date(isoString)
      if (Number.isNaN(date.getTime())) return ''
      const iso = date.toISOString()
      return iso.substring(0, 16) // YYYY-MM-DDTHH:mm
    },
    formatDate(isoString) {
      if (!isoString) return '未设置'
      const date = new Date(isoString)
      if (Number.isNaN(date.getTime())) return isoString
      return date.toLocaleString()
    },
    setFeedback(type, message) {
      this.feedback = { type, message }
    },
    async loadCouponNotifications() {
      if (!this.restaurantId || !this.token) {
        this.couponNotifications = []
        return
      }
      this.couponLoading = true
      try {
        const res = await getCouponNotifications({
          restaurant_id: this.restaurantId,
          include_inactive: 'true'
        })
        this.couponNotifications = res.data?.data?.records ?? []
      } catch (error) {
        console.error(error)
        this.setCouponFeedback('error', error.response?.data?.message || error.message || '优惠券记录加载失败')
      } finally {
        this.couponLoading = false
      }
    },
    async submitCoupon() {
      if (!this.restaurantId || !this.token) {
        this.setCouponFeedback('error', '登录过期或未绑定店铺，无法推送优惠券')
        return
      }
      this.setCouponFeedback('', '')
      if (!this.couponForm.title.trim()) {
        this.setCouponFeedback('error', '请输入优惠券标题')
        return
      }

      const type = this.couponForm.discountType
      const amountInput = this.couponForm.amount?.toString().trim()
      if (type !== 'gift' && (!amountInput || Number.isNaN(Number(amountInput)))) {
        this.setCouponFeedback('error', type === 'percentage' ? '请输入有效的折扣百分比' : '请输入有效的优惠金额')
        return
      }

      if (type === 'percentage') {
        const percent = Number(amountInput)
        if (percent <= 0 || percent >= 100) {
          this.setCouponFeedback('error', '折扣百分比需在 1 到 99 之间')
          return
        }
      }

      const payload = {
        title: this.couponForm.title.trim(),
        description: this.couponForm.description.trim() || null,
        discount_type: type,
        amount: type === 'gift' ? this.couponForm.amount?.trim() || null : Number(amountInput),
        min_spend: this.couponForm.minSpend ? Number(this.couponForm.minSpend) : null,
        valid_from: this.couponForm.validFrom ? new Date(this.couponForm.validFrom).toISOString() : null,
        valid_to: this.couponForm.validTo ? new Date(this.couponForm.validTo).toISOString() : null,
        total_quantity: this.couponForm.totalQuantity ? Number(this.couponForm.totalQuantity) : null
      }

      if (payload.valid_from && payload.valid_to && new Date(payload.valid_from) > new Date(payload.valid_to)) {
        this.setCouponFeedback('error', '有效期开始时间不能晚于结束时间')
        return
      }

      this.couponSaving = true
      try {
        await createCoupon(this.restaurantId, payload)
        this.setCouponFeedback('success', '优惠券推送成功，已通知关注用户')
        this.resetCouponForm()
        await Promise.all([this.loadCouponNotifications(), this.loadBroadcasts()])
      } catch (error) {
        console.error(error)
        this.setCouponFeedback('error', error.response?.data?.message || error.message || '推送优惠券失败')
      } finally {
        this.couponSaving = false
      }
    },
    resetCouponForm() {
      this.couponForm = {
        title: '',
        discountType: 'amount',
        amount: '',
        minSpend: '',
        validFrom: '',
        validTo: '',
        totalQuantity: '',
        description: ''
      }
    },
    setCouponFeedback(type, message) {
      this.couponFeedback = { type, message }
    },
    describeDiscount(coupon) {
      if (!coupon) return ''
      const type = coupon.discount_type
      const amount = coupon.amount
      if (type === 'percentage') {
        return amount ? `${Number(amount).toFixed(0)}% 折扣` : '折扣优惠'
      }
      if (type === 'gift') {
        const gift = coupon.extra_data?.gift_value || coupon.description || '赠品/礼遇'
        return `赠送福利：${gift}`
      }
      if (amount != null) {
        return `立减 ${this.formatCurrency(amount)}`
      }
      return '优惠活动'
    },
    formatCurrency(value) {
      const num = Number(value)
      if (Number.isNaN(num)) return value
      return `¥${num.toFixed(2)}`
    },
    describeThreshold(coupon) {
      if (!coupon || coupon.min_spend == null) {
        return '无使用门槛'
      }
      return `满 ${this.formatCurrency(coupon.min_spend)} 可用`
    },
    formatCouponRange(coupon) {
      if (!coupon) return '有效期未设置'
      return this.formatDateRange(coupon.valid_from, coupon.valid_to)
    },
    formatDateRange(start, end) {
      const startText = this.formatDateOnly(start)
      const endText = this.formatDateOnly(end)
      if (startText && endText) {
        return `${startText} - ${endText}`
      }
      if (endText) {
        return `有效期至 ${endText}`
      }
      if (startText) {
        return `自 ${startText} 起生效`
      }
      return '有效期未设置'
    },
    formatDateOnly(value) {
      if (!value) return ''
      const date = new Date(value)
      if (Number.isNaN(date.getTime())) return ''
      return date.toLocaleDateString('zh-CN', { year: 'numeric', month: '2-digit', day: '2-digit' })
    },
    scrollToComposer() {
      requestAnimationFrame(() => {
        const el = this.$el.querySelector('.composer')
        if (el) {
          el.scrollIntoView({ behavior: 'smooth', block: 'start' })
        }
      })
    }
  }
}
</script>

<style scoped>
.push-page {
  display: grid;
  gap: 24px;
  color: #1f2532;
}

.page-header h2 {
  margin: 0 0 4px;
  font-size: 24px;
  font-weight: 700;
}

.page-desc {
  margin: 0;
  color: #6b7280;
  font-size: 14px;
}

.card {
  background: #ffffff;
  border-radius: 16px;
  padding: 20px 24px;
  box-shadow: 0 12px 30px rgba(21, 32, 54, 0.08);
}

.section-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 16px;
}

.section-header h3 {
  margin: 0;
  font-size: 18px;
}

.section-sub {
  margin: -8px 0 16px;
  font-size: 13px;
  color: #6b7280;
}

.editing-hint {
  font-size: 13px;
  color: #2563eb;
}

.form-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
  gap: 16px;
  margin-bottom: 16px;
}

.coupon-grid {
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
}

.form-block {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.form-label {
  font-size: 13px;
  font-weight: 600;
  color: #4b5563;
}

.form-block input,
.form-block select,
.form-block textarea,
.form-select {
  padding: 10px 12px;
  border: 1px solid #e5e7eb;
  border-radius: 10px;
  font-size: 14px;
  background: #f9fafb;
}

.form-block textarea {
  min-height: 110px;
  resize: vertical;
}

.time-row {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 16px;
  align-items: end;
  margin-bottom: 16px;
}

.coupon-time-row {
  margin-top: 8px;
}

.form-switch {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  color: #374151;
}

.action-row {
  display: flex;
  align-items: center;
  gap: 12px;
}

.form-hint {
  font-size: 12px;
  color: #9ca3af;
}

.btn {
  padding: 10px 18px;
  border-radius: 10px;
  border: none;
  cursor: pointer;
  font-size: 14px;
  transition: transform 0.15s ease, box-shadow 0.15s ease;
}

.btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.btn.primary {
  background: linear-gradient(120deg, #2563eb, #3b82f6);
  color: #ffffff;
}

.btn.ghost {
  background: #eef2ff;
  color: #3b49df;
}

.btn.danger {
  background: #fee2e2;
  color: #dc2626;
}

.btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(37, 99, 235, 0.15);
}

.feedback {
  margin-top: 12px;
  font-size: 13px;
}

.feedback.success {
  color: #16a34a;
}

.feedback.error {
  color: #dc2626;
}

.coupon-list .broadcast-card {
  border: 1px solid #eef2ff;
}

.coupon-card {
  border-color: #e5e7eb;
}

.coupon-meta {
  display: grid;
  gap: 8px;
  margin: 12px 0;
}

.coupon-meta-item {
  display: flex;
  align-items: flex-start;
  gap: 8px;
  font-size: 13px;
  color: #4b5563;
}

.coupon-meta-item .meta-label {
  min-width: 72px;
  font-weight: 600;
  color: #1f2937;
}

.coupon-meta-item .meta-value {
  flex: 1;
}

.coupon .action-row {
  margin-top: 16px;
}

.list-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
}

.loading,
.empty {
  padding: 24px 0;
  text-align: center;
  color: #6b7280;
}

.broadcast-list {
  display: grid;
  gap: 16px;
}

.broadcast-card {
  border: 1px solid #eef1f7;
  border-radius: 14px;
  padding: 18px;
  background: #fdfdff;
  box-shadow: 0 6px 20px rgba(15, 23, 42, 0.06);
}

.broadcast-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 12px;
}

.broadcast-title {
  margin: 0 0 4px;
  font-size: 16px;
  font-weight: 600;
}

.status-chip {
  display: inline-flex;
  align-items: center;
  padding: 2px 10px;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 600;
}

.status-chip.active {
  background: #dcfce7;
  color: #166534;
}

.status-chip.inactive {
  background: #fee2e2;
  color: #991b1b;
}

.broadcast-time {
  color: #6b7280;
  font-size: 12px;
}

.broadcast-target {
  margin: 0 0 6px;
  color: #475569;
  font-size: 13px;
  font-weight: 500;
}

.broadcast-content {
  margin: 0 0 16px;
  color: #1f2937;
  line-height: 1.6;
  white-space: pre-line;
}

.broadcast-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  justify-content: space-between;
  align-items: center;
  font-size: 12px;
  color: #6b7280;
}

.time-window {
  display: flex;
  gap: 12px;
}

.card-actions {
  display: flex;
  gap: 10px;
}

@media (max-width: 720px) {
  .card {
    padding: 16px;
  }

  .broadcast-card {
    padding: 16px;
  }

  .action-row {
    flex-direction: column;
    align-items: stretch;
  }

  .card-actions {
    width: 100%;
    flex-direction: column;
  }
}
</style>