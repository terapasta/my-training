<template>
  <div v-if="!isDeleted" class="notification" :class="styles">
    <button @click="onClick" class="delete"></button>
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
      isDanger() {
        return this.type == 'danger'
      },
      styles() {
        return {
        'is-warning': !this.isDanger,
        'is-danger': this.isDanger,
        'has-text-weight-semibold': this.isDanger
        }
      }
    },
    methods: {
      updateReadDateStamp() {
        axios
        .patch('tasks/' + this.taskId + '/read_datestamps')
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
