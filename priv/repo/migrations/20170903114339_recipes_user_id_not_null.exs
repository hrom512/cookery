defmodule Cookery.Repo.Migrations.RecipesUserIdNotNull do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      modify :user_id, :integer, null: false
    end
  end
end
