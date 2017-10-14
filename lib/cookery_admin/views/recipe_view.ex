defmodule CookeryAdmin.RecipeView do
  use CookeryAdmin, :view

  alias Cookery.Data.Recipes

  def recipe_categories(recipe) do
    recipe.categories
    |> Enum.map(&(&1.name))
    |> Enum.join(", ")
  end

  def categories_for_select do
    Recipes.categories_tree()
    |> categories_list()
  end

  defp categories_list(categories, level \\ 0) do
    categories
    |> Enum.map(
         fn({category, child_categories}) ->
           title = String.duplicate("- ", level) <> category.name
           child_items = categories_list(child_categories, level + 1)
           [{title, category.id} | child_items]
         end
       )
    |> Enum.concat()
  end
end
