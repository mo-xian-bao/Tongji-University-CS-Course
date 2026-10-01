<template>
  <div class="merchant-chat">
    <header class="chat-header">
      <button class="back" @click="goBack">&lt;</button>
      <h3>{{ restaurantName || '联系商家' }}</h3>
    </header>

    <main class="chat-body">
      <div class="messages">
        <div
          v-for="(m, idx) in messages"
          :key="idx"
          :class="['message-row', m.from === 'me' ? 'me' : 'them']"
        >
          <img class="avatar" :src="m.avatar || defaultAvatar" alt="avatar" />
          <!-- 普通消息 -->
          <div v-if="!m.type || m.type === 'message'" class="bubble">{{ m.text }}</div>
          <!-- 特殊操作消息 -->
          <div 
            v-else-if="m.type === 'action'" 
            class="action-bubble"
            :class="getActionTheme(m.actionType)"
          >
            <!-- 头部：标题与图标 -->
            <div class="action-header">
              <span class="action-icon">{{ getActionIcon(m.actionType) }}</span>
              <span class="action-title-text">{{ m.title }}</span>
            </div>

            <div class="action-content">
              <!-- 场景1：修改成功（双列对比） -->
              <div v-if="m.actionType === 'modify_success'" class="comparison-grid">
                <div class="comparison-col col-old">
                  <h5>修改前</h5>
                  <div class="col-content">
                    <ul v-if="m.content.beforeItems && m.content.beforeItems.length">
                      <li v-for="item in m.content.beforeItems" :key="item.id">
                        <!-- 【修复1】增加 item.name 的兜底显示 -->
                        <span class="item-name">{{ item.name || item.dish_name || '未知菜品' }}</span>
                        <span class="qty">x{{ item.quantity }}</span>
                      </li>
                    </ul>
                    <p v-else class="empty-text">无菜品</p>
                    <div class="note-text" v-if="m.content.beforeNote">备注：{{ m.content.beforeNote }}</div>
                  </div>
                </div>
                
                <div class="comparison-arrow">→</div>

                <div class="comparison-col col-new">
                  <h5>修改后</h5>
                  <div class="col-content">
                    <ul v-if="m.content.afterItems && m.content.afterItems.length">
                      <li v-for="item in m.content.afterItems" :key="item.id">
                        <!-- 【修复2】增加 item.name 的兜底显示 -->
                        <span class="item-name">{{ item.name || item.dish_name || '未知菜品' }}</span>
                        <span class="qty">x{{ item.quantity }}</span>
                      </li>
                    </ul>
                    <p v-else class="empty-text">无菜品</p>
                    <div class="note-text" v-if="m.content.afterNote">备注：{{ m.content.afterNote }}</div>
                  </div>
                </div>
              </div>
              
              <!-- 场景2：申请修改（单列详情） -->
              <div v-if="m.actionType === 'modify_request'" class="detail-list">
                <div class="detail-row">
                  <label>申请变更内容：</label>
                  <div class="detail-value box-highlight">
                     <!-- 【修复3】修正 v-for 语法错误，移除 && length 判断 -->
                     <ul v-if="m.content.afterItems && m.content.afterItems.length">
                      <li v-for="item in m.content.afterItems" :key="item.dish_id || item.id">
                        <!-- 【修复4】增加容错显示 -->
                        {{ item.name || item.dish_name || '未知菜品' }} 
                        <span class="qty">x{{ item.quantity }}</span>
                      </li>
                    </ul>
                    <p v-else>无菜品</p>
                    <p v-if="m.content.afterNote" class="sub-note">备注: {{ m.content.afterNote }}</p>
                  </div>
                </div>
                <div class="detail-row" v-if="m.content.customerCount">
                   <label>就餐人数：</label> <span>{{ m.content.customerCount }}人</span>
                </div>
                <div class="detail-row" v-if="m.content.reason">
                   <label>申请理由：</label> <span>{{ m.content.reason }}</span>
                </div>
              </div>
              
              <!-- 场景3：取消类或拒绝类（成功或申请或拒绝） -->
              <div v-if="m.actionType.includes('cancel') || m.actionType.includes('reject')" class="simple-reason">
                <p class="reason-text">"{{ m.content.reason || '无理由' }}"</p>
              </div>

              <!-- 底部状态条 -->
              <div class="action-footer" v-if="m.content.status">
                <span class="status-badge" :class="getActionTheme(m.actionType)">
                  {{ m.content.status }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>

    <!-- 快捷操作按钮：移到发送窗口上方 -->
    <div v-if="order && !(order.status === 'cancelled' || order.status === 'completed')" class="quick-actions">
      <template v-if="order && order.status === 'pending'">
        <button class="quick-btn" @click="openEditModal(order, false)">修改订单</button>
        <button class="quick-btn danger" @click="cancelDirect">取消订单</button>
      </template>
      <template v-else-if="order && (order.status === 'confirmed' || order.status === 'preparing')">
        <button class="quick-btn" @click="openRequestModal('modify')">申请修改</button>
        <button class="quick-btn" @click="openRequestModal('cancel')">申请取消</button>
      </template>
      <!-- 当 cancelled 或 completed 时，不显示按钮 -->
    </div>

    <!-- 发送消息窗口 -->
    <div v-if="order && !(order.status === 'cancelled' || order.status === 'completed')" class="chat-input">
      <input v-model="inputText" @keydown.enter="sendMessage" placeholder="给商家写点什么..." />
      <button class="btn--primary" @click="sendMessage">发送</button>
    </div>

    <!-- 订单结束提示 -->
    <div v-else-if="order && (order.status === 'cancelled' || order.status === 'completed')" class="chat-closed">
      订单已结束，聊天窗口已关闭
    </div>

    <!-- 申请请求弹窗 -->
    <div v-if="showRequestModal" class="modal-mask" @click.self="closeRequestModal">
      <div class="modal-panel">
        <h4>{{ requestType === 'modify' ? '申请修改订单' : '申请取消订单' }}</h4>
        <textarea v-model="requestReason" rows="4" placeholder="请填写理由"></textarea>
        <div class="modal-actions">
          <button @click="closeRequestModal">取消</button>
          <button class="btn--primary" @click="submitRequest" :disabled="submitting">{{ submitting ? '提交中...' : '提交' }}</button>
        </div>
      </div>
    </div>

    <!-- 修改/编辑订单弹窗（原样复制的修改逻辑 UI） -->
    <div v-if="showEditModal" class="modal-mask" @click.self="closeEditModal">
      <div class="modal-panel modal-panel--large">
        <h3>{{ isRequestMode ? '申请修改订单' : '修改订单' }}</h3>
        <div v-if="editLoading" class="modal-loading">加载中...</div>
        <div v-else>
          <div v-if="!editForm.items.length" class="modal-loading">暂无可修改菜品</div>
          <div v-else>
            <div v-for="item in editForm.items" :key="item.id" class="edit-item">
              <div class="edit-item-info">
                <p class="edit-item-name">{{ item.dish_name }}</p>
                <p class="edit-item-price">¥{{ item.unit_price }}</p>
              </div>
              <div class="edit-item-actions">
                <button class="qty-btn" @click="updateQuantity(item, -1)" :disabled="item.quantity <= 1">-</button>
                <span class="qty-value">{{ item.quantity }}</span>
                <button class="qty-btn" @click="updateQuantity(item, 1)">+</button>
                <button class="remove-btn" @click="removeItem(item)">移除</button>
              </div>
            </div>

            <div v-for="item in editForm.items" :key="item.id + '-options'" class="form-row-group">
              <div v-if="item.is_spicy_selectable" class="form-row">
                <label>{{ item.dish_name }} - 辣度</label>
                <select v-model="item.spiciness">
                  <option value="不辣">不辣</option>
                  <option value="微辣">微辣</option>
                  <option value="中辣">中辣</option>
                  <option value="特辣">特辣</option>
                </select>
              </div>
              <div v-if="item.is_garnish_selectable" class="form-row">
                <label>{{ item.dish_name }} - 葱花香菜</label>
                <select v-model="item.garnish">
                  <option value="要葱花香菜">要葱花香菜</option>
                  <option value="要葱花">要葱花</option>
                  <option value="要香菜">要香菜</option>
                  <option value="不要葱花不要香菜">不要葱花不要香菜</option>
                </select>
              </div>
            </div>

            <div class="form-row">
              <label>就餐人数</label>
              <input type="number" min="1" v-model.number="editForm.customerCount" />
            </div>

            <div class="form-row">
              <label>备注</label>
              <textarea v-model.trim="editForm.note" rows="3" placeholder="补充口味、忌口等信息"></textarea>
            </div>

            <div class="edit-summary">
              <span>合计：</span>
              <strong>¥{{ editTotalPrice }}</strong>
            </div>

            <div class="modal-actions">
              <button class="btn btn--outline" @click="closeEditModal">取消</button>
              <button class="btn btn--primary"
                      :disabled="editSaving || !editForm.items.length"
                      @click="isRequestMode ? submitModificationRequest() : submitEdit()">
                {{ editSaving ? '提交中...' : (isRequestMode ? '确认申请' : '确认修改') }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

  </div>
</template>

<script>

export default {
  name: 'MerchantChat',
  data() {
    return {
      order: null,
      restaurantName: null,
      messages: [],
      avatarBasePath: '/static/uploads/avatar/',
       // 缓存当前登录者与商家头像（从 /api/users/profile 获取）
       myAvatar: null,
       merchantAvatar: null,
      inputText: '',
      showRequestModal: false,
      requestType: 'modify',
      requestReason: '',
      submitting: false,

      // 编辑/修改相关（原样复制）
      showEditModal: false,
      editLoading: false,
      editSaving: false,
      isRequestMode: false,
      editForm: {
        orderId: null,
        items: [],
        note: '',
        customerCount: 1,
        tableId: null
      },
      withdrawLoading: false,
      // 使用后端统一的默认头像路径（项目中实际位置）
      defaultAvatar: `${API_url}/static/default/avatar.png`,
      // 映射 sender_id -> 后端返回的 user 对象（包含 avatar_url）
      profileMap: {},
      messages: [], // 消息数组，现在支持普通消息和特殊消息
      lastMessageId: 0, // 记录最后消息ID，用于拉取新消息
      originalForm: null, // 保存修改前的订单信息
      restaurantAvatar: null, // 新增：餐厅头像
      restaurantUserId: null, // 新增：餐厅用户ID
    }
  },
  computed: {
    otherAvatar() {
      // 商家头像从餐厅信息获取
      return this.normalizeAvatar(this.restaurantAvatar || this.defaultAvatar)
    },
    editTotalPrice() {
      return this.editForm.items
        .reduce((sum, item) => sum + item.unit_price * item.quantity, 0)
        .toFixed(2)
    }
  },
  async created() {
    const orderId = this.$route.query.orderId
    await this.loadOrder(orderId)
    if (this.order) {
      await this.loadRestaurant(this.order.restaurant_id)  // 从 order 中获取 restaurant_id
      await this.fetchMyProfile()
      // 新增：预加载当前用户和商家用户头像
      const userIds = [localStorage.getItem('userId'), this.restaurantUserId].filter(Boolean)
      await this.fetchProfilesByIds(userIds)
    } else {
      console.error('加载订单失败，无法初始化聊天')
      return
    }
    await this.fetchMessages()
    this.lastMessageId = Math.max(...this.messages.map(m => m.id || 0))
    if (!this.messages || !this.messages.length) {
      this.messages = [{
        from: 'them',
        text: '您好，有什么可以帮您？',
        time: new Date().toLocaleTimeString(),
        avatar: this.otherAvatar,
        timestamp: new Date()
      }]
    }
    this.startMessagePolling()
  },
  methods: {
    // 简化 avatar 规范化：后端已返回相对路径或完整 URL，只前缀 API_url（若需要）
    normalizeAvatar(path) {
      const API = typeof API_url !== 'undefined' ? API_url : (window.API_url || window.location.origin)
      // 回退到后端的 default avatar 文件（注意文件名 avatar）
      if (!path) return `${API}/static/default/avatar.png`
      path = String(path).replace(/\\/g, '/').trim()
      if (/^https?:\/\//.test(path)) return path
      if (path.startsWith('/')) return `${API}${path}`
      return `${API}/static/uploads/avatar/${path}`
    },

    // 拉取当前用户资料以获取 avatar（复用 /api/users/profile）
    async fetchMyProfile() {
      try {
        const token = localStorage.getItem('token')
        if (!token) return
        const resp = await fetch('/api/users/profile', { headers: { Authorization: `Bearer ${token}` } })
        const data = await resp.json()
        if (resp.ok && data.success) {
          const u = data.data?.user || data.user || data.data
          if (u) {
            if (u.id) {
              localStorage.setItem('userId', u.id)
              // 【修复点】：主动将自己存入 profileMap，确保“我”的头像能立刻显示
              if (this.$set) {
                this.$set(this.profileMap, u.id, u)
              } else {
                this.profileMap[u.id] = u
              }
            }
          }
        }
      } catch (e) {
        console.error('fetchMyProfile error', e)
      }
    },
    

    async loadOrder(orderId) {
      if (!orderId) return
      const token = localStorage.getItem('token')
      try {
        const resp = await fetch(`/api/orders/${orderId}`, { headers: { Authorization: `Bearer ${token}` } })
        const data = await resp.json()
        if (data.success) {
          this.order = data.data
        }
      } catch (e) {
        console.error('loadOrder', e)
      }
    },
    // 加载餐厅信息（包括头像）
    async loadRestaurant(restaurantId) {
      try {
        const resp = await fetch(`/api/restaurants/${restaurantId}`)
        const data = await resp.json()
        if (resp.ok && data.success) {
          // 存储餐厅头像和用户ID
          this.restaurantAvatar = data.data.avatar_url
          this.restaurantUserId = data.data.user_id
        }
      } catch (e) {
        console.error('获取餐厅信息失败', e)
      }
    },
    async fetchMessages() {
      if (!this.order || !this.order.id) return
      try {
        const token = localStorage.getItem('token')
        // 获取当前登录用户ID，用于双重判断
        const currentUserId = parseInt(localStorage.getItem('userId')) || 0
        
        const resp = await fetch(`/api/messages?order_id=${this.order.id}&last_id=${this.lastMessageId}`, {
          headers: { Authorization: `Bearer ${token}` }
        })
        const result = await resp.json()
        
        if (result.success && result.data.length > 0) {
          // 1. 获取所有发送者的资料
          const senderIds = result.data.map(m => m.sender_id).filter(Boolean)
          await this.fetchProfilesByIds(senderIds)

          // 2. 处理消息
          const newMessages = result.data.map(m => {
            // 【修复点】：判断是否是“我”的逻辑增强，防止 sender_type 不准确
            const isMe = m.sender_type === 'user' || (m.sender_id && m.sender_id === currentUserId)

            // 【修复点】：头像逻辑重构
            let rawAvatar = null
            if (isMe) {
              // 如果是我，取 profileMap 中的头像
              rawAvatar = this.profileMap[m.sender_id]?.avatar_url
            } else {
              // 如果是商家，优先显示餐厅头像(Logo)，其次才是发送该消息的员工头像
              rawAvatar = this.restaurantAvatar || this.profileMap[m.sender_id]?.avatar_url
            }
            
            // 规范化路径
            const avatar = this.normalizeAvatar(rawAvatar)

            const messageData = {
              id: m.id,
              from: isMe ? 'me' : 'them',
              text: m.text,
              time: new Date(m.created_at).toLocaleTimeString(),
              avatar, // 使用计算好的 avatar
              timestamp: new Date(m.created_at)
            }

            // 处理特殊消息类型
            if (m.message_type === 'action') {
              try {
                const actionData = typeof m.text === 'string' ? JSON.parse(m.text) : m.text
                messageData.type = 'action'
                messageData.actionType = actionData.actionType
                messageData.title = actionData.title
                messageData.content = actionData.content
              } catch (e) {
                console.error('解析 Action 消息失败', e)
                messageData.type = 'message' // 解析失败降级为普通消息
              }
            }
            return messageData
          })

          // 追加新消息 (去重)
          const existingIds = new Set(this.messages.map(m => m.id || 0))
          const filteredNewMessages = newMessages.filter(m => !existingIds.has(m.id))
          this.messages.push(...filteredNewMessages)
          
          this.lastMessageId = Math.max(...this.messages.map(m => m.id || 0))
          
          // 滚动到底部 (可选优化)
          this.$nextTick(() => {
            const chatBody = this.$el.querySelector('.chat-body')
            if (chatBody) chatBody.scrollTop = chatBody.scrollHeight
          })
        }
     } catch (e) {
       console.error('fetchMessages error', e)
     }
    },
    // 批量根据 userId 列表从后端获取用户资料，填充 profileMap（忽略当前已存在的）
    async fetchProfilesByIds(ids = []) {
      if (!ids || !ids.length) return
      const token = localStorage.getItem('token')
      const API = typeof API_url !== 'undefined' ? API_url : (window.API_url || window.location.origin)
      const uniq = [...new Set(ids.filter(id => id != null && !this.profileMap[id]))]
      await Promise.all(uniq.map(async id => {
        try {
          const resp = await fetch(`${API}/api/users/${id}`, { headers: token ? { Authorization: `Bearer ${token}` } : {} })
          if (!resp.ok) return
          const r = await resp.json()
          if (r && r.success && r.data) {
            this.$set ? this.$set(this.profileMap, id, r.data) : (this.profileMap[id] = r.data)
          }
        } catch (e) {
          // ignore
        }
      }))
    },

    async sendMessage() {
      if (!this.inputText.trim() || !this.order || !this.order.id) return
      const text = this.inputText.trim()
      const token = localStorage.getItem('token')
      const currentUserId = localStorage.getItem('userId')

      try {
        const resp = await fetch('/api/messages', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
          body: JSON.stringify({ order_id: this.order.id, text })
        })
        const result = await resp.json()
        if (resp.ok && result.success) {
          // 更新 profileMap (如果后端返回了用户信息)
          if (result.data && result.data.sender_id && result.data.user) {
            if (this.$set) this.$set(this.profileMap, result.data.sender_id, result.data.user)
            else this.profileMap[result.data.sender_id] = result.data.user
          }

          // 【修复点】：优先从 profileMap 获取头像，保证一致性
          let rawAvatar = result.data.avatar || result.data.avatar_url
          if (!rawAvatar && currentUserId) {
            rawAvatar = this.profileMap[currentUserId]?.avatar_url
          }
          
          const avatar = this.normalizeAvatar(rawAvatar)

          this.messages.push({
            id: result.data.id,
            from: 'me',
            text: result.data.text,
            time: new Date(result.data.created_at).toLocaleTimeString(),
            avatar,
            timestamp: new Date(result.data.created_at)
          })
          this.inputText = ''
          
          // 滚动到底部
          this.$nextTick(() => {
            const chatBody = this.$el.querySelector('.chat-body')
            if (chatBody) chatBody.scrollTop = chatBody.scrollHeight
          })
         } else {
           throw new Error(result.message || '发送失败')
         }
       } catch (e) {
         console.error('sendMessage error', e)
         alert('发送消息失败')
       }
     },

    startMessagePolling(intervalMs = 5000) {
      if (this._msgTimer) clearInterval(this._msgTimer)
      this._msgTimer = setInterval(() => { this.fetchMessages().catch(()=>{}) }, intervalMs)
    },

    stopMessagePolling() {
      if (this._msgTimer) {
        clearInterval(this._msgTimer)
        this._msgTimer = null
      }
    },


    /* ----- 取消/申请/修改（原样复制逻辑） ----- */
    openRequestModal(arg1, arg2) {
      // 支持两种调用：openRequestModal('modify') 或 openRequestModal(order, 'modify')
      let order = null
      let type = null
      if (typeof arg1 === 'string') {
        type = arg1
        order = arg2 || this.order
      } else {
        order = arg1 || this.order
        type = arg2
      }
      if (order) this.order = order

      // 申请修改直接打开编辑弹窗（以请求模式 isRequest=true）
      if (type === 'modify') {
        // 如果已经有订单 id，直接打开编辑窗口并切换到申请模式
        this.openEditModal(this.order, true)
        return
      }

      // 其他类型（如 cancel）使用简短的申请理由弹窗
      this.requestType = type || 'cancel'
      this.requestReason = ''
      this.showRequestModal = true
    },

    closeRequestModal() {
      this.showRequestModal = false
    },
    async submitRequest() {
      if (!this.requestReason.trim() || !this.order) return
      this.submitting = true
      try {
        const token = localStorage.getItem('token')
        if (!token) { this.$router.push('/login'); return }
        const payload = {
          type: this.requestType,
          reason: this.requestReason.trim(),
          payload: this.requestType === 'modify' ? { 
            items: this.order.items.map(item => ({ ...item, dish_name: item.dish_name })), // 改为 dish_name
            note: this.order.note 
          } : {}
        }
        const resp = await fetch(`/api/orders/${this.order.id}/request-change`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
          body: JSON.stringify(payload)
        })
        const data = await resp.json()
        if (data.success) {
          // 移除：不再push普通消息，避免重复
          // this.messages.push({ from: 'me', text: `已发起${this.requestType === 'modify' ? '修改' : '取消'}申请：${this.requestReason}`, time: new Date().toLocaleTimeString() })
          alert('申请已提交，商家会在聊天中或订单页面处理')
          this.closeRequestModal()
          // 发送action消息到后端保存
          const actionId = await this.sendActionMessage(this.requestType === 'modify' ? 'modify_request' : 'cancel_request', this.requestType === 'modify' ? '申请修改' : '申请取消', {
            reason: this.requestReason,
            status: '申请已提交，等待商家处理'
          })
          // 本地添加显示
          this.messages.push({
            id: actionId,
            type: 'action',
            from: 'me',
            actionType: this.requestType === 'modify' ? 'modify_request' : 'cancel_request',
            title: this.requestType === 'modify' ? '申请修改' : '申请取消',
            content: {
              reason: this.requestReason,
              status: '申请已提交，等待商家处理'
            },
            time: new Date().toLocaleTimeString(),
            avatar: this.normalizeAvatar(this.profileMap[localStorage.getItem('userId')]?.avatar_url || this.defaultAvatar),
            timestamp: new Date()
          })
        }
      } catch (e) {
        console.error('submitRequest', e)
        alert('提交失败')
      } finally {
        this.submitting = false
      }
    },

    async cancelDirect() {
      if (!confirm('确认直接取消该订单？（仅在待接单时允许）')) return
      const token = localStorage.getItem('token')
      try {
        const resp = await fetch(`/api/orders/${this.order.id}/cancel`, {
          method: 'POST',
          headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' }
        })
        const data = await resp.json()
        if (data.success) {
          // 移除：不再push普通消息，避免重复
          // this.messages.push({ from: 'me', text: '已直接取消订单', time: new Date().toLocaleTimeString() })
          alert('订单已取消')
          if (this.order) this.order.status = 'cancelled'
          // 发送action消息到后端保存
          const actionId = await this.sendActionMessage('cancel_success', '取消成功', { reason: '用户直接取消' })
          // 本地添加显示
          this.messages.push({
            id: actionId,
            type: 'action',
            from: 'me',
            actionType: 'cancel_success',
            title: '取消成功',
            content: { reason: '用户直接取消' },
            time: new Date().toLocaleTimeString(),
            avatar: this.normalizeAvatar(this.profileMap[localStorage.getItem('userId')]?.avatar_url || this.defaultAvatar),
            timestamp: new Date()
          })
        } else {
          alert(data.message || '取消失败')
        }
      } catch (e) {
        console.error('cancelDirect', e)
        alert('取消失败')
      }
    },

    /* ---- 编辑/修改相关（原样复制） ---- */
    async openEditModal(order, isRequest) {
      this.isRequestMode = isRequest
      this.showEditModal = true
      this.editLoading = true
      try {
        const token = localStorage.getItem('token')
        if (!token) { this.$router.push('/login'); return }
        // 如果传了 order 则使用它，否则使用 this.order
        const targetId = (order && order.orderId) ? order.orderId : (this.order && this.order.id ? this.order.id : null)
        if (!targetId) throw new Error('未指定订单')
        const resp = await fetch(`/api/orders/${targetId}`, {
          headers: { Authorization: `Bearer ${token}` }
        })
        const result = await resp.json()
        if (!resp.ok || !result.success) throw new Error(result.message || '获取订单详情失败')
        const detail = result.data
        // 新增：调试 detail.items
        console.log('detail.items:', detail.items)
        // 确保 items 为数组
        const items = Array.isArray(detail.items) ? detail.items : (detail.items ? [detail.items] : [])
        this.editForm = {
          orderId: detail.id,
          tableId: detail.table_id,
          customerCount: detail.customer_count || 1,
          note: detail.note || '',
          items: items.map(item => ({
            id: item.id,
            dish_id: item.dish_id,
            name: item.dish_name,
            unit_price: Number(item.unit_price),
            quantity: item.quantity,
            spiciness: item.spiciness || null,
            garnish: item.garnish || null,
            is_spicy_selectable: item.dish?.is_spicy_selectable || false,
            is_garnish_selectable: item.dish?.is_garnish_selectable || false
          }))
        }
        // 新增：调试 editForm.items
        console.log('editForm.items:', this.editForm.items)
        // 保存修改前的信息（深拷贝）
        this.originalForm = JSON.parse(JSON.stringify(this.editForm))
      } catch (err) {
        console.error(err)
        alert(err.message || '无法加载订单详情')
        this.closeEditModal()
      } finally {
        this.editLoading = false
      }
    },
    closeEditModal() {
      this.showEditModal = false
      this.isRequestMode = false
      this.editForm = { orderId: null, items: [], note: '', customerCount: 1, tableId: null }
      this.originalForm = null // 重置
    },
    updateQuantity(item, delta) {
      const next = item.quantity + delta
      if (next >= 1) item.quantity = next
    },
    removeItem(target) {
      this.editForm.items = this.editForm.items.filter(item => item !== target)
    },
    async submitEdit() {
      if (!this.editForm.orderId || !this.editForm.items.length) {
        alert('请至少保留一项菜品'); return
      }
      this.editSaving = true
      try {
        const token = localStorage.getItem('token')
        if (!token) { this.$router.push('/login'); return }
        const payload = {
          note: this.editForm.note,
          table_id: this.editForm.tableId,
          customer_count: this.editForm.customerCount,
          items: this.editForm.items.map(item => ({
            dish_id: item.dish_id,
            quantity: item.quantity,
            spiciness: item.spiciness,
            garnish: item.garnish
          }))
        }
        const resp = await fetch(`/api/orders/${this.editForm.orderId}`, {
          method: 'PUT',
          headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' },
          body: JSON.stringify(payload)
        })
        const result = await resp.json()
        if (!resp.ok || !result.success) throw new Error(result.message || '修改订单失败')
        alert('订单修改成功')
        // 更新本地 order 状态/详情
        if (this.order && this.order.id === this.editForm.orderId) this.order = result.data
        // 新增：调试 originalForm.items 和 content
        console.log('originalForm.items:', this.originalForm?.items)
        const content = {
          beforeItems: this.originalForm?.items || [],
          beforeNote: this.originalForm?.note || '',
          afterItems: this.editForm.items,
          afterNote: this.editForm.note
        }
        console.log('content:', content)
        // 发送action消息到后端保存
        const actionId = await this.sendActionMessage('modify_success', '修改成功', content)
        // 本地添加显示（立即显示）
        this.messages.push({
          id: actionId, // 设置ID
          type: 'action',
          from: 'me',
          actionType: 'modify_success',
          title: '修改成功',
          content: content,
          time: new Date().toLocaleTimeString(),
          avatar: this.normalizeAvatar(this.profileMap[localStorage.getItem('userId')]?.avatar_url || this.defaultAvatar),
          timestamp: new Date()
        })
        // 关闭弹窗并重置（移到最后）
        this.showEditModal = false
        this.isRequestMode = false
        this.editForm = { orderId: null, items: [], note: '', customerCount: 1, tableId: null }
        this.originalForm = null
      } catch (error) {
        console.error('修改订单失败:', error)
        alert(error.message || '修改订单失败，请稍后重试')
      } finally {
        this.editSaving = false
      }
    },
    async submitModificationRequest() {
      if (!this.editForm.items.length) { alert('申请修改的内容不能为空'); return }
      this.editSaving = true
      try {
        const token = localStorage.getItem('token')
        if (!token) { this.$router.push('/login'); return }
        const payload = {
          type: 'modify',
          reason: '用户申请修改订单内容',
          payload: {
            note: this.editForm.note,
            customer_count: this.editForm.customerCount,
            items: this.editForm.items.map(item => ({
              dish_id: item.dish_id,
              dish_name: item.name || item.dish_name, 
              name: item.name || item.dish_name, // 为了保险，两个字段都带上
              quantity: item.quantity,
              spiciness: item.spiciness,
              garnish: item.garnish
            }))
          }
        }
        const response = await fetch(`/api/orders/${this.editForm.orderId}/request-change`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
          body: JSON.stringify(payload)
        })
        const result = await response.json()
        if (!response.ok || !result.success) throw new Error(result.message || '提交修改申请失败')
        alert('修改申请已提交')
        // 发送action消息到后端保存
        const actionId = await this.sendActionMessage('modify_request', '申请修改', {
          beforeItems: this.originalForm?.items || [],
          beforeNote: this.originalForm?.note || '',
          afterItems: this.editForm.items,
          afterNote: this.editForm.note,
          customerCount: this.editForm.customerCount,
          status: '申请已提交，等待商家处理'
        })
        // 本地添加显示
        this.messages.push({
          id: actionId,
          type: 'action',
          from: 'me',
          actionType: 'modify_request',
          title: '申请修改',
          content: {
            beforeItems: this.originalForm?.items || [],
            beforeNote: this.originalForm?.note || '',
            afterItems: this.editForm.items,
            afterNote: this.editForm.note,
            customerCount: this.editForm.customerCount,
            status: '申请已提交，等待商家处理'
          },
          time: new Date().toLocaleTimeString(),
          avatar: this.normalizeAvatar(this.profileMap[localStorage.getItem('userId')]?.avatar_url || this.defaultAvatar),
          timestamp: new Date()
        })
        // 关闭弹窗并重置（移到最后）
        this.showEditModal = false
        this.isRequestMode = false
        this.editForm = { orderId: null, items: [], note: '', customerCount: 1, tableId: null }
        this.originalForm = null
      } catch (error) {
        console.error('提交修改申请失败:', error)
        alert(error.message || '提交修改申请失败，请稍后重试')
      } finally {
        this.editSaving = false
      }
    },

    // 发送特殊消息到后端的辅助方法
    async sendActionMessage(actionType, title, content) {
      try {
        const token = localStorage.getItem('token')
        const payload = {
          order_id: this.order.id,
          text: JSON.stringify({ actionType, title, content }),
          message_type: 'action'
        }
        const resp = await fetch('/api/messages', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
          body: JSON.stringify(payload)
        })
        const result = await resp.json()
        if (resp.ok && result.success) {
          return result.data.id // 返回ID
        } else {
          throw new Error(result.message || '发送特殊消息失败')
        }
      } catch (e) {
        console.error('发送特殊消息失败', e)
        return null
      }
    },
    getStatusClass(status) {
      if (status.includes('等待')) return 'status-pending'
      if (status.includes('已通过')) return 'status-success'
      if (status.includes('已拒绝')) return 'status-rejected'
      return ''
    },

    getActionTheme(actionType) {
      switch (actionType) {
        case 'modify_success':
        case 'cancel_success':
          return 'theme-success' // 绿色：成功类
        case 'modify_request':
        case 'cancel_request':
          return 'theme-warning' // 橙色：申请/等待类
        case 'modify_reject': // 假设未来有拒绝状态
        case 'cancel_reject':
          return 'theme-danger'  // 红色：拒绝/失败类
        default:
          return 'theme-info'    // 蓝色：默认
      }
    },
  
    // 新增：获取对应状态的图标（使用 Emoji 或 SVG）
    getActionIcon(actionType) {
      if (actionType.includes('success')) return '✅'
      if (actionType.includes('request')) return '⏳'
      if (actionType.includes('reject')) return '❌'
      return '📝'
    },
    goBack() {
      // 明确导航到订单页面，避免 router.back() 导航到不确定的页面
      this.$router.replace({ name: 'OrderManagement' })
    },
  },
  beforeUnmount() {
    this.stopMessagePolling()
  }
}
</script>

