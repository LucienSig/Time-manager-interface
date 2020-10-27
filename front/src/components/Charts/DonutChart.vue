<template>
  <div id="app">
    <donut-chart id="donut" :data="donutData" colors='[ "#FF6384", "#36A2EB", "#FFCE56", "orange", "#825ee4"]' resize="true" width="400"></donut-chart>
  </div>
</template>

<script>
import Raphael from 'raphael/raphael'
global.Raphael = Raphael
import { DonutChart } from 'vue-morris'
import axios from "axios"
import { EventBus } from "../../store/event-bus";


export default {
  name: 'app',
  data () {
    return {
      donutData: [      ],
      userID: 'all'
    }
  },
  components: {
    DonutChart
  },
  mounted () {
    this.computeWorkingTimesStats();
    EventBus.$on('userID', (userID) => {
      this.userID = userID;
      this.computeWorkingTimesStats();
    });
  },
  methods: {
    computeWorkingTimesStats() {
      this.lineChartKey += 1;
      let workingTimesStats = {
        "Mon.": {
            average: 0,
            totalWorkedTime: 0,
            count: 0
        },
        "Tue.": {
            average: 0,
            totalWorkedTime: 0,
            count: 0
        },
        "Wed.": {
            average: 0,
            totalWorkedTime: 0,
            count: 0
        },
        "Thu.": {
            average: 0,
            totalWorkedTime: 0,
            count: 0
        },
        "Fri.": {
            average: 0,
            totalWorkedTime: 0,
            count: 0
        }
      }
      let days = ["Mon.", "Tue.", "Wed.", "Thu.", "Fri."];
      
      axios
        .get("http://3.127.5.177:4000/api/workingtimes/" + this.userID)
        .then((response) => {
          let data = response.data

          if (this.userID != "all") {
            data = response.data.data;
          }

          console.log(data);

          data.forEach((element) => {
            let start = element["start"];
            let end = element["end"];
            let day = "";
            let now = new Date();

            start = Date.parse(start);
            end = Date.parse(end);

            day = new Date(start).getDay();
            console.log(days[day]);

            if (start > now) {
              let dateDifference = new Date(Math.abs(start - end)).getHours();
              workingTimesStats[days[day]]["count"] += 1;
              workingTimesStats[days[day]]["totalWorkedTime"] += dateDifference;
              workingTimesStats[days[day]]["average"] = workingTimesStats[days[day]]["totalWorkedTime"]/workingTimesStats[days[day]]["count"];
            }
          });
          this.setLineCharts(workingTimesStats);
        });

    },
    setLineCharts(workingTimesStats) {

this.donutData = [
        { label: "Mon.", value: workingTimesStats["Mon."]["average"] },
        { label: "Tue.", value: workingTimesStats["Tue."]["average"] },
        { label: "Wed.", value: workingTimesStats["Wed."]["average"] },
        { label: "Thu.", value: workingTimesStats["Thu."]["average"] },
        { label: "Fri.", value: workingTimesStats["Fri."]["average"] },
      ];

    },
  }
}
</script>