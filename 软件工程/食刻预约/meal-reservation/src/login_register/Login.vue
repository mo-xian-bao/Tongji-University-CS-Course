<template>
  <div class="login-container">
    <!-- 身份选择弹窗 -->
    <div v-if="showRoleDialog" class="role-dialog-overlay" @click="closeRoleDialog">
      <div class="role-dialog" @click.stop>
        <h3 class="role-dialog-title">请选择登录身份</h3>
        <p class="role-dialog-subtitle">您的账号同时具有商家和客户身份</p>
        <div class="role-buttons">
          <button class="role-btn merchant-btn" @click="loginAsMerchant">
            <div class="role-icon">🏪</div>
            <span>商家身份</span>
            <small>管理店铺和菜品</small>
          </button>
          <button class="role-btn customer-btn" @click="loginAsCustomer">
            <div class="role-icon">🛒</div>
            <span>客户身份</span>
            <small>浏览和下单</small>
          </button>
        </div>
        <button class="role-dialog-close" @click="closeRoleDialog">×</button>
      </div>
    </div>

    <!-- 申诉提示弹窗 -->
    <div v-if="showAppealDialog" class="appeal-dialog-overlay" @click="closeAppealDialog">
      <div class="appeal-dialog" @click.stop>
        <h3 class="appeal-dialog-title">账号已被封禁</h3>
        <div v-if="banInfo" class="ban-info">
          <p class="ban-reason">
            <strong>封禁原因:</strong> {{ banInfo.ban_reason_text }}
          </p>
          <p v-if="banInfo.ban_until" class="ban-until">
            <strong>封禁期限:</strong> {{ formatDate(banInfo.ban_until) }}
          </p>
          <p class="ban-time">
            <strong>封禁时间:</strong> {{ formatDate(banInfo.banned_at) }}
          </p>
        </div>
        <p class="appeal-question">您是否要进行申诉？</p>
        <div class="appeal-buttons">
          <button class="appeal-btn primary" @click="goToAppeal">
            申请申诉
          </button>
          <button class="appeal-btn secondary" @click="closeAppealDialog">
            取消
          </button>
        </div>
        <button class="appeal-dialog-close" @click="closeAppealDialog">×</button>
      </div>
    </div>

    <div class="login-box">
      <h2 class="login-title">登录</h2>

      <div v-if="errorMessage" class="error-message">
        {{ errorMessage }}
      </div>

      <form @submit.prevent="handleLogin" class="login-form">
        <!-- 密码登录 -->
        <div v-if="loginType === 'password'" class="form-group">               
          <label for="identifier">手机号/账号ID</label>
          <input
            id="identifier"
            v-model="loginForm.identifier"
            type="text"
            :placeholder="'请输入手机号或账号ID'"
            class="form-input"
            @input="updatePunctually"
            required
          />
          <label for="password">密码</label>
          <input
            id="password"
            v-model="loginForm.password"
            type="password"
            placeholder="请输入密码"
            class="form-input"
            required
          />
        </div>

        <!-- 短信验证码登录 -->
        <div v-if="loginType === 'sms'" class="form-group">
          <label for="identifier">手机号</label>
          <input
            id="identifier"
            v-model="loginForm.identifier"
            type="text"
            :placeholder="'请输入手机号' "
            class="form-input"
            @input="updatePunctually"
            required
          />
          <label for="smsCode">短信验证码</label>
          <div class="sms-input-group">
            <input
              id="smsCode"
              v-model="loginForm.smsCode"
              type="text"
              placeholder="请输入6位验证码"
              class="sms-input"
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

        <!-- 登录方式切换 -->
        <div class="login-type-switch">
          <button
            type="button"
            class="switch-btn"
            :class="{ active: loginType === 'password' }"
            @click="switchLoginType('password')"
          >
            密码登录
          </button>
          <button
            type="button"
            class="switch-btn"
            :class="{ active: loginType === 'sms' }"
            @click="switchLoginType('sms')"
          >
            短信登录
          </button>
        </div>

        <button type="submit" class="login-btn" :disabled="isLoading">
          {{ isLoading ? '登录中...' : '登录' }}
        </button>
      </form>

      <div class="register-link">
        <span>还没有账号？</span>
        <router-link to="/register" class="link">立即注册</router-link>
      </div>
      <div class="reset-link">
        <span>忘记密码？</span>
        <router-link to="/reset-password" class="link">重置密码</router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

// 页面挂载时检测是否有有效token
onMounted(() => {
  checkExistingToken()
})

