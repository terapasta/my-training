import Vue from 'vue/dist/vue.esm'
import StatusButton from '../components/StatusButton'

const items = document.querySelectorAll("#status")
items.forEach((el, i) => {
  console.log(el['id'])
  new Vue({
    el,
    components: { StatusButton },
    template: '<status-button></status-button>',
  })
})
