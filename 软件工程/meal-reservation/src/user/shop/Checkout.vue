<template>
  <div class="checkout-page">
    <div class="header">结算</div>

    <div v-if="!order" class="empty">未选择订单或订单信息已过期</div>

    <div v-else class="content">
      <div class="shop">商家：{{ order.shop }}</div>
      <div class="items">商品：{{ order.items }}</div>
      <div class="date">下单时间：{{ order.date }}</div>

      <div class="total">
        <div class="label">总计</div>
        <div class="amount">¥ {{ total }}</div>
      </div>

      <button class="pay-btn" @click="pay">模拟支付</button>
    </div>

    <BottomNav />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import BottomNav from '../components/BottomNav.vue'

const router = useRouter()
const order = ref(null)
const total = ref('0.00')

onMounted(() => {
  try {
    const raw = sessionStorage.getItem('checkout_order')
    if (raw) {
      order.value = JSON.parse(raw)
      // 简单根据 items 字符串计算一个模拟价格
      const match = order.value.items.match(/(\d+)/g)
      let qty = 1
      if (match) qty = match.reduce((s, v) => s + Number(v), 0)
      // 模拟价格：每件 39.9
      total.value = (qty * 39.9).toFixed(2)
    }
  } catch (e) {
    console.error('读取结算订单失败', e)
  }
})

function pay() {
  alert('支付成功（模拟）')
  // 清除 sessionStorage 的结算订单
  try { sessionStorage.removeItem('checkout_order') } catch (e) {}
  // 支付后跳回订单页
  router.push({ name: 'Orders' })
}
</script>

<style scoped>
.checkout-page{min-height:100vh;padding-bottom:72px;background:#f7f8fb}
.header{padding:16px;font-weight:700;background:white}
.content{padding:16px}
.shop,.items,.date{background:white;padding:12px;border-radius:10px;margin-bottom:10px}
.total{display:flex;justify-content:space-between;align-items:center;padding:12px;background:white;border-radius:10px;margin:12px}
.amount{color:#ff4d4f;font-weight:800;font-size:20px}
.pay-btn{display:block;width:calc(100% - 32px);margin:12px;padding:12px;border-radius:8px;border:none;background:#1677ff;color:#fff;font-weight:700}
.empty{padding:24px;text-align:center;color:#999}
</style>
