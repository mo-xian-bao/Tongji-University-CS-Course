<template>
  <div>
    <h2>店铺信息</h2>
    <div class="card">

      <div class="avatar-uploader">
        <label class="small">店铺头像</label>
        <img :src="avatarUrl" alt="Avatar Preview" class="avatar-preview">

        <button class="btn-outline" @click="triggerFileUpload">更换头像</button>

        <input
          type="file"
          ref="fileInput"
          @change="handleFileChange"
          accept="image/*"
          style="display: none;"
        >
      </div>

      <hr class="divider">

      <div class="form-row">
        <div style="flex:1">
          <label class="small">店铺名称</label>
          <input v-model="name" class="input" placeholder="请输入店铺名称" />
        </div>
        <div style="flex:1">
          <label class="small">联系电话</label>
          <input v-model="phone" class="input" placeholder="请输入联系电话" />
        </div>
      </div>

      <div class="form-row" style="margin-top:12px">
        <div style="flex:1">
          <label class="small">店铺地址</label>
          <input v-model="address" class="input" placeholder="请输入店铺地址" />
        </div>
      </div>

      <div class="form-row">
        <div style="flex:1">
          <label class="small">营业时间</label>
          <div class="form-row" style="margin-top:8px">
            <input v-model="open" class="input" placeholder="09:00" />
            <span style="margin: 0 5px; line-height: 32px;">-</span>
            <input v-model="close" class="input" placeholder="21:00" />
          </div>
        </div>
        <div style="flex:1">
          <label class="small">店铺公告</label>
          <textarea v-model="notice" class="textarea" placeholder="请输入店铺公告"></textarea>
        </div>
      </div>
      <div style="margin-top:12px">
        <button class="btn" @click="save" :disabled="loading">
          {{ loading ? '保存中...' : '保存' }}
        </button>
      </div>
      <div v-if="showErrorPopup" class="toast" :class="toastType">
        {{ errorMessage }}
      </div>
    </div>
  </div>
</template>