<style scoped>
.merchant-chat {
  display: flex;
  flex-direction: column;
  height: 100vh;
}

.chat-header {
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  padding: 0 16px;
  height: 56px;
  background-color: #f8f8f8;
  border-bottom: 1px solid #e7e7e7;
}

.back {
  position: absolute;
  left: 16px;
  font-size: 24px; /* 增大 "<" 符号大小 */
  color: #333;
  background: none;
  border: none;
  cursor: pointer;
  padding: 8px;
}

h3 {
  margin: 0;
  font-size: 18px;
  color: #333;
  text-align: center;
}

.chat-body {
  flex: 1;
  padding: 16px;
  background-color: #fff;
  overflow-y: auto;
}

.messages {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.message-row {
  display: flex;
  align-items: flex-end;
  gap: 10px;
  /* 移除 width: 100% 以让消息块自适应宽度 */
}

.message-row.them {
  /* 对方消息推到最左边 */
  margin-right: auto;
}

.message-row.me {
  /* 我的消息推到最右边 */
  margin-left: auto;
  flex-direction: row-reverse;
}

.avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  object-fit: cover;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
}

.bubble {
  max-width: 70%;
  padding: 10px 14px;
  border-radius: 14px;
  background: #fff;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
}

.message-row.me .bubble {
  background: #e6f7ff;
}

