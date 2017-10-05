defmodule Cookery.Data.Recipes.Category do
  use Cookery, :schema

  alias Cookery.Data.Recipes
  alias Cookery.Data.Recipes.Category
  alias Cookery.Data.Recipes.Recipe
  alias Cookery.MaterializedPath

  schema "categories" do
    field :name, :string
    field :path, {:array, :integer}, default: []
    field :parent_id, :integer, virtual: true
    many_to_many :recipes, Recipe, join_through: "recipes_categories"

    timestamps()
  end

  def parent_id(category) do
    MaterializedPath.parent_id(category)
  end

  def parent(category) do
    MaterializedPath.parent(category)
  end

  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name, name: :categories_path_name_index)
  end
end
