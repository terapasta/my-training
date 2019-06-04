<template>
  <div>
    <v-message v-if="message" :message="message" :has-error="hasError"></v-message>
    <v-selector :selected="selected" :options="options"
              @update="updateStatus"></v-selector>
  </div>
</template>
<script>
  import axios from '../shared/axios'
  import enums from '../shared/enums'
  import VSelector from './VSelector'
  import VMessage from './VMessage'

  export default {
    components: { VSelector, VMessage },
    props: { 
      taskId: Number, 
      taskStatus: String,
    },
    data() {
      return {
        selected:'',
        message: '',
        hasError: false,
      }
    },
    computed: {
      options() {
        return enums.task.statuses
      }
    },
    methods: {
      updateStatus(status) {
        axios
        .patch('/tasks/' + this.taskId + '/statuses', { status: status })
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
