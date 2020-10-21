defmodule ApiWeb.UserController do
  use ApiWeb, :controller

  alias Api.Accounts
  alias Api.Accounts.User
  alias Api.Repo

  action_fallback ApiWeb.FallbackController

  def index(conn,  %{"email" => email, "username" => username}) do
    user = Repo.get_by(User, [email: email, username: username])

    if user == nil do
      conn
      |> put_status(404)
      |> json(%{"errors" => "{'credentials': ['user not found']}"})
    else
      conn
      |> put_status(201)
      |> json(%{
        "email": user.email,
        "username": user.username
      })
    end
  end

  def create(conn, %{"email" => email, "username" => username}) do
    with {:ok, %User{} = user} <- Accounts.create_user(%{"email" => email, "username" => username}) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"userID" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"userID" => id, "email" => email, "username" => username}) do
    user = Repo.get(User, id)

    if user do
      with {:ok, %User{} = user} <- Accounts.update_user(user, %{"email" => email, "username" => username}) do
        render(conn, "show.json", user: user)
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
