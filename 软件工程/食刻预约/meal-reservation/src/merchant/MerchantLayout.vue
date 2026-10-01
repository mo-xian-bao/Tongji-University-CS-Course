<template>
  <div class="app-root">

    <div v-if="isOrderBlockOpen" class="modal-backdrop" role="dialog" aria-modal="true" aria-label="订单未处理提示">
      <div class="modal">
        <div class="modal-title">提示</div>
        <div class="modal-content">{{ orderBlockMessage }}</div>
        <div class="modal-actions">
          <button class="btn-secondary" type="button" @click="closeOrderBlock">我知道了</button>
        </div>
      </div>
    </div>

    <div v-if="isBusinessConfirmOpen" class="modal-backdrop" role="dialog" aria-modal="true" :aria-label="businessConfirmTitle">
      <div class="modal">
        <div class="modal-title">{{ businessConfirmTitle }}</div>
        <div class="modal-content">{{ businessConfirmContent }}</div>
        <div class="modal-actions">
          <button class="btn-outline" type="button" :disabled="isUpdatingBusinessStatus" @click="cancelBusinessConfirm">取消</button>
          <button :class="businessConfirmButtonClass" type="button" :disabled="isUpdatingBusinessStatus" @click="confirmBusinessConfirm">{{ businessConfirmButtonText }}</button>
        </div>
      </div>
    </div>

    <main class="main-area">
      <header class="topbar global-top-bar">
        <div class="brand">
          <!-- 汉堡按钮：放在侧栏品牌左侧，控制侧栏收起/展开（不影响品牌文字） -->
          <button class="sidebar-hamburger" @click.stop="toggleSidebar" :aria-expanded="!isSidebarCollapsed" :title="isSidebarCollapsed ? '展开侧栏' : '收起侧栏'">
            <svg width="18" height="14" viewBox="0 0 24 18" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
              <path d="M3 3h18M3 9h18M3 15h18" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>
            </svg>
          </button>
          食刻预约 - 商家端
        </div>
        <div class="brand">
          <div class="brand-badge">
            <span class="brand-mark">食约</span>
          </div>
          <div class="brand-info">
            <span class="brand-title">{{ pageTitle }}</span>
            <span class="brand-subtitle">商家运营后台</span>
          </div>
        </div>

        <div class="top-actions">
          <button class="ghost-btn" @click="openHelp">帮助中心</button>
          <div class="store-switcher" @click="openStoreSwitcher">
            <span class="store-name">{{ storeName }}</span>
          </div>

          <div class="user-profile" @click="toggleDropdown">
            <div class="avatar-icon">
              {{ getAvatarLetter }}
            </div>
            <span class="user-name">{{ merchantName }}</span>
            <div class="status-indicator">
              <span :class="['status-dot', isOnline ? 'online' : 'offline']"></span>
              <span>{{ isOnline ? '营业中' : '已打烊' }}</span>
            </div>
            <svg class="dropdown-arrow" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
              <path d="M7 10l5 5 5-5H7z"/>
            </svg>

            <div v-if="isDropdownOpen" class="dropdown-menu">
              <ul>
                <li>
                  <a
                    href="#"
                    @click.prevent.stop="toggleBusinessStatus"
                    :class="['business-toggle', isOnline ? 'business-toggle-close' : 'business-toggle-open']"
                  >
                    {{ isOnline ? '打烊' : '开始营业' }}
                  </a>
                </li>
                <li><a href="#" @click.prevent.stop="goStoreInfo">店铺信息</a></li>
                <li><a href="#" @click.prevent.stop="switchToCustomer">切换至顾客端</a></li>
                <li><a href="#" @click.prevent.stop="logout">退出登录</a></li>
              </ul>
            </div>
          </div>
        </div>
      </header>
      <main class="main-content">
        <aside :class="['sidebar', { collapsed: isSidebarCollapsed }]">
          <div class="sidebar-inner">
          <nav>
            <router-link to="/merchant/dashboard" class="nav-item" title="仪表盘">
              <span class="nav-icon" aria-hidden="true">
                <!-- home icon -->
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none"><path d="M3 11.5L12 4l9 7.5" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/><path d="M5 21V11h14v10" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/></svg>
              </span>
              <span class="nav-label">仪表盘</span>
            </router-link>

            <router-link to="/merchant/orders" class="nav-item" title="订单管理">
              <span class="nav-icon" aria-hidden="true">
                <!-- cart icon -->
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none"><path d="M6 6h15l-1.5 9h-12z" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/><circle cx="9" cy="20" r="1" fill="currentColor"/><circle cx="18" cy="20" r="1" fill="currentColor"/></svg>
              </span>
              <span class="nav-label">订单管理</span>
            </router-link>

            <router-link to="/merchant/menu" class="nav-item" title="菜品管理">
              <span class="nav-icon" aria-hidden="true">
                <!-- dish/menu icon -->
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none"><path d="M12 2a10 10 0 0 0-9 14h18A10 10 0 0 0 12 2z" stroke="currentColor" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round"/></svg>
              </span>
              <span class="nav-label">菜品管理</span>
            </router-link>

            <router-link to="/merchant/tables" class="nav-item" title="桌位管理">
              <span class="nav-icon" aria-hidden="true">
                <!-- table icon -->
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none"><path d="M3 7h18M6 21V7M18 21V7" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/></svg>
              </span>
              <span class="nav-label">桌位管理</span>
            </router-link>

            <router-link to="/merchant/store" class="nav-item" title="店铺信息">
              <span class="nav-icon" aria-hidden="true">
                <!-- store icon -->
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none"><path d="M3 7h18v11a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V7z" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/><path d="M3 7l9-4 9 4" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/></svg>
              </span>
              <span class="nav-label">店铺信息</span>
            </router-link>

            <router-link to="/merchant/reviews" class="nav-item" title="评论管理">
              <span class="nav-icon" aria-hidden="true">
                <!-- chat icon -->
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none"><path d="M21 15a2 2 0 0 1-2 2H8l-5 3V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/></svg>
              </span>
              <span class="nav-label">评论管理</span>
            </router-link>

            <router-link to="/merchant/stats" class="nav-item" title="数据统计">
              <span class="nav-icon" aria-hidden="true">
                <!-- chart icon -->
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none"><path d="M3 3v18h18" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/><path d="M7 13v6M12 9v10M17 5v14" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/></svg>
              </span>
              <span class="nav-label">数据统计</span>
            </router-link>

            <router-link to="/merchant/push" class="nav-item" title="推送通知">
              <span class="nav-icon" aria-hidden="true">
                <!-- bell/notice icon -->
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none"><path d="M18 8a6 6 0 0 0-12 0c0 7-3 8-3 8h18s-3-1-3-8" stroke="currentColor" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/><path d="M13.73 21a2 2 0 0 1-3.46 0" stroke="currentColor" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/></svg>
              </span>
              <span class="nav-label">推送通知</span>
            </router-link>
          </nav>
          </div>
        </aside>
        <section class="content">
          <router-view />
        </section>
      </main>
    </main>
  </div>
