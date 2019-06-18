<template>
  <div>
    <div class="columns">
      <div><button class="button" @click="openEditModal">編集</button></div>
    </div>
    <div class="columns">
      <div class="field column is-2-desktop">
        <label class="label">タスク名</label>
        <div class="control">
          {{task.name}}
        </div>
      </div>
      <div class="field column is-2-desktop">
        <label class="label">締切期限</label>
        <div class="control">
          {{task.deadline}}
        </div>
      </div>
      <div class="field column is-2-desktop">
        <label class="label">金額</label>
        <div class="control">
          {{task.amount}}円
        </div>
      </div>
      <div class="field column is-2-desktop">
        <label class="label">借り手</label>
        <div class="control">
          {{translateRole(task.role)}}
        </div>
      </div>
      <div class="field column is-2-desktop">
        <label class="label">ステータス</label>
        <div class="control">
          {{translateStatus(task.status)}}
        </div>
      </div>
      <div class="field column is-2-desktop">
        <label class="label">優先度</label>
        <div class="control">
          {{translatePriority(task.priority)}}
        </div>
      </div>
    </div>
    <div class="columns">
      <div class="field column is-8-desktop">
        <label class="label">詳細</label>
        <div class="control">
          {{task.description}}
        </div>
      </div>
    </div>
    <div class="columns">
      <div class="field column is-6-desktop">
        <label class="label">ラベル</label>
        <div class="control">
          <span v-if="task.labels.length > 0">
            <span v-for="label in task.labels" :key="label.id" 
                  class="tags-input-badge tags-input-badge-pill tags-input-badge-selected-default is-info">
              {{ label.name }}
            </span>
          </span>
          <span v-else>
            <span>-</span>
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import enums from  '../../shared/enums'
  export default {
    props: {
      task: Object,
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
      openEditModal() {
        this.$emit('open-edit-modal')
      }
    }
  }
</script>
