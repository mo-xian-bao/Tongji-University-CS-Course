import { createRouter, createWebHistory } from 'vue-router'
//登录注册组件
import Login from '../login_register/Login.vue'
import Register from '../login_register/Register.vue'
import ResetPassword from '../login_register/ResetPassword.vue'
import MerchantApplication from '../merchant/MerchantApplication.vue'
import MerchantApplicationDetail from '../merchant/MerchantApplicationDetail.vue'

//用户端组件
import ShopList from '../user/shop/ShopList.vue'
import Restaurant from '../user/shop/Restaurant.vue'
import Checkout from '../user/shop/Checkout.vue'
import OrderForm from '../user/shop/OrderForm.vue'

import OrderManagement from '../user/order/Order_management.vue'
import OrderDetails from '../user/order/Order_details.vue'
import WriteReview from '../user/shop/WriteReview.vue'

import Messages from '../user/messages/Messages.vue'
import ChatDetail from '../user/messages/ChatDetail.vue'
import MerchantChat from '../user/order/MerchantChat.vue'

import Profile from '../user/profile/Profile.vue'
import EditProfile from '../user/profile/EditProfile.vue'
import AppealPage from '../user/profile/AppealPage.vue'
import MyFollows from '../user/profile/MyFollows.vue'
import MyCoupons from '../user/profile/MyCoupons.vue'
import SupportCenter from '../user/profile/SupportCenter.vue'
import NotificationSettings from '../user/profile/NotificationSettings.vue'

// 商家端组件
import MerchantLayout from '../merchant/MerchantLayout.vue'
import Dashboard from '../merchant/views/Dashboard.vue'
import OrderQueue from '../merchant/views/OrderQueue.vue'
import MenuList from '../merchant/views/MenuList.vue'
import StoreInfo from '../merchant/views/StoreInfo.vue'
import ReviewManagement from '../merchant/views/ReviewManagement.vue'
import Statistics from '../merchant/views/Statistics.vue'
import PushNotification from '../merchant/views/PushNotification.vue'
import TableManagement from '../merchant/views/TableManagement.vue'

// 管理员端组件
import AdminLayout from '../admin/AdminLayout.vue'
import AdminDashboard from '../admin/Dashboard.vue'
import SupportLayout from '../support/SupportLayout.vue'
import SupportDesk from '../support/SupportDesk.vue'
import SupportDashboard from '../support/SupportDashboard.vue'
import SupportChat from '../support/SupportChat.vue'
import SupportProcessing from '../support/SupportProcessing.vue'
import StoreApplications from '../admin/StoreApplications.vue'
import AccountBan from '../admin/AccountBan.vue'
import AppealHandling from '../admin/AppealHandling.vue'
import CommentManagement from '../admin/CommentManagement.vue'
import SystemNotification from '../admin/SystemNotification.vue'


