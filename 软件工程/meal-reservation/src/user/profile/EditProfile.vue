<template>
  <div class="edit-profile-page">
    <header class="page-header">
      <button class="back-btn" @click="goBack">
        <span>←</span>
      </button>
      <h1>编辑个人信息</h1>
      <button class="save-btn" @click="saveProfile" :disabled="isSaving">
        {{ isSaving ? '保存中...' : '保存' }}
      </button>
    </header>

    <main class="form-container">
      <!-- 头像上传 -->
      <div class="avatar-section">
        <div class="avatar-preview">
          <img :src="avatarPreview || defaultAvatar" alt="头像" />
        </div>
        <label class="upload-btn">
          <input type="file" accept="image/*" @change="handleAvatarChange" hidden />
          <span>更换头像</span>
        </label>
      </div>

      <!-- 用户名 -->
      <div class="form-group">
        <label>用户名</label>
        <input 
          v-model="username" 
          type="text" 
          placeholder="请输入用户名"
          maxlength="20"
        />
        <p class="hint">用户名长度为2-20个字符</p>
      </div>

      <!-- 生日 -->
      <div class="form-group">
        <label>生日</label>
        <input 
          v-model="birthday" 
          type="date" 
          :max="maxDate"
        />
        <p class="hint">选填，用于生日优惠提醒</p>
      </div>

      <!-- 个性签名 -->
      <div class="form-group">
        <label>个性签名</label>
        <textarea 
          v-model="bio" 
          placeholder="写点什么介绍一下自己吧~"
          maxlength="100"
          rows="4"
        ></textarea>
        <p class="hint">{{ bio.length }}/100</p>
      </div>
    </main>
  </div>
</template>

<script>
import { getProfile, updateProfile } from '@/api/user';

export default {
  name: 'EditProfile',
  data() {
    return {
      defaultAvatar: `${API_url}/static/default/avatar.png`, // 使用服务器上的默认头像
      username: '',
      birthday: '',
      bio: '',
      avatarPreview: null,
      avatarFile: null,
      isSaving: false,
      maxDate: new Date().toISOString().split('T')[0] // 今天的日期作为最大值
    }
  },
  mounted() {
    this.loadUserProfile();
  },
  methods: {
    async loadUserProfile() {
      try {
        const token = localStorage.getItem('token');
        if (!token) {
          this.$router.push('/login');
          return;
        }

        const res = await getProfile();
        const data = res.data;
        if (data.success) {
          const userData = data.data?.user || data.user || data.data;
          this.username = userData.username || '';
          this.birthday = userData.birthday || '';
          this.bio = userData.bio || '';
          
          // 处理头像URL
          let avatarUrl = userData.avatar_url || null;
          if (avatarUrl && !avatarUrl.startsWith('http')) {
            avatarUrl = `${API_url}${avatarUrl}`;
          }
          this.avatarPreview = avatarUrl;
        }
      } catch (error) {
        console.error('加载用户信息失败:', error);
        alert('加载用户信息失败');
      }
    },
    handleAvatarChange(event) {
      const file = event.target.files[0];
      if (!file) return;

      // 验证文件类型
      if (!file.type.startsWith('image/')) {
        alert('请选择图片文件');
        return;
      }

      // 验证文件大小（限制为2MB）
      if (file.size > 2 * 1024 * 1024) {
        alert('图片大小不能超过2MB');
        return;
      }

      this.avatarFile = file;

      // 预览图片
      const reader = new FileReader();
      reader.onload = (e) => {
        this.avatarPreview = e.target.result;
      };
      reader.readAsDataURL(file);
    },
    async saveProfile() {
      if (!this.username.trim()) {
        alert('请输入用户名');
        return;
      }

      if (this.username.length < 2 || this.username.length > 20) {
        alert('用户名长度为2-20个字符');
        return;
      }

      this.isSaving = true;

      try {
        const token = localStorage.getItem('token');
        const formData = new FormData();
        formData.append('username', this.username);
        formData.append('bio', this.bio);
        
        if (this.birthday) {
          formData.append('birthday', this.birthday);
        }
        
        if (this.avatarFile) {
          formData.append('avatar', this.avatarFile);
        }

        const res = await updateProfile(formData);
        const data = res.data;
        if (data.success) {
          alert('保存成功');
          this.$router.back();
        } else {
          alert(data.message || '保存失败');
        }
      } catch (error) {
        console.error('保存失败:', error);
        alert('保存失败，请稍后重试');
      } finally {
        this.isSaving = false;
      }
    },
    goBack() {
      this.$router.back();
    }
  }
};
</script>

<style scoped>
.edit-profile-page {
  min-height: 100vh;
  background-color: #f8f9fa;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
  background-color: white;
  box-shadow: 0 2px 4px rgba(0,0,0,0.05);
}

.back-btn {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  color: #333;
  padding: 5px;
}

.page-header h1 {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
}

.save-btn {
  background: linear-gradient(45deg, #4a90e2, #9013fe);
  color: white;
  border: none;
  padding: 8px 20px;
  border-radius: 20px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
}

.save-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.form-container {
  padding: 20px;
}

.avatar-section {
  background-color: white;
  padding: 30px 20px;
  border-radius: 12px;
  text-align: center;
  margin-bottom: 20px;
}

.avatar-preview {
  width: 100px;
  height: 100px;
  margin: 0 auto 20px;
}

.avatar-preview img {
  width: 100%;
  height: 100%;
  border-radius: 50%;
  object-fit: cover;
  border: 3px solid #e0e0e0;
}

.upload-btn {
  display: inline-block;
  padding: 10px 30px;
  background-color: #4a90e2;
  color: white;
  border-radius: 20px;
  cursor: pointer;
  font-size: 14px;
  transition: background-color 0.2s;
}

.upload-btn:hover {
  background-color: #3a7bc2;
}

.form-group {
  background-color: white;
  padding: 20px;
  border-radius: 12px;
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 10px;
  font-size: 14px;
  color: #666;
  font-weight: 500;
}

.form-group input,
.form-group textarea {
  width: 100%;
  padding: 12px;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  font-size: 16px;
  box-sizing: border-box;
  font-family: inherit;
}

.form-group input:focus,
.form-group textarea:focus {
  outline: none;
  border-color: #4a90e2;
}

.form-group textarea {
  resize: none;
}

.hint {
  margin: 8px 0 0;
  font-size: 12px;
  color: #999;
}
</style>