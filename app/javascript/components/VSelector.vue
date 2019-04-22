<template>
  <div>
    <select :value="selected" @change="onChange">
      <option v-for="(option) in options" :key="option['value']" :value="option['value']">{{option['name']}}</option>
    </select>
  </div>
</template>
<script>
  export default {
    props: { 
      selected: String,
      options: Array,
    },
    methods: {
      onChange(event) {
        this.$emit('update', event.target.value)
      }
    },
  }
</script>
