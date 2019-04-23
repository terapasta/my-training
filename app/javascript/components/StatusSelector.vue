<template>
  <div>
    <v-message v-if="message" :message="message" :has-error="hasError"></v-message>
    <v-selector :selected="selected" :options="options"
              @update="updateStatus"></v-selector>
  </div>
</template>
<script>
  import axios from '../shared/axios'
  import VSelector from './VSelector'
  import VMessage from './VMessage'

  export default {
    components: { VSelector, VMessage },
    props: { 
      taskId: String, 
      taskStatus: String,
    },
    data() {
      return {
        selected:'',
        message: '',
        hasError: false,
        options: [
          {
            name: '未着手',
            value: 'waiting'
          },
          {
            name: '着手',
            value: 'working'
          },
          {
            name: '完了',
            value: 'completed'
          }
        ]
      }
    },
    methods: {
      updateStatus(status) {
        axios
        .patch('tasks/' + this.taskId + '/statuses', { status: status })
        .then(() => {
          this.selected = status
          this.message = '更新しました'
        })
        .catch(() => {
          this.hasError = true
          this.message = '更新に失敗しました'
        })
      },
    },
    created() {
      if(this.taskStatus) {
        this.selected = this.taskStatus
      } else {
        this.selected = 'waiting'
      }
    }
  }
</script>