async function checkExistingToken() {
  const token = localStorage.getItem('token')
  const userStr = localStorage.getItem('user')

  if (token && userStr) {
    try {
      const user = JSON.parse(userStr)

      // 验证token是否有效
      const isValid = await validateToken(token)

      if (isValid) {
        // 根据用户类型自动跳转
        redirectByUserType(user)
      }
    } catch (error) {
      console.error('Token验证失败:', error)
      // 清除无效的token
      localStorage.removeItem('token')
      localStorage.removeItem('user')
    }
  }
}

async function validateToken(token) {
  try {
    const response = await fetch('/api/auth/validate', {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      }
    })

    if (response.ok) {
      const result = await response.json()
      return result.success
    }
    return false
  } catch (error) {
    console.error('Token验证请求失败:', error)
    return false
  }
}

function redirectByUserType(user) {
  // 如果用户类型为1（同时具有商家和客户身份），需要选择身份
  if (user.usertype == 1) {
    // 这里可以存储用户信息并显示身份选择弹窗
    // 或者根据之前选择的角色进行跳转
    const selectedRole = localStorage.getItem('selectedRole')
    if (selectedRole === 'merchant') {
      router.push('/merchant')
    } else {
      router.push('/shop')
    }
  } else {
    // 根据用户类型直接跳转
    if (user.usertype == 0) {
      router.push('/admin')
    } 
    else if (user.usertype == 100) {
      router.push('/support')
    }
    else {
      router.push('/shop')
    }
  }
}

const isLoading = ref(false)
const errorMessage = ref('')
const smsCountdown = ref(0)
const loginType = ref('password') // 'password' 或 'sms'
const showRoleDialog = ref(false) // 控制身份选择弹窗显示
const pendingLoginData = ref(null) // 存储待处理的登录数据
const showAppealDialog = ref(false) // 控制申诉弹窗显示
const banInfo = ref(null) // 存储封禁信息
const loginForm = reactive({
  identifier: '',
  password: '',
  smsCode: ''
})

// 计算属性：是否可以发送短信
const canSendSms = ref(false)
  
// 验证手机号格式
const validatePhone = (phone) => {
  const phoneRegex = /^1[3-9]\d{9}$/
  return phoneRegex.test(phone)
}

// 切换登录方式
const switchLoginType = (type) => {
  loginType.value = type
  // 清空验证码和倒计时
  loginForm.smsCode = ''
  smsCountdown.value = 0
  updateCanSendSms() 
}

// 更新短信发送按钮状态
const updateCanSendSms = () => {
  if (loginType.value === 'sms') {
    canSendSms.value = validatePhone(loginForm.identifier)
  } else {
    canSendSms.value = false
  }
}

const updatePunctually = () => {
  updateCanSendSms()
}

const handleLogin = async () => {
  // 清除之前的错误信息
  errorMessage.value = ''

  // 根据登录类型验证必要字段
  if (!loginForm.identifier) {
    errorMessage.value = '请输入手机号或账号ID'
    return
  }

  if (loginType.value === 'password' && !loginForm.password) {
    errorMessage.value = '请输入密码'
    return
  }

  if (loginType.value === 'sms' && !loginForm.smsCode) {
    errorMessage.value = '请输入短信验证码'
    return
  }

  isLoading.value = true

  try {
    // 准备请求数据
    const requestData = {
      identifier: loginForm.identifier,
      loginType: loginType.value,
      password: loginType.value === 'password' ? loginForm.password : '',
      smsCode: loginType.value === 'sms' ? loginForm.smsCode : ''
    }

    // 调用后端登录API
    const response = await fetch('/api/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(requestData)
    })

    const result = await response.json()

    if (result.success) {
      // 登录成功，存储token和用户信息
      localStorage.setItem('token', result.data.token)
      localStorage.setItem('user', JSON.stringify(result.data.user))

      // 如果用户类型为1（同时具有商家和客户身份），显示身份选择弹窗
      if (result.data.user.usertype == 1) {
        pendingLoginData.value = result.data // 保存登录数据
        showRoleDialog.value = true // 显示身份选择弹窗
      } else {
        // 其他用户类型直接跳转
        if (result.data.user.usertype == 0)
          router.push('/admin')
        else if(result.data.user.usertype == 100)
          router.push('/support')
        else
          router.push('/shop')
      }
    } else {
      // 检查是否为账号封禁状态（HTTP 423）
      if (response.status === 423 && result.data && result.data.can_appeal) {
        // 显示封禁信息和申诉选项
        banInfo.value = result.data.ban_info
        showAppealDialog.value = true
      } else {
        // 普通登录失败，显示错误信息
        errorMessage.value = result.message || '登录失败，请检查账号密码'
      }
    }

  } catch (error) {
    console.error('登录失败:', error)
    alert('网络错误，请稍后重试')
  } finally {
    isLoading.value = false
  }
}

