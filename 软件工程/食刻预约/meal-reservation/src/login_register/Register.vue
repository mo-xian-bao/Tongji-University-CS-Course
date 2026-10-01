<template>
  <div class="register-container">
    <div class="register-box">
      <h2 class="register-title">注册</h2>

      <form @submit.prevent="handleRegister" class="register-form">
        <!-- 身份选择 -->
        <div class="form-group">
          <label>注册身份</label>
          <div class="role-selection">
            <label class="role-option">
              <input
                type="radio"
                v-model="registerForm.userType"
                value="customer"
                class="role-radio"
              />
              <span class="role-text">个人用户</span>
              <small>浏览美食、下单购买</small>
            </label>
            
            <label  class="role-option">
              <input
                type="radio"
                v-model="registerForm.userType"
                value="merchant"
                class="role-radio"
              />
              <span class="role-text">商家用户</span>
              <small>开店营业、管理店铺</small>
            </label>
           

          </div>
          <span v-if="errors.userType" class="error-message">{{ errors.userType }}</span>
        </div>

        <div class="form-group">
          <label for="phone">手机号</label>
          <input
            id="phone"
            v-model="registerForm.phone"
            type="tel"
            placeholder="请输入手机号"
            :class="['form-input', checkResults.phone.available ? 'valid' : '', errors.phone ? 'error' : '']"
            @input="updatePunctually"
            required
          />
          <div class="validation-status">
            <span v-if="isCheckingDuplicate && registerForm.phone" class="checking-status">检查中...</span>
            <span v-else-if="checkResults.phone.message" :class="['validation-message', checkResults.phone.available ? 'available' : 'unavailable']">
              {{ checkResults.phone.message }}
            </span>
          </div>
          <span v-if="errors.phone" class="error-message">{{ errors.phone }}</span>
        </div>

        <div class="form-group">
          <label for="username">用户名</label>
          <input
            id="username"
            v-model="registerForm.username"
            type="text"
            placeholder="请输入用户名"
            :class="['form-input', checkResults.username.available ? 'valid' : '', errors.username ? 'error' : '']"
            @input="updatePunctually"
            required
          />
          <div class="validation-status">
            <span v-if="isCheckingDuplicate && registerForm.username" class="checking-status">检查中...</span>
            <span v-else-if="checkResults.username.message" :class="['validation-message', checkResults.username.available ? 'available' : 'unavailable']">
              {{ checkResults.username.message }}
            </span>
          </div>
          <span v-if="errors.username" class="error-message">{{ errors.username }}</span>
        </div>

        <div class="form-group">
          <label for="password">密码</label>
          <input
            id="password"
            v-model="registerForm.password"
            type="password"
            placeholder="请输入密码（至少6位）"
            class="form-input"
            required
          />
          <span v-if="errors.password" class="error-message">{{ errors.password }}</span>
        </div>

        <div class="form-group">
          <label for="confirmPassword">确认密码</label>
          <input
            id="confirmPassword"
            v-model="registerForm.confirmPassword"
            type="password"
            placeholder="请再次输入密码"
            class="form-input"
            required
          />
          <span v-if="errors.confirmPassword" class="error-message">{{ errors.confirmPassword }}</span>
        </div>

        <div class="form-group">
          <label for="smsCode">短信验证码</label>
          <div class="sms-input-group">
            <input
              id="smsCode"
              v-model="registerForm.smsCode"
              type="text"
              placeholder="请输入6位验证码"
              class="form-input sms-input"
              maxlength="6"
              required
            />
            <button
              type="button"
              class="sms-btn"
              :disabled="!canSendSms || smsCountdown > 0 "
              @click="sendSmsCode"
            >
              <span v-if="isCheckingDuplicate" class="checking-btn">检查中...</span>
              <span v-else>{{ smsCountdown > 0 ? `${smsCountdown}s后重发` : '发送验证码' }}</span>
            </button>
          </div>
          <span v-if="errors.smsCode" class="error-message">{{ errors.smsCode }}</span>
        </div>

        <button type="submit" class="register-btn" :disabled="isLoading">
          {{ isLoading ? '注册中...' : '注册' }}
        </button>
      </form>

      <div class="login-link">
        <span>已有账号？</span>
        <router-link to="/login" class="link">立即登录</router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
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
    } else {
      router.push('/shop')
    }
  }
}

