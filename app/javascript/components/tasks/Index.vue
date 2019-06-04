<template>
  <div class="is-centered">
    <h1 class="is-size-3">タスク一覧</h1>
    <hr>
    <v-new :group-id="groupId"></v-new>
    <hr>
    <v-table v-if="showTableFlag" :dataset="dataset" :head-dataset="headDataset"></v-table>
  </div>
</template>

<script>
import axios from '../../shared/axios'
import VTable from './Vtable'
import VNew from './VNew'

export default {
  components: { VTable, VNew },
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
    }
  },
  computed: {
    showTableFlag() {
      return this.dataset.length > 0
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
    }
  },
  created() {
    this.getTasks()
  }
}
</script>