.time {
  font-size: 11px;
  color: #999;
  margin-top: 4px;
}

.chat-input {
  display: flex;
  align-items: center;
  padding: 12px 16px; /* 增加内边距 */
  background-color: #f8f8f8;
  border-top: 1px solid #e7e7e7;
  width: 100%; /* 确保占满宽度 */
  box-sizing: border-box; /* 包含 padding 在宽度内 */
  box-shadow: 0 -2px 4px rgba(0, 0, 0, 0.1); /* 添加阴影 */
}

input {
  flex: 1;
  padding: 12px 16px; /* 增加内边距 */
  border: 1px solid #ddd;
  border-radius: 24px; /* 圆滑边框 */
  font-size: 14px;
  color: #333;
  outline: none;
  background-color: #fff;
  transition: border-color 0.2s ease; /* 添加过渡 */
}

input:focus {
  border-color: #007bff; /* 聚焦时边框变蓝 */
}

input::placeholder {
  color: #bbb;
}

.btn--primary {
  padding: 12px 20px; /* 增加内边距 */
  border: none;
  border-radius: 24px; /* 圆滑边框 */
  background-color: #007bff;
  color: #fff;
  font-size: 14px;
  cursor: pointer;
  margin-left: 8px; /* 与输入框间距 */
  transition: background-color 0.2s ease; /* 添加过渡 */
}

