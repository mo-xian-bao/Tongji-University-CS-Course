import axios from 'axios'

// Token validation
export const validateToken = () => axios.get('/auth/validate')

// Login & Register
export const login = (data) => axios.post('/login', data)
export const register = (data) => axios.post('/register', data)

// Password reset
export const sendResetPasswordCode = (phone) => axios.post('/reset-password/send-code', { phone })
export const resetPassword = (data) => axios.post('/reset-password', data)

// SMS
export const sendSms = (phone, purpose) => axios.post('/sms/send', { phone, purpose })

// Validation checks
export const checkPhone = (phone) => axios.get('/check-phone', { params: { phone } })
export const checkUsername = (username) => axios.get('/check-username', { params: { username } })
