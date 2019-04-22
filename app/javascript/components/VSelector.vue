<template>
  <div>
    <select v-model="selected" @change="exec">
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
    methods: {
      init() {
        this.selected = this.default
      },
      exec() {
        this.$emit('update', this.selected)
      }
    },
    created() {
      this.init()
    }
  }
</script>
