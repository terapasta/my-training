<template>
  <tags-input element-id="labels" v-model="labels" placeholder="ラベルを追加"></tags-input>
</template>
<script>
  import VoerroTagsInput from '@voerro/vue-tagsinput'

  export default {
    props: ['defaultLabels'],
    components: { 'tags-input': VoerroTagsInput },
    data() {
      return {
        labels: "",
      }
    },
    created () {
      this.labels = this.defaultLabels
    }
  }
</script>
