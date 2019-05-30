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
        return Object.keys(this.resData).map((value, index) => value)
      },
      dataCollection() {
        return Object.keys(this.resData).map((value, index) => this.resData[value])
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