const routes = [
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/merchant-chat/:restaurantId?',
    name: 'MerchantChat',
    component: MerchantChat,
    props: (route) => ({
      restaurantId: route.params.restaurantId,
      orderId: route.query.orderId
    })
  },
  {
    path: '/login',
    name: 'Login',
    component: Login
  },
  {
    path: '/shop',
    name: 'ShopList',
    component: ShopList
  },
  {
    path: '/messages',
    name: 'Messages',
    component: Messages
  },
  {
    path: '/messages/:id',
    name: 'MessageDetail',
    component: ChatDetail
  },
  {
    path: '/mine',
    name: 'Profile',
    component: Profile
  },
  {
    path: '/checkout',
    name: 'Checkout',
    component: Checkout
  },
    {
      path: '/user/shop/order-form',
      name: 'UserOrderForm',
      component: OrderForm,
      meta: { requiresAuth: true }
    },
    {
    path: '/register',
    name: 'Register',
    component: Register
  },
  {
    path: '/reset-password',
    name: 'ResetPassword',
    component: ResetPassword
  },
  {
    path: '/merchant-application',
    name: 'MerchantApplication',
    component: MerchantApplication
  },
  {
    path: '/merchant-application/:id',
    name: 'MerchantApplicationDetail',
    component: MerchantApplicationDetail,
    meta: { requiresAuth: true }
  },
  {
    path: '/restaurant',
    name: 'Restaurant',
    component: Restaurant,
    props: (route) => ({ id: route.query.id }) // 将查询参数转换为组件属性
  },
  {
    path: '/orders',
    name: 'OrderManagement',
    component: OrderManagement
  },
  // 2. 添加新的详情页路由
  {
    path: '/order/:id', // 使用动态参数 :id
    name: 'OrderDetails',
    component: OrderDetails
  },
  {
    path: '/write-review/:orderId',
    name: 'WriteReview',
    component: WriteReview,
    props: true
  },
  // 2. 添加新的个人中心路由
  {
    path: '/profile',
    name: 'Profile',
    component: Profile
  },
  {
    path: '/profile/support',
    name: 'SupportCenter',
    component: SupportCenter,
    meta: { requiresAuth: true }
  },
  {
    path: '/edit-profile',
    name: 'EditProfile',
    component: EditProfile,
    meta: { requiresAuth: true }
  },
  {
    path: '/appeal',
    name: 'AppealPage',
    component: AppealPage
  },
  {
    path: '/my-follows',
    name: 'MyFollows',
    component: MyFollows,
    meta: { requiresAuth: true }
  },
  {
    path: '/my-coupons',
    name: 'MyCoupons',
    component: MyCoupons,
    meta: { requiresAuth: true }
  },
  {
    path: '/profile/notification-settings',
    name: 'NotificationSettings',
    component: NotificationSettings,
    meta: { requiresAuth: true }
  },
  // 商家端路由
  {
    path: '/merchant',
    component: MerchantLayout,
    children: [
      {
        path: '',
        redirect: '/merchant/dashboard'
      },
      {
        path: 'dashboard',
        name: 'MerchantDashboard',
        component: Dashboard
      },
      {
        path: 'orders',
        name: 'MerchantOrders',
        component: OrderQueue
      },
      {
        path: 'tables',
        name: 'MerchantTables',
        component: TableManagement
      },
      {
        path: 'menu',
        name: 'MerchantMenu',
        component: MenuList,
        props: (route) => ({ restaurantId: route.query.restaurant_id || 1 }) // 默认餐厅ID为1
      },
      {
        path: 'store',
        name: 'MerchantStore',
        component: StoreInfo
      },
      {
        path: 'reviews',
        name: 'MerchantReviews',
        component: ReviewManagement
      },
      {
        path: 'stats',
        name: 'MerchantStats',
        component: Statistics
      },
      {
        path: 'push',
        name: 'MerchantPush',
        component: PushNotification
      }
    ]
  },
  // 客服页（独立页面组）
  {
    path: '/support',
    component: SupportLayout,
    children: [
      { path: '', redirect: '/support/dashboard' },
      { path: 'dashboard', name: 'SupportDashboard', component: SupportDashboard },
      { path: 'tickets', name: 'SupportDesk', component: SupportDesk },
      { path: 'chat', name: 'SupportChat', component: SupportChat },
      { path: 'processing', name: 'SupportProcessing', component: SupportProcessing }
    ]
  },
  // 管理员端路由
  {
    path: '/admin',
    component: AdminLayout,
    children: [
      {
        path: '',
        redirect: '/admin/dashboard'
      },
      {
        path: 'dashboard',
        name: 'AdminDashboard',
        component: AdminDashboard
      },
      {
        path: 'store-applications',
        name: 'StoreApplications',
        component: StoreApplications
      },
      {
        path: 'account-ban',
        name: 'AccountBan',
        component: AccountBan
      },
      {
        path: 'appeal-handling',
        name: 'AppealHandling',
        component: AppealHandling
      },
      {
        path: 'comment-management',
        name: 'CommentManagement',
        component: CommentManagement
      },
      {
        path: 'system-notification',
        name: 'SystemNotification',
        component: SystemNotification
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router