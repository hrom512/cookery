defmodule CookeryAdmin.RecipeController do
  use CookeryAdmin, :controller

  alias Cookery.Data.Recipes
  alias Cookery.Data.Recipes.Recipe

  plug :load_and_authorize_resource, model: Recipe

  def index(conn, _params) do
    recipes = Recipes.list_recipes_with_users()
    render(conn, "index.html", recipes: recipes)
  end

  def new(conn, _params) do
    changeset = Recipes.change_recipe(%Recipe{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"recipe" => recipe_params}) do
    case Recipes.create_recipe(recipe_params, conn.assigns.current_user) do
      {:ok, recipe} ->
        update_recipe_categories(recipe, recipe_params)
        conn
        |> put_flash(:info, dgettext("admin.recipes", "Recipe created successfully."))
        |> redirect(to: recipe_path(conn, :show, recipe))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    recipe = Recipes.get_recipe_with_user_and_categories!(id)
    render(conn, "show.html", recipe: recipe)
  end

  def edit(conn, %{"id" => id}) do
    recipe = Recipes.get_recipe_with_user_and_categories!(id)
    changeset = Recipes.change_recipe(recipe)
    render(conn, "edit.html", recipe: recipe, changeset: changeset)
  end

  def update(conn, %{"id" => id, "recipe" => recipe_params}) do
    recipe = Recipes.get_recipe!(id)
    case Recipes.update_recipe(recipe, recipe_params) do
      {:ok, recipe} ->
        update_recipe_categories(recipe, recipe_params)
        conn
        |> put_flash(:info, dgettext("admin.recipes", "Recipe updated successfully."))
        |> redirect(to: recipe_path(conn, :show, recipe))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", recipe: recipe, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    recipe = Recipes.get_recipe!(id)
    {:ok, _recipe} = Recipes.delete_recipe(recipe)

    conn
    |> put_flash(:info, dgettext("admin.recipes", "Recipe deleted successfully."))
    |> redirect(to: recipe_path(conn, :index))
  end

  defp update_recipe_categories(recipe, recipe_params) do
    categories_ids = recipe_params["categories_ids"] || []
    categories = Recipes.get_categiries(categories_ids)
    Recipes.update_recipe_categories(recipe, categories)
  end
end
