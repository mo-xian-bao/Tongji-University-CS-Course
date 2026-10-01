<template>
	<div
		class="ai-assistant"
		:class="{ open }"
		:style="{ top: pos.y + 'px', left: pos.x + 'px' }"
	>
		<button 
			class="ai-toggle" 
			@click.stop="toggle"
			@mousedown="startDrag"
			@touchstart.passive="startDrag"
		>
			<span v-if="!open">🤖 AI 助手</span>
			<span v-else>✕ 关闭</span>
		</button>

		<div v-if="open" class="ai-panel">
			<div 
				class="ai-header"
				@mousedown="startDrag"
				@touchstart.passive="startDrag"
			>
				<div class="ai-title">AI 助手</div>
				<button class="ai-close" @click.stop="toggle">✕</button>
			</div>
			<div class="ai-body">
				<div class="ai-messages" ref="msgBox">
					<div class="msg msg-system">AI 准备就绪，随时提问～</div>
					<div
						v-for="(msg, idx) in messages"
						:key="idx"
						class="msg"
						:class="msg.role === 'user' ? 'msg-user' : 'msg-ai'"
					>
						{{ msg.content }}
					</div>
					<div v-if="loading" class="msg msg-ai">思考中...</div>
				</div>
				<div class="ai-input">
					<input
						v-model="input"
						type="text"
						placeholder="请输入问题，回车发送"
						@keydown.enter.prevent="send"
					/>
					<button @click="send" :disabled="loading">发送</button>
				</div>
			</div>
		</div>
	</div>
</template>

