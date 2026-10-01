<template>
  <div class="support-dashboard">
    <h2>客服 — 仪表盘</h2>
    <div class="cards">
      <div class="card stat">
        <h3>待受理</h3>
        <div class="number">{{ counts.open }}</div>
        <div class="note">当前处于公开状态的工单数量（待受理）</div>
      </div>

      <div class="card stat">
        <h3>我的未处理</h3>
        <div class="number">{{ counts.my_in_progress }}</div>
        <div class="note">你还未处理的工单数量</div>
      </div>

      <div class="card stat">
        <h3>今日已处理</h3>
        <div class="number">{{ counts.my_today_processed }}</div>
        <div class="note">你当天已处理的工单数</div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'SupportDashboard',
  data() {
    return {
      tickets: [],
      counts: { open: 0, my_in_progress: 0, my_today_processed: 0 }
    }
  },
  created() {
    this.loadCounts()
  },
  methods: {
    async loadCounts() {
      try {
        const token = localStorage.getItem('token')
        const res = await axios.get(`/support/get_tickets`, { headers: { Authorization: `Bearer ${token}` } })
        if (res && res.data && res.data.success) {
          const d = res.data.data || {}
          this.counts.open = (d.open || []).length
          this.counts.my_in_progress = (d.my_in_progress || []).length
          this.counts.my_today_processed = (d.my_today_processed || []).length
        } else {
          // fallback to previous behavior
          this.tickets = (res && res.data && res.data.data) || []
          this.computeCounts()
        }
      } catch (e) {

      }
    },
  }
}
</script>

<style scoped>
.support-dashboard h2 { margin-bottom: 16px; color:#075985 }
.cards { display:flex; gap:16px; margin-bottom:16px }
.card.stat { flex:1; padding:16px; text-align:center }
.number { font-size:34px; font-weight:700; color:#0ea5a1 }
.note { color:#64748b; margin-top:8px }
.quick-info { padding:12px }
@media (max-width:720px) { .cards { flex-direction:column } }
</style>
