<template>
  <nav class="bottom-nav">
    <button class="nav-btn" :class="{active:isActive('/shop')}" @click="go('/shop')">
      <div class="icon">🏠</div>
      <div class="label">首页</div>
    </button>

    <button class="nav-btn" :class="{active:isActive('/orders')}" @click="go('/orders')">
      <div class="icon">📦</div>
      <div class="label">订单</div>
    </button>

    <button class="nav-btn" :class="{active:isActive('/messages')}" @click="go('/messages')">
      <div class="icon">💬</div>
      <div class="label">消息</div>
    </button>

    <button class="nav-btn" :class="{active:isActive('/profile')}" @click="go('/profile')">
      <div class="icon">👤</div>
      <div class="label">我的</div>
    </button>
  </nav>
</template>

<script setup>
import { useRouter, useRoute } from 'vue-router'
const router = useRouter()
const route = useRoute()

function go(path) {
  // 如果目标路由不存在于 router 中，router.push 仍然会添加，后续可实现对应页面
  router.push(path)
}

function isActive(path) {
  return route.path === path || route.path.startsWith(`${path}/`)
}
</script>

<style scoped>
.bottom-nav {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  height: 60px;
  display: flex;
  background: #fff;
  border-top: 1px solid #eee;
  z-index: 50;
}

.nav-btn {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  border: none;
  background: transparent;
  font-size: 12px;
  color: #666;
}

.nav-btn .icon {
  font-size: 18px;
}

.nav-btn.active {
  color: #1677ff;
}

.nav-btn:active {
  transform: translateY(1px);
}
</style>
