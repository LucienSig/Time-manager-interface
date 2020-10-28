defmodule ApiWeb.LoginController do
  use ApiWeb, :controller

  alias Api.Accounts
  alias Api.Accounts.Login
  alias Api.Repo
  alias Api.Accounts.User
  import Ecto.Query

  action_fallback ApiWeb.FallbackController

  def login(conn, params) do
    where = [email: params["email"]]
    select = [:email, :password]
    query = from User, where: ^where, select: ^select

    user = Repo.one(query)
    if user do
      password = :crypto.hash(:sha256, params["password"])
      |>Base.encode16()
      |> String.downcase()
      if user.password == password do
        conn
        |> put_status(200)
        |> json(%{"success" => "connected"})
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
