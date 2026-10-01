<template>
  <div class="merchant-application-container">
    <div class="application-box">
      <div class="application-header">
        <h2 class="application-title">店铺申请</h2>
        <p class="application-subtitle">请完善您的店铺信息，我们将尽快审核</p>
        <div class="progress-bar">
          <div class="progress-fill" :style="{ width: progress + '%' }"></div>
          <span class="progress-text">{{ progress }}%</span>
        </div>
      </div>

      <form @submit.prevent="handleSubmit" class="application-form" novalidate>
        <!-- 店铺基本信息 -->
        <div class="form-section">
          <h3 class="section-title">🏪 店铺基本信息</h3>

          <div class="form-group">
            <label for="shopName">店铺名称 *</label>
            <input
              id="shopName"
              v-model="applicationForm.shopName"
              type="text"
              placeholder="请输入店铺名称"
              class="form-input"
              required
            />
            <span v-if="errors.shopName" class="error-message">{{ errors.shopName }}</span>
          </div>

          <div class="form-group">
            <label for="shopType">店铺类型 *</label>
            <select
              id="shopType"
              v-model="applicationForm.shopType"
              class="form-select"
              required
            >
              <option value="">请选择店铺类型</option>
              <option value="restaurant">餐厅</option>
              <option value="fast_food">快餐店</option>
              <option value="cafe">咖啡厅</option>
              <option value="dessert">甜品店</option>
              <option value="drink">饮品店</option>
              <option value="other">其他</option>
            </select>
            <span v-if="errors.shopType" class="error-message">{{ errors.shopType }}</span>
          </div>

          <div class="form-group">
            <label for="businessLicense">营业执照号 *</label>
            <input
              id="businessLicense"
              v-model="applicationForm.businessLicense"
              type="text"
              placeholder="请输入营业执照号"
              class="form-input"
              required
            />
            <span v-if="errors.businessLicense" class="error-message">{{ errors.businessLicense }}</span>
          </div>

          <div class="form-group">
            <label for="phone">联系电话 *</label>
            <input
              id="phone"
              v-model="applicationForm.phone"
              type="tel"
              placeholder="请输入店铺联系电话"
              class="form-input"
              required
            />
            <span v-if="errors.phone" class="error-message">{{ errors.phone }}</span>
          </div>

          <div class="form-group">
            <label for="address">店铺地址 *</label>
            <textarea
              id="address"
              v-model="applicationForm.address"
              placeholder="请输入详细地址"
              class="form-textarea"
              rows="3"
              required
            ></textarea>
            <span v-if="errors.address" class="error-message">{{ errors.address }}</span>
          </div>

          <div class="form-group">
            <label for="businessHours">营业时间 *</label>
            <input
              id="businessHours"
              v-model="applicationForm.businessHours"
              type="text"
              placeholder="例如：09:00-22:00"
              class="form-input"
              required
            />
            <span v-if="errors.businessHours" class="error-message">{{ errors.businessHours }}</span>
          </div>

          <div class="form-group">
            <label for="description">店铺简介</label>
            <textarea
              id="description"
              v-model="applicationForm.description"
              placeholder="请简单介绍您的店铺特色"
              class="form-textarea"
              rows="4"
            ></textarea>
            <span v-if="errors.description" class="error-message">{{ errors.description }}</span>
          </div>
        </div>

        <!-- 证明文件上传 -->
        <div class="form-section">
          <h3 class="section-title">📄 证明文件</h3>

          <div class="upload-section">
            <div class="upload-item">
              <label class="upload-label">
                <div class="upload-area" :class="{ 'has-file': applicationForm.licenseFile }">
                  <div v-if="applicationForm.licenseFile" class="upload-preview">
                    <span class="file-name">{{ applicationForm.licenseFile.name }}</span>
                    <button type="button" class="remove-file" @click.stop="removeFile('license')">×</button>
                  </div>
                  <div v-else class="upload-placeholder">
                    <span class="upload-icon">📄</span>
                    <span class="upload-text">点击上传营业执照</span>
                    <small class="upload-hint">支持JPG、PNG格式，大小不超过5MB</small>
                  </div>
                </div>
                <input
                  type="file"
                  ref="licenseInput"
                  @change="handleFileUpload('license', $event)"
                  accept="image/*"
                  style="display: none"
                />
              </label>
              <span v-if="errors.licenseFile" class="error-message">{{ errors.licenseFile }}</span>
            </div>

            <div class="upload-item">
              <label class="upload-label">
                <div class="upload-area" :class="{ 'has-file': applicationForm.idFile }">
                  <div v-if="applicationForm.idFile" class="upload-preview">
                    <span class="file-name">{{ applicationForm.idFile.name }}</span>
                    <button type="button" class="remove-file" @click.stop="removeFile('id')">×</button>
                  </div>
                  <div v-else class="upload-placeholder">
                    <span class="upload-icon">🆔</span>
                    <span class="upload-text">点击上传身份证照片</span>
                    <small class="upload-hint">支持JPG、PNG格式，大小不超过5MB</small>
                  </div>
                </div>
                <input
                  type="file"
                  ref="idInput"
                  @change="handleFileUpload('id', $event)"
                  accept="image/*"
                  style="display: none"
                />
              </label>
              <span v-if="errors.idFile" class="error-message">{{ errors.idFile }}</span>
            </div>
          </div>
        </div>

        <!-- 提交按钮 -->
        <div class="form-actions">
          <button type="button" class="save-btn" @click="saveDraft" :disabled="isLoading">
            {{ isLoading ? '保存中...' : '保存草稿' }}
          </button>
          <button type="submit" class="submit-btn" :disabled="isLoading">
            {{ isLoading ? '提交中...' : '提交申请' }}
          </button>
          <button type="button" class="cancel-btn" @click="goBack">
            返回
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted,watch } from 'vue'
import { useRouter ,useRoute} from 'vue-router'

