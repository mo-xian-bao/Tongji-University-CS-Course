<template>
  <header class="header">
      <div class="back-btn" @click="goBack">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M19 12H5M12 19l-7-7 7-7"/>
        </svg>
      </div>
      <div style="flex:1;display:flex;justify-content:center;align-items:center;">
        <div class="header-title">客服中心</div>
      </div>
  </header>
    <div class="support-center-layout">

    <aside :class="['sidebar', { collapsed: sidebarCollapsed }]">
      <div class="sidebar-header">
        <div v-if="!sidebarCollapsed" class="sidebar-title">菜单</div>
        <button class="collapse-btn" @click="sidebarCollapsed = !sidebarCollapsed" :title="sidebarCollapsed ? '展开' : '收起'">{{ sidebarCollapsed ? '›' : '‹' }}</button>
      </div>
      <nav class="side-nav">
        <button :class="{ active: view === 'create' }" @click="view='create'" class="nav-btn create-btn" :title="sidebarCollapsed ? '提交工单' : ''">
          <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M12 5v14M5 12h14"/>
          </svg>
          <span v-if="!sidebarCollapsed" class="nav-label">提交工单</span>
        </button>
        <button :class="{ active: view === 'list' }" @click="view='list'" class="nav-btn list-btn" :title="sidebarCollapsed ? '我的工单' : ''">
          <svg class="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2M9 5a2 2 0 0 0 2 2h2a2 2 0 0 0 2-2M9 5a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2M9 12h6M9 16h6"/>
          </svg>
          <span v-if="!sidebarCollapsed" class="nav-label">我的工单</span>
        </button>
      </nav>
    </aside>

    <main class="content">
      <section v-if="view==='create'" class="create-ticket">
        <h3>提交新工单</h3>
      <div class="form-row">
        <label>工单类型 （必填）</label>
        <select v-model="form.ticket_type">
          <option value="general">通用</option>
          <option value="order_issue">订单问题</option>
          <option value="refund">退款/退单</option>
          <option value="other">其他</option>
        </select>
      </div>

      <div class="form-row">
        <label>标题 （必填）</label>
        <input v-model="form.subject" placeholder="简短描述问题" />
      </div>

      <div class="form-row">
        <label>描述 （必填）</label>
        <textarea v-model="form.content" placeholder="请详细描述遇到的问题，越详细越有助于快速处理"></textarea>
      </div>

      <div class="form-row">
        <label>关联订单（可选，支持筛选）</label>
        <div class="order-select">
          <input v-model="orderFilter" placeholder="按订单号搜索" />
          <select v-model="form.order_id">
            <option :value="null">不关联订单</option>
            <option v-for="o in filteredOrders" :key="o.id" :value="o.id">{{ o.order_number }} - {{ o.status }}</option>
          </select>
        </div>
      </div>

      <div class="form-row">
        <label>附件（最多 5 个）</label>
        <input type="file" multiple @change="onFilesSelected" />
        <div class="attachments-preview">
            <div v-for="(p, idx) in previews" :key="idx" class="preview-item">
              <div class="preview-inner">
                <img v-if="p.type==='image'" :src="p.src" />
                <div v-else class="file-placeholder">{{ p.name }}</div>
              </div>
              <div class="upload-state">
                <div v-if="p.uploading">上传中 {{ p.progress || 0 }}%</div>
                <div v-else-if="p.error" class="error">失败</div>
                <div v-else-if="p.url" class="done">已上传</div>
              </div>
              <button class="remove" @click="removePreview(idx)">删除</button>
            </div>
          </div>
      </div>

        <div class="form-actions">
          <button class="cancel" @click="resetForm">重置</button>
            <button class="submit" @click="submitTicket" :disabled="submitting">{{ submitting ? '提交中...' : '提交工单' }}</button>
        </div>
      </section>

      <section v-if="view==='list'" class="my-tickets">
        <h3>我的工单</h3>
        <div v-if="loadingTickets">加载中...</div>
        <ul v-else>
            <li v-for="t in tickets" :key="t.id" class="ticket-card">
              <div class="card-left">
                <div class="num">工单号: {{ t.ticket_number }}</div>
                <div class="subject">{{ t.subject }}</div>
                <div class="badges">
                  <span :class="['badge', typeClass(t.ticket_type)]">{{ typeForm(t.ticket_type) }}</span>
                  <span :class="['badge', statusClass(t.status)]">{{ statusForm(t.status) }}</span>
                </div>
                <div class="meta">提交于: {{ t.created_at ? (new Date(t.created_at)).toLocaleString() : '' }}</div>
              </div>
              <div class="card-right">
                <div class="actions">
                  <router-link class="order-link btn btn-secondary" :to="{ name: 'MessageDetail', params: { id: t.order_id } }" v-if="t.order_id">查看订单</router-link>
                  <button class="detail-btn btn btn-primary" @click="viewDetail(t.id)">查看详情</button>
                  <div style="height:8px"></div>
                  <button v-if="t.status !== 'closed'" class="btn btn-danger" @click="closeTicket(t.id)">关闭工单</button>
                  <button v-else class="btn btn-secondary" @click="reopenTicket(t.id)">重新打开</button>
                </div>
              </div>
            </li>
        </ul>
      </section>
    </main>
    <!-- 简单的详情弹窗 -->
    <div v-if="detailVisible" class="modal-overlay" @click="detailVisible=false">
      <div class="modal-content" @click.stop>
        <h4>工单详情 - {{ detail.ticket_number }}</h4>
        <p><strong>标题：</strong>{{ detail.subject }}</p>
        <p><strong>描述：</strong></p>
        <p class="desc">{{ detail.content }}</p>
        <p><strong>关联订单：</strong>{{ detail.order_number || '无' }}</p>
        <p><strong>状态：</strong>{{ statusForm(detail.status) }}</p>
        <p><strong>受理客服：</strong>{{ detail.status == 'open' ? '暂无' : detail.assigned_cs_name }}</p>
        <div style="margin-top:8px">
          <template v-if="detail.status === 'resolved'">
            <strong>评分：</strong>
            <div v-if="detail.rating">
              <span>已评分：{{ detail.rating }} / 5</span>
              <div v-if="detail.rating_comment" style="margin-top:6px">{{ detail.rating_comment }}</div>
              <div style="margin-top:8px">
                <button v-if="detail.rating <= 2" @click="reopenTicket(detail.id)">我不满意，重新打开工单</button>
              </div>
            </div>
            <div v-else>
              <div style="margin-top:6px">请为本次处理评分：</div>
              <div style="display:flex;gap:8px;margin-top:6px;align-items:center">
                <div>
                  <button v-for="s in [1,2,3,4,5]" :key="s" @click="ratingDraft = s" :style="{fontWeight: ratingDraft===s ? '700' : '400'}">{{ s }}</button>
                </div>
                <textarea v-model="ratingCommentDraft" placeholder="可选，填写不满意原因" style="flex:1;height:64px"></textarea>
              </div>
              <div style="margin-top:8px">
                <button @click="submitRating(detail.id, ratingDraft || 5, ratingCommentDraft)">提交评分</button>
              </div>
            </div>
          </template>
        </div>
          <div v-if="detail.attachments && detail.attachments.length" style="margin-top:8px">
            <strong>附件：</strong>
            <div class="detail-attachments" style="display:flex;gap:8px;margin-top:6px;flex-wrap:wrap">
              <div v-for="(a, i) in detail.attachments" :key="i" style="width:94px;height:94px;border:1px solid #eee;border-radius:6px;display:flex;align-items:center;justify-content:center;overflow:hidden;">
                <a :href="a" target="_blank" rel="noreferrer">
                  <img v-if="isImageUrl(a)" :src="a" style="max-width:100%;max-height:100%;object-fit:cover" />
                  <div v-else style="padding:6px;font-size:12px;color:#333;text-align:center;">打开文件</div>
                </a>
              </div>
            </div>
          </div>
        <div class="modal-actions" style="display:flex;justify-content:space-between;align-items:center;">
              <button class="btn btn-primary" @click="viewMessageThread(detail.id)" style="margin-right:auto;">查看消息流</button>
              <div style="display:flex;gap:8px;">
                <button class="btn btn-secondary" @click="detailVisible=false">关闭</button>
                <button v-if="detail.status !== 'closed'" class="btn btn-danger" @click="closeTicket(detail.id)">关闭工单</button>
                <button v-else class="btn btn-secondary" @click="reopenTicket(detail.id)">重新打开</button>
              </div>
        </div>
      </div>
    </div>
    <!-- 创建成功弹窗 -->
    <div v-if="createSuccessVisible" class="modal-overlay" @click="createSuccessVisible=false">
      <div class="modal-content" @click.stop>
        <h4>工单已创建</h4>
        <p>工单号：<strong>{{ createdTicket.ticket_number }}</strong></p>
        <p>我们已收到您的工单，客服会尽快处理。</p>
        <div class="modal-actions">
          <button @click="createSuccessVisible=false">知道了</button>
          <button @click="openCreatedTicket">查看工单</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { getOrders } from '@/api/orders'
