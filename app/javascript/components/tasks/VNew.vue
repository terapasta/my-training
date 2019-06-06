<template>
  <div>
    <v-form :group-id="groupId" :default-task="defaultTask"
            @set-type="setType" @add-task="addTask"></v-form>
  </div>
</template>

<script>
  import VForm from './VForm'
  export default {
    components: { VForm },
    props: {
      groupId: String
    },
    data() {
      return {
        defaultTask: {
          status: 'waiting',
          priority: 'middle',
        },
      }
    },
    methods: {
      setType(type) {
        let msg = ''
        if(type == 'success') {
          msg = 'タスクを追加しました'
        } else {
          msg = 'タスクを追加できませんでした'
        }
        this.$emit('set-message', { msg: msg, type: type })
      },
      addTask(task) {
        this.$emit('add-task', task)
      }
    }
  }
</script>

