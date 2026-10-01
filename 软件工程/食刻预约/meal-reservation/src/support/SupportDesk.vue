<template>
  <div class="support-desk">
    <h2>客服工作台 — 工单</h2>
    <div class="workspace">
      <div class="tickets-list card">
        <div class="list-header">
          <input v-model="query" placeholder="搜索工单/用户/手机号" class="search" />
          <div class="filters">
            <select v-model="statusFilter" class="status-select">
              <option value="all">全部</option>
              <option value="open">待受理</option>
              <option value="closed">已关闭</option>
              <option value="in_process">处理中</option>
              <option value="resolved">待反馈</option>
            </select>
          </div>
        </div>
        <div class="list-body">
          <div v-if="loadingTickets" class="empty">加载中…</div>
          <div v-else-if="filteredTickets.length === 0" class="empty">没有匹配的工单</div>
          <div v-for="ticket in filteredTickets" :key="ticket.id" class="ticket-item" :class="{selected: selectedTicket && selectedTicket.id === ticket.id}" @click="openTicket(ticket.id)">
            <div class="ticket-left">
              <div class="ticket-subject">#{{ ticket.id }} · {{ ticket.subject }}</div>
              <div class="ticket-meta">{{ ticket.user_name }} • {{ formatDate(ticket.created_at) }}</div>
            </div>
            <div class="ticket-right">
              <span class="status" :style="{background: statusColor(ticket.status)}">{{ statusLabel(ticket.status) }}</span>
            </div>
          </div>
        </div>
      </div>
      <div class="ticket-detail card">
        <div v-if="!selectedTicket" class="empty-detail">请选择左侧工单以查看详情</div>
        <div v-else>
          <div class="detail-header">
            <div>
              <h3>#{{ selectedTicket.id }} · {{ selectedTicket.subject }}</h3>
              <div class="meta">发起者：{{ selectedTicket.user_name }} • {{ selectedTicket.user_phone }} • {{ formatDate(selectedTicket.created_at) }}</div>
            </div>
            <div class="actions">
              <select v-model="selectedStatus">
                <option value="open">待受理</option>
                <option value="in_process">处理中</option>
                <option value="resolved">待反馈</option>
              </select>
              <button class="btn primary" @click="saveStatus" :disabled="selectedTicket.status == 'closed'">更新状态</button>
            </div>
          </div>
          <div class="detail-body">
            <div class="section">
              <h4>问题描述</h4>
              <div class="content">{{ selectedTicket.content }}</div>
            </div>
            <div class="section">
              <h4>附件</h4>
              <div v-if="selectedTicket.attachments && selectedTicket.attachments.length">
                <div class="attachments">
                  <div v-for="(a, idx) in selectedTicket.attachments" :key="idx" class="attachment">
                    <img v-if="isImageUrl(a)" :src="a" class="thumb" @click="openUrl(a)" />
                    <a v-else :href="a" target="_blank" rel="noopener" class="file-link">{{ filenameFromUrl(a) }}</a>
                  </div>
                </div>
              </div>
              <div v-else class="muted">暂无附件</div>
            </div>
            <div class="section">
              <div class="section-header">
                <h4>内部备注</h4>
                <button class="toggle-scroll" @click="showInternalNotesScroll = !showInternalNotesScroll" title="切换滚动框显示">
                  {{ showInternalNotesScroll ? '▼ 隐藏' : '▶ 显示' }}
                </button>
              </div>
              <div v-if="showInternalNotesScroll && selectedTicket.internal_notes && selectedTicket.internal_notes.length" class="scroll-container">
                <div v-for="(note, idx) in selectedTicket.internal_notes" :key="idx" class="note">
                  <div class="note-meta">{{ note.author_name ?note.author_name:"你自己"}} · {{ formatDate(note.created_at) }}</div>
                  <div class="note-content">{{ note.text }}</div>
                </div>
              </div>
              <div v-else-if="!showInternalNotesScroll && selectedTicket.internal_notes && selectedTicket.internal_notes.length" class="scroll-container-summary">
                共 {{ selectedTicket.internal_notes.length }} 条备注
              </div>
              <div v-if="!selectedTicket.internal_notes || !selectedTicket.internal_notes.length" class="muted">暂无内部备注</div>
              <textarea v-model="newInternalNote" placeholder="添加内部备注（仅客服可见）"></textarea>
              <div class="note-actions">
                <button class="btn" @click="newInternalNote=''">取消</button>
                <button class="btn" @click="addInternalNote" :disabled="!newInternalNote.trim()">添加备注</button>
              </div>
            </div>
            <div class="section">
              <div class="section-header">
                <h4>回复记录</h4>
                <button class="toggle-scroll" @click="showRepliesScroll = !showRepliesScroll" title="切换滚动框显示">
                  {{ showRepliesScroll ? '▼ 隐藏' : '▶ 显示' }}
                </button>
              </div>
              <div v-if="showRepliesScroll && selectedTicket.replies && selectedTicket.replies.length" class="scroll-container">
                <div v-for="(r, idx) in selectedTicket.replies" :key="idx" class="reply">
                  <div class="reply-meta" v-if="r.from == '客服'">客服 · {{ r.author_name?r.author_name:'你自己'}} · {{ formatDate(r.created_at) }}</div>
                  <div class="user-reply-meta" v-if="r.from != '客服'">用户 · {{ formatDate(r.created_at) }}</div>
                  <div v-if="r.from == '客服'">{{ r.text }}</div>
                  <div style="text-align: right;" v-if="r.from != '客服'">{{ r.text }}</div>
                </div>
              </div>
              <div v-else-if="!showRepliesScroll && selectedTicket.replies && selectedTicket.replies.length" class="scroll-container-summary">
                共 {{ selectedTicket.replies.length }} 条消息
              </div>
              <div v-if="!selectedTicket.replies || !selectedTicket.replies.length" class="muted">暂无回复</div>
                  <textarea 
                  v-model="newReply" 
                  class="reply-textarea"
                  :title="selectedTicket.status !== 'in_process' ? '工单未在处理中，无法回复' : ''"
                  :disabled='selectedTicket.status !== "in_process"'
                  ></textarea>
              <div class="note-actions">
                <button class="btn" @click="newReply=''">取消</button>
                <button class="btn primary" @click="sendReply" :disabled="!newReply.trim()">发送回复</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'SupportDesk',
  data() {
    return {
      tickets: [],
      loadingTickets: false,
      selectedTicket: null,
      query: '',
      statusFilter: 'all',
      selectedStatus: 'all',
      newInternalNote: '',
      newReply: '',
      showInternalNotesScroll: true,
      showRepliesScroll: true
    }
  },
  computed: {
    filteredTickets() {
      const q = this.query.trim().toLowerCase()
      return this.tickets
        .filter(t => this.statusFilter === 'all' ? true : t.status === this.statusFilter)
        .filter(t => {
          if (!q) return true
          return `${t.subject} ${t.user_name} ${t.user_phone}`.toLowerCase().includes(q)
        })
        .sort((a, b) => new Date(b.created_at) - new Date(a.created_at))
    }
  },
  created() { this.fetchTickets() },
  methods: {
    async fetchTickets() {
      this.loadingTickets = true
      try {
        const token = localStorage.getItem('token')
        const res = await axios.get(`/support/get_alltickets`, { headers: { Authorization: `Bearer ${token}` } })
        this.tickets = res.data.data || []
      } catch (e) {
        this.tickets = this.mockTickets()
      } finally { this.loadingTickets = false }
    },
    async openTicket(id) {
      const cached = this.tickets.find(t => t.id === id)
      if (cached && cached.content) { 
        this.selectedTicket = JSON.parse(JSON.stringify(cached)); 
        this.selectedStatus = this.selectedTicket.status; return 
      }
      try { 
        const res = await axios.get(`/support/tickets/${id}`); 
        this.selectedTicket = res.data.data } 
      catch (e) { 
          this.selectedTicket = this.tickets.find(t => t.id === id) || null }
      if (this.selectedTicket) 
        this.selectedStatus = this.selectedTicket.status
    },
    async refreshSelectedTicket() {
      if (!this.selectedTicket) return
      try {
        const token = localStorage.getItem('token')
        const res = await axios.get(`/support/tickets/${this.selectedTicket.id}`, { headers: { Authorization: `Bearer ${token}` } })
        this.selectedTicket = res.data.data || this.selectedTicket
        this.selectedStatus = this.selectedTicket.status
      } catch (e) {
        console.error('刷新工单信息失败:', e)
      }
    },
    statusLabel(status) {
      const map = { open: '待受理', closed: '已关闭', in_process: '处理中', resolved: '待反馈' }
      return map[status] || status
    },
    statusColor(status) { const map = { open: '#ffb74d', closed: '#4db6ac', in_process: '#29b6f6', resolved: '#9e9e9e' }; return map[status] || '#bbb' },
    formatDate(dateStr) { 
      if (!dateStr) return ''; 
      const d = new Date(dateStr); 
      return d.toLocaleString() 
    },
    async saveStatus() {
  if (!this.selectedTicket) return;
  
  // 获取用户信息
  const userStr = localStorage.getItem('user');
  const currentUser = userStr ? JSON.parse(userStr) : { username: '客服' };
  
  const previousStatus = this.selectedTicket.status;
  const newStatus = this.selectedStatus;
  const ticketId = this.selectedTicket.id;
  
  // 如果状态没变化，直接返回
  if (previousStatus === newStatus) return;
  
  // 保存旧状态以便回滚
  const rollback = () => {
    this.selectedTicket.status = previousStatus;
    const idx = this.tickets.findIndex(t => t.id === ticketId);
    if (idx !== -1) this.tickets[idx].status = previousStatus;
  };
  
  try {
    // 更新状态
    this.selectedTicket.status = newStatus;
    const idx = this.tickets.findIndex(t => t.id === ticketId);
    if (idx !== -1) this.tickets[idx].status = newStatus;
    
    // 发送更新请求
    await axios.put(`/support/tickets/${ticketId}`, { status: newStatus });
    
    // 根据状态变化发送自动回复
    let autoReply = null;
    
    if (previousStatus === 'open' && newStatus === 'in_process') {
      autoReply = {
        text: `我是客服${currentUser.username}，很高兴为您服务`,
        from: '客服',
        created_at: new Date().toISOString()
      };
    } else if (previousStatus === 'in_process' && newStatus === 'open') {
      autoReply = {
        text: '很抱歉无法为您继续服务，现在已有新客服来为您服务',
        from: '客服',
        created_at: new Date().toISOString()
      };
    } else if (previousStatus === 'in_process' && (newStatus === 'closed' || newStatus === 'resolved')) {
      autoReply = {
        text: '本次服务已完成，请为本次服务打分',
        from: '客服',
        created_at: new Date().toISOString()
      };
    }
    
    // 发送自动回复
    if (autoReply) {
      await axios.post(`/support/tickets/${ticketId}/reply`, autoReply);
    }
    
    // 刷新工单信息
    await this.refreshSelectedTicket();
    
    // 显示成功消息
    if (this.$message?.success) {
      this.$message.success('状态已更新');
    }
    
  } catch (error) {
    // 回滚状态
    rollback();
    
    // 显示错误消息
    if (this.$message?.error) {
      this.$message.error('更新失败: ' + (error.response?.data?.message || error.message));
    }
    
    console.error('保存状态失败:', error);
  }
},
    async addInternalNote() {
      if (!this.newInternalNote.trim() || !this.selectedTicket) return
      const note = { text: this.newInternalNote.trim(), created_at: new Date().toISOString() }
      this.selectedTicket.internal_notes = this.selectedTicket.internal_notes || []
      this.selectedTicket.internal_notes.unshift(note)
      this.newInternalNote = ''
      try { 
        await axios.post(`/support/tickets/${this.selectedTicket.id}/internal_notes`, note);
        await this.refreshSelectedTicket();
        this.$message && this.$message.success && this.$message.success('内部备注已添加') 
      } catch (e) { 
        this.$message && this.$message.error && this.$message.error('保存失败（仅本地已添加）') 
      }
    },
    async sendReply() {
      if (!this.newReply.trim() || !this.selectedTicket) return
      const payload = { text: this.newReply.trim(), from: '客服', created_at: new Date().toISOString() }
      this.selectedTicket.replies = this.selectedTicket.replies || []
      this.selectedTicket.replies.unshift(payload)
      this.newReply = ''
      try { 
        await axios.post(`/support/tickets/${this.selectedTicket.id}/reply`, payload);
        await this.refreshSelectedTicket();
        this.$message && this.$message.success && this.$message.success('回复已发送') 
      } 
      catch (e) { 
        this.$message && this.$message.error && this.$message.error('发送失败（本地已添加）') 
      }
    },
    isImageUrl(url) {
      if (!url) return false
      const lower = url.toLowerCase()
      return lower.endsWith('.png') || lower.endsWith('.jpg') || lower.endsWith('.jpeg') || lower.endsWith('.gif') || lower.endsWith('.webp') || lower.endsWith('.bmp')
    },
    openUrl(url) {
      try { window.open(url, '_blank') } catch (e) { /* noop */ }
    },
    filenameFromUrl(url) {
      try { return decodeURIComponent((url || '').split('/').pop() || url) } catch (e) { return url }
    }
  }
}
</script>

