import axios from 'axios'

// --- Restaurants ---
export const getRestaurants = () => axios.get('/restaurants')
export const getRestaurant = (id) => axios.get(`/restaurants/${id}`)
export const getRestaurantStatus = (restaurantId) => axios.get(`/restaurant/${restaurantId}/status`)
export const getRestaurantByUser = (userId) => axios.get(`/restaurant/user/${userId}`)

// --- Follow ---
export const getFollowStatus = (id) => axios.get(`/restaurants/${id}/follow`)
export const followRestaurant = (id) => axios.post(`/restaurants/${id}/follow`)
export const unfollowRestaurant = (id) => axios.delete(`/restaurants/${id}/follow`)

// --- Menu & Dishes (public) ---
export const getMenu = (restaurantId) => axios.get(`/dishes/menu/${restaurantId}`)
export const getRecommendations = () => axios.get('/dishes/recommendations')

// --- Reviews ---
export const getReviews = (restaurantId) => axios.get(`/restaurant/${restaurantId}/reviews`)
export const likeReview = (reviewId, action) => axios.post(`/reviews/${reviewId}/like`, { action })

// --- Tables (public) ---
export const getRestaurantTables = (restaurantId) => axios.get(`/restaurant/${restaurantId}/tables`)
export const getAvailableSlots = (restaurantId, params) => axios.get(`/restaurant/${restaurantId}/available-slots`, { params })
export const getAvailableTables = (restaurantId, params) => axios.get(`/restaurant/${restaurantId}/tables/available`, { params })

// --- Broadcasts ---
export const getBroadcasts = (params) => axios.get('/restaurant/broadcasts', { params })
export const getBroadcast = (id) => axios.get(`/restaurant/broadcasts/${id}`)

// --- Dish Notifications ---
export const getDishNotifications = (params) => axios.get('/dish-notifications', { params })
export const getDishNotification = (id) => axios.get(`/dish-notifications/${id}`)

// --- Coupons ---
export const getCouponNotifications = (params) => axios.get('/coupon-notifications', { params })
export const getCouponNotification = (id) => axios.get(`/coupon-notifications/${id}`)
export const getCouponRecommendations = (params) => axios.get('/coupons/recommendations', { params })
export const getCouponRecommendation = (id) => axios.get(`/coupons/recommendations/${id}`)
export const acceptCoupon = (id) => axios.post(`/coupons/${id}/accept`)
export const rejectCoupon = (id) => axios.post(`/coupons/${id}/reject`)
