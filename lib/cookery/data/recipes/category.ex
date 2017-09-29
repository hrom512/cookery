defmodule Cookery.Data.Recipes.Category do
  use Cookery, :schema

  alias Cookery.Repo
  alias Cookery.Data.Recipes.Category

  schema "categories" do
    field :name, :string
    belongs_to :parent, Category

    timestamps()
  end

  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:parent_id, :name])
    |> validate_required([:name])
    |> unique_constraint(:name, name: :categories_parent_id_name_index)
  end
end
