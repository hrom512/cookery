defmodule Cookery.Data.Accounts do
  @moduledoc """
  The Data.Accounts context.
  """

  import Ecto.Query, warn: false
  alias Cookery.Repo

  alias Cookery.Data.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  def create_admin(attrs \\ %{}) do
    %User{}
    |> User.admin_changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  def update_user_password(%User{} = user, attrs) do
    user
    |> User.password_changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.update_changeset(user, %{})
  end

  def change_user_password(%User{} = user) do
    User.password_changeset(user, %{})
  end

  def find_and_confirm_password(login, password) do
    case login && Repo.get_by(User, login: login) do
      nil ->
        {:error, :not_found}
      user ->
        if User.check_password(user, password) do
          {:ok, user}
        else
          {:error, :unauthorized}
        end
    end
  end
end
