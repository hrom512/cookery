defmodule Cookery.Repo.Migrations.AddMaterializedPathToCategories do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :path, {:array, :integer}, null: false, default: []
    end
  end
end
