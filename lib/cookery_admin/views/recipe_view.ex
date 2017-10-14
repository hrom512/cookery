defmodule CookeryAdmin.RecipeView do
  use CookeryAdmin, :view

  alias CookeryAdmin.CategoryView

  def recipe_categories(recipe) do
    recipe.categories
    |> Enum.map(&(&1.name))
    |> Enum.join(", ")
  end

  def categories_for_select do
    CategoryView.categories_for_select()
  end
end