// 发送短信验证码
const sendSmsCode = async () => {
  if (!validatePhone(loginForm.identifier)) {
    alert('请输入正确的手机号格式')
    return
  }

  try {
    const response = await fetch('/api/sms/send', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        phone: loginForm.identifier,
        purpose: 'login'
      })
    })

    const result = await response.json()

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
    alert('网络错误，请稍后重试')
  }
}

// 身份选择相关方法
const loginAsMerchant = () => {
  // 以商家身份登录
  if (pendingLoginData.value) {
    localStorage.setItem('user', JSON.stringify({
      ...pendingLoginData.value.user,
      selectedRole: 'merchant' // 标记选择的身份
    }))
    router.push('/merchant')
  }
  closeRoleDialog()
}

const loginAsCustomer = () => {
  // 以客户身份登录
  if (pendingLoginData.value) {
    localStorage.setItem('user', JSON.stringify({
      ...pendingLoginData.value.user,
      selectedRole: 'customer' // 标记选择的身份
    }))
    router.push('/shop')
  }
  closeRoleDialog()
}

const closeRoleDialog = () => {
  showRoleDialog.value = false
  pendingLoginData.value = null
}

const guestLogin = () => {
  // 开发测试用，快速进入商家列表
  localStorage.setItem('token', 'guest-token')
  localStorage.setItem('user', JSON.stringify({name: '游客'}))
  router.push('/shop')
}

// 申诉相关方法
const formatDate = (dateStr) => {
  if (!dateStr) return '未知'
  return new Date(dateStr).toLocaleString('zh-CN')
}

const closeAppealDialog = () => {
  showAppealDialog.value = false
  banInfo.value = null
}

const goToAppeal = () => {
  // 跳转到申诉页面，并传递封禁信息
  if (banInfo.value) {
    router.push({
      path: '/appeal',
      query: {
        banId: banInfo.value.id,
        banReason: banInfo.value.ban_reason_text
      }
    })
  }
  closeAppealDialog()
}
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px;
}

.login-box {
  background: white;
  padding: 40px;
  border-radius: 12px;
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 400px;
}

.login-title {
  text-align: center;
  margin-bottom: 30px;
  color: #333;
  font-size: 28px;
  font-weight: 600;
}

.error-message {
  background-color: #fff2f0;
  border: 1px solid #ffccc7;
  color: #ff4d4f;
  padding: 8px 12px;
  border-radius: 4px;
  margin-bottom: 20px;
  font-size: 14px;
  text-align: center;
}

.login-form {
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
  color: #555;
  font-weight: 500;
  font-size: 14px;
}

.form-input {
  padding: 12px 16px;
  border: 2px solid #e1e5e9;
  border-radius: 8px;
  font-size: 16px;
  transition: all 0.3s ease;
  outline: none;
}

.form-input:focus {
  border-color: #667eea;
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.form-input::placeholder {
  color: #aaa;
}

.login-btn {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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

.login-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
}

.login-btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  transform: none;
}

.register-link {
  text-align: center;
  margin-top: 25px;
  color: #666;
  font-size: 14px;
}

.register-link .link {
  color: #667eea;
  text-decoration: none;
  font-weight: 600;
  margin-left: 5px;
  transition: color 0.3s ease;
}

.register-link .link:hover {
  color: #764ba2;
  text-decoration: underline;
}

.reset-link {
  text-align: center;
  margin-top: 15px;
  color: #666;
  font-size: 14px;
}

.reset-link .link {
  color: #e53e3e;
  text-decoration: none;
  font-weight: 600;
  transition: color 0.3s ease;
}

.reset-link .link:hover {
  color: #c53030;
  text-decoration: underline;
}

.guest-btn {
  background: transparent;
  color: #667eea;
  border: 2px solid #667eea;
  padding: 8px 16px;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
}

.guest-btn:hover {
  background: #667eea;
  color: white;
}

/* 登录方式切换样式 */
.login-type-switch {
  display: flex;
  background: #f7fafc;
  border-radius: 8px;
  padding: 4px;
  margin-bottom: 20px;
}