<style scoped>
.support-desk h2 { margin-bottom: 18px; color: #164e63; font-weight: 700 }
.workspace { display: grid; grid-template-columns: 360px 1fr; gap: 20px }
.card { background: #fff; padding: 18px; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.04) }
.tickets-list .list-header { display:flex; gap:10px; align-items:center; margin-bottom:12px }
.search { flex:1; padding:8px 10px; border:1px solid #e6f2f1; border-radius:6px }
.filters button { margin-left:6px; padding:6px 10px; border-radius:6px; border:1px solid transparent; background:#f3faf8; color:#0f766e }
.filters button.active { background:#0f766e; color:white }
.list-body { max-height:720px; overflow:auto }
.ticket-item { display:flex; justify-content:space-between; padding:12px; border-bottom:1px solid #f0f6f6; cursor:pointer }
.ticket-item:hover { background:#f8fffe }
.ticket-item.selected { background:#e6fffb; border-left:4px solid #0f766e }
.ticket-subject { font-weight:600; color:#0f172a }
.ticket-meta { font-size:12px; color:#6b7280 }
.status { padding:6px 10px; border-radius:12px; color:white; font-weight:700; font-size:12px }
.ticket-detail .detail-header { display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:12px }
.detail-header h3 { margin:0; color:#0f172a }
.meta { color:#6b7280; font-size:13px }
.actions { display:flex; gap:8px; align-items:center }
select { padding:6px 8px; border-radius:6px }
  .btn { padding:8px 12px; border-radius:6px; border:1px solid #cbd5e1; background:#f8fafc; cursor:pointer; color:#0f172a }
  .btn.primary { background:#1e40af; color:white; border-color:#1e40af }
.section { margin-bottom:14px }
.section h4 { margin:0 0 8px 0; color:#164e63 }
.content { padding:12px; background:#fbfdfc; border-radius:6px; color:#0f172a }
.muted { color:#9ca3af }
textarea { width:100%; min-height:72px; padding:10px; margin-top:8px; border-radius:6px; border:1px solid #e6f2f1 }
.note-actions { display:flex; justify-content:flex-end; gap:8px; margin-top:8px }
.note { padding:8px; border-left:3px solid #e6f2f1; background:#fff; margin-bottom:8px }
.note-meta { font-size:12px; color:#6b7280 }
.reply { padding:10px; background:#f8fffe; border-radius:6px; margin-bottom:8px }
.reply-meta { font-size:12px; color:#0f766e; margin-bottom:6px }
.user-reply-meta { font-size:12px; color:#0f2a76; margin-bottom:6px;text-align: right }
.section-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:8px }
.section-header h4 { margin:0; color:#164e63 }
.toggle-scroll { background:none; border:none; color:#0f766e; cursor:pointer; font-size:12px; padding:4px 8px; border-radius:4px; transition:all 0.3s }
.toggle-scroll:hover { background:#e6f2f1; color:#164e63 }
.scroll-container { max-height:500px; overflow-y:auto; border:1px solid #e6f2f1; border-radius:6px; padding:8px; background:#fbfdfc; margin-bottom:8px }
.scroll-container-summary { padding:12px; background:#f3faf8; border-radius:6px; color:#6b7280; text-align:center; font-size:13px; margin-bottom:8px }
.empty { padding:30px; text-align:center; color:#9ca3af }
.empty-detail { padding:60px; text-align:center; color:#cbd5e1 }
 .attachments { display:flex; gap:10px; flex-wrap:wrap; }
 .attachment { display:flex; flex-direction:column; align-items:center }
 .thumb { width:120px; height:80px; object-fit:cover; border-radius:6px; cursor:pointer; border:1px solid #e6f2f1 }
 .file-link { color:#0f766e; text-decoration:underline }
 .reply-textarea {
  width: 100%;
  min-height: 120px;
  padding: 10px;
  border-radius: 4px;
  border: 1px solid #dcdfe6;
  font-size: 14px;
  resize: vertical;
  transition: all 0.3s;
}

.reply-textarea:disabled {
  background-color: #f5f7fa;
  border-color: #e4e7ed;
  color: #c0c4cc;
  cursor: not-allowed;
}

/* 增强悬停效果 */
.reply-textarea:disabled:hover {
  border-color: #f56c6c;
}

/* 自定义 tooltip 样式 */
.reply-textarea:disabled[title] {
  position: relative;
}

.reply-textarea:disabled[title]:hover::after {
  content: attr(title);
  position: absolute;
  bottom: calc(100% + 10px);
  left: 50%;
  transform: translateX(-50%);
  background: rgba(0, 0, 0, 0.8);
  color: white;
  padding: 6px 12px;
  border-radius: 4px;
  font-size: 12px;
  white-space: nowrap;
  z-index: 1000;
  pointer-events: none;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.reply-textarea:disabled[title]:hover::before {
  content: '';
  position: absolute;
  bottom: calc(100% + 5px);
  left: 50%;
  transform: translateX(-50%);
  border: 5px solid transparent;
  border-top-color: rgba(0, 0, 0, 0.8);
  z-index: 1000;
  pointer-events: none;
}
@media (max-width: 900px) { .workspace { grid-template-columns: 1fr } .tickets-list { order:2 } .ticket-detail { order:1 } }
</style>

<!-- Usage notes: 期望后端接口同组件内注释 -->
