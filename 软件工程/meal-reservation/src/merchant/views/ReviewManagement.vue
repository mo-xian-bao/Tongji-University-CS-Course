<template>
  <div>
    <h2>评论管理</h2>
    <div class="card">
      <h3>顾客评论</h3>
      <div v-for="r in reviews" :key="r.id" style="padding:12px;border-bottom:1px dashed #f1f7ff">
        <div style="display:flex;justify-content:space-between">
          <div><strong>{{r.user}}</strong> <span class="small">{{r.time}}</span></div>
          <div class="small">评分: {{r.score}}</div>
        </div>
        <div style="margin-top:6px">{{r.text}}</div>
        <div style="margin-top:8px">
          <input v-model="r.reply" class="input" placeholder="回复顾客（选填）" />
          <button class="btn" style="margin-left:8px" @click="send(r)">发送</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { getMerchantReviews, replyToReview } from '@/api/merchant'

export default{
  data(){
    return{
      reviews: []
    }
  },
  mounted(){
    this.loadReviews()
  },
  methods:{
    async send(r){
      try{
        const resp = await replyToReview(r.id, r.reply)
        if (resp.data.success) {
          alert('回复已保存')
          // 清空输入框
          r.reply = ''
        } else {
          alert(resp.data.message || '回复失败')
        }
      } catch (e) {
        console.error(e)
        alert(e.response?.data?.message || '回复失败')
      }
    },
    async loadReviews(){
      try{
        const resp = await getMerchantReviews()
        if (resp.data.success && resp.data.data && resp.data.data.reviews) {
          this.reviews = resp.data.data.reviews.map(r => ({
            id: r.id,
            user: r.username || `用户${r.user_id}`,
            time: r.created_at ? r.created_at.split('T')[0] : r.created_at,
            score: r.rating,
            text: r.content,
            reply: r.merchant_reply || ''
          }))
        }
      }catch(e){console.error('加载商家评价失败', e)}
    }
  }
}
</script>
