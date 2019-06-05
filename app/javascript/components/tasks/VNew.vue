<template>
  <div class="card-background">
    <form @submit.prevent="exec()">
      <div class="columns">
        <div class="field column is-2-desktop">
          <label class="label">タスク名</label>
          <div class="control">
            <input v-model="task.name" class="input" type="text" required>
          </div>
        </div>
        <div class="field column is-2-desktop">
          <label class="label">締切期限</label>
          <div class="control">
            <input v-model="task.deadline" class="input" type="date" required>
          </div>
        </div>
        <div class="field column is-2-desktop">
          <label class="label">金額</label>
          <div class="control">
            <input v-model="task.amount" class="input" type="number" required>
          </div>
        </div>
        <div class="field column is-2-desktop">
          <label class="label">借り手</label>
          <div class="control">
            <div class="select">
              <select v-model="task.debtor_id" required>
                <option disabled value="">未選択</option>
                <option v-for="user in users" :key="user.id" :value="user.id">{{ user.name }}</option>
              </select>
            </div>
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
          debtor_id: '',
          label: '',
          image: '',
          group_id: '',
        },
        users: [],
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
      resetForm() {
        Object.keys(this.task).forEach((key, i) => {
          let value = ''
          if(key == 'status') {
            value = 'waitnig'
          } else if(key == 'priority') {
            value = 'middle'
          }
          this.task[key] = value
        })
      },
      exec() {
        axios
        .post('/api/tasks', { task: this.task })
        .then((res) => {
          this.$emit('set-message', { msg: 'タスクを追加しました', type: 'success' })
          this.$emit('add-task', res.data)
          this.resetForm()
        })
        .catch((err) => {
          this.$emit('set-message', { msg: 'タスクを追加できませんでした', type: 'danger' })
          console.log(err)
        })
      }
    },
    created() {
      this.task.group_id = this.groupId
      axios
      .get('/api/users', { 
        params: {
          group_id: this.groupId
        }
      })
      .then((res) => {
        this.users = res.data
      })
    }
  }
</script>

