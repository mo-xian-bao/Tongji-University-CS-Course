<template>
  <div class="app-root">
    <aside class="sidebar">
      <div class="brand">食刻预约 - 管理员后台</div>
      <nav>
        <router-link to="/admin/dashboard" class="nav-item">仪表盘</router-link>
        <router-link to="/admin/store-applications" class="nav-item">店铺申请管理</router-link>
        <router-link to="/admin/account-ban" class="nav-item">账号封禁管理</router-link>
        <router-link to="/admin/appeal-handling" class="nav-item">申诉处理</router-link>
        <router-link to="/admin/comment-management" class="nav-item">评论管理</router-link>
        <router-link to="/admin/system-notification" class="nav-item">系统公告</router-link>
      </nav>
    </aside>

    <main class="main-area">
      <header class="topbar">
        <div class="user-profile" @click="toggleDropdown">
          <div class="avatar-icon admin">
            {{ getAvatarLetter }}
          </div>
          <span class="user-name">{{ adminName }}</span>
          <div class="status-indicator">
            <span class="status-dot admin"></span>
            <span>管理员</span>
          </div>
          <svg class="dropdown-arrow" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
            <path d="M7 10l5 5 5-5H7z"/>
          </svg>

          <div v-if="isDropdownOpen" class="dropdown-menu">
            <ul>
              <li><a href="#" @click.prevent.stop="logout">退出登录</a></li>
            </ul>
          </div>
        </div>
      </header>

      <section class="content">
        <router-view />
      </section>
    </main>
  </div>
</template>

<script>
export default {
  data() {
    return {
      adminName: '',
      isDropdownOpen: false
    }
  },
  computed: {
    getAvatarLetter() {
      return this.adminName ? this.adminName.charAt(0) : 'A'
    }
  },
  mounted() {
    this.loadCurrentUser()
  },
  methods: {
    loadCurrentUser() {
      try {
        // 从localStorage获取用户信息
        const userStr = localStorage.getItem('user')
        if (userStr) {
          const user = JSON.parse(userStr)
          // 优先显示用户名，如果没有则显示手机号，最后显示"管理员"
          this.adminName = user.username || user.phone || '管理员'
        } else {
          this.adminName = '管理员'
        }
      } catch (error) {
        console.error('加载用户信息失败:', error)
        this.adminName = '管理员'
      }
    },
    toggleDropdown() {
      this.isDropdownOpen = !this.isDropdownOpen
    },
    switchToCustomer() {
      this.$router.push('/shop')
      this.isDropdownOpen = false
    },
    switchToMerchant() {
      this.$router.push('/merchant/dashboard')
      this.isDropdownOpen = false
    },
    logout() {
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      this.$router.push('/login')
      this.isDropdownOpen = false
    },
    closeDropdownOnClickOutside(event) {
      const userProfile = this.$el.querySelector('.user-profile')
      if (userProfile && !userProfile.contains(event.target)) {
        this.isDropdownOpen = false
      }
    }
  },
  watch: {
    isDropdownOpen(isOpen) {
      if (isOpen) {
        setTimeout(() => document.addEventListener('click', this.closeDropdownOnClickOutside), 0)
      } else {
        document.removeEventListener('click', this.closeDropdownOnClickOutside)
      }
    }
  },
  beforeUnmount() {
    document.removeEventListener('click', this.closeDropdownOnClickOutside)
  }
}
</script>

<style scoped src="../merchant/styles.css"></style>

<style scoped>
/* 管理员特有样式 */
.avatar-icon.admin {
  background: linear-gradient(135deg, #ff6b6b, #ee5a24);
  box-shadow: 0 2px 8px rgba(238, 90, 36, 0.3);
}

.status-dot.admin {
  background-color: #ff6b6b;
  box-shadow: 0 0 5px #ff6b6b;
}

/* 修改侧边栏主题色 */
.sidebar {
  background: linear-gradient(180deg, #2c3e50 0%, #3498db 100%);
}

.nav-item.router-link-active {
  border-left-color: var(--color-surface);
}

.brand {
  background: linear-gradient(135deg, var(--color-surface), var(--color-neutral-100));
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}
</style>