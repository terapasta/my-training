import axios from 'axios'

const tokenElement = document.querySelector('meta[name="csrf-token"')
const instance = axios.create({
  headers: {
    'X-Requested-With': "XMLHttpRequest",
    'Content-Type': 'application/json',
    'X-CSRF-TOKEN' : (tokenElement) ? tokenElement.content : null
  }
})

export default instance
