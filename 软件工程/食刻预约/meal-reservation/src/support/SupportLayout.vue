<template>
  <div class="app-root">
    <aside class="sidebar">
      <div class="brand">食刻预约 - 客服工作台</div>
      <nav>
        <router-link to="/support/dashboard" class="nav-item">仪表盘</router-link>
        <router-link to="/support/tickets" class="nav-item">工单列表</router-link>
      </nav>
    </aside>

    <main class="main-area">
      <header class="topbar">
        <div class="user-profile" @click="toggleDropdown">
          <div class="avatar-icon support">
            {{ getAvatarLetter }}
          </div>
          <span class="user-name">{{ supportName }}</span>
          <div class="status-indicator">
            <span class="status-dot support"></span>
            <span>客服</span>
          </div>
          <svg class="dropdown-arrow" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
            <path d="M7 10l5 5 5-5H7z"/>
          </svg>

          <div v-if="isDropdownOpen" class="dropdown-menu">
            <ul>
              <li><a href="#" @click.prevent.stop="switchToCustomer">切换至顾客端</a></li>
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
      supportName: '',
      isDropdownOpen: false
    }
  },
  computed: {
    getAvatarLetter() {
      return this.supportName ? this.supportName.charAt(0) : 'S'
    }
  },
  mounted() {
    this.loadCurrentUser()
  },
  methods: {
    loadCurrentUser() {
      try {
        const token = localStorage.getItem('token');
        if (!token) {
          alert("你没有访问权限");
          this.$router.push('/login');
          return
        }
        const userStr = localStorage.getItem('user')
        if (userStr) {
          const user = JSON.parse(userStr)
          if (user.usertype !== 100) {
            alert("你没有访问权限");
            this.$router.push('/login');
            return
          }
          this.supportName = user.username || user.phone || '客服'
        } else {
            alert("你没有访问权限");
            this.$router.push('/login');
            return
        }
      } catch (error) {
        console.error('加载用户信息失败:', error)
        this.supportName = '客服'
      }
    },
    toggleDropdown() {
      this.isDropdownOpen = !this.isDropdownOpen
    },
    switchToCustomer() {
      this.$router.push('/shop')
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
.avatar-icon.support {
  background: linear-gradient(135deg, #06b6d4, #0891b2);
  box-shadow: 0 2px 8px rgba(8,145,178,0.2);
}
.status-dot.support { background-color: #06b6d4; box-shadow: 0 0 5px #06b6d4 }
.sidebar { background: linear-gradient(180deg, #0f172a 0%, #0ea5a1 100%); }
.brand { background: linear-gradient(135deg, #fff, #ecf0f1); -webkit-background-clip: text; background-clip: text; color: transparent; }
</style>
