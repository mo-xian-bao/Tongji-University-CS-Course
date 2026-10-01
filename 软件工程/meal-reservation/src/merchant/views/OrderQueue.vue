<template>
  <div>
    <h2>订单管理</h2>
    <div class="card">
      <h3>实时订单队列</h3>
      <div class="scrollable-content">
        <table class="table">
          <thead>
            <tr>
              <th>订单号</th>
              <th>顾客</th>
              <th>人数</th>
              <th>时间</th>
              <th>类型</th>
              <th>状态</th>
              <th>操作</th>
            </tr>
          </thead>
          <template v-for="o in orders" :key="o.id">
            <tr>
              <td>{{ o.id }}</td>
              <td>{{ o.customer }}</td>
              <td>{{ o.customerCount }}人</td>
              <td>{{ o.time }}</td>
              <td>
                <span class="order-type-tag" :class="'type-' + o.orderType">{{ o.type }}</span>
                <span v-if="o.reservationStatus && o.reservationStatus !== 'none'" class="reservation-tag">
                  📅 预约
                </span>
              </td>
              <td>
                <span class="status-tag" :class="'status-' + o.rawStatus">{{ o.status }}</span>
                <span v-if="o.reservationStatus && o.reservationStatus !== 'none'" 
                      class="reservation-status-tag" 
                      :class="'res-' + o.reservationStatus">
                  {{ getReservationStatusText(o.reservationStatus) }}
                </span>
              </td>
              <td>
                <!-- 既有按钮 -->
                <button 
                  class="btn" 
                  @click="accept(o)" 
                  :disabled="o.status !== '新订单'">
                  接单
                </button>
                <button 
                  class="btn-danger" 
                  @click="reject(o)" 
                  :disabled="o.status !== '新订单'">
                  拒绝
                </button>
                <button class="btn-secondary" @click="toggleDetails(o)">
                  {{ o.showDetails ? '收起' : '详情' }}
                </button>
                <button
                  v-if="o.rawStatus === 'confirmed'"
                  class="action-btn action-btn--primary"
                  :disabled="isServing || o.rawStatus !== 'confirmed'"
                  @click="serveOrder(o)"
                >
                  出餐
                </button>
                <button
                  v-if="o.rawStatus === 'dining' && o.isDineIn"
                  class="action-btn action-btn--outline"
                  :disabled="isReleasing || o.rawStatus !== 'dining'"
                  @click="releaseSeat(o)"
                >
                  释放座位
                </button>
              </td>
            </tr>
            <tr v-if="o.showDetails" class="details-row">
              <td colspan="7">
                <div class="details-content">
                  <h4>订单详情 ({{ o.id }})</h4>
                  <p><strong>菜品列表:</strong> {{ o.items.join(', ') }}</p>
                  <p><strong>顾客备注:</strong> {{ o.note || '无' }}</p>
                  <p v-if="o.coupon"><strong>使用优惠券:</strong> {{ o.coupon.title }} (优惠 ¥{{ o.discountAmount }})</p>
                  <p v-if="o.originalPrice && o.originalPrice !== o.totalPrice">
                    <strong>价格明细:</strong> 原价 ¥{{ o.originalPrice }} - 优惠 ¥{{ o.discountAmount }} = 实付 ¥{{ o.totalPrice }}
                  </p>
                  <!-- 预约信息 -->
                  <div v-if="o.reservationStatus && o.reservationStatus !== 'none'" class="reservation-info">
                    <p><strong>📅 预约信息:</strong></p>
                    <p>预约到店时间: {{ formatReservationTime(o.reservedTime) }}</p>
                    <p>预计结束时间: {{ formatReservationTime(o.reservedEndTime) }}</p>
                    <p>预约状态: 
                      <span :class="'reservation-status-' + o.reservationStatus">
                        {{ getReservationStatusText(o.reservationStatus) }}
                      </span>
                    </p>
                    <!-- 预约操作按钮（接单时自动确认，这里只保留入座和未到店操作） -->
                    <div class="reservation-actions">
                      <button 
                        v-if="o.reservationStatus === 'confirmed'"
                        class="btn reservation-btn"
                        @click="markSeated(o)"
                      >
                        🪑 客人已入座
                      </button>
                      <button 
                        v-if="o.reservationStatus === 'confirmed'"
                        class="btn-danger reservation-btn"
                        @click="markNoShow(o)"
                      >
                        ❌ 未到店
                      </button>
                      <button 
                        v-if="o.reservationStatus === 'pending'"
                        class="btn-danger reservation-btn"
                        @click="cancelReservation(o)"
                      >
                        取消预约
                      </button>
                    </div>
                  </div>
                </div>
              </td>
            </tr>
          </template>
        </table>
      </div>
    </div>

    <!-- 替换后：消息窗口（左侧为所有订单，按规则排序；右侧为消息与申请处理） -->
    <div class="card">
      <h3>消息 & 申请处理</h3>
      <div class="requests-chat">
        <!-- 左侧：所有订单（优先：有申请 -> 有新消息 -> 其他按时间） -->
        <aside class="requests-list">
          <div v-if="loading" class="empty-hint">加载中...</div>
          <ul v-else class="request-items">
            <li v-for="item in combinedList" :key="item.orderId" :class="{ active: selectedLeft && selectedLeft.orderId === item.orderId }" @click="selectLeftItem(item)">
              <div style="display:flex;justify-content:space-between;align-items:center;">
                <div>
                  <div style="font-weight:600;">{{ item.id }}</div>
                  <div style="font-size:12px;color:#666;">{{ item.customer }} · {{ item.time }}</div>
                </div>
                <div style="text-align:right">
                  <span v-if="item.hasRequest" class="status-pill status-pill--pending" style="margin-bottom:6px;">申请</span>
                  <div v-if="item.hasNew" style="background:#ff4d4f;color:#fff;padding:2px 6px;border-radius:12px;font-size:12px;margin-top:6px;">新消息</div>
                </div>
              </div>
            </li>
          </ul>
        </aside>

        <!-- 右侧：消息与审批区（根据 selectedLeft 或 selectedRequest 展示） -->
        <section class="chat-panel" v-if="selectedLeft || selectedRequest">
          <header class="chat-panel-header">
  <div>
    <!-- 标题显示逻辑 -->
    <h4 v-if="selectedRequest && selectedRequest.id">
      申请 #{{ selectedRequest.id }} · 订单 {{ selectedRequest.order_number || selectedLeft.id || '-' }}
    </h4>
    <h4 v-else-if="selectedLeft">
      订单 {{ selectedLeft.id }}
    </h4>
    
    <!-- 副标题 -->
    <p class="muted" v-if="selectedRequest">
      {{ selectedRequest.request_type === 'cancel' ? '取消申请' : '修改申请' }}
      <span :class="['status-pill', 'status-pill--' + (selectedRequest.status || 'pending').toLowerCase()]">
        {{ requestStatusText(selectedRequest.status) }}
      </span>
    </p>
  </div>

  <div class="chat-actions" v-if="selectedRequest && selectedRequest.id">
  <!-- 1. 待处理状态：显示操作按钮 -->
  <template v-if="isPending(selectedRequest)">
    <button 
      class="action-btn action-btn--primary" 
      @click="handleChangeRequest(selectedRequest, 'approved')"
    >
      同意
    </button>
    <button 
      class="action-btn action-btn--outline" 
      @click="handleChangeRequest(selectedRequest, 'rejected')"
    >
      拒绝
    </button>
  </template>

  <!-- 2. 已同意状态 -->
  <span v-else-if="isApproved(selectedRequest)" class="processed-text success">
    ✅ 已同意
  </span>

  <!-- 3. 已拒绝状态 -->
  <span v-else-if="isRejected(selectedRequest)" class="processed-text danger">
    ❌ 已拒绝
  </span>
  
  <!-- 4. 其他状态 (如已撤回 withdrawn, 已取消 cancelled) -->
  <span v-else class="processed-text muted">
    {{ requestStatusText(selectedRequest.status) }}
  </span>
