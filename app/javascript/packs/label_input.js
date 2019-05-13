import Vue from 'vue/dist/vue.esm'
import TagsInput from '../components/TagsInput'

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#task-form',
    components: { TagsInput },
  })
})
