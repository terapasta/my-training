import Vue from 'vue/dist/vue.esm'
import StatusSelector from '../components/StatusSelector'
import PrioritySelector from '../components/PrioritySelector'
import VMessage from '../components/VMessage'

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#task-index',
    components: { StatusSelector, PrioritySelector, VMessage },
  })
})
