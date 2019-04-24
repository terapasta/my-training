<template>
  <div>
    <span class="has-text-weight-semibold" :class="hasError ? 'has-text-danger' : 'has-text-success'">{{message}}</span>
  </div>
</template>
<script>
  export default {
    props: {
      message: String, 
      hasError: Boolean,
    },
  }
</script>
