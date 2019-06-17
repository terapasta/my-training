<template>
  <transition name="modal" appear>
    <div class="v-modal" :class="{'is-open': isModalActive}" @click.self="closeModal">
      <div class="container modal-background modal-window">
        <div class="message">
          <div class="message-header">
            <slot name="header"/>
            <button class="delete" @click="closeModal()"></button>
          </div>
          <div class="message-body">
            <slot/>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
  export default {
    props: {
      isModalActive: Boolean,
    },
    methods: {
      closeModal () {
        this.$emit('close-modal')
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
  .modal-enter-active, .modal-leave-active {
    transition: opacity 0.4s;
    .modal-window {
      transition: opacity 0.4s, transform 0.4s;
    }
  }
  .modal-leave-active {
    transition: opacity 0.6s ease 0.4s;
  }
  .modal-enter, .modal-leave-to {
    opacity: 0;
    .modal-window {
      opacity: 0;
      transform: translateY(-20px);
    }
  }
</style>
