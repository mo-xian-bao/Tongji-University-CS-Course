import axios from 'axios'

// --- Orders ---
export const getOrders = () => axios.get('/orders')
export const getOrder = (id) => axios.get(`/orders/${id}`)
export const createOrder = (data) => axios.post('/orders/create', data)
export const updateOrder = (id, data) => axios.put(`/orders/${id}`, data)
export const cancelOrder = (id) => axios.post(`/orders/${id}/cancel`)
export const requestChange = (id, data) => axios.post(`/orders/${id}/request-change`, data)

// --- Order Reviews ---
export const getOrderReview = (id) => axios.get(`/orders/${id}/review`)
export const submitReview = (data) => axios.post('/reviews', data)

// --- Pickup Notifications ---
export const getPickupNotifications = () => axios.get('/orders/pickup-notifications')
export const getPickupNotification = (id) => axios.get(`/orders/pickup-notifications/${id}`)

// --- Chat Messages (order-related) ---
export const getMessages = (params) => axios.get('/messages', { params })
export const sendMessage = (data) => axios.post('/messages', data)
