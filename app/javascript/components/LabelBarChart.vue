<template>
<div class="small">
  <bar-chart v-if="datacollection && datacollection.labels.length > 0" :chart-data="datacollection"></bar-chart>
</div>
</template>
<script>
  import BarChart from '../shared/BarChart'
  import axios from '../shared/axios'

  export default {
    components: {
      BarChart
    },
    data() {
      return {
        datacollection: null,
        // colors: ["hsl(348, 100%, 61%)", "hsl(48, 100%, 67%)", "hsl(141, 71%, 48%)", "hsl(204, 86%, 53%)", "hsl(217, 71%, 53%)", "hsl(171, 100%, 41%)", "hsl(0, 0%, 21%)"],
                colors: ["hsl(348, 100%, 61%)", "hsl(48, 100%, 67%)"]
      }
    },
    mounted() {
      this.fillData()
      this.fetchData()
    },
    methods: {
      fillData() {
        this.datacollection = {
          labels: [],
          datasets: [
            {
              data: [3,5,6,7],
            }
          ],
          options: {                             //◆オプション
            responsive: true,                  //グラフ自動設定
            legend: {                          //凡例設定
                display: false                 //表示設定
            },
            title: {                           //タイトル設定
                display: true,                 //表示設定
                fontSize: 18,                  //フォントサイズ
                text: 'タイトル'                //ラベル
            },
            scales: {                          //軸設定
                yAxes: [{                      //y軸設定
                    display: true,             //表示設定
                    scaleLabel: {              //軸ラベル設定
                       display: true,          //表示設定
                       labelString: '縦軸ラベル',  //ラベル
                       fontSize: 18               //フォントサイズ
                    },
                    ticks: {                      //最大値最小値設定
                        min: 0,                   //最小値
                        max: 30,                  //最大値
                        fontSize: 18,             //フォントサイズ
                        stepSize: 5               //軸間隔
                    },
                }],
                xAxes: [{                         //x軸設定
                    display: true,                //表示設定
                    barPercentage: 0.4,           //棒グラフ幅
                    categoryPercentage: 0.4,      //棒グラフ幅
                    scaleLabel: {                 //軸ラベル設定
                       display: true,             //表示設定
                       labelString: '横軸ラベル',  //ラベル
                       fontSize: 18               //フォントサイズ
                    },
                    ticks: {
                        fontSize: 18             //フォントサイズ
                    },
                }],
            },
          }
        }
      },
      fetchData() {        
        axios
        .get('/labels')
        .then((res) => {
          this.setData(res.data)
        })
        .catch((err) => {
          console.log(err)
        })
      },
      setData(resData) {
        const labels = []
        const data = []
        // const backgroundColor = []
        // const colors = this.colors
        // let counter = 0

        Object.keys(resData).forEach(function (key, i) {
          labels.push(key)
          data.push(resData[key])
          // if(colors.length <= i) {
          //   counter = 0
          // }
          // console.log(counter)
          // console.log(colors[counter])
          // backgroundColor.push(colors[counter])
          // counter++
        })
        this.datacollection.labels = labels
        // this.datacollection.datasets[0].data = data
        // this.datacollection.datasets[0].backgroundColor = colors
        // console.log(colors)
        console.log(data)
        console.log(this.datacollection)
      }
    }
  }
</script>
