<template>
  <div>
    <v-message v-if="message" :message="message" :has-error="hasError"></v-message>
    <v-selector :selected="selected" :options="options"
                @update="updatePriority"></v-selector>

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
      taskPriority: String,
    },
    data() {
      return {
        selected: '',
        message: '',
        hasError: false,
      }
    },
    computed: {
      options() {
        return enums.task.priorities
      }
    },
    methods: {
      updatePriority(priority) {
        axios
        .patch('/tasks/' + this.taskId + '/priorities', { priority: priority })
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
