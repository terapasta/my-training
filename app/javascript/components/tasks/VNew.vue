<template>
  <div class="card-background">
    <form @submit.prevent="exec()">
      <div class="columns">
        <div class="field column is-3-desktop">
          <label class="label">タスク名</label>
          <div class="control">
            <input v-model="task.name" class="input" type="text">
          </div>
        </div>
        <div class="field column is-3-desktop">
          <label class="label">締切期限</label>
          <div class="control">
            <input v-model="task.deadline" class="input" type="date">
          </div>
        </div>
        <div class="field column is-3-desktop">
          <label class="label">金額</label>
          <div class="control">
            <input v-model="task.amount" class="input" type="number">
          </div>
        </div>
        <div class="field column is-2-desktop">
          <label class="label">ステータス</label>
          <div class="control">
            <div class="select">
              <select v-model="task.status">
                <option v-for="(value, key) in statuses" :key="key" :value="key">{{ translateStatus(key) }}</option>
              </select>
            </div>
          </div>
        </div>
        <div class="field column is-2-desktop">
          <label class="label">優先度</label>
          <div class="control">
            <div class="select">
              <select v-model="task.priority">
                <option v-for="(value, key) in priorities" :key="key" :value="key">{{ translatePriority(key) }}</option>
              </select>
            </div>
          </div>
        </div>
      </div>
      <div class="columns">
        <div class="field column is-8-desktop">
          <label class="label">詳細</label>
          <div class="control">
            <textarea v-model="task.description" class="textarea"></textarea>
          </div>
        </div>
      </div>
      <div class="columns">
        <div class="field column is-6-desktop">
          <label class="label">ラベル</label>
          <div class="control">
            <tags-input default-tags="" placeholder="ラベルを追加する"></tags-input>
          </div>
        </div>
      </div>
      <div class="field">
        <button type="submit" class="button is-medium is-fullwidth is-primary has-text-weight-bold">追加</button>
      </div>
    </form>
  </div>
</template>

<script>
  import VueRouter from 'vue-router'
  import axios from '../../shared/axios'
  import enums from '../../shared/enums'
  import TagsInput from '../TagsInput'
  export default {
    components: { TagsInput },
    props: {
      groupId: String
    },
    data() {
      return {
        task: {
          name: '',
          deadline: '',
          amount: '',
          status: 'waiting',
          priority: 'middle',
          description: '',
          debtor_id: '2',
          label: '',
          image: '',
          group_id: '',
        }
      }
    },
    computed: {
      statuses() {
        return enums.task.statuses
      },
      priorities() {
        return enums.task.priorities
      }
    },
    methods: {
      translateStatus(status) {
        return enums.translateStatus(status)
      },
      translatePriority(priority) {
        return enums.translatePriority(priority)
      },
      exec() {
        axios
        .post('/api/tasks', { task: this.task })
        .then(() => {
          console.log('成功')
        })
        .catch((err) => {
          console.log('失敗')
        })
      }
    },
    created() {
      this.task.group_id = this.groupId
    }
  }
</script>

