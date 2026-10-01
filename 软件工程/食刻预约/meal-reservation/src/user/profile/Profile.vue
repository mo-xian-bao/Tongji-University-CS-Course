<template>
  <div v-if="user" class="profile-page">
    <header class="profile-header">
      <div class="avatar-container">
        <img :src="user.avatarUrl || defaultAvatar" alt="User Avatar" class="avatar-img" />
      </div>
      <div class="user-info">
        <h2 class="user-name">{{ user.name }}</h2>
        <button class="edit-profile-btn" @click="editProfile">
          <span>✏️</span>
        </button>
      </div>
      <p class="membership-level">{{ user.membershipLevel }}</p>
    </header>

    <main class="action-list">
      <div class="action-item" @click="editContact">
        <div class="icon-bg" style="background-color: #e6f2ff;">
          <span class="icon">📞</span>
        </div>
        <div class="text-content">
          <span class="title">修改联系方式</span>
          <span class="subtitle">{{ user.phone || '未设置手机号' }}</span>
        </div>
        <span class="arrow">&gt;</span>
      </div>

      <div class="action-item" @click="viewCoupons">
        <div class="icon-bg" style="background-color: #f2e9ff;">
          <span class="icon">🔖</span>
        </div>
        <div class="text-content">
          <span class="title">我的优惠券</span>
          <span class="subtitle">查看可用优惠券</span>
        </div>
        <span class="arrow">&gt;</span>
      </div>

      <div class="action-item" @click="viewFollows">
        <div class="icon-bg" style="background-color: #ffeef2;">
          <span class="icon">❤️</span>
        </div>
        <div class="text-content">
          <span class="title">我的关注</span>
          <span class="subtitle">管理关注的商铺</span>
        </div>
        <span class="arrow">&gt;</span>
      </div>

      <div class="action-item" @click="goSupport">
        <div class="icon-bg" style="background-color: #e8f0ff;">
          <span class="icon">💬</span>
        </div>
        <div class="text-content">
          <span class="title">客服中心</span>
          <span class="subtitle">提交与查看工单</span>
        </div>
        <span class="arrow">&gt;</span>
      </div>

      <div class="action-item" @click="openNotificationSettings">
        <div class="icon-bg" style="background-color: #fff4e6;">
          <span class="icon">🔔</span>
        </div>
        <div class="text-content">
          <span class="title">通知设置</span>
          <span class="subtitle">调整消息提醒模式</span>
        </div>
        <span class="arrow">&gt;</span>
      </div>

      <div class="action-item" @click="changePassword">
        <div class="icon-bg" style="background-color: #e3f9e9;">
          <span class="icon">🔒</span>
        </div>
        <div class="text-content">
          <span class="title">修改密码</span>
          <span class="subtitle">定期更改密码更安全</span>
        </div>
        <span class="arrow">&gt;</span>
      </div>

      <div class="action-item" @click="switchIdentity">
        <div class="icon-bg" style="background-color: #fff8e1;">
          <span class="icon">👥</span>
        </div>
        <div class="text-content">
          <span class="title">身份切换</span>
          <span class="subtitle">切换不同身份角色</span>
        </div>
        <span class="arrow">&gt;</span>
      </div>

      <div class="action-item" @click="logout">
        <div class="icon-bg" style="background-color: #ffebee;">
          <span class="icon" style="color: #d32f2f;">↪</span>
        </div>
        <div class="text-content">
          <span class="title">退出登录</span>
          <span class="subtitle">安全退出当前账号</span>
        </div>
        <span class="arrow">&gt;</span>
      </div>
    </main>

    <BottomNav />

    <!-- 修改手机号弹窗 -->
    <div v-if="showPhoneModal" class="modal-overlay" @click="closePhoneModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>修改手机号</h3>
          <button class="close-btn" @click="closePhoneModal">×</button>
        </div>
        
        <div class="modal-body">
          <div class="current-phone-info">
            <span class="label">当前手机号:</span>
            <span class="value">{{ user.phone }}</span>
          </div>

          <div class="form-field">
            <label>新手机号</label>
            <input 
              v-model="newPhone" 
              type="tel" 
              placeholder="请输入新手机号"
              maxlength="11"
            />
          </div>

          <div class="form-field">
            <label>验证码</label>
            <div class="code-group">
              <input 
                v-model="smsCode" 
                type="text" 
                placeholder="请输入验证码"
                maxlength="6"
              />
              <button 
                class="code-btn" 
                @click="sendSmsCode"
                :disabled="countdown > 0"
              >
                {{ countdown > 0 ? `${countdown}秒` : '发送' }}
              </button>
            </div>
          </div>
        </div>

        <div class="modal-footer">
          <button class="cancel-btn" @click="closePhoneModal">取消</button>
          <button class="confirm-btn" @click="submitPhoneChange" :disabled="isSubmitting">
            {{ isSubmitting ? '提交中...' : '确认' }}
          </button>
        </div>
      </div>
    </div>

    <!-- 修改密码弹窗 -->
    <div v-if="showPasswordModal" class="modal-overlay" @click="closePasswordModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>修改密码</h3>
          <button class="close-btn" @click="closePasswordModal">×</button>
        </div>
        
        <div class="modal-body">
          <!-- 使用密码修改模式 -->
          <div v-if="!useSmsMode">
            <div class="form-field">
              <label>当前密码</label>
              <input 
                v-model="oldPassword" 
                type="password" 
                placeholder="请输入当前密码"
                autocomplete="current-password"
              />
            </div>

            <div class="form-field">
              <label>新密码</label>
              <input 
                v-model="newPassword" 
                type="password" 
                placeholder="请输入新密码（至少6位）"
                autocomplete="new-password"
              />
            </div>

            <div class="form-field">
              <label>确认新密码</label>
              <input 
                v-model="confirmPassword" 
                type="password" 
                placeholder="请再次输入新密码"
                autocomplete="new-password"
              />
            </div>

            <!-- 忘记密码按钮 -->
            <div class="forgot-password-wrapper">
              <button class="forgot-password-btn" @click="switchToSmsMode">
                忘记密码？
              </button>
            </div>
          </div>

          <!-- 使用验证码修改模式 -->
          <div v-else>
            <div class="current-phone-info">
              <span class="label">手机号:</span>
              <span class="value">{{ user.phone }}</span>
            </div>

            <div class="form-field">
              <label>验证码</label>
              <div class="code-group">
                <input 
                  v-model="resetSmsCode" 
                  type="text" 
                  placeholder="请输入验证码"
                  maxlength="6"
                />
                <button 
                  class="code-btn" 
                  @click="sendResetSmsCode"
                  :disabled="resetCountdown > 0"
                >
                  {{ resetCountdown > 0 ? `${resetCountdown}秒` : '发送' }}
                </button>
              </div>
            </div>

            <div class="form-field">
              <label>新密码</label>
              <input 
                v-model="newPassword" 
                type="password" 
                placeholder="请输入新密码（至少6位）"
                autocomplete="new-password"
              />
            </div>

            <div class="form-field">
              <label>确认新密码</label>
              <input 
                v-model="confirmPassword" 
                type="password" 
                placeholder="请再次输入新密码"
                autocomplete="new-password"
              />
            </div>

            <!-- 返回密码模式按钮 -->
            <div class="forgot-password-wrapper">
              <button class="back-to-password-btn" @click="switchToPasswordMode">
                ← 我想起了旧密码
              </button>
            </div>
          </div>
        </div>

        <div class="modal-footer">
          <button class="cancel-btn" @click="closePasswordModal">取消</button>
          <button class="confirm-btn" @click="submitPasswordChange" :disabled="isSubmittingPassword">
            {{ isSubmittingPassword ? '提交中...' : '确认' }}
          </button>
        </div>
      </div>
    </div>

    <!-- 用户身份确认弹窗 -->
    <div v-if="showIdentityModal" class="modal-overlay" @click="closeIdentityModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>确认操作</h3>
        </div >
        <div class="modal-body">检测到你目前是客户身份，需要注册为商户吗？</div>
        <div class="modal-footer">
          <button class="cancel-btn" @click="closeIdentityModal">取消</button>
          <button class="confirm-btn" @click="IdentityModalclick" >确认</button>
        </div>
      </div>
    </div>
    <div v-if="showExeModal" class="modal-overlay" >
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>确认操作</h3>
        </div >
        <div class="modal-body">检测到你已有申请中的商铺，还要继续吗？</div>
        <div class="modal-footer">
          <button class="cancel-btn" @click="closeExeModal">取消</button>
          <button class="confirm-btn" @click="ExeModalclick" >确认</button>
        </div>
      </div>
    </div>
  </div>
  <div v-else class="loading">
    <p>加载中...</p>
  </div>
