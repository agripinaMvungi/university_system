import axios from 'axios'

const apiClient = axios.create({
  baseURL: process.env.NODE_ENV === 'development' 
    ? 'http://localhost:8000/studentapi'  // Proxy in development
    : 'http://3.85.238.66:8000/studentapi', // Direct in production
  withCredentials: false,
  headers: {
    'Accept': 'application/json',
    'Content-Type': 'application/json'
  }
})

export default {
  getStudents() {
    return apiClient.get('/students/')
  },
  getSubjects() {
    return apiClient.get('/subjects/')
  }
}