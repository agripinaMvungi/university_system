<template>
  <div class="subjects-container">
    <h1>Course Catalog</h1>
    <div class="node-info">
      <span class="node-label">Served by:</span>
      <span class="node-id">{{ currentNode }}</span>
    </div>

    <div v-if="loading" class="loading-indicator">
      <div class="spinner"></div>
      <span>Loading courses...</span>
    </div>

    <div v-else>
      <div class="controls">
        <input 
          v-model="searchQuery" 
          placeholder="Search courses..." 
          class="search-input"
        >
        <div class="filter-controls">
          <select v-model="selectedYear" class="year-filter">
            <option value="">All Years</option>
            <option v-for="year in availableYears" :key="year" :value="year">
              Year {{ year }}
            </option>
          </select>
          <button @click="sortBy('name')" class="sort-button">
            Sort by Name {{ sortField === 'name' ? (sortAsc ? '↑' : '↓') : '' }}
          </button>
          <button @click="sortBy('year')" class="sort-button">
            Sort by Year {{ sortField === 'year' ? (sortAsc ? '↑' : '↓') : '' }}
          </button>
        </div>
      </div>

      <ul v-if="filteredSubjects.length > 0" class="subject-list">
        <li v-for="subject in paginatedSubjects" :key="subject.id" class="subject-item">
          <div class="subject-info">
            <span class="subject-name">{{ subject.name }}</span>
            <span class="subject-meta">
              <span class="subject-year">Year {{ subject.year }}</span>
              <span class="subject-code">{{ subject.code || 'N/A' }}</span>
            </span>
          </div>
          <span class="subject-credits">
            {{ subject.credits || 0 }} Credits
          </span>
        </li>
      </ul>
      <p v-else class="no-data">No courses found matching your criteria</p>

      <div class="pagination" v-if="filteredSubjects.length > itemsPerPage">
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
  name: 'SubjectsPage',
  data() {
    return {
      subjects: [],
      loading: false,
      currentNode: 'Unknown',
      searchQuery: '',
      selectedYear: '',
      sortField: 'year',
      sortAsc: true,
      currentPage: 1,
      itemsPerPage: 5
    }
  },
  async created() {
    await this.fetchSubjects()
  },
  computed: {
    availableYears() {
      const years = new Set(this.subjects.map(s => s.year))
      return Array.from(years).sort()
    },
    filteredSubjects() {
      let filtered = this.subjects.filter(subject => {
        const matchesSearch = subject.name.toLowerCase().includes(this.searchQuery.toLowerCase())
        const matchesYear = this.selectedYear === '' || subject.year == this.selectedYear
        return matchesSearch && matchesYear
      })
      
      filtered.sort((a, b) => {
        if (a[this.sortField] < b[this.sortField]) return this.sortAsc ? -1 : 1
        if (a[this.sortField] > b[this.sortField]) return this.sortAsc ? 1 : -1
        return 0
      })

      return filtered
    },
    totalPages() {
      return Math.ceil(this.filteredSubjects.length / this.itemsPerPage)
    },
    paginatedSubjects() {
      const start = (this.currentPage - 1) * this.itemsPerPage
      const end = start + this.itemsPerPage
      return this.filteredSubjects.slice(start, end)
    }
  },
  methods: {
    async fetchSubjects() {
      this.loading = true
      try {
        const response = await api.getSubjects()
        this.subjects = response.data
        this.currentNode = response.headers['x-node-id'] || 'Unknown'
      } catch (error) {
        console.error('Error fetching subjects:', error)
        this.$notify({
          type: 'error',
          title: 'Error',
          text: 'Failed to load course data'
        })
      } finally {
        this.loading = false
      }
    },
    sortBy(field) {
      if (this.sortField === field) {
        this.sortAsc = !this.sortAsc
      } else {
        this.sortField = field
        this.sortAsc = true
      }
      this.currentPage = 1 // Reset to first page when sorting changes
    }
  }
}
</script>

<style scoped>
.subjects-container {
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

.filter-controls {
  display: flex;
  gap: 0.5rem;
  align-items: center;
}

.year-filter {
  padding: 0.5rem;
  border: 1px solid #ddd;
  border-radius: 4px;
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

.subject-list {
  list-style: none;
  padding: 0;
  margin: 2rem 0;
}

.subject-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem;
  margin-bottom: 0.5rem;
  background-color: #f9f9f9;
  border-radius: 4px;
  transition: background-color 0.2s;
}

.subject-item:hover {
  background-color: #f0f0f0;
}

.subject-info {
  display: flex;
  flex-direction: column;
}

.subject-name {
  font-weight: bold;
  margin-bottom: 0.25rem;
}

.subject-meta {
  display: flex;
  gap: 1rem;
  font-size: 0.9rem;
  color: #666;
}

.subject-year {
  background-color: #e1f5fe;
  padding: 0.2rem 0.5rem;
  border-radius: 4px;
}

.subject-code {
  font-family: monospace;
}

.subject-credits {
  background-color: #e8f5e9;
  padding: 0.3rem 0.6rem;
  border-radius: 4px;
  font-weight: bold;
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

.back-button {
  display: block;
  margin: 2rem auto 0;
  padding: 0.75rem 1.5rem;
  background-color: #42b983;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 1rem;
  transition: background-color 0.2s;
}

.back-button:hover {
  background-color: #369f6b;
}

/* Loading spinner styles (same as StudentsPage) */
.loading-indicator {
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 2rem 0;
}

.spinner {
  border: 3px solid rgba(0, 0, 0, 0.1);
  border-radius: 50%;
  border-top: 3px solid #42b983;
  width: 20px;
  height: 20px;
  animation: spin 1s linear infinite;
  margin-right: 10px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.no-data {
  text-align: center;
  color: #666;
  font-style: italic;
  margin: 2rem 0;
}
</style>