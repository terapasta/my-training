import Vue from 'vue/dist/vue.esm'
import TagsInput from '../components/TagsInput'

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    components: { TagsInput },
    el: '#form-area',
    data: {
      uploadedImage: '',
    },
    methods: {
      onFileChange(e) {
        let files = e.target.files || e.dataTransfer.files;
        this.createImage(files[0])
      },
      createImage(file) {
        let reader = new FileReader()
        reader.onload = (e) => {
          this.uploadedImage = e.target.result
        }
        reader.readAsDataURL(file)
      }
    }
  })
})