const router = useRouter()
const route  = useRoute()

const isLoading = ref(false)
const licenseInput = ref(null)
const idInput = ref(null)
const editingApplicationId = ref(false)

const applicationForm = reactive({
  shopName: '',
  shopType: '',
  businessLicense: '',
  phone: '',
  address: '',
  businessHours: '',
  description: '',
  licenseFile: null,
  idFile: null
})

const errors = reactive({
  shopName: '',
  shopType: '',
  businessLicense: '',
  phone: '',
  address: '',
  businessHours: '',
  description: '',
  licenseFile: '',
  idFile: ''
})

// 计算进度
const progress = computed(() => {

  let filledFields = 0
  const totalFields = 8

  // 显式访问每个响应式属性，确保依赖追踪
  const form = applicationForm
  
  if (form.shopName && form.shopName.trim()) filledFields++
  if (form.shopType && form.shopType.trim()) filledFields++
  if (form.businessLicense && form.businessLicense.trim()) filledFields++
  if (form.phone && form.phone.trim()) filledFields++
  if (form.address && form.address.trim()) filledFields++
  if (form.businessHours && form.businessHours.trim()) filledFields++
  if (form.licenseFile) filledFields++
  if (form.idFile) filledFields++

  return Math.round((filledFields / totalFields) * 100)
})

// 处理文件上传（只保存文件对象，不立即上传）
const handleFileUpload = (type, event) => {
  const file = event.target.files[0]
  if (!file) return

  // 验证文件类型
  if (!file.type.startsWith('image/')) {
    errors[`${type}File`] = '请上传图片文件'
    return
  }

  // 验证文件大小（5MB）
  if (file.size > 5 * 1024 * 1024) {
    errors[`${type}File`] = '文件大小不能超过5MB'
    return
  }

  // 创建本地预览URL
  const previewUrl = URL.createObjectURL(file)

  // 保存文件对象和预览URL
  applicationForm[`${type}File`] = {
    name: file.name,
    file: file,
    previewUrl: previewUrl,
    size: file.size
  }
  errors[`${type}File`] = ''
}

// 移除文件
const removeFile = (type) => {
  // 清理预览URL
  const fileObj = applicationForm[`${type}File`]
  if (fileObj && fileObj.previewUrl) {
    URL.revokeObjectURL(fileObj.previewUrl)
  }
  applicationForm[`${type}File`] = null
  errors[`${type}File`] = ''
  if (type === 'license') {
    licenseInput.value.value = ''
  } else if (type === 'id') {
    idInput.value.value = ''
  }
}

const normalizePhone = (value) => String(value || '').replace(/[\s-]/g, '')

const normalizeBusinessLicense = (value) => String(value || '').trim().toUpperCase()

const parseTimeToMinutes = (timeStr) => {
  const match = /^([0-1]?\d|2[0-3]):([0-5]\d)$/.exec(String(timeStr || '').trim())
  if (!match) return null
  const hour = Number(match[1])
  const minute = Number(match[2])
  return hour * 60 + minute
}