</div>
</header>

          <main class="chat-panel-body">
  <div class="messages">
  <div
    v-for="(m, idx) in messages"
    :key="idx"
    :class="['msg-row', m.from === 'me' ? 'me' : 'them']"
  >
    <!-- 头像 -->
    <img class="avatar" :src="m.avatar" alt="avatar" @error="$event.target.src = defaultAvatar" />

    <!-- 1. 特殊 Action 消息 (修改/取消/申请) -->
    <div 
      v-if="m.type === 'action'" 
      class="action-bubble"
      :class="getActionTheme(m.actionType)"
    >
      <!-- ... 这里保持之前的 Action 卡片代码不变 ... -->
       <div class="action-header">
          <span class="action-icon">{{ getActionIcon(m.actionType) }}</span>
          <span class="action-title-text">{{ m.title }}</span>
        </div>
        <!-- 简略... Action 内容 ... -->
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
          
          <!-- 场景3：取消类（成功或申请） -->
          <div v-if="m.actionType.includes('cancel')" class="simple-reason">
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

    <!-- 2. 普通文本消息 (修复点：使用 v-else 兜底，只要不是 action 都显示文本) -->
    <div v-else class="bubble">{{ m.text }}</div>
  </div>
</div>
</main>

          <footer class="chat-panel-footer">
            <input v-model="inputText" @keydown.enter="sendMessage" placeholder="回复客户／写处理意见..." />
            <button class="btn--primary" @click="sendMessage">发送</button>
          </footer>
        </section>

        <section class="chat-panel empty" v-else>
          <div class="empty-hint">请选择左侧订单以查看消息与处理</div>
        </section>
      </div>
    </div>
    
    <!-- 拒单弹窗：之前 methods/样式都在，但模板缺失 -->
    <div v-if="showRejectModal" class="modal-backdrop" @click.self="cancelReject">
      <div class="modal" role="dialog" aria-modal="true" aria-label="拒绝接单">
        <h3>拒绝接单</h3>
        <p v-if="currentOrder" style="margin: 6px 0 14px; color:#666; font-size:13px;">
          订单：{{ currentOrder.id }} · {{ currentOrder.customer }}
        </p>

        <div class="form-group">
          <label>请选择拒绝理由</label>
          <select v-model="rejectReason">
            <option value="" disabled>请选择…</option>
            <option value="菜品已售罄">菜品已售罄</option>
            <option value="店铺已打烊">店铺已打烊</option>
            <option value="排队过多">排队过多</option>
            <option value="备注无法满足">备注无法满足</option>
            <option value="其他">其他</option>
          </select>
        </div>

        <div class="form-group" v-if="rejectReason === '备注无法满足' || rejectReason === '其他'">
          <label>补充说明</label>
          <textarea v-model="customReason" rows="3" placeholder="请填写具体原因…"></textarea>
        </div>

        <div class="modal-actions">
          <button class="btn-secondary" @click="cancelReject">取消</button>
          <button class="btn-danger" @click="confirmReject">确认拒绝</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { getMerchantOrders, getChangeRequests, handleChangeRequest, acceptOrder, rejectOrder, serveOrder, releaseSeat, updateReservationStatus } from '@/api/merchant'
import { getRestaurant } from '@/api/shops'
import { getMessages, sendMessage } from '@/api/orders'
import { getUserById } from '@/api/user'

