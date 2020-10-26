defmodule ApiWeb.ChartController do
  use ApiWeb, :controller

  alias Api.Data
  alias Api.Data.Chart

  action_fallback ApiWeb.FallbackController

  def index(conn, _params) do
    charts = Data.list_charts()
    render(conn, "index.json", charts: charts)
  end

  def create(conn, %{"chart" => chart_params}) do
    with {:ok, %Chart{} = chart} <- Data.create_chart(chart_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.chart_path(conn, :show, chart))
      |> render("show.json", chart: chart)
    end
  end

  def show(conn, %{"id" => id}) do
    chart = Data.get_chart!(id)
    render(conn, "show.json", chart: chart)
  end

  def update(conn, %{"id" => id, "chart" => chart_params}) do
    chart = Data.get_chart!(id)

    with {:ok, %Chart{} = chart} <- Data.update_chart(chart, chart_params) do
      render(conn, "show.json", chart: chart)
    end
  end
end
