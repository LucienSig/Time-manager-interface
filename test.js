var axios = require('axios');

async function test_user() {
  const userConfigGet = {
    method: 'get',
    url: 'http://localhost:4000/api/users/1',
    headers: { }
  };
  const userResGet = {
    data: {
      email: "test@test.com",
      id: 1,
      is_active: false,
      username: "test"
    }
  }
  
  const userConfigPost = {
    method: 'post',
    url: 'http://localhost:4000/api/users/?email=test@test.com&username=test',
    headers: { }
  };
  const userResPost = {
    data: {
      email: "test@test.com",
      id:1,
      is_active:false,
      username:"test"
    }
  }
  
  const userConfigPut = {
    method: 'put',
    url: 'http://localhost:4000/api/users/1?email=updated@test.com&username=updated',
    headers: {}
  }
  const userResPut = {
    data: {
      email: "updated@test.com",
      id:1,
      is_active:false,
      username:"updated"
    }
  }
  
  const userConfigDel = {
    method: 'delete',
    url: "http://localhost:4000/api/users/1",
    headers: { }
  }
  const userResDel = {
    response: "deleted"
  }
  console.log("\n\n------- USER UNIT TESTS -------\n\n")
  console.log("------ TESTING POST ------")
  console.log("TRYING TO CREATE NEW USER")
  await axios(userConfigPost)
  .then(function (response) {
    if (JSON.stringify(response.data) != JSON.stringify(userResPost)) {
      console.log("ERROR")
      console.log("GOT :")
      console.log(JSON.stringify(response.data));
      console.log("BUT EXPECTED :");
      console.log(JSON.stringify(userResPost));
    }else {
      console.log("TEST OK")
      console.log("GOT : \n" + JSON.stringify(response.data))
    }
  })
  .catch(function (error) {
    console.log("ERROR\nGOT:\n" + JSON.stringify(error.response.data.errors))
  });

  console.log("\n------ TESTING GET ------")
  console.log("TRYING TO LIST USER")
  await axios(userConfigGet)
  .then(function (response) {
    if (JSON.stringify(response.data) != JSON.stringify(userResGet)) {
      console.log("ERROR")
      console.log("GOT :")
      console.log(JSON.stringify(response.data));
      console.log("BUT EXPECTED :");
      console.log(JSON.stringify(userResGet));
    } else {
      console.log("TEST OK")
      console.log("GOT : \n" + JSON.stringify(response.data))
    }
  })
  .catch(function (error) {
    if (error.response.data.error === "{'credentials': ['user not found']}" ) {console.log("ERROR \nNO USER WAS FOUND")}
    else {console.log(error)}
  });

  console.log("\n------ TESTING UPDATE ------")
  console.log("TRYING TO EDIT EXISTING USER")
  await axios(userConfigPut)
  .then(function (response) {
    if (response && (JSON.stringify(response.data) != JSON.stringify(userResPut))) {
      console.log("ERROR\nGOT:\n" + JSON.stringify(response.data));
      console.log("BUT EXPECTED:\n" + JSON.stringify(userResPut))
    } else {
      console.log("TEST OK\nGOT:\n" + JSON.stringify(response.data))
    }
  })
  .catch(function (error) {
    if (error.response && error.response.data.errors === "{'credentials': ['user not found']}") { console.log("ERROR\nNO USER WAS FOUND")}
    else {console.log(error)}
  })

  console.log("\n------ TESTING DELETE ------")
  console.log("TRYING TO DELETE USER")
  await axios(userConfigDel)
  .then(function (response) {
    if (response && (JSON.stringify(response.data) != JSON.stringify(userResDel))) {
      console.log("ERROR\nGOT:\n" + JSON.stringify(response.data));
      console.log("BUT EXPECTED:\n" + JSON.stringify(userResDel))
    } else {
      console.log("TEST OK\nGOT:\n" + JSON.stringify(response.data))
    }
  })
  .catch(function (error) {
    if (error.response && error.response.data.errors === "{'credentials': ['user not found']}") { console.log("ERROR\nNO USER WAS FOUND")}
    else {console.log(error)}
  })
  console.log("\n------- USER UNIT TEST OK -------\n\n")
}

async function test_working_times() {
  const userConfigPost = {
    method: 'post',
    url: 'http://localhost:4000/api/users/?email=test@test.com&username=test',
    headers: { }
  };
  const userResPost = {
    data: {
      email: "test@test.com",
      id:1,
      is_active:false,
      username:"test"
    }
  }

  const wtConfigPost = {
    method: "post",
    url: "http://localhost:4000/api/workingtimes/1?start=2000-01-01 23:00:07&end=2000-01-02 23:00:07", 
    headers: { }
  }
  const wtResPost = {
    success: "Created"
  }

  const wtConfigGet = {
    method: "get",
    url: "http://localhost:4000/api/workingtimes/1",
    headers: { }
  }
  const wtResGet = {
    data = {
      start = "2000-01-01 23:00:07",
      end = "2000-01-02 23:00:07",
      id: "1",
      user: "1"
    }
  }

  await axios(userConfigPost)
  .then(function (response) {
    if (JSON.stringify(response.data) != JSON.stringify(userResPost)) {
      console.log("ERROR")
      console.log("GOT :")
      console.log(JSON.stringify(response.data));
      console.log("BUT EXPECTED :");
      console.log(JSON.stringify(userResPost));
    }else {
      console.log("USER CREATED")
      console.log("GOT : \n" + JSON.stringify(response.data))
    }
  })
  .catch(function (error) {
    console.log("ERROR\nGOT:\n" + JSON.stringify(error.response.data.errors))
  });

  console.log("\n\n------- WORKING TIMES UNIT TESTS -------\n\n")
  console.log("------ CREATING WT ------")
  await axios(wtConfigPost)
  .then(function (response) {
    if (response && (JSON.stringify(response.data) != JSON.stringify(wtResPost))) {
      console.log("ERROR\nGOT:\n" + JSON.stringify(response.data));
      console.log("BUT EXPECTED:\n" + JSON.stringify(wtResPost))
    } else {
      console.log("TEST OK\nGOT:\n" + JSON.stringify(response.data))
    }
  })
  .catch(function (error) {
    if (error.response && error.response.data.errors === "{'credentials': ['user not found']}") { console.log("ERROR\nNO USER WAS FOUND")}
    else {console.log(error)}
  })
  console.log("------ GETTING WT ------")
  await axios(wtConfigGet)
  .then(function (response) {
    if (JSON.stringify(response.data) != JSON.stringify(wtResGet)) {
      console.log("ERROR")
      console.log("GOT :")
      console.log(JSON.stringify(response.data));
      console.log("BUT EXPECTED :");
      console.log(JSON.stringify(wtResGet));
    }else {
      console.log("USER CREATED")
      console.log("GOT : \n" + JSON.stringify(response.data))
    }
  })
  .catch(function (error) {
    console.log("ERROR\nGOT:\n" + JSON.stringify(error.response.data.errors))
  });
  console.log("\n------- WORKING TIMES UNIT TEST OK -------\n\n")
}

test_user()
test_working_times()