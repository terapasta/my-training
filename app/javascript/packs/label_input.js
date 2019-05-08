import Vue from 'vue/dist/vue.esm'
import LabelsInput from '../components/LabelsInput'

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#task-form',
    components: { LabelsInput }
  })
})
