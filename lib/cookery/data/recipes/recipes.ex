defmodule Cookery.Data.Recipes do
  @moduledoc """
  The Data.Recipes context.
  """

  import Ecto.Query, warn: false
  alias Cookery.Repo

  alias Cookery.Data.Recipes.Recipe
  alias Cookery.Data.Recipes.Category

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
    |> Category.arrange()
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
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
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
    category
    |> Category.changeset(attrs)
    |> Repo.update()
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
    Repo.delete(category)
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