.btn--primary:hover {
  background-color: #0056b3; /* 悬停变深 */
}

.btn--primary:disabled {
  background-color: #007bff80;
  cursor: not-allowed;
}

/* 新增：快捷操作按钮样式 */
.quick-actions {
  display: flex;
  gap: 8px;
  padding: 8px 16px;
  background-color: #f8f8f8;
  border-top: 1px solid #e7e7e7;
}

.quick-btn {
  padding: 8px 16px;
  border: 1px solid #007bff;
  border-radius: 20px; /* 圆滑边框 */
  background: #fff;
  color: #007bff;
  font-size: 14px;
  cursor: pointer;
  transition: background-color 0.2s ease;
}

.quick-btn:hover {
  background-color: #f0f8ff;
}

.quick-btn.danger {
  border-color: #dc3545;
  color: #dc3545;
}

.quick-btn.danger:hover {
  background-color: #ffebee;
}

/* 弹窗整体：增加内边距，避免内容贴边 */
.modal-mask {
  position: fixed;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(0, 0, 0, 0.5);
  z-index: 1000;
  padding: 18px;
}

.modal-panel {
  background: #fff;
  border-radius: 12px;
  width: 80%;
  max-width: 720px;
  max-height: 80vh;
  box-shadow: 0 8px 24px rgba(0,0,0,0.25);
  display: flex;
  flex-direction: column;
  overflow: hidden;
  padding: 16px; /* <- 关键：内边距 */
  box-sizing: border-box;
}

