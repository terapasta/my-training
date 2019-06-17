<template>
  <div class="is-centered">
    <h1 class="is-size-3">タスク一覧</h1>
    <hr>
    <div class="level">
      <div class="level-left"></div>
      <div class="level-right">
        <a class="level-item button is-danger is-rounded has-text-weight-semibold" @click="toggleModal()">
          <i class="fas fa-plus"></i>タスク追加
        </a>
      </div>
    </div>
    <v-search v-if="dataset.length > 0" :all-data="dataset" @set-filtered-data="setFilteredData"></v-search>
    <v-modal v-if="isModalActive" :isModalActive="isModalActive"
             @toggle-modal="toggleModal">
      <template slot="header">タスク作成</template>
      <message v-if="message" :message="message" :notification-type="notificationType"
                @delete-message="deleteMessage"></message>
      <v-new :group-id="groupId" @set-message="setMessage" @add-task="addTask"></v-new>
    </v-modal>
    <hr>
    <v-table v-if="showTableFlag" :dataset="filteredData" :head-dataset="headDataset"></v-table>
  </div>
</template>

<script>
  import axios from '../../shared/axios'
  import VTable from './Vtable'
  import VNew from './VNew'
  import Message from '../Message'
  import VModal from '../VModal'
  import VSearch from '../VSearch'

  export default {
    components: { VTable, VNew, Message, VModal, VSearch },
    props: {
      groupId: String
    },
    data() {
      return {
        q: {
          name: '',
          status: '',
          proority: '',
        },
        dataset: [],
        filteredData: [],
        headDataset: {
          id: 'ID',
          name: 'タスク名',
          deadline: '終了期限',
          amount: '金額',
          status: 'ステータス',
          priority: '優先度',
          label: 'ラベル',
          role: '貸借',
        },
        messageParams: '',
        isModalActive: false,
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
      },
    },
    methods: {
      setFilteredData(data) {
        this.filteredData = data
      },
      setMessage(params) {
        this.messageParams = params
      },
      addTask(task) {
        this.dataset.unshift(task)
      },
      toggleModal() {
        this.isModalActive = !this.isModalActive
      },
      deleteMessage() {
        this.messageParams = ''
      }
    },
    created() {
      // 一覧データ取得
      axios
      .get('/api/tasks/')
      .then((res) => {
        this.dataset = res.data
      })
      .catch((err) => {
        console.log(err)
      })
    },
  }
</script>