export default {
   data() {
  return {
    avatarBasePath: '/static/uploads/avatar/',
    // 列表与状态
    orders: [],
    changeRequests: [],
    requestLoading: false,
    loading: false,

    // 拒绝模态相关
    showRejectModal: false,
    currentOrder: null,
    rejectReason: '',
    customReason: '',

    // 左侧/右侧选择与消息
    selectedLeft: null,
    selectedRequest: null,
    messages: [],
    inputText: '',

    // 头像占位，确保指向后端 static（与 Profile.vue 一致）
    defaultAvatar: `${API_url}/static/default/avatar.png`,
    // 缓存当前商家/用户头像
    myAvatar: null,
    merchantAvatar: null,
    // 映射 sender_id -> user/profile 映射
    profileMap: {},
    lastMessageId: 0, 
    readStatus: JSON.parse(localStorage.getItem('merchant_message_read_status') || '{}'),
    hasNewStatus: JSON.parse(localStorage.getItem('merchant_message_hasnew_status') || '{}'),
    orderActivityMap: JSON.parse(localStorage.getItem('merchant_order_activity_map') || '{}'),

    // 新增：餐厅信息
    restaurantId: null,
    restaurantAvatar: null,
    restaurantUserId: null,
  }
},
   computed: {
     combinedList() {
       const orders = this.orders || []
       const reqs = this.changeRequests || []
       const orderMap = new Map(orders.map(o => [o.orderId, o]))
       
       // 1. 筛选待处理申请
       const pendingReqs = reqs.filter(r => (r.status || '').toLowerCase() === 'pending');
       const reqOrderIds = [...new Set(pendingReqs.map(r => r.order_id).filter(Boolean))]

       // --- 第一梯队：申请中 ---
       const reqOrders = reqOrderIds
         .map(id => orderMap.get(id))
         .filter(Boolean)
         .sort((a, b) => b.lastActivityTime - a.lastActivityTime) // 内部也按活跃时间排
         .map(o => ({ ...o, hasRequest: true }))

       // --- 第二梯队：有新消息 ---
       const newMsgOrders = orders
         .filter(o => o.hasNew && !reqOrderIds.includes(o.orderId))
         .sort((a, b) => b.lastActivityTime - a.lastActivityTime) // 内部按活跃时间排
         .map(o => ({ ...o, hasRequest: false }))

       // --- 第三梯队：普通订单 (按最后活跃时间排序) ---
       const excluded = new Set([...reqOrders, ...newMsgOrders].map(i => i.orderId))
       const others = orders
         .filter(o => !excluded.has(o.orderId))
         // 【关键修改】：按 lastActivityTime 倒序，而不是创建时间
         .sort((a, b) => b.lastActivityTime - a.lastActivityTime)
         .map(o => ({ ...o, hasRequest: false }))

       return [...reqOrders, ...newMsgOrders, ...others]
     }
   },
   mounted() {
     this.fetchOrders() // fetchOrders 内部会自动调用 checkNewMessages
     this.fetchChangeRequests()
     
     this._timer = setInterval(() => {
       this.fetchOrders()
       this.fetchChangeRequests()
       // 不需要单独调用 checkNewMessages，因为它已被串联在 fetchOrders 之后
     }, 30000)
   },
   beforeUnmount() {
     if (this._timer) {
       clearInterval(this._timer);
     }
   },
   methods: {
    // 【修复】辅助函数放在 methods 内部
    isPending(req) {
      return req && (req.status || '').toLowerCase() === 'pending';
    },
    isApproved(req) {
      return req && (req.status || '').toLowerCase() === 'approved';
    },
    isRejected(req) {
      return req && (req.status || '').toLowerCase() === 'rejected';
    },

     async fetchOrders() {
       try {
         this.loading = true;

         const token = localStorage.getItem('token');
         if (!token) {
           alert('请先登录');
           this.$router.push('/login');
           return;
         }

         const response = await getMerchantOrders();

         const result = response.data;

         if (result.success) {
           const dineInTypes = ['dinein', 'dine_in', 'dine-in']
           
           const oldStatusMap = {};
           this.orders.forEach(o => { oldStatusMap[o.orderId] = o.hasNew; });

           this.orders = result.data.map(order => {
             const isDineIn = dineInTypes.includes(order.order_type)
             const createTime = new Date(order.order_time).getTime();
             
             // 【关键修改】：初始化 lastActivityTime
             // 如果内存里有记录（比如刚聊过天），用记录的；否则用订单创建时间
             const activityTime = this.orderActivityMap[order.id] || createTime;

             return {
               // ... 基础字段 ...
               id: order.order_number,
               orderId: order.id,
               customer: order.customer_name,
               phone: order.customer_phone,
               customerCount: order.customer_count || 1,
               items: order.items.map(item => `${item.dish_name} x${item.quantity}`),
               time: new Date(order.order_time).toLocaleString('zh-CN', { hour12: false }), // 仅作展示用
               
               // 排序用的字段
               timestamp: createTime, 
               lastActivityTime: activityTime, // <--- 新增
               
               type: isDineIn ? '堂食' : '打包',
               orderType: order.order_type,
               isDineIn,
               status: this.getStatusText(order.status),
               note: order.note || '',
               showDetails: false,
               rawStatus: order.status,
               hasNew: oldStatusMap[order.id] || false, 
               customerId: order.user_id, // 假设后端返回 customer_id
               restaurantId: order.restaurant_id, // 新增：假设后端返回 restaurant_id
               
               // 优惠券相关字段
               totalPrice: order.total_price,
               originalPrice: order.original_price || order.total_price,
               discountAmount: order.discount_amount || 0,
               coupon: order.coupon,
               
               // 预约相关字段
               reservedTime: order.reserved_time,
               reservedEndTime: order.reserved_end_time,
               reservationStatus: order.reservation_status
             }
           })

           // 新增：从订单获取 restaurant_id 并加载餐厅信息
      if (this.orders.length > 0 && this.orders[0].restaurantId) {
        this.restaurantId = this.orders[0].restaurantId;
        await this.loadRestaurant(this.orders[0].restaurantId);
      }

           this.checkNewMessages();

         } else {
           alert(result.message || '获取订单列表失败');
         }

       } catch (error) {
         console.error("获取订单数据失败:", error);
       } finally {
         this.loading = false;
       }
     },

     async fetchChangeRequests() {
       try {
         this.requestLoading = true
         const token = localStorage.getItem('token')
         if (!token) return
         const resp = await getChangeRequests()
         const result = resp.data
         if (!result.success) throw new Error(result.message || '获取申请失败')
         this.changeRequests = (result.data || []).map(req => ({
           ...req,
           created_at: req.created_at,
           order_id: req.order_id || req.orderId || null,
           order_number: req.order_number || req.order_number || null,
           showDetails: false
         }))
       } catch (error) {
         console.error('获取申请失败:', error)
       } finally {
         this.requestLoading = false
       }
     },
     requestTypeText(type) {
       return type === 'cancel' ? '取消订单' : '修改订单'
     },
     requestStatusText(status) {
       const map = { pending: '待处理', approved: '已同意', rejected: '已拒绝', withdrawn: '已撤回' }
       return map[status] || status
     },
     formatDate(value) {
       if (!value) return '-'
       return new Date(value).toLocaleString('zh-CN', { hour12: false })
     },

     toggleRequestDetails(request) {
       request.showDetails = !request.showDetails;
     },

     getDishName(dishId, originalItems) {
       if (!originalItems) return `菜品ID: ${dishId}`;
       const originalItem = originalItems.find(item => item.dish_id === dishId);
       return originalItem ? originalItem.dish_name : `菜品ID: ${dishId}`;
     },

     async handleChangeRequest(request, action) {
       if (this.handlingRequestId) return
       
       let note = ''
       if (action === 'rejected') {
         const input = window.prompt('请输入拒绝说明：', '')
         if (input === null) return 
         note = input.trim() || '商家由于运营原因无法满足需求'
       } else {
         note = '商家已同意您的申请'
       }

       try {
         this.handlingRequestId = request.id

         const resp = await handleChangeRequest(request.id, { status: action, note })
         const result = resp.data

         if (!result.success) throw new Error(result.message || '操作失败')

         // 【修复】代码逻辑补全
         request.status = action;
         
         if (this.selectedRequest && this.selectedRequest.id === request.id) {
             this.selectedRequest.status = action;
             // 强制 Vue 响应式更新
             this.selectedRequest = { ...this.selectedRequest };
         }

         const targetIdx = this.changeRequests.findIndex(r => r.id === request.id);
         if (targetIdx !== -1) {
             this.changeRequests[targetIdx].status = action;
             if (this.$set) {
                 this.$set(this.changeRequests, targetIdx, this.changeRequests[targetIdx]);
             }
         }
         
         // 移除已处理的申请（使其变为普通订单）
         this.changeRequests = this.changeRequests.filter(r => r.id !== request.id);

         this.$forceUpdate();

         let actionType = ''
        let title = ''
        let contentPayload = {}

        if (request.request_type === 'modify') {
           if (action === 'approved') {
               actionType = 'modify_success'
               title = '修改已通过'
               contentPayload = {
                   beforeItems: request.original_order_details?.items || [],
                   beforeNote: request.original_order_details?.note || '',
                   afterItems: request.payload.items || [],
                   afterNote: request.payload.note || '',
                   status: '修改成功'
               }
           } else {
               actionType = 'modify_reject'
               title = '修改被拒绝'
               contentPayload = { reason: note, status: '已拒绝' }
           }
        } else if (request.request_type === 'cancel') {
            if (action === 'approved') {
                actionType = 'cancel_success'
                title = '同意取消'
                contentPayload = { reason: request.reason || '用户申请取消', status: '订单已取消' }
            } else {
                actionType = 'cancel_reject'
                title = '拒绝取消'
                contentPayload = { reason: note, status: '商家拒绝取消' }
            }
        }

        await this.sendActionMessage(request.order_id, actionType, title, contentPayload)

        this.fetchChangeRequests() 
        
        if (this.selectedLeft && this.selectedLeft.orderId === request.order_id) {
            this.selectLeftItem(this.selectedLeft, true)
         }

       } catch (error) {
         console.error('处理申请失败:', error)
         alert(error.response?.data?.message || error.message)
       } finally {
         this.handlingRequestId = null
       }
    },
     
     // 状态文本转换
     getStatusText(status) {
       const statusMap = {
         pending: '新订单',
         confirmed: '已接单',
         dining: '用餐中',
         completed: '已完成',
         rejected: '已拒绝',
         cancelled: '已取消'
       };
       return statusMap[status] || status;
     },
     
     // 预约状态文本转换
     getReservationStatusText(status) {
       const statusMap = {
         none: '非预约',
         pending: '待确认',
         confirmed: '已确认',
         seated: '已入座',
         completed: '已完成',
         cancelled: '已取消',
         no_show: '未到店'
       };
       return statusMap[status] || status;
     },
     
     // 格式化预约时间
     formatReservationTime(timeStr) {
       if (!timeStr) return '-';
       const date = new Date(timeStr);
       return date.toLocaleString('zh-CN', { 
         month: '2-digit', 
         day: '2-digit', 
         hour: '2-digit', 
         minute: '2-digit',
         hour12: false 
       });
     },
     
     // 确认预约
     async confirmReservation(order) {
       if (!confirm('确认接受该预约吗？')) return;
       try {
         const response = await updateReservationStatus(order.orderId, 'confirmed');
         if (response.data.success) {
           alert('预约已确认');
           this.fetchOrders();
         } else {
           alert(response.data.message || '操作失败');
         }
        } catch (error) {
          console.error('确认预约失败:', error);
          alert(error.response?.data?.message || '操作失败，请稍后重试');
        }
     },

     // 标记客人已入座
     async markSeated(order) {
       if (!confirm('确认客人已入座吗？')) return;
       try {
         const response = await updateReservationStatus(order.orderId, 'seated');
         if (response.data.success) {
           alert('已标记入座');
           this.fetchOrders();
         } else {
           alert(response.data.message || '操作失败');
         }
        } catch (error) {
          console.error('标记入座失败:', error);
          alert(error.response?.data?.message || '操作失败，请稍后重试');
        }
     },

     // 标记未到店
     async markNoShow(order) {
       if (!confirm('确认客人未到店吗？这将取消该预约。')) return;
       try {
         const response = await updateReservationStatus(order.orderId, 'no_show');
         if (response.data.success) {
           alert('已标记未到店');
           this.fetchOrders();
         } else {
           alert(response.data.message || '操作失败');
         }
        } catch (error) {
          console.error('标记未到店失败:', error);
          alert(error.response?.data?.message || '操作失败，请稍后重试');
        }
     },

     // 取消预约
     async cancelReservation(order) {
       const reason = prompt('请输入取消原因：');
       if (reason === null) return;
       try {
         const response = await updateReservationStatus(order.orderId, 'cancelled');
         if (response.data.success) {
           alert('预约已取消');
           this.fetchOrders();
         } else {
           alert(response.data.message || '操作失败');
         }
        } catch (error) {
          console.error('取消预约失败:', error);
          alert(error.response?.data?.message || '操作失败，请稍后重试');
        }
     },
     
     // 接单（同时处理预约确认）
     async accept(order) {
       try {
         const response = await acceptOrder(order.orderId);
         const result = response.data;
         if (result.success) {
           // 如果是预约订单，接单时同时确认预约
           if (order.reservationStatus === 'pending') {
             await this.confirmReservationSilent(order);
             alert(`已接单并确认预约: ${order.id}\n取单号: ${result.data.pickup_number}`);
           } else {
             alert(`已接单: ${order.id}\n取单号: ${result.data.pickup_number}`);
           }
           this.fetchOrders();
         } else {
           alert(result.message || '接单失败');
         }
        } catch (error) {
          console.error("接单失败:", error);
          alert(error.response?.data?.message || "接单操作失败，请稍后重试。");
        }
     },

     // 静默确认预约（接单时自动调用）
     async confirmReservationSilent(order) {
       try {
         await updateReservationStatus(order.orderId, 'confirmed');
       } catch (error) {
         console.error('自动确认预约失败:', error);
       }
     },
     
     // 拒绝订单
     reject(order) {
       this.currentOrder = order;
       this.rejectReason = '';
       this.customReason = '';
       this.showRejectModal = true;
     },
     
     async confirmReject() {
       if (!this.rejectReason) { alert('请选择一个拒绝理由！'); return; }
       let finalReason = this.rejectReason;
       if (this.rejectReason === '备注无法满足' || this.rejectReason === '其他') {
         if (!this.customReason) { alert('请填写具体信息！'); return; }
         finalReason += `: ${this.customReason}`;
       }
       try {
         const response = await rejectOrder(this.currentOrder.orderId, finalReason);
         const result = response.data;
         if (result.success) {
           alert(`订单 ${this.currentOrder.id} 已被拒绝。\n理由: ${finalReason}`);
           this.fetchOrders();
           this.cancelReject();
         } else {
           alert(result.message || '拒单失败');
         }
        } catch (error) {
          console.error("拒单失败:", error);
          alert(error.response?.data?.message || "拒单操作失败，请稍后重试。");
        }
     },

     cancelReject() {
       this.showRejectModal = false;
       this.currentOrder = null;
       this.rejectReason = '';
       this.customReason = '';
     },


     async serveOrder(order) {
  try {
    const newStatus = order.isDineIn ? 'dining' : 'completed'; // 堂食 -> 用餐中，打包 -> 已完成
    const response = await serveOrder(order.orderId, newStatus);
    const result = response.data;
    if (result.success) {
      alert(`出餐成功: ${order.id}`);
      this.fetchOrders();
    } else {
      alert(result.message || '出餐失败');
    }
  } catch (error) {
    console.error("出餐失败:", error);
    alert(error.response?.data?.message || "出餐操作失败，请稍后重试。");
  }
},


// 释放座位
async releaseSeat(order) {
  try {
    const response = await releaseSeat(order.orderId);
    const result = response.data;
    if (result.success) {
      alert(`座位释放成功: ${order.id}`);
      this.fetchOrders();
    } else {
      alert(result.message || '释放座位失败');
    }
  } catch (error) {
    console.error("释放座位失败:", error);
    alert(error.response?.data?.message || "释放座位操作失败，请稍后重试。");
  }
},


     getActionTheme(actionType) {
      if (!actionType) return 'theme-info'
      if (actionType.includes('success') || actionType === 'approved') return 'theme-success'
      if (actionType.includes('request') || actionType === 'pending') return 'theme-warning'
      if (actionType.includes('reject') || actionType.includes('cancel')) return 'theme-danger'
      return 'theme-info'
    },
    getActionIcon(actionType) {
      if (!actionType) return '📝'
      if (actionType.includes('success')) return '✅'
      if (actionType.includes('request')) return '⏳'
      if (actionType.includes('reject')) return '❌'
      return '📝'
    },
     toggleDetails(order) {
       order.showDetails = !order.showDetails;
     },

    // 统一左侧项点击

async selectLeftItem(item, forceRefresh = false) {
      // 只有切换了项目，或者强制刷新时才重置状态
      if (!forceRefresh && this.selectedLeft && this.selectedLeft.orderId === item.orderId) return;

      this.selectedLeft = item;
      
      // =======================================================
      // 【关键修复 1】：点击即消除红点 (无论消息加载是否成功)
      // =======================================================
      item.hasNew = false; // 视图立即更新
      
      // 更新源数据
      const originalOrder = this.orders.find(o => o.orderId === item.orderId);
      if (originalOrder) originalOrder.hasNew = false;
      
      // 立即持久化“无新消息”状态
      if (this.$set) this.$set(this.hasNewStatus, item.orderId, false);
      else this.hasNewStatus[item.orderId] = false;
      localStorage.setItem('merchant_message_hasnew_status', JSON.stringify(this.hasNewStatus));
      // =======================================================

      // --- 申请单匹配逻辑 ---
      const allRequests = this.changeRequests || [];
      const relatedRequests = allRequests.filter(r => r.order_id == item.orderId);
      
      if (relatedRequests.length > 0) {
        // 排序：时间倒序，ID倒序
        relatedRequests.sort((a, b) => {
          const timeA = new Date(a.created_at || 0).getTime();
          const timeB = new Date(b.created_at || 0).getTime();
          if (timeB !== timeA) return timeB - timeA;
          return b.id - a.id;
        });
        this.selectedRequest = relatedRequests[0]; 
      } else {
        this.selectedRequest = null;
      }

      // --- 拉取消息逻辑 ---

      try {
        const resp = await getMessages({ order_id: item.orderId });
        const result = resp.data;
        
        if (result.success) {
          const senderIds = result.data.map(m => m.sender_id).filter(Boolean);
          
          // 新增：从订单获取顾客ID 并预加载头像（假设后端返回 customer_id）
          const customerId = item.customerId || null; // 假设订单有 customerId 字段
          if (customerId) {
            await this.fetchProfilesByIds([customerId, ...senderIds]);
          } else {
            await this.fetchProfilesByIds(senderIds);
          }

          // 获取当前登录用户ID
          const currentUserId = localStorage.getItem('userId');

          this.messages = result.data.map(m => {
            // 修复：增加 sender_id 校验，防止其他商家作为用户下单时消息显示在右侧
            // 只有当 sender_type 为 merchant 且 sender_id 等于当前用户时，才认为是“我”
            const isMe = m.sender_type === 'merchant' && m.sender_id == currentUserId; 
            
            let rawAvatar = null;
            if (isMe) {
               rawAvatar = this.restaurantAvatar; // 商家头像从餐厅获取
            } else {
               rawAvatar = this.profileMap[m.sender_id]?.avatar_url; // 顾客头像从 profileMap 获取
            }

            const msgObj = {
              from: isMe ? 'me' : 'them',
              text: m.text,
              time: new Date(m.created_at).toLocaleTimeString(),
              avatar: this.normalizeAvatar(rawAvatar),
              type: m.message_type || 'message',
              actionType: null, title: null, content: null,
              id: m.id
            };

            if (m.message_type === 'action') {
              try {
                const content = typeof m.text === 'string' ? JSON.parse(m.text) : m.text;
                msgObj.actionType = content.actionType;
                msgObj.title = content.title;
                msgObj.content = content.content;
              } catch (e) {
                msgObj.type = 'message';
              }
            }
            return msgObj;
          });
          
          // =======================================================
          // =======================================================
          if (this.messages.length > 0) {
              const maxId = Math.max(...this.messages.map(m => parseInt(m.id) || 0));
              
              // 1. 获取最新消息的时间
              const lastMsg = this.messages[this.messages.length - 1]; // 假设后端按时间升序返回
              // 如果后端是降序，取 index 0。通常聊天记录是按时间升序（旧->新）
              const lastMsgTime = new Date(lastMsg.timestamp || lastMsg.time).getTime(); // 注意这里要看你 map 里的字段是 time 还是 timestamp
              // 为了保险，建议 map 的时候保留原始 m.created_at
              const rawLastMsgTime = new Date(result.data[result.data.length - 1].created_at).getTime();

              // 2. 更新 item 的 lastActivityTime
              // 这样它就会排在 "第三梯队" 的第一个，而不是掉到底部
              if (rawLastMsgTime > item.lastActivityTime) {
                  item.lastActivityTime = rawLastMsgTime;
                  if (originalOrder) originalOrder.lastActivityTime = rawLastMsgTime;
                  this.updateActivityTime(item.orderId, rawLastMsgTime);
              }
              
              // 3. 更新已读状态 (代码不变)
              if (this.$set) this.$set(this.readStatus, item.orderId, maxId);
              else this.readStatus[item.orderId] = maxId;
              localStorage.setItem('merchant_message_read_status', JSON.stringify(this.readStatus));
          }
          // =======================================================
          
          this.$nextTick(() => {
            const container = this.$el.querySelector('.chat-panel-body');
            if(container) container.scrollTop = container.scrollHeight;
          });
        }
      } catch (e) {
        console.error('Fetch messages error', e);
      }
    },

     async sendMessage() {
       if (!this.inputText.trim()) return
       const text = this.inputText.trim()
       try {
         const payload = this.selectedRequest && this.selectedRequest.id
           ? { request_id: this.selectedRequest.id, text }
           : (this.selectedLeft ? { order_id: this.selectedLeft.orderId, text } : null)
         if (!payload) return
         const resp = await sendMessage(payload)
         const result = resp.data
         if (result.success) {
           const sentAvatar = result.data && (result.data.avatar || result.data.avatar_url) ? (result.data.avatar || result.data.avatar_url) : null
           this.messages.push({
             from: 'me',
             text: result.data.text,
             time: new Date(result.data.created_at).toLocaleTimeString(),
             avatar: this.normalizeAvatar(sentAvatar),
             type: 'message'
           })
           this.inputText = ''
           if (this.selectedLeft) this.selectedLeft.hasNew = false

           const now = new Date().getTime();
           if (this.selectedLeft) {
               this.selectedLeft.lastActivityTime = now;
               const original = this.orders.find(o => o.orderId === this.selectedLeft.orderId);
               if (original) original.lastActivityTime = now;
               this.updateActivityTime(this.selectedLeft.orderId, now);
           }
         } else {
           throw new Error(result.message || '发送失败')
         }
       } catch (e) {
         console.error('send message error', e)
         alert(e.response?.data?.message || '发送失败')
       }
     },
     async sendActionMessage(orderId, actionType, title, content) {
      try {
        const payload = {
          order_id: orderId,
          message_type: 'action',
          text: JSON.stringify({ actionType, title, content })
        }
        await sendMessage(payload)
      } catch (e) {
        console.error('发送 Action 消消息失败', e)
      }
    },
//      async fetchMyProfile() {
//   try {
//     const token = localStorage.getItem('token')
//     if (!token) return
//     const resp = await fetch('/api/users/profile', { headers: { Authorization: `Bearer ${token}` }})
//     const data = await resp.json()
//     if (resp.ok && data.success) {
//       const u = data.data?.user || data.user || data.data
//       if (u) {
//         // 移除：不再获取头像（商家头像从餐厅获取）
//         // 新增：获取 restaurant_id 并加载餐厅信息
//         if (u.restaurant && u.restaurant.id) {
//           this.restaurantId = u.restaurant.id
//           await this.loadRestaurant(u.restaurant.id)
//         }
//         if (u.id) localStorage.setItem('userId', u.id)
//         if (u.usertype) localStorage.setItem('userType', u.usertype)
//       }
//     }
//   } catch (e) {
//     console.error('fetchMyProfile error', e)
//   }
// },
  async   loadRestaurant(restaurantId) {
  try {
    const resp = await getRestaurant(restaurantId)
    const data = resp.data
    if (data.success) {
      // 存储餐厅头像和用户ID
      this.restaurantAvatar = data.data.avatar_url
      this.restaurantUserId = data.data.user_id
    }
  } catch (e) {
    console.error('获取餐厅信息失败', e)
  }
},
     toAvatarUrl(path, senderType) {
       const API = typeof API_url !== 'undefined' ? API_url : (window.API_url || window.location.origin)
       if (!path) {
         const cached = senderType === 'merchant'
           ? (localStorage.getItem('merchantAvatar') || localStorage.getItem('restaurantAvatar') || this.merchantAvatar)
           : (localStorage.getItem('userAvatar') || this.myAvatar || null)
         if (cached) {
           if (/^https?:\/\//.test(cached)) return cached
           if (cached.startsWith('/')) return `${API}${cached}`
           return `${API}${this.avatarBasePath}${cached}`
         }
         return `${API}${this.avatarBasePath}avatar.png`
       }
       if (/^https?:\/\//.test(path)) return path
       if (path.startsWith('/')) return `${API}${path}`
       if (path.includes('/uploads/')) return `${API}/${path.replace(/^\/+/, '')}`
       return `${API}${this.avatarBasePath}${path}`
     },
     normalizeAvatar(path) {
       const API = typeof API_url !== 'undefined' ? API_url : (window.API_url || window.location.origin)
       if (!path) return `${API}/static/default/avatar.png`
       const p = String(path).replace(/\\/g, '/').trim()
       if (/^https?:\/\//.test(p)) return p
       if (p.startsWith('/')) return `${API}${p}`
       return `${API}/static/uploads/avatar/${p}`
     },
    async fetchProfilesByIds(ids = []) {
      if (!ids || !ids.length) return
      const uniq = [...new Set(ids.filter(id => id != null && !this.profileMap[id]))]
      await Promise.all(uniq.map(async id => {
        try {
          const resp = await getUserById(id)
          if (!resp.data) return
          const r = resp.data
          if (r && r.success && r.data) {
            this.$set ? this.$set(this.profileMap, id, r.data) : (this.profileMap[id] = r.data)
          }
        } catch (e) {}
      }))
    },

    // 【修复】将 checkNewMessages 移入 methods
    // 替换原有的 checkNewMessages 方法
async checkNewMessages() {
      if (!this.orders.length) return;

      for (const order of this.orders) {
        if (this.selectedLeft && this.selectedLeft.orderId === order.orderId) continue;

        try {
          const lastId = parseInt(this.readStatus[order.orderId]) || 0;

          const resp = await getMessages({ order_id: order.orderId, last_id: lastId });
          const result = resp.data;
          
          if (this.selectedLeft && this.selectedLeft.orderId === order.orderId) continue;

          if (result.success && result.data.length > 0) {
            const incomingMaxId = Math.max(...result.data.map(m => parseInt(m.id) || 0));
            
            // 【关键修改】：获取最新一条消息的时间，更新活跃时间
            // 确保列表排序会把这个订单顶上去
            const latestMsgTime = new Date(result.data[result.data.length - 1].created_at).getTime();
            if (latestMsgTime > order.lastActivityTime) {
                order.lastActivityTime = latestMsgTime;
                this.updateActivityTime(order.orderId, latestMsgTime);
            }

            if (incomingMaxId > lastId) {
                order.hasNew = true;
                if (this.$set) this.$set(order, 'hasNew', true);
                
                if (!this.hasNewStatus[order.orderId]) {
                    this.hasNewStatus[order.orderId] = true;
                    localStorage.setItem('merchant_message_hasnew_status', JSON.stringify(this.hasNewStatus));
                }
            }
          }
        } catch (e) { }
      }
    },
    updateActivityTime(orderId, timestamp) {
        this.orderActivityMap[orderId] = timestamp;
        // 持久化，防止刷新后顺序重置
        localStorage.setItem('merchant_order_activity_map', JSON.stringify(this.orderActivityMap));
    },
   }, // <--- methods 结束
 }
</script>

<style scoped>
/* 保持之前的样式 */
.details-row td {
  background-color: #f9f9f9;
  border-bottom: 2px solid #ddd;
}
.details-content {
  padding: 8px 15px; /* 减小内边距 */
  text-align: left;
}
.details-content h4 {
  margin-top: 0;
  font-size: 14px; /* 减小标题字体 */
}

.scrollable-content {
  max-height: 350px; /* 减小固定高度 */
  overflow-y: auto; /* 超出高度时显示滚动条 */
  border: 1px solid #f0f0f0;
  border-radius: 4px;
  padding: 0; /* 移除内边距，让表格填充 */
}

.btn-link {
  background: none;
  border: none;
  color: #5d9cec;
  cursor: pointer;
  padding: 0;
  margin-left: 8px;
  font-size: 12px;
}
.btn-link:hover {
  text-decoration: underline;
}

.request-details .comparison-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 15px; /* 减小间距 */
  background-color: #fafafa;
  padding: 10px; /* 减小内边距 */
  border-radius: 4px;
}
.request-details .comparison-col h5 {
  border-bottom: 1px solid #eee;
  padding-bottom: 8px;
  margin-top: 0;
  margin-bottom: 10px; /* 减小外边距 */
  font-size: 13px; /* 减小字体 */
}
.request-details ul {
  padding-left: 18px; /* 减小缩进 */
  margin: 5px 0 10px 0; /* 减小外边距 */
}
.request-details li {
  margin-bottom: 4px; /* 减小列表项间距 */
}
.request-details p {
  margin: 0 0 6px 0; /* 减小段落间距 */
  font-size: 12px; /* 减小字体 */
}
.request-details .item-options {
  color: #888;
  font-size: 0.9em;
  margin-left: 5px;
}

.change-request-card {
  margin-top: 20px;
}

.status-pill {
  display: inline-block;
  padding: 2px 8px;
  border-radius: 999px;
  font-size: 11px; /* 减小字体 */
  color: #fff;
}
.status-pill--pending { background-color: #f1c40f; }
.status-pill--approved { background-color: #2ecc71; }
.status-pill--rejected { background-color: #e74c3c; }
.status-pill--withdrawn { background-color: #bfbfbf; color: #fff; }

.empty-hint {
  padding: 12px 0;
  text-align: center;
  color: #888;
}

/* 按钮样式 */
.btn,
.btn-danger,
.btn-secondary,
.btn-outline {
  padding: 5px 10px; /* 减小按钮内边距 */
  border-radius: 4px;
  cursor: pointer;
  margin-right: 5px;
  font-size: 13px; /* 减小按钮字体 */
}
.btn:hover {
  background-color: #4a89dc;
}
.btn-outline {
  background-color: white;
  color: #5d9cec;
  border: 1px solid #5d9cec;
}
.btn-outline:hover {
  background-color: #f0f0f0;
}
.btn-secondary {
  background-color: #95a5a6;
  color: white;
  border: none;
  margin-left: 5px;
}
.btn-secondary:hover {
  background-color: #7f8c8d;
}
.btn-danger {
  background-color: #e74c3c;
  color: white;
  border: none;
}
.btn-danger:hover {
  background-color: #c0392b;
}
.action-btn {
  border: none;
  border-radius: 4px;
  padding: 6px 12px; /* 减小按钮内边距 */
  font-size: 13px; /* 减小按钮字体 */
  cursor: pointer;
  transition: background-color 0.2s ease;
  color: #fff;
  margin-left: 6px;
}

.action-btn--primary {
  background-color: #1abc9c;
}

.action-btn--primary:hover:not(:disabled) {
  background-color: #18a085;
}

.action-btn--outline {
  background-color: transparent;
  color: #1abc9c;
  border: 1px solid #1abc9c;
}

.action-btn--outline:hover:not(:disabled) {
  background-color: rgba(26, 188, 156, 0.08);
}

button:disabled {
  background-color: #ccc;
  cursor: not-allowed;
}


/* 模态框样式 */
.modal-backdrop {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal {
  background-color: white;
  padding: 20px;
  border-radius: 8px;
  width: 380px; /* 减小模态框宽度 */
  box-shadow: 0 4px 10px rgba(0,0,0,0.2);
}

.modal h3 {
  margin-top: 0;
}

.form-group {
  margin-bottom: 15px;
}
.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}
.form-group select,
.form-group textarea {
  width: 100%;
  padding: 8px;
  box-sizing: border-box; /* 确保padding不会撑大宽度 */
}

.modal-actions {
  text-align: right;
  margin-top: 20px;
}
.modal-actions button {
  margin-left: 10px;
}

/* 新增：表格紧凑样式 */
.table {
  font-size: 13px; /* 减小表格字体 */
}
.table th, .table td {
  padding: 8px 10px; /* 减小单元格内边距 */
}

/* 新增局部布局样式，尽量与现有样式兼容 */
.requests-chat { 
  display:flex; 
  gap:12px; 
  align-items:flex-start; 
  height: 520px; /* 增大整个消息窗口高度 */
 }
.requests-list { 
  width: 30%;               /* 缩短左侧栏宽度 */
  max-width: 300px;        /* 限制最大宽度以防过宽 */
  border-right:1px solid #f0f0f0; 
  padding-right:8px; 
  height: 100%;            /* 新增：填满高度 */
  overflow-y: auto;        /* 新增：内容溢出时显示滚动条 */
}
.request-items { list-style:none; margin:0; padding:0; display:flex; flex-direction:column; }
.request-items li { 
  padding:10px; 
  cursor:pointer; 
  border:1px solid #eee;   /* 为每个栏项增加小边框 */
  border-radius:6px;
  margin-bottom:8px;       /* 项间距，避免挤在一起 */
  background:#fff;
  transition: box-shadow .12s ease;
 }


/* --- Action Bubble UI (复用自 User 端) --- */
.action-bubble {
  width: 100%;
  min-width: 260px;
  max-width: 360px; /* 商家端宽一点 */
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  overflow: hidden;
  border: 1px solid #eee;
  border-left-width: 5px;
  margin: 4px 0;
  display: flex;
  flex-direction: column;
  text-align: left; /* 强制左对齐 */
}

/* 主题色 */
.theme-success { border-left-color: #52c41a; background-color: #f6ffed; }
.theme-success .action-title-text { color: #52c41a; }
.theme-success .status-badge { background: #e6f7ff; color: #52c41a; border: 1px solid #b7eb8f; }

.theme-warning { border-left-color: #faad14; background-color: #fffbe6; }
.theme-warning .action-title-text { color: #faad14; }
.theme-warning .status-badge { background: #fff7e6; color: #faad14; border: 1px solid #ffe58f; }

.theme-danger { border-left-color: #ff4d4f; background-color: #fff1f0; }
.theme-danger .action-title-text { color: #ff4d4f; }
.theme-danger .status-badge { background: #fff2f0; color: #ff4d4f; border: 1px solid #ffccc7; }

.theme-info { border-left-color: #1890ff; background-color: #e6f7ff; }

/* 内部结构 */
.action-header {
  padding: 8px 12px;
  border-bottom: 1px solid rgba(0,0,0,0.05);
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 600;
  background: rgba(255,255,255,0.6);
}
.action-icon { font-size: 16px; }
.action-title-text { font-size: 14px; }

.action-content {
  padding: 10px 12px;
  font-size: 13px;
  color: #333;
  background: #fff;
}

/* 对比网格 */
.comparison-grid { display: flex; align-items: stretch; gap: 8px; }
.comparison-col { flex: 1; background: #fafafa; border-radius: 6px; padding: 8px; display:flex; flex-direction:column; }
.col-new { background: #f4ffed; border: 1px solid #b7eb8f; }

.comparison-col h5 { margin: 0 0 6px 0; font-size: 12px; color: #999; text-align: center; }
.col-content ul { padding: 0; margin: 0; list-style: none; }
.col-content li { 
  font-size: 13px;
  margin-bottom: 4px;
  display: flex;
  justify-content: space-between;
  align-items: flex-start; /* 确保顶部对齐 */
}
.item-name {
  flex: 1; /* 名称占剩余空间 */
  word-break: break-word; /* 允许换行 */
  margin-right: 8px; /* 与数量间距 */
}
.qty {
  white-space: nowrap; /* 数量不换行 */
  font-weight: bold;
  color: #555;
}

.comparison-arrow { align-self: center; color: #ccc; font-weight: bold; }

.simple-reason { background: #f9f9f9; padding: 8px; border-radius: 6px; color: #555; font-style: italic; }

.action-footer { margin-top: 10px; text-align: right; }
.status-badge { display: inline-block; padding: 2px 8px; border-radius: 10px; font-size: 11px; font-weight: 600; }

.empty-text { color:#ccc; text-align:center; font-style:italic; font-size:12px; }
.note-text { margin-top:4px; padding-top:4px; border-top:1px dashed #eee; color:#888; font-size:12px; }

.request-items li:hover { box-shadow: 0 4px 10px rgba(0,0,0,0.04); }
.request-items li.active { background:#f5fbff; }
.chat-panel { flex:1; display:flex; flex-direction:column; min-height:220px; height: 100%; } /* 让右侧填充父容器高度 */
.chat-panel-header { display:flex; justify-content:space-between; align-items:flex-start; padding-bottom:8px; border-bottom:1px solid #eee; }
.chat-panel-body { flex:1; padding:12px; overflow:auto; background:#fafafa; }
.chat-panel-footer { display:flex; gap:8px; padding:10px; border-top:1px solid #eee; background:#fff; }
.chat-panel-footer input { flex:1; padding:8px 12px; border-radius:18px; border:1px solid #e7e7e7; }
.messages { display:flex; flex-direction:column; gap:10px; margin-bottom:8px; }
.msg-row { display:flex; align-items:flex-end; gap:10px; }
.msg-row.them { justify-content:flex-start; margin-right: auto; } /* <-- 新增：对方消息推到最左边 */
.msg-row.me { justify-content:flex-end; flex-direction:row-reverse; margin-left: auto; } /* <-- 新增：我的消息推到最右边 */
.avatar { width:36px; height:36px; border-radius:50%; object-fit:cover; box-shadow:0 1px 3px rgba(0,0,0,0.08); }
.bubble { max-width:70%; padding:10px 14px; border-radius:14px; background:#fff; box-shadow:0 1px 3px rgba(0,0,0,0.06); }
.msg-row.me .bubble { background:#e6f7ff; }
.time { font-size:11px; color:#999; margin-top:4px; }
.comparison-grid { display:grid; grid-template-columns:1fr 1fr; gap:12px; margin-top:12px; background:#fff; padding:10px; border-radius:6px; }

/* 美化发送按钮 */
.btn--primary {
  padding: 8px 16px;
  border: none;
  border-radius: 18px; /* 与输入框一致的圆角 */
  background: linear-gradient(135deg, #007bff, #0056b3); /* 渐变背景 */
  color: #fff;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease; /* 平滑过渡 */
  box-shadow: 0 2px 4px rgba(0, 123, 255, 0.2); /* 轻微阴影 */
}

.btn--primary:hover:not(:disabled) {
  background: linear-gradient(135deg, #0056b3, #004085); /* 深色渐变 */
  transform: translateY(-1px); /* 轻微上移 */
  box-shadow: 0 4px 8px rgba(0, 123, 255, 0.3); /* 增强阴影 */
}

.btn--primary:active {
  transform: translateY(0); /* 点击时恢复 */
}

.btn--primary:disabled {
  background: #ccc;
  color: #999;
  cursor: not-allowed;
  box-shadow: none;
  transform: none;
}

/* 预约信息样式 */
.reservation-info {
  margin-top: 12px;
  padding: 12px;
  background: #f0f9ff;
  border-radius: 8px;
  border-left: 4px solid #1890ff;
}

.reservation-info p {
  margin: 4px 0;
}

.reservation-status-pending {
  color: #fa8c16;
  font-weight: 600;
}

.reservation-status-confirmed {
  color: #52c41a;
  font-weight: 600;
}

.reservation-status-seated {
  color: #1890ff;
  font-weight: 600;
}

.reservation-status-completed {
  color: #52c41a;
  font-weight: 600;
}

.reservation-status-cancelled,
.reservation-status-no_show {
  color: #ff4d4f;
  font-weight: 600;
}

.reservation-actions {
  margin-top: 12px;
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.reservation-btn {
  padding: 6px 12px;
  font-size: 13px;
  border-radius: 6px;
}

/* 订单类型标签 */
.order-type-tag {
  display: inline-block;
  padding: 2px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 500;
}

.order-type-tag.type-dinein,
.order-type-tag.type-dine_in {
  background: #e6f7ff;
  color: #1890ff;
}

.order-type-tag.type-takeout {
  background: #fff7e6;
  color: #fa8c16;
}

.order-type-tag.type-delivery {
  background: #f9f0ff;
  color: #722ed1;
}

.reservation-tag {
  display: inline-block;
  margin-left: 4px;
  padding: 2px 6px;
  background: #f6ffed;
  color: #52c41a;
  border-radius: 4px;
  font-size: 11px;
}

/* 状态标签 */
.status-tag {
  display: inline-block;
  padding: 2px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 500;
}

.status-tag.status-pending {
  background: #fff7e6;
  color: #fa8c16;
}

.status-tag.status-confirmed {
  background: #f6ffed;
  color: #52c41a;
}

.status-tag.status-dining {
  background: #e6f7ff;
  color: #1890ff;
}

.status-tag.status-completed {
  background: #f5f5f5;
  color: #8c8c8c;
}

.status-tag.status-cancelled,
.status-tag.status-rejected {
  background: #fff1f0;
  color: #ff4d4f;
}

/* 预约状态小标签 */
.reservation-status-tag {
  display: inline-block;
  margin-left: 4px;
  padding: 1px 6px;
  border-radius: 3px;
  font-size: 11px;
}

.reservation-status-tag.res-pending {
  background: #fffbe6;
  color: #d48806;
}

.reservation-status-tag.res-confirmed {
  background: #f6ffed;
  color: #389e0d;
}

.reservation-status-tag.res-seated {
  background: #e6f7ff;
  color: #096dd9;
}

.reservation-status-tag.res-completed {
  background: #f5f5f5;
  color: #595959;
}

.reservation-status-tag.res-cancelled,
.reservation-status-tag.res-no_show {
  background: #fff1f0;
  color: #cf1322;
}
</style>