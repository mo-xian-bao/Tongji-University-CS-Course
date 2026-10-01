<template>
  <div class="reset-container">
    <div class="reset-box">
      <h2 class="reset-title">重置密码</h2>

      <form @submit.prevent="handleResetPassword" class="reset-form">
        <!-- 手机号输入 -->
        <div class="form-group">
          <label for="phone">手机号</label>
          <input
            id="phone"
            v-model="resetForm.phone"
            type="tel"
            placeholder="请输入注册手机号"
            class="form-input"
            @input="updatePunctually"
            required
          />
        </div>

        <!-- 验证码输入 -->
        <div class="form-group">
          <label for="smsCode">短信验证码</label>
          <div class="sms-input-group">
            <input
              id="smsCode"
              v-model="resetForm.smsCode"
              type="text"
              placeholder="请输入6位验证码"
              class="form-input sms-input"
              maxlength="6"
              required
            />
            <button
              type="button"
              class="sms-btn"
              :disabled="!canSendSms || smsCountdown > 0"
              @click="sendSmsCode"
            >
              {{ smsCountdown > 0 ? `${smsCountdown}s后重发` : '发送验证码' }}
            </button>
          </div>
        </div>

        <!-- 新密码输入 -->
        <div class="form-group">
          <label for="newPassword">新密码</label>
          <input
            id="newPassword"
            v-model="resetForm.newPassword"
            type="password"
            placeholder="请输入新密码（至少6个字符）"
            class="form-input"
            required
          />
        </div>

        <!-- 确认密码输入 -->
        <div class="form-group">
          <label for="confirmPassword">确认密码</label>
          <input
            id="confirmPassword"
            v-model="resetForm.confirmPassword"
            type="password"
            placeholder="请再次输入新密码"
            class="form-input"
            required
          />
        </div>

        <button type="submit" class="reset-btn" :disabled="isLoading">
          {{ isLoading ? '重置中...' : '重置密码' }}
        </button>
      </form>

      <div class="back-link">
        <router-link to="/login" class="link">返回登录</router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { sendResetPasswordCode, resetPassword } from '@/api/auth'
import { useRouter } from 'vue-router'

const router = useRouter()

const isLoading = ref(false)
const smsCountdown = ref(0)
const resetForm = reactive({
  phone: '',
  smsCode: '',
  newPassword: '',
  confirmPassword: ''
})

// 计算属性：是否可以发送短信
const canSendSms = ref(false)

// 验证手机号格式
const validatePhone = (phone) => {
  const phoneRegex = /^1[3-9]\d{9}$/
  return phoneRegex.test(phone)
}

// 更新短信发送按钮状态
const updateCanSendSms = () => {
  canSendSms.value = validatePhone(resetForm.phone)
}

const updatePunctually = () => {
  updateCanSendSms()
}

// 发送短信验证码
const sendSmsCode = async () => {
  if (!validatePhone(resetForm.phone)) {
    alert('请输入正确的手机号格式')
    return
  }

  try {
    const response = await sendResetPasswordCode(resetForm.phone)
    const result = response.data

    if (result.success) {
      alert('验证码发送成功！')
      // 开始倒计时
      smsCountdown.value = 60
      const timer = setInterval(() => {
        smsCountdown.value--
        if (smsCountdown.value <= 0) {
          clearInterval(timer)
        }
      }, 1000)
    } else {
      alert(result.message || '发送失败')
    }

  } catch (error) {
    console.error('发送验证码失败:', error)
    alert(error.response?.data?.message || '网络错误，请稍后重试')
  }
}

// 处理密码重置
const handleResetPassword = async () => {
  // 验证手机号
  if (!validatePhone(resetForm.phone)) {
    alert('请输入正确的手机号格式')
    return
  }

  // 验证验证码
  if (!resetForm.smsCode || resetForm.smsCode.length !== 6) {
    alert('请输入6位短信验证码')
    return
  }

  // 验证新密码
  if (!resetForm.newPassword || resetForm.newPassword.length < 6) {
    alert('新密码至少需要6个字符')
    return
  }

  // 验证确认密码
  if (resetForm.newPassword !== resetForm.confirmPassword) {
    alert('两次输入的密码不一致')
    return
  }

  isLoading.value = true

  try {
    const response = await resetPassword({
      phone: resetForm.phone,
      sms_code: resetForm.smsCode,
      new_password: resetForm.newPassword,
      confirmPassword: resetForm.confirmPassword
    })
    const result = response.data

    if (result.success) {
      alert('密码重置成功！')
      // 清空表单
      Object.assign(resetForm, {
        phone: '',
        smsCode: '',
        newPassword: '',
        confirmPassword: ''
      })
      // 返回登录页面
      router.push('/login')
    } else {
      alert(result.message || '重置失败')
    }

  } catch (error) {
    console.error('密码重置失败:', error)
    alert(error.response?.data?.message || '网络错误，请稍后重试')
  } finally {
    isLoading.value = false
  }
}
</script>

<style scoped>
.reset-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, var(--color-brand-500) 0%, #764ba2 100%);
  padding: 20px;
}

.reset-box {
  background: var(--color-surface);
  padding: 40px;
  border-radius: 12px;
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 400px;
}

.reset-title {
  text-align: center;
  margin-bottom: 30px;
  color: var(--color-text-700);
  font-size: 28px;
  font-weight: 600;
}

.reset-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-group label {
  color: var(--color-text-600);
  font-weight: 500;
  font-size: 14px;
}

.form-input {
  padding: 12px 16px;
  border: 2px solid var(--color-border-200);
  border-radius: 8px;
  font-size: 16px;
  transition: all 0.3s ease;
  outline: none;
}

.form-input:focus {
  border-color: var(--color-brand-500);
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.form-input::placeholder {
  color: var(--color-text-500);
}

.reset-btn {
  background: linear-gradient(135deg, var(--color-brand-500) 0%, #764ba2 100%);
  color: white;
  border: none;
  padding: 14px 20px;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  margin-top: 10px;
}

.reset-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
}

.reset-btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  transform: none;
}

.back-link {
  text-align: center;
  margin-top: 25px;
  color: var(--color-text-600);
  font-size: 14px;
}

.back-link .link {
  color: var(--color-brand-500);
  text-decoration: none;
  font-weight: 600;
  transition: color 0.3s ease;
}

.back-link .link:hover {
  color: #764ba2;
  text-decoration: underline;
}

/* 短信验证码样式 */
.sms-input-group {
  display: flex;
  gap: 10px;
  max-width: 100%; /* 添加这行，使其占满父容器宽度 */
  box-sizing: border-box;
  width: 100%;
  border-radius: 6px;
  overflow: hidden;
}

.sms-input {
  flex: 1;
  padding: 12px 16px;
  border: 2px solid var(--color-border-200);
  border-radius: 8px;
  font-size: 16px;
  transition: all 0.3s ease;
  outline: none;
  max-width: 80%;
}
.sms-input:focus {
  border-color: var(--color-brand-500);
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.sms-input::placeholder {
  color: var(--color-text-500);
}

.sms-btn {
  padding: 12px 16px;
  background: var(--color-brand-500);
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  white-space: nowrap;
  width:100%;
}

.sms-btn:hover:not(:disabled) {
  background: var(--color-brand-600);
  transform: translateY(-1px);
}

.sms-btn:disabled {
  background: var(--color-text-500);
  cursor: not-allowed;
  transform: none;
}

@media (max-width: 480px) {
  .reset-container {
    padding: 10px;
  }

  .reset-box {
    padding: 30px 20px;
  }

  .reset-title {
    font-size: 24px;
  }
}
</style>