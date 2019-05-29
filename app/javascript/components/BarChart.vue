<script>
  import { Bar, mixins } from 'vue-chartjs'
  import axios from '../shared/axios'

  export default {
    mixins: [Bar, mixins.reactiveData],
    name: 'BarChart',
    components: {
      Bar
    },
    props: ["labels", "dataCollection"],
    data() {
      return {
        chartData: {
          labels: this.labels,
          datasets: [
            {
              data: this.dataCollection,
              backgroundColor: "hsl(204, 86%, 53%)"
            }
          ],
        },
        options: {                           
          responsive: true,                 
          legend: {                      
              display: false             
          },
          title: {                         
              display: true,             
              fontSize: 18,                 
              text: 'ラベル使用頻度'           
          },
          scales: {                     
              yAxes: [{                  
                  display: true,         
                  scaleLabel: {            
                      display: true,      
                      labelString: 'ラベル使用回数', 
                      fontSize: 18              
                  },
                  ticks: {                      
                      min: 0,              
                      fontSize: 18,            
                      stepSize: 1          
                  },
              }],
              xAxes: [{                     
                  display: true,            
                  scaleLabel: {               
                      display: true,         
                      labelString: 'ラベル種類', 
                      fontSize: 18              
                  },
                  ticks: {
                      fontSize: 18            
                  },
              }],
          },
        }
      }
    },
    mounted() {
      this.renderChart(this.chartData, this.options)
    }
  }
</script>