const validateBusinessHours = (value) => {
  const raw = String(value || '').trim()
  if (!raw) return { ok: false, message: '请输入营业时间' }

  // 兼容 StoreInfo 的解析方式：opening_hours 会被 split('-') 拆成 [open, close]
  // 因此这里只允许单段 HH:mm-HH:mm，且连接符必须是普通 '-'。
  if (/[;,，；、]/.test(raw)) {
    return { ok: false, message: '营业时间仅支持单段格式：09:00-22:00' }
  }

  if (/[–—~～]/.test(raw)) {
    return { ok: false, message: '营业时间请使用 "-" 连接，例如 09:00-22:00' }
  }

  const parts = raw.split('-')
  if (parts.length !== 2) {
    return { ok: false, message: '营业时间格式错误，应为 09:00-22:00' }
  }

  const startStr = parts[0].trim()
  const endStr = parts[1].trim()
  const startMin = parseTimeToMinutes(startStr)
  const endMin = parseTimeToMinutes(endStr)
  if (startMin === null || endMin === null) {
    return { ok: false, message: '营业时间格式错误，应为 HH:mm-HH:mm，例如 09:00-22:00' }
  }

  // 当前规则：不支持跨日营业
  if (endMin <= startMin) {
    return { ok: false, message: '营业时间结束需晚于开始（当前不支持跨日）' }
  }

  return { ok: true }
}

// 验证表单
const validateForm = () => {
  let isValid = true

  // 清空之前的错误
  Object.keys(errors).forEach(key => {
    errors[key] = ''
  })

  // 验证店铺名称
  const shopName = String(applicationForm.shopName || '').trim()
  if (!shopName) {
    errors.shopName = '请输入店铺名称'
    isValid = false
  } else if (shopName.length < 2 || shopName.length > 50) {
    errors.shopName = '店铺名称长度需为2-50个字符'
    isValid = false
  }

  // 验证店铺类型
  if (!applicationForm.shopType) {
    errors.shopType = '请选择店铺类型'
    isValid = false
  }

  // 验证营业执照号
  const businessLicense = normalizeBusinessLicense(applicationForm.businessLicense)
  if (!businessLicense) {
    errors.businessLicense = '请输入营业执照号'
    isValid = false
  } else if (!/^[0-9A-Z]{15,18}$/.test(businessLicense)) {
    errors.businessLicense = '营业执照号格式不正确（建议15-18位数字/大写字母）'
    isValid = false
  }

  // 验证联系电话
  const phone = normalizePhone(applicationForm.phone)
  if (!phone) {
    errors.phone = '请输入联系电话'
    isValid = false
  } else if (!/^1[3-9]\d{9}$/.test(phone)) {
    errors.phone = '请输入正确的手机号格式'
    isValid = false
  }

  // 验证地址
  const address = String(applicationForm.address || '').trim()
  if (!address) {
    errors.address = '请输入店铺地址'
    isValid = false
  } else if (address.length < 5 || address.length > 200) {
    errors.address = '店铺地址长度需为5-200个字符'
    isValid = false
  }

  // 验证营业时间
  const businessHours = String(applicationForm.businessHours || '').trim()
  const hoursCheck = validateBusinessHours(businessHours)
  if (!hoursCheck.ok) {
    errors.businessHours = hoursCheck.message
    isValid = false
  }

  // 店铺简介（可选）
  const description = String(applicationForm.description || '').trim()
  if (description && description.length > 300) {
    isValid = false
    errors.description = '店铺简介最多300字'
  }

  // 验证营业执照文件
  if (!applicationForm.licenseFile) {
    errors.licenseFile = '请上传营业执照'
    isValid = false
  }

  // 验证身份证文件
  if (!applicationForm.idFile) {
    errors.idFile = '请上传身份证照片'
    isValid = false
  }

  return isValid
}

// 保存草稿
const saveDraft = async () => {
  try {
    isLoading.value = true

    const token = localStorage.getItem('token')
    if (!token) {
      router.push('/login')
      return
    }

    // 上传文件
    const formData = await prepareFormData(applicationForm, 'draft')

    const headers = {
      'Authorization': `Bearer ${token}`
    }

    // 如果是编辑模式，更新申请
    if (editingApplicationId.value) {
      const response = await fetch(`/api/merchant-application/${editingApplicationId.value}`, {
        method: 'PUT',
        headers,
        body: formData
      })

      if (response.ok) {
        alert('草稿已保存')
      } else {
        alert('保存失败，请稍后重试')
      }
    } else {
      // 创建新的申请
      const response = await fetch('/api/merchant-application', {
        method: 'POST',
        headers,
        body: formData
      })

      if (response.ok) {
        const data = await response.json()
        editingApplicationId.value = data.data.id
        alert('草稿已保存')
      } else {
        alert('保存失败，请稍后重试')
      }
    }
  } catch (error) {
    console.error('保存草稿失败:', error)
    alert('保存失败，请稍后重试')
  } finally {
    isLoading.value = false
  }
}

