defmodule ApiWeb.LoginController do
  use ApiWeb, :controller

  alias Api.Accounts
  alias Api.Accounts.Login
  alias Api.Repo
  alias Api.Accounts.User
  import Ecto.Query

  action_fallback ApiWeb.FallbackController
  def logout(conn, _params) do
    System.delete_env("token")
    conn
    |> put_status(200)
    |> json(%{"success" => "logged out"})
  end

  def login(conn, params) do
    where = [email: params["email"]]
    select = [:email, :password, :id, :role]
    query = from User, where: ^where, select: ^select

    user = Repo.one(query)
    if user do
      password = :crypto.hash(:sha256, params["password"])
      |>Base.encode16()
      |> String.downcase()
      if user.password == password do
        #Return JWT with userID + role + c-xsrf-token + 30 day expiry
        #get_csrf_token() for token
        if System.get_env("token") == nil do
          token = get_csrf_token()
          System.put_env("token", token)
          conn
          |> put_status(200)
          |> json(%{"token" => token, "user" => user.id, "role" => user.role})
        else
          conn
          |> put_status(200)
          |> json(%{"token" => System.get_env("token"), "user" => user.id, "role" => user.role})
        end
      else
        conn
        |> put_status(404)
        |> json(%{"errors" => "{'credentials': ['user not found']}"})
      end
    else
      conn
      |> put_status(404)
      |> json(%{"errors" => "{'credentials': ['user not found']}"})
    end
  end
end
