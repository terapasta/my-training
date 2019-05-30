import Vue from 'vue/dist/vue.esm'
import LabelBarChart from '../components/LabelBarChart'

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#mypage',
    components: { LabelBarChart }
  })
})