import { createTicket, getTickets, getTicket, updateTicket } from '@/api/support'

const STATUS_LABELS = {
  open: '开放中',
  in_process: '处理中',
  resolved: '已解决',
  closed: '已关闭'
}

const STATUS_CLASSES = {
  open: 'badge-open',
  in_process: 'badge-in_process',
  resolved: 'badge-resolved',
  closed: 'badge-closed'
}

const TYPE_LABELS = {
  order_issue: '订单问题',
  refund: '退款',
  other: '其它',
  general: '通用'
}

const TYPE_CLASSES = {
  order_issue: 'badge-order_issue',
  refund: 'badge-refund',
  other: 'badge-other',
  general: 'badge-general'
}

export default {
  name: 'SupportCenter',
  data() {
    return {
      form: {
        ticket_type: 'general',
        subject: '',
        content: '',
        order_id: null
      },
      orders: [],
      orderFilter: '',
      tickets: [],
      loadingTickets: false,
      submitting: false,
      detailVisible: false,
      detail: {},
      view: 'create',
      sidebarCollapsed: false,
      previews: [], // { type: 'image'|'file', src, name, file }
      attachmentsUrls: [],
      createSuccessVisible: false,
      createdTicket: null,
      ratingDraft: null,
      ratingCommentDraft: ''
    }
  },
  computed: {
    filteredOrders() {
      const kw = (this.orderFilter || '').trim()
      if (!kw) return this.orders
      return this.orders.filter(o => (o.order_number || '').includes(kw))
    }
  },
  mounted() {
    this.fetchOrders();
    this.fetchTickets();
  },
  beforeUnmount() {
    this.clearPreviews()
  },
  methods: {
    async fetchOrders() {
      try {
        const res = await getOrders();
        const data = res.data;
        if (data.success) {
          // 数据结构可能直接返回数组或 { data: [...] }
          this.orders = Array.isArray(data.data) ? data.data : (data.orders || data.data || []);
        } else {
          this.orders = [];
        }
      } catch (e) {
        console.error('fetch orders failed', e);
        this.orders = [];
      }
    },
    resetForm() {
      this.form = {
        ticket_type: 'general',
        subject: '',
        content: '',
        order_id: null
      };
      this.orderFilter = '';
      this.clearPreviews();
      this.attachmentsUrls = [];
    },
    statusForm(code) {
      return STATUS_LABELS[code] || code || ''
    },
    typeForm(code) {
      return TYPE_LABELS[code] || code || ''
    },
    typeClass(code) {
      return TYPE_CLASSES[code] || TYPE_CLASSES.general
    },
    statusClass(code) {
      return STATUS_CLASSES[code] || STATUS_CLASSES.closed
    },
    goBack(){
      this.$router.push('/profile')
    },
    onFilesSelected(e){
      const files = Array.from(e.target.files || []);
      if(!files.length) return;
      const max = 5;
      const availableSlots = max - this.previews.length;
      if (availableSlots <= 0) {
        alert('最多只能上传 5 个附件');
        return;
      }
      const toAdd = files.slice(0, availableSlots);
      toAdd.forEach(f => {
        const isImage = f.type.startsWith('image/');
        const preview = { type: isImage ? 'image' : 'file', name: f.name, file: f, src: isImage ? URL.createObjectURL(f) : null, uploading: false, progress: 0, error: null, url: null };
        this.previews.push(preview);
      });
      // 顺序上传每个新文件
      const startIdx = this.previews.length - toAdd.length;
      for(let i = 0; i < toAdd.length; i++){
        const idx = startIdx + i;
        this.uploadSingleFile(idx);
      }
    },
    removePreview(idx){
      const p = this.previews[idx];
      if(p && p.src) URL.revokeObjectURL(p.src);
      // 如果已经上传过并存在 attachmentsUrls，则也删除对应 URL（根据 url 精确匹配）
      if(p && p.url){
        this.attachmentsUrls = this.attachmentsUrls.filter(u => u !== p.url);
      }
      this.previews.splice(idx,1);
    },
    clearPreviews() {
      this.previews.forEach(p => {
        if (p && p.src) URL.revokeObjectURL(p.src)
      })
      this.previews = []
    },
    uploadSingleFile(idx){
      const p = this.previews[idx];
      if(!p || !p.file) return;
      p.uploading = true; p.progress = 0; p.error = null;
      const fd = new FormData();
      fd.append('files', p.file);
      const token = localStorage.getItem('token');

      return new Promise((resolve) => {
        const xhr = new XMLHttpRequest();
        xhr.open('POST', '/api/support/upload', true);
        xhr.setRequestHeader('Authorization', `Bearer ${token}`);
        xhr.upload.onprogress = (ev) => {
          if(ev.lengthComputable){
            p.progress = Math.round((ev.loaded / ev.total) * 100);
          }
        };
        xhr.onload = () => {
          try{
            const res = JSON.parse(xhr.responseText || '{}');
            if(xhr.status >=200 && xhr.status < 300 && res.success){
              // backend returns files: [{name, success, url/message}, ...]
              const fileRes = (res.files && res.files[0]) || {};
              if(fileRes.success && fileRes.url){
                p.url = fileRes.url;
                this.attachmentsUrls.push(fileRes.url);
                p.uploading = false; p.progress = 100;
                resolve(fileRes.url);
                return;
              } else {
                p.error = fileRes.message || '上传失败';
              }
            } else {
              p.error = res.message || '上传失败';
            }
          }catch(e){
            p.error = '响应解析失败';
          }
          p.uploading = false;
          resolve(null);
        };
        xhr.onerror = () => { p.error = '网络错误'; p.uploading = false; resolve(null); };
        xhr.send(fd);
      });
    },
    async submitTicket() {
      if (!this.form.subject) {
        alert('请填写标题');
        return;
      }
      if(!this.form.content)
      {
        alert('请填写描述');
        return;
      }
      this.submitting = true;
      try {
        // 在提交工单时附带 attachments 列表
        const payload = Object.assign({}, this.form, { attachments: this.attachmentsUrls });
        const res = await createTicket(payload);
        const data = res.data;
        if (data.success) {
          // 弹窗提示并提供查看
          this.createdTicket = data.data || {}
          this.createSuccessVisible = true
          this.resetForm();
          this.fetchTickets();
        } else {
          alert(data.message || '提交失败');
        }
      } catch (e) {
        console.error('submit ticket failed', e);
        alert(e.response?.data?.message || '提交失败，请稍后重试');
      } finally {
        this.submitting = false;
      }
    },
    async fetchTickets() {
      this.loadingTickets = true;
      try {
        const res = await getTickets();
        const data = res.data;
        if (data.success) {
          this.tickets = data.data || [];
        } else {
          this.tickets = [];
        }
      } catch (e) {
        console.error('fetch tickets failed', e);
        this.tickets = [];
      } finally {
        this.loadingTickets = false;
      }
    },
    async viewDetail(id) {
      try {
        const res = await getTicket(id);
        const data = res.data;
        if (data.success) {
          this.detail = data.data || {};
          // 如果有 attachments，确保是数组
          this.detail.attachments = this.detail.attachments || [];
          this.detailVisible = true;
          // 如果工单处于 resolved，准备显示评分区域（前端直接在模板中根据 detail.status 显示）
        } else {
          alert(data.message || '未能获取详情');
        }
      } catch (e) {
        console.error('fetch detail failed', e);
        alert(e.response?.data?.message || '获取详情失败');
      }
    },
    isImageUrl(url){
      if(!url) return false;
      const lower = url.toLowerCase();
      return lower.endsWith('.png') || lower.endsWith('.jpg') || lower.endsWith('.jpeg') || lower.endsWith('.gif') || lower.endsWith('.webp') || lower.endsWith('.bmp');
    },
    async closeTicket(id) {
      try {
        const res = await updateTicket(id, { status: 'closed' });
        const data = res.data;
        if (data.success) {
          alert('工单已关闭');
          this.detail = data.data || this.detail;
          this.fetchTickets();
          this.detailVisible = false;
        } else {
          alert(data.message || '关闭失败');
        }
      } catch (e) {
        console.error('close ticket failed', e);
        alert(e.response?.data?.message || '关闭失败');
      }
    },
    async submitRating(id, score, comment) {
      try {
        const res = await updateTicket(id, { rating: score, rating_comment: comment });
        const data = res.data;
        if (data.success) {
          alert('感谢您的评价');
          this.detail = data.data || this.detail;
          this.fetchTickets();
          // 如果不满意，前端将展示“重新打开”按钮由用户选择
        } else {
          alert(data.message || '评分提交失败');
        }
      } catch (e) {
        console.error('submit rating failed', e);
        alert(e.response?.data?.message || '评分提交失败');
      }
    },
    async reopenTicket(id) {
      try {
        const res = await updateTicket(id, { status: 'open' });
        const data = res.data;
        if (data.success) {
          alert('工单已重新打开，我们会继续处理');
          this.detail = data.data || this.detail;
          this.fetchTickets();
          this.detailVisible = false;
        } else {
          alert(data.message || '操作失败');
        }
      } catch (e) {
        console.error('reopen failed', e);
        alert(e.response?.data?.message || '操作失败');
      }
    },
    openCreatedTicket() {
      if (this.createdTicket && this.createdTicket.id) {
        this.view = 'list'
        // 打开详情
        this.fetchTickets().then(() => {
          this.viewDetail(this.createdTicket.id)
        })
      }
      this.createSuccessVisible = false
    },
    viewMessageThread(ticketId) {
      // 跳转到ChatDetail界面查看工单消息流
      this.$router.push({
        name: 'MessageDetail',
        params: { id: ticketId },
        query: { type: 'ticket' },
        state: { ticket: this.detail }
      });
      this.detailVisible = false;
    }
  }
}
</script>

