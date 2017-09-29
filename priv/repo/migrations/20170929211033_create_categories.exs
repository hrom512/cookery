defmodule Cookery.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :parent_id, references(:categories)
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:categories, [:parent_id, :name])
  end
end
