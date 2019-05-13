<template>
  <tags-input element-id="tags" v-model="tags" :placeholder="placeholder"></tags-input>
</template>
<script>
  import VoerroTagsInput from '@voerro/vue-tagsinput'

  export default {
    props: ['defaultTags', 'placeholder'],
    components: { 'tags-input': VoerroTagsInput },
    data() {
      return {
        tags: "",
      }
    },
    created () {
      this.tags = this.defaultTags
    }
  }
</script>
