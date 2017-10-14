defmodule CookeryAdmin.CategoryView do
  use CookeryAdmin, :view

  alias CookeryAdmin.RecipeView

  def categories_for_select do
    RecipeView.categories_for_select()
    |> List.insert_at(0, {"-", nil})
  end
end