.switch-btn {
  flex: 1;
  padding: 10px;
  border: none;
  background: transparent;
  color: #718096;
  font-size: 14px;
  font-weight: 500;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.switch-btn.active {
  background: white;
  color: #667eea;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
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
  border: 2px solid #e1e5e9;
  border-radius: 8px;
  font-size: 16px;
  transition: all 0.3s ease;
  outline: none;
  max-width: 80%;
}
.sms-input:focus {
  border-color: #667eea;
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.sms-input::placeholder {
  color: #aaa;
}

.sms-btn {
  padding: 12px 16px;
  background: #667eea;
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
  background: #5a67d8;
  transform: translateY(-1px);
}

.sms-btn:disabled {
  background: #a0aec0;
  cursor: not-allowed;
  transform: none;
}

/* 身份选择弹窗样式 */
.role-dialog-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.role-dialog {
  background: white;
  border-radius: 16px;
  padding: 32px;
  max-width: 400px;
  width: 90%;
  position: relative;
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.25);
  animation: slideIn 0.3s ease-out;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.role-dialog-title {
  text-align: center;
  margin-bottom: 8px;
  color: #333;
  font-size: 24px;
  font-weight: 600;
}

.role-dialog-subtitle {
  text-align: center;
  color: #666;
  font-size: 14px;
  margin-bottom: 24px;
}

.role-buttons {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.role-btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 24px 16px;
  border: 2px solid #e1e5e9;
  border-radius: 12px;
  background: white;
  cursor: pointer;
  transition: all 0.3s ease;
  text-align: center;
}

.role-btn:hover {
  border-color: #667eea;
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.15);
}

.role-icon {
  font-size: 48px;
  margin-bottom: 12px;
}

.role-btn span {
  font-size: 18px;
  font-weight: 600;
  color: #333;
  margin-bottom: 8px;
}

.role-btn small {
  font-size: 12px;
  color: #666;
  line-height: 1.4;
}

.merchant-btn {
  border-color: #48bb78;
}

.merchant-btn:hover {
  border-color: #38a169;
  background: #f0fff4;
}

.customer-btn {
  border-color: #4299e1;
}

.customer-btn:hover {
  border-color: #3182ce;
  background: #ebf8ff;
}

.role-dialog-close {
  position: absolute;
  top: 16px;
  right: 16px;
  background: none;
  border: none;
  font-size: 24px;
  color: #999;
  cursor: pointer;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.role-dialog-close:hover {
  background: #f7fafc;
  color: #333;
}

@media (max-width: 480px) {
  .login-container {
    padding: 10px;
  }

  .login-box {
    padding: 30px 20px;
  }

  .login-title {
    font-size: 24px;
  }

  .role-dialog {
    padding: 24px 20px;
  }

  .role-dialog-title {
    font-size: 20px;
  }

  .role-icon {
    font-size: 36px;
  }

  .role-btn {
    padding: 20px 16px;
  }
}

/* 申诉弹窗样式 */
.appeal-dialog-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.appeal-dialog {
  background: white;
  border-radius: 12px;
  padding: 32px;
  width: 90%;
  max-width: 500px;
  position: relative;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  animation: slideIn 0.3s ease-out;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.appeal-dialog-title {
  font-size: 24px;
  font-weight: 700;
  color: #2d3748;
  margin-bottom: 20px;
  text-align: center;
}

.ban-info {
  background-color: #f8f9fa;
  border: 1px solid #e9ecef;
  border-radius: 8px;
  padding: 16px;
  margin-bottom: 20px;
}

.ban-info p {
  margin: 8px 0;
  color: #495057;
}

.ban-info strong {
  color: #212529;
  font-weight: 600;
}

.appeal-question {
  font-size: 18px;
  color: #495057;
  text-align: center;
  margin-bottom: 24px;
  font-weight: 500;
}

.appeal-buttons {
  display: flex;
  gap: 16px;
  justify-content: center;
}

.appeal-btn {
  padding: 12px 24px;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  min-width: 120px;
}

.appeal-btn.primary {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.appeal-btn.primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(102, 126, 234, 0.4);
}

.appeal-btn.secondary {
  background-color: #e9ecef;
  color: #495057;
}

.appeal-btn.secondary:hover {
  background-color: #dee2e6;
}

.appeal-dialog-close {
  position: absolute;
  top: 16px;
  right: 16px;
  background: none;
  border: none;
  font-size: 24px;
  color: #999;
  cursor: pointer;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.appeal-dialog-close:hover {
  background: #f7fafc;
  color: #333;
}

@media (max-width: 480px) {
  .appeal-dialog {
    padding: 24px 20px;
    width: 95%;
  }

  .appeal-dialog-title {
    font-size: 20px;
  }

  .appeal-buttons {
    flex-direction: column;
  }

  .appeal-btn {
    width: 100%;
  }
}
</style>