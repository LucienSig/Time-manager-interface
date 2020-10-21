defmodule Api.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :is_active, :boolean, default: false
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :is_active])
    |> validate_required([:email, :username, :is_active])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end
end
