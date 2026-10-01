import axios from 'axios'

// --- Restaurant Management ---
export const getMerchantRestaurant = (userId) => axios.get(`/restaurant/user/${userId}`)
export const createRestaurant = (data) => axios.post('/restaurant', data)
export const updateRestaurant = (restaurantId, data) => axios.put(`/restaurant/${restaurantId}`, data)
export const setRestaurantStatus = (restaurantId, isOpen) => axios.patch(`/restaurant/${restaurantId}/status`, { is_open: isOpen })
export const getMyRestaurant = () => axios.get('/users/restaurant')

// --- Order Queue ---
export const getMerchantOrders = () => axios.get('/merchant/orders')
export const getChangeRequests = () => axios.get('/merchant/orders/change-requests')
export const handleChangeRequest = (id, data) => axios.patch(`/merchant/orders/change-requests/${id}`, data)
export const acceptOrder = (orderId) => axios.post(`/merchant/orders/${orderId}/accept`)
export const rejectOrder = (orderId, reason) => axios.post(`/merchant/orders/${orderId}/reject`, { reason })
export const serveOrder = (orderId, status) => axios.post(`/merchant/orders/${orderId}/serve`, { status })
export const releaseSeat = (orderId) => axios.post(`/merchant/orders/${orderId}/release-seat`, { status: 'completed' })
export const updateReservationStatus = (orderId, status) => axios.put(`/merchant/orders/${orderId}/reservation-status`, { status })

// --- Menu Management ---
export const getMerchantMenu = () => axios.get('/merchant/menu')

// --- Dishes CRUD ---
export const createDish = (data) => axios.post('/dishes', data)
export const getDish = (dishId, params) => axios.get(`/dishes/${dishId}`, { params })
export const updateDish = (dishId, data) => axios.put(`/dishes/${dishId}`, data)
export const setDishStatus = (id, status) => axios.patch(`/dishes/${id}/status`, { status })
export const getDishOffShelfInfo = (id) => axios.get(`/dishes/${id}/off-shelf-info`)
export const batchSetDishStatus = (data) => axios.patch('/dishes/batch-status', data)
export const uploadDishImage = (formData) => axios.post('/dishes/upload', formData)

// --- Review Management ---
export const getMerchantReviews = () => axios.get('/merchant/reviews')
export const replyToReview = (id, reply) => axios.post(`/merchant/reviews/${id}/reply`, { reply })

// --- Statistics ---
export const getStatsOverview = (params) => axios.get('/merchant/statistics/overview', { params })
export const getStatsTrend = (params) => axios.get('/merchant/statistics/trend', { params })
export const getStatsPeakHours = (params) => axios.get('/merchant/statistics/peak-hours', { params })
export const getStatsTopDishes = (params) => axios.get('/merchant/statistics/top-dishes', { params })
export const getStatsOrderStatus = (params) => axios.get('/merchant/statistics/order-status', { params })
export const getStatsCategoryShare = (params) => axios.get('/merchant/statistics/category-share', { params })
export const getStatsReviewWordcloud = (params) => axios.get('/merchant/statistics/review-wordcloud', { params })
export const exportStats = (params) => axios.get('/merchant/statistics/export', { params, responseType: 'blob' })

// --- Stock Statistics ---
export const getStockOptions = () => axios.get('/merchant/stock/options')
export const getStockOverview = (params) => axios.get('/merchant/stock/statistics/overview', { params })
export const getStockTrend = (params) => axios.get('/merchant/stock/statistics/trend', { params })
export const getStockInOut = (params) => axios.get('/merchant/stock/statistics/in-out', { params })
export const getStockCostDistribution = (params) => axios.get('/merchant/stock/statistics/cost-distribution', { params })
export const getStockLogs = (params) => axios.get('/merchant/stock/statistics/logs', { params })
export const exportStock = (params) => axios.get('/merchant/stock/statistics/export', { params, responseType: 'blob' })

// --- Table Management ---
export const getTables = () => axios.get('/tables')
export const createTable = (data) => axios.post('/tables', data)
export const getTable = (id) => axios.get(`/tables/${id}`)
export const updateTable = (id, data) => axios.put(`/tables/${id}`, data)
export const deleteTable = (id) => axios.delete(`/tables/${id}`)
export const getReservations = (params) => axios.get('/merchant/reservations', { params })
export const getTableSchedule = (tableId, params) => axios.get(`/merchant/tables/${tableId}/schedule`, { params })

// --- Broadcasts (merchant push) ---
export const createBroadcast = (restaurantId, data) => axios.post(`/restaurant/${restaurantId}/broadcasts`, data)
export const updateBroadcast = (restaurantId, id, data) => axios.patch(`/restaurant/${restaurantId}/broadcasts/${id}`, data)
export const deleteBroadcast = (restaurantId, id) => axios.delete(`/restaurant/${restaurantId}/broadcasts/${id}`)

// --- Coupons (merchant push) ---
export const createCoupon = (restaurantId, data) => axios.post(`/restaurant/${restaurantId}/coupons`, data)

// --- Upload ---
export const uploadMerchantFile = (formData) => axios.post('/merchant/upload', formData)
export const uploadFile = (formData) => axios.post('/upload', formData)
