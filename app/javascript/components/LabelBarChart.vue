<template>
  <div>
    <bar-chart v-if="dataCollection.length > 0" :labels="labels" :data-collection="dataCollection"></bar-chart>
  </div>
</template>

<script>
  import axios from '../shared/axios'
  import BarChart from './BarChart'

  export default {
    components: {
      BarChart,
    },
    data() {
      return {
        resData: {},
      }
    },
    computed: {
      labels() {
        const labels = Object.keys(this.resData).map((value, index) => {
          return value
        })
        return labels
      },
      dataCollection() {
        const obj = this.resData
        const dataCollection = []
        Object.keys(obj).forEach(function(key) {
          dataCollection.push(obj[key])
        })
        return dataCollection
      }
    },
    methods: {
      fetchLabels() {
        axios
        .get('/labels')
        .then((res) => {
          this.resData = res.data
        })
        .catch((err) => {
          console.log(err)
        })
      }
    },
    created() {
      this.fetchLabels()
    }
  }
</script>


