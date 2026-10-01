<template>
  <div class="appeal-form-container">
    <div class="appeal-header">
      <h2 class="appeal-title">账号申诉</h2>
      <p class="appeal-subtitle">
        如果您认为账号被误封，可以提交申诉申请，管理员会尽快处理
      </p>
    </div>

    <!-- 封禁信息显示 -->
    <div v-if="banInfo" class="ban-info-card">
      <h3 class="info-title">封禁信息</h3>
      <div class="info-grid">
        <div class="info-item">
          <span class="info-label">封禁原因:</span>
          <span class="info-value">{{ banInfo.ban_reason_text }}</span>
        </div>
        <div class="info-item">
          <span class="info-label">封禁类型:</span>
          <span class="info-value">{{ getBanTypeText(banInfo.ban_type) }}</span>
        </div>
        <div v-if="banInfo.ban_until" class="info-item">
          <span class="info-label">封禁期限:</span>
          <span class="info-value">{{ formatDate(banInfo.ban_until) }}</span>
        </div>
        <div class="info-item">
          <span class="info-label">封禁时间:</span>
          <span class="info-value">{{ formatDate(banInfo.banned_at) }}</span>
        </div>
      </div>
    </div>

    <!-- 申诉表单 -->
    <form @submit.prevent="submitAppeal" class="appeal-form">
      <!-- 申诉类型 -->
      <div class="form-group">
        <label class="form-label">申诉类型 *</label>
        <select
          v-model="appealForm.appeal_type"
          class="form-select"
          required
        >
          <option value="">请选择申诉类型</option>
          <option value="mistake_ban">误封</option>
          <option value="punishment_too_heavy">处罚过重</option>
          <option value="evidence_provided">提供证据证明</option>
          <option value="other">其他</option>
        </select>
      </div>

      <!-- 申诉理由 -->
      <div class="form-group">
        <label class="form-label">申诉理由 *</label>
        <textarea
          v-model="appealForm.appeal_reason"
          class="form-textarea"
          placeholder="请详细描述您的申诉理由..."
          rows="5"
          required
        ></textarea>
      </div>

      <!-- 补充说明 -->
      <div class="form-group">
        <label class="form-label">补充说明</label>
        <textarea
          v-model="appealForm.additional_info"
          class="form-textarea"
          placeholder="可以提供更多详细信息或补充说明..."
          rows="3"
        ></textarea>
      </div>

      <!-- 身份验证 -->
      <div class="form-group">
        <label class="form-label">用户名/手机号 *</label>
        <input
          v-model="appealForm.user_identifier"
          type="text"
          class="form-input"
          placeholder="请输入您的用户名或手机号"
          required
        />
      </div>

      <div class="form-group">
        <label class="form-label">密码 *</label>
        <input
          v-model="appealForm.password"
          type="password"
          class="form-input"
          placeholder="请输入您的密码"
          required
        />
      </div>

      <!-- 联系方式 -->
      <div class="form-group">
        <label class="form-label">联系方式</label>
        <input
          v-model="appealForm.contact_info"
          type="text"
          class="form-input"
          placeholder="请提供您的联系方式（手机号、邮箱等）"
        />
      </div>

      <!-- 附件上传 -->
      <div class="form-group">
        <label class="form-label">申诉材料</label>
        <div class="upload-section">
          <input
            ref="fileInput"
            type="file"
            multiple
            accept=".jpg,.jpeg,.png,.gif,.pdf,.doc,.docx,.txt"
            @change="handleFileSelect"
            style="display: none"
          />
          <button
            type="button"
            class="upload-btn"
            @click="$refs.fileInput.click()"
          >
            <i class="upload-icon">📎</i>
            选择文件
          </button>
          <div class="upload-tips">
            支持上传图片、PDF、Word文档等文件，单个文件不超过10MB
          </div>

          <!-- 已选文件列表 -->
          <div v-if="selectedFiles.length > 0" class="selected-files">
            <div v-for="(file, index) in selectedFiles" :key="index" class="file-item">
              <div class="file-info">
                <span class="file-name">{{ file.name }}</span>
                <span class="file-size">{{ formatFileSize(file.size) }}</span>
              </div>
              <div class="file-actions">
                <button
                  v-if="file.uploadStatus === 'pending'"
                  type="button"
                  class="upload-progress-btn"
                  disabled
                >
                  上传中...
                </button>
                <button
                  v-else-if="file.uploadStatus === 'success'"
                  type="button"
                  class="upload-success-btn"
                  disabled
                >
                  ✓ 已上传
                </button>
                <button
                  v-else-if="file.uploadStatus === 'error'"
                  type="button"
                  class="upload-error-btn"
                  @click="uploadFile(file, index)"
                >
                  重新上传
                </button>
                <button
                  type="button"
                  class="remove-file-btn"
                  @click="removeFile(index)"
                >
                  × 删除
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 提交按钮 -->
      <div class="form-actions">
        <button
          type="button"
          class="cancel-btn"
          @click="$emit('cancel')"
        >
          取消
        </button>
        <button
          type="submit"
          class="submit-btn"
          :disabled="submitting"
        >
          {{ submitting ? '提交中...' : '提交申诉' }}
        </button>
      </div>
    </form>

    <!-- 错误提示 -->
    <div v-if="errorMessage" class="error-message">
      {{ errorMessage }}
    </div>

    <!-- 成功提示 -->
    <div v-if="successMessage" class="success-message">
      {{ successMessage }}
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'AppealForm',
  props: {
    banInfo: {
      type: Object,
      required: true
    }
  },
  emits: ['cancel', 'success'],
  data() {
    return {
      appealForm: {
        user_identifier: '',
        password: '',
        appeal_type: '',
        appeal_reason: '',
        additional_info: '',
        contact_info: '',
        attachments: []
      },
      selectedFiles: [],
      submitting: false,
      errorMessage: '',
      successMessage: ''
    }
  },
  methods: {
    getBanTypeText(type) {
      const typeMap = {
        'permanently': '永久封禁',
        'temporarily': '临时封禁'
      }
      return typeMap[type] || '未知类型'
    },

    formatDate(dateStr) {
      if (!dateStr) return '未知'
      return new Date(dateStr).toLocaleString('zh-CN')
    },

    formatFileSize(bytes) {
      if (!bytes) return '0 B'
      const k = 1024
      const sizes = ['B', 'KB', 'MB', 'GB']
      const i = Math.floor(Math.log(bytes) / Math.log(k))
      return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
    },

    handleFileSelect(event) {
      const files = Array.from(event.target.files)

      // 检查文件大小限制
      const maxSize = 10 * 1024 * 1024 // 10MB
      const validFiles = []

      files.forEach(file => {
        if (file.size > maxSize) {
          this.errorMessage = `文件 ${file.name} 超过10MB限制`
          return
        }

        validFiles.push({
          file,
          name: file.name,
          size: file.size,
          uploadStatus: 'pending',
          path: '',
          type: file.name.split('.').pop().toLowerCase()
        })
      })

      this.selectedFiles.push(...validFiles)
      event.target.value = '' // 清空文件选择

      // 自动开始上传
      validFiles.forEach((fileObj, index) => {
        const actualIndex = this.selectedFiles.indexOf(fileObj)
        this.uploadFile(fileObj, actualIndex)
      })
    },

    async uploadFile(fileObj, index) {
      try {
        this.selectedFiles[index].uploadStatus = 'pending'

        const formData = new FormData()
        formData.append('file', fileObj.file)

        const response = await axios.post('/appeal/upload', formData, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        })

        if (response.data.success) {
          const { file_name, file_path, file_size, file_type, mime_type } = response.data.data

          this.selectedFiles[index] = {
            ...this.selectedFiles[index],
            uploadStatus: 'success',
            path: file_path,
            originalName: file_name
          }

          this.appealForm.attachments.push({
            file_name,
            file_path,
            file_size,
            file_type,
            mime_type
          })
        }
      } catch (error) {
        console.error('文件上传失败:', error)
        this.selectedFiles[index].uploadStatus = 'error'
        this.errorMessage = `文件 ${fileObj.name} 上传失败: ${error.response?.data?.message || error.message}`
      }
    },

    removeFile(index) {
      const file = this.selectedFiles[index]

      // 如果文件已上传成功，从附件列表中移除
      if (file.uploadStatus === 'success') {
        this.appealForm.attachments = this.appealForm.attachments.filter(
          att => att.file_path !== file.path
        )
      }

      this.selectedFiles.splice(index, 1)
    },

    async submitAppeal() {
      try {
        this.submitting = true
        this.errorMessage = ''
        this.successMessage = ''

        // 检查是否有文件正在上传
        const uploadingFiles = this.selectedFiles.filter(file => file.uploadStatus === 'pending')
        if (uploadingFiles.length > 0) {
          this.errorMessage = '请等待文件上传完成后再提交'
          return
        }

        // 验证必填字段
        if (!this.appealForm.user_identifier || !this.appealForm.password) {
          this.errorMessage = '请填写用户名/手机号和密码'
          return
        }

        const response = await axios.post('/appeal', this.appealForm, {
          headers: {
            'Content-Type': 'application/json'
          }
        })

        if (response.data.success) {
          this.successMessage = '申诉提交成功，请耐心等待处理结果'
          setTimeout(() => {
            this.$emit('success', response.data.data)
          }, 2000)
        } else {
          this.errorMessage = response.data.message || '申诉提交失败'
        }
      } catch (error) {
        console.error('申诉提交失败:', error)
        this.errorMessage = error.response?.data?.message || '申诉提交失败，请稍后重试'
      } finally {
        this.submitting = false
      }
    }
  }
}
</script>

