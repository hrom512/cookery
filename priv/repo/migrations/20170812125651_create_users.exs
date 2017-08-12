defmodule Cookery.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :login, :string, null: false
      add :password, :string, null: false

      timestamps()
    end

  end
end
