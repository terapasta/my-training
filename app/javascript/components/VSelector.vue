<template>
  <div>
    <select v-model="selected">
      <option v-for="(element) in array" :key="element['value']" :value="element['value']">{{element['name']}}</option>
    </select>
  </div>
</template>
<script>
  export default {
    props: { 
      default: String,
      array: Array,
    },
    data() {
      return {
        selected: ''
      }
    },
    watch: {
      selected() {
        this.$emit('update', this.selected)
      }
    },
    methods: {
      init() {
        this.selected = this.default
      }
    },
    created() {
      this.init()
    }
  }
</script>
