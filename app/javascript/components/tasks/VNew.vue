<template>
  <div>
    <v-form v-if="defaultTask.group_id && users.length > 0" 
      :default-task="defaultTask" :users="users" @exec="exec">
      <template slot="btn">追加</template>
    </v-form>
  </div>
</template>

<script>
  import axios from '../../shared/axios'
  import VForm from './VForm'
  export default {
    components: { VForm },
    props: {
      groupId: String,
    },
    data() {
      return {
        defaultTask: {
          name: '',
          deadline: '',
          amount: '',
          status: 'waiting',
          priority: 'middle',
          description: '',
          debtor_id: '',
          label: '',
          image: '',
          group_id: '',
        },
        users: [],
      }
    },
    methods: {
      exec(params) {
        axios
        .post('/api/tasks', { task: params })
        .then((res) => {
          this.$emit('set-message', { msg: 'タスクを追加しました', type: 'success' })
          this.$emit('add-task', res.data)
          this.resetForm()
        })
        .catch((err) => {
          this.$emit('set-message', { msg: 'タスクを追加できませんでした', type: 'danger' })
          console.log(err)
        })
      },
      resetForm() {
        Object.keys(this.defaultTask).forEach((key, i) => {
          let value = ''
          if(key == 'status') {
            value = 'waitnig'
          } else if(key == 'priority') {
            value = 'middle'
          } else if(key == 'group_id') {
            value = this.groupId
          }
          this.defaultTask[key] = value
        })
      },
    },
    created() {
      this.defaultTask.group_id = this.groupId
      axios
      .get('/api/users', { params: { group_id: this.groupId } } )
      .then((res) => { this.users = res.data } )
      .catch((err) => { console.log(err) } )
    }
  }
</script>

