<template>
  <div class="select">
    <select :value="selected" @change="onChange">
      <option v-for="(value, key) in options" :key="key" :value="key">{{ value }}</option>
    </select>
  </div>
</template>
<script>
  export default {
    props: { 
      selected: String,
      options: Object,
    },
    methods: {
      onChange(event) {
        this.$emit('update', event.target.value)
      }
    },
  }
</script>