</template>

<script>
import BottomNav from '../components/BottomNav.vue';

export default {
  name: 'UserProfile',
  components: {
    BottomNav
  },
  data() {
    return {
      user: null,
      defaultAvatar: `${API_url}/static/default/avatar.png`,
      // 修改手机号相关
      showPhoneModal: false,
      newPhone: '',
      smsCode: '',
      countdown: 0,
      timer: null,
      isSubmitting: false,
      // 修改密码相关
      showPasswordModal: false,
      useSmsMode: false, // 是否使用验证码模式
      oldPassword: '',
      newPassword: '',
      confirmPassword: '',
      resetSmsCode: '', // 重置密码的验证码
      resetCountdown: 0,
      resetTimer: null,
      isSubmittingPassword: false,
      //身份更改确认
      showIdentityModal: false,
      showExeModal:false
    }
  },
  beforeUnmount() {
    if (this.timer) {
      clearInterval(this.timer);
    }
    if (this.resetTimer) {
      clearInterval(this.resetTimer);
    }
  },
  mounted() {
    this.fetchUserProfile();
  },
  methods: {
    async fetchUserProfile() {
      try {
        const token = localStorage.getItem('token');
        
        if (!token) {
          alert("请先登录");
          this.$router.push('/login');
          return;
        }

        const response = await fetch('/api/users/profile', {
          method: 'GET',
          headers: { 
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
          }
        });

        const data = await response.json();

        if (response.ok && data.success) {
          const userData = data.data?.user || data.user || data.data;
          
          if (!userData) {
            throw new Error('返回的数据结构不正确，缺少用户信息');
          }
          
          // 处理头像URL
          let avatarUrl = userData.avatar_url || userData.avatarUrl || null;
          if (avatarUrl && !avatarUrl.startsWith('http')) {
            avatarUrl = `${API_url}${avatarUrl}`;
          }
          
          this.user = {
            id: userData.id,
            name: userData.username || userData.name || '未设置用户名',
            phone: userData.phone || '未设置手机号',
            membershipLevel: '普通会员',
            avatarUrl: avatarUrl,
            birthday: userData.birthday || null,
            bio: userData.bio || '',
            created_at: userData.created_at,
            updated_at: userData.updated_at
          };
        } else {
          throw new Error(data.message || '获取用户信息失败');
        }

      } catch (error) {
        console.error("获取用户资料失败:", error);
        
        if (error.message.includes('Failed to fetch')) {
          alert("无法连接到服务器，请确保后端服务正在运行");
        } else if (error.message.includes('401') || error.message.includes('token')) {
          alert("登录已过期，请重新登录");
          localStorage.removeItem('token');
          localStorage.removeItem('user');
          this.$router.push('/login');
        } else {
          alert(`无法加载用户资料: ${error.message}`);
        }
      }
    },
    goSupport() {
      const token = localStorage.getItem('token');
      if (!token) {
        alert('请先登录');
        this.$router.push('/login');
        return;
      }
      this.$router.push({ name: 'SupportCenter' });
    },
    openNotificationSettings() {
      const token = localStorage.getItem('token');
      if (!token) {
        alert('请先登录');
        this.$router.push('/login');
        return;
      }
      this.$router.push({ name: 'NotificationSettings' });
    },
    editProfile() {
      this.$router.push('/edit-profile');
    },
    
    // 修改手机号相关方法
    editContact() {
      this.showPhoneModal = true;
      this.newPhone = '';
      this.smsCode = '';
    },
    closePhoneModal() {
      this.showPhoneModal = false;
      this.newPhone = '';
      this.smsCode = '';
      if (this.timer) {
        clearInterval(this.timer);
        this.countdown = 0;
      }
    },
    async sendSmsCode() {
      if (!this.newPhone) {
        alert('请输入新手机号');
        return;
      }

      const phoneRegex = /^1[3-9]\d{9}$/;
      if (!phoneRegex.test(this.newPhone)) {
        alert('请输入正确的手机号格式');
        return;
      }

      if (this.newPhone === this.user.phone) {
        alert('新手机号不能与当前手机号相同');
        return;
      }

      try {
        const response = await fetch('/api/sms/send', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            phone: this.newPhone,
            purpose: 'change_phone'
          })
        });

        const data = await response.json();
        if (response.ok && data.success) {
          alert('验证码已发送');
          this.startCountdown();
        } else {
          alert(data.message || '发送验证码失败');
        }
      } catch (error) {
        console.error('发送验证码失败:', error);
        alert('发送验证码失败,请稍后重试');
      }
    },
    startCountdown() {
      this.countdown = 60;
      this.timer = setInterval(() => {
        this.countdown--;
        if (this.countdown <= 0) {
          clearInterval(this.timer);
          this.timer = null;
        }
      }, 1000);
    },
    async submitPhoneChange() {
      if (!this.newPhone) {
        alert('请输入新手机号');
        return;
      }

      if (!this.smsCode) {
        alert('请输入验证码');
        return;
      }

      const phoneRegex = /^1[3-9]\d{9}$/;
      if (!phoneRegex.test(this.newPhone)) {
        alert('请输入正确的手机号格式');
        return;
      }

      this.isSubmitting = true;

      try {
        const token = localStorage.getItem('token');
        const response = await fetch('/api/users/change-phone', {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            new_phone: this.newPhone,
            sms_code: this.smsCode
          })
        });

        const data = await response.json();
        if (response.ok && data.success) {
          alert('手机号修改成功');
          this.closePhoneModal();
          this.fetchUserProfile();
        } else {
          alert(data.message || '修改失败');
        }
      } catch (error) {
        console.error('修改手机号失败:', error);
        alert('修改失败，请稍后重试');
      } finally {
        this.isSubmitting = false;
      }
    },

    // 修改密码相关方法
    changePassword() {
      this.showPasswordModal = true;
      this.useSmsMode = false;
      this.oldPassword = '';
      this.newPassword = '';
      this.confirmPassword = '';
      this.resetSmsCode = '';
    },
    closePasswordModal() {
      this.showPasswordModal = false;
      this.useSmsMode = false;
      this.oldPassword = '';
      this.newPassword = '';
      this.confirmPassword = '';
      this.resetSmsCode = '';
      if (this.resetTimer) {
        clearInterval(this.resetTimer);
        this.resetCountdown = 0;
      }
    },
    switchToSmsMode() {
      this.useSmsMode = true;
      this.oldPassword = '';
    },
    switchToPasswordMode() {
      this.useSmsMode = false;
      this.resetSmsCode = '';
      if (this.resetTimer) {
        clearInterval(this.resetTimer);
        this.resetCountdown = 0;
      }
    },
    async sendResetSmsCode() {
      try {
        const response = await fetch('/api/sms/send', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            phone: this.user.phone,
            purpose: 'reset_password'
          })
        });

        const data = await response.json();
        if (response.ok && data.success) {
          alert('验证码已发送');
          this.startResetCountdown();
        } else {
          alert(data.message || '发送验证码失败');
        }
      } catch (error) {
        console.error('发送验证码失败:', error);
        alert('发送验证码失败,请稍后重试');
      }
    },
    startResetCountdown() {
      this.resetCountdown = 60;
      this.resetTimer = setInterval(() => {
        this.resetCountdown--;
        if (this.resetCountdown <= 0) {
          clearInterval(this.resetTimer);
          this.resetTimer = null;
        }
      }, 1000);
    },
    async submitPasswordChange() {
      // 验证输入
      if (!this.useSmsMode && !this.oldPassword) {
        alert('请输入当前密码');
        return;
      }

      if (this.useSmsMode && !this.resetSmsCode) {
        alert('请输入验证码');
        return;
      }

      if (!this.newPassword) {
        alert('请输入新密码');
        return;
      }

      if (this.newPassword.length < 6) {
        alert('新密码长度至少为6位');
        return;
      }

      if (!this.confirmPassword) {
        alert('请确认新密码');
        return;
      }

      if (this.newPassword !== this.confirmPassword) {
        alert('两次输入的新密码不一致');
        return;
      }

      this.isSubmittingPassword = true;

      try {
        const token = localStorage.getItem('token');
        
        let endpoint, bodyData, headers;
        
        if (this.useSmsMode) {
          // 使用验证码修改密码 - 复用原有接口
          endpoint = '/api/reset-password';
          bodyData = {
            phone: this.user.phone,
            sms_code: this.resetSmsCode,  // 使用 sms_code 而不是 smsCode
            new_password: this.newPassword
          };
          headers = {
            'Authorization': `Bearer ${token}`,  // 带上 token 表示是登录用户
            'Content-Type': 'application/json'
          };
        } else {
          // 使用旧密码修改密码
          endpoint = '/api/users/change-password';
          bodyData = {
            old_password: this.oldPassword,
            new_password: this.newPassword
          };
          headers = {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
          };
        }

        const response = await fetch(endpoint, {
          method: 'POST',
          headers: headers,
          body: JSON.stringify(bodyData)
        });

        const data = await response.json();
        if (response.ok && data.success) {
          alert('密码修改成功，请重新登录');
          this.closePasswordModal();
          // 清除本地存储并跳转到登录页
          localStorage.removeItem('token');
          localStorage.removeItem('user');
          this.$router.push('/login');
        } else {
          alert(data.message || '修改失败');
        }
      } catch (error) {
        console.error('修改密码失败:', error);
        alert('修改失败，请稍后重试');
      } finally {
        this.isSubmittingPassword = false;
      }
    },

    viewCoupons() {
      this.$router.push({ name: 'MyCoupons' });
    },
    viewFollows() {
      this.$router.push({ name: 'MyFollows' });
    },
    async switchIdentity() {
        try {
          const token = localStorage.getItem('token');
        
          if (!token) {
          this.$router.push('/login');
          return;
          }

          const response = await fetch('/api/users/profile', {
            method: 'GET',
            headers: { 
             'Authorization': `Bearer ${token}`,
             'Content-Type': 'application/json'
            }
          });

          const data = await response.json();

          if (response.ok && data.success) {
            const userData = data.data?.user || data.user || data.data;
          
            if (!userData) {
              throw new Error('返回的数据结构不正确，缺少用户信息');
            }
            if(userData.usertype==1)
              this.$router.push('/merchant');
            else
              this.showIdentityModal = true;
          }

        }
      catch (error) {
        console.error("获取用户资料失败:", error);
        
        if (error.message.includes('Failed to fetch')) {
          alert("无法连接到服务器，请确保后端服务正在运行");
        } else if (error.message.includes('401') || error.message.includes('token')) {
          alert("登录已过期，请重新登录");
          localStorage.removeItem('token');
          localStorage.removeItem('user');
          this.$router.push('/login');
        } else {
          alert(`无法加载用户资料: ${error.message}`);
        }
      }

    },
    closeIdentityModal() {
        this.showIdentityModal = false;
    },
    async IdentityModalclick() {
        this.showIdentityModal = false;
        try {
          const token = localStorage.getItem('token');
        
          if (!token) {
          this.$router.push('/login');
          return;
          }

          const response = await fetch('/api/merchant-application', {
            method: 'GET',
            headers: { 
             'Authorization': `Bearer ${token}`,
             'Content-Type': 'application/json'
            }
          });

          const data = await response.json();
          if (response.ok) {
            if (data.data.applications.length>=1)
            { 
              this.showExeModal = true
            }
            else
              this.$router.push('/merchant-application');
          }

        }
      catch (error) {
        console.error("获取用户资料失败:", error);
        
        if (error.message.includes('Failed to fetch')) {
          alert("无法连接到服务器，请确保后端服务正在运行");
        } else if (error.message.includes('401') || error.message.includes('token')) {
          alert("登录已过期，请重新登录");
          localStorage.removeItem('token');
          localStorage.removeItem('user');
          this.$router.push('/login');
        } else {
          alert(`无法加载用户资料: ${error.message}`);
        }
      }

    },
    closeExeModal(){
        this.showExeModal = false;
    },
    ExeModalclick(){
        this.showExeModal = false;
        this.$router.push('/merchant-application');
    },
    logout() {
      if (confirm('您确定要退出登录吗?')) {
        localStorage.removeItem('token');
        localStorage.removeItem('user');
        this.$router.push('/login');
      }
    }
  }
};
</script>