<style scoped>
.support-center-layout{display:flex;gap:12px;padding:16px}
.sidebar{width:220px;background:linear-gradient(135deg,#f5f7fa 0%,#fff 100%);border-radius:12px;padding:12px;box-shadow:0 4px 12px rgba(0,0,0,0.08);transition:all .3s cubic-bezier(0.4,0,0.2,1);margin-top:1%;border:1px solid rgba(74,144,226,0.1)}
.sidebar.collapsed{width:64px}
.sidebar .sidebar-header{display:flex;justify-content:space-between;align-items:center;padding:8px 12px;margin-bottom:12px;border-bottom:1px solid rgba(74,144,226,0.1)}
.sidebar .sidebar-title{font-size:14px;font-weight:700;color:#263238;letter-spacing:0.5px}
.sidebar .collapse-btn{width:40px;height:40px;border-radius:50%;background:linear-gradient(135deg,#4a90e2,#9013fe);border:none;color:#fff;box-shadow:0 6px 18px rgba(73,70,150,0.18);display:flex;align-items:center;justify-content:center;font-size:20px;cursor:pointer;transition:all .2s ease;flex-shrink:0}
.sidebar .collapse-btn:hover{transform:scale(1.08);box-shadow:0 8px 24px rgba(73,70,150,0.25)}
.sidebar .collapse-btn:active{transform:scale(0.96)}
.side-nav{display:flex;flex-direction:column;gap:10px;padding:8px}
.side-nav .nav-btn{display:flex;align-items:center;justify-content:center;gap:12px;padding:12px 14px;border-radius:10px;border:1px solid transparent;background:linear-gradient(135deg,rgba(255,255,255,0.6),rgba(255,255,255,0.3));color:#263238;text-align:center;cursor:pointer;font-weight:600;font-size:14px;transition:all .2s ease;position:relative;width:100%;height:48px}
.sidebar.collapsed .nav-btn{padding:0;width:48px;height:48px;gap:0;justify-content:center}
.side-nav .nav-btn:hover{background:linear-gradient(135deg,rgba(74,144,226,0.08),rgba(144,19,254,0.06));transform:translateX(4px);border-color:rgba(74,144,226,0.2)}
.side-nav .nav-btn.active{background:linear-gradient(135deg,#4a90e2,#9013fe);color:#fff;box-shadow:0 6px 16px rgba(73,70,150,0.22);border-color:rgba(255,255,255,0.3)}
.side-nav .nav-btn.active:hover{transform:translateX(2px);box-shadow:0 8px 20px rgba(73,70,150,0.28)}
.nav-icon{width:20px;height:20px;stroke-linecap:round;stroke-linejoin:round;flex-shrink:0}
.nav-label{white-space:nowrap;font-size:14px}
.content{flex:1}
.content .support-header { text-align: center; }
.content .support-header h2.center-title { margin: 0 0 6px; }
.hint { color: #666; font-size: 13px; margin-top:4px }
.create-ticket { background: #fff; padding: 12px; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.04); margin-top: 12px }
.form-row { margin-bottom: 10px }
.form-row label { display:block; font-weight:600; margin-bottom:6px }
.form-row input, .form-row select, .form-row textarea { width:100%; padding:10px; border:1px solid #eee; border-radius:8px }
.form-row textarea { min-height:100px }
.order-select { display:flex; gap:8px }
.order-select input { flex:1 }
.order-select select { width:45% }
.form-actions { display:flex; justify-content:flex-end; gap:8px }
.form-actions { display:flex; justify-content:flex-end; gap:8px }

/* Button system */
.btn { display:inline-flex; align-items:center; justify-content:center; gap:8px; padding:8px 12px; border-radius:10px; border:1px solid transparent; cursor:pointer; font-weight:600; transition:transform .06s ease, box-shadow .08s ease, opacity .12s ease }
.btn:active{ transform:translateY(1px) }
.btn[disabled]{ opacity:.6; cursor:not-allowed }
.btn-primary { background: linear-gradient(45deg,#4a90e2,#9013fe); color:#fff; border-color: rgba(0,0,0,0.04); box-shadow:0 6px 18px rgba(73,70,150,0.08) }
.btn-primary:hover{ filter:brightness(.98) }
.btn-secondary { background: #f7f8fb; color:#263238; border-color:#e6e9ee }
.btn-secondary:hover{ filter:brightness(.99) }
.btn-danger { background:#ff5c5c; color:#fff; border-color: rgba(0,0,0,0.04) }
.btn-danger:hover{ filter:brightness(.98) }

.form-actions .cancel { background:#f0f0f0; border:none; padding:8px 14px; border-radius:8px; cursor:pointer; transition:all .2s ease }
.form-actions .cancel:hover { background:#e8e8e8; transform:translateY(-2px); box-shadow:0 4px 12px rgba(0,0,0,0.08) }
.form-actions .cancel:active { transform:translateY(0) }
.form-actions .submit { background: linear-gradient(45deg,#4a90e2,#9013fe); color:#fff; border:none; padding:8px 14px; border-radius:8px; cursor:pointer; transition:all .2s ease }
.form-actions .submit:hover { filter:brightness(1.05); transform:translateY(-2px); box-shadow:0 6px 16px rgba(73,70,150,0.22) }
.form-actions .submit:active { transform:translateY(0) }
.my-tickets { margin-top:18px }
.ticket-card{display:flex;justify-content:space-between;align-items:flex-start;padding:14px;border-radius:10px;background:#fff;margin-bottom:12px;box-shadow:0 2px 6px rgba(0,0,0,0.04);border:1px solid #f0f0f0}
.ticket-card .card-left{flex:1}
.ticket-card .card-right{display:flex;flex-direction:column;align-items:flex-end;gap:8px}
.ticket-card .num{font-size:12px;color:#999}
.ticket-card .subject{font-weight:700;margin-top:6px}
.ticket-card .meta{font-size:12px;color:#888;margin-top:8px}
.badges{margin-top:8px;display:flex;gap:8px;align-items:center}
.badge{display:inline-block;padding:6px 8px;border-radius:14px;font-size:12px;color:#fff}
.badge-open{background:#4a90e2}
.badge-in_process{background:#f5a623}
.badge-resolved{background:#7ed321}
.badge-closed{background:#9b9b9b}
.badge-order_issue{background:#2d9cdb}
.badge-refund{background:#d64545}
.badge-general{background:#6b7280}
.badge-other{background:#8b5cf6}
.actions{display:flex;flex-direction:column;gap:8px;align-items:flex-end}
.detail-btn{background:linear-gradient(45deg,#4a90e2,#9013fe);color:#fff;border:none;padding:8px 12px;border-radius:8px;cursor:pointer}
.detail-btn:hover{transform:translateY(-2px)}
.order-link{font-size:13px;color:#4a90e2}
.modal-overlay { position:fixed; inset:0; background:rgba(0,0,0,0.4); display:flex; justify-content:center; align-items:center }
.modal-content { background:#fff; padding:16px; border-radius:10px; width:90%; max-width:520px }
.modal-actions { text-align:right; margin-top:12px }
.desc { white-space:pre-wrap }
.attachments-preview{display:flex;gap:8px;flex-wrap:wrap;margin-top:8px}
.preview-item{width:92px;height:92px;border:1px solid #eee;border-radius:8px;display:flex;flex-direction:column;align-items:center;justify-content:center;position:relative;padding:6px}
.preview-item img{max-width:100%;max-height:100%;object-fit:cover;border-radius:6px}
.preview-item .file-placeholder{font-size:12px;color:#444;text-align:center}
.preview-item .remove{position:absolute;top:4px;right:4px;border:none;background:#ff6b6b;color:#fff;border-radius:4px;padding:2px 6px;font-size:12px}
.header-title {
  font-size: 18px;
  font-weight: 600;
}

.header-icons {
  display: flex;
  gap: 16px;
}
.back-btn {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 20px;
  background-color: #f0f0f0;
}
.header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: 40px;
  background-color: white;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 16px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  z-index: 1000;
}

</style>
