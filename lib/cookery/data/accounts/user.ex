defmodule Cookery.Data.Accounts.User do
  use Cookery, :schema
  use Arc.Ecto.Schema

  alias Cookery.Data.Accounts.User
  alias Cookery.Data.Recipes.Recipe

  schema "users" do
    field :login, :string
    field :name, :string
    field :password, :string
    field :password_confirmation, :string, virtual: true
    field :avatar, Cookery.Avatar.Type
    has_many :recipes, Recipe

    timestamps()
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :login])
    |> cast_attachments(attrs, [:avatar])
    |> validate_required([:name, :login])
    |> validate_length(:login, min: 4, max: 100)
    |> unique_constraint(:login)
  end

  # with password and without avatar
  def create_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :login, :password])
    |> validate_required([:name, :login, :password])
    |> validate_length(:login, min: 4, max: 100)
    |> unique_constraint(:login)
    |> validate_length(:password, min: 6)
    |> generate_password_hash
  end

  def password_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> generate_password_hash
  end

  def check_password(%User{} = user, password) do
    Comeonin.Bcrypt.checkpw(password, user.password)
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
