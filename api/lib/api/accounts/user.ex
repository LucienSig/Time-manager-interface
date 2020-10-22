defmodule Api.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :is_active, :boolean, default: false
    field :username, :string

    timestamps()
  end

  @mail_regex ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :is_active])
    |> validate_required([:email, :username, :is_active])
    |> validate_format(:email, @mail_regex)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end
end
