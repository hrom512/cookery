defmodule Cookery.Data.Recipes.Category do
  use Cookery, :schema

  use EctoMaterializedPath

  alias Cookery.Data.Recipes
  alias Cookery.Data.Recipes.Category
  alias Cookery.Data.Recipes.Recipe

  schema "categories" do
    field :name, :string
    field :path, EctoMaterializedPath.Path, default: []
    belongs_to :parent, Category
    many_to_many :recipes, Recipe, join_through: "recipes_categories"

    timestamps()
  end

  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:parent_id, :name])
    |> validate_required([:name])
    |> unique_constraint(:name, name: :categories_parent_id_name_index)
    |> set_materialized_path()
  end

  defp set_materialized_path(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{parent_id: parent_id}} ->
        parent = Recipes.get_category!(parent_id)
        EctoMaterializedPath.make_child_of(changeset, parent, :path)
      _ ->
        changeset
    end
  end
end
