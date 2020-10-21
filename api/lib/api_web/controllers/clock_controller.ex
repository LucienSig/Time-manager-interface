defmodule ApiWeb.ClockController do
  use ApiWeb, :controller

  alias Api.Time
  alias Api.Time.Clock
  alias Api.Repo
  alias Api.Accounts.User
  import Ecto.Query

  action_fallback ApiWeb.FallbackController

  def read(conn, %{"userID" => userID}) do
    if userID != "all" do
      clock = Repo.get_by(Clock, [user: userID])

      if clock == nil do
        conn
        |> put_status(404)
        |> json(%{"errors" => "{'credentials': ['clock not found']}"})
      else
        conn
        |> put_status(201)
        |> json(%{
          "time": clock.time,
          "status": clock.status,
          "user": clock.user
        })
      end

      conn
      |> put_status(401)
      |> json(%{"id" => userID})
    else
      clock = Repo.all(Clock)
      |> Enum.map(&%{time: &1.time, user: &1.user, status: &1.status})
      if clock == [] do
        conn
        |> put_status(404)
        |> json(%{"error" => "{'credentials': ['working time not found']}"})
      end

      conn
      |>put_status(200)
      |> json(clock)
    end
  end

  def create(conn, %{"userID" => userID}) do
    count = Repo.all(from u in "clocks", select: fragment("count(*)"))

    id = List.first(count)
    user_tmp = Repo.get_by(User, [id: userID])
    clock = Repo.get_by(Clock, [user: userID])

    if user_tmp do
      if clock do
        time = NaiveDateTime.utc_now()
        status = !clock.status

        changeset = Clock.changeset(clock, %{"time" => time, "status" => status, "user" => userID})
        case Repo.update(changeset) do
          {:ok, clock} ->
          conn
          |> put_status(200)
          |> json(%{"Reponse" => "Updated", "time" => time, "status" => status, "user" => userID})
          {:error, result} ->
          conn
          |> put_status(404)
          |> json(%{"errors" => "{'credentials': ['no user found']}"})
        end
      else
        status = true
        date = NaiveDateTime.utc_now()
        changeset = Clock.changeset(%Clock{}, %{"id" => id, "status" => status, "time" => date, "user" => userID})

        case Repo.insert(changeset) do
          {:ok, _user} ->
            json(conn |> put_status(:created), %{success: "Created"})

          {:error, changeset} ->
            errors = "#{inspect(changeset.errors)}" |> String.replace("[", "(") |> String.replace("]", ")") |> String.replace("{", "[") |> String.replace("}", "]") |> String.replace("(", "{") |> String.replace(")", "}") |> String.replace(" :", " ")

            json(conn |> put_status(:bad_request), %{errors: errors})
        end
      end
    else
      conn
      |> put_status(404)
      |> json(%{"errors" => "{'credentials': ['no user found']}"})
    end
  end

  def show(conn, %{"id" => id}) do
    clock = Time.get_clock!(id)
    render(conn, "show.json", clock: clock)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Time.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Time.update_clock(clock, clock_params) do
      render(conn, "show.json", clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Time.get_clock!(id)

    with {:ok, %Clock{}} <- Time.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
