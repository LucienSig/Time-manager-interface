<template>
  <div>
    <!-- Modal -->
    <div
      class="modal fade"
      id="createModal"
      tabindex="-1"
      role="dialog"
      aria-labelledby="createModal"
      aria-hidden="true"
    >
      <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLongTitle">Add employee</h5>
            <button
              type="button"
              class="close"
              data-dismiss="modal"
              aria-label="Close"
            >
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <h5 class="modal-title mb-2 mt-3">Email</h5>
            <div
              class="col col-12 col-xl-12 col-lg-12 col-md-12 col-sm-12 d-none alert alert-danger text-center"
              :class="[errors.email != '' ? 'd-block' : '']"
            >
              <div v-for="error in errors.email" :key="error">
                {{ error }}
              </div>
            </div>
            <div
              class="col col-12 col-xl-12 col-lg-12 col-md-12 col-sm-12 d-none alert alert-success text-center"
              :class="[success != '' ? 'd-block' : '']"
            >
              {{ success }}
            </div>
            <input
              class="form-control form-control-lg"
              placeholder="email"
              v-model="email"
            />
            <h5 class="modal-title mb-2 mt-3">Username</h5>
            <div
              class="col col-12 col-xl-12 col-lg-12 col-md-12 col-sm-12 d-none alert alert-danger text-center"
              :class="[errors.username != '' ? 'd-block' : '']"
            >
              <div class v-for="error in errors.username" :key="error">
                {{ error }}
              </div>
            </div>
            <input
              class="form-control form-control-lg"
              placeholder="username"
              v-model="username"
            />
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-secondary"
              data-dismiss="modal"
            >
              Close
            </button>
            <button type="button" class="btn btn-primary" @click="createUser()">
              Create
            </button>
          </div>
        </div>
      </div>
    </div>

    <base-header type="gradient-primary" class="pb-6 pb-8 pt-md-4">
      <div class="row">
        <div class="col-12">
          <a
            class="btn btn-lg btn-success text-white float-right"
            data-toggle="modal"
            data-target="#createModal"
            >Create user</a
          >
        </div>
      </div>
      <!-- Card stats -->
      <div class="row d-flex justify-content-center mb-5">
        <vue-qrcode value="https://0.0.0.0:4000/" />
      </div>
      <div class="row">
        <div class="col-xl-4 col-lg-4">
          <stats-card
            title="Total employees"
            type="gradient-red"
            :sub-title="totalUsers"
            icon="ni ni-active-40"
            class="mb-4 mb-xl-0"
          >
            <template slot="footer">
              <span class="text-nowrap">Enterprise employee</span>
            </template>
          </stats-card>
        </div>
        <div class="col-xl-4 col-lg-4">
          <stats-card
            title="Working time average (contractual)"
            type="gradient-orange"
            :sub-title="workingTimesAverage.toFixed(2)"
            icon="ni ni-chart-pie-35"
            class="mb-4 mb-xl-0"
          >
            <template slot="footer">
              <span class="text-nowrap">Working time average scheduled</span>
            </template>
          </stats-card>
        </div>
        <div class="col-xl-4 col-lg-4">
          <stats-card
            title="Total worked time average"
            type="gradient-green"
            :sub-title="workedTimeAverage.toFixed(3)"
            icon="ni ni-money-coins"
            class="mb-4 mb-xl-0"
          >
            <template slot="footer">
              <span class="text-nowrap">Effectiv worked time average</span>
            </template>
          </stats-card>
        </div>
      </div>
    </base-header>

    <!--Charts-->
    <div class="container-fluid mt--7">
      <div class="row">
        <div class="col-xl-6 mb-5 mb-xl-0" v-if="this.charts.indexOf('line') != -1">
          <card type="default" header-classes="bg-transparent">
            <div slot="header" class="row align-items-center">
              <div class="col">
                <div style="position:absolute; right: 20px; font-size: 30px" class='text-danger' @click="removeChart('line')"><i class="fas fa-times"></i></div>
                <h6 class="text-light text-uppercase ls-1 mb-1">Overview</h6>
                <h5 class="h3 text-white mb-0">Working time average</h5>
              </div>
            </div>
            <line-chart
              :height="350"
            >
            </line-chart>
          </card>
        </div>
        <div class="col-xl-2 mb-5 mb-xl-0" v-else>
          <card type="default" header-classes="bg-transparent">
            <div slot="header" class="row align-items-center">
              <div class="col">
                <div style="position:absolute; right: 20px; font-size: 30px" class='text-success' @click="addChart('line')"><i class="fas fa-plus"></i></div>
                <h6 class="text-light text-uppercase ls-1 mb-1">Overview</h6>
                <h5 class="h5 text-white mb-0">Working time average</h5>
              </div>
            </div>
          </card>
        </div>


        <div class="col-xl-3" v-if="this.charts.indexOf('donut') != -1">
          <card header-classes="bg-transparent">
            <div slot="header" class="row align-items-center">
              <div class="col">
                <div style="position:absolute; right: 20px; font-size: 30px" class='text-danger' @click="removeChart('donut')"><i class="fas fa-times"></i></div>
                <h6 class="text-uppercase text-muted ls-1 mb-1">Performance</h6>
                <h5 class="h3 mb-0">Working times repartition</h5>
              </div>
            </div>
            <donut-chart>
            </donut-chart>
          </card>
        </div>
        <div class="col-xl-3" v-else>
          <card header-classes="bg-transparent">
            <div slot="header" class="row align-items-center">
              <div class="col">
                <div style="position:absolute; right: 20px; font-size: 30px" class='text-success' @click="addChart('donut')"><i class="fas fa-plus"></i></div>
                <h6 class="text-uppercase text-muted ls-1 mb-1">Performance</h6>
                <h5 class="h5 mb-0">Working times repartition</h5>
              </div>
            </div>
          </card>
        </div>

        <div class="col-xl-3" v-if="this.charts.indexOf('bar') != -1">
          <card header-classes="bg-transparent">
            <div slot="header" class="row align-items-center">
              <div class="col">
                <div style="position:absolute; right: 20px; font-size: 30px" class='text-danger' @click="removeChart('bar')"><i class="fas fa-times"></i></div>
                <h6 class="text-uppercase text-muted ls-1 mb-1">Performance</h6>
                <h5 class="h3 mb-0">Effectiv work time average</h5>
              </div>
            </div>

            <bar-chart>
            </bar-chart>
            
          </card>
        </div>
        <div class="col-xl-3" v-else>
          <card header-classes="bg-transparent">
            <div slot="header" class="row align-items-center">
              <div class="col">
                <div style="position:absolute; right: 20px; font-size: 30px" class='text-success' @click="addChart('bar')"><i class="fas fa-plus"></i></div>
                <h6 class="text-uppercase text-muted ls-1 mb-1">Performance</h6>
                <h5 class="h5 mb-0">Effectiv work time average</h5>
              </div>
            </div>
          </card>
        </div>
      </div>
      <!-- End charts-->

      <!--Tables-->
      <div class="row mt-5">
        <div class="col-xl-12 mb-5 mb-xl-0">
          <page-visits-table></page-visits-table>
        </div>
      </div>
      <!--End tables-->
    </div>
  </div>
