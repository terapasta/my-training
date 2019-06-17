<template>
  <form>
    <div class="columns">
      <div class="column is-3">
        <label class="label">タスク名</label>
        <div class="control">
          <input v-model="q.name" class="input" type="text">
        </div>
      </div>
      <div class="column is-2">
        <label class="label">ステータス</label>
        <div class="control">
          <div class="select">
            <select v-model="q.status">
              <option value="">未選択</option>
              <option v-for="(value, key) in statuses" :key="key" :value="key">{{ translateStatus(key) }}</option>
            </select>
          </div>
        </div>
      </div>
      <div class="column is-2">
        <label class="label">優先度</label>
        <div class="control">
          <div class="select">
            <select v-model="q.priority">
              <option value="">未選択</option>
              <option v-for="(value, key) in priorities" :key="key" :value="key">{{ translatePriority(key) }}</option>
            </select>
          </div>
        </div>
      </div>
      <div class="column is-2">
        <label class="label">貸借</label>
        <div class="control">
          <div class="select">
            <select v-model="q.role">
              <option selected value="">未選択</option>
              <option v-for="(value, key) in roles" :key="key" :value="key">{{ translateRole(key) }}</option>
            </select>
          </div>
        </div>
      </div>
      {{setFilteredData}}
    </div>
    <div class="columns">
      <div class="column is-2">
        <label class="label"></label>
        <div class="control">
          <div class="button" @click="clear">検索条件クリア</div>
        </div>
      </div>
    </div>
  </form>
</template>

<script>
  import enums from '../shared/enums'
  export default {
    props: {
      allData: Array,
    },
    data() {
      return {
        q: {
          name: '',
          status: '',
          priority: '',
          role: '',
        },
        fillterdData: []
      }
    },
    computed: {
      setFilteredData() {
        const filteredData = this.allData.map((value, key) => {
          if(value.name.indexOf(this.q.name, 0) >= 0
            && (this.q.status == '' || this.q.status == value.status) 
            && (this.q.priority == '' || this.q.priority == value.priority)
            && (this.q.role == '' || this.q.role == value.role)) return value
        }).filter(v => v)
        this.$emit('set-filtered-data', filteredData)
      },
      statuses() {
        return enums.task.statuses
      },
      priorities() {
        return enums.task.priorities
      },
      roles() {
        return enums.userTask.roles
      }
    },
    methods: {
      translateStatus(status) {
        return enums.translateStatus(status)
      },
      translatePriority(priority) {
        return enums.translatePriority(priority)
      },
      translateRole(role) {
        return enums.translateRole(role)
      },
      clear() {
        Object.keys(this.q).forEach(key => {
          this.q[key] = ''
        })
      }
    },
  }
</script>