/* 大弹窗适度放宽 */
.modal-panel--large {
  max-width: 900px;
}

/* 标题与子区块间距 */
.modal-panel > h3,
.modal-panel > h4 {
  margin: 0 0 12px 0;
  font-size: 18px;
  text-align: center;
  padding: 6px 0;
}

/* 内容区：可滚动，内边距统一 */
.modal-content {
  padding: 8px 0;
  overflow: auto;
  flex: 1 1 auto;
}

/* 行为区：右侧保留内边距，按钮不贴边 */
.modal-actions {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
  padding-top: 12px;
  padding-bottom: 4px;
  border-top: 1px solid #eee;
  background: transparent;
}

/* 编辑项优化：布局更紧凑，按钮更小 */
.edit-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px 0;
  border-bottom: 1px solid #f1f1f1;
  gap: 12px;
}

.edit-item-info {
  flex: 1 1 60%;
}

.edit-item-name {
  margin: 0 0 6px 0;
  font-size: 15px;
  color: #222;
}

.edit-item-price {
  margin: 0;
  font-size: 13px;
  color: #777;
}

/* 操作区更紧凑 */
.edit-item-actions {
  display: flex;
  align-items: center;
  gap: 8px;
  min-width: 140px;
  justify-content: flex-end;
}

.qty-btn {
  padding: 6px 10px;
  border-radius: 12px;
  background-color: #007bff;
  color: #fff;
  font-size: 14px;
  cursor: pointer;
  border: none;
}