</template>

<script>
export default {
  data() {
    return {
      // 侧栏折叠状态（保存在 localStorage）
      isSidebarCollapsed: JSON.parse(localStorage.getItem('sidebar_collapsed') || 'false'),
      merchantName: '',
      storeName: '加载中...',
      isOnline: true,
      restaurantId: null,
      isDropdownOpen: false,
      isBusinessConfirmOpen: false,
      pendingBusinessIsOpen: null,
      isUpdatingBusinessStatus: false,
      isOrderBlockOpen: false,
      orderBlockMessage: '仍有订单未处理，请先处理订单',
      pageTitleMap: {
        '/merchant/dashboard': '仪表盘',
        '/merchant/orders': '订单管理',
        '/merchant/menu': '菜品管理',
        '/merchant/tables': '桌位管理',
        '/merchant/store': '店铺信息',
        '/merchant/reviews': '评论管理',
        '/merchant/stats': '数据统计',
        '/merchant/push': '商家广播中心'
      }
    }
  },
  computed: {
    getAvatarLetter() {
      return this.merchantName ? this.merchantName.charAt(0) : '?'
    },
    pageTitle() {
      return this.$route?.meta?.title || this.pageTitleMap[this.$route.path] || '商家控制台'
    },
    businessConfirmTitle() {
      return this.pendingBusinessIsOpen ? '确认开始营业' : '确认打烊'
    },
    businessConfirmContent() {
      return this.pendingBusinessIsOpen
        ? '确认要开始营业吗？开始营业后顾客端将可以下单。'
        : '确认要打烊吗？打烊后顾客端将无法下单。'
    },
    businessConfirmButtonText() {
      return this.pendingBusinessIsOpen ? '确认开始营业' : '确认打烊'
    },
    businessConfirmButtonClass() {
      return this.pendingBusinessIsOpen ? 'btn-secondary' : 'btn-danger'
    }
  },
  mounted() {
    this.loadCurrentUser()
  },
  methods: {
    toggleSidebar() {
      this.isSidebarCollapsed = !this.isSidebarCollapsed
      try { localStorage.setItem('sidebar_collapsed', JSON.stringify(this.isSidebarCollapsed)) } catch (e) {}
    },
    loadCurrentUser() {
      try {
        // 从localStorage获取用户信息
        const userStr = localStorage.getItem('user')
        if (userStr) {
          const user = JSON.parse(userStr)
          // 优先显示用户名，如果没有则显示手机号，最后显示"用户"
          this.merchantName = user.username || user.phone || '用户'
          
          if (user.id) {
            this.fetchRestaurantInfo(user.id)
          }
        } else {
          this.merchantName = '未登录'
        }
      } catch (error) {
        console.error('加载用户信息失败:', error)
        this.merchantName = '用户'
      }
    },
    async fetchRestaurantInfo(userId) {
      try {
        const token = localStorage.getItem('token')
        const response = await fetch(`/api/restaurant/user/${userId}`, {
          headers: {
            'Authorization': `Bearer ${token}`
          }
        })
        const res = await response.json()
        console.log('餐厅信息响应:', res)
        if (res.success && res.data && res.data.restaurant) {
          this.storeName = res.data.restaurant.name || '未命名餐厅'
          this.restaurantId = res.data.restaurant.id
          // 缓存餐厅ID供其他组件使用
          if (this.restaurantId != null) {
            localStorage.setItem('restaurant_id', String(this.restaurantId))
          }
          if (this.restaurantId != null) {
            await this.fetchRestaurantStatus(this.restaurantId)
          }
        } else {
          this.storeName = '未创建餐厅'
          this.restaurantId = null
        }
      } catch (error) {
        console.error('获取餐厅信息失败:', error)
        this.storeName = '获取失败'
        this.restaurantId = null
      }
    },
    async fetchRestaurantStatus(restaurantId) {
      try {
        const token = localStorage.getItem('token')
        const response = await fetch(`/api/restaurant/${restaurantId}/status`, {
          headers: {
            'Authorization': `Bearer ${token}`
          }
        })
        const res = await response.json()
        if (res.success && res.data && typeof res.data.is_open === 'boolean') {
          this.isOnline = res.data.is_open
        }
      } catch (error) {
        console.error('获取营业状态失败:', error)
      }
    },

    async fetchMerchantOrders() {
      try {
        const token = localStorage.getItem('token')
        if (!token) return []

        const response = await fetch('/api/merchant/orders', {
          method: 'GET',
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
          }
        })

        const result = await response.json()
        if (result && result.success && Array.isArray(result.data)) {
          return result.data
        }
        return []
      } catch (error) {
        console.error('获取订单列表失败:', error)
        return []
      }
    },

    async hasUnprocessedOrders() {
      const activeStatuses = new Set(['pending'])
      const orders = await this.fetchMerchantOrders()
      return orders.some(o => activeStatuses.has(o?.status))
    },
    closeOrderBlock() {
      this.isOrderBlockOpen = false
    },
    async toggleBusinessStatus() {
      try {
        const restaurantId = this.restaurantId ?? localStorage.getItem('restaurant_id')
        if (!restaurantId) {
          this.isDropdownOpen = false
          return
        }

        const nextIsOpen = !this.isOnline

        // 打烊前检查是否仍有待处理订单
        if (!nextIsOpen) {
          const hasUnprocessed = await this.hasUnprocessedOrders()
          if (hasUnprocessed) {
            this.isDropdownOpen = false
            this.isOrderBlockOpen = true
            return
          }
        }

        // 开始营业/打烊都需要二次确认
        this.pendingBusinessIsOpen = nextIsOpen
        this.isDropdownOpen = false
        this.isBusinessConfirmOpen = true
        return
      } catch (error) {
        console.error('切换营业状态失败:', error)
      } finally {
        // 弹窗流程由按钮统一关闭
        if (!this.isBusinessConfirmOpen) {
          this.isDropdownOpen = false
        }
      }
    },
    async setBusinessStatus(restaurantId, isOpen) {
      try {
        this.isUpdatingBusinessStatus = true
        const token = localStorage.getItem('token')

        const response = await fetch(`/api/restaurant/${restaurantId}/status`, {
          method: 'PATCH',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`
          },
          body: JSON.stringify({ is_open: isOpen })
        })

        const res = await response.json()
        if (res.success && res.data && typeof res.data.is_open === 'boolean') {
          this.isOnline = res.data.is_open
        }
      } finally {
        this.isUpdatingBusinessStatus = false
      }
    },
    cancelBusinessConfirm() {
      this.isBusinessConfirmOpen = false
      this.pendingBusinessIsOpen = null
      this.isDropdownOpen = false
    },
    async confirmBusinessConfirm() {
      try {
        const restaurantId = this.restaurantId ?? localStorage.getItem('restaurant_id')
        if (!restaurantId) {
          return
        }
        if (typeof this.pendingBusinessIsOpen !== 'boolean') {
          return
        }
        await this.setBusinessStatus(restaurantId, this.pendingBusinessIsOpen)
      } catch (error) {
        console.error('更新营业状态失败:', error)
      } finally {
        this.isBusinessConfirmOpen = false
        this.pendingBusinessIsOpen = null
        this.isDropdownOpen = false
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
    goStoreInfo() {
      this.$router.replace({ name: 'MerchantStore', query: { t: Date.now() } })
      // 跳转后关闭下拉菜单
      this.isDropdownOpen = false
    },
    closeDropdownOnClickOutside(event) {
      const userProfile = this.$el.querySelector('.user-profile')
      if (userProfile && !userProfile.contains(event.target)) {
        this.isDropdownOpen = false
      }
    },
    openHelp() {
      window.open('https://gitlab.com/tj-cs-swe/CS10102302-2025/group11/meal-reservation', '_blank')
    },
    openStoreSwitcher() {
      try {
        const restaurantId = localStorage.getItem('restaurant_id')
        const query = { t: Date.now() }
        if (restaurantId) query.restaurant_id = restaurantId
        this.$router.push({ name: 'MerchantStore', query })
      } catch (err) {
        // fallback navigation
        this.$router.push({ name: 'MerchantStore' })
      }
    },
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
.global-top-bar {
  display: flex;
  justify-content: flex-start;
  align-items: center;
  height: 72px;
  min-height: 72px;
  min-width: 900px;
  flex-wrap: nowrap;
  flex-shrink: 0;
  background: linear-gradient(90deg, #f97316 0%, #f59e0b 100%);
  color: #fff;
  box-shadow: 0 6px 20px rgba(249, 115, 22, 0.25);
}

.brand {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 20px 40px 20px 0px;
  flex-shrink: 0;
  white-space: nowrap;
}

.brand-badge {
  display: inline-flex;
  align-items: center;
  gap: 8px;
}

.brand-mark {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.18);
  border-radius: 14px;
  padding: 6px 14px;
  font-weight: 600;
  letter-spacing: 0.08em;
}

.brand-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.brand-title {
  font-size: 20px;
  font-weight: 600;
  letter-spacing: 0.02em;
}

.brand-subtitle {
  font-size: 12px;
  opacity: 0.85;
}

.top-actions {
  display: flex;
  align-items: center;
  gap: 18px;
  margin-left: auto;
  flex-shrink: 0;
}

.ghost-btn {
  background: rgba(255, 255, 255, 0.12);
  color: #fff;
  border: none;
  border-radius: 999px;
  padding: 8px 18px;
  font-size: 14px;
  cursor: pointer;
  transition: background 0.2s ease, transform 0.2s ease, box-shadow 0.2s ease;
  white-space: nowrap;
}

.ghost-btn:hover {
  background: rgba(255, 255, 255, 0.22);
  transform: translateY(-1px);
  box-shadow: 0 8px 18px rgba(255, 255, 255, 0.18);
}

.store-switcher {
  background: rgba(255, 255, 255, 0.16);
  padding: 8px 14px;
  border-radius: 999px;
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  transition: background 0.2s ease;
  white-space: nowrap;
}

.store-switcher:hover {
  background: rgba(255, 255, 255, 0.26);
}

.store-name {
  font-weight: 500;
}

.icon-down {
  width: 16px;
  height: 16px;
  color: #fff;
}

.user-profile {
  display: flex;
  align-items: center;
  gap: 10px;
  background: rgba(255, 255, 255, 0.16);
  padding: 8px 14px;
  border-radius: 16px;
  cursor: pointer;
  position: relative;
  transition: background 0.2s ease;
  white-space: nowrap;
}

.user-profile:hover {
  background: rgba(255, 255, 255, 0.26);
}

.avatar-icon {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.22);
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
}

.dropdown-menu {
  position: absolute;
  top: calc(100% + 12px);
  right: 0;
  background: #ffffff;
  color: #1f2937;
  border-radius: 12px;
  box-shadow: 0 14px 28px rgba(15, 23, 42, 0.18);
  overflow: hidden;
  z-index: 10;
  min-width: 180px;
}

.dropdown-menu ul {
  list-style: none;
  padding: 8px 0;
  margin: 0;
}

.dropdown-menu li a {
  display: block;
  padding: 10px 18px;
  color: inherit;
  text-decoration: none;
  font-size: 14px;
}

.dropdown-menu li a:hover {
  background: rgba(2, 132, 199, 0.08);
}
.dropdown-menu li a.business-toggle {
  font-weight: 700;
}

.dropdown-menu li a.business-toggle-open {
  background: rgba(46, 204, 113, 0.12);
  color: #166534;
}

.dropdown-menu li a.business-toggle-open:hover {
  background: rgba(46, 204, 113, 0.18);
}

.dropdown-menu li a.business-toggle-close {
  background: rgba(239, 68, 68, 0.12);
  color: #991b1b;
}

.dropdown-menu li a.business-toggle-close:hover {
  background: rgba(239, 68, 68, 0.18);
}

.modal-backdrop {
  position: fixed;
  inset: 0;
  background: rgba(15, 23, 42, 0.45);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2000;
}

.modal {
  width: min(420px, calc(100vw - 32px));
  background: #ffffff;
  color: #1f2937;
  border-radius: 14px;
  box-shadow: 0 18px 38px rgba(15, 23, 42, 0.22);
  padding: 18px 18px 16px;
}

.modal-title {
  font-size: 16px;
  font-weight: 700;
  margin-bottom: 10px;
}

.modal-content {
  font-size: 14px;
  line-height: 1.55;
  color: #374151;
}

.modal-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 16px;
}
.main-content {
  display: flex;
  height: calc(100vh - 72px); /* 减去顶部栏高度 */
}

/* minimal icon layout for sidebar items */
.nav-item {
  display: flex;
  align-items: center;
  gap: 10px; /* keep spacing consistent */
  padding: 10px 14px;
  color: inherit;
  text-decoration: none;
  position: relative; /* allow pseudo-element indicator */
}

.nav-icon {
  width: 20px;
  height: 20px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  color: rgba(255,255,255,0.95); /* match sidebar text */
}

/* ensure SVGs inherit currentColor */
.nav-icon svg { color: inherit; fill: none; }

/* hover visuals */
.nav-item:hover {
  background: rgba(255,255,255,0.06);
}

/* 明确设置选中样式（在 scoped 样式中也声明），保证收起时高亮条和文字加粗仍然可见 */
.nav-item.router-link-active {
  background: rgba(255,255,255,0.18);
  color: white;
  border-left-color: #fed7aa;
  font-weight: 600;
}

/* 侧栏折叠样式（仅增加必要规则） */
.sidebar {
  width: 220px;
  transition: width 320ms cubic-bezier(.2,.9,.2,1);
  overflow: hidden; /* hide clipped inner content during transition */
}
.sidebar .sidebar-top { display:flex; align-items:center; gap:10px; padding:12px 14px; }

.collapse-btn {
  width:28px; height:34px; border-radius:8px; border:none;
  background: rgba(255,255,255,0.04); color: inherit; cursor: pointer;
  display:inline-flex; align-items:center; justify-content:center;
}
.sidebar-brand { font-weight:600; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }

/* collapsed 状态：收窄侧栏，仅显示图标（图标居中） */
.sidebar.collapsed {
  width: 72px;
}
.sidebar.collapsed .sidebar-brand { display:none !important; }
.sidebar.collapsed nav { padding-left: 0; padding-right: 0; }
.sidebar.collapsed .nav-item { justify-content: center; padding: 8px 8px; }
.sidebar.collapsed .nav-label { display: none; }

/* 内部容器：在宽度变化时平滑过渡内部元素（位移与透明度），减少布局抖动 */
.sidebar-inner {
  display: block;
  transition: transform 260ms cubic-bezier(.2,.9,.2,1), opacity 260ms ease;
  will-change: transform, opacity;
}
.sidebar.collapsed .sidebar-inner {
  /* 不再整体左移以避免把左侧高亮条裁切掉（sidebar overflow:hidden 会裁切位移内容） */
  transform: none;
  opacity: 0.98;
}

/* 文本标签淡出并略微左移 */
.nav-label {
  display: inline-block;
  max-width: 220px; /* reserve space for expanded label */
  white-space: nowrap;
  overflow: hidden;
  vertical-align: middle;
  transition: max-width 280ms cubic-bezier(.2,.9,.2,1), opacity 220ms ease, transform 220ms ease;
  transform-origin: left center;
}
.sidebar.collapsed .nav-label {
  max-width: 0;
  opacity: 0;
  transform: translateX(-6px);
  pointer-events: none;
}

/* 用伪元素作为选中指示器，放在 nav-item 内部左侧，不会被 nav-label 的收缩影响 */

.nav-item.router-link-active::before {
  background-color: #fed7aa;
}

/* 让 brand 区域在收起/展开时平滑调整间距 */
.brand {
  transition: padding 220ms ease, gap 220ms ease;
}
.sidebar.collapsed .brand {
  gap: 8px;
  padding-left: 12px;
}

/* 保持图标大小与对齐 */
.nav-icon { width:20px; height:20px; display:inline-flex; align-items:center; justify-content:center; }

@media (max-width: 768px) {
  .brand-title {
    font-size: 16px;
  }

  .brand-subtitle {
    font-size: 11px;
  }

  .top-actions {
    gap: 12px;
  }

  .ghost-btn,
  .store-switcher {
    font-size: 13px;
    padding: 6px 12px;
  }

  .user-profile {
    padding: 6px 10px;
  }

  .avatar-icon {
    width: 28px;
    height: 28px;
    font-size: 13px;
  }

  .user-name {
    font-size: 13px;
  }

  .status-indicator {
    font-size: 12px;
  }
}

/* 侧栏内的汉堡按钮，放在品牌左侧，不影响品牌字体或样式 */
.sidebar .brand {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 16px;
  font-weight: 600; /* 保持原来品牌样式不变 */
}

.sidebar-hamburger {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  padding: 0;
  border-radius: 8px;
  border: none;
  background: rgba(255, 255, 255, 0.09);
  color: inherit;
  cursor: pointer;
}
.sidebar-hamburger:hover { background: rgba(255,255,255,0.08); transform: translateY(-1px); }

/* 让汉堡图标的 SVG 进行平滑旋转，不与按钮的 hover transform 冲突 */
.sidebar-hamburger svg {
  transition: transform 200ms ease;
  transform-origin: center;
}

/* 当 aria-expanded 为 false（侧栏收起/状态切换后），将图标旋转 90deg */
.sidebar-hamburger[aria-expanded="false"] svg {
  transform: rotate(90deg);
}

/* collapsed 状态：收窄侧栏，仅隐藏 nav 文本，但不要隐藏品牌文本（保持固定显示） */
.sidebar.collapsed {
  width: 72px;
}
.sidebar.collapsed .nav-item { justify-content: center; padding: 10px 8px; }
.sidebar.collapsed .nav-label { display: none; }

/* 确保品牌区在收起时仍然可见（不要将 brand 隐藏/截断为不可见） */
.sidebar .brand { white-space: nowrap; }
</style>