const isLoading = ref(false)
const smsCountdown = ref(0)
const registerForm = reactive({
  userType: 'customer', // 默认为个人用户
  phone: '',
  username: '',
  password: '',
  confirmPassword: '',
  smsCode: ''
})

const errors = reactive({
  userType: '',
  phone: '',
  username: '',
  password: '',
  confirmPassword: '',
  smsCode: ''
})

// 计算属性：是否可以发送短信
const canSendSms = ref(false)
const isCheckingDuplicate = ref(false) // 检查重复状态
const checkResults = reactive({
  phone: { valid: false, available: false, message: '' },
  username: { valid: false, available: false, message: '' }
})

// 检查表单完整性
const isFormComplete = computed(() => {
  return validatePhone(registerForm.phone) &&
         registerForm.username.length >= 2 &&
         registerForm.password.length >= 6 &&
         registerForm.password === registerForm.confirmPassword &&
         registerForm.userType
})

// 监听手机号变化，更新发送按钮状态
const validatePhoneForSms = () => {
  canSendSms.value =  checkResults.phone.available && validatePhone(registerForm.phone)
}

const updatePunctually = () => {
  validatePhoneForSms()

  // 实时检查手机号和用户名
  if (registerForm.phone) {
    checkPhoneAvailability()
  }
  if (registerForm.username) {
    checkUsernameAvailability()
  }
}

// 检查手机号是否可用
async function checkPhoneAvailability() {
  if (!validatePhone(registerForm.phone)) {
    checkResults.phone = { valid: false, available: false, message: '请输入正确的手机号格式' }
    return
  }

  isCheckingDuplicate.value = true
  try {
    const response = await fetch(`/api/check-phone?phone=${registerForm.phone}`)
    const result = await response.json()

    if (result.success) {
      checkResults.phone = { valid: true, available: result.data.available, message: result.data.available ? '手机号可用' : '手机号已被注册' }
    } else {
      checkResults.phone = { valid: false, available: false, message: result.message || '检查失败' }
    }
  } catch (error) {
    console.error('检查手机号失败:', error)
    checkResults.phone = { valid: false, available: false, message: '网络错误' }
  } finally {
    isCheckingDuplicate.value = false
    validatePhoneForSms()
  }
}

// 检查用户名是否可用
async function checkUsernameAvailability() {
  if (registerForm.username.length < 2) {
    checkResults.username = { valid: false, available: false, message: '用户名至少需要2个字符' }
    return
  }

  isCheckingDuplicate.value = true
  try {
    const response = await fetch(`/api/check-username?username=${registerForm.username}`)
    const result = await response.json()

    if (result.success) {
      checkResults.username = { valid: true, available: result.data.available, message: result.data.available ? '用户名可用' : '用户名已被使用' }
    } else {
      checkResults.username = { valid: false, available: false, message: result.message || '检查失败' }
    }
  } catch (error) {
    console.error('检查用户名失败:', error)
    checkResults.username = { valid: false, available: false, message: '网络错误' }
  } finally {
    isCheckingDuplicate.value = false
    validatePhoneForSms()
  }
}

const validatePhone = (phone) => {
  const phoneRegex = /^1[3-9]\d{9}$/
  return phoneRegex.test(phone)
}

const validateForm = () => {
  let isValid = true

  // 清空之前的错误
  Object.keys(errors).forEach(key => {
    errors[key] = ''
  })

  // 验证身份选择
  if (!registerForm.userType) {
    errors.userType = '请选择注册身份'
    isValid = false
  }

  // 验证手机号
  if (!validatePhone(registerForm.phone)) {
    errors.phone = '请输入正确的手机号格式'
    isValid = false
  } else if (!checkResults.phone.available) {
    errors.phone = checkResults.phone.message
    isValid = false
  }

  // 验证用户名
  if (registerForm.username.length < 2) {
    errors.username = '用户名至少需要2个字符'
    isValid = false
  } else if (!checkResults.username.available) {
    errors.username = checkResults.username.message
    isValid = false
  }

  // 验证密码
  if (registerForm.password.length < 6) {
    errors.password = '密码至少需要6个字符'
    isValid = false
  }

  // 验证确认密码
  if (registerForm.password !== registerForm.confirmPassword) {
    errors.confirmPassword = '两次输入的密码不一致'
    isValid = false
  }

  return isValid
}