<style scoped>
.appeal-form-container {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.appeal-header {
  text-align: center;
  margin-bottom: 30px;
}

.appeal-title {
  color: #333;
  margin-bottom: 10px;
  font-size: 28px;
  font-weight: 600;
}

.appeal-subtitle {
  color: #666;
  font-size: 16px;
  margin: 0;
}

.ban-info-card {
  background-color: #f8f9fa;
  border: 1px solid #e9ecef;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 30px;
}

.info-title {
  color: #495057;
  margin: 0 0 15px 0;
  font-size: 18px;
  font-weight: 600;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 15px;
}

.info-item {
  display: flex;
  flex-direction: column;
}

.info-label {
  font-weight: 600;
  color: #495057;
  margin-bottom: 5px;
}

.info-value {
  color: #6c757d;
}

.appeal-form {
  background-color: white;
  border-radius: 8px;
  padding: 30px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.form-group {
  margin-bottom: 25px;
}

.form-label {
  display: block;
  font-weight: 600;
  color: #495057;
  margin-bottom: 8px;
}

.form-input,
.form-select,
.form-textarea {
  width: 100%;
  padding: 12px;
  border: 1px solid #ced4da;
  border-radius: 4px;
  font-size: 16px;
  transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
  box-sizing: border-box;
}

.form-input:focus,
.form-select:focus,
.form-textarea:focus {
  border-color: #80bdff;
  outline: 0;
  box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
}

.form-textarea {
  resize: vertical;
  min-height: 100px;
}

.upload-section {
  border: 1px dashed #ced4da;
  border-radius: 4px;
  padding: 20px;
  text-align: center;
}

.upload-btn {
  background-color: #007bff;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 16px;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  transition: background-color 0.15s ease-in-out;
}

.upload-btn:hover {
  background-color: #0056b3;
}

.upload-icon {
  font-size: 18px;
}

.upload-tips {
  color: #6c757d;
  font-size: 14px;
  margin-top: 10px;
}

.selected-files {
  margin-top: 20px;
  text-align: left;
}

.file-item {
  background-color: #f8f9fa;
  border: 1px solid #e9ecef;
  border-radius: 4px;
  padding: 15px;
  margin-bottom: 10px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.file-info {
  flex: 1;
}

.file-name {
  font-weight: 600;
  color: #495057;
  display: block;
  margin-bottom: 5px;
}

.file-size {
  color: #6c757d;
  font-size: 14px;
}

.file-actions {
  display: flex;
  gap: 8px;
  margin-left: 15px;
}

.upload-progress-btn,
.upload-success-btn,
.upload-error-btn,
.remove-file-btn {
  padding: 6px 12px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.upload-progress-btn {
  background-color: #ffc107;
  color: #212529;
}

.upload-success-btn {
  background-color: #28a745;
  color: white;
}

.upload-error-btn {
  background-color: #dc3545;
  color: white;
}

.remove-file-btn {
  background-color: #6c757d;
  color: white;
}

.upload-error-btn:hover,
.remove-file-btn:hover {
  opacity: 0.8;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 15px;
  margin-top: 30px;
}

.cancel-btn,
.submit-btn {
  padding: 12px 30px;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.15s ease-in-out;
}

.cancel-btn {
  background-color: #6c757d;
  color: white;
}

.cancel-btn:hover {
  background-color: #5a6268;
}

.submit-btn {
  background-color: #007bff;
  color: white;
}

.submit-btn:hover:not(:disabled) {
  background-color: #0056b3;
}

.submit-btn:disabled {
  background-color: #6c757d;
  cursor: not-allowed;
}

.error-message {
  background-color: #f8d7da;
  color: #721c24;
  border: 1px solid #f5c6cb;
  border-radius: 4px;
  padding: 12px;
  margin-top: 15px;
}

.success-message {
  background-color: #d4edda;
  color: #155724;
  border: 1px solid #c3e6cb;
  border-radius: 4px;
  padding: 12px;
  margin-top: 15px;
}
</style>