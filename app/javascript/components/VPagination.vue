<template>
  <nav class="pagination is-rounded is-centered" role="navigation" aria-label="pagination">
    <a v-show="currentPage - 1 > 0" class="pagination-previous" @click="setCurrentPage(currentPage - 1)">前へ</a>
    <a v-show="currentPage + 1 <= pages" class="pagination-next" @click="setCurrentPage(currentPage + 1)">次へ</a>
    <ul class="pagination-list">
      <li v-for="i in pages" :key=i>
        <a v-if="i == 1 || i == pages || (currentPage - 1 <= i && i <= currentPage + 1)" class="pagination-link" :class="{'is-current': i == currentPage}" @click="setCurrentPage(i)">{{i}}</a>
        <span v-else-if="i == 2 || i == (pages - 1)" class="pagination-ellipsis">&hellip;</span>
      </li>
    </ul>
  </nav>
</template>

<script>
  export default {
    props: {
      data: Array
    },
    data() {
      return {
        maxItems: 10,
        currentPage: 1,
        pages: 1,
        items: []
      }
    },
    watch: {
      data() {
        this.paging(this.currentPage)
        this.calcPages()
      },
      currentPage(value) {
        this.paging(value)
      }
    },
    methods: {
      setCurrentPage(page) {
        this.currentPage = page
      },
      paging(page) {
        const start = (page - 1) * this.maxItems
        const end = start + this.maxItems
        this.$emit('paging', this.data.slice(start, end))
      },
      calcPages() {
        this.pages = Math.ceil(this.data.length / this.maxItems)
      }
    },
    mounted() {
      this.calcPages()
      this.paging(this.currentPage)
    }
  }
</script>

<style lang="scss" scoped>
  .pagination-ellipsis {
    $pagination-ellipsis-color: white;
  }
</style>
