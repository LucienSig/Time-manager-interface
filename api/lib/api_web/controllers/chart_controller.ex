defmodule ApiWeb.ChartController do
  use ApiWeb, :controller

  alias Api.Data
  alias Api.Data.Chart
  alias Api.Accounts.User
  import Ecto.Query
  alias Api.Repo

  action_fallback ApiWeb.FallbackController

  def index(conn, %{"userID" => id}) do
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
  end

  # def create(conn, %{"chart" => chart_params}) do
  #   with {:ok, %Chart{} = chart} <- Data.create_chart(chart_params) do
  #     conn
  #     |> put_status(:created)
  #     |> put_resp_header("location", Routes.chart_path(conn, :show, chart))
  #     |> render("show.json", chart: chart)
  #   end
  # end

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

  end

  def change(conn, %{"userID" => userID, "line" => line, "bar" => bar, "donut" => donut}) do
    where = [user_id: userID]
    select = [:line, :bar, :donut, :user_id, :id]
    query = from Chart, where: ^where, select: ^select

    user = Repo.one(query)
    chart = Repo.get(Chart, user.id)
    if chart do
      changeset = Chart.changeset(chart, %{"line" => line, "bar" => bar, "donut" => donut})
      case Repo.update(changeset) do
        {:ok, chart} ->
          conn
          |> put_status(200)
          |>json(%{"Response" => "Updated", "line" => line, "bar" => bar, "donut" => donut})
        {:error, result} ->
          conn
          |> put_status(404)
          |> json(%{"errors" => "{'credentials': ['chart not found']}"})
      end
    end
  end
end
