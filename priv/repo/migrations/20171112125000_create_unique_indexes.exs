defmodule Cookery.Repo.Migrations.CreateUniqueIndexes do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:login])
    create unique_index(:recipes, [:title, :user_id])
  end
end
