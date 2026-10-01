<template>
  <div id="app">
    <router-view />
    <AIAssistantFloating v-if="!hideAssistant" />
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import AIAssistantFloating from './components/AIAssistantFloating.vue'

const route = useRoute()
const hiddenPaths = ['/login', '/register', '/reset-password']
const hideAssistant = computed(() => hiddenPaths.includes(route.path))
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'Helvetica Neue', Arial, sans-serif;
  line-height: 1.6;
  color: #333;
}

#app {
  min-height: 100vh;
}

/* 全局样式 */
a {
  text-decoration: none;
}

button {
  font-family: inherit;
}

input {
  font-family: inherit;
}
</style>