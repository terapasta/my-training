<template>
  <div class="v-modal" :class="{'is-open': isModalActive}" @click.self="closeModal">
    <div class="container modal-background">
      <div class="message">
        <div class="message-header">
          <slot name="header"></slot>
          <button class="delete" @click="closeModal()"></button>
        </div>
        <div class="message-body">
          <slot/>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    props: {
      isModalActive: Boolean,
    },
    methods: {
      closeModal () {
        this.$emit('toggle-modal')
      },
    }
  }
</script>

<style lang="scss">
  .v-modal {
    align-items: center;
    justify-content: center;
    position: fixed;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    overflow-y: auto;
    visibility: hidden;
    opacity: 0;
    z-index: -1;
  }
  .is-open {
    visibility: visible;
    opacity: 1;
    background-color: rgba(0, 0, 0, .3);
    z-index: 100;
  }
  .modal-background {
    top: 10%;
  }
</style>
