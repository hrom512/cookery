defmodule Cookery.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :path, {:array, :integer}, null: false, default: []
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:categories, [:path, :name])
  end
end
