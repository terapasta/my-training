<template>
  <div class="is-centered">
    <h1 class="is-size-3">タスク一覧</h1>
    <hr>
    <message v-if="message" :message="message" :notification-type="notificationType"></message>
    <v-new :group-id="groupId" @set-message="setMessage"></v-new>
    <hr>
    <v-table v-if="showTableFlag" :dataset="dataset" :head-dataset="headDataset"></v-table>
  </div>
</template>

<script>
  import axios from '../../shared/axios'
  import VTable from './Vtable'
  import VNew from './VNew'
  import Message from '../Message'

  export default {
    components: { VTable, VNew, Message },
    props: {
      groupId: String
    },
    data() {
      return {
        dataset: [],
        headDataset: {
          id: 'ID',
          name: 'タスク名',
          deadline: '終了期限',
          amount: '金額',
          status: 'ステータス',
          priority: '優先度',
          label: 'ラベル',
          group: 'グループ',
          role: '貸借',
        },
        messageParams: '',
      }
    },
    computed: {
      showTableFlag() {
        return this.dataset.length > 0
      },
      message() {
        return this.messageParams.msg
      },
      notificationType() {
        return this.messageParams.type
      }
    },
    methods: {
      getTasks() {
        axios
        .get('/api/tasks/')
        .then((res) => {
          this.dataset = res.data
        })
        .catch((err) => {
          console.log(err)
        })
      },
      setMessage(params) {
        this.messageParams = params
      }
    },
    created() {
      this.getTasks()
    }
  }
</script>

