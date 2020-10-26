defmodule ApiWeb.ChartManagerView do
  use ApiWeb, :view
  alias ApiWeb.ChartManagerView

  def render("index.json", %{chartmanager: chartmanager}) do
    %{data: render_many(chartmanager, ChartManagerView, "chart_manager.json")}
  end

  def render("show.json", %{chart_manager: chart_manager}) do
    %{data: render_one(chart_manager, ChartManagerView, "chart_manager.json")}
  end

  def render("chart_manager.json", %{chart_manager: chart_manager}) do
    %{id: chart_manager.id,
      user: chart_manager.user,
      line: chart_manager.line,
      bar: chart_manager.bar,
      donut: chart_manager.donut}
  end
end