// 提交申请
const handleSubmit = async () => {
  if (!validateForm()) {
    alert('请检查表单是否填写正确')
    return
  }

  isLoading.value = true

  try {
    const token = localStorage.getItem('token')
    if (!token) {
      router.push('/login')
      return
    }

    // 上传文件
    const formData = await prepareFormData(applicationForm, 'submitted')

    const headers = {
      'Authorization': `Bearer ${token}`
    }

    // 如果是编辑模式，更新申请并设置为提交状态
    if (editingApplicationId.value) {
      const response = await fetch(`/api/merchant-application/${editingApplicationId.value}`, {
        method: 'PUT',
        headers,
        body: formData
      })

      if (response.ok) {
        alert('店铺申请提交成功！我们将在3个工作日内完成审核')
        history.back()
      } else {
        alert('提交失败，请稍后重试')
      }
    } else {
      // 创建新的申请并直接提交
      const response = await fetch('/api/merchant-application', {
        method: 'POST',
        headers,
        body: formData
      })

      if (response.ok) {
        const data = await response.json()
        editingApplicationId.value = data.data.id
        alert('店铺申请提交成功！我们将在3个工作日内完成审核')
        history.back()
      } else {
        alert('提交失败，请稍后重试')
      }
    }
  } catch (error) {
    console.error('提交失败:', error)
    alert('提交失败，请稍后重试')
  } finally {
    isLoading.value = false
  }
}

// 准备FormData，包含文件上传
async function prepareFormData(form, status) {
  const formData = new FormData()

  // 添加文本字段
  formData.append('shopName', String(form.shopName || '').trim())
  formData.append('shopType', String(form.shopType || '').trim())
  formData.append('businessLicense', normalizeBusinessLicense(form.businessLicense))
  formData.append('phone', normalizePhone(form.phone))
  formData.append('address', String(form.address || '').trim())
  formData.append('businessHours', String(form.businessHours || '').trim())
  formData.append('description', String(form.description || '').trim())
  formData.append('status', status)

  if (form.licenseFile && form.licenseFile.file) {
       const licenseResponse = await uploadFile(form.licenseFile.file, 'license')
       formData.append('licenseFile', licenseResponse)
       }
  if (form.idFile && form.idFile.file) {
       const idResponse = await uploadFile(form.idFile.file, 'id')
       formData.append('idFile', idResponse)
       }

  return formData
}

// 单独上传文件
async function uploadFile(file, fileType) {
      const token = localStorage.getItem('token')
      if (!token) {
       throw new Error('用户未登录')
       }
       
      const uploadFormData = new FormData()
      uploadFormData.append('file', file)
      uploadFormData.append('file_type', fileType)

      const response = await fetch('/api/merchant/upload', {
      method: 'POST',
       headers: {
       'Authorization': `Bearer ${token}`
       },
       body: uploadFormData
       })

       if (response.ok) {
          const data = await response.json()
        return data.url
       } else {
          throw new Error('文件上传失败')
        }
      }

// 返回
const goBack = () => {
  if (confirm('确定要返回？未保存的信息将会丢失。')) {
    history.back();
  }
}

// 加载现有的申请数据（用于编辑）

onMounted(() => {
  const query = route.query
  const id = query.id
  const edit = query.edit
  if (id && edit) {
    editingApplicationId.value = parseInt(id)
    loadApplicationData()
  }
  else{

  }
})

async function loadApplicationData() {
  try {
    const token = localStorage.getItem('token')
    if (!token) {
      router.push('/login')
      return
    }

    const headers = {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    }

    const response = await fetch(`/api/merchant-application/${editingApplicationId.value}`, { headers })
    if (response.ok) {
      const data = await response.json()
      const app = data.data

      // 填充表单数据
      applicationForm.shopName = app.shop_name
      applicationForm.shopType = app.shop_type
      applicationForm.businessLicense = app.business_license
      applicationForm.phone = app.phone
      applicationForm.address = app.address
      applicationForm.businessHours = app.business_hours
      applicationForm.description = app.description
      applicationForm.licenseFile = app.license_file_url ? { name: '营业执照.jpg' } : null
      applicationForm.idFile = app.id_file_url ? { name: '身份证.jpg' } : null

    } else {
      console.error('获取申请数据失败')
      router.push('/messages')
    }
  } catch (error) {
    console.error('加载申请数据失败:', error)
    router.push('/messages')
  }
}

