<template>
  <div class="notification" :class="type">
    <span class="has-text-weight-semibold">{{ message }}</span>
  </div>
</template>

<script>
  export default {
    props: {
      message: String,
      notificationType: ''
    },
    computed: {
      type() {
        if(this.notificationType == 'success') {
          return 'is-success'
        } else if(this.notificationType == 'danger') {
          return 'is-danger'
        } else {
          return 'is-info'
        }
      }
    },
    mounted() {
      setTimeout(() => this.$emit('delete-message'), 5000)
    }
  }
</script>

<style lang="scss" scoped>
  .notification {
    width: 100%;
  }
</style>


