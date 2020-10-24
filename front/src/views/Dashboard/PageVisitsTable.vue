<template>
  <div class="card">
    <!-- Modal -->
    <div
      class="modal fade"
      id="editModal"
      tabindex="-1"
      role="dialog"
      aria-labelledby="editModal"
      aria-hidden="true"
    >
      <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="editModalLongTitle">Update employee</h5>
            <button
              type="button"
              class="close"
              data-dismiss="modal"
              aria-label="Close"
            >
              <span aria-hidden="true">&times;</span>
            </button>
            <div class="row mt-5 mr-3">
              <a class="btn btn-lg btn-danger" @click="deleteUser(user.id)"
                ><i class="fas fa-trash float-right text-white"></i
              ></a>
            </div>
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
              class="col col-12 col-xl-12 col-lg-12 col-md-12 col-sm-12 alert alert-success text-center"
              v-if="success != '' "
            >
              {{ success }}
            </div>
            <input
              class="form-control form-control-lg"
              placeholder="email"
              v-model="user.email"
            />
            <h5 class="modal-title mb-2 mt-3">Username</h5>
           <div
              class="col col-12 col-xl-12 col-lg-12 col-md-12 col-sm-12 d-none alert alert-danger text-center"
              :class="[errors.username != '' ? 'd-block' : '']"
            >
              <div v-for="error in errors.username" :key="error">
                {{ error }}
              </div>
            </div>
            <input
              class="form-control form-control-lg"
              placeholder="username"
              v-model="user.username"
            />
            
            
            <!-- Calendar -->
            <div class="col-md-12 mt-3">

              <div class="row w-100 mt-2 mb-0 p-0">
                <div class="text-white h3 text-center p-4 col-2 col-md-2">
                </div>
                <div class="bg-dark text-white mb-0 h3 text-center p-4 col-2 col-md-2">
                    Mon.
                </div>
                <div class="bg-dark text-white mb-0 h3 text-center p-4 col-2 col-md-2">
                    Tue.
                </div>
                <div class="bg-dark text-white mb-0 h3 text-center p-4 col-2 col-md-2">
                    Wed.
                </div>
                <div class="bg-dark text-white mb-0 h3 text-center p-4 col-2 col-md-2">
                    Thu.
                </div>
                <div class="bg-dark text-white mb-0 h3 text-center p-4 col-2 col-md-2">
                    Fri.
                </div>
              </div>
              <div class="row w-100" v-for="index in 10" :key="index">
                <div class="h3 text-center col-2 col-md-2 pt-2">
                  {{index + 8}} h
                </div>
                <div class="cells h-25 text-white border h3 text-center cursor-pointer p-4 col-2 col-md-2 mb-0" :data-hour="index+8" data-day="1" @click="selectedCell">
                </div>
                <div class="cells h-25 text-white border h3 text-center cursor-pointer p-4 col-2 col-md-2 mb-0" :data-hour="index+8" data-day="2" @click="selectedCell">
                </div>
                <div class="cells h-25 text-white border h3 text-center cursor-pointer p-4 col-2 col-md-2 mb-0" :data-hour="index+8" data-day="3" @click="selectedCell">
                </div>
                <div class="cells h-25 text-white border h3 text-center cursor-pointer p-4 col-2 col-md-2 mb-0" :data-hour="index+8" data-day="4" @click="selectedCell">
                </div>
                <div class="cells h-25 text-white border h3 text-center cursor-pointer p-4 col-2 col-md-2 mb-0" :data-hour="index+8" data-day="5" @click="selectedCell">
                </div>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-secondary"
              data-dismiss="modal"
            >
              Close
            </button>
            <button type="button" class="btn btn-primary" @click="editUser()">
              Save
            </button>
          </div>
        </div>
      </div>
    </div>

    <div class="card-header border-0">
      <div class="row align-items-center">
        <div class="col">
          <h3 class="mb-0">Employees</h3>
        </div>
        <div class="col text-right">
          <a href="#!" class="btn btn-lg btn-warning">Overview</a>
        </div>
      </div>
    </div>

    <div class="table-responsive">
      <base-table thead-classes="thead-light" :data="users">
        <template slot="columns">
          <th>Username</th>
          <th>Email</th>
          <th>Clock</th>
          <th>Edit</th>
        </template>

        <template slot-scope="{ row }">
          <th scope="row">
            <div class="mt-3">{{ row.username }}</div>
          </th>
          <td>
            <div class="mt-3">{{ row.email }}</div>
          </td>
          <td>
            <a class="btn btn-lg btn-success"
              @click="clock(row.id)"
              v-if="clocks[row.id]"
              ><i class="fas fa-user-check text-white"></i
            ></a>
            <a class="btn btn-lg btn-danger" v-else @click="clock(row.id)"
              ><i class="fas fa-user-times text-white"></i
            ></a>
          </td>
          <td>
            <a
              class="btn btn-lg btn-primary"
              data-toggle="modal"
              data-target="#editModal"
              @click="selectUser(row.id)"
              ><i class="fas fa-user-edit text-white"></i
            ></a>
          </td>
        </template>
      </base-table>
    </div>
  </div>
</template>
<script>
import axios from "axios";
import isValidDate from 'is-valid-date';
import moment from 'moment';