<script>
export default{
  data(){
    return{
      // 3. 为头像预览URL添加 data 属性
      avatarUrl: 'https://via.placeholder.com/100', // 默认占位图

      open:'09:00',
      close:'21:00',
      notice:'欢迎光临，请提前10分钟下单',

      // 4. 用来保存用户选择的真实文件
      avatarFile: null,

  // 店铺信息字段
  name: '',
  address: '',
  phone: '',

      // 添加加载状态
      loading: false,

      // 餐厅ID
      restaurantId: null,

      // 用户ID（从本地存储获取）
      userId: null
      ,
      // Toast state
      errorMessage: '',
      toastType: 'success',
      showErrorPopup: false
      ,
      // 保存从服务器加载的原始值（用于保存失败时恢复）
      originalValues: null
    }
  },

  mounted() {
    // 组件挂载时获取用户信息和餐厅信息
    this.getUserInfo();
    this.getRestaurantInfo();
  },

  methods:{
    showToast(message, type = 'success') {
      this.errorMessage = message
      this.toastType = type
      this.showErrorPopup = true
      setTimeout(() => {
        this.showErrorPopup = false
        this.errorMessage = ''
      }, 1000)
    },

    // 保存失败时恢复表单到原始值（若无原始值则清空）
    restoreOriginalValues() {
      if (this.originalValues) {
        this.name = this.originalValues.name || ''
        this.address = this.originalValues.address || ''
        this.phone = this.originalValues.phone || ''
        this.open = this.originalValues.open || '09:00'
        this.close = this.originalValues.close || '21:00'
        this.notice = this.originalValues.notice || ''
        this.avatarUrl = this.originalValues.avatarUrl || 'https://via.placeholder.com/100'
        this.restaurantId = this.originalValues.restaurantId || null
        this.avatarFile = null
      } else {
        this.name = ''
        this.address = ''
        this.phone = ''
        this.open = '09:00'
        this.close = '21:00'
        this.notice = ''
        this.avatarUrl = 'https://via.placeholder.com/100'
        this.restaurantId = null
        this.avatarFile = null
      }
    },

    getUserInfo() {
      // 更健壮地从 localStorage 获取 user 和 token
      const userStr = localStorage.getItem('user');
      if (!userStr) {
        this.userId = null;
        this.user = null;
        return;
      }

      try {
        const user = JSON.parse(userStr);
        this.user = user;
        // 兼容 user.id 或 user.user_id
        this.userId = user.id ?? user.user_id ?? null;
        this.token = localStorage.getItem('token') || null;
      } catch (e) {
        console.error('解析用户信息失败:', e);
        localStorage.removeItem('user');
        this.userId = null;
        this.user = null;
      }
    },

    async getRestaurantInfo() {
      if (!this.userId) return;

      try {
  const headers = this.token ? { 'Authorization': `Bearer ${this.token}` } : {};
  const response = await fetch(`/api/restaurant/user/${this.userId}`, { headers });
        const result = await response.json();

        if (result.success) {
          const restaurant = result.data.restaurant;
          this.restaurantId = restaurant.id;

          // 更新表单数据
          this.name = restaurant.name || '';
          this.address = restaurant.address || '';
          this.phone = restaurant.phone || '';

          const hours = (restaurant.opening_hours || '').split('-').map(s => String(s || '').trim());
          if (hours.length === 2) {
            this.open = hours[0];
            this.close = hours[1];
          }

          this.notice = restaurant.notice || '';
          this.avatarUrl = restaurant.avatar_url || 'https://via.placeholder.com/100';
          // 保存原始值以便保存失败时恢复
          this.originalValues = {
            name: this.name,
            address: this.address,
            phone: this.phone,
            open: this.open,
            close: this.close,
            notice: this.notice,
            avatarUrl: this.avatarUrl,
            restaurantId: this.restaurantId
          }
        }
        else {
          this.originalValues = null
        }
      } catch (error) {
        console.error('获取餐厅信息失败:', error);
      }
    },

    async save(){
      if (!this.userId) {
        this.showToast('请先登录', 'error')
        this.restoreOriginalValues()
        return;
      }

      this.loading = true;

      try {
        // 验证营业时间格式与先后关系
        // Accept both '1:00' and '01:00' formats for hours (0-23)
        const timePattern = /^([0-1]?\d|2[0-3]):([0-5]\d)$/
        const openStr = String(this.open || '').trim()
        const closeStr = String(this.close || '').trim()

        if (!timePattern.test(openStr) || !timePattern.test(closeStr)) {
          this.showToast('营业时间格式错误，应为 HH:MM，例如 09:00', 'error')
          this.loading = false;
          this.restoreOriginalValues()
          return;
        }

        const toMinutes = (t) => {
          const [hh, mm] = t.split(':').map(s => parseInt(s, 10) || 0)
          return hh * 60 + mm
        }

        const openMin = toMinutes(openStr)
        const closeMin = toMinutes(closeStr)

        // 当前规则：不支持跨日营业（close 必须大于 open）
        if (closeMin <= openMin) {
          this.showToast('结束时间应晚于开始时间；当前不支持跨日营业，请调整', 'error')
          this.loading = false;
          this.restoreOriginalValues()
          return;
        }

        // 构造营业时间字符串
        const openingHours = `${openStr}-${closeStr}`;

        // 其他字段校验
        const nameStr = String(this.name || '').trim()
        const addressStr = String(this.address || '').trim()
        const phoneStr = String(this.phone || '').replace(/[\s-]/g, '')
        const noticeStr = String(this.notice || '').trim()

        if (!nameStr) {
          this.showToast('请填写店铺名称', 'error')
          this.loading = false;
          this.restoreOriginalValues()
          return;
        }
        if (nameStr.length < 2 || nameStr.length > 50) {
          this.showToast('店铺名称长度需为2-50个字符', 'error')
          this.loading = false;
          this.restoreOriginalValues()
          return;
        }
        if (!addressStr) {
          this.showToast('请填写店铺地址', 'error')
          this.loading = false;
          this.restoreOriginalValues()
          return;
        }
        if (addressStr.length < 5 || addressStr.length > 200) {
          this.showToast('店铺地址长度需为5-200个字符', 'error')
          this.loading = false;
          this.restoreOriginalValues()
          return;
        }
        if (!phoneStr) {
          this.showToast('请填写联系电话', 'error')
          this.loading = false;
          this.restoreOriginalValues()
          return;
        }
        if (!/^1[3-9]\d{9}$/.test(phoneStr)) {
          this.showToast('联系电话格式不正确（需为11位手机号）', 'error')
          this.loading = false;
          this.restoreOriginalValues()
          return;
        }
        if (noticeStr.length > 300) {
          this.showToast('店铺公告最多300字', 'error')
          this.loading = false;
          this.restoreOriginalValues()
          return;
        }

        // 构造请求数据
        const requestData = {
          user_id: this.userId,
          name: nameStr,
          address: addressStr,
          phone: phoneStr,
          opening_hours: openingHours,
          notice: noticeStr,
          avatar_url: this.avatarUrl
        };

        // 如果已有餐厅ID，则更新；否则创建新餐厅
        let url, method;
        if (this.restaurantId) {
          url = `/api/restaurant/${this.restaurantId}`;
          method = 'PUT';
          // 更新时不需要user_id
          delete requestData.user_id;
        } else {
          url = '/api/restaurant';
          method = 'POST';
        }

        // 如果用户选择了新头像文件，尝试先上传图片到后端上传接口
        if (this.avatarFile) {
          try {
            const fd = new FormData();
            fd.append('file', this.avatarFile);
            // 预期后端提供 /api/upload 接口返回 { success: true, url: '...'}
            const upRes = await fetch('/api/upload', {
              method: 'POST',
              headers: this.token ? { 'Authorization': `Bearer ${this.token}` } : {},
              body: fd
            });
            const upJson = await upRes.json();
            if (upJson && upJson.success && upJson.url) {
              requestData.avatar_url = upJson.url;
            } else {
              // 上传失败时保留本地预览 URL（注意：不可持久化），并提示
              console.warn('头像上传未返回可用 URL，使用预览地址');
            }
          } catch (e) {
            console.warn('头像上传失败，继续使用预览地址', e);
          }
        }

        const headers = { 'Content-Type': 'application/json' };
        if (this.token) headers['Authorization'] = `Bearer ${this.token}`;

        const response = await fetch(url, {
          method: method,
          headers,
          body: JSON.stringify(requestData)
        });

        const result = await response.json();

        if (result.success) {
          this.showToast('店铺信息保存成功', 'success')
          // 如果是创建餐厅，保存餐厅ID
          if (result.data && result.data.restaurant) {
            this.restaurantId = result.data.restaurant.id;
            // 更新原始值为新保存的数据
            const r = result.data.restaurant
            this.originalValues = {
              name: r.name || this.name,
              address: r.address || this.address,
              phone: r.phone || this.phone,
              open: (r.opening_hours || '').split('-')[0] || this.open,
              close: (r.opening_hours || '').split('-')[1] || this.close,
              notice: r.notice || this.notice,
              avatarUrl: r.avatar_url || this.avatarUrl,
              restaurantId: r.id || this.restaurantId
            }
          }
        } else {
          this.showToast('保存失败: ' + (result.message || '未知错误'), 'error')
          this.restoreOriginalValues()
        }
      } catch (error) {
        console.error('保存店铺信息失败:', error);
        this.showToast('保存失败，请检查网络连接', 'error')
        this.restoreOriginalValues()
      } finally {
        this.loading = false;
      }
    },

    // 5. 新增：触发隐藏的文件输入框
    triggerFileUpload() {
      this.$refs.fileInput.click();
    },

    // 6. 新增：处理文件选择
    handleFileChange(event) {
      const file = event.target.files[0];
      if (file) {
        // 保存文件对象，以便'save'时上传
        this.avatarFile = file;

        // 生成本地URL用于预览
        this.avatarUrl = URL.createObjectURL(file);
      }
    }
  }
}
</script>

