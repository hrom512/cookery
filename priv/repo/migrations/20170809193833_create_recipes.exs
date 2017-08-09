defmodule Cookery.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add :title, :string, null: false
      add :description, :text

      timestamps()
    end

  end
end