<script setup>
import { onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { aiChat } from '@/api/user'

const open = ref(false)
const input = ref('')
const loading = ref(false)
const messages = ref([])
const msgBox = ref(null)

const pos = ref({ x: 0, y: 0 })
const dragging = ref(false)
const dragOffset = ref({ x: 0, y: 0 })

const clamp = (val, min, max) => Math.min(Math.max(val, min), max)

const startDrag = (e) => {
	const point = e.touches ? e.touches[0] : e
	dragging.value = true
	dragOffset.value = {
		x: point.clientX - pos.value.x,
		y: point.clientY - pos.value.y
	}
}

const onDragMove = (e) => {
	if (!dragging.value) return
	const point = e.touches ? e.touches[0] : e
	const vw = window.innerWidth
	const vh = window.innerHeight
	const width = open.value ? 360 : 140
	const height = open.value ? 520 : 64
	const nextX = clamp(point.clientX - dragOffset.value.x, 12, vw - width - 12)
	const nextY = clamp(point.clientY - dragOffset.value.y, 12, vh - height - 12)
	pos.value = { x: nextX, y: nextY }
}

const endDrag = () => {
	dragging.value = false
}

const toggle = () => {
	open.value = !open.value
}

// 监听打开状态，防止面板展开时超出屏幕底部
watch(open, (val) => {
	if (val) {
		const vh = window.innerHeight
		const vw = window.innerWidth
		const height = 520 // 面板高度
		const width = 360  // 面板宽度
		
		// 如果底部超出屏幕，向上移动
		if (pos.value.y + height > vh - 12) {
			pos.value.y = Math.max(12, vh - height - 12)
		}
		// 如果右侧超出屏幕，向左移动
		if (pos.value.x + width > vw - 12) {
			pos.value.x = Math.max(12, vw - width - 12)
		}
	}
})

const scrollToBottom = () => {
	requestAnimationFrame(() => {
		if (msgBox.value) {
			msgBox.value.scrollTop = msgBox.value.scrollHeight
		}
	})
}

const send = async () => {
	if (!input.value.trim() || loading.value) return
	const text = input.value.trim()
	input.value = ''
	messages.value.push({ role: 'user', content: text })
	loading.value = true
	scrollToBottom()

	try {
		const res = await aiChat(text)
		const data = res.data
		if (data.success) {
			messages.value.push({ role: 'assistant', content: data.data.answer })
		} else {
			messages.value.push({ role: 'assistant', content: '抱歉，我遇到了一些问题：' + data.message })
		}
	} catch (e) {
		messages.value.push({ role: 'assistant', content: '网络请求失败，请稍后重试。' })
	} finally {
		loading.value = false
		scrollToBottom()
	}
}

onMounted(() => {
	const vw = window.innerWidth
	const vh = window.innerHeight
	pos.value = { x: vw - 200, y: vh - 140 }
	window.addEventListener('mousemove', onDragMove)
	window.addEventListener('mouseup', endDrag)
	window.addEventListener('touchmove', onDragMove, { passive: false })
	window.addEventListener('touchend', endDrag)
})

onBeforeUnmount(() => {
	window.removeEventListener('mousemove', onDragMove)
	window.removeEventListener('mouseup', endDrag)
	window.removeEventListener('touchmove', onDragMove)
	window.removeEventListener('touchend', endDrag)
})
</script>

<style scoped>
.ai-assistant {
	position: fixed;
	z-index: 2000;
	display: flex;
	flex-direction: column;
	align-items: flex-end;
	gap: 8px;
	cursor: grab;
	user-select: none;
}

.ai-assistant:active {
	cursor: grabbing;
}

.ai-toggle {
	background: #2b6be4;
	color: #fff;
	border: none;
	border-radius: 999px;
	padding: 12px 16px;
	font-size: 14px;
	cursor: pointer;
	box-shadow: 0 8px 20px rgba(43, 107, 228, 0.25);
	transition: transform 0.15s ease, box-shadow 0.15s ease;
}

.ai-toggle:hover {
	transform: translateY(-1px);
	box-shadow: 0 10px 24px rgba(43, 107, 228, 0.3);
}

.ai-panel {
	width: min(360px, 90vw);
	height: min(520px, 80vh);
	background: #fff;
	border-radius: 12px;
	box-shadow: 0 14px 40px rgba(0, 0, 0, 0.16);
	overflow: hidden;
	display: flex;
	flex-direction: column;
}

.ai-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 12px 14px;
	background: linear-gradient(135deg, #2b6be4, #5f9bff);
	color: #fff;
}

.ai-title {
	font-weight: 600;
	letter-spacing: 0.3px;
}

.ai-close {
	background: transparent;
	border: none;
	color: #fff;
	font-size: 16px;
	cursor: pointer;
}

.ai-body {
	flex: 1;
	display: flex;
	flex-direction: column;
	padding: 12px;
	gap: 10px;
	min-height: 0; /* 关键：防止 flex 子元素溢出导致不滚动 */
}

.ai-messages {
	flex: 1;
	overflow-y: auto;
	padding: 8px;
	background: #f7f9fc;
	border-radius: 8px;
	display: flex;
	flex-direction: column;
	gap: 8px;
	
	/* 美化滚动条 */
	scrollbar-width: thin;
	scrollbar-color: #cbd5e1 transparent;
}

.ai-messages::-webkit-scrollbar {
	width: 6px;
}

.ai-messages::-webkit-scrollbar-track {
	background: transparent;
}

.ai-messages::-webkit-scrollbar-thumb {
	background-color: #cbd5e1;
	border-radius: 3px;
}

.msg {
	padding: 10px 12px;
	border-radius: 10px;
	font-size: 14px;
	line-height: 1.5;
	word-break: break-word;
}

.msg-system {
	background: #eef2fb;
	color: #4a5c96;
}

.msg-user {
	align-self: flex-end;
	background: #2b6be4;
	color: #fff;
}

.msg-ai {
	align-self: flex-start;
	background: #e9ecf6;
	color: #2f3c5c;
}

.ai-input {
	display: flex;
	gap: 8px;
}

.ai-input input {
	flex: 1;
	padding: 10px 12px;
	border-radius: 8px;
	border: 1px solid #dfe3eb;
	font-size: 14px;
}

.ai-input button {
	padding: 10px 14px;
	border-radius: 8px;
	border: none;
	background: #2b6be4;
	color: #fff;
	cursor: pointer;
	min-width: 64px;
}

.ai-input button:disabled {
	opacity: 0.6;
	cursor: not-allowed;
}
</style>
