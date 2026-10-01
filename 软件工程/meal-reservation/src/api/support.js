import axios from 'axios'

// --- Tickets ---
export const getTickets = (params) => axios.get('/support/tickets', { params })
export const createTicket = (data) => axios.post('/support/tickets', data)
export const getTicket = (id) => axios.get(`/support/tickets/${id}`)
export const updateTicket = (id, data) => axios.put(`/support/tickets/${id}`, data)
export const replyTicket = (id, data) => axios.post(`/support/tickets/${id}/reply`, data)
export const addInternalNote = (id, data) => axios.post(`/support/tickets/${id}/internal_notes`, data)

// --- Support Dashboard/Desk (staff) ---
export const getAssignedTickets = () => axios.get('/support/get_tickets')
export const getAllTickets = () => axios.get('/support/get_alltickets')