.qty-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.qty-value {
  width: 36px;
  text-align: center;
  font-size: 14px;
}

/* 移除按钮更小 */
.remove-btn {
  padding: 6px 10px;
  border-radius: 10px;
  background-color: #dc3545;
  color: #fff;
  font-size: 13px;
  border: none;
}

/* 表单行、输入、选择项更紧凑 */
.form-row, .form-row-group {
  margin-bottom: 10px;
  display: flex;
  gap: 12px;
  align-items: center;
  flex-wrap: wrap;
}

.form-row label {
  min-width: 90px;
  font-size: 14px;
  color: #444;
}

input[type="number"], textarea, select {
  flex: 1 1 auto;
  padding: 8px 10px;
  border-radius: 8px;
  border: 1px solid #e5e5e5;
  font-size: 14px;
}

/* 备注 textarea 显示更紧凑并与边框保持距离 */
textarea {
  min-height: 72px;
  max-height: 140px;
  resize: vertical;
  margin-top: 6px;
}

/* 合计区更显眼但紧凑 */
.edit-summary {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 8px;
  margin-top: 8px;
  border-top: 1px dashed #f1f1f1;
}

.edit-summary strong {
  color: #ff6b00;
  font-size: 18px;
}

/* 按钮尺寸适当缩小 */
.btn, .btn--primary, .btn--outline {
  padding: 8px 14px;
  border-radius: 8px;
  font-size: 14px;
}

