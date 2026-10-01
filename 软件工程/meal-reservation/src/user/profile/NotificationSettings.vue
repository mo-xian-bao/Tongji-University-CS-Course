<template>
  <div class="notification-settings">
    <header class="settings-header">
      <button class="back-btn" type="button" aria-label="返回" @click="goBack">←</button>
      <h1 class="title">通知设置</h1>
    </header>

    <section class="settings-body">
      <p class="hint">选择消息提醒模式，决定消息列表的提示样式。</p>

      <form class="mode-list">
        <label
          v-for="option in options"
          :key="option.value"
          class="mode-item"
        >
          <input
            class="radio-input"
            type="radio"
            :value="option.value"
            name="notification-mode"
            :checked="isSelected(option.value)"
            @change="() => setPreference(option.value)"
          />
          <div class="mode-content">
            <span class="mode-title">{{ option.title }}</span>
            <span class="mode-desc">{{ option.description }}</span>
          </div>
          <span v-if="isSelected(option.value)" class="mode-active">✓</span>
        </label>
      </form>

      <p v-if="feedback" class="feedback">{{ feedback }}</p>
    </section>
  </div>
</template>

<script setup>
import { onUnmounted, ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const STORAGE_KEY = 'notificationPreference'
const DEFAULT_MODE = 'normal'

const options = [
  {
    value: 'normal',
    title: '常规模式',
    description: '显示数字角标，直观展示未读数量'
  },
  {
    value: 'dnd',
    title: '免打扰模式',
    description: '以小红点提示新消息，减少数字提醒打扰'
  }
]

const feedback = ref('')
const mode = ref(readPreference())
let feedbackTimer = null

function readPreference() {
  try {
    const stored = localStorage.getItem(STORAGE_KEY)
    return stored === 'dnd' ? 'dnd' : DEFAULT_MODE
  } catch (err) {
    console.warn('读取通知偏好失败', err)
    return DEFAULT_MODE
  }
}

function setPreference(value) {
  if (mode.value === value) {
    return
  }
  mode.value = value
  try {
    localStorage.setItem(STORAGE_KEY, value)
  } catch (err) {
    console.warn('保存通知偏好失败', err)
  }
  window.dispatchEvent(new CustomEvent('notification-preference-changed', { detail: value }))
  showFeedback(value === 'dnd' ? '已切换到免打扰模式' : '已切换到常规模式')
}

function isSelected(value) {
  return mode.value === value
}

function showFeedback(message) {
  feedback.value = message
  if (feedbackTimer) {
    clearTimeout(feedbackTimer)
  }
  feedbackTimer = setTimeout(() => {
    feedback.value = ''
    feedbackTimer = null
  }, 1800)
}

function goBack() {
  router.back()
}

onUnmounted(() => {
  if (feedbackTimer) {
    clearTimeout(feedbackTimer)
  }
})
</script>

<style scoped>
.notification-settings {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background: #f6f7fb;
  color: #1f2933;
}

.settings-header {
  display: flex;
  align-items: center;
  padding: 16px;
  background: #ffffff;
  box-shadow: 0 1px 3px rgba(15, 23, 42, 0.08);
}

.back-btn {
  width: 36px;
  height: 36px;
  margin-right: 12px;
  border: none;
  border-radius: 10px;
  background: #eef1f8;
  color: #334155;
  font-size: 18px;
  cursor: pointer;
}

.title {
  font-size: 20px;
  font-weight: 600;
}

.settings-body {
  padding: 20px;
  flex: 1;
}

.hint {
  margin-bottom: 20px;
  color: #64748b;
  font-size: 14px;
}

.mode-list {
  display: grid;
  gap: 16px;
}

.mode-item {
  position: relative;
  display: flex;
  align-items: center;
  padding: 16px;
  border-radius: 16px;
  background: #ffffff;
  box-shadow: 0 4px 12px rgba(15, 23, 42, 0.05);
  cursor: pointer;
  transition: box-shadow 0.2s ease;
}

.mode-item:hover {
  box-shadow: 0 6px 18px rgba(15, 23, 42, 0.08);
}

.radio-input {
  margin-right: 16px;
  width: 18px;
  height: 18px;
}

.mode-content {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.mode-title {
  font-size: 16px;
  font-weight: 600;
}

.mode-desc {
  font-size: 13px;
  color: #6b7280;
}

.mode-active {
  position: absolute;
  right: 16px;
  top: 50%;
  transform: translateY(-50%);
  font-size: 18px;
  color: #2563eb;
  font-weight: 600;
}

.feedback {
  margin-top: 20px;
  font-size: 14px;
  color: #2563eb;
}
</style>