// 发送短信验证码
const sendSmsCode = async () => {
  // 首先检查表单是否完整
  if (!validateForm()) {
    return
  }

  // 检查手机号和用户名是否都通过了验证
  if (!checkResults.phone.available) {
    alert(checkResults.phone.message || '手机号不可用')
    return
  }

  if (!checkResults.username.available) {
    alert(checkResults.username.message || '用户名不可用')
    return
  }

  try {
    const response = await fetch('/api/sms/send', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        phone: registerForm.phone,
        purpose: 'register'
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

const handleRegister = async () => {
  if (!validateForm()) {
    return
  }
    // 验证短信验证码
  if (!registerForm.smsCode || registerForm.smsCode.length !== 6) {
    errors.smsCode = '请输入6位短信验证码'
    return
  }
  isLoading.value = true

  try {
    // 调用后端注册API
    const response = await fetch('/api/register', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(registerForm)
    })

    const result = await response.json()

    if (result.success) {
      localStorage.setItem('token', result.data.token)
      localStorage.setItem('user', JSON.stringify(result.data.user))
      // 注册成功，根据身份跳转
      if (registerForm.userType === 'merchant') {
        // 商家注册成功，跳转到店铺申请页面
        alert('注册成功！请完善店铺信息')
        router.push('/merchant-application');
      } else {
        // 个人用户注册成功
        alert('注册成功！')
        router.push('/shop')
      }
    } else {
      // 注册失败，显示错误信息
      alert(result.message || '注册失败')

      // 如果后端返回了具体的字段错误，可以显示对应错误信息
      if (result.message.includes('手机号')) {
        errors.phone = result.message
      } else if (result.message.includes('用户名')) {
        errors.username = result.message
      } else if (result.message.includes('密码')) {
        errors.password = result.message
      }
    }

  } catch (error) {
    console.error('注册失败:', error)
    alert('网络错误，请稍后重试')
  } finally {
    isLoading.value = false
  }
}
</script>

<style scoped>
.register-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px;
}

.register-box {
  background: white;
  padding: 40px;
  border-radius: 12px;
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 400px;
}

.register-title {
  text-align: center;
  margin-bottom: 30px;
  color: #333;
  font-size: 28px;
  font-weight: 600;
}

.register-form {
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

/* 身份选择样式 */
.role-selection {
  display: flex;
  gap: 16px;
  margin-top: 8px;
}

.role-option {
  flex: 1;
  position: relative;
  cursor: pointer;
  padding: 16px;
  border: 2px solid #e1e5e9;
  border-radius: 8px;
  transition: all 0.3s ease;
  text-align: center;
  background: white;
}

.role-option:hover {
  border-color: #667eea;
  background: #f7fafc;
}

.role-radio {
  position: absolute;
  opacity: 0;
}

.role-text {
  display: block;
  font-size: 16px;
  font-weight: 600;
  color: #333;
  margin-bottom: 4px;
}

.role-option small {
  display: block;
  font-size: 12px;
  color: #666;
  line-height: 1.3;
}

.role-option input[type="radio"]:checked + 
.role-text {
  color: #667eea;
}


.role-option input[type="radio"]:checked ~ * 
{
  border-color: #667eea;
  background: #f7fafc;
}

/* 保持其他现有样式 */
.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
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

.form-input.valid {
  border-color: #27ae60;
}

.form-input.error {
  border-color: #e74c3c;
}

.validation-status {
  margin-top: 4px;
  min-height: 18px;
}

.checking-status {
  font-size: 12px;
  color: #f39c12;
  font-style: italic;
}

.validation-message {
  font-size: 12px;
  margin-top: 2px;
}

.validation-message.available {
  color: #27ae60;
}

.validation-message.unavailable {
  color: #e74c3c;
}

.error-message {
  color: #e74c3c;
  font-size: 12px;
  margin-top: 4px;
}

.register-btn {
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

.register-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
}

.register-btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  transform: none;
}

.login-link {
  text-align: center;
  margin-top: 25px;
  color: #666;
  font-size: 14px;
}

.login-link .link {
  color: #667eea;
  text-decoration: none;
  font-weight: 600;
  margin-left: 5px;
  transition: color 0.3s ease;
}

.login-link .link:hover {
  color: #764ba2;
  text-decoration: underline;
}

/* 短信验证码样式 */
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

.checking-btn {
  font-style: italic;
  color: #f39c12;
}

@media (max-width: 480px) {
  .register-container {
    padding: 10px;
  }

  .register-box {
    padding: 30px 20px;
  }

  .register-title {
    font-size: 24px;
  }
}
</style>