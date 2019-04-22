<template>
  <v-selector :default="taskStatus" :array="array"
              @update="updateStatus"></v-selector>
</template>
<script>
  import axios from '../shared/axios'
  import VSelector from './VSelector'

  export default {
    components: { VSelector },
    props: { 
      taskId: String, 
      taskStatus: String,
    },
    data() {
      return {
        array: [
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
      }
    }
  }
</script>