</script>

<style scoped>
.merchant-application-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px;
}

.application-box {
  background: white;
  padding: 40px;
  border-radius: 16px;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 800px;
  max-height: 90vh;
  overflow-y: auto;
}

.application-header {
  text-align: center;
  margin-bottom: 40px;
}

.application-title {
  font-size: 32px;
  color: #333;
  margin-bottom: 12px;
  font-weight: 600;
}

.application-subtitle {
  color: #666;
  font-size: 16px;
  margin-bottom: 24px;
}

.progress-bar {
  background: #f1f5f9;
  border-radius: 20px;
  height: 8px;
  position: relative;
  margin-bottom: 8px;
}

.progress-fill {
  background: linear-gradient(90deg, #48bb78 0%, #38a169 100%);
  height: 100%;
  border-radius: 20px;
  transition: width 0.3s ease;
}

.progress-text {
  position: absolute;
  top: -20px;
  right: 0;
  font-size: 12px;
  font-weight: 600;
  color: #48bb78;
}

.application-form {
  display: flex;
  flex-direction: column;
  gap: 32px;
}

.form-section {
  border-bottom: 1px solid #e2e8f0;
  padding-bottom: 24px;
}

.form-section:last-child {
  border-bottom: none;
}

.section-title {
  font-size: 20px;
  color: #333;
  margin-bottom: 20px;
  font-weight: 600;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 20px;
}

.form-group label {
  color: #555;
  font-weight: 500;
  font-size: 14px;
}

.form-input,
.form-select,
.form-textarea {
  padding: 12px 16px;
  border: 2px solid #e1e5e9;
  border-radius: 8px;
  font-size: 16px;
  transition: all 0.3s ease;
  outline: none;
}

.form-input:focus,
.form-select:focus,
.form-textarea:focus {
  border-color: #667eea;
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.form-textarea {
  resize: vertical;
  min-height: 100px;
}

.error-message {
  color: #e74c3c;
  font-size: 12px;
  margin-top: 4px;
}

/* 文件上传样式 */
.upload-section {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.upload-item {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.upload-label {
  cursor: pointer;
}

.upload-area {
  border: 2px dashed #cbd5e0;
  border-radius: 8px;
  padding: 24px;
  text-align: center;
  transition: all 0.3s ease;
  position: relative;
  background: #f8fafc;
}

.upload-area:hover {
  border-color: #667eea;
  background: #f0f7ff;
}

.upload-area.has-file {
  border-color: #48bb78;
  background: #f0fff4;
}

.upload-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
}

.upload-icon {
  font-size: 32px;
}

.upload-text {
  font-size: 16px;
  font-weight: 500;
  color: #333;
}

.upload-hint {
  font-size: 12px;
  color: #666;
}

.upload-preview {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 12px;
  background: rgba(72, 187, 120, 0.1);
  border-radius: 6px;
}

.file-name {
  font-size: 14px;
  color: #333;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 200px;
}

.remove-file {
  background: none;
  border: none;
  color: #e74c3c;
  font-size: 18px;
  cursor: pointer;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.remove-file:hover {
  background: #fee;
}

/* 表单操作按钮 */
.form-actions {
  display: flex;
  gap: 12px;
  justify-content: center;
  margin-top: 32px;
}

.save-btn,
.submit-btn,
.cancel-btn {
  padding: 12px 24px;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  min-width: 120px;
}

.save-btn {
  background: #e2e8f0;
  color: #4a5568;
  border: 2px solid #e2e8f0;
}

.save-btn:hover:not(:disabled) {
  background: #cbd5e0;
  border-color: #cbd5e0;
}

.submit-btn {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
}

.submit-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
}

.cancel-btn {
  background: white;
  color: #e53e3e;
  border: 2px solid #feb2b2;
}

.cancel-btn:hover {
  background: #fff5f5;
  border-color: #fc8181;
}

.save-btn:disabled,
.submit-btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  transform: none;
}

@media (max-width: 768px) {
  .application-box {
    padding: 24px;
    margin: 10px;
  }

  .application-title {
    font-size: 24px;
  }

  .upload-area {
    padding: 16px;
  }

  .form-actions {
    flex-direction: column;
  }

  .save-btn,
  .submit-btn,
  .cancel-btn {
    width: 100%;
  }
}

@media (max-width: 480px) {
  .application-box {
    padding: 20px 16px;
  }

  .upload-preview {
    flex-direction: column;
    gap: 8px;
    align-items: flex-start;
  }

  .file-name {
    max-width: 100%;
  }
}
</style>