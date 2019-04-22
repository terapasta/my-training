<template>
  <v-selector :default="taskPriority" :array="array"
              @update="updatePriority"></v-selector>
</template>
<script>
  import axios from '../shared/axios'
  import VSelector from './VSelector'

  export default {
    components: { VSelector },
    props: { 
      taskId: String, 
      taskPriority: String,
    },
    data() {
      return {
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
      }
    },
  }
</script>
