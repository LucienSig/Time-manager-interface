
<template>
  <div id="app">
    <div class="container">
      <div class="col-12 panel panel-default">
        <div class="panel-body">
          <div class="col-12">
            <div v-if="lineData.length != 0" :key="lineChartKey">
              <line-chart
                id="line"
                :data="lineData"
                xkey="year"
                ykeys='[ "a" ]'
                resize="true"
                labels='[ "Serie A"]'
                line-colors='[ "#FF6384" ]'
                grid="true"
                grid-text-weight="bold"
                parse-time="false"
              >
              </line-chart>
            </div>
            <div v-else>No Data</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import Raphael from "raphael/raphael";
global.Raphael = Raphael;
import { LineChart } from "vue-morris";
import { EventBus } from "../../store/event-bus";


export default {
  name: "app",
  data() {
    return {
      lineData: [],
      lineChartKey: 0,
      userID: 'all',
      workingTimes: {
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
    };
  },
  components: {
    LineChart,
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

            day = new Date(start).getDay() - 1;
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
      this.lineData = [
        { year: "Mon.", a: workingTimesStats["Mon."]["average"], b: 0 },
        { year: "Tue.", a: workingTimesStats["Tue."]["average"], b: 0 },
        { year: "Wed.", a: workingTimesStats["Wed."]["average"], b: 0 },
        { year: "Thu.", a: workingTimesStats["Thu."]["average"], b: 0 },
        { year: "Fri.", a: workingTimesStats["Fri."]["average"], b: 0 },
      ];
    },
  },
};
</script>