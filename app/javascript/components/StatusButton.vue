<template>
  <div>
    <select v-model="status">
      <option>A</option>
      <option>B</option>
      <option>C</option>
    </select>
    <p>{{status}}</p>
  </div>
</template>
<script>
  import axios from 'axios'
  export default {
    data: function () {
      return {
        status: ''
      }
    },
    methods: {
      init() {
        axios.get('/tasks.json')
        .then((res)=> {
        })
      }
    },
    created() {
      this.init()
    }
  }
</script>
