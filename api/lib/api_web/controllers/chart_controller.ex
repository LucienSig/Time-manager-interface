defmodule ApiWeb.ChartController do
  use ApiWeb, :controller

  alias Api.Data
  alias Api.Data.Chart
  alias Api.Accounts.User
  import Ecto.Query
  alias Api.Repo

  action_fallback ApiWeb.FallbackController

  def index(conn, %{"userID" => id}) do
    if System.get_env("token") != nil do
      if id != "all" do
        where = [id: id]
        select = [:id]
        query = from User, where: ^where, select: ^select

        user = Repo.one(query)

        if user == nil do
          conn
          |> put_status(404)
          |> json(%{"errors" => "{'credentials': ['user not found']}"})
        else
          charts = Data.list_charts(%{"userID" => id})
          render(conn, "index.json", charts: charts)
        end
      else
        chart = Repo.all(Chart)
        |> Enum.map(&%{line: &1.line, bar: &1.bar, id: &1.id, donut: &1.donut, user_id: &1.user_id})

        if chart == [] do
          conn
          |> put_status(404)
          |> json(%{"error" => "{'credentials': ['chart not found']}"})
        end

        conn
        |>put_status(200)
        |> json(chart)
      end
    else
      conn
      |> put_status(404)
      |> json(%{"error" => "{'credentials': ['you are not logged in'}]"})
    end
  end

  def create(conn, %{"userID" => id, "line" => line, "bar" => bar, "donut" => donut}) do
    user = Repo.get(User, id)

    if user do
      changeset =
        Chart.changeset(%Chart{}, %{"line" => line, "bar" => bar, "donut" => donut, "user_id" => id})

      case Repo.insert(changeset) do
        {:ok, _workingtimes} ->
          json(conn |> put_status(:created), %{success: "Created"})

        {:error, changeset} ->
          errors = "#{inspect(changeset.errors)}" |> String.replace("[", "(") |> String.replace("]", ")") |> String.replace("{", "[") |> String.replace("}", "]") |> String.replace("(", "{") |> String.replace(")", "}") |> String.replace(" :", " ")

          json(conn |> put_status(:bad_request), %{errors: errors})
      end
    else
      conn
      |> put_status(404)
      |> json(%{"errors" => "{'credentials': ['user not found']}"})
    end
  end

  def show(conn, %{"userID" => id, "chartID" => chartID}) do
    if System.get_env("token") != nil do
      where = [user_id: id, id: chartID]
      select = [:line, :bar, :donut, :user_id, :id]
      query = from Chart, where: ^where, select: ^select

      chart = Repo.one(query)

      if chart == nil do
        conn
        |> put_status(404)
        |> json(%{"errors" => "{'credentials': ['working times not found']}"})
      else
        chart = Data.get_chart!(%{"userID" => id, "chartID" => chartID})
        render(conn, "show.json", chart: chart)
      end
    else
      conn
      |> put_status(404)
      |> json(%{"error" => "{'credentials': ['you are not logged in'}]"})
    end
  end

  def change(conn, params) do
    where = [user_id: params["userID"]]
    select = [:line, :bar, :donut, :user_id, :id]
    query = from Chart, where: ^where, select: ^select

    user = Repo.one(query)
    chart = Repo.get(Chart, user.id)
    if chart do
      changeset = Chart.changeset(chart, params)
      case Repo.update(changeset) do
        {:ok, chart} ->
          conn
          |> put_status(200)
          |>json(%{"Response" => "Updated", "line" => params["line"], "bar" => params["bar"], "donut" => params["donut"]})
        {:error, result} ->
          conn
          |> put_status(404)
          |> json(%{"errors" => "{'credentials': ['chart not found']}"})
      end
    end
  end
end
