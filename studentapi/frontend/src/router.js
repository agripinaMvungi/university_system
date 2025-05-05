import { createRouter, createWebHistory } from 'vue-router'
import HomeView from './views/Home.vue'
import StudentsView from './views/Students.vue'
import SubjectsView from './views/Subjects.vue'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: HomeView
  },
  {
    path: '/students',
    name: 'Students',
    component: StudentsView
  },
  {
    path: '/subjects',
    name: 'Subjects',
    component: SubjectsView
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router