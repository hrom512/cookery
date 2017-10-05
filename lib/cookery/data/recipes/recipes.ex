defmodule Cookery.Data.Recipes do
  @moduledoc """
  The Data.Recipes context.
  """

  import Ecto.Query, warn: false
  alias Cookery.Repo

  alias Cookery.Data.Recipes.Recipe
  alias Cookery.Data.Recipes.Category
  alias Cookery.MaterializedPath

  @doc """
  Returns the list of recipes.

  ## Examples

      iex> list_recipes()
      [%Recipe{}, ...]

  """
  def list_recipes do
    Repo.all(Recipe)
  end

  def list_recipes_with_users do
    list_recipes()
    |> Repo.preload(:user)
  end

  def list_categories do
    Repo.all(Category)
  end

  def categories_tree do
    list_categories()
    |> MaterializedPath.arrange()
  end

  @doc """
  Gets a single recipe.

  Raises `Ecto.NoResultsError` if the Recipe does not exist.

  ## Examples

      iex> get_recipe!(123)
      %Recipe{}

      iex> get_recipe!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recipe!(id) do
    Repo.get!(Recipe, id)
  end

  def get_recipe_with_user!(id) do
    get_recipe!(id)
    |> Repo.preload(:user)
  end

  def get_category!(id) do
    Repo.get!(Category, id)
  end

  @doc """
  Creates a recipe.

  ## Examples

      iex> create_recipe(%{field: value})
      {:ok, %Recipe{}}

      iex> create_recipe(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recipe(attrs, user) do
    attrs = Map.put(attrs, "user_id", user.id)
    %Recipe{}
    |> Recipe.changeset(attrs)
    |> Repo.insert()
  end

  def create_category(attrs) do
    if attrs["parent_id"] && attrs["parent_id"] != "" do
      parent = get_category!(attrs["parent_id"])
    else
      parent = nil
    end
    %Category{}
    |> Category.changeset(attrs)
    |> MaterializedPath.create(parent)
  end

  @doc """
  Updates a recipe.

  ## Examples

      iex> update_recipe(recipe, %{field: new_value})
      {:ok, %Recipe{}}

      iex> update_recipe(recipe, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recipe(%Recipe{} = recipe, attrs) do
    recipe
    |> Recipe.changeset(attrs)
    |> Repo.update()
  end

  def update_category(%Category{} = category, attrs) do
    if attrs["parent_id"] do
      if attrs["parent_id"] == "" do
        parent_id = nil
        parent = nil
      else
        { parent_id, _ } = Integer.parse(attrs["parent_id"])
        parent = get_category!(parent_id)
      end
      if parent_id != Category.parent_id(category) do
        update_category_parent(category, parent)
      end
    end

    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  def update_category_parent(category, parent) do
    MaterializedPath.update_parent(category, parent)
  end

  def update_recipe_categories(recipe, categories) do
    recipe
      |> Repo.preload(:categories)
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_assoc(:categories, categories)
      |> Repo.update!()
  end

  @doc """
  Deletes a Recipe.

  ## Examples

      iex> delete_recipe(recipe)
      {:ok, %Recipe{}}

      iex> delete_recipe(recipe)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recipe(%Recipe{} = recipe) do
    Repo.delete(recipe)
  end

  def delete_category(%Category{} = category) do
    MaterializedPath.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipe changes.

  ## Examples

      iex> change_recipe(recipe)
      %Ecto.Changeset{source: %Recipe{}}

  """
  def change_recipe(%Recipe{} = recipe) do
    Recipe.changeset(recipe, %{})
  end

  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end
end
