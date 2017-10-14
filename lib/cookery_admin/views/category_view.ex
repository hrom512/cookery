defmodule CookeryAdmin.CategoryView do
  use CookeryAdmin, :view

  alias Cookery.Data.Recipes

  def categories_for_select do
    Recipes.categories_tree()
    |> categories_list()
    |> List.insert_at(0, {"-", nil})
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