<style scoped>
/* 为新增的头像模块添加样式 */
.avatar-uploader {
  text-align: center;
  margin-bottom: 20px;
}
.avatar-preview {
  width: 100px;
  height: 100px;
  border-radius: 50%; /* 圆形头像 */
  border: 2px solid #eee;
  object-fit: cover; /* 保证图片不变形 */
  display: block;
  margin: 10px auto;
}
.divider {
  border: none;
  border-top: 1px solid #f0f0f0;
  margin: 20px 0;
}

/* 你原有的样式（我补充了一些定义） */
.card {
  /* 假设已有 */
  padding: 20px;
  background-color: #fff;
  border-radius: 8px;
}
.form-row {
  display: flex;
  gap: 20px; /* 元素间距 */
}
.small {
  font-size: 14px;
  font-weight: bold;
  color: #555;
  display: block;
  margin-bottom: 5px;
}
.input, .textarea {
  width: 100%;
  border: 1px solid #e6eefb;
  border-radius: 6px;
  padding: 8px;
  box-sizing: border-box; /* 关键 */
}
.textarea {
  height: 80px;
  resize: vertical;
}

/* 按钮样式 (假设) */
.btn {
  padding: 10px 15px;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
}
.btn-outline {
  padding: 8px 12px;
  border: 1px solid #ddd;
  background-color: white;
  border-radius: 6px;
  cursor: pointer;
}
.btn-outline:hover {
  background-color: #f9f9f9;
}

/* Toast Notification Styles */
.toast {
  position: fixed;
  top: 20px;
  right: 20px;
  padding: 16px 24px;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  z-index: 2000;
  animation: slideIn 0.3s ease;
  font-size: 15px;
  font-weight: 500;
  color: white;
  max-width: 400px;
  word-wrap: break-word;
}

.toast.success {
  background: #2ecc71;
}

.toast.error {
  background: #e74c3c;
}

@keyframes slideIn {
  from {
    transform: translateX(100%);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}

@keyframes slideOut {
  from {
    transform: translateX(0);
    opacity: 1;
  }
  to {
    transform: translateX(100%);
    opacity: 0;
  }
}

</style>