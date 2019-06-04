<template>
  <div>
    <table class="table is-striped is-fullwidth">
      <thead class="thead">
        <tr>
          <td v-for="(headData, i) in headDataset" :key="i">{{ headData }}</td>
        </tr>
      </thead>

      <tbody class="tbody">
        <tr v-for="data in dataset" :key="data.id">
          <td>{{ data.id }}</td>
          <td>{{ data.name }}</td>
          <td>{{ data.deadline }}</td>
          <td>{{ data.amount }}</td>
          <td>{{ translateStatus(data.status) }}</td>
          <td>{{ translatePriority(data.priority) }}</td>
          <td v-if="data.labels.length > 0">
            <span v-for="label in data.labels" :key="label.id" 
                  class="tags-input-badge tags-input-badge-pill tags-input-badge-selected-default is-info">
              {{ label.name }}
            </span>
          </td>
          <td v-else>
            <span>-</span>
          </td>
          <td>{{ data.group.name }}</td>
          <td>{{ translateRole(data.role) }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
  import enums from '../../shared/enums'

  export default {
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
      }
    }
  }
</script>
