import axios from 'axios'

// --- Review Management ---
export const getAdminReviews = () => axios.get('/admin/reviews')
export const getAdminReviewStats = () => axios.get('/admin/reviews/stats')
export const updateReview = (id, data) => axios.patch(`/admin/reviews/${id}`, data)
export const getReviewKeywords = () => axios.get('/admin/review-keywords')
export const addReviewKeyword = (keyword) => axios.post('/admin/review-keywords', { keyword })
export const deleteReviewKeyword = (id) => axios.delete(`/admin/review-keywords/${id}`)

// --- Account Ban ---
export const getBanStats = () => axios.get('/admin/users/ban/stats')
export const getBanList = (params) => axios.get('/admin/users/ban/list', { params })
export const banUser = (id, data) => axios.post(`/admin/users/${id}/ban`, data)
export const unbanUser = (id) => axios.post(`/admin/users/${id}/unban`)

// --- Appeals ---
export const getAppeals = (params) => axios.get('/admin/appeals', { params })
export const getAppealStats = () => axios.get('/admin/appeals/stats')
export const processAppeal = (id, data) => axios.post(`/admin/appeal/${id}/process`, data)

// --- Merchant Applications ---
export const getMerchantApplications = (params) => axios.get('/admin/merchant-applications', { params })
export const getMerchantApplicationStats = () => axios.get('/admin/merchant-applications/stats')
export const getMerchantApplication = (id) => axios.get(`/admin/merchant-applications/${id}`)
export const approveMerchantApplication = (id) => axios.post(`/admin/merchant-applications/${id}/approve`, {})
export const rejectMerchantApplication = (id, reason) => axios.post(`/admin/merchant-applications/${id}/reject`, { reason })
export const cleanupMerchantApplication = (id) => axios.delete(`/admin/merchant-applications/${id}/cleanup`)

// --- System Notifications ---
export const getAdminNotifications = () => axios.get('/admin/system-notifications')
export const sendSystemNotification = (data) => axios.post('/admin/system-notifications', data)
export const deleteSystemNotification = (adminId, targetAudience, timestamp) => axios.delete(`/admin/system-notifications/${adminId}/${targetAudience}/${timestamp}`)
export const deleteSystemNotificationByAudience = (adminId, targetAudience) => axios.delete(`/admin/system-notifications/${adminId}/${targetAudience}`)
