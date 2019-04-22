<template>
  <div>
    <v-message :message="message" :has-error="hasError"></v-message>
    <v-selector :default="taskPriority" :array="array"
                @update="updatePriority"></v-selector>
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
      taskPriority: String,
    },
    data() {
      return {
        message: '',
        hasError: false,
        array: [
          {
            name: '低',
            value: 'low'
          },
          {
            name: '中',
            value: 'middle'
          },
          {
            name: '高',
            value: 'high'
          },
          {
            name: '-',
            value: 'unselected'
          }
        ]
      }
    },
    methods: {
      updatePriority(priority) {
        axios
        .patch('tasks/' + this.taskId + '/priorities', { priority: priority })
        .then(() => {
          this.setMessage('更新しました')
        })
        .catch(() => {
          this.hasError = true
          this.setMesssage('更新に失敗しました')
        })
      }
    },
    setMessage(msg) {
      this.message = msg
    }
  }
</script>
