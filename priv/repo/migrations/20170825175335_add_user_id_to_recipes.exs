defmodule Cookery.Repo.Migrations.AddUserIdToRecipes do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      add :user_id, references(:users)
    end
    create index(:recipes, :user_id)
  end
end
