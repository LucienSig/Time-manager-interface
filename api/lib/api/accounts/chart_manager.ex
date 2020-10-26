defmodule Api.Accounts.ChartManager do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chartmanager" do
    field :bar, :boolean, default: false
    field :donut, :boolean, default: false
    field :line, :boolean, default: false
    field :user, :string

    timestamps()
  end

  @doc false
  def changeset(chart_manager, attrs) do
    chart_manager
    |> cast(attrs, [:user, :line, :bar, :donut])
    |> validate_required([:user, :line, :bar, :donut])
  end
end
