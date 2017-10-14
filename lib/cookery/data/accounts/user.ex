defmodule Cookery.Data.Accounts.User do
  @moduledoc false

  use Cookery, :schema
  use Arc.Ecto.Schema

  alias Comeonin.Bcrypt
  alias Cookery.Data.Accounts.User
  alias Cookery.Data.Recipes.Recipe

  schema "users" do
    field :name, :string
    field :timezone, :string
    field :is_admin, :boolean, default: false
    field :login, :string
    field :password, :string
    field :password_confirmation, :string, virtual: true
    field :avatar, Cookery.Avatar.Type
    has_many :recipes, Recipe

    timestamps()
  end

  def admin_changeset(%User{} = user, attrs) do
    user
    |> create_changeset(attrs)
    |> cast(attrs, [:is_admin])
  end

  def create_changeset(%User{} = user, attrs) do
    user
    |> with_name_and_timezone(attrs)
    |> with_login(attrs)
    |> with_password(attrs)
  end

  def update_changeset(%User{} = user, attrs) do
    user
    |> with_name_and_timezone(attrs)
    |> with_login(attrs)
    |> cast_attachments(attrs, [:avatar])
  end

  def password_changeset(%User{} = user, attrs) do
    user
    |> with_password(attrs)
    |> validate_confirmation(:password)
  end

  def check_password(%User{} = user, password) do
    Bcrypt.checkpw(password, user.password)
  end

  defp with_name_and_timezone(changeset, attrs) do
    changeset
    |> cast(attrs, [:name, :timezone])
    |> validate_required([:name])
  end

  defp with_login(changeset, attrs) do
    changeset
    |> cast(attrs, [:login])
    |> validate_required([:login])
    |> validate_length(:login, min: 4, max: 100)
    |> unique_constraint(:login)
  end

  defp with_password(changeset, attrs) do
    changeset
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6)
    |> generate_password_hash
  end

  defp generate_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password, Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
