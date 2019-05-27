<template>
  <div>
    <div v-if=isShow>
      <slot/>
      <p @click=onClick>閉じる</p>
    </div>
    <div v-else>
      <p @click=onClick>もっと見る</p>
    </div>
  </div>
</template>

<script>
  export default {
    data() {
      return {
        isShow: false
      }
    },
    methods: {
      onClick() {
        this.isShow = !this.isShow
      }
    },
  }
</script>