/* 修改：对比视图样式，支持水平并列 */
.comparison-grid {
  margin-top: 15px;
  display: flex; /* 改为 flex，支持水平并列 */
  gap: 12px;
  border-top: 1px solid #f0f0f0;
  padding-top: 12px;
  justify-items: start;
  align-items: flex-start;
}

.comparison-col {
  flex: 1; /* 每个列占等宽 */
  max-width: none; /* 移除单列限制 */
}

.comparison-col h5 {
  margin-top: 0;
  margin-bottom: 8px;
  font-size: 14px;
}

.comparison-col ul {
  padding-left: 18px;
  margin: 5px 0;
  font-size: 13px;
  color: #555;
}

.comparison-col p {
  font-size: 13px;
  color: #555;
}

.comparison-arrow {
  align-self: center;
  color: #999;
  font-weight: bold;
}

/* --- 强化 action-bubble 样式 --- */
.action-bubble {
  width: 100%; /* 占满容器允许的宽度，由父级控制最大宽 */
  min-width: 260px;
  max-width: 340px; /* 限制最大宽度，防止太宽难看 */
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  overflow: hidden;
  border: 1px solid #eee;
  border-left-width: 5px; /* 左侧色条 */
  margin: 4px 0;
  display: flex;
  flex-direction: column;
}