export default {
  name: "page-visits-table",
  data() {
    return {
      users: [],
      user: {},
      clocks: {},
      success: "",
      errors: {
        email: [],
        username: [],
      },
    };
  },
  mounted() {
    this.readAllUsers();
  },
  methods: {
    readAllUsers() {
      axios
        .get("http://localhost:4000/api/users/all")
        .then((response) => {
          this.users = response.data;
          this.users.forEach(element => {
            this.setUserClock(element.id);
          });
        })
        .catch((error) => {
          console.log(error);
        });
    },
    setUserClock (id) {
      axios.get("http://localhost:4000/api/clocks/" + id)
      .then((response) => {
        let clockLength = response.data.data.length;
        this.clocks[id] = response.data.data[clockLength -1].status;
      })
      .catch(() => {
        this.clocks[id] = false;
      })
    },
    selectUser(id) {
      this.success = "";
      this.clearErrorMessage();
      axios
        .get("http://localhost:4000/api/users/" + id)
        .then((response) => {
          this.user = response.data.data;
          this.getUserWorkingTimes();
        })
        .catch((error) => {
          console.log(error);
        });
    },
    clock(id) {
      axios.post("http://localhost:4000/api/clocks/" + id)
      .then((response) => {
        this.clocks[id] = response.data.status;
        this.readAllUsers();
      })
    },
    deleteUser(id) {
      axios
        .delete("http://localhost:4000/api/users/" + id)
        .then(() => {
          this.success = "User deleted";
        })
        .catch((error) => {
          console.log(error.response);
        });
    },
    selectedCell($event) {
      let isActive = $event.target.classList.contains('bg-success');
      
      if (!isActive) {
        // console.log('is not active');
        $event.target.classList.add('bg-success');
      } else {
        $event.target.classList.remove('bg-success');
      }

    },
    getUserWorkingTimes () {
        axios
        .get("http://localhost:4000/api/workingtimes/" + this.user.id)
        .then((response) => {
          let dates = response.data.data;
          dates.forEach(date => {
            let dateNow = new Date();
            let startTimeStamp = new Date(Date.parse(date.start));
            let getDay = new Date(Date.parse(date.start)).getDay();
            let hour = new Date(Date.parse(date.start)).getHours();

            let dayCell = document.querySelector('div[data-day="' +  String(getDay) + '"][data-hour="' +  String(hour) + '"]');

            if (dateNow < startTimeStamp) {
              dayCell.classList.add('bg-success');
            }

          });
        })
        .catch((error) => {
          console.log(error.response);
        });
    },
    createWorkingTimes(start, end) {

        let form = new FormData();
        
        form.append('start', start);
        form.append('end', end);

        axios
        .post("http://localhost:4000/api/workingtimes/" + this.user.id, form)
        .then((response) => {
          console.log(response.data)
        })
        .catch(error => {
          console.log(error)
        })
    },
    deleteWorkingTime (id) {
      axios
        .delete("http://localhost:4000/api/workingtimes/" + id)
        .then((response) => {
          console.log(response.data);
        })
        .catch((error) => {
          console.log(error);
        })
    },
    deleteWorkingTimes () {
        axios
        .get("http://localhost:4000/api/workingtimes/" + this.user.id)
        .then((response) => {
          let dates = response.data.data;
          dates.forEach(date => {
            let dateNow = new Date();
            let startTimeStamp = new Date(Date.parse(date.start));

            if (dateNow < startTimeStamp) {
              this.deleteWorkingTime(date.id);
            }

          });
        })
        .catch((error) => {
          console.log(error.response);
        });
    },
    saveWorkingTimes () {
      this.deleteWorkingTimes();
      let currentDate = new Date();
      let currentYear = currentDate.getFullYear();
      let currentMonth = currentDate.getMonth() + 1;
      
      for (let month = currentMonth; month <= 12; month++) {
        for (let date = 1; date <= 31; date++) {
          let fullDate = currentYear + "/" + month + "/" + date;
          let isValideDate = isValidDate(date + "/" + month + "/" + currentYear);
          let getDay = new Date(fullDate).getDay();

          if (isValideDate) {
            
            let allDataDay = document.querySelectorAll('div.bg-success[data-day="' +  String(getDay) + '"');
            if (allDataDay.length > 0) {
              let startHour = allDataDay[0].getAttribute('data-hour');
              let endHour = allDataDay[allDataDay.length - 1].getAttribute('data-hour');

              let start = moment(String(fullDate + " " + startHour +":00:00")).format("YYYY-MM-DD hh:mm:ss");
              let end = moment(String(fullDate + " " + endHour +":00:00")).format("YYYY-MM-DD hh:mm:ss");
              this.createWorkingTimes(start, end);

            }
            // is valid
          }
        }
      }


    },
    editUser() {

      let form = new FormData();

      form.append("email", this.user.email);
      form.append("username", this.user.username);

      axios
        .put("http://localhost:4000/api/users/" + this.user.id, form)
        .then((response) => {
          this.saveWorkingTimes();
          this.user = response.data.data;
          this.clearErrorMessage();
          this.success = "User created";
          this.readAllUsers();
        })
        .catch((error) => {
          this.clearErrorMessage();
          for (const key in error.response.data.errors) {
            this.errors[key] = error.response.data.errors[key];
          }
        });
    },
    clearErrorMessage() {
      this.success = "";
      for (const key in this.errors) {
        this.errors[key] = [""];
      }
    },
  },
};
</script>
<style>
  .cursor-pointer {
    cursor: pointer;
  }
</style>
