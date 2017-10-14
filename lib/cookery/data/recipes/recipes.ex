defmodule Cookery.Data.Recipes do
  @moduledoc """
  The Data.Recipes context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Changeset
  alias Cookery.Repo
  alias Cookery.Data.Recipes.Recipe
  alias Cookery.Data.Recipes.Category
  alias Cookery.MaterializedPath

  # Recipes

  def list_recipes do
    Repo.all(Recipe)
  end

  def list_recipes_with_users do
    list_recipes()
    |> Repo.preload(:user)
  end

  def get_recipe!(id) do
    Repo.get!(Recipe, id)
  end

  def get_recipe_with_user_and_categories!(id) do
    id
    |> get_recipe!()
    |> Repo.preload(:user)
    |> Repo.preload(:categories)
  end

  def create_recipe(attrs, user) do
    attrs = Map.put(attrs, "user_id", user.id)
    %Recipe{}
    |> Recipe.changeset(attrs)
    |> Repo.insert()
  end

  def update_recipe(%Recipe{} = recipe, attrs) do
    recipe
    |> Recipe.changeset(attrs)
    |> Repo.update()
  end

  def update_recipe_categories(recipe, categories) do
    recipe
      |> Repo.preload(:categories)
      |> Changeset.change()
      |> Changeset.put_assoc(:categories, categories)
      |> Repo.update!()
  end

  def delete_recipe(%Recipe{} = recipe) do
    Repo.delete(recipe)
  end

  def change_recipe(%Recipe{} = recipe) do
    categories_ids = recipe.categories |> Enum.map(&(&1.id))

    recipe
    |> Map.put(:categories_ids, categories_ids)
    |> Recipe.changeset(%{})
  end

  # Categories

  def list_categories do
    Repo.all(Category)
  end

  def categories_tree do
    list_categories()
    |> MaterializedPath.arrange()
  end

  def get_category!(id) do
    Repo.get!(Category, id)
  end

  def get_category(nil), do: nil
  def get_category(id) do
    Repo.get(Category, id)
  end

  def get_categiries([]), do: []
  def get_categiries(ids) do
    from(c in Category, where: c.id in ^ids)
    |> Repo.all()
  end

  def create_category(attrs, parent \\ nil) do
    %Category{}
    |> Category.changeset(attrs)
    |> MaterializedPath.create(parent)
  end

  # Not updates parent
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  def update_category_parent(category, parent) do
    MaterializedPath.update_parent(category, parent)
  end

  def delete_category(%Category{} = category) do
    MaterializedPath.delete(category)
  end

  def change_category(%Category{} = category) do
    category
    |> Map.put(:parent_id, Category.parent_id(category))
    |> Category.changeset(%{})
  end
end
