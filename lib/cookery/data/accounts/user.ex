defmodule Cookery.Data.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cookery.Data.Accounts.User


  schema "users" do
    field :login, :string
    field :name, :string
    field :password, :string

    timestamps()
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :login, :password])
    |> validate_required([:name, :login, :password])
    |> validate_changeset
  end

  def check_password(%User{} = user, password) do
    Comeonin.Bcrypt.checkpw(password, user.password)
  end


  defp validate_changeset(changeset) do
    changeset
    |> validate_length(:login, min: 4, max: 100)
    |> unique_constraint(:login)
    |> validate_length(:password, min: 6)
    |> generate_password_hash
  end

  defp generate_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end