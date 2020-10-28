defmodule ApiWeb.UserController do
  use ApiWeb, :controller

  alias Api.Accounts
  alias Api.Accounts.User
  alias Api.Repo

  action_fallback ApiWeb.FallbackController

  def index(conn,  %{"email" => email, "username" => username}) do
    user = Accounts.list_users(%{"email" => email, "username" => username})
    if user == nil do
      conn
      |> put_status(404)
      |> json(%{"errors" => "{'credentials': ['user not found']}"})
    else
      conn
      |> put_status(201)
      |> json(%{
        "email": user.email,
        "username": user.username,
        "role": user.role,
        "id": user.id
      })
    end
  end

  def create(conn, %{"email" => email, "username" => username, "password" => passwd, "role" => role, "team" => team}) do
    password = :crypto.hash(:sha256, passwd)
    |>Base.encode16()
    |> String.downcase()
    with {:ok, %User{} = user} <- Accounts.create_user( %{"email" => email, "username" => username, "password" => password, "role" => role, "team" => team}) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"userID" => id}) do
    if id != "all" do
      user = Accounts.get_user!(id)
      if user == nil do
        conn
        |> put_status(404)
        |> json(%{"error" => "{'credentials': ['user not found']}"})
      end
      render(conn, "show.json", user: user)
    else
      user = Repo.all(User)
      |> Enum.map(&%{email: &1.email, username: &1.username, id: &1.id, password: &1.password, role: &1.role, team: &1.team})
      if user == [] do
        conn
        |> put_status(404)
        |> json(%{"error" => "{'credentials': ['user not found']}"})
      end

      conn
      |>put_status(200)
      |> json(user)
    end
  end

  def update(conn, params) do
    user = Repo.get(User, params["userID"])

    if user do
      if params["password"] do
        Accounts.update_user(user, params)
        password = :crypto.hash(:sha256, params["password"])
        |> Base.encode16()
        |> String.downcase()
        with {:ok, %User{} = user} <- Accounts.update_user(user, %{"password" => password}) do
          conn
          |> put_status(200)
          |> json(%{"Success" => "Updated Password"})
        end
      else
        with {:ok, %User{} = user} <- Accounts.update_user(user, params) do
          render(conn, "show.json", user: user)
        end
      end
    else
      conn
      |> put_status(404)
      |> json(%{"errors" => "{'credentials': ['user not found']}"})
    end

  end

  def delete(conn, %{"userID" => id}) do
    user = Repo.get(User, id)

    if user do
      with {:ok, %User{}} <- Accounts.delete_user(user) do
        conn
        |> put_status(200)
        |> json(%{
          "response": "deleted"
        })
      end
    else
      conn
      |> put_status(404)
      |> json(%{"errors" => "{'credentials': ['user not found']}"})
    end
  end
end