/* --- 主题配色方案 --- */
/* 成功 (Success) - 绿色 */
.theme-success {
  border-left-color: #52c41a;
  background-color: #f6ffed; /* 极淡的绿色背景 */
}
.theme-success .action-title-text { color: #52c41a; }
.theme-success .status-badge { background: #e6f7ff; color: #52c41a; border: 1px solid #b7eb8f; }

/* 警告/申请 (Warning) - 橙色 */
.theme-warning {
  border-left-color: #faad14;
  background-color: #fffbe6; /* 极淡的黄色背景 */
}
.theme-warning .action-title-text { color: #faad14; }
.theme-warning .status-badge { background: #fff7e6; color: #faad14; border: 1px solid #ffe58f; }

/* 危险/拒绝 (Danger) - 红色 */
.theme-danger {
  border-left-color: #ff4d4f;
  background-color: #fff1f0;
}
.theme-danger .action-title-text { color: #ff4d4f; }
.theme-danger .status-badge { background: #fff2f0; color: #ff4d4f; border: 1px solid #ffccc7; }

/* 默认 (Info) - 蓝色 */
.theme-info {
  border-left-color: #1890ff;
  background-color: #e6f7ff;
}

/* --- 内部布局 --- */
.action-header {
  padding: 10px 14px;
  border-bottom: 1px solid rgba(0,0,0,0.05);
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 600;
  background: rgba(255,255,255,0.5);
}

.action-icon { font-size: 16px; }
.action-title-text { font-size: 15px; }

.action-content {
  padding: 12px 14px;
  font-size: 13px;
  color: #333;
  background: #fff; /* 内容区保持白色背景，阅读更清晰 */
}

/* --- 对比网格 (修改成功) --- */
.comparison-grid {
  display: flex;
  align-items: flex-start;
  gap: 6px;
}

.comparison-col {
  flex: 1;
  background: #fafafa;
  border-radius: 8px;
  padding: 8px;
}

.col-old h5, .col-new h5 {
  margin: 0 0 6px 0;
  font-size: 12px;
  color: #999;
  text-align: center;
}

.col-new {
  background: #f4ffed; /* 修改后的列稍微带点绿，强调新内容 */
  border: 1px solid #b7eb8f;
}

.col-content ul {
  padding: 0;
  margin: 0;
  list-style: none;
}

.col-content li {
  font-size: 13px;
  margin-bottom: 4px;
  display: flex;
  justify-content: space-between;
}

.col-content .qty { font-weight: bold; color: #555; }
.note-text { font-size: 12px; color: #888; margin-top: 4px; border-top: 1px dashed #eee; padding-top: 4px; }
.empty-text { color: #ccc; font-style: italic; text-align: center; margin: 4px 0; }

.comparison-arrow {
  align-self: center;
  color: #999;
  font-weight: bold;
}

/* --- 详情列表 (申请修改) --- */
.detail-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.detail-row {
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.detail-row label {
  font-size: 12px;
  color: #888;
}
.detail-value.box-highlight {
  background: #fafafa;
  border: 1px dashed #ddd;
  padding: 8px;
  border-radius: 6px;
}
.detail-value ul { list-style: none; padding: 0; margin: 0; }
.sub-note { font-size: 12px; color: #666; margin-top: 4px; }

/* --- 简单理由 (取消) --- */
.simple-reason {
  background: #f9f9f9;
  padding: 10px;
  border-radius: 6px;
  text-align: center;
  font-style: italic;
  color: #555;
}

/* --- 底部状态 --- */
.action-footer {
  margin-top: 12px;
  text-align: right;
}

.status-badge {
  display: inline-block;
  padding: 4px 10px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 600;
  background: #eee;
  color: #666;
  /* 具体的颜色由 theme-* 类覆盖 */
}
</style>