<style scoped>
.profile-page {
  background-color: #f8f9fa;
  min-height: 100vh;
  padding-bottom: 60px;
}

.loading {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  font-size: 16px;
  color: #666;
}

.profile-header {
  background: linear-gradient(45deg, #4a90e2, #9013fe);
  color: white;
  text-align: center;
  padding: 40px 20px 20px;
  border-bottom-left-radius: 20px;
  border-bottom-right-radius: 20px;
}

.avatar-container {
  width: 80px;
  height: 80px;
  margin: 0 auto 10px;
}

.avatar-img {
  width: 100%;
  height: 100%;
  border-radius: 50%;
  border: 3px solid white;
  object-fit: cover;
}

.user-info {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  margin-bottom: 5px;
}

.user-name {
  margin: 0;
  font-size: 22px;
  font-weight: bold;
}

.edit-profile-btn {
  background-color: rgba(255, 255, 255, 0.3);
  border: none;
  border-radius: 50%;
  width: 28px;
  height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 14px;
  transition: background-color 0.2s;
}

.edit-profile-btn:hover {
  background-color: rgba(255, 255, 255, 0.4);
}

.membership-level {
  margin: 5px 0 0;
  font-size: 14px;
  opacity: 0.8;
  background-color: rgba(255,255,255,0.2);
  display: inline-block;
  padding: 2px 10px;
  border-radius: 10px;
}

.action-list {
  margin: 20px;
  background-color: white;
  border-radius: 12px;
  padding: 0 15px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}

.action-item {
  display: flex;
  align-items: center;
  padding: 15px 0;
  border-bottom: 1px solid #f5f5f5;
  cursor: pointer;
  transition: background-color 0.2s;
}

.action-item:hover {
  background-color: #f8f9fa;
}

.action-item:last-child {
  border-bottom: none;
}

.icon-bg {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 15px;
}

.icon {
  font-size: 20px;
}

.text-content {
  flex-grow: 1;
}

.title {
  display: block;
  font-size: 16px;
  font-weight: 500;
  color: #333;
}

.subtitle {
  display: block;
  font-size: 12px;
  color: #999;
  margin-top: 2px;
}

.arrow {
  font-size: 18px;
  color: #ccc;
}

/* 弹窗样式 */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background-color: white;
  border-radius: 16px;
  width: 90%;
  max-width: 400px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #f0f0f0;
}

