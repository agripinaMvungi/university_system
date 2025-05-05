<template>
  <div class="students-container">
    <h1>Students List</h1>
    <div class="node-info">
      <span class="node-label">Served by:</span>
      <span class="node-id">{{ currentNode }}</span>
    </div>

    <div v-if="loading" class="loading-indicator">
      <div class="spinner"></div>
      <span>Loading students...</span>
    </div>

    <div v-else>
      <div class="controls">
        <input 
          v-model="searchQuery" 
          placeholder="Search students..." 
          class="search-input"
        >
        <div class="sort-controls">
          <button @click="sortBy('name')" class="sort-button">
            Sort by Name {{ sortField === 'name' ? (sortAsc ? '↑' : '↓') : '' }}
          </button>
          <button @click="sortBy('enrollment_date')" class="sort-button">
            Sort by Date {{ sortField === 'enrollment_date' ? (sortAsc ? '↑' : '↓') : '' }}
          </button>
        </div>
      </div>

      <ul v-if="filteredStudents.length > 0" class="student-list">
        <li v-for="student in filteredStudents" :key="student.id" class="student-item">
          <div class="student-info">
            <span class="student-name">{{ student.name }}</span>
            <span class="student-program">{{ getProgramName(student.program) }}</span>
          </div>
          <span class="enrollment-date">
            Enrolled: {{ formatDate(student.enrollment_date) }}
          </span>
        </li>
      </ul>
      <p v-else class="no-data">No students found matching your search</p>

      <div class="pagination" v-if="filteredStudents.length > itemsPerPage">
        <button 
          @click="currentPage--" 
          :disabled="currentPage === 1"
          class="page-button"
        >
          Previous
        </button>
        <span class="page-info">Page {{ currentPage }} of {{ totalPages }}</span>
        <button 
          @click="currentPage++" 
          :disabled="currentPage === totalPages"
          class="page-button"
        >
          Next
        </button>
      </div>
    </div>

    <button @click="$router.push('/')" class="back-button">
      Back to Home
    </button>
  </div>
</template>

<script>
import api from '@/services/api'

export default {
  name: 'StudentsPage',
  data() {
    return {
      students: [],
      loading: false,
      currentNode: 'Unknown',
      searchQuery: '',
      sortField: 'name',
      sortAsc: true,
      currentPage: 1,
      itemsPerPage: 5,
      programs: {
        1: 'Software Engineering',
        2: 'Computer Science',
        3: 'Information Technology'
      }
    }
  },
  created() {
    this.fetchStudents()
  },
  computed: {
    filteredStudents() {
      let filtered = this.students.filter(student =>
        student.name.toLowerCase().includes(this.searchQuery.toLowerCase())
      )

      filtered.sort((a, b) => {
        if (a[this.sortField] < b[this.sortField]) return this.sortAsc ? -1 : 1
        if (a[this.sortField] > b[this.sortField]) return this.sortAsc ? 1 : -1
        return 0
      })

      return filtered
    },
    totalPages() {
      return Math.ceil(this.filteredStudents.length / this.itemsPerPage)
    },
    paginatedStudents() {
      const start = (this.currentPage - 1) * this.itemsPerPage
      const end = start + this.itemsPerPage
      return this.filteredStudents.slice(start, end)
    }
  },
  methods: {
    async fetchStudents() {
      this.loading = true
      try {
        const response = await api.getStudents()
        this.students = response.data
        this.currentNode = response.headers['x-node-id'] || 'Unknown'
      } catch (error) {
        console.error('Error fetching students:', error)
        this.$notify({
          type: 'error',
          title: 'Error',
          text: 'Failed to load students data'
        })
      } finally {
        this.loading = false
      }
    },
    getProgramName(programId) {
      return this.programs[programId] || `Program ${programId}`
    },
    formatDate(dateString) {
      const options = { year: 'numeric', month: 'long', day: 'numeric' }
      return new Date(dateString).toLocaleDateString(undefined, options)
    },
    sortBy(field) {
      if (this.sortField === field) {
        this.sortAsc = !this.sortAsc
      } else {
        this.sortField = field
        this.sortAsc = true
      }
    }
  }
}
</script>


<style scoped>
.students-container {
  max-width: 800px;
  margin: 0 auto;
  padding: 2rem;
  font-family: 'Arial', sans-serif;
}

.node-info {
  margin: 1rem 0;
  padding: 0.5rem;
  background-color: #f0f0f0;
  border-radius: 4px;
}

.controls {
  display: flex;
  justify-content: space-between;
  margin: 1rem 0;
  flex-wrap: wrap;
  gap: 1rem;
}

.search-input {
  padding: 0.5rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  flex-grow: 1;
}

.sort-controls {
  display: flex;
  gap: 0.5rem;
}

.sort-button, .page-button {
  padding: 0.5rem 1rem;
  background-color: #e0e0e0;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.sort-button:hover, .page-button:hover {
  background-color: #d0d0d0;
}

.sort-button:disabled, .page-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.student-list {
  list-style: none;
  padding: 0;
  margin: 2rem 0;
}

.student-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem;
  margin-bottom: 0.5rem;
  background-color: #f9f9f9;
  border-radius: 4px;
  transition: background-color 0.2s;
}

.student-item:hover {
  background-color: #f0f0f0;
}

.student-info {
  display: flex;
  flex-direction: column;
}

.student-name {
  font-weight: bold;
  margin-bottom: 0.25rem;
}

.student-program {
  color: #666;
  font-size: 0.9rem;
}

.enrollment-date {
  color: #666;
  font-size: 0.9rem;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 1rem;
  margin: 1rem 0;
}

.page-info {
  font-size: 0.9rem;
}

/* Rest of your existing styles... */
</style>