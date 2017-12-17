defmodule CookeryAdmin.CategoryController do
  use CookeryAdmin, :controller

  alias Cookery.Data.Recipes
  alias Cookery.Data.Recipes.Category

  plug :load_and_authorize_resource, model: Category
  plug :scrub_params, "category" when action in [:create, :update]

  def index(conn, _params) do
    categories = Recipes.categories_tree()
    render(conn, "index.html", categories: categories)
  end

  def new(conn, _params) do
    changeset = Recipes.change_category(%Category{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"category" => category_params}) do
    parent = Recipes.get_category(category_params["parent_id"])

    case Recipes.create_category(category_params, parent) do
      {:ok, _category} ->
        conn
        |> put_flash(:info, dgettext("admin.categories", "Category created successfully."))
        |> redirect(to: category_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    category = Recipes.get_category!(id)
    changeset = Recipes.change_category(category)
    render(conn, "edit.html", category: category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Recipes.get_category!(id)
    parent = Recipes.get_category(category_params["parent_id"])

    Recipes.update_category_parent(category, parent)

    case Recipes.update_category(category, category_params) do
      {:ok, _category} ->
        conn
        |> put_flash(:info, dgettext("admin.categories", "Category updated successfully."))
        |> redirect(to: category_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", category: category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Recipes.get_category!(id)
    Recipes.delete_category(category)

    conn
    |> put_flash(:info, dgettext("admin.categories", "Category deleted successfully."))
    |> redirect(to: category_path(conn, :index))
  end
end
