<template>
  <div>
    <v-form v-if="defaultTask.group.id && users.length > 0"
            :default-task="defaultTask" :users="users" @exec="exec">
      <template slot="btn">更新</template>
    </v-form>
  </div>
</template>

<script>
  import axios from '../../shared/axios'
  import VForm from './VForm'
  export default {
    components: { VForm },
    props: {
      defaultTask: Object,
    },
    data() {
      return {
        users: [],
      }
    },
    methods: {
      exec(params) {
        axios
        .patch('/api/tasks/' + params.id, { task: params })
        .then((res) => {
          this.$emit('set-message', { msg: 'タスクを更新しました', type: 'success' })
          this.$emit('add-task', res.data)
          this.$emit('open-show-modal', res.data.id)
        })
        .catch((err) => {
          this.$emit('set-message', { msg: 'タスクを更新できませんでした', type: 'danger' })
          console.log(err)
        })
      },
    },
    created() {
      axios
      .get('/api/users', { params: { group_id: this.defaultTask.group.id } } )
      .then((res) => { this.users = res.data } )
      .catch((err) => { console.log(err) } )
    }
  }
</script>
