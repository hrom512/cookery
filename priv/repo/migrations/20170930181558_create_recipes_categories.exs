defmodule Cookery.Repo.Migrations.CreateRecipesCategories do
  use Ecto.Migration

  def change do
    create table(:recipes_categories) do
      add :recipe_id, references(:recipes), null: false
      add :category_id, references(:categories), null: false
    end

    create unique_index(:recipes_categories, [:recipe_id, :category_id])
  end
end