.modal-header h3 {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
}

.close-btn {
  background: none;
  border: none;
  font-size: 28px;
  color: #999;
  cursor: pointer;
  padding: 0;
  width: 30px;
  height: 30px;
  line-height: 1;
}

.modal-body {
  padding: 20px;
}

.current-phone-info {
  background-color: #f8f9fa;
  padding: 12px 15px;
  border-radius: 8px;
  margin-bottom: 20px;
}

.current-phone-info .label {
  color: #666;
  font-size: 14px;
  margin-right: 10px;
}

.current-phone-info .value {
  color: #333;
  font-size: 16px;
  font-weight: 600;
}

.form-field {
  margin-bottom: 15px;
}

.form-field label {
  display: block;
  margin-bottom: 8px;
  font-size: 14px;
  color: #666;
  font-weight: 500;
}

.form-field input {
  width: 100%;
  padding: 12px;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  font-size: 16px;
  box-sizing: border-box;
}

.form-field input:focus {
  outline: none;
  border-color: #4a90e2;
}

.code-group {
  display: flex;
  gap: 10px;
}

.code-group input {
  flex: 1;
}

.code-btn {
  padding: 12px 20px;
  background-color: #4a90e2;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  cursor: pointer;
  white-space: nowrap;
  min-width: 80px;
}

.code-btn:disabled {
  background-color: #ccc;
  cursor: not-allowed;
}

/* 忘记密码按钮样式 */
.forgot-password-wrapper {
  text-align: center;
  margin-top: 10px;
}

.forgot-password-btn,
.back-to-password-btn {
  background: none;
  border: none;
  color: #d32f2f;
  font-size: 14px;
  cursor: pointer;
  text-decoration: none;
  padding: 8px;
}

.forgot-password-btn:hover,
.back-to-password-btn:hover {
  text-decoration: underline;
}

.back-to-password-btn {
  color: #4a90e2;
}

.modal-footer {
  display: flex;
  gap: 10px;
  padding: 20px;
  border-top: 1px solid #f0f0f0;
}

.cancel-btn,
.confirm-btn {
  flex: 1;
  padding: 12px;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 500;
  cursor: pointer;
}

.cancel-btn {
  background-color: #f0f0f0;
  color: #666;
}

.confirm-btn {
  background: linear-gradient(45deg, #4a90e2, #9013fe);
  color: white;
}

.confirm-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
</style>