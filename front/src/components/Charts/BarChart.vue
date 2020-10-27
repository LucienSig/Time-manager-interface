<template>
  <div id="app">
    <div class="container">
      <div class="row">
        
        <div class="col-md-12">
          <bar-chart 
            :key="lineChartKey"
            id="bar" :data="barData" xkey="year" ykeys='[ "workedtime" ]' resize="true"
            labels='[ "workedtime"]'
            :bar-colors="osColors"
            parse-time="false"
            grid="true" grid-text-weight="bold">
          </bar-chart>
        </div>
       
      </div>
    </div>
  </div>
</template>

<script>
import Raphael from 'raphael/raphael'
global.Raphael = Raphael
import { BarChart } from 'vue-morris'
import axios from "axios";
import { EventBus } from "../../store/event-bus";

export default {
  name: 'app',
  data () {
    return {
      barData: [
        { year: 'Mon.', workedtime: 10 },
        { year: 'Tue.', workedtime: 10 },
        { year: 'Wed.', workedtime: 20 },
        { year: 'Thu.', workedtime: 30 },
        { year: 'Fri.', workedtime: 30 }
      ],
      lineChartKey: 0,
      userID: 'all'
    }
  },
  components: {
    BarChart
  },
  mounted() {
    this.computeWorkingTimesStats();
    EventBus.$on('userID', (userID) => {
      this.userID = userID;
      this.computeWorkingTimesStats();
    });
  },
  methods: {
    computeWorkingTimesStats() {

      axios
        .get("http://3.127.5.177:4000/api/clocks/" + this.userID)
        .then((response) => {
          let start = "";
          let end = "";
          let totalWorkingTimes = 0;
          let count = 0;

          let data = response.data

          if (this.userID != "all") {
            data = response.data.data;
          }

          console.log(data);
          
          data.forEach((element, index) => {
            let times = element["time"];


            if (index % 2 == 0) {
              start = times;
            } else {
              end = times
              let minutes = new Date(Date.parse(end) - Date.parse(start)).getMinutes();
              minutes += new Date(Date.parse(end) - Date.parse(start)).getHours() * 60;
              totalWorkingTimes += minutes;
              count += 1;
            }

            this.totalWorkingTimes  = (totalWorkingTimes/count) / 60;
            console.log("debug");
            console.log(this.totalWorkingTimes);
            this.setLineCharts()
          });
        });

    },
    setLineCharts() {
      this.barData = [
        { year: "time in hours", workedtime: this.totalWorkingTimes },
      ];
      this.lineChartKey += 1;
    }
  }
}
</script>