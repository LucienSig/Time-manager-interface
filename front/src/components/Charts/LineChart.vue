
<template>
  <div id="app">
    <div class="container">
        
        <div class="col-12 panel panel-default">
          <div class="panel-body">
            
            <div class="col-12">
              <div v-if="lineData.length != 0">
                <line-chart
                  id="line"
                  :data="lineData"
                  xkey="year"
                  ykeys='[ "a", "b" ]'
                  resize="true"
                  labels='[ "Serie A", "Serie B" ]'
                  line-colors='[ "#FF6384", "#36A2EB" ]'
                  grid="true"
                  grid-text-weight="bold"
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
import Raphael from "raphael/raphael";
global.Raphael = Raphael;
import { LineChart } from "vue-morris";
export default {
  name: "app",
  data() {
    return {
      donutData: [
        { label: "Red", value: 300 },
        { label: "Blue", value: 50 },
        { label: "Yellow", value: 100 },
      ],
      barData: [
        { year: "2013", and: 10, ios: 5, win: 2 },
        { year: "2014", and: 10, ios: 15, win: 3 },
        { year: "2015", and: 20, ios: 25, win: 2 },
        { year: "2016", and: 30, ios: 20, win: 1 },
      ],
      lineData: [] /*[
        { year: '2013', a: 10, b: 5 },
        { year: '2014', a: 40, b: 15 },
        { year: '2015', a: 20, b: 25 },
        { year: '2016', a: 30, b: 20 },
      ],*/,
      areaData: [
        { year: "2013", a: 30, b: 5 },
        { year: "2014", a: 25, b: 15 },
        { year: "2015", a: 29, b: 25 },
        { year: "2016", a: 50, b: 20 },
      ],
      issue24Data: [
        {
          id: 8853,
          company_id: 58,
          location_id: null,
          followers: 203,
          date: "2019-08-04",
          created_at: null,
          updated_at: null,
          deleted_at: null,
        },
        {
          id: 8829,
          company_id: 58,
          location_id: null,
          followers: 203,
          date: "2019-08-03",
          created_at: null,
          updated_at: null,
          deleted_at: null,
        },
        {
          id: 8805,
          company_id: 58,
          location_id: null,
          followers: 202,
          date: "2019-08-02",
          created_at: null,
          updated_at: null,
          deleted_at: null,
        },
        {
          id: 8777,
          company_id: 58,
          location_id: null,
          followers: 200,
          date: "2019-08-01",
          created_at: null,
          updated_at: null,
          deleted_at: null,
        },
      ],
    };
  },
  components: {
    LineChart,
  },
  mounted() {
    setInterval(() => {
      this.lineData = [
        { year: "2013", a: this.rand(100), b: this.rand(100) },
        { year: "2014", a: this.rand(100), b: this.rand(100) },
        { year: "2015", a: this.rand(100), b: this.rand(100) },
        { year: "2016", a: this.rand(100), b: this.rand(100) },
      ];
    }, 5000);
  },
  computed: {
    prettyFloorMinFollowers() {
      return this.prettyFloor(this.yMinMax["min"]["followers"]);
    },
    prettyCeilMaxFollowers() {
      return this.prettyCeil(this.yMinMax["max"]["followers"]);
    },
    yMinMax() {
      return this.minMax(this.issue24Data, "followers");
    },
  },
  methods: {
    rand(limit) {
      return Math.round(Math.random() * limit);
    },
    osColors() {
      console.log("osColors");
      return [];
    },
    minMax(objects, field) {
      var result = {};
      return objects.reduce(function (valorAnterior, valorActual, indice) {
        if (indice == 1) {
          result["min"] = valorAnterior;
          result["max"] = valorAnterior;
        }
        valorActual[field] < result["min"][field]
          ? (result["min"] = valorActual)
          : "";
        valorActual[field] > result["max"][field]
          ? (result["max"] = valorActual)
          : "";
        return result;
      });
    },
    prettyFloor(number) {
      var l = Math.floor(Math.log10(Math.abs(number), 10)) - 1;
      if (l <= 0) {
        l++;
      }
      number = number / Math.pow(10, l);
      number = Math.floor(number);
      if (l > 0) {
        number = number * Math.pow(10, l);
      }
      return number;
    },
    prettyCeil(number) {
      var l = Math.floor(Math.log10(Math.abs(number), 10)) - 1;
      if (l <= 0) {
        l++;
      }
      number = number / Math.pow(10, l);
      number = Math.ceil(number);
      if (l > 0) {
        number = number * Math.pow(10, l);
      }
      return number;
    },
  },
};
</script>