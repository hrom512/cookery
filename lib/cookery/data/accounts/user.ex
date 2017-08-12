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

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :login, :password])
    |> validate_required([:name, :login, :password])
  end
end
