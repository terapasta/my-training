<template>
  <div>
    <table class="table is-striped is-fullwidth">
      <thead class="thead">
        <tr>
          <th v-for="(headData, i) in headDataset" :key="i">{{ headData }}</th>
          <th></th>
        </tr>
      </thead>

      <tbody class="tbody">
        <tr v-for="data in dataset" :key="data.id" @dblclick=openShowModal(data.id)>
          <td>{{ data.id }}</td>
          <td>{{ data.name }}</td>
          <td>{{ data.deadline }}</td>
          <td>{{ data.amount }}</td>
          <td>
            <span v-if="data.role == 'debtee'">
              <status-selector :task-id="data.id" :task-status="data.status"></status-selector>
            </span>
            <span v-else>
              {{ translateStatus(data.status) }}
            </span>
          </td>
          <td>
            <span v-if="data.role == 'debtee'">
              <priority-selector :task-id="data.id" :task-priority="data.priority"></priority-selector>
            </span>
            <span v-else>
              {{ translatePriority(data.priority) }}
            </span>
          </td>
          <td>
            <span v-if="data.labels.length > 0">
              <span v-for="label in data.labels" :key="label.id" 
                    class="tags-input-badge tags-input-badge-pill tags-input-badge-selected-default is-info">
                {{ label.name }}
              </span>
            </span>
            <span v-else>
              <span>-</span>
            </span>
          </td>
          <td>{{ translateRole(data.role) }}</td>
          <td>
            
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
  import enums from '../../shared/enums'
  import StatusSelector from '../StatusSelector'
  import PrioritySelector from '../PrioritySelector'

  export default {
    components: { StatusSelector, PrioritySelector },
    props: {
      dataset: Array,
      headDataset: Object,
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
      openShowModal(id) {
        this.$emit('open-show-modal', id)
      }
    }
  }
</script>
