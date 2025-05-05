<template>
    <div class="home">
      <h1>University Portal</h1>
      <p>Served by: {{ currentNode }}</p>
      
      <div class="buttons">
        <router-link to="/students" class="btn">Students</router-link>
        <router-link to="/subjects" class="btn">Courses</router-link>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: 'HomePage',
    data() {
      return {
        currentNode: 'Unknown'
      }
    },
    created() {
      this.getNodeId();
    },
    methods: {
      getNodeId() {
        // This will be set by the load balancer or frontend server
        const nodeId = document.cookie.split('; ').find(row => row.startsWith('X-Node-ID='));
        if (nodeId) {
          this.currentNode = nodeId.split('=')[1];
        }
      }
    }
  }
  </script>
  
  <style scoped>
  .home {
    text-align: center;
    padding: 20px;
  }
  
  .buttons {
    margin: 30px 0;
  }
  
  .btn {
    display: inline-block;
    padding: 10px 20px;
    margin: 0 10px;
    background-color: #42b983;
    color: white;
    text-decoration: none;
    border-radius: 4px;
    font-size: 16px;
  }
  
  .btn:hover {
    background-color: #369f6b;
  }
  </style>