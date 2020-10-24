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

    <base-header type="gradient-primary" class="pb-6 pb-8 pt-5 pt-md-8">
      <div class="row">
        <div class="col-12">
          <a
            class="btn btn-lg btn-success text-white float-right mb-5"
            data-toggle="modal"
            data-target="#createModal"
            >Create user</a
          >
        </div>
      </div>
      <!-- Card stats -->
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
        <div class="col-xl-6 mb-5 mb-xl-0">
          <card type="default" header-classes="bg-transparent">
            <div slot="header" class="row align-items-center">
              <div class="col">
                <h6 class="text-light text-uppercase ls-1 mb-1">Overview</h6>
                <h5 class="h3 text-white mb-0">Working time average</h5>
              </div>
              <div class="col">
                <ul class="nav nav-pills justify-content-end">
                  <li class="nav-item mr-2 mr-md-0">
                    <a
                      class="nav-link py-2 px-3"
                      href="#"
                      :class="{ active: bigLineChart.activeIndex === 0 }"
                      @click.prevent="initBigChart(0)"
                    >
                      <span class="d-none d-md-block">Month</span>
                      <span class="d-md-none">M</span>
                    </a>
                  </li>
                  <li class="nav-item">
                    <a
                      class="nav-link py-2 px-3"
                      href="#"
                      :class="{ active: bigLineChart.activeIndex === 1 }"
                      @click.prevent="initBigChart(1)"
                    >
                      <span class="d-none d-md-block">Week</span>
                      <span class="d-md-none">W</span>
                    </a>
                  </li>
                </ul>
              </div>
            </div>
            <line-chart
              :height="350"
              ref="bigChart"
              :chart-data="bigLineChart.chartData"
              :extra-options="bigLineChart.extraOptions"
            >
            </line-chart>
          </card>
        </div>

        <div class="col-xl-3">
          <card header-classes="bg-transparent">
            <div slot="header" class="row align-items-center">
              <div class="col">
                <h6 class="text-uppercase text-muted ls-1 mb-1">Performance</h6>
                <h5 class="h3 mb-0">Clocking times</h5>
              </div>
            </div>

            <bar-chart
              :height="350"
              ref="barChart"
              :chart-data="redBarChart.chartData"
            >
            </bar-chart>
          </card>
        </div>

        <div class="col-xl-3">
          <card header-classes="bg-transparent">
            <div slot="header" class="row align-items-center">
              <div class="col">
                <h6 class="text-uppercase text-muted ls-1 mb-1">Performance</h6>
                <h5 class="h3 mb-0">Lateness average</h5>
              </div>
            </div>

            <bar-chart
              :height="350"
              ref="barChart"
              :chart-data="redBarChart.chartData"
            >
            </bar-chart>
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
import * as chartConfigs from "@/components/Charts/config";
import LineChart from "../components/Charts/LineChart.vue";
import BarChart from "@/components/Charts/BarChart";

// Tables
import PageVisitsTable from "./Dashboard/PageVisitsTable";

export default {
  components: {
    LineChart,
    BarChart,
    PageVisitsTable,
  },
  data() {
    return {
      bigLineChart: {
        allData: [
          [0, 20, 10, 30, 15, 40, 20, 60, 60],
          [0, 20, 5, 25, 10, 30, 15, 40, 40],
        ],
        activeIndex: 0,
        chartData: {
          datasets: [],
          labels: [],
        },
        extraOptions: chartConfigs.blueChartOptions,
      },
      redBarChart: {
        chartData: {
          labels: ["Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
          datasets: [
            {
              label: "Sales",
              data: [25, 20, 30, 22, 17, 29],
            },
          ],
        },
      },
      email: "",
      username: "",
      success: "",
      errors: {
        email: [],
        username: [],
      },
      totalUsers: "",
      workingTimesCount: "",
      workingTimesAverage: 0
    };
  },
  methods: {
    initBigChart(index) {
      let chartData = {
        datasets: [
          {
            label: "Performance",
            data: this.bigLineChart.allData[index],
          },
        ],
        labels: ["May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
      };
      this.bigLineChart.chartData = chartData;
      this.bigLineChart.activeIndex = index;
    },
    createUser() {
      let form = new FormData();

      form.append("email", this.email);
      form.append("username", this.username);

      axios
        .post("http://localhost:4000/api/users/", form)
        .then(() => {
          this.clearErrorMessage();
          this.success = "User created";

          setTimeout(() => {
            window.location.reload();
          }, 4000);
        })
        .catch((error) => {
          this.clearErrorMessage();
          for (const key in error.response.data.errors) {
            this.errors[key] = error.response.data.errors[key];
          }
        });
    },
    getAllUsers () {
        axios
        .get("http://localhost:4000/api/users/all")
        .then((response) => {
          this.totalUsers = response.data.length;
        })
    },
    getWorkingTimesAverage () {
        axios
        .get("http://localhost:4000/api/workingtimes/all")
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
        })
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
        }
      });

      this.workedTimeAverage = (workedTime/clockCount)/60;

    },
    getWorkedTimesAverage () {
        axios
        .get("http://localhost:4000/api/clocks/all")
        .then((response) => {
          console.log(response.data);
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
    this.initBigChart(0);
    this.getAllUsers();
    this.getWorkingTimesAverage();
    this.getWorkedTimesAverage();
  },
};
</script>
<style></style>
