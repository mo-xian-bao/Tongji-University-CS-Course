import axios from 'axios'

// --- Profile ---
export const getProfile = () => axios.get('/users/profile')
export const updateProfile = (formData) => axios.post('/users/update-profile', formData)
export const changePhone = (data) => axios.post('/users/change-phone', data)
export const changePassword = (data) => axios.post('/users/change-password', data)
export const getUserById = (id) => axios.get(`/users/${id}`)

// --- Follows ---
export const getFollowedRestaurants = () => axios.get('/users/followed-restaurants')

// --- System Notifications ---
export const getSystemNotifications = () => axios.get('/users/system-notifications')

// --- Merchant Application (user side) ---
export const getMyMerchantApplication = () => axios.get('/merchant-application')
export const submitMerchantApplication = (formData) => axios.post('/merchant-application', formData)
export const updateMerchantApplication = (id, formData) => axios.put(`/merchant-application/${id}`, formData)
export const getMerchantApplicationDetail = (id) => axios.get(`/merchant-application/${id}`)

// --- Appeal ---
export const uploadAppealFile = (formData) => axios.post('/appeal/upload', formData)
export const submitAppeal = (data) => axios.post('/appeal', data)
export const downloadAppealAttachment = (attachmentId) => axios.get(`/appeal/${attachmentId}/download`, { responseType: 'blob' })

// --- AI Chat ---
export const aiChat = (question) => axios.post('/ai/chat', { question })
