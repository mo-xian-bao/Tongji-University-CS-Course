<template>
  <div class="support-chat">
    <h2>协商沟通</h2>

    <div class="chat-layout">
      <div class="left card">
        <label>选择工单</label>
        <select v-model.number="selectedTicketId" @change="loadConversation">
          <option v-for="t in tickets" :key="t.id" :value="t.id">#{{ t.id }} · {{ t.subject }}</option>
        </select>

        <label style="margin-top:10px">目标方</label>
        <select v-model="targetParty">
          <option value="merchant">商家</option>
          <option value="user">客户</option>
        </select>

        <div class="info muted" v-if="!selectedTicketId">请选择工单以开始沟通</div>
      </div>

      <div class="center card">
        <div class="messages">
          <div v-if="loadingMsgs" class="empty">加载中…</div>
          <div v-else-if="messages.length===0" class="empty">暂无消息</div>
          <div v-for="m in messages" :key="m.id || m.created_at" class="message-item">
            <div class="meta">{{ m.sender_label }} · {{ formatDate(m.created_at) }}</div>
            <div class="text">{{ m.text }}</div>
          </div>
        </div>
        <textarea v-model="composeText" placeholder="输入消息内容"></textarea>
        <div class="actions">
          <button class="btn" @click="composeText=''">取消</button>
          <button class="btn primary" @click="sendMessage" :disabled="!composeText.trim()">发送</button>
        </div>
      </div>

      <div class="right card">
        <h4>工单信息</h4>
        <div v-if="currentTicket">
          <p><strong>#{{ currentTicket.id }}</strong> · {{ currentTicket.subject }}</p>
          <p>发起者：{{ currentTicket.user_name }}（{{ currentTicket.user_phone }}）</p>
          <p>状态：{{ currentTicket.status }}</p>
        </div>
        <div v-else class="muted">未选择工单</div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'SupportChat',
  data() {
    return {
      tickets: [],
      selectedTicketId: null,
      currentTicket: null,
      messages: [],
      loadingMsgs: false,
      composeText: '',
      targetParty: 'merchant'
    }
  },
  created() { this.fetchTickets() },
  methods: {
    async fetchTickets() {
      try {
        const res = await axios.get('/api/support/tickets')
        this.tickets = res.data.data || []
      } catch (e) {
        this.tickets = this.mockTickets()
      }
    },
    async loadConversation() {
      if (!this.selectedTicketId) return
      this.currentTicket = this.tickets.find(t => t.id === this.selectedTicketId) || null
      // 优先使用 ticket.order_id 或 ticket.request_id，如果没有，仍允许手动发送（后端需要 order_id 或 request_id）
      const orderId = this.currentTicket && this.currentTicket.order_id
      const requestId = this.currentTicket && this.currentTicket.request_id
      this.loadingMsgs = true
      try {
        const res = await axios.get('/api/messages', { params: { order_id: orderId, request_id: requestId } })
        this.messages = (res.data.data || []).map(m => ({ ...m, sender_label: m.sender_type || '系统' }))
      } catch (e) {
        this.messages = []
      } finally { this.loadingMsgs = false }
    },
    async sendMessage() {
      if (!this.selectedTicketId) return
      const ticket = this.currentTicket || this.tickets.find(t=>t.id===this.selectedTicketId)
      const payload = { text: this.composeText.trim() }
      // 优先填 order_id，再填 request_id
      if (ticket && ticket.order_id) payload.order_id = ticket.order_id
      else if (ticket && ticket.request_id) payload.request_id = ticket.request_id
      else {
        // 无关联 id 时提示并退出
        this.$message && this.$message.warning && this.$message.warning('该工单没有关联 order_id 或 request_id，无法通过消息接口发送。')
        return
      }

      try {
        const res = await axios.post('/api/messages', payload)
        const msg = res.data.data || { text: payload.text, created_at: new Date().toISOString(), sender_type: 'support' }
        this.messages.push({ ...msg, sender_label: '客服' })
        this.composeText = ''
        this.$message && this.$message.success && this.$message.success('发送成功')
      } catch (e) {
        this.$message && this.$message.error && this.$message.error('发送失败')
      }
    },
    mockTickets() { return [ { id:301, subject:'订单问题', user_name:'客户A', user_phone:'13800000001', order_id:5001 } ] },
    formatDate(s) { if(!s) return ''; return new Date(s).toLocaleString('zh-CN') }
  }
}
</script>

<style scoped>
.support-chat h2 { color:#075985; margin-bottom:12px }
.chat-layout { display:grid; grid-template-columns:220px 1fr 300px; gap:12px }
.left .card, .center .card, .right .card { padding:12px }
.messages { max-height:480px; overflow:auto; margin-bottom:8px }
.message-item { padding:8px; border-radius:6px; background:#f8fafc; margin-bottom:8px }
.message-item .meta { color:#64748b; font-size:12px }
.text { color:#0f172a }
.actions { display:flex; justify-content:flex-end; gap:8px }
.btn { padding:8px 12px; border-radius:6px; border:1px solid #cbd5e1; background:#fff }
.btn.primary { background:#1e40af; color:#fff }
.muted { color:#94a3b8 }
@media (max-width:900px){ .chat-layout{grid-template-columns:1fr} }
</style>
