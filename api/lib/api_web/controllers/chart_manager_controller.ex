defmodule ApiWeb.ChartManagerController do
  use ApiWeb, :controller

  alias Api.Accounts
  alias Api.Accounts.ChartManager

  action_fallback ApiWeb.FallbackController

  def index(conn, _params) do
    chartmanager = Accounts.list_chartmanager()
    render(conn, "index.json", chartmanager: chartmanager)
  end

  def create(conn, %{"chart_manager" => chart_manager_params}) do
    with {:ok, %ChartManager{} = chart_manager} <- Accounts.create_chart_manager(chart_manager_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.chart_manager_path(conn, :show, chart_manager))
      |> render("show.json", chart_manager: chart_manager)
    end
  end

  def show(conn, %{"id" => id}) do
    chart_manager = Accounts.get_chart_manager!(id)
    render(conn, "show.json", chart_manager: chart_manager)
  end

  def update(conn, %{"id" => id, "chart_manager" => chart_manager_params}) do
    chart_manager = Accounts.get_chart_manager!(id)

    with {:ok, %ChartManager{} = chart_manager} <- Accounts.update_chart_manager(chart_manager, chart_manager_params) do
      render(conn, "show.json", chart_manager: chart_manager)
    end
  end

  def delete(conn, %{"id" => id}) do
    chart_manager = Accounts.get_chart_manager!(id)

    with {:ok, %ChartManager{}} <- Accounts.delete_chart_manager(chart_manager) do
      send_resp(conn, :no_content, "")
    end
  end
end
