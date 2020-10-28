defmodule Api.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  schema "users" do
    field :email, :string
    field :is_active, :boolean, default: false
    field :username, :string
    field :password, :string
    field :password_full, :string, virtual: true
    field :role, :integer, default: 1
    field :team, :string

    timestamps()
  end

  @mail_regex ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :is_active, :role, :team, :password_full])
    |> validate_required([:email, :username, :is_active, :role, :password_full])
    |> validate_format(:email, @mail_regex)
    |> validate_length(:password_full, min: 8)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password_full: pass}}
        ->
          put_change(changeset, :password, hashpwsalt(pass))
      _ ->
          changeset
    end
  end
end