</template>
<script>
import axios from "axios";

// Charts
import {EventBus} from "../store/event-bus";
import LineChart from "../components/Charts/LineChart.vue";
import DonutChart from "@/components/Charts/DonutChart.vue";
import BarChart from "@/components/Charts/BarChart.vue";

// Tables
import PageVisitsTable from "./Dashboard/PageVisitsTable";
import VueQrcode from 'vue-qrcode'


export default {
  components: {
    VueQrcode,
    LineChart,
    DonutChart,
    BarChart,
    PageVisitsTable,
  },
  data() {
    return {
      email: "",
      username: "",
      success: "",
      errors: {
        email: [],
        username: [],
      },
      totalUsers: "",
      workingTimesCount: "",
      workingTimesAverage: 0,
      workedTimeAverage: 0,
      charts: ['line', 'bar', 'donut']
    };
  },
  methods: {
    createUser() {
      let form = new FormData();

      form.append("email", this.email);
      form.append("username", this.username);

      axios
        .post("http://3.127.5.177:4000/api/users/", form)
        .then((response) => {
          this.clearErrorMessage();
          this.success = "User created";
          this.createChartManager(response.data.data.id);
        })
        .catch((error) => {
          this.clearErrorMessage();
          for (const key in error.response.data.errors) {
            this.errors[key] = error.response.data.errors[key];
          }
        });
    },
    getUserChart() {
      axios
        .get("http://3.127.5.177:4000/api/charts/" + this.userID)
        .then((response) => {
          this.charts = [];
          
          if (response.data.data[0]['bar']) {
            this.charts.push('bar')
          }

          if (response.data.data[0]['line']) {
            this.charts.push('line')
          }

          if (response.data.data[0]['donut']) {
            this.charts.push('donut')
          }

        })
        .catch((error) => {
          this.clearErrorMessage();
          for (const key in error.response.data.errors) {
            this.errors[key] = error.response.data.errors[key];
          }
        });
    },
    removeChart(name) {
      let index = this.charts.indexOf(name);
      this.charts.splice(index, 1);

      let charts = this.getAvailableCharts();

      axios.put("http://3.127.5.177:4000/api/charts/" + String(this.userID), charts)
      .then((response) => {
        console.log(response);
        this.getUserChart();
      })

      
    },
    getAvailableCharts () {
      let form = new FormData();
      if (this.charts.indexOf('donut')) {
        form.append('donut', 'true');
      } else {
        form.append('line', 'false');
      }

      if (this.charts.indexOf('line')) {
        form.append('line', 'true');
      } else {
        form.append('line', 'false');
      }

      if (this.charts.indexOf('bar')) {
        form.append('bar', 'true');
      } else {
        form.append('bar', 'false');
      }
      return form
    },

    addChart(name) {
      this.charts.push(name);
      let charts = this.getAvailableCharts();

      console.log(charts.getAll());

      axios.put("http://3.127.5.177:4000/api/charts/" + String(this.userID), charts)
      .then((response) => {
        console.log(response);
        this.getUserChart();
      })
    },
    createChartManager (userId) {
      let form = new FormData()
      form.append('donut', 'true');
      form.append('line', 'true');
      form.append('bar', 'true');
      form.append('userID', userId);

      axios.post("http://3.127.5.177:4000/api/charts", form)
      .then((response) => {
        console.log(response);
      })
    },
    getAllUsers () {
        axios
        .get("http://3.127.5.177:4000/api/users/all")
        .then((response) => {
          this.totalUsers = response.data.length;
        })
    },
    getWorkingTimesAverage () {
        axios
        .get("http://3.127.5.177:4000/api/workingtimes/all")
        .then((response) => {
          let workingTimesCount = response.data.length;
          let totalHour = 0;

          response.data.forEach(element => {
            let start = element["start"];
            let end = element["end"];

            start =  Date.parse(start);
            end = Date.parse(end);
            
            let dateDifference = new Date(Math.abs(start - end)).getHours();
            totalHour += dateDifference
          });

          this.workingTimesAverage = totalHour/workingTimesCount
        });
    },
    computeWorkedTimeAverage(days) {
      let start = "";
      let workedTime = 0;
      let clockCount = 0;

      days.forEach((element, index) => {
        if (index % 2 == 0) {
          start = element.time
        } else {
          let end = element.time
          start =  Date.parse(start);
          end = Date.parse(end);
          clockCount += 1;
          workedTime += new Date(Math.abs(start - end)).getMinutes();
          workedTime += new Date(Math.abs(start - end)).getHours() * 60;
        }
      });

      this.workedTimeAverage = (workedTime/clockCount)/60;

    },
    getWorkedTimesAverage () {
        axios
        .get("http://3.127.5.177:4000/api/clocks/all")
        .then((response) => {
          this.computeWorkedTimeAverage(response.data)
        })
    },
    clearErrorMessage() {
      this.success = "";
      for (const key in this.errors) {
        this.errors[key] = [""];
      }
    },
  },
  mounted() {
    EventBus.$on('userID', (userID) => {
      this.userID = userID;
      this.getUserChart();
    });
    this.getAllUsers();
    this.getWorkingTimesAverage();
    this.getWorkedTimesAverage();
  },
};
</script>
<style></style>
