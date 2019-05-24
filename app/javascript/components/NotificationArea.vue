<template>
  <div v-if="!isDeleted" class="notification" :class="styles">
    <button @click="onClick" :id="taskId + '-delete'" class="delete"></button>
    <span><slot/></span>
  </div>
</template>

<script>
  import axios from '../shared/axios'
  
  export default {
    props: {
      type: String,
      taskId: String
    },
    data() {
      return {
        isDeleted: false
      }
    },
    computed: {
      styles() {
        return {
        'is-warning': this.type == 'warning',
        'is-danger': this.type == 'danger',
        'is-info': this.type == 'info',
        'has-text-weight-semibold': this.type == 'danger'
        }
      }
    },
    methods: {
      updateReadDateStamp() {
        axios
        .patch('/tasks/' + this.taskId + '/read_datestamps')
        .then(() => {
          this.isDeleted = true
        })
      },
      onClick() {
        this.updateReadDateStamp()
      }
    }
  }
</script>
