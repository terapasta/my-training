<template>
  <div>
    <v-message v-if="message" :message="message" :has-error="hasError"></v-message>
    <v-selector :selected="selected" :options="options"
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
        selected: '',
        message: '',
        hasError: false,
        options: [
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
          this.selected = priority
          this.message = '更新しました'
        })
        .catch(() => {
          this.hasError = true
          this.message = '更新に失敗しました'
        })
      },
    },
    created() {
      if(this.taskPriority) {
        this.selected = this.taskPriority
      } else {
        this.selected = 'waiting'
      }
    }
  }
</script>
